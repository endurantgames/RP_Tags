local addOnName, ns = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("after MODULE_J",
function(self, event, ...)

  local oUF         = _G[GetAddOnMetadata(addOnName, "X-oUF")]; -- auto-added by oUF
  local CONST       = RPTAGS.CONST;
  local frameNames  = CONST.RPUF.FRAME_NAMES;
  local oUF_style   = CONST.RPUF.OUF_STYLE;

  if not RPTAGS.utils.config.get("DISABLE_BLIZZARD")
  then function oUF:DisableBlizzard() end; -- this prevents oUF from disabling oUF
  end;

  local hashLayoutSizes = { PLAYER = "large", TARGET = "large" };

  oUF:Factory(
    function(self)
      RPTAGS.cache.UnitFrames = RPTAGS.cache.UnitFrames or {};
      self:SetActiveStyle(oUF_style)
      for unit, frameName in pairs(frameNames)
      do  local u = unit:lower();
          local frame = self:Spawn(u, frameName);
          UnregisterUnitWatch(frame);
          -- frame:SetPoint("CENTER");
          RPTAGS.cache.UnitFrames[u] = _G[frameName];
          -- frame:Public("UpdateEverything");
          frame:SetFrameStrata("MEDIUM");
          frame:Public("SetLayoutSize", hashLayoutSizes[unit] or "small");
          RPTAGS.utils.frames.scale(frame);
      end;
    end);

  local EventsFrame = CreateFrame("Frame");
  EventsFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
  EventsFrame:SetScript("OnEvent",
    function(self, event, isLogin, isReload)
      -- this makes sure everything gets properly applied to our unitframes
      -- i.e., applying fonts once they're loaded
      if isLogin or isReload
      then for frameName, frame in pairs(RPTAGS.cache.UnitFrames)
           do  RPTAGS.utils.frames.RPUF_Refresh("all", "everything");
           end;
      end;
    end);
end);

Module:WaitUntil("MODULE_E",
function(self, event, ...)

  local Config = RPTAGS.utils.config;
  local Get    = Config.get;

  local function scale_of(frame) return Get( frame.unit:upper() .. "FRAME_SCALE"); end;

  local function scaleFrame(frame)

    if   type(frame) == "string"
    then frame = RPTAGS.cache.UnitFrames[ frame:lower() ];
    end;

    if frame then frame:SetScale( scale_of(frame)); end

  end;

  local function scaleAllFrames()

    for frameName, frame in pairs(RPTAGS.cache.UnitFrames)
    do  frame:SetScale( scale_of(frameName) );
    end;

  end;

  RPTAGS.utils.frames.scaleAll = scaleAllFrames;
  RPTAGS.utils.frames.scale    = scaleFrame;

end);

