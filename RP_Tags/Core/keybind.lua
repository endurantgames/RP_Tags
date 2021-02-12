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

  local loc             = RPTAGS.utils.locale.loc;
  local linkHandler     = RPTAGS.utils.links.handler;
  local registerKeybind = RPTAGS.utils.keybind.register;

  registerKeybind("HELP",    function() linkHandler("opt://help")    end);
  registerKeybind("OPTIONS", function() linkHandler("opt://options") end);
  
-- RPQ ---------------------------------------------------------------------------------------------------------------------------------------------
end);
