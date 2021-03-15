-- RP Tags 
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International (CC BY 4.0) license.

local rpTagsVersion = "9.0.5";

local RPTAGS = RPTAGS;
local addOnName, ns = ...;

if not GetAddOnMetadata("RP_Tags", "Version"):match("^" .. rpTagsVersion)
then print(addOnName .. " requires at least version " .. rpTagsVersion .. " of rpTags.")
     error();
end;

RPTAGS.queue:NewModuleType("dataSource");
local Module = RPTAGS.queue:NewModule(addOnName, "dataSource");

Module:WaitUntil("UTILS_GET",
function(self, event, ...)

  local Main = _G["ListenerAddon"];

  local name = RPTAGS.utils.get.name;
  local Config = RPTAGS.utils.config;

  local function isParty(line)
     return line.e == "PARTY"         or line.e == "PARTY_LEADER"
         or line.e == "INSTANCE_CHAT" or line.e == "INSTANCE_CHAT_LEADER"
         or line.e == "RAID"          or line.e == "RAID_LEADER"
         or line.e == "RAID_WARNING"
  end;

  local function isEmote(line)         return line.e == "EMOTE" or  line.e == "TEXT_EMOTE" end;
  local function isEmotedSay(line)     return line.e == "EMOTE" and line.e:find("\".-\""); end;
  local function isSay(line)           return line.e == "SAY"   or  isEmotedSay(line)      end;
  local function isNamelessEmote(line) return line.e == "EMOTE";                           end;
  local function isWhisper(line)       return line.e == "WHISPER"                          end;

  local function isAnyOfTheAbove(line)
    return isWhisper(line) or isParty(line) or isSay(line) or isEmote(line)
  end;

  local function isToMe(line)
    return line.m:find( UnitName('player') )
        or line.m:find( name('player') )
        or line.m:find( RPTAGS.utils.get.nick('player') )
        or line.m:find( Config.get("ME") )
  end;

  local function isTextEmoteToMe(line)
    return line.e == "TEXT_EMOTE"
       and line.m:find( "you")
       and not ( line.m:find("orders you to open fire.") or
                 line.m:find("asks you to wait.") or
                 line.m:find("tells you to attack") or
                 line.m:find("motions for you to follow.") or
                 line.m:find("looks at you with crossed eyes")
               )
  end;

  local function msg(line, u, quotedOnly)
    return (line.e == "EMOTE" and (name(u) .. " ") or "")
           .. line.m:match(quotedOnly and "\"(.-)\"" or "(.+)")
  end;

  local function listenerCount(u)
    local count = 0;
    if    Main.chat_history[ UnitName(u) ]
    then  for _, line in ipairs( Main.chat_history[ UnitName(u) ] )
          do count = count + ( isAnyOfTheAbove(line) and 1 or 0 )
         end;
    end;
    return count;
  end;

  local function listenerLast(u)
    if listenerCount(u) > 0
    then local history = Main.chat_history[ UnitName(u) ];
         for i = #history, 1, -1
         do if isAnyOfTheAbove(history[i]) then return msg(history[i], u) end;
         end;
    end;
    return ""
  end;

  local function listenerWhisper(u)
    if listenerCount(u) > 0
    then local history = Main.chat_history[ UnitName(u) ];
          for i = #history, 1, -1
          do  if isWhisper(history[i]) then return msg(history[i]) end;
          end;
     end;
     return "";
  end;

  local function listenerSay(u)
    if listenerCount(u) > 0
    then local history = Main.chat_history[ UnitName(u) ];
         for i = #history, 1, -1
         do  if   isSay(history[i]) 
             then return msg(history[i], nil, isEmotedSay(history[i]));
             end;
         end;
    end;
    return "";
  end;

  local function listenerEmote(u)
    if listenerCount(u) > 0
    then local history = Main.chat_history[ UnitName(u) ];
         for i = #history, 1, -1
         do  if isEmote(history[i]) then return msg( history[i], u) end;
         end;
    end;
    return "";
  end;

  local function listenerToYou(u)
    if listenerCount(u) > 0
    then local history = Main.chat_history[ UnitName(u) ];
         for i = #history, 1, -1
         do  if isSay( history[i] )           and isToMe( history[i] )
             or isNamelessEmote( history[i] ) and isToMe( history[i] )
             or isParty( history[i] )         and isToMe( history[i] )
             or isWhisper( history[i] )
             or isTextEmoteToMe( history[i] ) 
             then return msg( history[i], u, isEmotedSay(history[i]) )
             end;
         end;
    end;
    return "";
  end;

  local function listenerParty(u)
    local count = listenerCount(u);
    if count > 0
    then local history = Main.chat_history[ UnitName(u) ];
         for i = #history, 1, -1
         do  if isParty( history[i] ) then return msg( history[i]) end;
         end;
    end;
    return "";
  end;

  local function listenerColor(u)
    local count = listenerCount(u);
    if count > 0
    then local last = Main.chat_history[ UnitName(u) ][ count ];
         local Color = RPTAGS.utils.color;
         local hue = Color.redToGreenHue( 
                       time() - last.t, 
                       0, 
                       Config.get("LISTENCOLOR_STEP") * 6,
                       true  -- invert colors green to red
                       );
         local r, g, b = Color.hsvToRgb(hue, 1, 1, 1);
         return "|cff" .. Color.integersToColor(r, g, b);
    end;
    return "";
  end;

  RPTAGS.utils.get.listener = 
  {  last    = listenerLast,
     count   = listenerCount,
     whisper = listenerWhisper,
     party   = listenerParty,
     say     = listenerSay,
     emote   = listenerEmote,
     toyou   = listenerToYou,
     color   = listenerColor,
  };

end);

