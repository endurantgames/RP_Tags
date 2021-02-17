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
  local Dropdown     = optUtils.dropdown;
  local Checkbox     = optUtils.checkbox;
  local Spacer       = optUtils.spacer;
  local evalTagString = Utils.tags.eval;
  local openEditor   = Config.openEditor;

  local function requiresRPUF() return Config.get("DISABLE_RPUF"); end;

  local function build_tag_editor_button(str)
    local STR         = str:upper():gsub("[:%-]", "");
    local setting     = "EDITOR_BUTTON_" .. STR;
    local buttonCount = "EDITOR_NUM_BUTTONS";
    local w           =
    { type            = "toggle",
      desc            = str,
      name            = loc("TAG_" .. str .. "_DESC"),
      order           = source_order(),
      get             = function() return Get(setting) end,
      disabled        = 
        function() 
        return (Get(buttonCount) >= CONST.RPUF.EDITOR_MAX_BUTTONS) 
          and not Get(setting) 
        end,
      set             = 
        function(self, value)
          Set(setting, value);
          Set(buttonCount, Get(buttonCount) + (value and 1 or -1));
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
    str = str:upper():gsub("%s+", "_");
    ttstr = ttstr:upper():gsub("%s+", "_");
    local w    = 
    { type = "group",
      name     = loc("CONFIG_" .. str),
      order = source_order(),
      args     = 
      { header =
        { type = "header",
          width = "full",
          name = "# " .. loc("CONFIG_" .. str),
          dialogControl = "LMD30_Description",
          order = source_order(),
        },
        instruct = 
          { type = "description",
            width = "full",
            name = loc("CONFIG_" .. str .. "_TT"),
            order = source_order(),
          },
        current = 
          { type = "input",
            width = "full",
            name = loc("CONFIG_" .. str),
            get = function(self) return Get(str) end,
            set = function(self, value) Set(str, value) end,
            order = source_order(),
          },
        tagPreview = 
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
          },
        -- subhed2 = 
        --   { type = "header",
        --     width = "full",
        --     name = "Current Values:",
        --     order = source_order(),
        --   },
        currentTooltip = 
          { type = "input",
            width = "full",
            name = loc("CONFIG_" .. ttstr),
            get = function(self) return Get(ttstr) end,
            set = function(self, value) Set(ttstr, value) end,
            order = source_order(),
          },
        tooltipPreview = 
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
          },
        subhed4 = 
          { type = "header",
            name = "## Open in Tag Editor:",
            width = "full",
            dialogControl = "LMD30_Description",
            order = source_order(),
          },
        editPanel   = Pushbutton(str,   function() openEditor(str)   end, hidden, requiresRPUF),
        editTooltip = Pushbutton(ttstr, function() openEditor(ttstr) end, hidden, requiresRPUF),
      };
    };
    return w;
  end;

  local function build_frame_panel(str, info)
    info             = info or {};
    str              = str:upper():gsub("%s+", "_");

    local menu     = {};
    menu.backdrop  =
    { BLIZZTOOLTIP = loc("BACKDROP_BLIZZTOOLTIP" ),
      THIN_LINE    = loc("BACKDROP_ORIGINAL"     ),
      THICK_LINE   = loc("BACKDROP_THICK_LINE"   ),
      ORIGINAL     = loc("BACKDROP_THIN_LINE"    ), };

    menu.texture   =
    { BAR          = loc("BAR"                   ),
      SKILLS       = loc("SKILLS"                ),
      BLANK        = loc("BLANK"                 ),
      SHADED       = loc("SHADED"                ),
      SOLID        = loc("SOLID"                 ),
      RAID         = loc("RAID"                  ), };

    menu.align     =
    { LEFT         = loc("LEFT"                  ),
      CENTER       = loc("CENTER"                ),
      RIGHT        = loc("RIGHT"                 ), };

    menu.small     =
    { COMPACT      = loc("RPUF_COMPACT"          ),
      ABRIDGED     = loc("RPUF_ABRIDGED"         ),
      THUMBNAIL    = loc("RPUF_THUMBNAIL"        ), };

    menu.large     =
    { COMPACT      = loc("RPUF_COMPACT"          ),
      ABRIDGED     = loc("RPUF_ABRIDGED"         ),
      THUMBNAIL    = loc("RPUF_THUMBNAIL"        ),
      PAPERDOLL    = loc("RPUF_PAPERDOLL"        ),
      FULL         = loc("RPUF_FULL"             ), };

    local f          = {};
    f.alpha          = "RPUFALPHA_"         .. str      ;
    f.backdrop       = "RPUF_BACKDROP_"     .. str      ;
    f.detailHeight   = "DETAILHEIGHT_"      .. str      ;
    f.gapSize        = "GAPSIZE_"           .. str      ;
    f.iconWidth      = "ICONWIDTH_"         .. str      ;
    f.infoWidth      = "INFOWIDTH_"         .. str      ;
    f.layout         = str                  .. "LAYOUT" ;
    f.link           = "LINK_FRAME_"        .. str      ;
    f.portWidth      = "PORTWIDTH_"         .. str      ;
    f.show           = "SHOW_FRAME_"        .. str      ;
    f.sAlign         = "STATUS_ALIGN_"      .. str      ;
    f.sHeight        = "STATUSHEIGHT_"      .. str      ;
    f.sTexture       = "STATUS_TEXTURE_"    .. str      ;


    local w          =
    { name           = loc(str .. "FRAME"),
      order          = source_order(),
      type           = "group",
      hidden         = function() return Get("DISABLE_RPUF") end,
      args           =
      { show         = Wide(Checkbox(f.show,   nil, requiresRPUF), 1),
        link         = Wide(Checkbox(f.link,   function() return not Get(f.show) end, requiresRPUF), 1),
        layout       = Dropdown(f.layout, function() return not Get(f.show) end, requiresRPUF, 
                         info.small and menu.small or menu.large),
        spacer       = Spacer(2),
        scale        = build_frame_scaler(str, function() return not Get(f.show) end, requiresRPUF),
        visibility =
        { type = "group",
          inline = true,
          name = "Visibility",
          order = source_order(),
          hidden = function() return Get("LINK_FRAME_" .. str) end,
          disabled = requiresRPUF,
          args =
          { hideCombat      = Wide(Checkbox("rpuf hide combat",    nil , reqRPUF ), 1),
            hidePetBattle   = Wide(Checkbox("rpuf hide petbattle", nil , reqRPUF ), 1),
            hideVehicle     = Wide(Checkbox("rpuf hide vehicle",   nil , reqRPUF ), 1),
            hideParty       = Wide(Checkbox("rpuf hide party",     nil , reqRPUF ), 1),
            hideRaid        = Wide(Checkbox("rpuf hide raid",      nil , reqRPUF ), 1),
            hideDead        = Wide(Checkbox("rpuf hide dead",      nil , reqRPUF ), 1),
          },
        },
        positioning =
        { type = "group",
          name = "Positioning",
          order = source_order(),
          inline = true,
          hidden = function() return not Get("SHOW_FRAME_" .. str) or Get("DISABLE_RPUF") end,
          args =
          { lockFrames      = Wide(Checkbox("lock frames", nil , reqRPUF ), 1),
            resetFrames     = Pushbutton("reset frame locations", resetFrames, nil , reqRPUF ),
          },
        },
        look         =
        { type       = "group",
          -- inline     = true,
          name       = "Frame Appearance",
          order      = source_order(),
          hidden     = function() return Get(f.link) or not Get(f.show) end,
          args       =
          { backdrop = Dropdown(f.backdrop, nil, requiresRPUF, menu.backdrop ), spb = Spacer(),
            alpha    = build_dimensions_slider(f.alpha, 0, 1, 0.05),             spa = Spacer(),
            statusBar    =
            { type       = "group",
              inline     = true,
              name       = "Status Bar Appearance",
              order      = source_order(),
              hidden     = function() return Get(f.link) or not Get(f.show) end,
              args       =
              { align    = Dropdown(  f.sAlign,    nil, requiresRPUF, menu.align   ), spa = Spacer(),
                texture  = Dropdown(  f.sTexture,  nil, requiresRPUF, menu.texture ), spt = Spacer(),
                height   = build_dimensions_slider(f.sHeight,   15, 140, 5),                         sph = Spacer(),
              },
            },
          },
        },
        dimensions   =
        { type       = "group",
          -- inline     = true,
          name       = "Panel Dimensions",
          order      = source_order(),
          hidden     = function() return Get(f.link) or not Get(f.show) end,
          args       =
          { gap      = build_dimensions_slider(f.gapSize,       0,  20,  1), spg = Spacer(),
            icon     = build_dimensions_slider(f.iconWidth,    10,  75,  1), spi = Spacer(),
            port     = build_dimensions_slider(f.portWidth,    25, 200,  5), spp = Spacer(),
            info     = build_dimensions_slider(f.infoWidth,   100, 400, 10), spn = Spacer(),
            detail   = build_dimensions_slider(f.detailHeight, 20, 250,  5), spd = Spacer(),
          },
        },
      },
    };
    return w;

  end;
  RPTAGS.utils.options.frame_scaler      = build_frame_scaler;
  RPTAGS.utils.options.dimensions_slider = build_dimensions_slider;
  RPTAGS.utils.options.tagpanel          = build_tagpanel;
  RPTAGS.utils.options.requiresRPUF      = requiresRPUF;
  RPTAGS.utils.options.frame_panel       = build_frame_panel;
  RPTAGS.utils.options.editor_button     = build_tag_editor_button;
  RPTAGS.utils.options.editor_bar_mockup = build_editor_bar_mockup;

end);
