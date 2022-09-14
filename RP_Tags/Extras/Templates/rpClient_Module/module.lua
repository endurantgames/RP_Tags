-- RP Tags Module Template
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 

local moduleName, ns = ...
local  Module = RPTAGS.queue:NewModule(moduleName)

-- Callback functions don't need to return a value, although if they return a value it should
-- a table. If the table has a value of error = true, then the program will terminate; if
-- there is a value for errorMessage, that will be displayed to the user.
--
Module:WaitUntil("ADDON_INIT",
function(self, event, ...)
-- RPQ  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 

-- /RPQ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
end);

-- Modules of the type rpClient will want to support custom functions
-- to get data. RP_Tags_MyRolePlay can be a good example, if LibMSP is
-- being used.
Module:WaitUntil("UTILS_GET",
function(self, event, ...)
-- RPQ  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 

  local function myNiftyGetFunction(field)
    return SomeProgram.data[field]
  end;

  RPTAGS.utils.get.name = myNiftyGetFunction("name");
  RPTAGS.utils.get.race = myNiftyGetFunction("race");

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
