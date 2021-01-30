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
local Module = RPTAGS.queue:GetModule("totalRP3");

Module:WaitUntil("CORE_KEYBIND",
  function(self, event, ...)

  -- KeyBinds: keybinds
  
  local RPTAGS     = RPTAGS;
  
  local notify = RPTAGS.utils.text.notify;
  local Config = RPTAGS.utils.config;
  local loc    = RPTAGS.utils.locale.loc;
  
  local function keybind_IC_OOC()
      TRP3_API.dashboard.switchStatus();
        local you_are_now = loc("NOTIFY_KEYBIND_IC_OOC") .. "|cff";
        if TRP3_API.dashboard.isPlayerIC()
           then you_are_now = you_are_now .. RPTAGS.utils.config.get("COLOR_IC") .. loc("IS_IC_VERBOSE") .. "|r."
           else you_are_now = you_are_now .. RPTAGS.utils.config.get("COLOR_OOC") .. loc("IS_OOC_VERBOSE") .. "|r."
        end;
  
      notify(you_are_now)
  end;
  
  local function keybind_mouseoverOpen()
    if not UnitExists('mouseover') or not UnitIsPlayer('mouseover') then return nil end;
    local unitID = TRP3_API.utils.str.getUnitID('mouseover');
    SlashCmdList.TOTALRP3("open " .. unitID);
  end;
           
  RPTAGS.utils.keybinds = RPTAGS.utils.keybinds or {};

  RPTAGS.utils.keybinds.ic_ooc        = keybind_IC_OOC;
  RPTAGS.utils.keybinds.mouseoverOpen = keybind_mouseoverOpen;
  
    -- keybindings
  BINDING_HEADER_RPTAGS              = RPTAGS.utils.locale.loc("APP_NAME");
  BINDING_NAME_RPTAGS_IC_OOC         = RPTAGS.utils.locale.loc("KEYBIND_IC_OOC");
  BINDING_NAME_RPTAGS_MOUSEOVER_OPEN = RPTAGS.utils.locale.loc("KEYBIND_MOUSEOVER_OPEN");

end);
