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
  local Editor       = RPTAGS.Editor;
  local linkHandler  = Utils.links.handler;

  local menu = { fontSize = { small = loc("SIZE_SMALL"), medium = loc("SIZE_MEDIUM"), large = loc("SIZE_LARGE") } };
  
  local function requiresRPUF() return Config.get("DISABLE_RPUF"); end;

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

    local f = 
    { alpha           = "RPUFALPHA_"           .. str,
      backdrop        = "RPUF_BACKDROP_"       .. str,
      detailHeight    = "DETAILHEIGHT_"        .. str,
      gapSize         = "GAPSIZE_"             .. str,
      iconWidth       = "ICONWIDTH_"           .. str,
      infoWidth       = "INFOWIDTH_"           .. str,
      layout          = str                    .. "LAYOUT",
      link            = "LINK_FRAME_"          .. str,
      portWidth       = "PORTWIDTH_"           .. str,
      show            = "SHOW_FRAME_"          .. str,
      sAlign          = "STATUS_ALIGN_"        .. str,
      sHeight         = "STATUSHEIGHT_"        .. str,
      sTexture        = "STATUS_TEXTURE_"      .. str,
      hideCombat      = "RPUF_HIDE_COMBAT_"    .. str,
      hidePetBattle   = "RPUF_HIDE_PETBATTLE_" .. str,
      hideVehicle     = "RPUF_HIDE_VEHICLE_"   .. str,
      hideParty       = "RPUF_HIDE_PARTY_"     .. str,
      hideRaid        = "RPUF_HIDE_RAID_"      .. str,
      hideDead        = "RPUF_HIDE_DEAD_"      .. str,
      mouseoverCursor = "MOUSEOVER_CURSOR_"    .. str,
      lockFrame       = "LOCK_FRAME_"          .. str,
    };

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
          { hideCombat      = Wide(Checkbox(f.hideCombat      ), 1      ),
            hidePetBattle   = Wide(Checkbox(f.hidePetBattle   ), 1      ),
            hideVehicle     = Wide(Checkbox(f.hideVehicle     ), 1      ),
            hideParty       = Wide(Checkbox(f.hideParty       ), 1      ),
            hideRaid        = Wide(Checkbox(f.hideRaid        ), 1      ),
            hideDead        = Wide(Checkbox(f.hideDead        ), 1      ),
            mouseoverCursor = Wide(Checkbox(f.mouseoverCursor ), "full" ),
          },
        },
        positioning =
        { type = "group",
          name = "Positioning",
          order = source_order(),
          inline = true,
          hidden = function() return not Get("SHOW_FRAME_" .. str) or Get("DISABLE_RPUF") end,
          args =
          { lockFrames      = Wide(Checkbox(f.lockFrame), 1),
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
            colors    = 
            { type = "execute",
              name = "Colors",
              func = function() linkHandler("opt://colors/rpuf") end,
              order = source_order(),
            },
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
