-- RP Tags CrossRP dataSource Module
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International (CC BY 4.0) license. 

local RPTAGS = RPTAGS;
local addOnName, ns = ...;
local loc = RPTAGS.utils.locale.loc;
local Config = RPTAGS.utils.config;


local moduleName, ns = ...
local Module = RPTAGS.queue:NewModule(moduleName)

local rpTagsVersion = "9.0.2.7";

RPTAGS.queue:NewModuleType("dataSource");
local Module = RPTAGS.queue:NewModule(addOnName, "dataSource");

-- Callback functions don't need to return a value, although if they return a value it should
-- a table. If the table has a value of error = true, then the program will terminate; if
-- there is a value for errorMessage, that will be displayed to the user.
--
Module:WaitUntil("after UTILS_GET",
function(self, event, ...)
-- RPQ  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 

  local Main=_G["CrossRP"];

  local CONST      = RPTAGS.CONST or {};
  CONST.elixirID   = 2460;
  CONST.elixirName = loc("Elixir of Tongues") or "Elixir of Tongues";

  local function elixirBuffScanner(unit)
    local elixirBuff = nil;

    for i = 1,40 -- iterate through the unit's buffs
    do  local buff = {};
              buff.name,      buff.icon, 
              buff.count,     buff.dispelType, 
              buff.duration,  buff.expirationTime, 
              buff.source,    buff.isStealable, 
              buff.nameplateShowPersonal, 
              buff.spellID 
            = UnitAura(unit,i,"HELPFUL");
        if    buff.spellID == CONST.elixirID 
        or    buff.name    == CONST.elixirName
        then  elixirBuff = buff;
              break; -- leave the loop early
         end;
    end; -- for i = 1,40

    if not elixirBuff 
    then   return false
    else   return true, elixirBuff;
    end;
  end;

  local function hasElixirBuff(unit) if not UnitIsPlayer(unit) then return false end;
    local hasBuff, elixirBuff = elixirBuffScanner(unit);
    return hasBuff;
  end;

  local function elixirBuffTag if not UnitIsPlayer(unit) then return "" end;
    local hasBuff, elixirBuff = elixirBuffScanner(unit);
    if    hasBuff
    then  return Config.get("ELIXIRBUFF_FMT")
    else return "";
  end;

  local function elixirBuffIcon(unit) if not UnitIsPlayer(unit) then return "" end;
    local hasBuff, elixirBuff = elixirBuffScanner(unit);
    if not hasBuff then return "";
    else   if Config.get("ELIXIRBUFFICON_FMT") 
           then 
           else 
           end;
    end;
  end;

  local function getElixirBuffTime(unit) if not UnitIsPlayer(unit) then return "" end;
    local hasBuff, elixirBuff = elixirBuffScanner(unit);
    if not hasBuff then return "";
    else if Config.get("ELIXIRBUFFTIME_FMT")
         then
         else
         end;
    end;
  end;

  local function getElixirBuffInfo(unit) if not UnitIsPlayer(unit) then return "" end;
    local hasBuff, elixirBuff = elixirBuffScanner(unit);
    if hasBuff then return elixirBuff else return {} end;
  end;
    
  RPTAGS.utils.get.crossrp =
  { elixir     = hasElixirBuff,
    elixirData = getElixirBuffInfo,
    elixirIcon = getElixirBuffIcon,
    elixirTime = getElixirBuffTime
  };
    
-- /RPQ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
end);

RPTAGS.queue:WaitUntil("OPTIONS_GENERAL",
function(self, event, ...)
-- RPQ  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 

  

-- /RPQ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
end);

-- UnitFrames modules _must_ extend the registerTag and refresh (frame)
-- functions, as shown here:
Module:WaitUntil("UTILS_TAGS",
function(self, event, ...)
-- RPQ  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 
  
  local function myNiftyTagRegisterer(tagName, tagMethod, extraEvents)
     SomeProgram.events[tag] = RPTAGS.UTILS.MAIN_EVENT .. 
                               (extraEvents and (" " .. extraEvents) or "");
     SomeProgram.methods[tag] = tagMethod;
  end;

  RPTAGS.utils.modules.extend(
    { ["tags.registerTag"] = myNiftyTagRegisterer,
    }
 );
-- /RPQ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
end);

Module:WaitUntil("UTILS_FRAMES",
function(self, event, ...)
-- RPQ  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 

  local function myNiftyFrameUpdater(frameName)
     SomeProgram.update.frame(frameName);
  end;

  RPTAGS.utils.modules.extend(
    { ["frames.refresh"] = myNiftyFrameUpdater,
    }
 );
-- /RPQ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
end);

-- To add configuration options, call the addOptions function *before*
-- DATA_OPTIONS executes, like this:
Module:WaitUntil("before DATA_OPTIONS",
function(self, event, ...)
-- RPQ  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 

  -- Most of the RPTAGS.utils.options functions will automatically do a loc()
  -- on their text arguments, so make sure to declare localizations for those.
  -- It's recommended, but not required, that you separate the localizations
  -- into a Locale/enUS.lua (or whatever) file.
  --
  local build = RPTAGS.utils.options;
  local addOptions = RPTAGS.utils.modules.addOptions;

  addOptions(moduleName, "formats",
    

  RPTAGS.utils.modules.addOptions(moduleName, "keybind",
    { activate_my_module = build.keybind("activate my module") 
    });

  RPTAGS.utils.modules.addOptions(moduleName, "about",
    { myModule = build.markdown( { loc("OPT_MY_MODULE"), loc("MY_MODULE_MD") }) 
    });

-- /RPQ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
end);

-- For the full list of events currently loaded by RPTAGS, see
-- RP_Tags/RP_Tags.lua
Module:WaitUntil("ADDON_LOAD",
function(self, event, ...)
-- RPQ  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 

   if RPTAGS.utils.config.get("LOGIN_MESSAGE")
   then print("[|cffbb00bbMyAddon|r] Addon loaded.");
   end;

-- /RPQ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
end);
