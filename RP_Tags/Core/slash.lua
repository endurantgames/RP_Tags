-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license.

local RPTAGS     = RPTAGS;

RPTAGS.queue:WaitUntil("CORE_SLASH",
function(self, event, ...)

  local CONST       = RPTAGS.CONST;
  local Utils       = RPTAGS.utils;
  local Cache       = RPTAGS.cache;
  local loc         = Utils.locale.loc;
  local notify      = Utils.text.notify;
  local notifyFmt   = Utils.text.notifyFmt;
  local sliceUp     = Utils.text.sliceUp;
  local split       = Utils.text.split;
  local tc          = Utils.text.titlecase;
  local linkHandler = Utils.links.handler;
  local slashes     = split(loc("APP_SLASH"), "|");
  local default     = "opt://about";

  for   i, slash_cmd in ipairs(slashes) 
  do    _G["SLASH_RPTAGS" .. i] = "/" .. slash_cmd 
  end;

  Cache.slash           = Cache.slash or {};
  Cache.slash.slashCmds = slashes;
  Cache.slash.slashCmd  = slashes[1];
  
  local keys = {}; 
  for k, _ in pairs(CONST.UIPANELS) 
  do  if   not k:match("_")
      then tinsert(keys, loc("SLASH_" .. k:upper())) 
      end;
  end;
  Cache.slash.uniq, Cache.slash.ambig = sliceUp(keys);

  SlashCmdList["RPTAGS"] =
    function(str)
      local  cmd, params = str:match("(%S+)%s*(.*)$");
      if     cmd == nil then linkHandler(default);
      else   local  uniq, ambig = Cache.slash.uniq[cmd], Cache.slash.ambig[cmd];
             if     ambig
             then   local poss = split(ambig, "|")
                    local last = table.remove(poss);
                    notifyFmt(loc("FMT_AMBIGUOUS_RESULT"), 
                      tc(table.concat(poss, ", ")) .. (#poss > 1 and ", " or ""),
                      tc(last));
             elseif uniq == "commands"
             then   notify(loc("SLASH_COMMAND_LIST"))
             elseif uniq == "open"
             then   linkHandler(params)
             elseif uniq and CONST.UIPANELS[uniq]
             then   linkHandler(CONST.UIPANELS[uniq]);
             else   notifyFmt(loc("FMT_UNKNOWN_SLASH"), cmd, Cache.slash.slashCmd)
             end;
      end;
    end;
  
end);