Module:WaitUntil("DATA_CONST",
function(self, event, ...) RPTAGS.CONST.CONFIG.LISTENCOLOR_STEP = 5; end);

Module:WaitUntil("before OPTIONS_COLORS",
function(self, event, ...)

  local loc = RPTAGS.utils.locale.loc;
  local Config = RPTAGS.utils.config;

  RPTAGS.utils.modules.addOptions(addOnName, "colors",
    { listenerColors =
      { type = "group",
        order = 1000,
        name = loc("OPT_LISTENER_COLORS"),
        args =
        { header =
          { type = "description",
            name = "## " .. loc("OPT_LISTENER_COLORS"),
            dialogControl = "LMD30_Description",
            order = 1,
            width = "full",
          },
          instruct =
          { type = "description",
            name = "## " .. loc("OPT_LISTENER_COLORS_I"),
            dialogControl = "LMD30_Description",
            order = 2,
            width = "full",
          },
          stepSize =
          { type = "range",
            name = loc("CONFIG_LISTENCOLOR_STEP"),
            desc = loc("CONFIG_LISTENCOLOR_STEP_TT"),
            order = 3,
            width = 1.5,
            min = 1,
            max = 30,
            step = 1,
            get = function() return Config.get("LISTENCOLOR_STEP") end,
            set = function(info, value) Config.set("LISTENCOLOR_STEP", value) end,
          },
        },
      },
    });

end);

Module:WaitUntil("DATA_TAGS",
function(self, event, ...)
  local Get = RPTAGS.utils.get.listener;
  local loc = RPTAGS.utils.locale.loc;

  RPTAGS.utils.modules.insertTagGroup(
    { key = "LISTENER",
      title = loc("TAG_GROUP_LISTENER_TITLE"),
      help = loc("TAG_GROUP_LISTENER_HELP"),
      tags =
      { 
        { name = "rp:listen-last",
          alias = { "rp:listen", "rp:listener", "rp:listener-last" },
          label = loc("TAG_rp:listen-last_LABEL"),
          desc = loc("TAG_rp:listen-last_DESC"),
          method = Get.last,
          extraEvents = "CHAT_MSG_SAY CHAT_MSG_EMOTE CHAT_MSG_TEXT_EMOTE CHAT_MSG_WHISPER",
          size = true,
        },
        { name = "rp:listen-count",
          alias = { "rp:listener-count" },
          label = loc("TAG_rp:listen-count_LABEL"),
          desc = loc("TAG_rp:listen-count_DESC"),
          extraEvents = "CHAT_MSG_SAY CHAT_MSG_EMOTE CHAT_MSG_TEXT_EMOTE CHAT_MSG_WHISPER",
          method = Get.count,
        },
        { name = "rp:listen-emote",
          alias = { "rp:listener-emote", "rp:listen-emoted", "rp:listener-emoted", "rp:emoted" },
          label = loc("TAG_rp:listen-emote_LABEL"),
          desc = loc("TAG_rp:listen-emote_DESC"),
          method = Get.emote,
          extraEvents = "CHAT_MSG_EMOTE CHAT_MSG_TEXT_EMOTE",
          size = true,
        },
        { name = "rp:listen-say",
          alias = { "rp:listener-say", "rp:listen-said", "rp:listener-said", "rp:said" },
          label = loc("TAG_rp:listen-say_LABEL"),
          desc = loc("TAG_rp:listen-say_DESC"),
          method = Get.say,
          extraEvents = "CHAT_MSG_SAY CHAT_MSG_EMOTE",
          size = true,
        },
        { name = "rp:listen-party",
          alias = { "rp:listener-party", "rp:listen-raid", "rp:listener-raid", },
          label = loc("TAG_rp:listen-party_LABEL"),
          desc = loc("TAG_rp:listen-party_DESC"),
          method = Get.party,
          extraEvents = "CHAT_MSG_PARTY CHAT_MSG_PARTY_LEADER CHAT_MSG_RAID CHAT_MSG_RAID_LEADER CHAT_MSG_RAID_WARNING CHAT_MSG_INSTANCE_CHAT CHAT_MSG_INSTANCE_CHAT_LEADER",
          size = true,
        },
        { name = "rp:listen-toyou",
          alias = { "rp:listen-you", "rp:listen-to-me",
                    "rp:listener-to-you", "rp:listener-toyou", "rp:listener-you", 
                    "rp:toyou", "rp:to-me",
                    "rp:listen-tome", "rp:listen-me", "rp:listen-to-me",
                    "rp:listener-to-me", "rp:listener-tome", "rp:listener-me", 
                    "rp:tome", "rp:to-me" },
          label = loc("TAG_rp:listen-toyou_LABEL"),
          desc = loc("TAG_rp:listen-toyou_DESC"),
          method = Get.toyou,
          extraEvents = "CHAT_MSG_SAY CHAT_MSG_EMOTE CHAT_MSG_TEXT_EMOTE",
          size = true,
        },
        { name = "rp:listen-whisper",
          alias = { "rp:listener-whisper", "rp:listener-tell", "rp:listen-tell", "rp:whisper", "rp:color", },
          label = loc("TAG_rp:listen-whisper_LABEL"),
          desc = loc("TAG_rp:listen-whisper_DESC"),
          method = Get.whisper,
          extraEvents = "CHAT_MSG_WHISPER",
          size = true,
        },
        { name = "rp:listencolor",
          alias = { "rp:listenercolor", "rp:listen-color", "rp:listener-color" },
          desc = loc("TAG_rp:listencolor_DESC"),
          method = Get.color,
        },
      },
    });
end);


