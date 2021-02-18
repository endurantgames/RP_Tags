-- ------------------------------------------------------------------------------
-- RP Tags 
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. To view a copy of the license, visit
--
--     https://creativecommons.org/licenses/by/4.0/

local RPTAGS        = RPTAGS;
local addOnName, ns = ...;
local Module        = RPTAGS.queue:NewModule(addOnName, "rpClient");
local TRP3_API      = TRP3_API;

TRP3_API.module.registerModule(
  { -- let trp3 know we exist
    ["name"]        = GetAddOnMetadata(addOnName, "Title"),
    ["description"] = GetAddOnMetadata(addOnName, "Notes"),
    ["version"]     = GetAddOnMetadata(addOnName, "Version"),
    ["id"]          = addOnName,
    ["autoEnable"]  = true 
  }
);

Module:WaitUntil("MODULE_C",
function(self, event, ...)
  local registerFunction = RPTAGS.utils.modules.registerFunction;

  local function mapTrp3Slash(trp3Param)
    return function(a) SlashCmdList["TOTALRP3"](trp3Param .. " " .. (a or "")); end;
  end;

  local function openTrp3Menu(trp3Menu)
    return 
      function() 
        SlashCmdList["TOTALRP3"]("switch main");
        TRP3_API.navigation.menu.selectMenu(trp3Menu);
      end;
  end;

  registerFunction("totalRP3", "open",       mapTrp3Slash("switch main"       ));
  registerFunction("totalRP3", "help",       mapTrp3Slash( "help"             ));
  registerFunction("totalRP3", "showtarget", mapTrp3Slash("show target"       ));
  registerFunction("totalRP3", "showplayer", mapTrp3Slash("open"              ));
  registerFunction("totalRP3", "setic",      mapTrp3Slash("status ic"         ));
  registerFunction("totalRP3", "setooc",     mapTrp3Slash("status ooc"        ));
  registerFunction("totalRP3", "ic_ooc",     mapTrp3Slash("status toggle"     ));
  registerFunction("totalRP3", "about",      openTrp3Menu("main_00_dashboard" ));
  registerFunction("totalRP3", "changes",    openTrp3Menu("main_00_dashboard" ));
  registerFunction("totalRP3", "options",    openTrp3Menu("main_90_config"    ));

end);
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
