local addOnName, ns = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("after MODULE_J",
function(self, event, ...)

  local oUF         = _G[GetAddOnMetadata(addOnName, "X-oUF")]; -- auto-added by oUF
  local CONST       = RPTAGS.CONST;
  local frameNames  = CONST.RPUF.FRAMES.NAMES;
  local oUF_style   = CONST.RPUF.OUF_STYLE;

  function oUF:DisableBlizzard() end; -- this prevents oUF from disabling oUF

  oUF:Factory(
    function(self)
      RPTAGS.cache.UnitFrames = RPTAGS.cache.UnitFrames or {};
      self:SetActiveStyle(oUF_style)
      for unit, frameName in pairs(frameNames)
      do  local u = unit:lower();
          local frame = self:Spawn(u, frameName);
          frame:SetPoint("CENTER");
          RPTAGS.cache.UnitFrames[u] = _G[frameName];
          frame:UpdateEverything();
          frame:SetFrameStrata("MEDIUM");
          RPTAGS.utils.frames.scale(frame);
      end;
    end);

end);

Module:WaitUntil("MODULE_E",
function(self, event, ...)

  local Config = RPTAGS.utils.config;
  local Get    = Config.get;

  local function scale_of(frameName) return Get( frameName:upper() .. "FRAME_SCALE"); end;

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

Module:WaitUntil("before MODULE_G",
function(self, event, ...)

  RPTAGS.cache.layouts         = RPTAGS.cache.layouts         or {};
  RPTAGS.cache.layouts.known   = RPTAGS.cache.layouts.known   or {}
  RPTAGS.cache.layouts.by_size = RPTAGS.cache.layouts.by_size or {};

  local function RPUF_GetLayout(layoutName) 
    return RPTAGS.cache.layouts.known[layoutName]; 
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
    then layoutsCache.known[layoutName] = layout;
         layoutsCache.by_size[layout.size] = layoutsCache.by_size[layout.size] or {};
         table.insert(layoutsCache.by_size[layout.size], layoutName);
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

  local function RPUF_NewLayout(layoutName, layoutSize, layoutVersion)

    return 
    { name                       = loc("LAYOUT_" .. layoutName:upper()),
      key                        = layoutName,
      panel_methods              = {},
      frame_methods              = {},
      panel_method_hash          = {},
      size                       = layoutSize,
      version                    = layoutVersion or GetAddOnMetadata(addOnName, "Version"),
      Register_Panel_Method      = function(self, hashName, hashTable) self.panel_method_hash[hashName] = hashTable; end,
      Register_Panel_Method_Hash = function(self, hashName, func)      self.panel_methods[hash] = func;              end,
      Register_Frame_Method      = function(self, func)                self.frame_methods[hash] = func;              end,
      RegisterLayout             = function(self)                      RPUF_RegisterLayout(layoutName, self)         end,
    };

  end;

  local frameList =    -- uppercase name, isSmallFrame
  { { "PLAYER",        false },
    { "TARGET",        false },
    { "FOCUS",         true  },
    { "TARGETTARGET",  true  }, 
  };

  local refreshFuncs =
  { framesize        = "SetUF_Size",
    layout           = "PlacePanels",
    fonts            = "SetFont",
    textcolor        = "SetTextColor",
    tags             = "SetTagStrings",
    hiding           = "Start_SSD",
    lock             = "ApplyFrameLock",
    statusbar        = "StyleStatusBar",
    style            = "StyleFrame",
    location         = "SetCoords",
    vis              = "SetPanelVis",
    sizes            = "PlacePanels",
    backdrop         = "StyleFrame",
    content          = "RefreshContentNow",
    portrait         = "UpdatePortrait",
  };

  local function RPUF_Refresh(frameName, ...)

    local function helper(funcName, frame) -- takes a name of a method (from the list above)
      local func = frame[funcName];        -- and a frame, and calls the func if possible
      if func and type(func) == "function" then func(frame) end;
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

  RPTAGS.utils.frames.RPUF_Refresh        = RPUF_Refresh;
  RPTAGS.utils.frames.RPUF_RegisterLayout = RPUF_RegisterLayout;
  RPTAGS.utils.frames.RPUF_GetLayout      = RPUF_GetLayout;
  RPTAGS.utils.frames.RPUF_NewLayout      = RPUF_NewLayout;

end);