Module:WaitUntil("before MODULE_F",
function(self, event, ...)

  RPTAGS.cache.layouts          = RPTAGS.cache.layouts          or {};
  RPTAGS.cache.layouts.known    = RPTAGS.cache.layouts.known    or {};
  RPTAGS.cache.layouts.by_size  = RPTAGS.cache.layouts.by_size  or {};
  RPTAGS.cache.layouts.defaults = RPTAGS.cache.layouts.defaults or {};

  local loc = RPTAGS.utils.locale.loc;

  local function RPUF_GetLayout(layoutName) 
    return RPTAGS.cache.layouts.known[layoutName:lower()]; 
  end;

  local function RPUF_RegisterLayout(layoutName, layout)
    local layoutCache = RPTAGS.cache.layouts;

    if   layoutCache.known[layoutName] 
    then return error("This layout is already registered: " .. layoutName); 
    end;
    
    local required_panel_methods =
    { "GetPanelLeft", "GetPanelTop", "GetPanelHeight", "GetPanelWidth",
      "GetPanelJustifyH", "GetPanelJustifyV", "GetPanelVis" };

    local required_frame_methods = 
    { "GetFrameDimensions" };

    local missing_panel_methods = {};
    local missing_frame_methods = {};

    for _, method in ipairs(required_panel_methods)
    do  if   not layout.panel_methods[method] and
             not layout.panel_method_hash[method]
        then table.insert(missing_panel_methods, method)
        end;
    end;

    for _, method in ipairs(required_frame_methods)
    do  if   not layout.frame_methods[method]
        then table.insert(missing_frame_methods, method)
        end;
    end;

    if   #missing_panel_methods + #missing_frame_methods == 0
    then layoutCache.known[layoutName] = layout;
         layoutCache.by_size[layout.size] = layoutCache.by_size[layout.size] or {};
         table.insert(layoutCache.by_size[layout.size], layoutName);
    else print("Error: layout " .. layoutName .. "  is incomplete")
         for _, method in ipairs(missing_panel_methods)
         do print(" - Missing required panel method " .. method)
         end;
         for _, method in ipairs(missing_frame_methods)
         do print(" - Missing required frame method " .. method)
         end;
         print("The layout has not been loaded.");
    end;

  end;

  local function RPUF_SetMoverOffset(self, moverName, offset)
    self.offset[moverName] = offset;
  end;

  local function RPUF_GetMoverOffset(self, frame, moverName)
    local offset = self.offset[moverName];
    if type(offset) == "function" then return offset(frame) 
    elseif type(offset) == "table" then return unpack(offset) 
    else return 0, 0
    end;
  end;

  local function RPUF_RegisterAsDefault(self)
    if   self.size
    then RPTAGS.cache.layouts.defaults[self.size] = self.name;
    else print("Could not register as default");
    end;
  end;

  local function RPUF_NewLayout(layoutName, layoutSize, layoutVersion)

    return 
    { name                       = loc("RPUF_" .. layoutName:upper()),
      key                        = layoutName,
      panel_methods              = {},
      frame_methods              = {},
      panel_method_hash          = {},
      offset                     = {},
      size                       = layoutSize,
      version                    = layoutVersion or GetAddOnMetadata(addOnName, "Version"),
      GetLayoutSize              = function(self) return self.size end,
      Register_Panel_Method_Hash = function(self, hashName, hashTable) self.panel_method_hash[hashName] = hashTable; end,
      Register_Panel_Method      = function(self, funcName, func)      self.panel_methods[funcName]     = func;      end,
      Register_Frame_Method      = function(self, funcName, func)      self.frame_methods[funcName]     = func;      end,
      RegisterLayout             = function(self)                      RPUF_RegisterLayout(layoutName, self)         end,
      RegisterAsDefault          = function(self)                      RPUF_RegisterAsDefault(self)                  end,
      SetMoverOffset             = RPUF_SetMoverOffset,
      GetMoverOffset             = RPUF_GetMoverOffset,
    };

  end;

  local frameList =    -- uppercase name, isSmallFrame
  { { "PLAYER",        false },
    { "TARGET",        false },
    { "FOCUS",         true  },
    { "TARGETTARGET",  true  }, 
  };

  local refreshFuncs =
  { framesize        = "UpdateFrameSize",
    layout           = "UpdateLayout",
    fonts            = "UpdateFont",
    textcolor        = "UpdateTextColor",
    tags             = "UpdateTagStrings",
    hiding           = "UpdateFrameVisibility",
    lock             = "UpdateFrameLock",
    statusbar        = "UpdateStatusBar",
    style            = "UpdateFrameAppearance",
    location         = "ResetCoords",
    vis              = "UpdatePanelVisibility",
    sizes            = "UpdatePanelPlacement",
    backdrop         = "UpdateFrameApparance",
    content          = "UpdateContent",
    portrait         = "UpdatePortrait",
    everything       = "UpdateEverything",
    movers           = "UpdateMover",
    unitcolors       = "UpdateUnitColors",
  };

  local function RPUF_Refresh(frameName, ...)

    local function helper(funcName, frame) -- takes a name of a method (from the list above)
      if frame:HasPublicFunction(funcName)
      then frame:Public(funcName);
      end;
    end;

    for _, param in ipairs({ ... })
    do  local what = refreshFuncs[param:lower()];
        if    what
        then  local  ufCache = RPTAGS.cache.UnitFrames;
              if     (not frameName) or (frameName:lower() == "all")
              then   for name, frame in pairs(ufCache) do helper(what, frame); end;
              elseif ufCache[frameName:lower()]
              then   helper(what, ufCache[frameName:lower()]);
              end;
        end
    end;
  end;

  local function RPUF_EnableOrDisableBlizzard()
    local blizzFrames = { player = PlayerFrame, target = TargetFrame, focus = FocusFrame, targetTarget = TargetTargetFrame };
    for _, frame in pairs(blizzFrames) 
    do  if RPTAGS.utils.config.get("DISABLE_BLIZZARD") then UnregisterUnitWatch(frame); else RegisterUnitWatch(frame) end; end;
  end;

  local function RPUF_LayoutHashTable(layoutSize)
    local layoutCache = RPTAGS.cache.layouts;
    local hashTable = {};

    if   not layoutSize or layoutSize == "large"
    then for layoutName, _ in pairs(layoutCache.known)
         do  hashTable[layoutName:upper()] = loc("RPUF_" .. layoutName:upper());
         end;
    elseif layoutCache.by_size[layoutSize] 
    then for _, layoutName in ipairs(layoutCache.by_size[layoutSize])
         do hashTable[layoutName:upper()] = loc("RPUF_" .. layoutName:upper());
         end;
    end;
    return hashTable;
  end;

  local function RPUF_GetDefaultLayout(size)
    size = size or "small";
    local layoutCache = RPTAGS.cache.layouts;
    return layoutCache.defaults[size] or error("No default for size " .. size or type(size));
  end;

  RPTAGS.utils.frames.RPUF_Refresh                 = RPUF_Refresh;
  RPTAGS.utils.frames.RPUF_RegisterLayout          = RPUF_RegisterLayout;
  RPTAGS.utils.frames.RPUF_GetLayout               = RPUF_GetLayout;
  RPTAGS.utils.frames.RPUF_GetDefaultLayout        = RPUF_GetDefaultLayout;
  RPTAGS.utils.frames.RPUF_NewLayout               = RPUF_NewLayout;
  RPTAGS.utils.frames.RPUF_EnableOrDisableBlizzard = RPUF_EnableOrDisableBlizzard;
  RPTAGS.utils.frames.RPUF_LayoutHashTable         = RPUF_LayoutHashTable;

end);


