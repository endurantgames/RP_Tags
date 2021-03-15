-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 

RPTAGS.queue:WaitUntil("OPTIONS_COLORS",
function(self, event, ...)
-- RPQ -----------------------------------------------------------------------------------------------------------------------------
--
  local Config             = RPTAGS.utils.config;
  local loc                = RPTAGS.utils.locale.loc
  local source_order       = RPTAGS.utils.options.source_order

  local Color_Picker       = RPTAGS.utils.options.color_picker
  local Header             = RPTAGS.utils.options.header
  local Instruct           = RPTAGS.utils.options.instruct
  local Markdown           = RPTAGS.utils.options.markdown
  local Multi_Reset        = RPTAGS.utils.options.multi_reset
  local Reset              = RPTAGS.utils.options.reset
  local Spacer             = RPTAGS.utils.options.spacer

  -- ---------------------------------------------------------------------------------------------------------------------------------------------------------------

  local colorsOptions      =
  { order                  = source_order(),
    type                   = "group",
    name                   = loc("PANEL_COLORS"),
    childGroups            = "tab",
    args                   =
    { instruct             = Instruct("colors"),
      status               =
      { type               = "group",
        name               = loc("OPT_COLORS_STATUS"),
        order              = source_order(),
        args               =
        { headerStatus     = Header("colors status"),
          colorIC          = Color_Picker("ic"),
          colorOOC         = Color_Picker("ooc"),
          colorNPC         = Color_Picker("npc"),
          colorMe          = Color_Picker("ME"),
        },
      },
      gender               =
      { type               = "group",
        name               = loc("OPT_COLORS_GENDER"),
        order              = source_order(),
        args               =
        { headerGender     = Header("colors gender"),
          colorMale        = Color_Picker("male"),
          colorFemale      = Color_Picker("female"),
          colorNeuter      = Color_Picker("neuter"),
          colorThey        = Color_Picker("they", nil, function() return not Config.get("PARSE_GENDER") end),
          disabledNote     =
          { type = "description",
            dialogControl = "LMD30_Description",
            fontSize = "small",
            name = loc("DISABLED_NBCOLOR_MD"),
            order = source_order(),
          },
        },
      },
      comparison           =
      { type               = "group",
        name               = loc("OPT_COLORS_COMPARISON"),
        order              = source_order(),
        args               =
        { headerComparison = Header("colors comparison"),
          colorLessThan    = Color_Picker("lessthan"),
          colorEqualish    = Color_Picker("equalish"),
          colorGreaterThan = Color_Picker("greaterthan"),
        },
      },
      hilite               =
      { type               = "group",
        name               = loc("OPT_COLORS_HILITE"),
        order              = source_order(),
        args               =
        { headerHilite     = Header("colors hilite"),
          colorHilite1     = Color_Picker("hilite 1"),
          colorHilite2     = Color_Picker("hilite 2"),
          colorHilite3     = Color_Picker("hilite 3"),
        },
      },
      default              =
      { type               = "group",
        name               = loc("OPT_COLORS_DEFAULT"),
        order              = source_order(),
        args               =
        { unknown          = Color_Picker("unknown"),
        },
      },
    },
  };

  RPTAGS.options.colors = colorsOptions;

end);
