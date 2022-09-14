-- RP Tags 
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license.

local RPTAGS        = RPTAGS;
local addOnName, ns = ...;
local Module        = RPTAGS.queue:GetModule(addOnName);
local target        = GetAddOnMetadata(addOnName, "X-RPQTarget");

if IsAddOnLoaded(target) then target = GetAddOnMetadata(target, "Title") or target end;

Module:WaitUntil("DATA_LOCALE",
function(self, event, ...)
  local L = LibStub("AceLocale-3.0"):NewLocale(RPTAGS.CONST.APP_ID, "enUS", true);
  L["TAG_rp:listen-last_DESC"     ] = "Last thing heard by Listener";
  L["TAG_rp:listen-last_LABEL"    ] = "Last: ";
  L["TAG_rp:listen-count_DESC"    ] = "Count of Listener entries";
  L["TAG_rp:listen-count_LABEL"   ] = "Count: ";
  L["TAG_rp:listen-whisper_DESC"  ] = "Last thing whispered to you";
  L["TAG_rp:listen-whisper_LABEL" ] = "Whisper: ";
  L["TAG_rp:listencolor_DESC"     ] = "Color for last time whispered";
  L["TAG_rp:listen-say_DESC"      ] = "Last thing said";
  L["TAG_rp:listen-say_LABEL"     ] = "Said: ";
  L["TAG_rp:listen-emote_DESC"    ] = "Last thing emoted";
  L["TAG_rp:listen-emote_LABEL"   ] = "Emoted: ";
  L["TAG_rp:listen-party_DESC"    ] = "Last thing said in party or raid";
  L["TAG_rp:listen-party_LABEL"   ] = "Party: ";
  L["TAG_rp:listen-toyou_DESC"    ] = "Last thing said to you.";
  L["TAG_rp:listen-toyou_LABEL"   ] = "Last (to you): ";
  L["OPT_LISTENER_COLORS"         ] = "Listener Colors";
  L["OPT_LISTENER_COLORS_I"       ] = "Choose the delay until the [rp:listencolor] tag changes color.";
  L["CONFIG_LISTENCOLOR_STEP"     ] = "Listener Color Step (in seconds)";
  L["CONFIG_LISTENCOLOR_STEP_TT"  ] = "The amount of time since you last heard someone via Listener for their color to change when you use the [rp:listencolor] tag.";
  L["TAG_GROUP_LISTENER_TITLE"    ] = "Listener";
  L["TAG_GROUP_LISTENER_HELP"     ] = "Tags that provide information from the Listener addon.";
  L["RPQ_TYPE_DATASOURCE"         ] = "|cffdddd00" .. "Data Source Module" .. "|r";
  L["RPQ_TYPE_TARGETOFDATASOURCE" ] = "|cffdddd00" .. "Data Source" .. "|r";

end);

