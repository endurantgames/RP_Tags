-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 

local RPTAGS     = RPTAGS;
RPTAGS.queue:WaitUntil("UTILS_TEXT",
function(self, event, ...)
  
  RPTAGS.utils      = RPTAGS.utils or {};
  RPTAGS.utils.text = RPTAGS.utils.text or {};
  RPTAGS.cache      = RPTAGS.cache or {};
  local Utils       = RPTAGS.utils;
  local Cache       = RPTAGS.cache;
  local loc         = Utils.locale.loc;
  local Config      = Utils.config;

  local function notSupported()       
    return "|cff" .. Config.get("COLOR_UNKNOWN") .. Config.get("UNSUP_TAG") .. "|r" 
  end;

  local function dontChangeTheColor() return "" end;

  local function iconNotSupported()   
    if Config.get("UNSUP_TAG") == "" 
    then return "" 
    else return "|TInterface\\RAIDFRAME\\ReadyCheck-NotReady:0|t" end; 
  end;

  -- Utilities available under RPTAGS.utils.text
  --
  RPTAGS.utils.text.unsup        = notSupported;
  RPTAGS.utils.text.unsupcolor   = dontChangeTheColor;
  RPTAGS.utils.text.unsupicon    = iconNotSupported;

end);
