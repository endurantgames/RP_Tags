local addOnName, ns = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("MODULE_G",
function(self, event, ...)

  local loc               = RPTAGS.utils.locale.loc;
  local Get               = RPTAGS.utils.config.get;
  local Set               = RPTAGS.utils.config.set;
  local Default           = RPTAGS.utils.config.default;
  local eval              = RPTAGS.utils.tags.eval;
  local addOptions        = RPTAGS.utils.modules.addOptions;
  local addOptionsPanel   = RPTAGS.utils.modules.addOptionsPanel;
  local source_order      = RPTAGS.utils.options.source_order;
  local Checkbox          = RPTAGS.utils.options.checkbox
  local Color_Picker      = RPTAGS.utils.options.color_picker
  local Common            = RPTAGS.utils.options.common
  local Dropdown          = RPTAGS.utils.options.dropdown
  local Header            = RPTAGS.utils.options.header
  local Instruct          = RPTAGS.utils.options.instruct
  local Keybind           = RPTAGS.utils.options.keybind
  local Pushbutton        = RPTAGS.utils.options.pushbutton
  local Spacer            = RPTAGS.utils.options.spacer
  local Reset             = RPTAGS.utils.options.reset
  local Frame_Scaler      = RPTAGS.utils.options.frame_scaler
  local Dim_Slider = RPTAGS.utils.options.dimensions_slider;
  local TagPanel          = RPTAGS.utils.options.tagpanel;
  local reqRPUF           = RPTAGS.utils.options.requiresRPUF;
  local collectionBrowser = RPTAGS.utils.options.collectionBrowser;
  local Font              = RPTAGS.utils.options.font;
  local split             = RPTAGS.utils.text.split;
  local listOfAllTags     = RPTAGS.utils.options.listOfAllTags;
  local ifConfig          = RPTAGS.utils.config.ifConfig;
  local Frame_Panel       = RPTAGS.utils.options.frame_panel;
  local LibSharedMedia    = LibStub("LibSharedMedia-3.0");
  local RPUF_Refresh      = RPTAGS.utils.frames.RPUF_Refresh;

  local menu = {
  backdrop  =
  { BLIZZTOOLTIP = loc("BACKDROP_BLIZZTOOLTIP" ),
    THIN_LINE    = loc("BACKDROP_ORIGINAL"     ),
    THICK_LINE   = loc("BACKDROP_THICK_LINE"   ),
    ORIGINAL     = loc("BACKDROP_THIN_LINE"    ), },
  texture   =
  { BAR          = loc("BAR"                   ),
    SKILLS       = loc("SKILLS"                ),
    BLANK        = loc("BLANK"                 ),
    SHADED       = loc("SHADED"                ),
    SOLID        = loc("SOLID"                 ),
    RAID         = loc("RAID"                  ), },
  align     =
  { LEFT         = loc("LEFT"                  ),
    CENTER       = loc("CENTER"                ),
    RIGHT        = loc("RIGHT"                 ), },
  small     =
  { COMPACT      = loc("RPUF_COMPACT"          ),
    ABRIDGED     = loc("RPUF_ABRIDGED"         ),
    THUMBNAIL    = loc("RPUF_THUMBNAIL"        ), },
  large     =
  { COMPACT      = loc("RPUF_COMPACT"          ),
    ABRIDGED     = loc("RPUF_ABRIDGED"         ),
    THUMBNAIL    = loc("RPUF_THUMBNAIL"        ),
    PAPERDOLL    = loc("RPUF_PAPERDOLL"        ),
    FULL         = loc("RPUF_FULL"             ), },
  fontSize =
    { extrasmall = loc("SIZE_EXTRA_SMALL"),
      small = loc("SIZE_SMALL"),
      medium = loc("SIZE_MEDIUM"),
      large = loc("SIZE_LARGE"),
      extralarge = loc("SIZE_EXTRA_LARGE"),
    },
    portraitStyle =
    { STANDARD = "Standard 3D model",
      FROZEN = "Non-animated model",
      FLAT = "Standard 2D model",
    },
    portraitFrameColor =
    { RPCOLOR = "Use the unit's custom [rp:color].",
      FRAMECOLOR = "Use the same border color as the unit frame.",
      NOCOLOR = "Don't change the color of the frame.",
    }
  };


  local function build_portrait_options(hidden, disabled)
    local w =
    { type = "group",
      name = loc("OPT_PORTRAIT"),
      order = source_order(),
      args = {}; 
    };

    w.args.header = 
    { type = "description",
      name = "# " .. loc("OPT_PORTRAIT"),
      order = source_order(),
      dialogControl = "LMD30_Description",
    };

    w.args.instruct =
    { type = "description",
      dialogControl = "LMD30_Description",
      name = loc("OPT_PORTRAIT_I"),
      order = source_order(),
    };

    w.args.portraitStyle =
    { type = "select",
      name = loc("CONFIG_PORTRAIT_STYLE"),
      desc = loc("CONFIG_PORTRAIT_STYLE_TT"),
      order = source_order(),
      values = menu.portraitStyle,
      get = function() return Get("PORTRAIT_STYLE") end,
      set = function(info, value) Set("PORTRAIT_STYLE", value);
             RPUF_Refresh("portrait") end,
      width = "full",
    };

    w.args.portraitBackground =
    { type = "select",
      name = loc("CONFIG_PORTRAIT_BG"),
      desc = loc("CONFIG_PORTRAIT_BG_TT"),
      order = source_order(),
      dialogControl = "LSM30_Background",
      values = LibSharedMedia:HashTable("background"),
      get = function() return Get("PORTRAIT_BG") end,
      set = function(info, value) Set("PORTRAIT_BG", value);
              RPUF_Refresh("portrait") end,
    };

    w.args.spaPort = Spacer();

    w.args.portraitBorder =
    { type = "select",
      name = loc("CONFIG_PORTRAIT_BORDER"),
      desc = loc("CONFIG_PORTRAIT_BORDER_TT"),
      order = source_order(),
      dialogControl = "LSM30_Border",
      values = LibSharedMedia:HashTable("border"),
      get = function() return Get("PORTRAIT_BORDER") end,
      set = function(info, value) Set("PORTRAIT_BORDER", value);
              RPUF_Refresh("portrait") end,
    };

    w.args.portraitFrameColor =
    { type = "select",
      name = loc("CONFIG_PORTRAIT_BORDER_STYLE"),
      desc = loc("CONFIG_PORTRAIT_BORDER_STYLE_TT"),
      order = source_order(),
      width = "full",
      values = menu.portraitFrameColor,
      get = function() return Get("PORTRAIT_BORDER_STYLE") end,
      set = function(info, value) Set("PORTRAIT_BORDER_STYLE", value);
              RPUF_Refresh("portrait") end,
    };

    w.args.header2 =
    { type = "header",
      width = "full",
      name = "## " .. loc("CONFIG_PORTRAIT_TOOLTIP"),
      dialogControl = "LMD30_Description",
      order = source_order(),
    };

    w.args.instruct2 = 
    { type = "description",
      width = "full",
      name = loc("CONFIG_PORTRAIT_TOOLTIP_TT"),
      order = source_order(),
    };

    w.args.current = 
    { type = "input",
      width = "full",
      name = loc("CONFIG_PORTRAIT_TOOLTIP"),
      get = function(self) return Get("PORTRAIT_TOOLTIP") end,
      set = function(info, value) Set("PORTRAIT_TOOLTIP", value) end,
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
          name = function(self) return eval(Get("PORTRAIT_TOOLTIP"), "player", "player") end,
          fontSize = "medium",
        },
      },
    };

    return w;

  end;
  addOptionsPanel("RPUF_Panels",
  { name                = loc("OPT_RPUF_PANELS"),
    order               = source_order(),
    type                = "group",
    args                =
    { -- panel             = Header("rpuf panels", nil, reqRPUF ),
      instruct          = Instruct("rpuf panels", nil, reqRPUF ),
      namePanel         = TagPanel("namepanel",   "name tooltip"),
      infoPanel         = TagPanel("infopanel",   "info tooltip"),
      statusPanel       = TagPanel("statuspanel", "status tooltip"),
      detailPanel       = TagPanel("detailpanel", "detail tooltip"),
      portraitPanel     = build_portrait_options(),
      iconAPanel        = TagPanel("icon 1", "icon 1 tooltip"),
      iconBPanel        = TagPanel("icon 2", "icon 2 tooltip"),
      iconCPanel        = TagPanel("icon 3", "icon 3 tooltip"),
      iconDPanel        = TagPanel("icon 4", "icon 4 tooltip"),
      iconEPanel        = TagPanel("icon 5", "icon 5 tooltip"),
      iconFPanel        = TagPanel("icon 6", "icon 6 tooltip"),
    },
  }); 
  
end);
