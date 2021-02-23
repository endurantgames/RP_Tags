local addOnName, ns = ...;
local RPTAGS        = RPTAGS;
local Module        = RPTAGS.queue:GetModule(addOnName);

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
  };

  local function refresh(frameName, ...)

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

end);
