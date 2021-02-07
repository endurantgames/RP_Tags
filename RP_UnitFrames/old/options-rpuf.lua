local function build_frame_scaler(str, hidden, disabled)
      local w    = build_common("range", "CONFIG_", str .. "frame scale", hidden, disabled, true, true);
      w.min      = 0.25;
      w.max      = 2;
      w.step     = 0.05;
      return w;
end;
local function build_dimensions_slider(str, min, max, step, hidden, disabled)
      local w    = build_common("range", "CONFIG_", str, hidden, disabled, true);
      w.min      = min or 0;
      w.max      = max or 100;
      w.step     = step or 1;
      w.set      = function(info, value) Config.set(str, value); resizeAll(); end;
      return w;
end;

local function build_tagpanel(str, ttstr, hidden, disabled)
      local str = str:upper():gsub("%s", "_");
      local w    = 
      { type = "group",
        name     = loc("CONFIG_" .. str);
        args     = 
        { panel   = build_pushbutton(str,   function() openEditor(str)   end, hidden, disabled),
          tooltip = build_pushbutton(ttstr, function() openEditor(ttstr) end, hidden, disabled),
        };
      };
      return w;
end;

