local addOnName, addOn = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("before MODULE_G", -- module options must load before RPTAGS options
function(self, event, ...)

  local Utils        = RPTAGS.utils;
  local Config       = Utils.config;
  local Get          = Config.get;
  local Set          = Config.set;
  local Locale       = Utils.locale;
  local loc          = Locale.loc;
  local tagDesc      = Locale.tagDesc;
  local tagLabel     = Locale.tagLabel;
  local CONST        = RPTAGS.CONST;
  local optUtils      = Utils.options;
  local source_order = optUtils.source_order
  local Blank_Line   = optUtils.blank_line
  local Common       = optUtils.common;
  local Pushbutton   = optUtils.pushbutton;
  local Header       = optUtils.header;
  local Instruct     = optUtils.instruct;
  local Wide         = optUtils.set_width;
  local Textbox      = optUtils.textbox;
  local Slider       = optUtils.slider;
  local Dropdown     = optUtils.dropdown;
  local Checkbox     = optUtils.checkbox;
  local Spacer       = optUtils.spacer;
  local evalTagString = Utils.tags.eval;
  local openEditor   = Config.openEditor;
  local Editor       = RPTAGS.Editor;
  local linkHandler  = Utils.links.handler;
  local Font         = optUtils.font;

  local function build_tag_editor_button(str)
    local STR         = str:upper():gsub("[:%-]", "");
    local setting     = "EDITOR_BUTTON_" .. STR;
    local w           =
    { type            = "toggle",
      desc            = str,
      name            = loc("TAG_" .. str .. "_DESC"),
      order           = source_order(),
      get             = function() return Get(setting) end,
      disabled        = 
        function() 
          return (Editor:CountToolBar() >= CONST.RPUF.EDITOR_MAX_BUTTONS)
             and not Get(setting) 
        end,
      set             = 
        function(self, value)
          Set(setting, value);
          Editor:UpdateLayout();
        end,
    };

    return w;
  end;

  local function build_editor_bar_mockup(str)
    local w = 
    { name = "Editor Button Bar",
      type = "group",
      order = source_order(),
      inline = true,
      args = 
      { colorWheel =
        { type = "execute",
          name = RPTAGS.CONST.ICONS.COLORWHEEL,
          desc = "Change text color",
          order = source_order(),
          width = 0.375,
        },
        noColor =
        { type = "execute",
          name = RPTAGS.CONST.ICONS.COLORWHEEL,
          desc = "Reset Colors",
          order = source_order(),
          disabled = true,
          width = 0.375,
        },
      },
    };

    for _, button in ipairs(CONST.RPUF.EDITOR_BUTTON_LIST)
    do  w.args[button] =
        { type = "execute",
          name = tagLabel(button),
          desc = tagDesc(button),
          order = source_order(),
          width = 0.75,
          hidden = function() 
            return not Get("EDITOR_BUTTON_" .. button:upper():gsub("[:%-]",""));
          end,
        }
    end;

    return w;
  end;
  
  local function Percent(w)
    w.isPercent = true;
   return w; 
  end;

  local menu = 
  { fontSize =
    { extrasmall = loc("SIZE_EXTRA_SMALL"),
      small = loc("SIZE_SMALL"),
      medium = loc("SIZE_MEDIUM"),
      large = loc("SIZE_LARGE"),
      extralarge = loc("SIZE_EXTRA_LARGE"),
    },
    portraitStyle =
    { STANDARD = "Standard 3D portrait",
      FROZEN = "Non-animated portrait",
    },

  };

  local function build_tagpanel(str, ttstr, hidden, disabled, opt)

    opt = opt or {};
    str = str:upper():gsub("%s+", "_");
    ttstr = ttstr:upper():gsub("%s+", "_");

    local w    = 
    { type = "group",
      name     = loc("CONFIG_" .. str),
      order = source_order(),
      args = {},
    };

    w.args.header =
    { type = "header",
      width = "full",
      name = "# " .. loc("CONFIG_" .. (opt["no_text"] and ttstr or str)),
      dialogControl = "LMD30_Description",
      order = source_order(),
    };

    if   not opt["no_text"]
    then w.args.fontSize = Dropdown(str .. "_FONTSIZE", nil, nil, menu.fontSize);

         w.args.instruct = 
         { type = "description",
           width = "full",
           name = loc("CONFIG_" .. str .. "_TT"),
           order = source_order(),
         };

         w.args.current = 
         { type = "input",
           width = "full",
           name = loc("CONFIG_" .. str),
           get = function(self) return Get(str) end,
           set = function(self, value) Set(str, value) end,
           order = source_order(),
         };

         w.args.tagPreview = 
         { type = "group",
           order = source_order(),
           name = "Live Preview",
           inline = true,
           args = 
           { preview = 
             { type = "description",
               order = source_order(),
               name = function(self) return evalTagString(Get(str), "player", "player") end,
               fontSize = function(self) return str:match("ICON") and "large" or "medium" end,
             },
           },
         };
    end;
    if   not opt["no_tooltip"]
    then w.args.instruct_tt = 
         { type = "description",
           width = "full",
           name = loc("CONFIG_" .. ttstr .. "_TT"),
           order = source_order(),
         };

         w.args.currentTooltip = 
         { type = "input",
           width = "full",
           name = loc("CONFIG_" .. ttstr),
           get = function(self) return Get(ttstr) end,
           set = function(self, value) Set(ttstr, value) end,
           order = source_order(),
         };

         w.args.tooltipPreview = 
         { type = "group",
           order = source_order(),
           name = "Live Preview",
           inline = true,
           args = 
           { preview = 
             { type = "description",
               order = source_order(),
               name = function(self) return evalTagString(Get(ttstr), "player", "player") end,
               fontSize = "medium",
             },
           },
         };
    end;

    w.args.subhed4 = 
    { type = "header",
       name = "## Open in Tag Editor:",
       width = "full",
       dialogControl = "LMD30_Description",
       order = source_order(),
    };

    if not opt["no_text"]
    then w.args.editPanel = Pushbutton(str, function() InterfaceOptionsFrame:Hide() openEditor(str) end);
    end;

    if not opt["no_tooltip"]
    then w.args.editTooltip = Pushbutton(ttstr, function() InterfaceOptionsFrame:Hide() openEditor(ttstr) end);
    end;

    return w;
  end;

  RPTAGS.utils.options.tagpanel          = build_tagpanel;
  RPTAGS.utils.options.editor_button     = build_tag_editor_button;
  RPTAGS.utils.options.editor_bar_mockup = build_editor_bar_mockup;

end);
