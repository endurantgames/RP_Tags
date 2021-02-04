-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 

RPTAGS.queue:WaitUntil("DATA_OPTIONS",
function(self, event, ...)
-- RPQ -----------------------------------------------------------------------------------------------------------------------------
--
  local Config             = RPTAGS.utils.config;
  local AceMarkdownControl = LibStub("AceMarkdownControl-3.0");
  local loc                = RPTAGS.utils.locale.loc
  local source_order       = RPTAGS.utils.options.source_order

  local Blank_Line         = RPTAGS.utils.options.blank_line
  local Checkbox           = RPTAGS.utils.options.checkbox
  local Color_Picker       = RPTAGS.utils.options.color_picker
  local Common             = RPTAGS.utils.options.common
  local Dropdown           = RPTAGS.utils.options.dropdown
  local Header             = RPTAGS.utils.options.header
  local Instruct           = RPTAGS.utils.options.instruct
  local Markdown           = RPTAGS.utils.options.markdown
  local Multi_Reset        = RPTAGS.utils.options.multi_reset
  local Panel              = RPTAGS.utils.options.panel
  local Pushbutton         = RPTAGS.utils.options.pushbutton
  local Question_Mark      = RPTAGS.utils.options.question_mark
  local Recipe             = RPTAGS.utils.options.recipe
  local Reset              = RPTAGS.utils.options.reset
  local Slider             = RPTAGS.utils.options.slider
  local Spacer             = RPTAGS.utils.options.spacer
  local Textbox            = RPTAGS.utils.options.textbox
  local Textbox_Wide       = RPTAGS.utils.options.textbox_wide
  local Keybind            = RPTAGS.utils.options.keybind

  -- ---------------------------------------------------------------------------------------------------------------------------------------------------------------

  local generalOptions = 
  { order    = source_order(),
    type    = "group",
    name    = loc("OPT_GENERAL"),
    childGroups = "tab",
    args    = 
    { -- panel = Header("general"),
      -- header         = Header("display"),
      instruct       = Instruct("general"),
      loginMessage   = Checkbox("login message"),
      -- changesMessage = Checkbox("changes message" , nil, true),
      -- changesQM      = Question_Mark(loc("CHANGES_MOVED")),
      linebreaks     = Checkbox("linebreaks"),
      parsing        = 
      { type = "group",
        order = source_order(),
        name = loc("OPT_PARSE"),
        args = 
        { headerParse    = Header("parse", 2),
          parseHW        = Checkbox("parse hw"),
          parseGender    = Checkbox("parse gender"),
          parseAge       = Checkbox("parse age"),
          adultGenders   = Checkbox("adult genders"   , nil, function() return not Config.get("PARSE_GENDER") end),
        },
        plugins = RPTAGS.cache.plugins.parse,
      },
      notes          =
      { type = "group",
        order = source_order(),
        name = loc("OPT_NOTES"),
        args = 
        { header   = Header("notes", 2),
          instruct = Instruct("notes"),
          note1          = Textbox_Wide("note 1 string"),
          note2          = Textbox_Wide("note 2 string"),
          note3          = Textbox_Wide("note 3 string"),
        },
        plugins = RPTAGS.cache.plugins.notes,
      },
  
      formats = 
      { type = "group",
        order = source_order(),
        name = loc("OPT_FORMATS"),
        args = 
        { header = Header("formats", 2),
          instruct = Instruct("formats"),
          unitsHeight    = Dropdown("units height"    , nil, function() return not Config.get("PARSE_HW") end),
          unitsWeight    = Dropdown("units weight"    , nil, function() return not Config.get("PARSE_HW") end),
          sizeBuffFmt    = Dropdown("sizebuff fmt"),
          glanceDelim    = Dropdown("glance delim"),
          glancecolon    = Dropdown("glance colon"),
          profileSizeFmt = Dropdown("profilesize fmt"),
          unsupTag       = Dropdown("unsup tag"),
        },
        plugins = RPTAGS.cache.plugins.formats,
      },
      sizes =
      { type = "group",
        order = source_order(),
        name = loc("OPT_TAG_SIZES"),
        args =
        { header           = Header("tag sizes", 2                               ),
          instruct         = Instruct("tag sizes"),

          extraSmall       = Slider("tag size xs", { 5, 1 }, { 50, 200 }, 1, 1.5 ),
          spacerExtraSmall = Spacer(                                             ),
          resetExtraSmall  = Reset( "tag size xs"                                ),

          small            = Slider("tag size s",  { 5, 1 }, { 50, 200 }, 1, 1.5 ),
          spacerSmall      = Spacer(                                             ),
          resetSmall       = Reset( "tag size s"                                 ),

          medium           = Slider("tag size m",  { 5, 1 }, { 50, 200 }, 1, 1.5 ),
          spacerMedium     = Spacer(                                             ),
          resetMedium      = Reset( "tag_size_m"                                 ),

          large            = Slider("tag size l",  { 5, 1 }, { 50, 200 }, 1, 1.5 ),
          spacerLarge      = Spacer(                                             ),
          resetLarge       = Reset( "tag size l"                                 ),

          extraLarge       = Slider("tag size xl", { 5, 1 }, { 50, 200 }, 1, 1.5 ),
          spacerExtraLarge = Spacer(                                             ),
          resetExtraLarge  = Reset( "tag size xl"                                ),
        },
        plugins = RPTAGS.cache.plugins.sizes,
      },
      keybind              =
      { name = loc("OPT_KEYBINDINGS"),
        order    = source_order(),
        type = "group",
        args =
        { header = Header("keybindings"),
          instruct = Instruct("keybindings"),
          options = Keybind("options"),
          help = Keybind("help"),
        },
        plugins = RPTAGS.cache.plugins.keybind,
      }, 
    },
    plugins = RPTAGS.cache.plugins.general,
  };

  local colorsOptions = 
  { order    = source_order(),
    type = "group",
    name = loc("OPT_COLORS"),
    childGroups = "tab",
    args = 
    { -- panel = Header("colors"),
      instruct = Instruct("colors"),
      -- reset = Multi_Reset({ "color unknown"}),
      status = 
      { type             = "group",
        name             = loc("OPT_COLORS_STATUS"),
        order            = source_order(),
        args             = 
        { headerStatus     = Header("colors status"),
          colorIC          = Color_Picker("ic"),
          colorOOC         = Color_Picker("ooc"),
          colorNPC         = Color_Picker("npc"),
          -- reset            = Multi_Reset( { "color_ic", "color_npc", "color_ooc" } ),
        },
      },
      gender           = 
      { type             = "group",
        name             = loc("OPT_COLORS_GENDER"),
        order            = source_order(),
        args             = 
        { headerGender     = Header("colors gender"),
          colorMale        = Color_Picker("male"),
          colorFemale      = Color_Picker("female"),
          colorNeuter      = Color_Picker("neuter"),
          colorThey        = Color_Picker("they", nil, nil, function() return not Config.get("PARSE_GENDER") end),
          -- reset            = Multi_Reset( { "color_male", "color_female", "color_neuter", "color_they" } ),
        }, 
      }, 
      comparison       = 
      { type             = "group",
        name             = loc("OPT_COLORS_COMPARISON"),
        order            = source_order(),
        args             = 
        { headerComparison = Header("colors comparison"),
          colorLessThan    = Color_Picker("lessthan"),
          colorEqualish    = Color_Picker("equalish"),
          colorGreaterThan = Color_Picker("greaterthan"),
          -- reset            = Multi_Reset( { "color_lessthan", "color equalish", "color greaterthan" } ),
        }, 
      },
      hilite           = 
      { type             = "group",
        name             = loc("OPT_COLORS_HILITE"),
        order            = source_order(),
        args             = 
        { headerHilite     = Header("colors hilite"),
          colorHilite1     = Color_Picker("hilite 1"),
          colorHilite2     = Color_Picker("hilite 2"),
          colorHilite3     = Color_Picker("hilite 3"),
          -- reset            = Multi_Reset( { "color hilite 1", "color hilite 2", "color hilite 3" } ),
        }, 
      },
      default = 
      { type = "group",
        name = loc("OPT_COLORS_DEFAULT"),
        order = source_order(),
        args =
        { unknown = Color_Picker("unknown"),
        },
      },
    }, 
    plugins = RPTAGS.cache.plugins.colors,
  };

  local helpSystem = 
  { name                  = loc("OPT_HELP"),
    order    = source_order(),
    type                  = "group",
    childGroups = "tab",
    args                  =
    { intro               = 
      { type = "group",
        name = loc("OPT_HELP_INTRO"),
        order = source_order(),
        args = { panel = Markdown(loc("INTRO_MD")), },
      },
      tags              = Panel.taghelp(),
      tagModifiers       = Markdown({ loc("OPT_TAG_MODIFIERS"), loc("TAG_MODIFIERS_MD") }), 
      recipes               = 
      { name               = loc("OPT_RECIPES"),
        order = source_order(),
        type = "group",
        args = 
        { header = Header("recipes"),
          instruct = Instruct("recipes"),
          nameTitle         = Recipe("name titles"),
          eyes              = Recipe("eyes"),
          age               = Recipe("age"),
          currently         = Recipe("currently"),
          genderRaceClass   = Recipe("gender race class"),
          target            = Recipe("target"),
          profileSize       = Recipe("profilesize"),
          rpStyle           = Recipe("rp style"),
          friendName        = Recipe("friend name"),
          server            = Recipe("server"),
        },
      },
    },
    plugins = RPTAGS.cache.plugins.help,
  };
  
  local aboutScreen             = 
  { name                  = loc("OPT_ABOUT"),
    order    = source_order(),
    type                  = "group",
    childGroups           = "tab",
    args                  =
    { header  = Markdown("## " .. loc("APP_NAME") .. " " .. loc("VERSION") .. " " .. 
                            RPTAGS.metadata.Version),
      version             = Panel.version(),
      changes             = Markdown({ loc("OPT_CHANGES"), loc("CHANGES_MD") }),
      credits             = Markdown({ loc("OPT_CREDITS"), loc("CREDITS_MD") }),
      debuggingCommands   = Markdown({ loc( "OPT_DEBUGGING_CMDS" ), loc( "DEBUGGING_COMMANDS_MD" )  }),
      plugins = RPTAGS.cache.plugins.about,
    },
  };

  local optionsTable = 
  { childGroups = "tree",
    type = "group",
    plugins = RPTAGS.cache.options.top,
    plugins = RPTAGS.cache.plugins.modules,
    args = { 
      general = generalOptions,
      colors = colorsOptions,
      help = helpSystem,
      about = aboutScreen,
    },
  }; 

  RPTAGS.cache.optionsSections = { "colors", "help", "about" };
  RPTAGS.cache.optionsTable = optionsTable;
  
end);
