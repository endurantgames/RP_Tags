-- ------------------------------------------------------------------------------
-- RP Tags 
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. To view a copy of the license, visit
--
--     https://creativecommons.org/licenses/by/4.0/

local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:NewModule("totalRP3", "rpClient");

Module:WaitUntil("ADDON_LOAD",
  function(self, event, ...) 
    local TRP3_API     = TRP3_API;
    local loc          = RPTAGS.utils.locale.loc;
  
    local Register     = { addon = TRP3_API.module.registerModule, callback = TRP3_API.Events.registerCallback, };
    local refreshAll   = RPTAGS.utils.tags.refreshAll;
    local getUnitID    = TRP3_API.utils.str.getUnitID;
    local unitIDToInfo = TRP3_API.utils.str.unitIDToInfo;
    
    TRP3_API.module.registerModule(
      { -- let trp3 know we exist and set up our callback for new profile received
        ["name"]        = string.format(loc("FMT_APP_NAME"), loc("APP_NAME"), loc("APP_VERSION_MODE")),
        ["description"] = 'Alternate friendslist display for roleplayers',
        ["version"]     = loc("APP_VERSION"),
        ["id"]          = loc("APP_ID"),
        ["minVersion"]  = 3,
        ["autoEnable"]  = true,
        ["onStart"]     = 
          function() 
            Register.callback(TRP3_API.events.REGISTER_DATA_UPDATED,
              function(unitID)
                if not unitID then return end
                -- we're going to listen for trp3 update event and make our unitframes update when it happens
                local unit_name, _ = unitIDToInfo(unitID);
                if   getUnitID("target")       == unitID or 
                     getUnitID("player")       == unitID or 
                     getUnitID("focus")        == unitID or 
                     getUnitID("targettarget") == unitID or
                     UnitInRaid(unitID)                  or 
                     UnitInRaid(unit_name)               or
                     UnitInParty(unitID)                 or 
                     UnitInParty(unit_name)  
                then refreshAll() 
                end; -- if 
              end);  -- end of our callback handler for new data
            end -- of the onStart function
      }
    ); -- closes the module registration table
  end
);
