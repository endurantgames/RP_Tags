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
--
-- Utils-Format: Utilities for formatting text or numeric values for display
--
-- List of functions at the end

local RPTAGS     = RPTAGS;
RPTAGS.queue:WaitUntil("UTILS_FORMATS",
function(self, event, ...)


local Utils      = RPTAGS.utils;
local CONST      = RPTAGS.CONST;

if not Utils.format then Utils.format = {} end;
local Format = Utils.format;

local Config     = RPTAGS.utils.config;
local loc        = Utils.locale.loc;
local floc       = Utils.locale.floc;
local sizeBuffs  = CONST.SIZEBUFFS;
local LONG, MEDIUM, SHORT, VERYSHORT = CONST.LONG, CONST.MEDIUM, CONST.SHORT, CONST.VERYSHORT;
                                       -- we don't actually need CONST.VERYLONG for this

local fmt        = string.format;

-- -----------------------------------------------------------------------------------------
-- format a string representing a sizebuff
local function format_sizebuff(sizeBuff, optionalFormat, isPandaren) -- sizeBuff is a spellID
  local sizeChange;
  local buffName;

  if    not sizeBuff or not sizeBuffs[sizeBuff] then return "" end;
  
  sizeChange = sizeBuffs[sizeBuff]["sizeChange"];
  buffName   = sizeBuffs[sizeBuff]["buffName"];
  if   isPandaren and sizeBuffs[sizeBuff]["foodBuff"]
  then sizeChange = sizeChange * 2;
  end;

  local F = 
  { [ "PCT"]          = fmt(floc("SB_PCT"),          sizeChange),
    [ "PCT_BRC"]      = fmt(floc("SB_PCT_BRC"),      sizeChange),
    [ "PCT_BUFF"]     = fmt(floc("SB_PCT_BUFF"),     sizeChange, buffName),
    [ "BUFF_PCT"]     = fmt(floc("SB_BUFF_PCT"),     buffName, sizeChange),
    [ "BUFF"]         = fmt(floc("SB_BUFF"),         buffName),
    [ "BUFF_BRC"]     = fmt(floc("SB_BUFF_BRC"),     buffName),
    [ "BUFF_PCT_BRC"] = fmt(floc("SB_BUFF_PCT_BRC"), buffName, sizeChange),
    [ "ICON"]         = RPTAGS.CONST.ICONS.T_ .. GetSpellTexture(sizeBuff) .. RPTAGS.CONST.ICONS._t,
  };

  return sizeChange == 0 and "" or F[outFormat or Config.get("SIZEBUFF_FMT") or "PCT_BRC"];
end   

      -- format a number in centimeters; returns a string and a table ------------------------------------------------
local function format_cm(num, optionalFormat)
  local cm         = tonumber(num); 
  
  if not cm then return num, nil end; -- if we don't have centimeters

  local asCm       = math.floor(0.5 + cm);
  local asIn       = math.floor(0.5 + asCm / 2.54);
  local asFt       = math.floor(asIn / 12);
  local asInWithFt = math.floor(0.5 + asIn % 12);

  local F =
  { ["CM"]              = fmt(floc("CM"),       asCm),
    ["CM_FT_IN"]        = fmt(floc("CM_FT_IN"), asCm,  asFt,       asInWithFt),
    ["CM_IN"]           = fmt(floc("CM_IN"),    asCm,  asIn),
    ["FT_IN"]           = fmt(floc("FT_IN"),    asFt,  asInWithFt),
    ["FT_IN_CM"]        = fmt(floc("FT_IN_CM"), asFt,  asInWithFt, asCm),
    ["IN"]              = fmt(floc("IN"),       asIn),
    ["IN_CM"]           = fmt(floc("IN_CM"),    asIn,  asCm), 
    ["HEIGHT_PASSTHRU"] = fmt(floc("HEIGHT_PASSTHRU"), num)
  };

  return F[optionalFormat or Config.get("UNITS_HEIGHT") or "CM_FT_IN"]
end   

      -- format a number in kilograms; returns a string and a table 
local function format_kg(num, optionalFormat)
  local kg         = tonumber(num); 
  if not kg then return num, nil end; -- if it's not a number send back the text
                     -- math calculuations
  local asKg       = math.floor(0.5 + kg);
  local asLb       = math.floor(0.5 + asKg * 2.2);
  local asSt       = math.floor(asLb / 14);
  local asLbWithSt = math.floor(0.5 + asLb % 14);

  local F = 
  { ["KG"]              = fmt(floc("KG"),             asKg),
    ["KG_LB"]           = fmt(floc("KG_LB"),          asKg, asLb),
    ["KG_ST_LB"]        = fmt(floc("KG_ST_LB"),       asKg, asSt,       asLbWithSt),
    ["LB_KG"]           = fmt(floc("LB_KG"),          asLb, asKg),
    ["LB_ST"]           = fmt(floc("LB_ST"),          asLb, asSt,       asLbWithSt),
    ["ST_LB"]           = fmt(floc("ST_LB"),          asSt, asLbWithSt, asLb),
    ["ST_LB_KG"]        = fmt(floc("ST_LB_KG"),       asSt, asLbWithSt, asKg),
    ["ST_LB_LB_KG"]     = fmt(floc("ST_LB_LB_KG"),    asSt, asLbWithSt, asLb, asKg), 
    ["WEIGHT_PASSTHRU"] = fmt(floc("WEIGHT_PASSTHRU"), num),
  };

  local outFormat = optionalFormat or "KG_LB";
  return F[optionaFormat or Config.get("UNITS_WEIGHT") or "KG_LB"]
end   

local function format_unsup(tag, optionalFormat)
  local part = tag:gsub("rp:","");
  local out = {}
  for _, fmtString in ipairs({"??", "?", "", "|cffff0000!!|r", }) -- "TAG", "(TAG)", "[TAG]", "PART", "(PART)", "|cffdd0000TAG|r", "|cffdd0000PART|r", "" })
    do out[fmtString] = (fmtString:gsub("TAG", tag):gsub("PART", part)) .. "|r"
    end;
  return out[optionalFormat or RPTAGS.utils.config.default("UNSUP_TAG") or "??"]
