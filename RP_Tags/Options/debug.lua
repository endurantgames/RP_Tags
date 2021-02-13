-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 

local RPTAGS          = RPTAGS;

RPTAGS.queue:WaitUntil("before OPTIONS_ABOUT",
function(self, event, ...)
-- RPQ -----------------------------------------------------------------------------------------------------------------------------------------------
  
  local Utils            = RPTAGS.utils;
  local build_blank_line = Utils.options.blank_line;
  local build_markdown   = Utils.options.markdown;
  local hasFunc          = Utils.modules.getFunction;
  local loc              = Utils.locale.loc;
  local source_order     = Utils.options.source_order;

  local debugMessage = "To load debugging information, erase this message and replace it with only the following, no blank lines or leading spaces:\n\n    |cffff0000debug|r |cffffff00libs|r\n    |cffff0000debug|r |cffffff00addons|r\n    |cffff0000debug|r |cffffff00config|r\n\nYou can enter more than one, separated by spaces, but this is |cffff0000NOT|r recommended as it may cause your WoW client to lag indefinitely.";
  RPTAGS.cache.debug = debugMessage;

  local function get_debug_info()
    local value = RPTAGS.cache.debug:gsub("\n+$",""):gsub("^\n*%s*",""):gsub("|cff%x%x%x%x%x%x",""):gsub("|r", "");

    if not value:match("^debug [%a ]+$")
    then return debugMessage 
    else local details          = {};
         local FMT              = "%-25s = %s";
         local HDR              = "[%s]";

         local function N(v)          
         return 
              type(v) == "string" and v:gsub("|","||"):gsub("\n","\\n")
           or type(v) == "number" and v 
           or type(v) == "boolean" and v and "true"
           or type(v) == "boolean" and "false"
           or type(v) 
         end;
       local function P(k, v, lev)    return string.rep("  ", lev) ..  string.format(FMT, N(k), N(v))            end;
       local function H(str, lev)     return string.rep("  ", lev) ..  string.format(HDR, N(str))                end;
       local function addH(str, lev)  table.insert(details, H(str, lev))                 end;
       local function addP(k, v, lev) table.insert(details, P(k, v, lev))                end;
       local function addB()                            table.insert(details, " ")                           end;
   
       local function walk(tab, lev)
         for k, v in pairs(tab)
         do  if type(v) == "table"
             then addH(k, lev); 
                  walk(v, lev + 1);
             else addP(k, v, lev)
             end;
         end;
       end;
   
       local sections = { strsplit(" ", value:gsub("^debug ", "")) };
       for i = 1, math.min(#sections, 2)
       do  local sec = sections[i];
           if sec:match("^lib")
           then addH("Libraries", 0); 
                for lib in LibStub:IterateLibraries() 
                do  local _, minor = LibStub(lib); addP(lib, minor, 1); 
                end;
          elseif sec:match("^addon")
          then addH("AddOns", 0); 
               walk(RPTAGS.cache.addOns, 1);
          elseif sec:match("^config")
          then addH("Config", 0); 
               walk(RP_TagsDB, 1); 
          else addH("Unknown Parameter", 0);
               addP("debug", sec);
          end;
          addB();
       end;

       addH("Done", 0);
       return table.concat(details, "\n");
    end;
  end;
   
  local w =
  { type = "group",
    name = "Debugging",
    order = source_order(),
    width = "full",
    args = 
    { header = 
      { type = "header",
        name = "System State",
        order = source_order(),
        width = "full",
      },
      details =
      { type = "input",
        name = "Details",
        width = "full",
        order = source_order(),
        get = function(self) return get_debug_info(RPTAGS.cache.debug) end,
        set = function(self, value) RPTAGS.cache.debug = value; end,
        multiline = 10,
      },
    },
  };

            
  -- local function build_recipe(str)
      -- RPTAGS.cache.recipes = RPTAGS.cache.recipes or {};
      -- local str = "RECIPE_" .. str:gsub("%s+","_"):upper();
      -- local desc = build_markdown(
                     -- "### " .. loc(str .. "_TITLE") .. "\n\n"
                     -- .. loc(str .. "_TT")
                   -- );
      -- local box = 
            -- { type = "input",
              -- order = source_order(),
              -- name = "",
              -- get = function(self) return loc(str) end,
              -- width = 1.5,
              -- desc = loc(str .. "_TT"),
            -- };
                    -- 
      -- local w =
      -- { type = "group",
        -- name = loc(str .. "_TITLE"),
        -- order = source_order(),
        -- args =
        -- { desc = desc,
          -- box = box,
        -- }
      -- };
      -- return w;
    -- 
  -- end;

  -- RPTAGS.utils.options.recipe = build_recipe;

  RPTAGS.options.debug = w;

-- RPQ -----------------------------------------------------------------------------------------------------------------------------------------------
end);
