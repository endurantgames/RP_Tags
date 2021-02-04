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

  RPTAGS.cache.plugins = RPTAGS.cache.plugins or {};
  local PCache = RPTAGS.cache.plugins;

  local function addOptions(addOnName, location, options)
    if   addOnName and location and options
    then PCache[location] = PCache[location] or {};
         PCache[location][addOnName] = PCache[location][addOnName] or {};
         local MountPoint = PCache[location][addOnName]
         for k, v in pairs(options)
         do  if   v.order 
             then v.order = 1999 + v.order;
             else v.order = 1000 + RPTAGS.utils.options.source_order();
             end;
             MountPoint[k] = v;
         end;
    end;
  end;

  local function registerTargetFunction(target, funcType, func)
    if RPTAGS.cache.addOns.targets[target]
    then RPTAGS.cache.addOns.targets[target][funcType]= func;
    elseif RPTAGS.cache.addOns.other[target]
    then RPTAGS.cache.addOns.other[target][funcType] = func;
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

  RPTAGS.utils.modules.registerFunction = registerTargetFunction;
  RPTAGS.utils.modules.extend           = extendUtility;
  RPTAGS.utils.modules.addOptions       = addOptions;
end);

