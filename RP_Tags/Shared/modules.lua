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

  RPTAGS.cache.Plugins = RPTAGS.cache.Plugins or {};

  local function addOptions(addOnName, location, options)
    local pluginsCache = RPTAGS.cache.Plugins;
    pluginsCache[location]            = pluginsCache[location] or {};
    pluginsCache[location][addOnName] = CopyTable(options);
  end;

  local function applyOptionsPlugins(optionsTable, pluginsCache)
    local function walk(otable, path)
      local curr;
      if type(path) == "string"
      then curr, path = path, nil;
      else curr = table.remove(path, 1);
      end;
      if not (otable and otable.args and otable.args[curr]) then return nil
      elseif not path or #path == 0
      then   return otable.args[curr]
      else   return walk(otable.args[curr], path)
      end;
    end;

    pluginsCache = pluginsCache or RPTAGS.cache.Plugins;
    for location, plugins in pairs(pluginsCache)
    do local mountPoint = walk(optionsTable, { strsplit("%.", location) }) ;
        if mountPoint then mountPoint.plugins = plugins; 
        end;
    end;

    return optionsTable;
  end;

  local function addOptionsPanel(panel, optionsTable)
    local order = RPTAGS.cache.options.optionsOrder;
    local insertPoint = RPTAGS.cache.options.optionsModulesInsert;
    table.insert(order, insertPoint, panel);
    RPTAGS.options[panel] = optionsTable;
    RPTAGS.cache.options.optionsModulesInsert = insertPoint + 1;
  end;

  local function getAddOnData(str)
    if type(str) ~= "string" then return nil, nil end;
    for category, categoryData in pairs(RPTAGS.cache.addOns)
    do if   categoryData[str] 
       then return categoryData[str], category
       end;
    end;
    return nil, nil
  end;

  local function registerAddOnFunction(addOn, funcType, func)
    local knownAddOn = type(addOn) == "string" and getAddOnData(addOn) or addOn;
    if not knownAddOn or type(knownAddOn) ~= "table"
    then print("[|cffff0000registerAddOnFunction|r] Unknown AddOn: " .. addon or "nil");
    else knownAddOn.func = knownAddOn.func or {};
         knownAddOn.func[funcType] = func;
    end;
  end;

  local function getAddOnFunction(addOn, funcName)
    if type(addOn) == "string"
    then addOn = getAddOnData(addOn);
    end;
    if addOn and addOn.func and addOn.func[funcName] and type(addOn.func[funcName]) == "function"
    then return addOn.func[funcName];
    else return nil;
    end;
  end;

  local function runAddOnFunction(addOn, funcName, ...)
    local func = getAddOnFunction(addOn, funcName)
    if func then func(...) return true end;
  end;
     
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

  local function addSlashAlias(aka, param)
  -- This isn't a general add-a-slash-command function; it creates an
  -- alias for the RPTAGS slash command, such as if RP_UnitFrames wants
  -- its own command or something.
  --
    local num = 1;  -- find the next available slash command
    while _G["SLASH_RPTAGS" .. num] do num = num + 1 end;
    if type(param) == "string"
    then _G["SLASH_RPTAGS" .. num] =
           function(a) SlashCmdList["SLASH_RPTAGS"]("open " .. param .. "?" .. a) end;
    elseif type(param) == "function"
    then _G["SLASH_RPTAGS" .. num] = 
           function(a) SlashCmdList["SLASH_RPTAGS"](param(a)) end;
    end;
  end;

  RPTAGS.utils.modules                  = RPTAGS.utils.modules or {};
  RPTAGS.utils.modules.registerFunction = registerAddOnFunction;
  RPTAGS.utils.modules.getFunction      = getAddOnFunction;
  RPTAGS.utils.modules.runFunction      = runAddOnFunction;
  RPTAGS.utils.modules.extend           = extendUtility;
  RPTAGS.utils.modules.addOptions       = addOptions;
  RPTAGS.utils.modules.addOptionsPanel  = addOptionsPanel;
  RPTAGS.utils.modules.addSlashAlias    = addSlashAlias;
  RPTAGS.utils.modules.getAddOn         = getAddOnData;
  RPTAGS.utils.modules.plugOptions      = applyOptionsPlugins;
end);

