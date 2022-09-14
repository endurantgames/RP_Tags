-- RP Tags 
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 

local RPTAGS        = RPTAGS;
local addOnName, ns = ...;
local Module        = RPTAGS.queue:GetModule(addOnName);

-- This is how you add to the localization.
--
Module:WaitUntil("DATA_LOCALE",
function(self, event, ...)
-- RPQ  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 
  local L                               = LibStub("AceLocale-3.0"):NewLocale(RPTAGS.CONST.APP_ID, "enUS", true);
  local elixir                          = "Elixir of Tongues";
  L["OPT_CROSSRP"]                      = "CrossRP";
  L["ELIXIR_OF_TONGUES"]                = elixir;
  L["TAG_GROUP_CROSSRP_TITLE"]          = "CrossRP";
  L["TAG_GROUP_CROSSRP_HELP"]           = "These tags can be used to check for the presence of the " .. exlir .. " buff.";
  L["TAG_rp:crossrp-elixir_DESC"]       = "Whether or not the unit has an " .. elixir .. " buff.";
  L["TAG_rp:crossrp-elixir_LABEL"]      = "CrossRP Buff: ";
  L["TAG_rp:crossrp-elixir-icon_DESC"]  = "An icon if the unit has an " .. elixir .. " buff.";
  L["TAG_rp:crossrp-elixir-time_LABEL"] = "CrossRP Buff Time: ";
  L["TAG_rp:crossrp-elixir-time_DESC"]  = "The amount of time remaining on the unit's " .. elixir .. " buff.";
  L["CROSSRP_MD"] =
[====[
# CrossRP dataSource Module

This dataSource Module adds tags that look for, and note the duration of, the Elixir of Tongues buff.

Created by [Oraibi](mailto:oraibi@spindrift.games).
]====];
-- /RPQ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
end);

