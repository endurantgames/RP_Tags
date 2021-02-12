-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 

RPTAGS.queue:WaitUntil("OPTIONS_HELP",
function(self, event, ...)
-- RPQ -----------------------------------------------------------------------------------------------------------------------------
--
  local Options            = RPTAGS.options;
  local Utils              = RPTAGS.utils;
  local Config             = Utils.config;
  local loc                = Utils.locale.loc
  local source_order       = Utils.options.source_order

  local optUtils           = Utils.options;
  local Blank_Line         = optUtils.blank_line
  local Header             = optUtils.header
  local Instruct           = optUtils.instruct
  local Markdown           = optUtils.markdown
  local Pushbutton         = optUtils.pushbutton
  local Recipe             = optUtils.recipe
  local Spacer             = optUtils.spacer
  local Plugins            = optUtils.plugins

  -- ---------------------------------------------------------------------------------------------------------------------------------------------------------------

  local helpSystem         =
  { name                   = loc("PANEL_HELP"),
    order                  = source_order(),
    type                   = "group",
    childGroups            = "tab",
    args                   =
    { intro                =
      { type               = "group",
        name               = loc("OPT_HELP_INTRO"),
        order              = source_order(),
        args               =
        { panel            = Markdown(loc("INTRO_MD")),
        },
      },
      tags                 = Options.taghelp(),
      tagModifiers         = Markdown({ loc("OPT_TAG_MODIFIERS"), loc("TAG_MODIFIERS_MD") }),
      recipes              =
      { name               = loc("OPT_RECIPES"),
        order              = source_order(),
        type               = "group",
        args               =
        { header           = Header("recipes"),
          instruct         = Instruct("recipes"),
          nameTitle        = Recipe("name titles"),
          eyes             = Recipe("eyes"),
          age              = Recipe("age"),
          currently        = Recipe("currently"),
          genderRaceClass  = Recipe("gender race class"),
          target           = Recipe("target"),
          profileSize      = Recipe("profilesize"),
          rpStyle          = Recipe("rp style"),
          friendName       = Recipe("friend name"),
          server           = Recipe("server"),
        },
      },
    },
    plugins             = Plugins("help"),
  };
  
  RPTAGS.options.help = helpSystem;

end);
