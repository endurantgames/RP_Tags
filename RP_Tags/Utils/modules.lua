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

  -- Moduless

local RPTAGS = RPTAGS;

RPTAGS.queue:WaitUntil("UTILS_MODULES",
function(self, event, ...)

  RPTAGS.cache.plugins = {};

  local function addPluginOptions(location, title, options)
    if location and title and options
    then RPTAGS.cache.plugins[location] = RPTAGS.cache.plugins[location] or {};
         RPTAGS.cache.plugins[location][title] = options
    end;
  end;

  RPTAGS.utils.modules = RPTAGS.utils.modules or {};

  local function extendUtility(oldFuncList)
     for oldFuncName, newFunc in pairs(oldFuncList)
     do  local category, funcName = strsplit("[%./]", oldFuncName);
         local oldFunc = RPTAGS.utils[category][funcName];

         RPTAGS.utils[category][funcName] = 
         function(...) 
           return newFunc(unpack( { oldFunc(...) } )); 
                               -- ^   these      ^ curly braces are necessary
         end;
    end;
  end;

  RPTAGS.utils.modules.extend = extendUtility;
  RPTAGS.utils.modules.plugOptions = addPluginOptions;
end);

