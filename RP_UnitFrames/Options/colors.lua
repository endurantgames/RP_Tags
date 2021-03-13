local addOnName, ns = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("MODULE_G",
function(self, event, ...)

  local Utils           = RPTAGS.utils;
  local loc             = RPTAGS.utils.locale.loc;
  local frameNames      = RPTAGS.CONST.RPUF.FRAME_NAMES;

  local Get             = Utils.config.get;
  local Set             = Utils.config.set;
  local Default         = Utils.config.default;
  local addOptions      = Utils.modules.addOptions;
  local addOptionsPanel = Utils.modules.addOptionsPanel;
  local source_order    = Utils.options.source_order;
  local Color_Picker    = Utils.options.color_picker
  local Spacer          = Utils.options.spacer
  local toHex           = Utils.color.decimalsToColor;
  local RPUF_Refresh    = Utils.frames.RPUF_Refresh;

  local function build_frame_colors(unit)
    local ufCache = RPTAGS.cache.UnitFrames;

    local function helper_have_unit(color, unit, ...)
      local update = { ... };
      local colorSetting = color .. "_" .. unit:upper();
      local picker = Color_Picker(colorSetting);
      picker.set = 
        function(info, r, g, b, a)
          local ufCache = RPTAGS.cache.UnitFrames;
          Set("COLOR_" .. colorSetting , toHex(r, g, b));
          RPUF_Refresh(unit, unpack(update));
        end;
      return picker;
    end;

    function helper_no_unit(color, ...)
      local picker = Color_Picker(color);
      local update = { ... };
      picker.set =
        function(info, r, g, b, a)
          local ufCache = RPTAGS.cache.UnitFrames;
          Set("COLOR_" .. color, toHex(r, g, b));
          RPUF_Refresh("all", unpack(update))
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
         { background = helper_have_unit( "RPUF",         unit, "style"     ),
           border     = helper_have_unit( "RPUF_BORDER",  unit, "style"     ),
           text       = helper_have_unit( "RPUF_TEXT",    unit, "textcolor"   ),
           tooltip    = helper_have_unit( "RPUF_TOOLTIP", unit, nil              ), -- don't need to fire an update method
           statusBar  = helper_have_unit( "STATUS",       unit, "statusbar" ),
           statusText = helper_have_unit( "STATUS_TEXT",  unit, "statusbar" ), };

         frame_group.hidden = 
         function() return Get("DISABLE_RPUF")
                        or Get("LINK_FRAME_" .. unit:upper())
                    or not Get("SHOW_FRAME_" .. unit:upper()); end;

    else frame_group.args =
         { background = helper_no_unit(   "RPUF",               "style"          ),
           border     = helper_no_unit(   "RPUF_BORDER",        "style"          ),
           text       = helper_no_unit(   "RPUF_TEXT",          "textcolor"   ),
           tooltip    = helper_no_unit(   "RPUF_TOOLTIP",       nil              ), -- don't need to fire an update method
           statusBar  = helper_no_unit(   "STATUS",             "statusbar" ),
           statusText = helper_no_unit(   "STATUS_TEXT",        "statusbar" ), };

        -- frame_group.hidden = function() return Get("DISABLE_RPUF") end;
    end;

    return frame_group;
  end;
            
  local rpufColors = build_frame_colors();
  for   unit, _ in pairs(frameNames)
  do    rpufColors.args[unit:lower()] = build_frame_colors(unit:lower());
  end;
  
  addOptions(addOnName, "colors", { rpufColors = rpufColors } );
end);
