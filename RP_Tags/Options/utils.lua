-- ------------------------------------------------------------------------------
-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 
-- Utils-Config: Utilities for reading and registering configuration values

local RPTAGS          = RPTAGS;

RPTAGS.queue:WaitUntil("UTILS_OPTIONS",
function(self, event, ...)
-- RPQ -----------------------------------------------------------------------------------------------------------------------------------------------
  
  local Utils              = RPTAGS.utils;
  local Config             = Utils.config;
  local loc                = Utils.locale.loc;
  local hilite             = Utils.text.hilite;
  local hi                 = Utils.text.hilite;
  local APP_NAME           = loc("APP_NAME");
  local refreshAll         = Utils.tags.refreshAll;
  local weights            = Utils.format.kg;
  local heights            = Utils.format.cm;
  local sizebuffs          = Utils.format.sizebuff;
  local profilesizes       = Utils.format.sizewords;
  local unsup              = Utils.format.unsup;
  local notify             = Utils.text.notify;
  local AceConfigDialog    = LibStub("AceConfigDialog-3.0");
  local AceGUI             = LibStub("AceGUI-3.0");
  local LibSharedMedia     = LibStub("LibSharedMedia-3.0");
  local split              = Utils.text.split;
  local getKeyBind         = Utils.keybind.get;
  local setKeyBind         = Utils.keybind.set;
  local clearKeyBind       = Utils.keybind.clear;

  local MENUS =
  { UNITS_HEIGHT          =
    { CM                  =  heights(168, "CM"),
      CM_FT_IN            =  heights(168, "CM_FT_IN"),
      CM_IN               =  heights(168, "CM_IN"),
      FT_IN               =  heights(168, "FT_IN"),
      FT_IN_CM            =  heights(168, "FT_IN_CM"),
      IN                  =  heights(168, "IN"),
      IN_CM               =  heights(168, "IN_CM"),
      HEIGHT_PASSTHRU     =  heights(168, "HEIGHT_PASSTHRU"),
    },
  
    UNITS_WEIGHT =
    { KG                  =  weights(73, "KG"),
      KG_LB               =  weights(73, "KG_LB"),
      KG_ST_LB            =  weights(73, "KG_ST_LB"),
      LB_KG               =  weights(73, "LB_KG"),
      LB_ST               =  weights(73, "LB_ST"),
      LB_ST               =  weights(73, "LB_ST"),
      ST_LB               =  weights(73, "ST_LB"),
      ST_LB_KG            =  weights(73, "ST_LB_KG"),
      ST_LB_LB_KG         =  weights(73, "ST_LB_LB_KG"),
      WEIGHT_PASSTHRU     =  weights(73, "WEIGHT_PASSTHRU"),
    },
  
    PROFILESIZE_FMT =
    { WRD_BRC_NUM         =  profilesizes(7, BIG_PROFILE, "WRD_BRC_NUM"),
      WRD_PAR_NUM         =  profilesizes(7, BIG_PROFILE, "WRD_PAR_NUM"),
      BRC_WRD_NUM         =  profilesizes(7, BIG_PROFILE, "BRC_WRD_NUM"),
      PAR_WRD             =  profilesizes(7, BIG_PROFILE, "PAR_WRD"),
      WRD                 =  profilesizes(7, BIG_PROFILE, "WRD"),
      BRC_LTR_NUM         =  profilesizes(7, BIG_PROFILE, "BRC_LTR_NUM"),
      BRC_LTR             =  profilesizes(7, BIG_PROFILE, "BRC_LTR"),
      LTR                 =  profilesizes(7, BIG_PROFILE, "LTR"),
      BRC_NUM             =  profilesizes(7, BIG_PROFILE, "BRC_NUM"),
      NUM                 =  profilesizes(7, BIG_PROFILE, "NUM"),
    },
  
    SIZEBUFF_FMT =
    { PCT                 =  sizebuffs(8212, "PCT"),
      PCT_BRC             =  sizebuffs(8212, "PCT_BRC"),
      PCT_BUFF            =  sizebuffs(8212, "PCT_BUFF"),
      BUFF_PCT            =  sizebuffs(8212, "BUFF_PCT"),
      BUFF                =  sizebuffs(8212, "BUFF"),
      BUFF_BRC            =  sizebuffs(8212, "BUFF_BRC"),
      BUFF_PCT_BRC        =  sizebuffs(8212, "BUFF_PCT_BRC"),
    },
  
    GLANCE_COLON =
    { [": "]              =  loc("CONFIG_GLANCE_COLON_COLON"),
      [", "]              =  loc("CONFIG_GLANCE_COLON_COMMAS"),
      [" - "]             =  loc("CONFIG_GLANCE_COLON_DASHES"),
      [" / "]             =  loc("CONFIG_GLANCE_COLON_SLASHES"),
      [" "]               =  loc("CONFIG_GLANCE_COLON_SPACES"),
    },
  
    GLANCE_DELIM =
    { [", "]              =  loc("CONFIG_GLANCE_DELIM_COMMAS"),
      ["\n"]              =  loc("CONFIG_GLANCE_DELIM_NEWLINES"),
      ["; "]              =  loc("CONFIG_GLANCE_DELIM_SEMICOLONS"),
      [" / "]             =  loc("CONFIG_GLANCE_DELIM_SLASHES"),
      [" "]               =  loc("CONFIG_GLANCE_DELIM_SPACES"),
    },
  
    UNSUP_TAG =
    { ["?"]               =  "?",
      ["??"]              =  "??",
      ["???"]             =  "???",
      ["[?]"]             =  "[?]",
      ["|cffdddd00?|r"]   =  "|cffdddd00?|r",
      ["|cffdd0000?|r"]   =  "|cffdd0000?|r",
      ["|cffdddd00[?]|r"] =  "|cffdddd00[?]|r",
      ["|cffdd0000[?]|r"] =  "|cffdd0000[?]|r",
      [""]                =  loc("CONFIG_UNSUP_NONE"),
  
      ["|TInterface\\RAIDFRAME\\ReadyCheck-NotReady:0|t"] = "|TInterface\\RAIDFRAME\\ReadyCheck-NotReady:0|t",
    },
  } ;
  
  local function source_order()
        RPTAGS.cache.orderCount = (RPTAGS.cache.orderCount or 0) + 1;
        return RPTAGS.cache.orderCount;
  end;

  local function build_markdown(text, hidden, disabled)

      local w =
      { order = source_order(),
        type = "description",
        dialogControl = "LMD30_Description",
        width = "full",
      };

      if type(text) == "table"
      then w.name = hilite(text[2], true);
           w = 
           { type = "group",
             name = hilite(text[1], true),
             width = "full",
             order = source_order(),
             args = { 
               text = w }
           };
      elseif type(text) == "string"
      then w.name = text -- hilite(text, true);
      end;

      return w
  end;
  local function build_common(type, prefix, str, hidden, disabled, get, set, no_tooltip)
        local widget = {};
  
        str    = str:upper():gsub("%s", "_");
        prefix = prefix:upper():gsub("%s", "_");
  
        widget.order    = source_order();
        widget.hidden   = hidden;
        widget.disabled = disabled;
        widget.name     = hi(loc(prefix .. str));
        widget.type     = type;
  
        if     get == true 
        then   widget.get = function() return Config.get(str) end;
        elseif get
        then   widget.get = get;
        end;
  
        if     set == true 
        then   widget.set = function(info, value) return Config.set(str, value) end;
        elseif set
        then   widget.set = set;
        end;
  
        if not no_tooltip then widget.desc = hi(loc(prefix .. str .. "_TT")); end;
  
       return widget;
  end;
  
  local function build_spacer(size)     
        return 
          { name = "", 
            order = source_order(), 
            width = 0.05 * (size or 1),   
            type = "description", 
            fontSize = "medium", 
          }; 
        end;

  local function build_blank_line(fontSize) 
    return 
      { name = "", 
        order = source_order(), 
        width = "full", 
        type = "description", 
        fontSize = fontSize or "medium", 
      }; 
  end;

  local function build_label(str, hidden, disabled, width)
    local w = build_common("description", "", str, hidden, disabled);
    w.name = str;
    w.width = width or 1
    return w;
  end;

  local function build_checkbox(str, hidden, disabled)
        local w    = build_common("toggle", "CONFIG_", str, hidden, disabled, true, true);
        w.width = 1.5;
        return w;
  end;
  
  local function build_textbox(str, hidden, disabled)
        local w    = build_common("input", "CONFIG_", str, hidden, disabled, true, true);
        return w;
  end;  
  
  local function build_dropdown(str, hidden, disabled, values)
        local w    = build_common("select", "CONFIG_", str, hidden, disabled, true, true);
        w.values   = values or MENUS[str:upper():gsub("%s+","_")]
        return w;
  end;
  
  local function build_color_picker(str, hidden, disabled)
    str = "COLOR_" .. string.upper(str):gsub("%s","_");
    local w =
    { name = loc("CONFIG_" .. str),
      order = source_order(),
      width = "full",
      type = "group" ,
      inline = true,
    };

    local c    = build_common("color", "UI_", "BLANK", hidden, disabled);
    c.hasAlpha = false;
    c.get      = 
      function(info, value) 
        local  hexString = Config.get(str);
        if     type(hexString) == "number" then hexString = "000000"; end;
        local  r, g, b, a = RPTAGS.utils.color.colorToDecimals(hexString);
        return r, g, b, a;
      end;
    c.set      = 
      function(info, r, g, b, a) 
        local value = RPTAGS.utils.color.decimalsToColor(r, g, b);
        Config.set(str, value);
      end;
    c.width = 0.25;
    c.desc = loc("CONFIG_" .. str .. "_TT");

    local s = build_spacer();

    local l = build_markdown(loc("CONFIG_" .. str .. "_TT"));

    w.args = { color = c, spacer = s, label = l };

    return w;
  end;
  
  local function build_slider(str, min, max, step, width, hidden, disabled, get, set)
        local w = build_common("range", "config_", str, hidden, disbled, true, true);
        w.width = width or "full";
  
        if     not min
        then   min = 0
        elseif type(min) == "table"
        then   w.min     = min[2];
               w.softMin = min[1];
        else   w.min = min;
        end;

        if     not max
        then   max = 0
        elseif type(max) == "table"
        then   w.max     = max[2];
               w.softMax = max[1];
        else   w.max = max;
        end;

        if     not step
        then   step = 0
        elseif type(step) == "table"
        then   w.step = step[1];
               w.bigStep = step[2];
        else   w.step = step;
        end;

        return w;
  end;
  
  local function build_pushbutton(str, func, hidden, disabled)
        local w    = build_common("execute", "config ", str, hidden, disabled);
        w.func = func;
        return w;
  end
  
  local function build_reset(list, hidden, disabled)
        local w = build_pushbutton(
          "reset these values", 
          function() 
            for _, s in ipairs(list) 
            do  Config.reset(string.upper(s):gsub("%s+","_")) 
            end 
          end, 
          hidden, disabled);
        return w;
  end;
  
  local function build_header(str, level, hidden, disabled)
        local w = build_markdown(
                    string.rep("#", level or 1) .. 
                    loc("OPT_" .. str:upper():gsub("%s+","_")), 
                    hidden, disabled);
        w.width = "full";
        return w;
  end;
  
  local function build_instruct(str, hidden, disabled)
        local w = build_common("description", "opt ", str .. "_i", hidden, disabled, nil, nil, true);
        w.fontSize = "medium";
        w.dialogControl = "LMD30_Description";
        return w;
  end; 
  
  local function build_keybind(str, hidden, disabled)
        local str = str:upper():gsub("%s+", "_");

        local w  = 
        { name   = loc("KEYBIND_" .. str),
          type   = "group",
          order  = source_order(),
          inline = true,
          args = {},
        };

        local allKeys = getKeyBind(str);
      
        for i = 1, 2
        do  local keybind = build_common("keybinding", "UI_", "BLANK", hidden, disabled);
            keybind.width = "half";
            keybind.get = function(self) return getKeyBind(str, i); end;
            keybind.set = 
              function(self, value) 
                if   value == ""
                then clearKeyBind(getKeyBind(str, i)); 
                else setKeyBind(str, value) 
                end;
              end;
            w.args["keybind" .. i] = keybind;
            w.args["spacer" .. i] = build_spacer();
        end;

        w.args.desc = build_markdown(loc("KEYBIND_" .. str .. "_TT"));

        return w
  end;

  local function build_lsm_font(str, hidden, disabled, get, set)
    local w    = build_common("select", "", str, hidden, disabled, get or true, set or true);
    w.dialogControl = "LSM30_Font";
    w.values   = LibSharedMedia:HashTable("font");
    return w;
  end;

  local function build_lsm_sound(str, hidden, disabled, get, set)
    local w    = build_common("select", "", str, hidden, disabled, get or true, set or true);
    w.dialogControl = "LSM30_Sound";
    w.values   = LibSharedMedia:HashTable("sound");
    return w;
  end;

  local function build_lsm_statusbar(str, hidden, disabled, get, set)
    local w    = build_common("select", "", str, hidden, disabled, get or true, set or true);
    w.dialogControl = "LSM30_Statusbar";
    w.values   = LibSharedMedia:HashTable("statusbar");
    return w;
  end;

  local function build_lsm_background(str, hidden, disabled, get, set)
    local w    = build_common("select", "", str, hidden, disabled, get or true, set or true);
    w.dialogControl = "LSM30_Background";
    w.values   = LibSharedMedia:HashTable("background");
    return w;
  end;

  local function build_lsm_border(str, hidden, disabled, get, set)
    local w    = build_common("select", "", str, hidden, disabled, get or true, set or true);
    w.dialogControl = "LSM30_Border";
    w.values   = LibSharedMedia:HashTable("border");
    return w;
  end;

  local function set_width(w, width) w.width = width or "full"; return w; end;
  local function set_fontSize(w, fontSize) w.fontSize = fontSize or "small"; return w; end;

  local function build_plugin_mountpoint(str)
    RPTAGS.cache.Plugins = RPTAGS.cache.Plugins or {};
    RPTAGS.cache.Plugins[str] = RPTAGS.cache.Plugins[str] or {};
    return RPTAGS.cache.Plugins[str];
  end;

  local function build_data_table(str, data, config)
    local w = 
    { type   = "group",
      inline = true,
      name   = str,
      width  = "full",
      order  = source_order(),
      args   = {},
    };
    config = config or {};
    config.width = config.width or {};
    for l, line in ipairs(data)
    do  for i, item in ipairs(line)
        do  local cellName = string.format("TableCell_%d_%d", l, i);
            w.args[cellName] =
            { type = "description",
              width = config.width[i] or 1,
              name = (l == 1) and ("*" .. item .. "*") or item or "",
              order = source_order(),
              fontSize = config.fontSize or "small",
              dialogControl = "LMD30_Description",
            };
            if config.spacer then w.args[cellName .. "_Spacer"] = build_spacer(); end;
        end;
        if config.blank_line then w.args["BlankLine" .. l] = build_blank_line("small"); end;
    end;
    return w;
  end;
    
  RPTAGS.utils.options  = RPTAGS.utils.options or {};
  optUtils              = RPTAGS.utils.options;
  optUtils.source_order = source_order;
  optUtils.common       = build_common
  optUtils.set_width    = set_width;
  optUtils.set_fontSize = set_fontSize;

  optUtils.background   = build_lsm_background;
  optUtils.blank_line   = build_blank_line;
  optUtils.border       = build_lsm_border;
  optUtils.checkbox     = build_checkbox
  optUtils.color_picker = build_color_picker
  optUtils.dropdown     = build_dropdown
  optUtils.font         = build_lsm_font;
  optUtils.header       = build_header
  optUtils.instruct     = build_instruct
  optUtils.keybind      = build_keybind;
  optUtils.label        = build_label
  optUtils.markdown     = build_markdown
  optUtils.pushbutton   = build_pushbutton;
  optUtils.reset        = build_reset
  optUtils.slider       = build_slider;
  optUtils.sound        = build_lsm_sound;
  optUtils.spacer       = build_spacer;
  optUtils.statusbar    = build_lsm_statusbar;
  optUtils.textbox      = build_textbox;
  optUtils.data_table   = build_data_table;

-- RPQ -----------------------------------------------------------------------------------------------------------------------------------------------
end);
