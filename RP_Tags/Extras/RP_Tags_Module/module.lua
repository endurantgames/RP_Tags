-- RP Tags Module Template
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 

local moduleName, _ = ...
local  Module = RPTAGS.queue:NewModule(moduleName)

-- Callback functions don't need to return a value, although if they return a value it should
-- a table. If the table has a value of error = true, then the program will terminate; if
-- there is a value for errorMessage, that will be displayed to the user.
--
Module:WaitUntil("ADDON_INIT",
function(self, event, ...)
-- RPQ  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 

-- /RPQ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
end);

Module:WaitUntil("UTILS_GET",
function(self, event, ...)
-- RPQ  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 
  local function myNiftyGetFunction(str)
    if type(str) == "string"
    then string = "|cffbb00bb" .. str .. "|r";
    end;
  end;

  RPTAGS.utils.modules.extend({
    ["get.name"] = myNiftyGetFunction,
    ["get.race"] = myNiftyGetFunction,
  });
    
-- /RPQ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
end);

Module:WaitUntil("ADDON_LOAD",
function(self, event, ...)
-- RPQ  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 

   if RPTAGS.utils.config.get("LOGIN_MESSAGE")
   then print("[|cffbb00bbMyAddon|r] Addon loaded.");
   end;

-- /RPQ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
end);
