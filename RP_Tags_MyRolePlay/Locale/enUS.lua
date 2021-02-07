-- ------------------------------------------------------------------------------
-- RP Tags 
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. To view a copy of the license, visit
--
--     https://creativecommons.org/licenses/by/4.0/

local addOnName, addOn = ...
local RPTAGS     = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("DATA_LOCALE",
function(self, event, ...)
  local L = LibStub("AceLocale-3.0"):NewLocale(RPTAGS.CONST.APP_ID, "enUS", true);
  L["KEYBIND_IC_OOC"            ] = "Toggle IC/OOC Status";
  L["KEYBIND_MOUSEOVER_OPEN"    ] = "Open Mouseover Profile";
  L["KEYBIND_IC_OOC_TT"         ] = "Set a keybinding to toggle between in character and out of character in MyRolePlay.";
  L["KEYBIND_MOUSEOVER_OPEN_TT" ] = "Set a keybinding to automatically open your mouseover target in MyRolePlay.";
  L["NOTIFY_KEYBIND_IC_OOC"     ] = "You are now ";
end);
