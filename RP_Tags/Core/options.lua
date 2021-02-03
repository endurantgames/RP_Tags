-- ------------------------------------------------------------------------------
-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 
-- Utils-Config: Utilities for reading and registering configuration values

local RPTAGS          = RPTAGS;

RPTAGS.queue:WaitUntil("CORE_OPTIONS",
function(self, event, ...)
  
  local ACR       = LibStub("AceConfigRegistry-3.0");
  local ACD = LibStub("AceConfigDialog-3.0");
  
  local loc             = RPTAGS.utils.locale.loc;
  local addOnName       = RPTAGS.addOnName;
  local APP_NAME        = loc("APP_NAME");
  
  local optionsFrame = {};

  local panels = {};

  ACR:RegisterOptionsTable(
        APP_NAME, 
        RPTAGS.cache.optionsTable, 
        false);

  panels.general = ACD:AddToBlizOptions(APP_NAME, APP_NAME, nil , "general");
 
  for _, section in ipairs(RPTAGS.cache.optionsSections)
  do panels[section] = ACD:AddToBlizOptions(
                         APP_NAME,
                         loc("OPT_" .. section:upper()), 
                         panels.general.name,
                         section
                      );
  end;

  RPTAGS.cache.panels = panels;
end);
