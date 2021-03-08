-- RP Tags 
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 

local RPTAGS = RPTAGS;
local addOnName, ns = ...;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("UTILS_GET",
  function(self, event, ...)
    -- constants
    --
    local CONST            = RPTAGS.CONST;
    local ICON             = CONST.ICONS;
    local STATUS           = ICON.STATUS;
    local GENDER           = ICON.GENDER; -- category
    local PARAMS           = ICON.PARAMS;  -- category

    -- utilities
    --
    local loc              = RPTAGS.utils.locale.loc;
    local tagLabel         = RPTAGS.utils.locale.tagLabel;
    local split            = RPTAGS.utils.text.split;
    local tc               = RPTAGS.utils.text.titlecase;
    local Config           = RPTAGS.utils.config;
    local redToGreenHue    = RPTAGS.utils.color.redToGreenHue;
    local compareColor     = RPTAGS.utils.color.compare;
    local hsvToRgb         = RPTAGS.utils.color.hsvToRgb;
    local colorCode        = TRP3_API.utils.color.colorCode;
    local splitRGB         = RPTAGS.utils.color.hexaToNumber;
    local match            = RPTAGS.utils.text.match;

    -- trp3 utilities
    local TRP3_API         = TRP3_API;
    local TRP3_Register    = TRP3_Register;
    local getTrpName       = TRP3_API.r.name;
    local getData          = TRP3_API.profile.getData;
    local getProfile       = TRP3_API.register.getUnitIDCurrentProfileSafe;
    local getUnitID        = TRP3_API.utils.str.getUnitID;

    -- wow utilities
    local GetGuildInfo               = GetGuildInfo;
    local UnitClassBase              = UnitClassBase;
    local UnitIsPlayer               = UnitIsPlayer;
    local UnitName                   = UnitName;
    local UnitRace                   = UnitRace;
    local UnitSex                    = UnitSex;

--     RPTAGS.utils.get = { core = {}, color = {}, text = {}, icon = {}, }; 

          -- primary method of retrieving TRP3 data --------------------------------------------------------------------
    local function getField(fieldName, u)           if not u               then return "" end;
                                                    if not UnitIsPlayer(u) then return "" end;
      local  unitID  = getUnitID(u);                if not unitID          then return "" end;
      local  profile = getProfile(unitID);          if not profile         then return "" end;
      local  value   = getData(fieldName, profile); if not value           then return "" end;
      return tostring(value);
    end

    local function getProfileID(u)                if not u               then return nil end;
                                                  if not UnitIsPlayer(u) then return nil end;
      local unitID = getUnitID(u);                if not unitID          then return nil end;
      local reg = TRP3_Register.character[unitID] if not reg             then return nil end;
      local profileID = reg.profileID;            if not profileID       then return nil end; 
      return profileID;
    end

          -- alias to get characteristics ------------------------------------------------------------------------------
    local function getChara(partial_field, u) return getField("characteristics/" .. partial_field, u) end

          -- retrieve "miscellaneous" fields such as MOTTO -------------------------------------------------------------
    local function getMisc(fieldName, u)
      if   UnitIsPlayer(u)
      then local unitID  = getUnitID(u);       if not unitID                     then return "", false; end;
           local profile = getProfile(unitID); if not profile                    then return "", false; end;
                                               if not profile.characteristics    then return "", false; end;
                                               if not profile.characteristics.MI then return "", false; end;
           for _, t in pairs(profile.characteristics.MI) 
           do  if   string.find(string.lower(t["NA"] or ""):gsub(" ",""), fieldName) == 1
               then return t["VA"], true; -- found a match!
               end; -- if
           end -- for
           return "", false;
      else return "", false;
      end; -- if
    end;

          -- functions that just get and return straight values
    local function getAge(u)      return getChara("AG", u); end;
    local function getBP(u)       return getChara("BP", u); end;
    local function getCurr(u)     return getField("character/CU", u); end;
    local function getEyes(u)     return getChara("EC", u); end;
    local function getFT(u)       return getChara("FT", u); end;
    local function getHome(u)     return getChara("RE", u); end;
    local function getInfo(u)     return getField("character/CO", u); end;
    local function getLastName(u) return getChara("LN", u); end;
    local function getTitle(u)    return getChara("TI", u); end;

          -- retrieve at-first-glance fields ---------------------------------------------------------------------------
    local function getGlance(u, slot, args) if not UnitIsPlayer(u) then return ""; end;
      local showTitle, showText, showIcon = args.title or args.all, args.text or args.all, args.icon or args.all;
      -- showTitle = showTitle == 1; showText = showText == 1; showIcon = showIcon == 1;
      local delimiter = Config.get("GLANCE_DELIM");
      local separator = Config.get("GLANCE_COLON");

      if   slot == 0
      then local allGlances = {};
           for i =  1, 5
           do  local iGlance =  getGlance(u, i, showTitle, showText, showIcon, true);
               if iGlance ~= "" then table.insert(allGlances, iGlance) end;
           end -- for
           return table.concat(allGlances, delimiter or "")
      else local path    = "misc/PE/" .. slot;
           local unitID  = getUnitID(u);
           local profile = getProfile(unitID or u);

           local active = getData( path .. "/AC", profile); if not active then return "" end;
           local title  = getField(path .. "/TI", u);       local text =  getField(path .. "/TX", u)
           local icon   = getField(path .. "/IC", u)        local value = "";

           if showIcon    and icon                        then value = value .. "|TInterface\\ICONS\\" .. icon .. ":0|t "; end;
           if showTitle   and title                       then value = value .. title;                                     end;
           if showTitle   and showText and text and title then value = value .. separator;                                 end;
           if showText    and text                        then value = value .. text;                                      end;
           if value == "" and showTitle                   then value = "...";                                              end;
           return value;
      end  -- if
    end

          -- get the height of a player --------------------------------------------------------------------------------
    local function getHeight(u) if not UnitIsPlayer(u) then return ""; end; -- if

      local height = getChara("HE", u); if height == "" then return ""; end; -- if

      local cm, s;
      if   Config.get("PARSE_HW")
      then cm, s = RPTAGS.utils.parse.height(height)  -- we don't care about the exactness
      end; -- if

      if   s -- if we parsed it and got a cm result
      then return RPTAGS.utils.format.cm(cm,     Config.get("UNITS_HEIGHT"));
      else return RPTAGS.utils.format.cm(height, Config.get("UNITS_HEIGHT"));
      end; -- if
    end

          -- get the weight of a player --------------------------------------------------------------------------------
    local function getWeight(u, noParse) if not UnitIsPlayer(u) then return ""; end; -- if

      local weight = getChara("WE", u) if weight == "" then return ""; end; -- if

      local kg, s;
      if   Config.get("PARSE_HW") and not noParse
      then kg, s = RPTAGS.utils.parse.weight(weight)
      end; --  if

      if   s -- we parsed it and got a kg result
      then return RPTAGS.utils.format.kg(kg,     Config.get("UNITS_WEIGHT"));
      else return RPTAGS.utils.format.kg(weight, Config.get("UNITS_WEIGHT"));
      end; -- if
    end

          -- get the race of a player or other unit --------------------------------------------------------------------
    local function getRace(u)
      local trpVersion = getChara("RA", u);
      local systemRace = UnitRace(u);
      if string.len(trpVersion) > 0 then return trpVersion else return systemRace end -- if trpversion
    end

          -- get the class of a player or another unit -----------------------------------------------------------------
    local function getClass(u)
      local trpVersion     = getChara("CL", u);
      local systemClass, _ = RPTAGS.utils.text.titlecase(UnitClassBase(u));
      if string.len(trpVersion) > 0 then return trpVersion else return systemClass end 
    end

      -- get the name of a player or other unit ---------------------------
    local function getName(u) 
      if not u then return "" end;
      local sysName = UnitName(u); 
      local trpName = getTrpName(u);
      if trpName and string.len(trpName) > 0 
         then return trpName 
         else return sysName
      end; --if
    end

          -- get the first name of a player or other unit ---------------------------
    local function getFirstName(u) if not u or not UnitName(u) then return "" end;
      local  trpFirstName = getChara("FN", u) 
      if     trpFirstName  ~= "" then return trpFirstName 
      elseif getTrpName(u) ~= "" then return getTrpName(u):gsub("%s+", "")
                                 else return   UnitName(u):gsub("%s+", "") 
      end;
    end

          -- years, an age function that returns a number of years
    local function getYears(u, flag)
      local age = getChara("AG", u);
      if age == "" then return ""; end;
      local years, s, x = RPTAGS.utils.parse.age(age);
      if not s then return age; end;
      if not x then years = loc("ABOUT") .. " " .. years end;
      years = years .. " " .. loc("AGE_YEARS");
      if flag then years = years .. " " .. loc("YEARS_" .. string.upper(flag)) end;
      return years;
    end;

          -- ic/ooc status
    local function getStatus(u)
      if     UnitIsPlayer(u) and getField("character/RP", u) == "1" then return loc("IS_IC") 
      elseif UnitIsPlayer(u)                                        then return loc("IS_OOC")
      else                                                               return loc("IS_NPC")
      end; 
    end
--    local function getNpcStatus(u) if not UnitIsPlayer(u)                then return loc("IS_NPC") else return "" end; end; -- moved to get-shared
    local function getIcStatus(u)  if getField("character/RP", u) == "1" then return loc("IS_IC")  else return "" end; end;
    local function getOocStatus(u) if getField("character/RP", u) == "2" then return loc("IS_OOC") else return "" end; end;

    local function getRelation(u)                                          if not u         then return "" end;
      local profileID  = getProfileID(u);                                  if not profileID then return "" end;
      local rel        =  TRP3_API.register.relation.getRelation(profileID); if not rel       then return "" end;
      if rel then return TRP3_API.register.relation.getRelationText(profileID)                  else return "" end;
    end;

    local function getGender(u)
      local race = getRace(u);
      if not race then return loc("GENDER_UNKNOWN"), "UNKNOWN" end;

      local gameSex     = UnitSex(u);
      local genderField = getMisc("gender", u);

      if not genderField then return loc("GENDER_UNKNOWN"), "UNKNOWN" end;

      if   Config.get("PARSE_GENDER")
      then local knownGender, s;
           if   string.len(genderField) > 0
           then knownGender, s = RPTAGS.utils.parse.gender(genderField);
                if s then return genderField, knownGender else return genderField, "UNKNOWN"; end;
           end; -- if genderfield

           knownGender, s = RPTAGS.utils.parse.gender(string.gsub(race, "[Hh]uman", "#####"));
           if s then return loc("GENDER_" .. knownGender), knownGender; end;
      end; -- if parse gender

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

      local function case(s)  -- helper function -----------------------------------------------------------------------
        if string.match(pro, "%u") then return tc(s) else return s:lower() end end;

      local function pronoun(g, v) -- helper function ------------------------------------------------------------------
        return loc("PRONOUN_" .. g:upper() .. "_" .. v:upper()); end;

      local function allPronouns(g)
        local all = ""; for t in string.gmatch(pronounList, "%a") do all = all .. "/" .. pronoun(g, t) end; return all:sub(2); end;

      local pronounsField = getMisc("pronouns", u); -- get the pronouns field ---------------------------------------------
      local pronounIndex  = string.find(pronounList:lower(), pro:lower());

      if   pronounsField ~= ""
      then -- they have a custom pronouns field ---------------------------------------------------------------------
           local customPronouns = split(pronounsField, "/");
           for _, g in ipairs(split(genderList, ";"))
           do  -- loop g == loop through the genders -------------------------------------------------------------
               if   pronounsField:lower() == g:lower() -- Does this gender's name match the gender field? ------------------
               then return case(pronoun(g, pro)), allPronouns(g); 
               end; -- if
               for _, c in ipairs(customPronouns)
               do  -- loop c == loop through their customs ----------------------------------------------------
                   for t in string.gmatch(pronounList, "%a")
                   do  -- loop t == loop through the tags --------------------------------------------------
                       if  pronoun(g, t):lower() == c:lower() then return case(pronoun(g, pro)), allPronouns(g); -- found a match, so we'll assume this is our gender
                       end  -- if
                   end -- loop t
               end -- loop c
           end -- loop g

           -- did not find a match on any of the sets but they still have a custom field ----------------------------
           --
           local p = customPronouns[pronounIndex];
           if p then return case(p), pronounsField; else return case(customPronouns[1]), pronounsField; end -- if

      else -- they don't have a pronouns field ----------------------------------------------------------------------
           local _, genderMatch = getGender(u);
           local p = pronoun(genderMatch, pro:lower());
           if p ~= "" then return case(p), allPronouns(genderMatch) else return "", "" end; -- if

      end; -- if pronounsField --------------------------------------------------------------------------------------
    end; -- function

    local function getAllPronouns(u) local _, all = getPronoun(u, loc("PRONOUN_TAGS"):sub(1,1)); return all; end; -- function

    local function getMiscAndTweakOutput(miscField, u)
          local Tweaks = {
            ["motto"]       = function(unit) local  m, f = getMisc("motto", unit) return f and string.format(loc("FMT_MOTTO"), m) or "" end,
            ["nick-quoted"] = function(unit) local n, nf = getMisc("nick", unit); local nn, nnf = getMisc("nickname", unit)
                                             return nf and string.format(loc("FMT_MOTTO"), n) or nnf and string.format(loc("FMT_MOTTO"), nn) or "" end,
            ["house"]       = function(unit) local  h, hf = getMisc("house", unit); local  f, ff = getMisc("family", unit)
                                             return hf and h or ff and f or getMisc("tribe", unit) end,
            ["family"]      = function(unit) local  f, ff = getMisc("family", unit); local  h, hf = getMisc("house", unit)
                                             return ff and  f or hf and h or getMisc("tribe", unit) end,
            ["tribe"]       = function(unit) local  t, tf = getMisc("tribe", unit); local  f, ff = getMisc("family", unit);
                                             return tf and  t or ff and f or getMisc("house", unit) end,
            ["markings"]    = function(unit) local  m, f =  getMisc("markings", unit); return f and m or getMisc("tattoos", unit) end,
            ["actor"]       = function(unit) local as, asf = getMisc("actress",    unit); local ar, arf = getMisc("actor",      unit);
                                             local fc, fcf = getMisc("faceclaim",  unit); local vc, vcf = getMisc("voiceclaim", unit);
                                             local bc, bcf = getMisc("bodyclaim",  unit);
                                             return asf and as or arf and ar or fcf and fc or vcf and vc or bcf and bc or "" end,
            ["religion"]    = function(unit) local  r, f = getMisc("religion", unit); return f  and  r or getMisc("faith", unit) end,
            ["rstatus"]     = function(unit) local trp_rs = getChara("RS", u);
                                             if trp_rs then return loc("RSTATUS_" .. trp_rs)
                                                       else local  r, rf = getMisc("relationship status", unit);
                                                            local  m, mf = getMisc("marital status", unit);
                                                            return rf and  r or mf and m or getMisc("romantic status", unit)
                                             end; end,
         };

      if Tweaks[miscField] then return Tweaks[miscField](u) else return getMisc(miscField, u) end; -- if
    end; -- function

    local function getNote(u, noteNum)
          return u and (getUnitID(u) ~= getUnitID('player'))
                   and TRP3_API.profile.getPlayerCurrentProfile().notes
                   and TRP3_Register.character[getUnitID(u)]
                   and TRP3_Register.character[getUnitID(u)].profileID
                   and TRP3_API.profile.getPlayerCurrentProfile().notes[TRP3_Register.character[getUnitID(u)].profileID]
                   or ""
    end; -- function

    local function scanNote(u, patNum, iconRequested)
          local thisNote = getNote(u, patNum) .. "\n";
          local matches, found = {}, false;

          local pattern = Config.get("NOTE_" .. patNum .. "_STRING") or "";
          pattern = pattern:lower();
          if   pattern:len() >= 3
          then for line in thisNote:gmatch("(.-)\n")
               do  for _ in line:lower():gmatch(pattern)
                   do  found = true; 
                       table.insert(matches, line); 
                   end; -- for _
               end; -- for line
          end; -- if

          return    found and iconRequested and "|TInterface\\ICONS\\" .. Config.get("NOTE_" .. patNum .. "_ICON") .. ":0|t "
                 or found                   and table.concat(matches, "\n")
                 or "";
    end; -- function

    local function getKnownName(u)
      if    getRelation(u):len() > 0 
      then  return getName(u)
      else  local  g, _ = getGender(u); 
            local  r = getRace(u); 
            return string.format(loc("FMT_A"), g .. " " .. r);
      end;  -- if
    end; -- function

    local function getRelWho(u) 
      local  myRelation = getRelation(u);
      if     myRelation:len() > 0 then return loc("RELATION_" .. myRelation:upper()) else return loc("RELATION_STRANGER") end;
    end; -- function

    local function getRoleplayingStyle(u, style, variant)
      local  STYLE = { ic = 1, injury = 2, death = 3, romance = 4, battle = 5, guild = 6, };
      local  num = STYLE[style];

      if     num
      then   local value = getField("misc/ST/" .. num, u);
             if    value == "" then value = 0; end;
             local s = "STYLE_" .. style:upper() .. "_" .. value;
             if    variant then s = s .. "_" .. variant; end;
             return loc(s);
      end;  -- if num

      local  labels = {};
      if     style == "no"
      then   if getField("misc/ST/1", u) == "5" 
      then   table.insert(labels, tagLabel("rp:style-ic"));      
      end;
      if getField("misc/ST/2", u) == "2" 
      then   table.insert(labels, tagLabel("rp:style-injury"));
      end;
      if getField("misc/ST/3", u) == "2" 
      then table.insert(labels, tagLabel("rp:style-death"));   
      end;
      if getField("misc/ST/4", u) == "2" 
      then table.insert(labels, tagLabel("rp:style-romance")); 
      end;
      elseif style == "ask"
      then   if getField("misc/ST/1", u) == "2" 
             then table.insert(labels, tagLabel("rp:style-ic"));      
             end;
             if getField("misc/ST/1", u) == "3" 
             then table.insert(labels, tagLabel("rp:style-ic"));      
             end;
             if getField("misc/ST/1", u) == "4" 
             then table.insert(labels, tagLabel("rp:style-ic"));      
             end;
             if getField("misc/ST/2", u) == "3" 
             then table.insert(labels, tagLabel("rp:style-injury"));  
             end;
             if getField("misc/ST/3", u) == "3" 
             then table.insert(labels, tagLabel("rp:style-death"));   
             end;
             if getField("misc/ST/4", u) == "3" 
             then table.insert(labels, tagLabel("rp:style-romance")); 
             end;
      elseif style == "yes"
      then   if getField("misc/ST/1", u) == "1" 
             then table.insert(labels, tagLabel("rp:style-ic"));      
             end;
             if getField("misc/ST/2", u) == "1" 
             then table.insert(labels, tagLabel("rp:style-injury"));  
             end;
             if getField("misc/ST/3", u) == "1" 
             then table.insert(labels, tagLabel("rp:style-death"));   
             end;
             if getField("misc/ST/4", u) == "1" 
             then table.insert(labels, tagLabel("rp:style-romance")); 
             end;
      end; -- if style

      if labels == {} then return "" else return table.concat(labels, ", ") end;

    end;

    local function getExperience(u, request)
      local xpField = getField("character/XP", u);

      if not xpField                                 then return                                "";
      elseif request == "long"                       then return loc("XP_" .. xpField            );
      elseif request == "short"                      then return loc("XP_" .. xpField .. "_SHORT");
      elseif request == "rookie"    and xpField == 1 then return loc("XP_1"                      );
      elseif request == "volunteer" and xpField == 3 then return loc("XP_3"                      );
      elseif request == "icon"                       then return loc("XP_" .. xpField .. "_ICON" );
      elseif request == "rookie-icon"                then return loc("XP_1_ICON"                 );
      elseif request == "volunteer-icon"             then return loc("XP_3_ICON"                 );
                                                     else return                                ""; 
      end; -- if request
    end; -- func

    local function getClientInfo(u, request)                          if not u then return "" end;
          local  unitID = getUnitID(u);                               if not unitID then return "" end;
          local  Char = TRP3_API.register.getCharacterList()[unitID]; if not Char then return "" end;
                                                                      if not Char.client then return "" end;
          local  knownClient  = CONST.CLIENT.LOOKUP[Char.client];     if not knownClient then   return "" end;

          if     request == "long"                              then return loc("CLIENT_" .. knownClient)
          elseif request == "short"                             then return loc("CLIENT_" .. knownClient .. "_SHORT")
          elseif request == "version" and Char.clientVersion    then return Char.clientVersion
          elseif request == "full"    and Char.clientVersion    then return loc("CLIENT_" .. knownClient) .. " " .. Char.clientVersion
          elseif request == "icon"                              then return CONST.CLIENT.ICON[knownClient] or ""
          elseif request == "TRP"     and knownClient == "TRPE" then return loc("CLIENT_TRP")
          elseif request == knownClient                         then return loc("CLIENT_" .. knownClient)
          else   return ""
          end    -- if knownClient
    end; -- function

    local function getGuildInfo(u, request) if not UnitIsPlayer(u) then return "" end;
      local guildStyle = getField("misc/ST/6", u)
      local guildField = getMisc("guild", u)
      local isGuildIC;
      local guildName, guildRank, _ = GetGuildInfo(u)

      if guildField  ~= ""  then guildName = guildField; isGuildIC = true; guildRank = ""; end;
      if guildStyle  == "1" then isGuildIC = true;                                         end;
      if guildName   == nil then guildName = "";                                           end;
      if guildRank   == nil then guildRank = "";                                           end;

      if     request == "status" and isGuildIC then return loc("IS_IC")
      elseif request == "status"               then return loc("IS_OOC")
      elseif request == "name"                 then return guildName
      elseif request == "rank"                 then return guildRank
      end; -- requestif
    end;

          -- get a color string from a specific field on the unit, includes |cff ---------------------------------------
    local function getColor(colorField, u)             if not UnitIsPlayer(u) then return "" end; -- don't change the color
      local unitID  = getUnitID(u);                    if not unitID          then return "" end; -- don't change the color
      local profile = getProfile(unitID);              if not profile         then return "" end; -- don't change the color
      local fieldValue = getData("characteristics/" 
            .. colorField, profile);                   if not fieldValue      then return "" end; -- don't change the color
      local  rgb = fieldValue:match("(%x%x%x%x%x%x)"); if not rgb             then return "" end; -- don't change the color
      return "|cff" .. (rgb) -- change the color
    end

          -- the simplest color functions
    local function getEyeColor(u)  return getColor("EH", u); end;
    local function getNameColor(u) return getColor("CH", u); end;

          -- returns a color for the unit based on its gender ----------------------------------------------------
    local function getGenderColor(u) local _, genderCode = getGender(u); return "|cff"..Config.get("COLOR_"..genderCode);
    end;

          -- returns a color for the unit based on its IC/OOC status
    local function getStatusColor(u) if not u then return "" end;
      if   UnitIsPlayer(u)
      then local status = getField("character/RP", u); -- get the status
           if status == "1" then return "|cff" .. Config.get("COLOR_IC")  end;
           if status == "2" then return "|cff" .. Config.get("COLOR_OOC") end;
           return "|cff" .. Config.get("COLOR_UNKNOWN");
      else return "|cff" .. Config.get("COLOR_NPC");
      end; -- if
    end;

          -- returns a color based on the unit's age relative to the player
    local function getRelativeAgeColor(u) if not UnitIsPlayer(u) then return ""; end; -- don't change the color
      if not Config.get("PARSE_AGE")                         then return ""; end; -- don't change the color
        
      local playerAge, parsedPlayer, playerExact = RPTAGS.utils.parse.age(getAge("player"));
      local unitAge,   parsedUnit,   unitExact   = RPTAGS.utils.parse.age(getAge(u));
      if not parsedPlayer then return ""; end; -- don't change the color
      if not parsedUnit   then return "|cff" .. Config.get("COLOR_UNKNOWN"); end;

      return compareColor(playerAge, unitAge, playerExact and unitExact);
    end;

          -- returns a color based on the unit's height relative to the player
    local function getRelativeHeightColor(u) if not UnitIsPlayer(u) then return ""; end; -- don't change the color
      if not Config.get("PARSE_HW")                             then return ""; end; -- don't change the color

      local playerHeight, parsedPlayer, playerExact = RPTAGS.utils.parse.height(getChara("HE", "player"));
      local unitHeight,   parsedUnit,   unitExact   = RPTAGS.utils.parse.height(getChara("HE", u));
      if not parsedPlayer then return ""; end; -- don't change the color
      if not parsedUnit   then return "|cff" .. Config.get("COLOR_UNKNOWN"); end;

      return compareColor(playerHeight, unitHeight, playerExact and unitExact);
    end;

          -- returns a color based on the unit's weight relative to the player
    local function getRelativeWeightColor(u) if not UnitIsPlayer(u) then return ""; end; -- don't change the color
      if not Config.get("PARSE_HW")                             then return ""; end; -- don't change the color

      local playerWeight, parsedPlayer, playerExact = RPTAGS.utils.parse.weight(getChara("WE", "player"));
      local unitWeight,   parsedUnit,   unitExact   = RPTAGS.utils.parse.weight(getChara("WE", u));
      if not parsedPlayer then return ""; end; -- don't change the color
      if not parsedUnit   then return "|cff" .. Config.get("COLOR_UNKNOWN"); end;

      return compareColor(playerWeight, unitWeight, playerExact and unitExact);
    end;

          -- hilite colors
--     local function getHiliteColor(n) if not n then n = 1; end; return "|cff" .. Config.get("COLOR_HILITE_" .. n); end; -- moved to get-shared

    local function getRelationColor(u)
          if not UnitIsPlayer(u) then return ""; end; -- don't change the color
          local profileID = getProfileID(u);
          if not profileID then return ""; end; -- don't change the color
          local rel = TRP3_API.register.relation.getRelation(profileID);
          if rel == "NONE" then return "" else return CONST.RELCOLOR[rel]; end;
    end;

    local function getGuildStatusColor(u) 
          if not UnitIsPlayer(u) then return "|cff" .. Config.get("COLOR_NPC") end;
          local  guildStyle = getField("misc/ST/6", u)
          local  guildName, _, _ = GetGuildInfo(u);
          if     guildName  == nil then return "|cff" .. Config.get("COLOR_UNKNOWN")
          elseif guildStyle == "1" then return "|cff" .. Config.get("COLOR_IC")
          elseif guildStyle == "2" then return "|cff" .. Config.get("COLOR_OOC")
          else                          return "|cff" .. Config.get("COLOR_UNKNOWN")
          end; -- if
    end; -- function

    local function ico(path, tint, param) if not path then return "" end;

          if     not param            then param = PARAMS.DEFAULT
          elseif PARAMS[param] ~= nil then param = PARAMS[param]
                                      else param = PARAMS.DEFAULT  end; -- if not param

          local val = "|TInterface\\" .. path .. ":" .. param;
          if tint then local r, g, b = splitRGB(tint); val = val..":"..r..":"..g..":"..b; end; -- if tint
          val = val .. "|t";
          return val;
    end; -- function

    local function getGlanceIcons(u) if not UnitIsPlayer(u) then return "" end;
          return getGlance(1, u, false, false, true)
             ..  getGlance(2, u, false, false, true)
             ..  getGlance(3, u, false, false, true)
             ..  getGlance(4, u, false, false, true)
             ..  getGlance(5, u, false, false, true);
    end;

          -- returns the default user icon
    local function unitIcon(u)
          local iconName = getChara("IC", u)
          if not iconName or iconName == "" then return ""; end; -- show nothing if they have no icon?
          return ico("ICONS\\" .. iconName);
    end;

    local function getGenderIcon(u)
          local genderField, genderCode = getGender(u);
          if not match(genderField, loc("GENDER_UNKNOWN")) and genderCode == "UNKNOWN"
          then return unitIcon(u); -- if they have a unique gender field then return their picture
          else return ico(GENDER[genderCode], Config.get("COLOR_" .. genderCode), genderCode)
          end; -- if/then/else
    end;

    local function getStatusIcon(u)
          local tint;
          if UnitIsPlayer(u)
             then local status = getField("character/RP", u); -- get the status
                  if        status == "1" then tint = Config.get("COLOR_IC")
                     elseif status == "2" then tint = Config.get("COLOR_OOC");
                     else                      tint = Config.get("COLOR_UNKNOWN")
                     end; -- if/elseif/else
             else tint = Config.get("COLOR_NPC");
             end; -- if player
          return ico(STATUS, tint);
    end;

    local function relationshipIcon(u)
          local profileID = getProfileID(u);
          if profileID then return ico("ICONS\\" ..  TRP3_API.register.relation.getRelationTexture(profileID)) else return ""; end; -- if
    end;

    local function getProfileSize(u, request) if not u then return "" end;
      local BIG_PROFILE = RPTAGS.CONST.BIG_PROFILE;
      local pick = getField("about/TE", u);
      local size;

      if     pick == "1" then size = getField("about/T1/TX", u):len()
      elseif pick == "3" then size = getField("about/T3/PH", u):len() +
                                     getField("about/T3/PS", u):len() +
                                     getField("about/T3/HI", u):len();
      elseif pick == "2" then size = 0;
                              local unitID  = getUnitID(u);       if not unitID  then return "" end;
                              local profile = getProfile(unitID); if not profile then return "" end;

                              if    profile.about and profile.about.T2
                              then for _, section in ipairs(profile.about.T2) do size = size + (section.TX and section.TX:len() or 0); end;
                              else return ""
                              end; -- if profile.about.T2
      else   return ""
      end; -- if pick = 1, 3, 2

      -- size now contains the total size in characters
      local blocks = math.floor(size / 255);
      local word = RPTAGS.utils.format.sizewords(blocks, BIG_PROFILE, Config.get("PROFILESIZE_FMT"));

      if     size    == 0       then return ""
      elseif request == "word"  then return word
      elseif request == "color" then local hue = redToGreenHue(blocks, 0, BIG_PROFILE, true);
                                     local r, g, b = hsvToRgb(hue, 1, 1, 1);
                                     return colorCode(r, g, b);
      else return ""
      end; -- if request

    end; -- function

    local function getRaceIcon(u)
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
    
    --
    RPTAGS.utils.get                   = RPTAGS.utils.get or {};
    RPTAGS.utils.get.color             = RPTAGS.utils.get.color or {};
    RPTAGS.utils.get.color.age         = getRelativeAgeColor;
    RPTAGS.utils.get.color.custom      = getColor;
    RPTAGS.utils.get.color.eye         = getEyeColor;
    RPTAGS.utils.get.color.gender      = getGenderColor;
    RPTAGS.utils.get.color.guildstatus = getGuildStatusColor;
    RPTAGS.utils.get.color.height      = getRelativeHeightColor;
    RPTAGS.utils.get.color.name        = getNameColor;
    RPTAGS.utils.get.color.relation    = getRelationColor;
    RPTAGS.utils.get.color.status      = getStatusColor;
    RPTAGS.utils.get.color.weight      = getRelativeWeightColor;
    RPTAGS.utils.get.core              = RPTAGS.utils.get.core or {};
    RPTAGS.utils.get.core.chara        = getChara;
    RPTAGS.utils.get.core.data         = getData;
    RPTAGS.utils.get.core.field        = getField;
    RPTAGS.utils.get.core.misc         = getMisc;
    RPTAGS.utils.get.core.unitID       = getUnitID;
    RPTAGS.utils.get.icon              = RPTAGS.utils.get.icon or {};
    RPTAGS.utils.get.icon.gender       = getGenderIcon;
    RPTAGS.utils.get.icon.glances      = getGlanceIcons;
    RPTAGS.utils.get.icon.relation     = relationshipIcon;
    RPTAGS.utils.get.icon.status       = getStatusIcon;
    RPTAGS.utils.get.icon.unit         = unitIcon;
    RPTAGS.utils.get.icon              = RPTAGS.utils.get.icon or {};
    RPTAGS.utils.get.text.age          = getAge;
    RPTAGS.utils.get.text.birthplace   = getBP;
    RPTAGS.utils.get.text.class        = getClass;
    RPTAGS.utils.get.text.client       = getClientInfo;
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
    RPTAGS.utils.get.text.misc         = getMiscAndTweakOutput;
    RPTAGS.utils.get.text.name         = getName;
    RPTAGS.utils.get.text.note         = scanNote;
    RPTAGS.utils.get.text.ooc          = getOocStatus;
    RPTAGS.utils.get.text.profileSize  = getProfileSize;
    RPTAGS.utils.get.text.pronoun      = getPronoun;
    RPTAGS.utils.get.text.pronouns     = getAllPronouns;
    RPTAGS.utils.get.text.race         = getRace;
    RPTAGS.utils.get.text.relation     = getRelation;
    RPTAGS.utils.get.text.relwho       = getRelWho;
    RPTAGS.utils.get.text.status       = getStatus;
    RPTAGS.utils.get.text.style        = getRoleplayingStyle;
    RPTAGS.utils.get.text.title        = getTitle;
    RPTAGS.utils.get.text.weight       = getWeight;
    RPTAGS.utils.get.text.xp           = getExperience;
    RPTAGS.utils.get.text.years        = getYears;
    RPTAGS.utils.get.icon.race         = getRaceIcon;
    RPTAGS.utils.get.text.extStatus    = RPTAGS.utils.text.unsup;

  end
);
