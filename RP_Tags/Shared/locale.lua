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

  -- Utils-Locale: Utilities for localizing text strings
  --
  -- List of functions at the end

local RPTAGS        = RPTAGS;
RPTAGS.queue:WaitUntil("UTILS_LOCALE",
function(self, event, ...)

local LOC_          = RPTAGS.CONST.LOC  or "";
local FLOC_         = RPTAGS.CONST.FLOC or "FMT_";
RPTAGS.utils        = RPTAGS.utils        or {};
RPTAGS.utils.locale = RPTAGS.utils.locale or {};

local function load_locale()
  RPTAGS.cache = RPTAGS.cache or {};
  RPTAGS.cache.locale = RPTAGS.cache.locale or LibStub("AceLocale-3.0"):GetLocale(RPTAGS.CONST.APP_ID);
end;

-- localization
local function loc(key) return RPTAGS.cache.locale[LOC_ .. key]; end;
local function floc(f)  return RPTAGS.cache.locale[FLOC_ .. f  ]; end; 
local function hloc(k)  return Utils.text.hilite(RPTAGS.cache.locale[LOC_ .. key]); end;

-- Functions available under RPTAGS.utils.locale
--
RPTAGS.utils.locale.loc  = loc;
RPTAGS.utils.locale.floc = floc;
RPTAGS.utils.locale.hloc = hloc;
RPTAGS.utils.locale.load = load_locale;

end);
