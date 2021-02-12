-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 

RPTAGS.queue:WaitUntil("OPTIONS_ABOUT",
function(self, event, ...)
-- RPQ -----------------------------------------------------------------------------------------------------------------------------
--
  local Config             = RPTAGS.utils.config;
  local loc                = RPTAGS.utils.locale.loc
  local source_order       = RPTAGS.utils.options.source_order

  local Blank_Line         = RPTAGS.utils.options.blank_line
  local Header             = RPTAGS.utils.options.header
  local Instruct           = RPTAGS.utils.options.instruct
  local Markdown           = RPTAGS.utils.options.markdown
  local Spacer             = RPTAGS.utils.options.spacer
  local Plugins            = RPTAGS.utils.options.plugins

  -- ---------------------------------------------------------------------------------------------------------------------------------------------------------------

  local aboutScreen        =
  { name                   = loc("PANEL_ABOUT"),
    order                  = source_order(),
    type                   = "group",
    childGroups            = "tab",
    args                   =
    { header               = Markdown("## " .. loc("APP_NAME") .. " " .. loc("VERSION") .. " " ..  RPTAGS.metadata.Version),
      version              = RPTAGS.options.version,
      changes              = Markdown({ loc("OPT_CHANGES"), loc("CHANGES_MD") }),
      credits              = Markdown({ loc("OPT_CREDITS"), loc("CREDITS_MD") }),
      debuggingCommands    = Markdown({ loc( "OPT_DEBUGGING_CMDS" ), loc( "DEBUGGING_COMMANDS_MD" )  }),
      plugins           = Plugins("about"),
    },
  };

  RPTAGS.options.about = aboutScreen;
  
end);
