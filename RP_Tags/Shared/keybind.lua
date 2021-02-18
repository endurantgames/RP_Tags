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

  local loc                = RPTAGS.utils.locale.loc;
  local notify             = RPTAGS.utils.text.notify
  local fmt                = string.format;
  RPTAGS.cache.keybind     = RPTAGS.cache.keybind or {};
  RPTAGS.cache.keybind.run = RPTAGS.cache.keybind.run or {};
  RPTAGS.utils.keybind     = RPTAGS.utils.keybind or {};
  local AceConfigRegistry  = LibStub("AceConfigRegistry-3.0");

  local function registerKeyBind(keybind, func)
    RPTAGS.cache.keybind.run[keybind] = func;
    _G["BINDING_NAME_RPTAGS_" .. keybind] = loc("KEYBIND_" .. keybind);
  end;

  local function runKeyBind(keybind)
    local func = RPTAGS.cache.keybind.run[keybind];
    if func then func() end;
  end;

  local function getKeyBindKey(keybind, i)
    local allKeys = { GetBindingKey("RPTAGS_" .. keybind) };
    if i then return allKeys[i] else return allKeys; end;
  end;

  local function getKeyBindList(keybind)
    local list = {};
    for k, _ in pairs(RPTAGS.cache.keybind.run)
    do  table.insert(list, k);
    end;
    return list;
  end;

  local POPUP = "RPTAGS_KEYBIND_CONFIRM";

  StaticPopupDialogs[POPUP] =
  { button1      = YES,
    button2      = NO,
    hideOnEscape = 1,
    timeout      = 0,
    whileDead    = 1,
    OnCancel     = function(self) notify("Keybinding cancelled.") end,
    OnAccept     = 
      function(self) 
        local keyCache = RPTAGS.cache.keybind;
        SetBinding(keyCache.key, keyCache.binding, GetCurrentBindingSet());
        SaveBindings(GetCurrentBindingSet());
          notify("Keybinding [[" .. keyCache.name .. "]] set to [[[" ..  keyCache.key .. "]]].");
        self:Hide();
        RPTAGS.cache.keybind.key     = nil;
        RPTAGS.cache.keybind.binding = nil;
        RPTAGS.cache.keybind.name    = nil;
        AceConfigRegistry:NotifyChange(loc("APP_NAME"));
      end,
  };

  local function setKeyBindKey(keybind, key)
    local existingBind = GetBindingByKey(key);
    if    existingBind  and existingBind ~= "RPTAGS_" .. keybind
    then  local bindName = _G["BINDING_NAME_" .. existingBind] or existingBind;
          StaticPopupDialogs[POPUP].text = fmt(loc("FMT_KEYBIND_WARNING"), existingBind);
          RPTAGS.cache.keybind.key     = key;
          RPTAGS.cache.keybind.binding = "RPTAGS_" .. keybind;
          RPTAGS.cache.keybind.name    = loc("KEYBIND_" .. keybind);
          StaticPopup_Show(POPUP);
    else  SetBinding(key, "RPTAGS_" .. keybind, GetCurrentBindingSet());
          SaveBindings(GetCurrentBindingSet());
          notify(fmt(loc("FMT_KEYBIND_SET"), key, keybind));
          AceConfigRegistry:NotifyChange(loc("APP_NAME"));
    end;
  end;

  local function clearKeyBind(key)
    if not key then return nil end;
    SetBinding(key, nil, GetCurrentBindingSet());
    SaveBindings(GetCurrentBindingSet());
    AceConfigRegistry:NotifyChange(loc("APP_NAME"));
    notify(fmt(loc("FMT_KEYBIND_CLEARED"), key));
  end;

  RPTAGS.utils.keybind.get      = getKeyBindKey;
  RPTAGS.utils.keybind.set      = setKeyBindKey;
  RPTAGS.utils.keybind.register = registerKeyBind;
  RPTAGS.utils.keybind.run      = runKeyBind;
  RPTAGS.utils.keybind.list     = getKeyBindList;
  RPTAGS.utils.keybind.clear    = clearKeyBind;

-- RPQ ----------------------------------------------------------------------------------------------------------
end);

