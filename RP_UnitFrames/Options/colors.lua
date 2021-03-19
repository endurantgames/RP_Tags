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

  local function confGet(unit, setting)
    return unit and RPTAGS.cache.UnitFrames[unit]:Public("ConfGet", setting) or Get(setting);
  end;

  local function confSet(unit, setting, value)
    return unit and RPTAGS.cache.UnitFrames[unit]:Public("ConfSet", setting, value) or Set(setting, value);
  end;

  local menu = {};
  menu.unitColors = { }; 
  --[[["rp:color"] = loc("TAG_rp:color_DESC"),
    ["rp:eyecolor"] = loc("TAG_rp:eyecolor_DESC"),
    ["rp:friendcolor"] = loc("TAG_rp:friendcolor_DESC"),
    ["rp:gendercolor"] = loc("TAG_rp:gendercolor_DESC"),
    ["rp:guildcolor"] = loc("TAG_rp:guildcolor_DESC"),
    ["rp:guildstatuscolor"] = loc("TAG_rp:guildstatuscolor_DESC"),
    ["rp:mecolor"] = loc("TAG_rp:mecolor_DESC"),
    ["rp:partycolor"] = loc("TAG_rp:partycolor_DESC"),
    -- filesize = loc("TAG_rp:filesizecolor_DESC"),
  };
  --]]
  menu.unitColorsOrder = 
  { "rp:color", 
    "rp:eyecolor", 
    "rp:friendcolor", 
    "rp:gendercolor",
    "rp:guildcolor", 
    "rp:guildstatuscolor", 
    "rp:mecolor", 
    "rp:partycolor",
    "rp:profilesizecolor",
    "rp:relationcolor",
    "rp:statuscolor",
    "rp:agecolor",
    "rp:heightcolor",
    "rp:weightcolor",
    "rp:hilite-1",
    "rp:hilite-2",
    "rp:hilite-3",
    "rp:target-color",
    "rp:target-gendercolor",
    "rp:target-statuscolor",
    "rp:target-mecolor",
    "classcolor",
    "powercolor",
    "raidcolor",
    "threatcolor",
  };

  for _, tag in ipairs(menu.unitColorsOrder)
  do  menu.unitColors[tag] = loc("TAG_" .. tag .. "_DESC")
  end;

  local function build_frame_colors(unit)
    local ufCache = RPTAGS.cache.UnitFrames;

    local function helper_have_unit(color, unit, ...)
      local colorSetting = color .. "_" .. unit:upper();
      local update = { ... };
      local picker = Color_Picker(colorSetting);
      picker.set = 
        function(info, r, g, b, a)
          local ufCache = RPTAGS.cache.UnitFrames;
          confSet(unit, "COLOR_" .. colorSetting , toHex(r, g, b));
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
          confSet(unit, "COLOR_" .. color, toHex(r, g, b));
          RPUF_Refresh("all", unpack(update))
        end;
      return picker;
    end;

    local function use_unit_color(unit, color, ...)
      color = color:upper();
      local useUnitSetting = "COLOR_" .. color .. "_USE_UNITCOLOR" .. (unit and ("_" .. unit:upper()) or "");
      local unitColorSetting = "COLOR_" .. color .. "_UNITCOLOR" .. (unit and ("_" .. unit:upper()) or "");
      local picker = unit and helper_have_unit(color, unit, ...)
                           or helper_no_unit(color, unit, ...);
      picker.disabled = function() return confGet(unit, useUnitSetting) end;
      local update = { ... };
      picker.width = unit and 1.20 or 1.25;
      return
          picker,
          { type = "toggle",
            name = "Use a Unit Color",
            desc = "Use one of the unit's colors instead of a default color.",
            order = source_order(),
            width = 0.8,
            get = function() return confGet(unit, useUnitSetting) end,
            set = function(info, value) confSet(unit, useUnitSetting, value) RPUF_Refresh(unit, unpack(update)) end,
          },
          { type = "select",
            name = "",
            desc = "Choose a unit color.",
            values = menu.unitColors,
            order = source_order(),
            width = unit and 1.05 or 1.15,
            get = function() return confGet(unit, unitColorSetting) end,
            set = function(info, value) confSet(unit, unitColorSetting, value) RPUF_Refresh(unit, unpack(update)) end,
            sorting = menu.unitColorsOrder,
            hidden = function() return not confGet(unit, useUnitSetting) end,
          },
          { type = "description",
            name = "",
            order = source_order(),
            width = "full",
          };
    end;

    local frame_group =
    { type = "group",
      name =  loc(unit and (unit:upper() .. "FRAME") or "OPT_COLORS_RPUF"),
      inline = unit and true,
      order = source_order(),
      args = 
      { header = 
        { type = "description",
          name = unit and ("## " .. loc(unit:upper() .. "FRAME")) or ("# " .. loc("OPT_COLORS_RPUF")),
          width = "full",
          order = source_order(),
          dialogControl = "LMD30_Description",
        },
        instruct =
        { type = "description",
          name = unit and ("These colors only apply to the " .. loc(unit:upper() .. "FRAME") .. ".")
                 or ("These colors apply to any frames that are `linked` to the shared settings. " ..
                     "You can pick specific colors, or you can use colors from the unit's RP profile; " ..
                     "these are called *unit colors.*"),
          width = "full",
          order = source_order(),
          dialogControl = "LMD30_Description",
        }
      },
    };

    local optionsToBuild =
    { RPUF = { "style" },
      RPUF_BORDER = { "style" },
      RPUF_TEXT = { "textcolor" },
      RPUF_TOOLTIP = { "textcolor" },
      STATUS = { "statusbar" },
      STATUS_TEXT = { "statusbar" },
      PORTRAIT_BORDER = { "portrait" },
      PORTRAIT_BACKDROP ={  "portrait" },
    };

    local optionsToBuildOrder = 
    { "RPUF", 
      "RPUF_BORDER", 
      "RPUF_TEXT", 
      "RPUF_TOOLTIP", 
      "STATUS", 
      "STATUS_TEXT",
      "PORTRAIT_BORDER",
      "PORTRAIT_BACKDROP",
    };

    for _, option in ipairs(optionsToBuildOrder)
    do  local picker, useUnitColor, unitColor, newline = 
        use_unit_color(unit, option, unpack(optionsToBuild[option]));
        frame_group.args[option:lower() .. "Picker"] = picker;
        frame_group.args[option:lower() .. "UseUnitColor"] = useUnitColor;
        frame_group.args[option:lower() .. "UnitColor"] = unitColor;
        frame_group.args[option:lower() .. "Newline"] = newline;
    
    end;

    --[[ if unit 
    then frame_group.args =
         { background = helper_have_unit( "RPUF",         unit, "style"     ),
           border     = helper_have_unit( "RPUF_BORDER",  unit, "style"     ),
           text       = helper_have_unit( "RPUF_TEXT",    unit, "textcolor"   ),
           tooltip    = helper_have_unit( "RPUF_TOOLTIP", unit, nil              ), -- don't need to fire an update method
           statusBar  = helper_have_unit( "STATUS",       unit, "statusbar" ),
           statusText = helper_have_unit( "STATUS_TEXT",  unit, "statusbar" ), };
    --]]
    if unit
    then frame_group.hidden = 
         function() return Get("DISABLE_RPUF")
                        or Get("LINK_FRAME_" .. unit:upper())
                    or not Get("SHOW_FRAME_" .. unit:upper()); end;
    end;

    return frame_group;
  end;
            
  local rpufColors = build_frame_colors();
  for   unit, _ in pairs(frameNames)
  do    rpufColors.args[unit:lower()] = build_frame_colors(unit:lower());
  end;
  
  addOptions(addOnName, "colors", { rpufColors = rpufColors } );
end);
