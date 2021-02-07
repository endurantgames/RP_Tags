local addOnName, addOn = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("before DATA_OPTIONS",
function(self, event, ...)
  local RPTAGS = RPTAGS;

  local Config = RPTAGS.utils.config;
  local function requiresRPUF() return Config.get("DISABLE_RPUF"); end;
  
  local loc = RPTAGS.utils.locale.loc;
  local addOptions        = RPTAGS.utils.modules.addOptions
  local source_order      = RPTAGS.utils.options.order
  local Common            = RPTAGS.utils.options.common
  local Pushbutton        = RPTAGS.utils.options.pushbutton

  local function build_frame_scaler(str, hidden, disabled)
    local w    = Common("range", "CONFIG_", str .. "frame scale", hidden, disabled, true, true);
    w.min      = 0.25;
    w.max      = 2;
    w.step     = 0.05;
    w.disabled = requiresRPUF;
    return w;
  end;

  local function build_dimensions_slider(str, min, max, step, hidden, disabled)
    local w    = Common("range", "CONFIG_", str, hidden, disabled, true);
    w.min      = min or 0;
    w.max      = max or 100;
    w.step     = step or 1;
    w.disabled = requiresRPUF;
    w.set      = function(info, value) Config.set(str, value); resizeAll(); end;
    return w;
  end;

  local function build_tagpanel(str, ttstr, hidden, disabled)
    local str = str:upper():gsub("%s", "_");
    local w    = 
    { type = "group",
      name     = loc("CONFIG_" .. str);
      args     = 
      { panel   = Pushbutton(str, function() openEditor(str) end, hidden, requiresRPUF),
        tooltip = Pushbutton(ttstr, function() openEditor(ttstr) end, hidden, requiresRPUF),
      };
    };
    return w;
  end;

  RPTAGS.utils.options.frame_scaler = build_frame_scaler;
  RPTAGS.utils.options.dimensions_slider = build_dimensions_slider;
  RPTAGS.utils.options.tagpanel = build_tagpanel;
  RPTAGS.utils.options.requiresRPUF = requiresRPUF;

end);
