-- ------------------------------------------------------------------------------
-- RP Tags
-- by Oraibi, Moon Guard (US) server
--
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. To view a copy of the license, visit
--
--     https://creativecommons.org/licenses/by/4.0/

-- Utils-Parse: Utilities for analzying a string and converting it to a value for formatting
local RPTAGS = RPTAGS;
RPTAGS.queue:WaitUntil("UTILS_PARSE",

function(self, event, ...)

RPTAGS.utils.parse = RPTAGS.utils.parse or {};
local Utils = RPTAGS.utils
local Parse = Utils.parse;

local loc        = Utils.locale.loc;
local isnum      = Utils.text.isnum;
local match      = Utils.text.match;
local split      = Utils.text.split;
local Config     = Utils.config;
local rot13      = Utils.text.rot13;

-- ---------------------------------------------------------------------------------------------------------------------
      -- returns a numeric value, a boolean indicating if parsed, and a boolean indicating if exact value
local function parseAge(s, race)

      local age, success, exact = 0, false, false;
      local num = tonumber;
      
      s = string.gsub(s, ",", ""); -- so we can say "5,000 years"

      local ish    = string.match(s, "(%d+)ish");
      local years  = string.match(s, "(%d+) years");
      local cent   = string.match(s, "(%d+) centuries");
      local mill   = string.match(s, "([%d.]+) millen+ia");
      local dec    = string.match(s, "(%d+)s");
      local number = string.match(s, "(%d+)");

      if       isnum(s)      then age = num(s);           success = true; exact = true;
        elseif isnum(ish)    then age = num(ish);         success = true; exact = false; 
        elseif isnum(years)  then age = num(years);       success = true; exact = true;
        elseif isnum(cent)   then age = num(cent) * 100;  success = true; exact = false;
        elseif isnum(mill)   then age = num(mill) * 1000; success = true; exact = false;
        elseif isnum(dec)    then age = num(dec) + 5;     success = true; exact = false;
        elseif isnum(number) then age = num(number);      success = true; exact = true;
      end; -- if

      if match(s, loc("ABOUT")) then exact = false; end;
      if match(s, race)         then exact = false; end;

      return age, success, exact;
end;  

-- ---------------------------------------------------------------------------------------------------------------------
      -- returns a numeric value, a boolean indicating if parsed, and a boolean indicating if exact value
local function parseHeight(s)

      local height, success, exact = 0, false, false;
      local num = tonumber;

      local cm         = string.match(s, "([%d.]+) cm"      );
      local meters     = string.match(s, "([%d.]+) meter"  );
      local fift, fiin = string.match(s, "(%d+)' *(%d+)"    );
      local feet       = string.match(s, "(%d+) feet"      );
      local foft, foin = string.match(s, "(%d+) foot (%d+)");

      if       isnum(s)      then height = num(s);                               success = true; exact = true; 
        elseif isnum(cm)     then height = num(cm);                              success = true; exact = true;
        elseif isnum(meters) then height = num(meters) * 100;                    success = true; exact = true; 
        elseif isnum(fiin)   then height = 30.48 * num(fift) + 2.54 * num(fiin); success = true; exact = true;
        elseif isnum(feet)   then height = 30.48 * num(feet);                    success = true; exact = false;
        elseif isnum(foin)   then height = 30.48 * num(foft) + 2.54 * num(foin); success = true; exact = false;
        end; -- if

      if match(s, loc("ABOUT")) then exact = false; end;

      return math.floor(height + 0.5), success, exact;
end;  

-- ---------------------------------------------------------------------------------------------------------------------
      -- returns a numeric value, a boolean indicating if parsed, and a boolean indicating if exact value
local function parseWeight(s)
      local weight, success, exact = 0, false, false;
      local num = tonumber;

      local lb = string.match(s, "(%d+) lb");
      local pounds = string.match(s, "(%d+) pound");
      local kg = string.match(s, "([%d.]+) kg");
      local kilo = string.match(s, "([%d.]+) kilo");

      if       isnum(s)  then weight = num(s);                 success = true; exact = true; 
        elseif isnum(lb) then weight = num(lb) * 0.45;         success = true; exact = true;
        elseif isnum(pounds) then weight = num(pounds) * 0.45; success = true; exact = true;
        elseif isnum(kg) then weight = num(kg);                success = true; exact = true;
        elseif isnum(kilo) then weight = num(kilo);            success = true; exact = true;
        end; --if

      if match(s, loc("ABOUT")) then exact = false; end;

      return weight, success, exact;
end;  

-- ---------------------------------------------------------------------------------------------------------------------
local function parseGenderString(s)
      local genderList = split(loc("GENDERS"),";");

      for _, t in ipairs(genderList)
        do local genderAliases = loc("GENDER_ALIASES_"  .. t);
           if Config.get("ADULT_GENDERS") 
              then genderAliases = genderAliases .. ";" .. rot13(loc("GENDER_ADULT_" .. t))
              end; -- if
           local aliasList = split(genderAliases,";");

           for _, a in ipairs(aliasList)
             do if match(s, a) then return t, true; end; -- if
             end; -- for
        end; -- for
      return "UNKNOWN", false;
end; 


-- ---------------------------------------------------------------------------------------------------------------------
-- this is preparatory work
local raceData, raceIndex = {}, {};
for raceID = RPTAGS.CONST.RACE_COUNT, 1, -1
do  local raceInfo = C_CreatureInfo.GetRaceInfo(raceID);
    local race = { 
          name = raceInfo.raceName, 
          normalized = raceInfo.clientFileString:gsub("%A", ""):lower(), 
          match = {}, 
          code = raceID, };
    if RPTAGS.CONST.RACE.FALLBACK["RACE_" .. raceID] then race.fallback = RPTAGS.CONST.RACE.FALLBACK["RACE_" .. raceID] end;
    for _, t in ipairs(split(loc("RACE_" .. raceID), ","))
    do local pattern =t:gsub("%A", ""):lower()
       table.insert(race.match, pattern);
    end; -- for t
    table.insert(raceData, race);
    raceIndex[raceID] = race;
    raceIndex[raceInfo.raceName] = race;
end; -- for raceID
for _, raceName in ipairs(RPTAGS.CONST.RACE_OTHERS)
do local race = { name = raceName, normalized = raceName:gsub("%A", ""):lower(), match = {}, code = raceName };
   for _, t in ipairs(split(loc("RACE_" .. raceName:upper()), ","))
   do local pattern = t:gsub("%A",""):lower()
      table.insert(race.match, pattern);
   end;
   table.insert(raceData, race);
   raceIndex[raceName] = race;
end;

RPTAGS.cache.raceData = raceData;   -- save our data just in case we need it later
RPTAGS.cache.raceIndex = raceIndex;

local function normalizeRace(u, why, rpRace) -- returns three values, code, fallback, and racedata
  if   not rpRace then rpRace = "" end;
  if   why == "icon"
  then if raceIndex[rpRace] then return raceIndex[rpRace].code, raceIndex[rpRace].fallback, raceIndex[rpRace] end; 

       for _, race in ipairs(raceData)
       do for _, m in ipairs(race.match) do if string.match(rpRace:gsub("%A",""):lower(), m) then return race.code, race.fallback, race end; end; -- for m
       end; -- for race

       local _, _, raceID = UnitRace(u);
       if raceIndex[raceID] then return raceIndex[raceID].code, raceIndex[raceID].fallback, raceIndex[raceID] end;

       return nil, nil, nil;

  else return nil; -- why is not "icon", we haven't defined other possible reasons so return nothing
  end; -- if
end -- function

local function parseMrpGlanceString(data) -- yoinked from mrp's code.
  local glances = {};
  for icon, title, text in string.gmatch(data, "|T[^\n]+\\([^|:]+).-[\n]*#([^\n]+)[\n]*(.-)[\n]*%-%-%-[\n]*") 
  do table.insert(glances, { icon = icon, title = title, text = text});
  end
  return glances;
end;

-- Functions available under RPTAGS.utils.parse
--
Parse.gender = parseGenderString;
Parse.age    = parseAge;
Parse.weight = parseWeight;
Parse.height = parseHeight;
Parse.race   = normalizeRace; 

end);
