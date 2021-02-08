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

local addOnName, addOn = ...;
local Module = RPTAGS.queue:NewModule(addOnName, "rpClient");
local TRP3_API     = TRP3_API;
 
TRP3_API.module.registerModule(
  { -- let trp3 know we exist
    ["name"]        = GetAddOnMetadata("RP_Tags_totalRP3", "Title"),
    ["description"] = GetAddOnMetadata("RP_Tags_totalRP3", "Notes"),
    ["version"]     = GetAddOnMetadata("RP_Tags_totalRP3", "Version"),
    ["id"]          = "RP_Tags_totalRP3",
    ["autoEnable"]  = true 
  }
);

Module:WaitUntil("ADDON_LOAD",
function(self, event)

  local refreshAll   = RPTAGS.utils.frames.refreshAll;
  local getUnitID    = TRP3_API.utils.str.getUnitID;
  local unitIDToInfo = TRP3_API.utils.str.unitIDToInfo;

  TRP3_API.Events.registerCallback(
    TRP3_API.events.REGISTER_DATA_UPDATED,
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
    end
  );  -- end of our callback handler for new data

end);
