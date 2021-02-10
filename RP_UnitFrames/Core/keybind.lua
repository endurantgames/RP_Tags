-- ------------------------------------------------------------------------------
-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. To view a copy of the license, visit
--
--     https://creativecommons.org/licenses/by/4.0/

local addOnNames, addOn = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnNames, "rpClient");

Module:WaitUntil("CORE_KEYBIND",
  function(self, event, ...)

    local RPTAGS = RPTAGS;

    RPTAGS.utils = RPTAGS.utils or {};
    RPTAGS.utils.keybinds = RPTAGS.utils.keybinds or {};

    local notify = RPTAGS.utils.text.notify;
    local Config = RPTAGS.utils.config;
    local loc    = RPTAGS.utils.locale.loc;
    
    local function keybind_disableRPUF()
      Config.set("DISABLE_RPUF", not(Config.get("DISABLE_RPUF")))
      -- RPTAGS.utils.rpuf.allFrames.disable();
    end;
    
    local function keybind_hideInCombat()
      if Config.get("DISABLE_RPUF")
      then notify("ERROR_KEYBIND_NO_RPUF")
      else Config.set("RPUF_HIDE", not(Config.get("RPUF_HIDE")))
           -- RPTAGS.utils.rpuf.allFrames.visibility();
      end;
    end;
    
    local function keybind_lockFrames()
      if Config.get("DISABLE_RPUF")
      then notify("ERROR_KEYBIND_NO_RPUF")
      else Config.set("LOCK_FRAMES", not(Config.get("LOCK_FRAMES")))
           -- RPTAGS.utils.rpuf.allFrames.lock();
      end;
    end;
    
    local function keybind_tagEditor()
      if     Config.get("DISABLE_RPUF")
      then   notify("ERROR_KEYBIND_NO_RPUF")
      -- elseif RPTAGS_TagEdit:IsVisible()
      -- then   notify("NOTIFY_KEYBIND_TAG_EDITOR_OPEN")
      -- elseif RP_TagsDB.editor and RP_TagsDB.editor.last 
      -- then   RPTAGS.utils.rpuf.tags.edit(RP_TagsDB.editor.last)
      --        notify("NOTIFY_KEYBIND_TAG_EDITOR")
      -- else   notify("ERROR_KEYBIND_TAG_EDITOR")
      --        InterfaceOptionsFrame_Show(); InterfaceOptionsFrame_OpenToCategory(RPTAGS_Tags_OptionsPanel)
      end;    
    end;
    
    RPTAGS.utils.keybinds.hideInCombat  = keybind_hideInCombat;
    RPTAGS.utils.keybinds.tagEditor     = keybind_tagEditor;
    RPTAGS.utils.keybinds.lockFrames    = keybind_lockFrames;
    RPTAGS.utils.keybinds.disableRPUF   = keybind_disableRPUF;
    
      -- keybindings
    BINDING_NAME_RPTAGS_DISABLE_RPUF   = RPTAGS.utils.locale.loc("KEYBIND_DISABLE_RPUF");
    BINDING_NAME_RPTAGS_HIDE_IN_COMBAT = RPTAGS.utils.locale.loc("KEYBIND_HIDE_IN_COMBAT");
    BINDING_NAME_RPTAGS_LOCK_FRAMES    = RPTAGS.utils.locale.loc("KEYBIND_LOCK_FRAMES");
    BINDING_NAME_RPTAGS_TAG_EDITOR     = RPTAGS.utils.locale.loc("KEYBIND_TAG_EDITOR");  
 end
);

