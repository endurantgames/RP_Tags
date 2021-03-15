-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license.
-- Get-Shared: functions for data that don't depend on MSP program

local RPTAGS           = RPTAGS;

RPTAGS.queue:WaitUntil("UTILS_GET",
function(self, event, ...)

RPTAGS.utils.get = { core = {}, shared = {}, color = {}, text = {}, icon = {}, };

-- constants
--
local CONST            = RPTAGS.CONST;

-- libraries
--
local LRI              = LibStub("LibRealmInfo");

-- utilities
--
local loc              = RPTAGS.utils.locale.loc;
local Config           = RPTAGS.utils.config;

-- wow utilities
local BATTLENET_FONT_COLOR       = BATTLENET_FONT_COLOR;
local BNGetFriendGameAccountInfo = C_BattleNet.GetFriendGameAccountInfo;
local BNGetNumFriendGameAccounts = C_BattleNet.GetFriendNumGameAccounts;
local BNGetNumFriends            = BNGetNumFriends;
local C_FriendList               = C_FriendList;
local CreateFrame                = CreateFrame;
local DIM_RED_FONT_COLOR         = DIM_RED_FONT_COLOR;
local GREEN_FONT_COLOR           = GREEN_FONT_COLOR;
local IsInGuild                  = IsInGuild;
local IsInRaid                   = IsInRaid;
local LIGHTBLUE_FONT_COLOR       = LIGHTBLUE_FONT_COLOR;
local LIGHTGRAY_FONT_COLOR       = LIGHTGRAY_FONT_COLOR;
local ORANGE_FONT_COLOR          = ORANGE_FONT_COLOR;
local UnitAura                   = UnitAura;
local UnitGUID                   = UnitGUID;
local UnitInOtherParty           = UnitInOtherParty;
local UnitInParty                = UnitInParty;
local UnitIsInMyGuild            = UnitIsInMyGuild;
local UnitIsPVP                  = UnitIsPVP;
local UnitIsPlayer               = UnitIsPlayer;
local UnitIsSameServer           = UnitIsSameServer;
local UnitName                   = UnitName;
local UnitRace                   = UnitRace;

      -- whether the unit has any buffs affecting their scale -----------------------------------------------
local function sizeBuffScanner(unit) 
  local sizeBuff = nil;
  for buffID,_ in pairs(CONST.SIZEBUFFS)
  do  for i = 1,40
      do  local _, _, _, _, _, _, _, _, _, spellID = UnitAura(unit,i);
          if spellID == buffID then sizeBuff = buffID; end;
          end; -- for i = 1,40
      end; -- for buffID
  return sizeBuff
end; -- function

local function getSizeBuff(unit) if not UnitIsPlayer(unit) then return "" end;
  local sizeBuff = sizeBuffScanner(unit)
  return sizeBuff and RPTAGS.utils.format.sizebuff(sizeBuff, Config.get("SIZEBUFF_FMT"), UnitRace(unit) == "PANDAREN") or "";
end

local function getSizeBuffIcon(unit) if not UnitIsPlayer(unit) then return "" end;
  local sizeBuff = sizeBuffScanner(unit)
  return sizeBuff and RPTAGS.utils.format.sizebuff(sizeBuff, "ICON", UnitRace(unit) == "PANDAREN") or "";
end;

local function getNpcStatus(u) if not UnitIsPlayer(u) then return loc("IS_NPC") else return "" end; end;

local function getServerInfo(u, request) if not UnitIsPlayer(u) then return "" end;
  local unitGUID = UnitGUID(u);          if not unitGUID        then return "" end;

  local realmID, realmName, _, rules, realmLang, _, region, timezone, _, englishName, _ = LRI:GetRealmInfoByGUID(unitGUID);

  if     request == "name"       then return englishName or realmName
  elseif request == "abbr"       then return CONST.SERVER.ABBR[realmID]
  elseif request == "lang"       then return loc("LANG_" .. (realmLang or ""))
  elseif request == "lang-short" then return realmLang
  elseif request == "mine"       then return UnitIsSameServer(u) and (englishName or realmName) or ""
  elseif request == "notmine"    then return UnitIsSameServer(u) and "" or (englishName or realmName)
  elseif request == "region"     then return loc("REGION_" .. region);
  elseif request == "star"       then return UnitIsSameServer(u) and "" or "(*) "
  elseif request == "dash"       then return UnitIsSameServer(u) and "" or "-"
  elseif request == "subregion"  then return loc("REGION_" .. region .. "_" .. realmLang .. "_" .. (timezone or ""))
  elseif request == "type"       then return loc("SERVER_TYPE_" .. (rules or ""))
  elseif request == "type-short" then return rules
  else                                return ""
  end; -- if request
end; -- function

-- local function getClientInfo(u, request) can't be here because it uses MRP-specific code
-- local function getGuildInfo( u, request) can't be here because it uses getField and getMisc

-- hilite colors
local function getHiliteColor(n) if not n then n = 1; end; return "|cff" .. Config.get("COLOR_HILITE_" .. n); end;

-- tracker for battlenet friend data ------------------------------------------------------------------------------------------
local friendData = CreateFrame("frame");
friendData.friends = {};
friendData:RegisterEvent("BN_FRIEND_LIST_SIZE_CHANGED")
friendData:RegisterEvent("PLAYER_ENTERING_WORLD")
friendData.friends.btag = {};
friendData:SetScript("OnEvent",
  function (self, event)
  if     event == "BN_FRIEND_LIST_SIZE_CHANGED" or event == "PLAYER_ENTERING_WORLD"
  then   local newBNFriends = {};
         local numBNFriends, _ = BNGetNumFriends();
         for f = 1, numBNFriends
         do  local friendAccounts = BNGetNumFriendGameAccounts(f);
             if   friendAccounts > 0
             then for a = 1, friendAccounts
                  do local _, name, client, server, _, _, _, _, _, _, _, _, _, _ = BNGetFriendGameAccountInfo(f, a);
                     if client == "WoW" then newBNFriends[name .. "-" .. server] = { name = name, server = server }; end; 
                  end; -- for a
             end; -- if friendAccounts > 0
         end; -- for f

  self.friends.btag = newBNFriends;
  end; -- if btag friendslist
end); -- function

local function getGuildColor(u)
  if   not UnitIsPlayer(u) or not IsInGuild() or not UnitIsInMyGuild(u) 
  then return "" -- don't change the color
  else return GREEN_FONT_COLOR:GenerateHexColorMarkup(); 
  end; -- if
end;

local function getFriendColor(u) if not u or not UnitIsPlayer(u) then return "" end; -- don't change the color
  local unitName, unitServer = UnitName(u);
  local guid = UnitGUID(u);
  local unitID = unitName .."-" .. (unitServer or GetRealmName());

  if     C_FriendList.IsIgnored(unitName) then return DIM_RED_FONT_COLOR:GenerateHexColorMarkup();
  elseif C_FriendList.IsFriend(guid)      then return GREEN_FONT_COLOR:GenerateHexColorMarkup();
  elseif friendData.friends.btag[unitID]  then return BATTLENET_FONT_COLOR:GenerateHexColorMarkup();
  else   return ""; -- don't change the color;
  end;
end; -- function

local function getPartyColor(u) if not u or not UnitIsPlayer(u) then return "" end; -- don't change the color
  if     IsInRaid() and UnitInParty(u) then return ORANGE_FONT_COLOR:GenerateHexColorMarkup();
  elseif UnitInParty(u)                then return LIGHTBLUE_FONT_COLOR:GenerateHexColorMarkup();
  elseif UnitInOtherParty(u)           then return LIGHTGRAY_FONT_COLOR:GenerateHexColorMarkup();
  else   return ""; -- don't change the color
  end; -- if
end; -- function

local function pvpIcon(u, request) 
  if   UnitIsPlayer(u) and UnitIsPVP(u) 
  then local faction, _ = UnitFactionGroup(u); 
       if request == "square" then request = "_SQUARE" else request = ""; end;
       return RPTAGS.const.ICONS.T_ .. RPTAGS.const.ICONS["PVP_" .. faction:upper() .. request] .. RPTAGS.const.ICONS._t
  else return "" end;
end; -- function

local function targetMeta(u, request) if not u or not UnitIsPlayer(u) then return "" end;
  local tot = u .. "target";
  if not UnitExists(tot) then return "" end;
  local tmap = {
    name        = RPTAGS.utils.get.text.name,
    class       = RPTAGS.utils.get.text.class,
    color       = RPTAGS.utils.get.color.name,
    icon        = RPTAGS.utils.get.icon.unit,
    gender      = RPTAGS.utils.get.text.gender,
    gendercolor = RPTAGS.utils.get.color.gender,
    gendericon  = RPTAGS.utils.get.icon.gender,
    race        = RPTAGS.utils.get.text.race,
    status      = RPTAGS.utils.get.text.status,
    statuscolor = RPTAGS.utils.get.color.status,
    statusicon  = RPTAGS.utils.get.icon.status,
    me          = RPTAGS.utils.get.shared.me,
    mecolor     = RPTAGS.utils.get.shared.meColor,
    title       = RPTAGS.utils.get.text.fulltitle, };
  if request == "details"
  then return (tmap.icon(tot)       or "") .. " " .. (tmap.color(tot)       or "") ..        (tmap.name(tot)  or "") .. "|r\n" ..
              (tmap.statusicon(tot) or "") .. " " ..                                         (tmap.title(tot) or "") ..   "\n" ..
              (tmap.gendericon(tot) or "") .. " " .. (tmap.race(tot)        or "") .. " " .. (tmap.class(tot) or "");
  elseif tmap[request] then return tmap[request](tot) 
  else return "" 
  end;
end;

local function meColor(u)
  if UnitGUID(u) == UnitGUID('player')
  then return "|cff" .. Config.get("COLOR_ME");
  end;
end;

local function meName(u)
  if UnitGUID(u) == UnitGUID('player')
  then return "|cff" .. Config.Get("COLOR_ME") .. Config.get("ME") .. "|r";
  end;
end;

--
RPTAGS.utils.get.shared.friendColor  = getFriendColor;
RPTAGS.utils.get.shared.guildColor   = getGuildColor;
RPTAGS.utils.get.shared.hiliteColor  = getHiliteColor;
RPTAGS.utils.get.shared.npc          = getNpcStatus;
RPTAGS.utils.get.shared.partyColor   = getPartyColor;
RPTAGS.utils.get.shared.pvpIcon      = pvpIcon;
RPTAGS.utils.get.shared.server       = getServerInfo;
RPTAGS.utils.get.shared.sizebuff     = getSizeBuff;
RPTAGS.utils.get.shared.sizebuffIcon = getSizeBuffIcon;
RPTAGS.utils.get.shared.target       = targetMeta;
RPTAGS.utils.get.shared.meColor      = meColor;
RPTAGS.utils.get.shared.me           = meName;

end);
