local addOnName, addOn = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("before MODULE_G", -- module options must load before RPTAGS options
function(self, event, ...)

  local Utils        = RPTAGS.utils;
  local Config       = Utils.config;
  local Get          = Config.get;
  local Set          = Config.set;
  local loc          = Utils.locale.loc;
  local Options      = Utils.options;
  local source_order = Options.source_order
  local Common       = Options.common;
  local Pushbutton   = Options.pushbutton;
  local Header       = Options.header;
  local Instruct     = Options.instruct;
  local Textbox      = Options.textbox;
  local Dropdown     = Options.dropdown;
  local Checkbox     = Options.checkbox;
  local Spacer       = Options.spacer;
  local evalTagString = Utils.tags.eval;

  local function requiresRPUF() return Config.get("DISABLE_RPUF"); end;

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
    { name           = str .. " Frame",
      order          = source_order(),
      type           = "group",
      args           =
      { show         = Checkbox(f.show,   nil,                                   requiresRPUF),
        link         = Checkbox(f.link,   function() return not Get(f.show) end, requiresRPUF),
        layout       = Dropdown(f.layout, function() return not Get(f.show) end, requiresRPUF, 
                         info.small and menu.small or menu.large),
        spacer       = Spacer(2),
        scale        = build_frame_scaler(str, function() return not Get(f.show) end, requiresRPUF),
        look         =
        { type       = "group",
          inline     = true,
          name       = "Frame Appearance",
          order      = source_order(),
          hidden     = function() return Get(f.link) or not Get(f.show) end,
          args       =
          { backdrop = Dropdown(f.backdrop, nil, requiresRPUF, menu.backdrop ), spb = Spacer(),
            alpha    = build_dimensions_slider(f.alpha, 0, 1, 0.05),             spa = Spacer(),
          },
        },
        dimensions   =
        { type       = "group",
          inline     = true,
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
    };
    return w;

  end;
  RPTAGS.utils.options.frame_scaler      = build_frame_scaler;
  RPTAGS.utils.options.dimensions_slider = build_dimensions_slider;
  RPTAGS.utils.options.tagpanel          = build_tagpanel;
  RPTAGS.utils.options.requiresRPUF      = requiresRPUF;
  RPTAGS.utils.options.frame_panel       = build_frame_panel;

end);
