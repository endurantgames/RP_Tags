-- ------------------------------------------------------------------------------
-- RP Tags 
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. To view a copy of the license, visit
--
--     https://creativecommons.org/licenses/by/4.0/

local addOnName, ns = ...
local RPTAGS        = RPTAGS;
local Module        = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("UTILS_GET",
function(self, event, ...)
    -- constants
    --
    local CONST  = RPTAGS.CONST;
    local ICON   = CONST.ICONS;
    local STATUS = ICON.STATUS;
    local GENDER = ICON.GENDER; -- category
    local PARAMS = ICON.PARAMS;  -- category

    -- libraries

    local LRI              = LibStub("LibRealmInfo");

    -- utilities
    --
    local loc          = RPTAGS.utils.locale.loc;
    local tc           = RPTAGS.utils.text.titlecase;
    local Config       = RPTAGS.utils.config;
    local compareColor = RPTAGS.utils.color.compare;
    local splitRGB     = RPTAGS.utils.color.hexaToNumber;
    local joinRGB      = RPTAGS.utils.color.colorCode;

    local unSup        = RPTAGS.utils.text.unsup;
    local unSupYet     = RPTAGS.utils.text.unsup;
    local unSupColor   = RPTAGS.utils.text.unsupcolor;
    local unSupIcon    = RPTAGS.utils.text.unsupicon;

    -- wow utilities
    local C_FriendList = C_FriendList;
    local GetGuildInfo = GetGuildInfo;
    local UnitGUID     = UnitGUID;
    local UnitIsPlayer = UnitIsPlayer;
    local UnitName     = UnitName;
    local UnitRace     = UnitRace;
    local UnitSex      = UnitSex;
    
    -- utilities
    local function getUnitID(u) if not u or not UnitIsPlayer(u) then return nil; end;
      local unitName, unitRealm = UnitFullName(u);
      if not unitRealm then unitRealm = GetRealmName(); end; -- the player's current realm
      return unitName .. "-" .. unitRealm:gsub(" ","");
    end;

    local function getField(u, field) 
      if   u == 'player' 
      then return msp.my[field] 
      else local  unitID = getUnitID(u); 
           if not unitID then return nil end;
           if not msp.char[unitID] then return nil end;
           local value = msp.char[unitID].field[field]; 
           return value;
      end;
    end;
    
    local function getText(u, field)
      local value = getField(u, field);
      if not value then return nil; end;
      value = value:gsub("|cff%x%x%x%x%x%x","");
      value = value:gsub("|r$", "");
      return value;
    end;

    local function getColor(u, field) local value = getField(u, field); if value then return value:match("^(|cff%x%x%x%x%x%x)") or ""; else return nil; end; end;

    local function ico(path, tint, param) if not path then return "" end;
      if     not param            then param = PARAMS.DEFAULT
      elseif PARAMS[param] ~= nil then param = PARAMS[param]
                                  else param = PARAMS.DEFAULT  end; -- if not param
      local val = "|TInterface\\" .. path .. ":" .. param;
      if tint then local r, g, b = splitRGB(tint); val = val..":"..r..":"..g..":"..b; end; -- if tint
      val = val .. "|t";
      return val;
    end; -- function

    -- unsupported on this client
    
    -- the actual data-getting routines

    local function getRace(u)  local mrpRace  = getText(u, "RA"); if mrpRace  and mrpRace:len()  > 0 then return mrpRace  else return UnitRace(u)  end; end;
    local function getName(u)  local mrpName  = getText(u, "NA"); if mrpName  and mrpName:len()  > 0 then return mrpName  else return UnitName(u)  end; end;
    local function getClass(u) local mrpClass = getText(u, "RC"); if mrpClass and mrpClass:len() > 0 then return mrpClass else return UnitClass(u) end; end;


    local function getNameColor(u) return getColor(u, "NA") or "";           end;

     
    -- local mrpClass = getText(u, "RC"); if mrpClass then return mrpClass; else local gameClass = UnitClass(u); return gameClass; end; end;
    -- local mrpName = getText(u, "NA") if mrpName then return mrpName else local gameName = UnitName(u); return gameName; end;
    -- local mrpRace = getField(u, "RA"); if mrpRace then return mrpRace; else local gameRace = UnitRace(u); return gameRace; end;

    local function getFirstName(u)
      local mrpName = getText(u, "NA")
      if mrpName then return mrpName:gsub(" .+$", ""); else local gameName = UnitName(u) return gameName;
      end;
    end;

    local function getLastName(u)
      local mrpName = getText(u, "NA");
      if mrpName 
      then local parts = {};
           for part in mrpName:gmatch("%S+") do table.insert(parts, part) end;
           if     #parts == 0 then return ""
           elseif #parts == 1 then return ""
           elseif #parts == 2 then return parts[2]
           elseif parts[#parts - 1] == "von" or parts[#parts - 1] == "St."
           then return parts[#parts -1] .. " " .. parts[#parts]
           else return parts[#parts]
           end;
      else return "";
      end;
    end; -- function

    local function getCurr(u)     return getField(u, "CU") or ""; end;
    local function getInfo(u)     return getField(u, "CO") or ""; end;
    local function getEyes(u)     return  getText(u, "AE") or ""; end;
    local function getEyeColor(u) return getColor(u, "AE") or ""; end;

    local function getUnitIcon(u)
      local icon = getField(u, "IC");
      if    icon and icon ~= nil and icon:len() > 0 then return RPTAGS.CONST.ICONS.T_ ..  "ICONS\\" .. icon .. RPTAGS.CONST.ICONS._t; 
      else  return RPTAGS.utils.get.icon.race(u) end;
    end;
    
    local function getAge(u)      return getField(u, "AG") end;
    local function getHome(u)     return getField(u, "HH") end;
    local function getBP(u)       return getField(u, "HB") end;
    local function getFT(u)       return getField(u, "NT") end;
      
    local function getMisc(field, u) -- these are the fields that we know how to get
      local  value;
      if     field == "motto" 
      then   value = getField(u, "MO") 
             if value then return '"' .. value .. '"' else return "" end;
      elseif field == "nick"
      then   return getField(u, "NI") or "";
      elseif field == "nick-quoted"
      then   value = getField(u, "NI");
             if value then return '"' .. value .. '"' else return "" end;
      elseif field == "rstatus"
      then   value = getField(u, "RS");
             if value then return loc("RSTATUS_" .. value) else return "" end;
      elseif field == "house" or field == "family" or field == "tribe"
      then   return getField(u, "NH") or "";
      else   return "|cff" .. Config.get("COLOR_UNKNOWN") .. "?|r"
      end;
    end; -- function
                            
    local function getYears(u, flag)
      local age = getField(u, "AG");
      if not age then return ""; end;
      local years, s, x = RPTAGS.utils.parse.age(age);
      if not s then return age; end;
      if not x then years = loc("ABOUT") .. " " .. years end;
      years = years .. " " .. loc("AGE_YEARS");
      if flag then years = years .. " " .. loc("YEARS_" .. string.upper(flag)) end;
      return years;
    end;

    local function getRelativeAgeColor(u) if not UnitIsPlayer(u) then return ""; end; -- don't change the color
      if not Config.get("PARSE_AGE")                         then return ""; end; -- don't change the color
      local playerAge, parsedPlayer, playerExact = RPTAGS.utils.parse.age(getAge("player"));
      local unitAge,   parsedUnit,   unitExact   = RPTAGS.utils.parse.age(getAge(u));
      if not parsedPlayer then return ""; end; -- don't change the color
      if not parsedUnit   then return "|cff" .. Config.get("COLOR_UNKNOWN"); end;
      return compareColor(playerAge, unitAge, playerExact and unitExact);
    end;

    local function getRelativeHeightColor(u) if not UnitIsPlayer(u) then return ""; end; -- don't change the color
      if not Config.get("PARSE_HW")                             then return ""; end; -- don't change the color
      local playerHeight, parsedPlayer, playerExact = RPTAGS.utils.parse.height(getField("player", "AH"));
      local unitHeight,   parsedUnit,   unitExact   = RPTAGS.utils.parse.height(getField(u, "AH"));
      if not parsedPlayer then return ""; end; -- don't change the color
      if not parsedUnit   then return "|cff" .. Config.get("COLOR_UNKNOWN"); end;
      return compareColor(playerHeight, unitHeight, playerExact and unitExact);
    end;

    local function getRelativeWeightColor(u) if not UnitIsPlayer(u) then return ""; end; -- don't change the color
      if not Config.get("PARSE_HW")                             then return ""; end; -- don't change the color
      local playerWeight, parsedPlayer, playerExact = RPTAGS.utils.parse.weight(getField("player", "AW"));
      local unitWeight,   parsedUnit,   unitExact   = RPTAGS.utils.parse.weight(getField(u, "AW"));
      if not parsedPlayer then return ""; end; -- don't change the color
      if not parsedUnit   then return "|cff" .. Config.get("COLOR_UNKNOWN"); end;

      return compareColor(playerWeight, unitWeight, playerExact and unitExact);
    end;

    local function getStatus(u)
      if not UnitIsPlayer(u) then return loc("IS_NPC") end;
      local  status = tonumber(getField(u, "FC")) or 0;
      if     status == 1 then return loc("IC_OOC")
      elseif status == 0 then return ""
      elseif status == 2 then return loc("IS_IC")
      elseif status == 3 then return loc("IS_OPEN")
      elseif status == 4 then return loc("IS_STORYTELLER")
      else   return loc("IS_IC");
      end;
    end;

    local function getIcStatus(u)  local status = tonumber(getField(u, "FC")) or 0; if status >= 2 then return loc("IS_IC") else return ""; end; end;
    local function getOocStatus(u) local status = tonumber(getField(u, "FC")) or 0; if status == 1 then return loc("IS_OOC") else return "" end; end;

    local function getStatusColor(u)
      if not UnitIsPlayer(u) then return loc("COLOR_NPC") end;
      local status = tonumber(getField(u, "FC")) or 0;
      if     status == 1 then return "|cff" .. Config.get("COLOR_OOC") 
      elseif status == 0 then return "|cff" .. Config.get("COLOR_UNKNOWN")
      elseif status == 2 then return "|cff" .. Config.get("COLOR_IC")
      elseif status == 3 then local r, g, b = splitRGB(Config.get("COLOR_IC"))  return joinRGB(85 + r * 2/3, 85 + g * 2/3, 85 + b * 2/3)
      elseif status == 4 then local r, g, b = splitRGB(Config.get("COLOR_NPC")) return joinRGB(85 + r * 2/3, 85 + g * 2/3, 85 + b * 2/3) 
      else return "";
      end;
    end;

    local function getStatusIcon(u)
      local tint;
      if   UnitIsPlayer(u)
      then local  status = tonumber(getField(u, "FC"));
           if     status == 1 then tint = Config.get("COLOR_OOC")
           elseif status == 2 then tint = Config.get("COLOR_IC");
           elseif status == 0 then tint = Config.get("COLOR_UNKNOWN");
           elseif status == 3 then local r, g, b = splitRGB(Config.get("COLOR_IC"))  tint = joinRGB(85 + r * 2/3, 85 + g * 2/3, 85 + b * 2/3)
           elseif status == 4 then local r, g, b = splitRGB(Config.get("COLOR_NPC")) tint = joinRGB(85 + r * 2/3, 85 + g * 2/3, 85 + b * 2/3) 
           else                    tint = Config.get("COLOR_UNKNOWN")
           end; -- if/elseif/else
      else tint = Config.get("COLOR_NPC");
      end; -- if player
      return ico(STATUS, tint);
    end;

    local function getExtStatus(u, request)
      local status = tonumber(getField(u, "FC")) or 0;
      if     request == "open"        and status == 3 then return loc("IS_OPEN") 
      elseif request == "storyteller" and status == 4 then return loc("IS_STORYTELLER")
      else   return "" end;
    end;

    local function getProfileSize(u, request)
      local BIG_PROFILE = RPTAGS.CONST.BIG_PROFILE;

      local size = 0;
      local desc = getField(u, "DE")
      if    desc then size = size + desc:len(); end;
      local hist = getField(u, "HI")
      if    hist then size = size + desc:len(); end;

     
      local blocks = math.floor(size/255);
      local word = RPTAGS.utils.format.sizewords(blocks, BIG_PROFILE, Config.get("PROFILESIZE_FMT"));
      if     size    == 0       then return ""
      elseif request == "word"  then return word
      elseif request == "color" then local hue = RPTAGS.utils.color.redToGreenHue(blocks, 0, BIG_PROFILE, true);
                                     local r, g, b = RPTAGS.utils.color.hsvToRgb(hue, 1, 1, 1);
                                     return RPTAGS.utils.color.colorCode(r, g, b)
      end; -- if request
    end; -- function

    local function getHeight(u)
      local height = getField(u, "AH") if not height then return "" end;
      local cm, s;
      if Config.get("PARSE_HW") then cm, s = RPTAGS.utils.parse.height(height); end;
      if s then return RPTAGS.utils.format.cm(cm,     Config.get("UNITS_HEIGHT"));
      else return RPTAGS.utils.format.cm(height, Config.get("UNITS_HEIGHT")); end;
    end;

    local function getWeight(u, noParse)
      local weight = getField(u, "AW") if not weight then return "" end;
      local kg, s
      if Config.get("PARSE_HW") and not noParse then kg, s = RPTAGS.utils.parse.weight(weight) end;
      if s then return RPTAGS.utils.format.kg(kg, Config.get("UNITS_WEIGHT"));
      else return RPTAGS.utils.format.kg(weight, Config.get("UNITS_WEIGHT")); end;
    end;

    local function getGuildInfo(u, request) if not UnitIsPlayer(u) then return "" end;
      local guildName, guildRank, _ = GetGuildInfo(u)

      if     request == "status" then return unSup();
      elseif request == "name"   then return guildName
      elseif request == "rank"   then return guildRank
      end; -- requestif
    end;

    local function getGender(u)

      local race = getRace(u);
      if race and Config.get("PARSE_GENDER")
      then local knownGender, s;
           knownGender, s = RPTAGS.utils.parse.gender(string.gsub(race, "[Hh]uman", "#####"));
           if s then return loc("GENDER_" .. knownGender), knownGender; end;
      end; -- if parse gender

      local gameSex     = UnitSex(u);
      -- so now we'll try what the game thinks they are
      if gameSex == 3 then return loc("GENDER_FEMALE"), "FEMALE"; end;
      if gameSex == 2 then return loc("GENDER_MALE"),   "MALE";   end;
      if gameSex == 1 then return loc("GENDER_NEUTER"), "NEUTER"; end;

      -- fallback on "heck i dunno"
      return loc("GENDER_UNKNOWN"), "UNKNOWN";
    end;

    local function getPronoun(u, pro)
      -- load the localized pronoun data -------------------------------------------------------------------------------
      local pronounList = loc("PRONOUN_TAGS");
      local genderList  = loc("GENDERS") .. ";" .. loc("EXTRA_PRONOUN_SETS");

      -- check the input parameters ------------------------------------------------------------------------------------
      if not pro or not u                           then return "", nil end; -- if we don't have both params
      if not string.len(pro) == 1                   then return "", nil end; -- if code for pronoun isn't 1 char
      if not string.match(pronounList, pro:lower()) then return "", nil end; -- if code isn't on the pronoun list

      local function case(s) if string.match(pro, "%u") then return tc(s) else return s:lower() end end;
      local function pronoun(g, v) return loc("PRONOUN_" .. g:upper() .. "_" .. v:upper()); end;
      local function allPronouns(g) local all = ""; for t in string.gmatch(pronounList, "%a") do all = all .. "/" .. pronoun(g, t) end; return all:sub(2); end;

       local _, genderMatch = getGender(u);
       local p = pronoun(genderMatch, pro:lower());
       if p ~= "" then return case(p), allPronouns(genderMatch) else return "", "" end; -- if

    end; -- function

    local function getAllPronouns(u) local _, all = getPronoun(u, loc("PRONOUN_TAGS"):sub(1,1)); return all; end; -- function
    local function getGenderColor(u) local _, genderCode = getGender(u); return "|cff"..Config.get("COLOR_"..genderCode); end;

    local function getGenderIcon(u)
      local _, genderCode = getGender(u);
      return ico(GENDER[genderCode], Config.get("COLOR_" .. genderCode), genderCode)
    end;

    local function getKnownName(u) -- if you are a character level friend with the person in question
      local unitName, guid = UnitName(u), UnitGUID(u);
      if C_FriendList.IsFriend(guid) 
      then  return getName(u)
      else  local  g, _ = getGender(u);
            local  r = getRace(u);
            return string.format(loc("FMT_A"), g .. " " .. r);
      end;  -- if
    end; -- function

    local function getGlance(u, slot, args)
      local showTitle, showText, showIcon = args.title or args.all, args.text or args.all, args.icon or args.all;
      local unitID         = getUnitID(u);      if not unitID  then return "" end;
      local glances        = getField(u, "PE"); if not glances then return "" end; 
      glances              = RPTAGS.utils.parse.mrpGlance(glances);           -- { { icon = icon, title = title, text = text }+ }
      RPTAGS.cache.glances = glances;
      local delimiter      = Config.get("GLANCE_DELIM"); 
      local separator      = Config.get("GLANCE_COLON");
      local value          = "";
      
      if   slot == 0
      then local allGlances = {};
           for   i = 1, #glances
           do    local glance = getGlance(u, i, showTitle, showText, showIcon) 
                 if    glance and glance ~= "" 
                 then  table.insert(allGlances, glance) 
                 end; 
           end;
           return table.concat(allGlances, delimiter or "")
      else local glance = glances[tonumber(slot)];
           if not glance                then return ""                                       end;
           if showIcon                  then value = value..ico("ICONS\\"..glance.icon).." " end;
           if showTitle                 then value = value..glance.title                     end;
           if showTitle   and showText  then value = value..separator                        end;
           if showText                  then value = value..glance.text                      end;
           if value == "" and showTitle then value = "..."                                   end;
           return value;
      end;
    end; -- function

    local function getRoleplayingStyle(u, style, variant)
      if     style == "ic" 
      then   local value = getField(u, "FR") if not value then value = 0; end;
             if tonumber(value) ~= value and variant ~= "ICON" then return value 
             elseif tonumber(value) ~= value and variant == "ICON" then return ico("ICONS\\INV_Inscription_Scroll") end;
             local s = "STYLE_" .. style:upper() .. "_" .. value;
             if    variant then s = s .. "_" .. variant; end;
             return loc(s)
      elseif variant == "ICON" then return unSupIcon()
      else   return unSup()
      end;
    end; -- function

    local function getClientInfo(u, request) if not u or not UnitIsPlayer(u) then return "" end;
      local  unitID = getUnitID(u);          if not unitID then return "" end;
      local  dataField = getField(u, "VA");  if not dataField then return "" end;
      local  client, v = unpack(RPTAGS.utils.text.split(dataField, "/"));
      local  knownClient  = CONST.CLIENT.LOOKUP[client];    if not knownClient then   return "" end;

      if     request == "long"          then return loc("CLIENT_" .. knownClient)
      elseif request == "short"         then return loc("CLIENT_" .. knownClient .. "_SHORT")
      elseif request == "version" and v then return v
      elseif request == "full"    and v then return loc("CLIENT_" .. knownClient) .. " " .. v
      elseif request == "full"          then return loc("CLIENT_" .. knownClient)
      elseif request == "icon"          then return CONST.CLIENT.ICON[knownClient] or ""
      elseif request == "TRP"     and 
             knownClient == "TRPE"      then return loc("CLIENT_TRP")
      elseif request == knownClient     then return loc("CLIENT_" .. knownClient)
      else   return ""
      end    -- if knownClient

    end; -- function

    local function getRaceIcon(u) if not u or not UnitIsPlayer(u) then return "" end;
      local RACEICON = CONST.ICONS.RACE;
      local rpRace = getRace(u);
      local _, _, gameRaceCode  = UnitRace(u);
      local raceCode, raceFallback, _ = RPTAGS.utils.parse.race(u, "icon", rpRace)
      local race;

      if     raceCode        and RACEICON[raceCode]     then race = raceCode
      elseif raceFallback    and RACEICON[raceFallback] then race = raceFallback
      elseif gameRaceCode    and RACEICON[gameRaceCode] then race = gameRaceCode
      else   race = 0
      end;

      local _, genderNorm = getGender(u) -- curse your sudden but inevitable gender normativity

      if     genderNorm and RACEICON[race] and RACEICON[race][genderNorm] then return ico(RACEICON[race][genderNorm])
      elseif genderNorm and RACEICON[race] and RACEICON[race]["OTHER"   ] then return ico(RACEICON[race]["OTHER"   ])
      elseif genderNorm and RACEICON[   0] and RACEICON[race][genderNorm] then return ico(RACEICON[   0][genderNorm])
      elseif genderNorm and RACEICON[   0] and RACEICON[race]["OTHER"   ] then return ico(RACEICON[   0]["OTHER"   ])
      else return "" -- no icon
      end;
    end;

    RPTAGS.utils.get.color.age         = getRelativeAgeColor;
    RPTAGS.utils.get.color.custom      = getNameColor;
    RPTAGS.utils.get.color.eye         = getEyeColor;
    RPTAGS.utils.get.color.gender      = getGenderColor;
    RPTAGS.utils.get.color.height      = getRelativeHeightColor;
    RPTAGS.utils.get.color.name        = getNameColor;
    RPTAGS.utils.get.color.profileSize = getProfileSize;
    RPTAGS.utils.get.color.status      = getStatusColor;
    RPTAGS.utils.get.color.weight      = getRelativeWeightColor;

    RPTAGS.utils.get.core.misc         = getMisc;
    RPTAGS.utils.get.core.unitID       = getUnitID;

    RPTAGS.utils.get.icon.gender       = getGenderIcon;
    RPTAGS.utils.get.icon.status       = getStatusIcon;
    RPTAGS.utils.get.icon.unit         = getUnitIcon;
    RPTAGS.utils.get.icon.race         = getRaceIcon;

    RPTAGS.utils.get.text.age          = getAge;
    RPTAGS.utils.get.text.birthplace   = getBP;
    RPTAGS.utils.get.text.class        = getClass;
    RPTAGS.utils.get.text.curr         = getCurr;
    RPTAGS.utils.get.text.eyes         = getEyes;
    RPTAGS.utils.get.text.firstname    = getFirstName;
    RPTAGS.utils.get.text.fulltitle    = getFT;
    RPTAGS.utils.get.text.gender       = getGender;
    RPTAGS.utils.get.text.glance       = getGlance;
    RPTAGS.utils.get.text.guild        = getGuildInfo;
    RPTAGS.utils.get.text.height       = getHeight;
    RPTAGS.utils.get.text.home         = getHome;
    RPTAGS.utils.get.text.ic           = getIcStatus;
    RPTAGS.utils.get.text.info         = getInfo;
    RPTAGS.utils.get.text.knownName    = getKnownName;
    RPTAGS.utils.get.text.lastname     = getLastName;
    RPTAGS.utils.get.text.misc         = getMisc;
    RPTAGS.utils.get.text.name         = getName;
    RPTAGS.utils.get.text.ooc          = getOocStatus;
    RPTAGS.utils.get.text.profileSize  = getProfileSize;
    RPTAGS.utils.get.text.pronoun      = getPronoun;
    RPTAGS.utils.get.text.pronouns     = getAllPronouns;
    RPTAGS.utils.get.text.race         = getRace;
    RPTAGS.utils.get.text.status       = getStatus;
    RPTAGS.utils.get.text.weight       = getWeight;
    RPTAGS.utils.get.text.years        = getYears;
    RPTAGS.utils.get.text.extStatus    = getExtStatus;
    RPTAGS.utils.get.text.style        = getRoleplayingStyle;
    RPTAGS.utils.get.text.client       = getClientInfo;

 -- unsupported functions
    RPTAGS.utils.get.icon.glances      = unSupYet;     -- in progress

    RPTAGS.utils.get.text.title        = unSupYet;
    
    RPTAGS.utils.get.text.xp           = unSup;        -- research needed
    RPTAGS.utils.get.color.guildstatus = unSupColor;  
    RPTAGS.utils.get.text.note         = unSup;        -- mrp doesn't support trp3's "notes"

    RPTAGS.utils.get.text.relation     = unSup;        -- mrp doesn't support trp3's "relations"
    RPTAGS.utils.get.text.relwho       = unSup;
    RPTAGS.utils.get.icon.relation     = unSupIcon;    
    RPTAGS.utils.get.color.relation    = unSupColor;

  end
);


