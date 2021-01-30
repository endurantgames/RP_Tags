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
  
  local AceConfig       = LibStub("AceConfig-3.0");
  local AceConfigDialog = LibStub("AceConfigDialog-3.0");
  
  local loc             = RPTAGS.utils.locale.loc;
  
  AceConfig:RegisterOptionsTable(loc("APP_NAME"), RPTAGS.cache.optionsTable);
  RPTAGS.cache.OptionsPanel = AceConfigDialog:AddToBlizOptions(loc("APP_NAME"));
  
end);
