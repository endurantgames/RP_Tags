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
  local Dimensions_Slider  = RPTAGS.utils.options.dimensions_slider
  local Dropdown           = RPTAGS.utils.options.dropdown
  local Frame_Scaler       = RPTAGS.utils.options.frame_scaler
  local Header             = RPTAGS.utils.options.header
  local Instruct           = RPTAGS.utils.options.instruct
  local Markdown           = RPTAGS.utils.options.markdown
  local Multi_Reset        = RPTAGS.utils.options.multi_reset
  local Panel              = RPTAGS.utils.options.panel
  local Pushbutton         = RPTAGS.utils.options.pushbutton
  local Recipe             = RPTAGS.utils.options.recipe
  local Reset              = RPTAGS.utils.options.reset
  local Slider             = RPTAGS.utils.options.slider
  local Spacer             = RPTAGS.utils.options.spacer
  local Tagpanel           = RPTAGS.utils.options.tagpanel
  local Textbox            = RPTAGS.utils.options.textbox

  
  -- ---------------------------------------------------------------------------------------------------------------------------------------------------------------
  local optionsTable = { 
    childGroups = "tree",
    type = "group",
    plugins = RPTAGS.cache.options.top,
    args = { 
      generaL = 
      { order   = 1,
        type    = "group",
        name    = loc("OPT_GENERAL"),
        childGroups = "tab",
        args    = 
        { panel = Header("general"),
          instruct = Instruct("general"),
          headerDisplay  = Header("display"),
          loginMessage   = Checkbox("login message"),
          changesMessage = Checkbox("changes message" , nil, function() return not Config.get("LOGIN_MESSAGE") end),
          linebreaks     = Checkbox("linebreaks"),
          parsing        = 
          { type = "group",
            order = source_order(),
            name = loc("OPT_PARSE"),
            args = 
            { headerParse    = Header("parse"),
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
            { headerNote     = Header("notes"),
              note1          = Textbox("note 1 string"),
              note2          = Textbox("note 2 string"),
              note3          = Textbox("note 3 string"),
            },
            plugins = RPTAGS.cache.plugins.notes,
          },
  
          formats = 
          { type = "group",
            order = source_order(),
            name = loc("OPT_FORMATS"),
            args = 
            { headerFormats  = Header("formats"),
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
            { header           = Header("tag sizes"                                  ),

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
          },
          keybind              =
          { name = loc("OPT_KEYBINDINGS"),
            order = 104,
            type = "group",
            args =
            { options =
              { name = loc("APP_NAME") .. " Options",
                order = source_order(),
                type = "keybinding",
              },
              help =
              { name = loc("APP_NAME") .. " Help",
                order = source_order(),
                type = "keybinding",
              },
            },
            plugins = RPTAGS.cache.plugins.keybind,
          }, 
        },
        plugins = RPTAGS.cache.plugins.general,
      },
      colors = 
      { order = 2,
        type = "group",
        name = loc("OPT_COLORS"),
        childGroups = "tab",
        args = 
        { panel = Header("colors"),
          instruct = Instruct("colors"),
          unknown = Color_Picker("unknown"),
          reset = Multi_Reset({ "color unknown"}),
          status = 
          { type             = "group",
            childGroups      = "inline",
            name             = loc("OPT_COLORS_STATUS"),
            order            = source_order(),
            args             = 
            { headerStatus     = Header("colors status"),
              colorIC          = Color_Picker("ic"),
              colorNPC         = Color_Picker("npc"),
              colorOOC         = Color_Picker("ooc"),
              reset            = Multi_Reset( { "color_ic", "color_npc", "color_ooc" } ),
            },
          },
          gender           = 
          { type             = "group",
            childGroups = "inline",
            name             = loc("OPT_COLORS_GENDER"),
            order            = source_order(),
            args             = 
            { headerGender     = Header("colors gender"),
              colorMale        = Color_Picker("male"),
              colorFemale      = Color_Picker("female"),
              colorNeuter      = Color_Picker("neuter"),
              colorThey        = Color_Picker("they", nil, nil, function() return not Config.get("PARSE_GENDER") end),
              reset            = Multi_Reset( { "color_male", "color_female", "color_neuter", "color_they" } ),
            }, 
          }, 
          comparison       = 
          { type             = "group",
            childGroups = "inline",
            name             = loc("OPT_COLORS_COMPARISON"),
            order            = source_order(),
            args             = 
            { headerComparison = Header("colors comparison"),
              colorLessThan    = Color_Picker("lessthan"),
              colorEqualish    = Color_Picker("equalish"),
              colorGreaterThan = Color_Picker("greaterthan"),
              reset            = Multi_Reset( { "color_lessthan", "color equalish", "color greaterthan" } ),
            }, 
          },
          hilite           = 
          { type             = "group",
            childGroups = "inline",
            name             = loc("OPT_COLORS_HILITE"),
            order            = source_order(),
            args             = 
            { headerHilite     = Header("colors hilite"),
              colorHilite1     = Color_Picker("hilite 1"),
              colorHilite2     = Color_Picker("hilite 2"),
              colorHilite3     = Color_Picker("hilite 3"),
              reset            = Multi_Reset( { "color hilite 1", "color hilite 2", "color hilite 3" } ),
            }, 
          },
        }, 
        plugins = RPTAGS.cache.plugins.colors,
      }, 
      plugins = RPTAGS.cache.plugins.modules,
      help = 
      { name                  = loc("OPT_RPTAGS_HELP"),
        order                 = 105,
        type                  = "group",
        args                  =
        { intro           =
          { order             = source_order(),
            type              = "description",
            dialogControl     = AceMarkdownControl:New().description,
            name              = loc("INTRO_MD"),
          },
          tags              = Panel.taghelp(),
          -- helpOptions           = Markdown( loc( "OPT_OPTIONS"        ), loc( "OPTIONS_MD"            )  ),
          -- helpBindings          = Markdown( loc( "OPT_KEYBINDINGS"    ), loc( "BINDINGS_MD"           )  ),
          tagModifiers       =
          { order             = source_order(),
            type              = "group",
            name              = loc("OPT_TAG_MODIFIERS"),
            childGroups       = "tab",
            args              = 
            { panel           = 
              { order         = source_order(),
                type          = "description",
                name          = loc("TAG_MODIFIERS_MD"),
                dialogControl     = AceMarkdownControl:New().description,
              },
              modifierGroup   =
              { order         = source_order(),
                name          = loc("OPT_TAG_MODIFIERS"),
                type          = "group",
                args          =
                { helpLabels  = Markdown(loc("OPT_LABELS"),         loc("LABELS_MD")),
                  helpSizes   = Markdown(loc("OPT_SIZE_MODIFIERS"), loc("SIZE_MODIFIERS_MD")),
                },
              },
            },
          },
          recipes               = 
          { name               = loc("OPT_RECIPES"),
            order = source_order(),
            type = "group",
            args = 
            { nameTitle         = Recipe("name titles"),
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
      },
      about                   = 
      { name                  = loc("OPT_ABOUT"),
        order                 = 106,
        type                  = "group",
        childGroups           = "tab",
        args                  =
        { version             = Panel.version(),
          changes             =
          { order             = source_order(),
            type              = "group",
            name              = loc("OPT_CHANGES"),
            args              =
            { panel           =
              { order         = source_order(),
                type          = "description",
                dialogControl = AceMarkdownControl:New().description,
                name          = loc("CHANGES_MD")
              },
            },
          },
          credits             =
          { order             = source_order(),
            type              = "group",
            name              = loc("OPT_CREDITS"),
            args              =
            { panel           =
              { order         = source_order(),
                type          = "description",
                dialogControl = AceMarkdownControl:New().description,
                name          = loc("CREDITS_MD")
              },
            },
          },
          debuggingCommands = Markdown( loc( "OPT_DEBUGGING_CMDS" ), loc( "DEBUGGING_COMMANDS_MD" )  ),
          plugins = RPTAGS.cache.plugins.about,
        },
      },
    }, 
  }; 

  RPTAGS.cache.optionsTable = optionsTable;


  
end);
