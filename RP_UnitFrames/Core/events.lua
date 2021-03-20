local RPTAGS = RPTAGS;
local addOnName, ns = ...;
local Module = RPTAGS.queue:GetModule(addOnName);

RPTAGS.queue:WaitUntil("MODULE_H",
function(self, event, ...)

  local RPUF_Refresh = RPTAGS.utils.frames.RPUF_Refresh;

  RPTAGS.EventsFrame:AddEvent("PLAYER_FOCUS_CHANGED",  function() RPUF_Refresh("focus",  "content"); end);
  RPTAGS.EventsFrame:AddEvent("PLAYER_TARGET_CHANGED", function() RPUF_Refresh("target", "content"); end);
  RPTAGS.EventsFrame:AddEvent("UNIT_TARGET",           function() RPUF_Refresh("all",    "content"); end);
  RPTAGS.EventsFrame:AddEvent(
    "CHAT_MSG_EMOTE", 
    "CHAT_MSG_PARTY", 
    "CHAT_MSG_PARTY_LEADER", 
    "CHAT_MSG_RAID", 
    "CHAT_MSG_RAID_LEADER",
    "CHAT_MSG_RAID_WARNING",
    "CHAT_MSG_SAY",
    "CHAT_MSG_TEXT_EMOTE",
    "CHAT_MSG_WHISPER",
    function (self, event, text, unitID, ...)
      local realmName = GetNormalizedRealmName();

      local function getUnit(unit)
        local unitName, unitRealm = UnitFullName(unit);
        if unitName then return string.format("%s-%s", unitName, unitRealm or realmName) else return "" end;
      end;

      local ufCache = RPTAGS.cache.UnitFrames;
      if unitID and ufCache[unitID]
      then RPUF_Refresh(unitID, "content")
           print("unitID", unitID, "refreshing", unitID);

      elseif unitID == getUnit("target")
      then RPUF_Refresh("target", "content")
           print("unitID", unitID, "refreshing", "target");

      elseif unitID == getUnit("focus")
      then RPUF_Refresh("focus", "content")
           print("unitID", unitID, "refreshing", "focus");

      elseif unitID == getUnit("targettarget")
      then RPUF_Refresh("targettarget", "content")
           print("unitID", unitID, "refreshing", "targettarget");

      end;
    end);
end);

