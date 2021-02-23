local addOnName, ns = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("MODULE_G",
function(self, event, ...)

  local loc             = RPTAGS.utils.locale.loc;
  local CONST           = RPTAGS.CONST;
  local Get             = RPTAGS.utils.config.get;
  local Set             = RPTAGS.utils.config.set;
  local Default         = RPTAGS.utils.config.default;
  local addOptions      = RPTAGS.utils.modules.addOptions;
  local addOptionsPanel = RPTAGS.utils.modules.addOptionsPanel;
  local source_order    = RPTAGS.utils.options.source_order;
  local Color_Picker    = RPTAGS.utils.options.color_picker
  local Spacer          = RPTAGS.utils.options.spacer
  local toHex           = RPTAGS.utils.color.decimalsToColor;

  local function build_frame_colors(unit)
    local ufCache = RPTAGS.cache.UnitFrames;

    local function helper_have_unit(color, unit, methodName)
      local colorSetting = color .. "_" .. unit:upper();
      local picker = Color_Picker(colorSetting);
      picker.set = 
        function(info, r, g, b, a)
          local ufCache = RPTAGS.cache.UnitFrames;
          Set("COLOR_" .. colorSetting , toHex(r, g, b));
          if   methodName 
          then local frame = ufCache[unit];
               local method = frame[methodName];
               if method then method(frame); end;
          end;
        end;
      return picker;
    end;

    function helper_no_unit(color, methodName)
      local picker = Color_Picker(color);
      picker.set =
        function(info, r, g, b, a)
          local ufCache = RPTAGS.cache.UnitFrames;
          Set("COLOR_" .. color, toHex(r, g, b));
          if   methodName 
          then for frameName, frame in pairs(ufCache)
               do local method = frame[methodName];
                  if    method then method(frame); end;
               end;
          end;
        end;
      return picker;
    end;

    local frame_group =
    { type = "group",
      name =  loc(unit and (unit:upper() .. "FRAME") or "OPT_COLORS_RPUF"),
      inline = unit and true,
      order = source_order(),
    };

    if unit 
    then frame_group.args =
         { background = helper_have_unit( "RPUF",         unit, "StyleFrame"     ),
           border     = helper_have_unit( "RPUF_BORDER",  unit, "StyleFrame"     ),
           text       = helper_have_unit( "RPUF_TEXT",    unit, "SetTextColor"   ),
           tooltip    = helper_have_unit( "RPUF_TOOLTIP", unit, nil              ), -- don't need to fire an update method
           statusBar  = helper_have_unit( "STATUS",       unit, "StyleStatusBar" ),
           statusText = helper_have_unit( "STATUS_TEXT",  unit, "StyleStatusBar" ), };

         frame_group.hidden = 
         function() return Get("DISABLE_RPUF")
                        or Get("LINK_FRAME_" .. unit:upper())
                    or not Get("SHOW_FRAME_" .. unit:upper()); end;

    else frame_group.args =
         { background = helper_no_unit(   "RPUF",               "StyleFrame"     ),
           border     = helper_no_unit(   "RPUF_BORDER",        "StyleFrame"     ),
           text       = helper_no_unit(   "RPUF_TEXT",          "SetTextColor"   ),
           tooltip    = helper_no_unit(   "RPUF_TOOLTIP",       nil              ), -- don't need to fire an update method
           statusBar  = helper_no_unit(   "STATUS",             "StyleStatusBar" ),
           statusText = helper_no_unit(   "STATUS_TEXT",        "StyleStatusBar" ), };

        frame_group.hidden = function() return Get("DISABLE_RPUF") end;
    end;

    return frame_group;
  end;
            
  local rpufColors = build_frame_colors();
  for   unit, _ in pairs(CONST.FRAMES.NAMES)
  do    rpufColors.args[unit:lower()] = build_frame_colors(unit:lower());
  end;
  
  addOptions(addOnName, "colors", { rpuf = rpufColors }  );

end);
