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
  L["KEYBIND_IC_OOC"]         = "Toggle IC/OOC Status";
  L["KEYBIND_MOUSEOVER_OPEN"] = "Open Mouseover Profile";
  L["KEYBIND_IC_OOC_TT"]    = "Set a keybinding to toggle between in character and out of character in MyRolePlay.";
  L["KEYBIND_MOUSEOVER_OPEN_TT"] = "Set a keybinding to automatically open your mouseover target in MyRolePlay.";
  L["NOTIFY_KEYBIND_IC_OOC"] = "You are now ";
end);

Module:WaitUntil("before DATA_OPTIONS",
function(self, event, ...)
  local build_keybind = RPTAGS.utils.options.keybind;
  local addOptions    = RPTAGS.utils.modules.addOptions;

  addOptions(addOnName, "keybind",
    { ic_ooc = build_keybind("ic_ooc"),
      mouseover_open = build_keybind("mouseover_open") }
    );
end);

Module:WaitUntil("CORE_KEYBIND",
function(self, event, ...)
  local RPTAGS     = RPTAGS;
  
  local notify = RPTAGS.utils.text.notify;
  local Config = RPTAGS.utils.config;
  local loc    = RPTAGS.utils.locale.loc;
  
  local function keybind_IC_OOC()
      if msp.my.FC == "1" -- ooc
         then mrp.Commands.ic()
         else mrp.Commands.ooc()
      end;
  end;
  
  local function keybind_mouseoverOpen()
    if not UnitExists('mouseover') or not UnitIsPlayer('mouseover') then return nil end;
    local unitID = RPTAGS.get.core.unitID('mouseover');
         if not unitID then return nil end;
         SlashCmdList.MYROLEPLAY("show " .. unitID);
    end;
           
  RPTAGS.utils.keybinds = RPTAGS.utils.keybinds or {};

  RPTAGS.utils.keybinds.ic_ooc        = keybind_IC_OOC;
  RPTAGS.utils.keybinds.mouseoverOpen = keybind_mouseoverOpen;
  
    -- keybindings
  BINDING_HEADER_RPTAGS              = RPTAGS.utils.locale.loc("APP_NAME");
  BINDING_NAME_RPTAGS_IC_OOC         = RPTAGS.utils.locale.loc("KEYBIND_IC_OOC");
  BINDING_NAME_RPTAGS_MOUSEOVER_OPEN = RPTAGS.utils.locale.loc("KEYBIND_MOUSEOVER_OPEN");
end);
