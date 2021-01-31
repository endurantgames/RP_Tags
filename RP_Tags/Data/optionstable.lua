-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 

RPTAGS.queue:WaitUntil("DATA_OPTIONS",
function(self, event, ...)
-- RPQ -----------------------------------------------------------------------------------------------------------------------------
--
  local Config                  = RPTAGS.utils.config;
  local AceMarkdownControl      = RPTAGS.cache.AceMarkdownControl;
  local loc                     = RPTAGS.utils.locale.loc
  local build_common            = RPTAGS.utils.options.build_common
  local build_checkbox          = RPTAGS.utils.options.build_checkbox
  local build_textbox           = RPTAGS.utils.options.build_textbox
  local build_dropdown          = RPTAGS.utils.options.build_dropdown
  local build_color_picker      = RPTAGS.utils.options.build_color_picker
  local build_frame_scaler      = RPTAGS.utils.options.build_frame_scaler
  local build_dimensions_slider = RPTAGS.utils.options.build_dimensions_slider
  local build_pushbutton        = RPTAGS.utils.options.build_pushbutton
  local build_tagpanel          = RPTAGS.utils.options.build_tagpanel
  local build_reset             = RPTAGS.utils.options.build_reset
  local build_header            = RPTAGS.utils.options.build_header
  local build_instruct          = RPTAGS.utils.options.build_instruct
  local build_markdown          = RPTAGS.utils.options.build_markdown
  local source_order            = RPTAGS.utils.options.source_order
  local build_panel             = RPTAGS.utils.options.panel
  local build_recipe            = RPTAGS.utils.options.build_recipe
  
  -- ---------------------------------------------------------------------------------------------------------------------------------------------------------------
  local optionsTable = { 
    childGroups = "tree",
    type = "group",
    plugins = RPTAGS.cache.options.top,
    args = { 
      generaLOptions = 
      { order   = 1,
        type    = "group",
        name    = loc("OPT_GENERAL"),
        childGroups = "tab",
        args    = 
        { panel = build_header("general"),
          instruct = build_instruct("general"),
          headerDisplay  = build_header("display"),
          loginMessage   = build_checkbox("login message"),
          changesMessage = build_checkbox("changes message" , nil, function() return not Config.get("LOGIN_MESSAGE") end),
          linebreaks     = build_checkbox("linebreaks"),
          parsing        = 
          { type = "group",
            order = source_order(),
            name = loc("OPT_PARSE"),
            args = 
            { headerParse    = build_header("parse"),
              parseHW        = build_checkbox("parse hw"),
              parseGender    = build_checkbox("parse gender"),
              parseAge       = build_checkbox("parse age"),
              adultGenders   = build_checkbox("adult genders"   , nil, function() return not Config.get("PARSE_GENDER") end),
            },
            plugins = RPTAGS.cache.plugins.parse,
          },
          notes          =
          { type = "group",
            order = source_order(),
            name = loc("OPT_NOTES"),
            args = 
            { headerNote     = build_header("notes"),
              note1          = build_textbox("note 1 string"),
              note2          = build_textbox("note 2 string"),
              note3          = build_textbox("note 3 string"),
            },
            plugins = RPTAGS.cache.plugins.notes,
          },
  
          formats = 
          { type = "group",
            order = source_order(),
            name = loc("OPT_FORMATS"),
            args = 
            { headerFormats  = build_header("formats"),
              unitsHeight    = build_dropdown("units height"    , nil, function() return not Config.get("PARSE_HW") end),
              unitsWeight    = build_dropdown("units weight"    , nil, function() return not Config.get("PARSE_HW") end),
              sizeBuffFmt    = build_dropdown("sizebuff fmt"),
              glanceDelim    = build_dropdown("glance delim"),
              glancecolon    = build_dropdown("glance colon"),
              profileSizeFmt = build_dropdown("profilesize fmt"),
              unsupTag       = build_dropdown("unsup tag"),
            },
            plugins = RPTAGS.cache.plugins.formats,
          },
        }, 
        plugins = RPTAGS.cache.plugins.general,
      },
      colorsOptions = 
      { order = 2,
        type = "group",
        name = loc("OPT_COLORS"),
        childGroups = "tab",
        args = 
        { panel = build_header("colors"),
          instruct = build_instruct("colors"),
          unknown = build_color_picker("unknown"),
          reset = build_reset({ "color unknown"}),
          status = 
          { type             = "group",
            childGroups      = "inline",
            name             = loc("OPT_COLORS_STATUS"),
            order            = source_order(),
            args             = 
            { headerStatus     = build_header("colors status"),
              colorIC          = build_color_picker("ic"),
              colorNPC         = build_color_picker("npc"),
              colorOOC         = build_color_picker("ooc"),
              reset            = build_reset( { "color_ic", "color_npc", "color_ooc" } ),
            },
          },
          gender           = 
          { type             = "group",
            childGroups = "inline",
            name             = loc("OPT_COLORS_GENDER"),
            order            = source_order(),
            args             = 
            { headerGender     = build_header("colors gender"),
              colorMale        = build_color_picker("male"),
              colorFemale      = build_color_picker("female"),
              colorNeuter      = build_color_picker("neuter"),
              colorThey        = build_color_picker("they", nil, nil, function() return not Config.get("PARSE_GENDER") end),
              reset            = build_reset( { "color_male", "color_female", "color_neuter", "color_they" } ),
            }, 
          }, 
          comparison       = 
          { type             = "group",
            childGroups = "inline",
            name             = loc("OPT_COLORS_COMPARISON"),
            order            = source_order(),
            args             = 
            { headerComparison = build_header("colors comparison"),
              colorLessThan    = build_color_picker("lessthan"),
              colorEqualish    = build_color_picker("equalish"),
              colorGreaterThan = build_color_picker("greaterthan"),
              reset            = build_reset( { "color_lessthan", "color equalish", "color greaterthan" } ),
            }, 
          },
          hilite           = 
          { type             = "group",
            childGroups = "inline",
            name             = loc("OPT_COLORS_HILITE"),
            order            = source_order(),
            args             = 
            { headerHilite     = build_header("colors hilite"),
              colorHilite1     = build_color_picker("hilite 1"),
              colorHilite2     = build_color_picker("hilite 2"),
              colorHilite3     = build_color_picker("hilite 3"),
              reset            = build_reset( { "color hilite 1", "color hilite 2", "color hilite 3" } ),
            }, 
          },
        }, 
        plugins = RPTAGS.cache.plugins.colors,
      }, 
      plugins = RPTAGS.cache.plugins.modules,
      keyBindings =
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
      helpPanel = 
      { name                  = loc("OPT_RPTAGS_HELP"),
        order                 = 105,
        type                  = "group",
        args                  =
        { helpIntro           =
          { order             = source_order(),
            type              = "description",
            dialogControl     = AceMarkdownControl.description,
            name              = loc("INTRO_MD"),
          },
          helpTags              = build_panel.taghelp(),
          -- helpOptions           = build_markdown( loc( "OPT_OPTIONS"        ), loc( "OPTIONS_MD"            )  ),
          -- helpBindings          = build_markdown( loc( "OPT_KEYBINDINGS"    ), loc( "BINDINGS_MD"           )  ),
          helpTagModifiers       =
          { order             = source_order(),
            type              = "group",
            name              = loc("OPT_TAG_MODIFIERS"),
            childGroups       = "tab",
            args              = 
            { panel           = 
              { order         = source_order(),
                type          = "description",
                name          = loc("TAG_MODIFIERS_MD"),
                dialogControl     = AceMarkdownControl.description,
              },
              modifierGroup   =
              { order         = source_order(),
                name          = loc("OPT_TAG_MODIFIERS"),
                type          = "group",
                args          =
                { helpLabels  = build_markdown(loc("OPT_LABELS"),         loc("LABELS_MD")),
                  helpSizes   = build_markdown(loc("OPT_SIZE_MODIFIERS"), loc("SIZE_MODIFIERS_MD")),
                },
              },
            },
          },
          helpRecipes           = 
          { name               = loc("OPT_RECIPES"),
            order = source_order(),
            type = "group",
            args = 
            { nameTitle         = build_recipe("name titles"),
              eyes              = build_recipe("eyes"),
              age               = build_recipe("age"),
              currently         = build_recipe("currently"),
              genderRaceClass   = build_recipe("gender race class"),
              target            = build_recipe("target"),
              profileSize       = build_recipe("profilesize"),
              rpStyle           = build_recipe("rp style"),
              friendName        = build_recipe("friend name"),
              server            = build_recipe("server"),
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
        { aboutVersion        = build_panel.version(),
          aboutChanges        =
          { order             = source_order(),
            type              = "group",
            name              = loc("OPT_CHANGES"),
            args              =
            { panel           =
              { order         = source_order(),
                type          = "description",
                dialogControl = AceMarkdownControl.description,
                name          = loc("CHANGES_MD")
              },
            },
          },
          aboutCredits        =
          { order             = source_order(),
            type              = "group",
            name              = loc("OPT_CREDITS"),
            args              =
            { panel           =
              { order         = source_order(),
                type          = "description",
                dialogControl = AceMarkdownControl.description,
                name          = loc("CREDITS_MD")
              },
            },
          },
          helpDebuggingCommands = build_markdown( loc( "OPT_DEBUGGING_CMDS" ), loc( "DEBUGGING_COMMANDS_MD" )  ),
          plugins = RPTAGS.cache.plugins.about,
        },
      },
    }, 
  }; 

  RPTAGS.cache.optionsTable = optionsTable;


  
end);
