-- ------------------------------------------------------------------------------
-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 

local RPTAGS          = RPTAGS;

RPTAGS.queue:WaitUntil("before OPTIONS_HELP",
function(self, event, ...)
-- RPQ -----------------------------------------------------------------------------------------------------------------------------------------------
  
  local Utils              = RPTAGS.utils;
  local loc                = Utils.locale.loc;
  local build_markdown     = Utils.options.markdown;
  local source_order       = Utils.options.source_order

  local function build_recipe(str)
      RPTAGS.cache.recipes = RPTAGS.cache.recipes or {};
      local str = "RECIPE_" .. str:gsub("%s+","_"):upper();
      local desc = build_markdown(
                     "### " .. loc(str .. "_TITLE") .. "\n\n"
                     .. loc(str .. "_TT")
                   );
      local box = 
            { type = "input",
              order = source_order(),
              name = "",
              get = function(self) return loc(str) end,
              width = 1.5,
              desc = loc(str .. "_TT"),
            };
                    
      local w =
      { type = "group",
        name = loc(str .. "_TITLE"),
        order = source_order(),
        args =
        { desc = desc,
          box = box,
        }
      };
      return w;
    
  end;

  RPTAGS.options = RPTAGS.options or {};
  RPTAGS.options.recipe = build_recipe;
 
-- RPQ -----------------------------------------------------------------------------------------------------------------------------------------------
end);
