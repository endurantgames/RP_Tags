-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 

local RPTAGS = RPTAGS;

RPTAGS.queue:WaitUntil("UTILS_KEYBIND",
function(self, event, ...)
-- RPQ ----------------------------------------------------------------------------------------------------------

  local loc = RPTAGS.utils.locale.loc;
  RPTAGS.cache.keybinds = RPTAGS.cache.keybinds or {};
  BINDING_HEADER_RPTAGS = loc("APP_NAME");

  local function runKeybind(keybind, ...)
    return RPTAGS.cache.keybinds[keybind] and RPTAGS.cache.keybinds[keybind].func(...) or nil;
  end;

  local function registerKeybind(keybind, func)
    local bind = {};
    bind.func = func;
    _G["BINDING_NAME_RPTAGS_" .. keybind:upper()] = loc("KEYBIND_" .. keybind:upper());
    RPTAGS.cache.keybinds[keybind] = bind;
  end;

  local function getKeybindKey(keybind, i)
    i = i or 1;
    local key1, key2 = GetBindingKey(keybind)
    return i == 2 and key2 or key1;
  end;

  local POPUP = "RPTAGS_KEYBIND_CONFIRM";

  StaticPopupDialogs[POPUP] =
  { text = "This will erase the binding for " .. data.curr .. ". Are you sure you want to do that?",
    button1 = YES,
    button2 = NO,
    OnAccept = function(self) end,
    OnCancel = function(self) end,
    OnHide = function(self) end,
    hideOnEscape = 1,
    timeout = 0,
    whileDead = 1,
  };

  local function setKeybindKey(keybind, key, mode)
  end;

  RPTAGS.utils.keybind = RPTAGS.utils.keybind or {};
  RPTAGS.utils.keybind.register = registerKeybind;
  RPTAGS.utils.keybind.run = runKeybind;

-- RPQ ----------------------------------------------------------------------------------------------------------
end);

