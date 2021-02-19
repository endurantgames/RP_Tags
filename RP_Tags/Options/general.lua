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

  local optUtils           = RPTAGS.utils.options;
  local source_order       = optUtils.source_order
  local Blank_Line         = optUtils.blank_line
  local Checkbox           = optUtils.checkbox
  local Dropdown           = optUtils.dropdown
  local Header             = optUtils.header
  local Instruct           = optUtils.instruct
  local Markdown           = optUtils.markdown
  local Multi_Reset        = optUtils.multi_reset
  local Pushbutton         = optUtils.pushbutton
  local Reset              = optUtils.reset
  local Slider             = optUtils.slider
  local Spacer             = optUtils.spacer
  local Textbox            = optUtils.textbox
  local Keybind            = optUtils.keybind
  local Wide               = optUtils.set_width;

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
      parse                =
      { type               = "group",
        order              = source_order(),
        name               = loc("OPT_PARSE"),
        args               =
        { headerParse      = Header("parse", 2),
          parseHW          = Checkbox("parse hw"),
          parseGender      = Checkbox("parse gender"),
          parseAge         = Checkbox("parse age"),
          adultGenders     = Checkbox("adult genders", nil, 
                               function() return not Config.get("PARSE_GENDER") end
                             ),
        },
      },
      notes                =
      { type               = "group",
        order              = source_order(),
        name               = loc("OPT_NOTES"),
        args               =
        { header           = Header("notes", 2),
          instruct         = Instruct("notes"),
          note1            = Wide(Textbox("note 1 string")),
          note2            = Wide(Textbox("note 2 string")),
          note3            = Wide(Textbox("note 3 string")),
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
              name = loc("DISABLED_HW_MD"),
              hidden = function() return Config.get("PARSE_HW") end,
              fontSize = "small",
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
      sizes                =
      { name               = loc("OPT_TAG_SIZES"),
        order              = source_order(),
        type               = "group",
        args               =
        { header           = Header("tag sizes"),
          instruct         = Instruct("tag sizes"),
          ellipses         = Wide(Checkbox("real ellipses")),
          blank            = Blank_Line(),
          extraSmall       = Wide(Slider("tag size xs"), 1.5),
          s1               = Spacer(),
          small            = Wide(Slider("tag size s" ), 1.5),
          s2               = Spacer(),
          medium           = Wide(Slider("tag size m" ), 1.5),
          s3               = Spacer(),
          large            = Wide(Slider("tag size l" ), 1.5),
          s4               = Spacer(),
          extraLarge       = Wide(Slider("tag size xl"), 1.5),
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
