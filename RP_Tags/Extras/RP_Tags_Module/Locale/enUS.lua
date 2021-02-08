-- RP Tags 
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 

local RPTAGS = RPTAGS;
local addOnName, addOn = ...;
local Module = RPTAGS.queue:GetModule(addOnName);

-- This is how you add to the localization.
--
Module:WaitUntil("DATA_LOCALE",
function(self, event, ...)
-- RPQ  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 
  local L = LibStub("AceLocale-3.0"):NewLocale(RPTAGS.CONST.APP_ID, "enUS", true);
  L["OPT_MY_MODULE"]         = "My Nifty Module";
  L["ACTIVATE_MY_MODULE"]    = "Activate My Nifty Module";
  L["ACTIVATE_MY_MODULE_TT"] = "Set a keybinding to activate My Nifty Module."]
  L["MY_MODULE_MD"] =
[====[
# My Nifty Module

This is my module. It's nifty!

Created by [me](mailto:moduleauthor@example.com)!
]====];
-- /RPQ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
end);

