-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) 

local addOnName, addOn = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("after MODULE_J",
function(self, event, ...)

  local oUF         = _G[GetAddOnMetadata(addOnName, "X-oUF")]; -- auto-added by oUF
  local CONST       = RPTAGS.CONST;
  local FRAME_NAMES = CONST.FRAMES.NAMES;
  local oUF_style   = CONST.RPUF.OUF_STYLE;

  function oUF:DisableBlizzard() end; -- this prevents oUF from disabling oUF

  oUF:Factory(
    function(self)
      RPTAGS.cache.UnitFrames = RPTAGS.cache.UnitFrames or {};
      self:SetActiveStyle(oUF_style)
      for unit, frameName in pairs(CONST.FRAMES.NAMES)
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

Module:WaitUntil("before MODULE_G",
function(self, event, ...)

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

  RPTAGS.utils = RPTAGS.utils or {};
  RPTAGS.utils.frames = RPTAGS.utils.frames or {};
  RPTAGS.utils.frames.RPUF_Refresh = RPUF_Refresh;

end);

