-- ------------------------------------------------------------------------------
-- RP Tags
-- by Oraibi, Moon Guard (US) server
--
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. To view a copy of the license, visit
--
--     https://creativecommons.org/licenses/by/4.0/

-- KeyBinds: keybinds

local RPTAGS     = RPTAGS;

RPTAGS.queue:WaitUntil("CORE_KEYBIND",
function(self, event, ...)
-- RPQ ---------------------------------------------------------------------------------------------------------------------------------------------

  RPTAGS.utils = RPTAGS.utils or {};
  RPTAGS.utils.keybinds = RPTAGS.utils.keybinds or {};
  
  local loc = RPTAGS.utils.locale.loc;
  
  local function keybind_rptagsOptions()
     -- if not InterfaceOptionsFrame:IsShown() then InterfaceOptionsFrame_Show(); end;
     -- InterfaceOptionsFrame_OpenToCategory(RPTAGS_General_OptionsPanel)
  end;
    
  local function keybind_rptagsHelp()
     -- if not InterfaceOptionsFrame:IsShown() then InterfaceOptionsFrame_Show(); end;
     -- InterfaceOptionsFrame_OpenToCategory(RPTAGS_Main_OptionsPanel)
  end;
  
  RPTAGS.utils.keybinds.rptagsOptions = keybind_rptagsOptions;
  RPTAGS.utils.keybinds.rptagsHelp    = keybind_rptagsHelp;
  
    -- keybindings
  BINDING_HEADER_RPTAGS              = RPTAGS.utils.locale.loc("APP_NAME");
  BINDING_NAME_RPTAGS_HELP           = RPTAGS.utils.locale.loc("KEYBIND_HELP");
  BINDING_NAME_RPTAGS_OPTIONS        = RPTAGS.utils.locale.loc("KEYBIND_OPTIONS");
  
-- RPQ ---------------------------------------------------------------------------------------------------------------------------------------------
end);
