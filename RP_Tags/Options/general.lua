-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 

RPTAGS.queue:WaitUntil("OPTIONS_GENERAL",
function(self, event, ...)
-- RPQ -----------------------------------------------------------------------------------------------------------------------------
--
  local Config             = RPTAGS.utils.config;
  local loc                = RPTAGS.utils.locale.loc
  local source_order       = RPTAGS.utils.options.source_order

  local Blank_Line         = RPTAGS.utils.options.blank_line
  local Checkbox           = RPTAGS.utils.options.checkbox
  local Dropdown           = RPTAGS.utils.options.dropdown
  local Header             = RPTAGS.utils.options.header
  local Instruct           = RPTAGS.utils.options.instruct
  local Markdown           = RPTAGS.utils.options.markdown
  local Multi_Reset        = RPTAGS.utils.options.multi_reset
  local Pushbutton         = RPTAGS.utils.options.pushbutton
  local Reset              = RPTAGS.utils.options.reset
  local Slider             = RPTAGS.utils.options.slider
  local Spacer             = RPTAGS.utils.options.spacer
  local Textbox            = RPTAGS.utils.options.textbox
  local Textbox_Wide       = RPTAGS.utils.options.textbox_wide
  local Keybind            = RPTAGS.utils.options.keybind

  -- ---------------------------------------------------------------------------------------------------------------------------------------------------------------

  local generalOptions     =
  { order                  = source_order(),
    type                   = "group",
    name                   = loc("PANEL_GENERAL"),
    childGroups            = "tab",
    args                   =
    { instruct             = Instruct("general"),
      loginMessage         = Checkbox("login message"),
      linebreaks           = Checkbox("linebreaks"),
      parsing              =
      { type               = "group",
        order              = source_order(),
        name               = loc("OPT_PARSE"),
        args               =
        { headerParse      = Header("parse", 2),
          parseHW          = Checkbox("parse hw"),
          parseGender      = Checkbox("parse gender"),
          parseAge         = Checkbox("parse age"),
          adultGenders     = Checkbox("adult genders", nil, function() return not Config.get("PARSE_GENDER") end),
        },
      },
      notes                =
      { type               = "group",
        order              = source_order(),
        name               = loc("OPT_NOTES"),
        args               =
        { header           = Header("notes", 2),
          instruct         = Instruct("notes"),
          note1            = Textbox_Wide("note 1 string"),
          note2            = Textbox_Wide("note 2 string"),
          note3            = Textbox_Wide("note 3 string"),
        },
      },
      formats              =
      { type               = "group",
        order              = source_order(),
        name               = loc("OPT_FORMATS"),
        args               =
        { header           = Header("formats", 2),
          instruct         = Instruct("formats"),
          disabledNote     =
            { type = "description",
              dialogControl = "LMD30_Description",
              name = "Height and weight formats are currently disabled, because you don't have [Parse Height and Weight](setting://general/parse) enabled.",
              hidden = function() return Config.get("PARSE_HW") end,
              order = source_order(),
            },
          unitsHeight      = Dropdown("units height", nil, function() return not Config.get("PARSE_HW") end),
          uhs              = Spacer(),
          unitsWeight      = Dropdown("units weight", nil, function() return not Config.get("PARSE_HW") end),
          uws              = Spacer(),
          sizeBuffFmt      = Dropdown("sizebuff fmt"),
          sbs              = Spacer(),
          glanceDelim      = Dropdown("glance delim"),
          gds              = Spacer(),
          glancecolon      = Dropdown("glance colon"),
          gcs              = Spacer(),
          profileSizeFmt   = Dropdown("profilesize fmt"),
          pss              = Spacer(),
          unsupTag         = Dropdown("unsup tag"),
          uts              = Spacer(),
        },
      },
      keybind              =
      { name               = loc("OPT_KEYBINDINGS"),
        order              = source_order(),
        type               = "group",
        args               =
        { header           = Header("keybindings"),
          instruct         = Instruct("keybindings"),
          options          = Keybind("options"),
          help             = Keybind("help"),
        },
      },
    },
  };

  RPTAGS.options.general = generalOptions;

end);
