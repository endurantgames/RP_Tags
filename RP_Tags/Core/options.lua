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
  
  local ACR          = LibStub("AceConfigRegistry-3.0");
  local ACD          = LibStub("AceConfigDialog-3.0");
  local loc          = RPTAGS.utils.locale.loc;
  -- local addOnName    = RPTAGS.addOnName;
  local APP_NAME     = loc("APP_NAME");
  local optionsFrame = {};
  local panels       = {};
  local order        = RPTAGS.cache.options.optionsOrder;

  local optionsTable =
  { type = "group",
    childGroups = "tree",
    args = {};
  };
  
  for i, panelName in ipairs(order)
  do optionsTable.args[panelName] = RPTAGS.options[panelName];
  end;

  ACR:RegisterOptionsTable(APP_NAME, optionsTable, false);
  
  local mainPanel = table.remove(order, 1);
  panels[mainPanel] = ACD:AddToBlizOptions(APP_NAME, APP_NAME, nil , mainPanel);
 
  for _, section in ipairs(order)
  do  panels[section] = 
        ACD:AddToBlizOptions( 
          APP_NAME,
          loc("PANEL_" .. section:upper()), 
          panels[mainPanel].name, 
          section
        );
  end;

  RPTAGS.cache.panels = panels;
end);
