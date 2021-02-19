-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license.
-- OnLoad: program initalization
local RPTAGS = RPTAGS;

RPTAGS.queue:WaitUntil("ADDON_LOAD",
function(self, event, ...)
  local Config = RPTAGS.utils.config;
  local notify = RPTAGS.utils.text.notify;
  local version = RPTAGS.CONST.VERSION;
  local split = RPTAGS.utils.text.split;
  local loc = RPTAGS.utils.locale.loc;


  if    Config.get("LOGIN_MESSAGE")
  then  notify(string.format( loc("FMT_APP_LOAD"), 
               version, split(loc("APP_SLASH"), "|")[1]));
       if   Config.get("CHANGES_MESSAGE")
       then notify(loc("CHANGES_MOVED"))
            Config.set("CHANGES_MESSAGE", false);
       end;
  end;

end);
