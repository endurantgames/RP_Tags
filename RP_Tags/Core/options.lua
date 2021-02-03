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
  
  local ACR       = LibStub("AceConfig-3.0");
  local ACD = LibStub("AceConfigDialog-3.0");
  
  local loc             = RPTAGS.utils.locale.loc;
  local addOnName       = RPTAGS.addOnName;
  local APP_NAME        = loc("APP_NAME");
  
  local optionsFrame = {};

  ACR:RegisterOptionsTable(APP_NAME, RPTAGS.cache.optionsTable, nil);
  ACD:AddToBlizOptions(APP_NAME);

end);