end;

      -- takes a size and maximum size, and returns a string and a list based on the relative size
local function format_sizewords(size, maxSize, optionalFormat)
      local w, l;
      maxSize = maxSize or LONG;
      local scale = maxSize / LONG;
      if        size > maxSize            then w, l = "EXTRA_LARGE", "XL";
         elseif size > scale * MEDIUM     then w, l = "LARGE",        "L";
         elseif size > scale * SHORT      then w, l = "MEDIUM",       "M";
         elseif size > scale * VERYSHORT  then w, l = "SMALL",        "S";
         elseif size > -1                         then w, l = "EXTRA_SMALL", "XS";
                                                  else w, l = "UNKNOWN",      "U"; 
         end; -- if
      local word = loc("SIZE_" .. w);
      local letter = loc("SIZE_" .. l);
      local F = { ["WRD_BRC_NUM"] = fmt(floc("SZ_WRD_BRC_NUM"), word, size),
                    ["WRD_PAR_NUM"] = fmt(floc("SZ_WRD_PAR_NUM"), word, size),
                    ["BRC_WRD_NUM"] = fmt(floc("SZ_BRC_WRD_NUM"), word, size),
                    ["PAR_WRD"]     = fmt(floc("SZ_PAR_WRD"),     word),
                    ["WRD"]         = fmt(floc("SZ_WRD"),         word),
                    ["BRC_LTR_NUM"] = fmt(floc("SZ_BRC_LTR_NUM"), letter, size),
                    ["BRC_LTR"]     = fmt(floc("SZ_BRC_LTR"),     letter),
                    ["LTR"]         = fmt(floc("SZ_LTR"),         letter),
                    ["BRC_NUM"]     = fmt(floc("SZ_BRC_NUM"),     size),
                    ["NUM"]         = fmt(floc("SZ_NUM"),         size), -- ok
                   };
      return F[optionalFormat or Config.get("PROFILESIZE_FMT") or "BRC_LTR"];
end; 

-- Functions available under RPTAGS.utils.format
--
Format.cm        = format_cm;
Format.kg        = format_kg;
Format.sizebuff  = format_sizebuff;
Format.sizewords = format_sizewords;
Format.unsup     = format_unsup;

end);
