-- RP Tags 
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license.

local RPTAGS = RPTAGS;

RPTAGS.queue:WaitUntil("UTILS_CONFIG",
function(self, event, ...)
-- RPQ ----------------------------------------------------------------------------------------------------------------------------------
  
  RPTAGS.utils.config = RPTAGS.utils.config or {};
  
  local CONST         = RPTAGS.CONST;
  local Utils         = RPTAGS.utils;
  local Config        = Utils.config;
  local Default       = CONST.CONFIG.DEFAULTS;
  local db            = RP_TagsDB.settings;

  local function keyIsValid(key) if not key then return false end;
    if   RP_TagsDB.settings[key]
    then return true else return false 
    end;
  end;

  for key, _ in pairs(Default)
  do  if not db[key] then db[key] = {} end;
      db[key].value   = (db[key].value == nil) and Default[key] or db[key].value;
      db[key].default = Default[key];
      db[key].init    = nil;
  end;
        -- return the value of a config setting
  local function getConfig(key) if not key then return nil; end;
    if   keyIsValid(key)
    then if   RP_TagsDB.settings[key].value ~= nil
         then return RP_TagsDB.settings[key].value 
         else return RP_TagsDB.settings[key].default 
         end;
    else return nil;
    end;
  end;  
  
  local function setConfig(key, value, quiet) if not key then return nil; end;
    local loc = RPTAGS.utils.locale.loc;
    local notify = RPTAGS.utils.text.notify;
    local notifyFmt = RPTAGS.utils.text.notifyFmt;

    if   keyIsValid(key)
    then RP_TagsDB.settings[key].value = value;
         if Config.get("SETTINGS_CHANGE") and not quiet
         then 
              if     type(value) == "boolean"
              then   value = value and loc("TRUE") or loc("FALSE");
              elseif type(value) == "nil"
              then   value = loc("NIL")
              elseif type(value) == "table"
              then   value = loc("TABLE")
              elseif type(value) == "function"
              then   value = loc("FUNCTION")
              elseif type(value) == "string" and key:match("COLOR") and value:match("^%x%x%x%x%x%x$")
              then   value = "|cff" .. value .. "#" .. value .. "|r"
              end;
              notifyFmt(loc("FMT_SETTINGS_CHANGE"), loc("CONFIG_" .. key), value);
         end;
         return value;
    else return nil;
    end; -- if;
  end; -- function
  
  local function resetConfig(key) if not key then return nil; end; 
    if   keyIsValid(key)
    then local value = RP_TagsDB.settings[key].default;
         return setConfig(key, value);
    else return nil;
    end; --if
  end; -- function
  
  local function getDefault(key) if not key then return nil; end;
    if   keyIsValid(key)
    then return RP_TagsDB.settings[key].default or Default[key];
    else return nil;
    end;
  end; -- function
        
  RPTAGS.utils.config.default = getDefault;
  RPTAGS.utils.config.get     = getConfig;
  RPTAGS.utils.config.reset   = resetConfig;
  RPTAGS.utils.config.set     = setConfig;
  RPTAGS.utils.config.valid   = keyIsValid;

  -- /RPQ ----------------------------------------------------------------------------------------------------------------------------------
end);
