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
  local eval               = Utils.tags.eval;

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
              width = "full",
              desc = loc(str .. "_TT"),
            };

      local preview =
            { type = "group",
              name = loc("UI_LIVE_PREVIEW"),
              order = source_order(),
              inline = true,
              args = 
              { preview = 
                { type = "description",
                  order = source_order(),
                  name = function() return eval(loc(str), "player", "player") end,
                },
              },
            };
                    
      local w =
      { type = "group",
        name = loc(str .. "_TITLE"),
        order = source_order(),
        args =
        { desc = desc,
          box = box,
          preview = preview,
        }
      };
      return w;
    
  end;

  RPTAGS.utils.options.recipe = build_recipe;
 
-- RPQ -----------------------------------------------------------------------------------------------------------------------------------------------
end);
