-- ------------------------------------------------------------------------------
-- RP Tags 
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. To view a copy of the license, visit
--
--     https://creativecommons.org/licenses/by/4.0/

local addOnName, addOn = ...;
local RPTAGS     = RPTAGS;
local Module = RPTAGS.queue:NewModule(addOnName, "rpClient");

Module:WaitUntil("ADDON_LOAD",
function(self, event, ...)
    local getUnitID = RPTAGS.utils.get.core.unitID;
    local refreshFrame = RPTAGS.utils.tags.refreshFrame;
      table.insert(msp.callback.received, 
        function(unitID)
          RPTAGS.utils.frames.refreshAll();
        end);
   end
);

Module:WaitUntil("before DATA OPTIONS",
function(self, event, ...)
  RPTAGS.utils.modules.registerFunction("MyRolePlay", "options",
    function() InterfaceOptionsFrame_OpenToCategory("MyRolePlay") end);
end);

