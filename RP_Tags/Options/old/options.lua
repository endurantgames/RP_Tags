-- ------------------------------------------------------------------------------
-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 
-- Utils-Config: Utilities for reading and registering configuration values

local RPTAGS          = RPTAGS;

RPTAGS.queue:WaitUntil("UTILS_OPTIONS",
function(self, event, ...)
-- RPQ -----------------------------------------------------------------------------------------------------------------------------------------------
  
  local Utils              = RPTAGS.utils;
  local Config             = Utils.config;
  local loc                = Utils.locale.loc;
  local hilite             = Utils.text.hilite;
  local hi                 = Utils.text.hilite;
  local APP_NAME           = loc("APP_NAME");
  local refreshAll         = Utils.tags.refreshAll;
  local weights            = Utils.format.kg;
  local heights            = Utils.format.cm;
  local sizebuffs          = Utils.format.sizebuff;
  local profilesizes       = Utils.format.sizewords;
  local unsup              = Utils.format.unsup;
  local notify             = Utils.text.notify;
  local AceConfigDialog    = LibStub("AceConfigDialog-3.0");
  local AceGUI             = LibStub("AceGUI-3.0");
  local LibSharedMedia     = LibStub("LibSharedMedia-3.0");
  local split              = Utils.text.split;

  local function build_panel_version(hidden, disabled)
        
       local args = {}

       local function build_addOn(addOn)
         local name = addOn.title or addOn.name;
         local version = addOn.version 
                         and addOn.version:gsub(" alpha ", "a"):gsub(" beta ", "b")
                         or "";
         local rpqType = addOn.rpqType;

         if not rpqType then rpqType = ""
         -- elseif rpqType == "core" or rpqType == "header" or rpqType:match("^targetOf")
         -- then   rpqType = loc("RPQ_TYPE_" .. rpqType:upper()); 
         else   rpqType = loc("RPQ_TYPE_" .. rpqType:upper());
         end;

         if not addOn.enabled 
         then    name = "|cff808080" ..    name:gsub("|cff%x%x%x%x%x%x",""):gsub("|r","") .. "|r";
              version = "|cff808080" .. version:gsub("|cff%x%x%x%x%x%x",""):gsub("|r","") .. "|r";
              rpqType = "|cff808080" .. rpqType:gsub("|cff%x%x%x%x%x%x",""):gsub("|r","") .. "|r";
         end;
        
         local displayName;
         if addOn.func and addOn.func.open and type(addOn.func.open) == "function"
         then displayName = "[" .. name .. "](addon://" .. addOn.name .. "?open)";
         else displayName = name;
         end;

         args[addOn.name .. "Name"] =
         { type           = "description",
           fontSize       = "small",
           order          = source_order(),
           width          = 1.5,
           dialogControl = "LMD30_Description",
           name           = displayName,
         };

         args[addOn.name .. "Version"]     =
         { type           = "description",
           order          = source_order(),
           width          = 0.5,
           fontSize       = "small",
           dialogControl = "LMD30_Description",
           name           = version,
         };

         args[addOn.name .. "Type"] =
         { type           = "description",
           order          = source_order(),
           width          = 1,
           fontSize       = "small",
           dialogControl = "LMD30_Description",
           name           = rpqType,
         };
       end;

       args.tableHeader = build_addOn(
        { name = "TableHeader", 
          title = loc("RPQ_HEADER_NAME"),
          version = loc("RPQ_HEADER_VERSION"),
          rpqType = "header",
          enabled = true,
        }
      );   

      args.blankAfterHeader = build_blank_line();

      args[RPTAGS.addOnName] = build_addOn(RPTAGS.cache.addOns.core[RPTAGS.addOnName]);
     
      local function build_category(cat)

        for addOnName, addOnData in pairs(RPTAGS.cache.addOns[cat])
        do  args[addOnName] = build_addOn(addOnData);
            local target = RPTAGS.cache.addOns.other[addOnData.target];

            if    target
            then  args[addOnData.target] = build_addOn(target);
            end;
        end;

        for addOnName, addOnData in pairs(RPTAGS.cache.addOns[cat])
        do  args[addOnName] = build_addOn(addOnData);
        end;

      end;

      for _, category in ipairs({ "rpClient", "rpClient_0", "unitFrames", "unitFrames_0"})
      do  if   RPTAGS.cache.addOns[category]
          then build_category(category);
          end;
      end;


      if   RPTAGS.cache.addOns.targets ~= {}
      then args.blankBeforeTargets = build_blank_line();
           build_category("targets");
      end;

      args.blankBeforeFollowUp = build_blank_line();

      args.followUpText = build_markdown(loc("RPQ_FOLLOWUP"));

      local w =
      { type = "group",
        name = loc("OPT_VERSION"),
        order = source_order(),
        args = args,
      };

      return w;
  end;

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

  local function build_panel_taghelp()
    
    local function build_tag_help(tag)
      local w =
      { name = tag.desc,
        order = source_order(),
        type = "input",
        width = 0.66,
        disabled = RPTAGS.CONST.UNSUP[tagName],
        get = function() return "[" .. tag.name .. "]" end,
      };
      return w
    end;
  
    local function build_subtitle_help(tag)
      local w =
      { name = tag.title,
        type = "header",
        order = source_order(),
        width = "full",
      };
      return w;
    end;
  
    local function build_tag_group_help(group)
      local   args = {};
      args.groupHelp = 
      { type = "description",
        name = "## " .. group.title .. " " .. loc("TAGS") .. "\n\n" .. group.help,
        order = source_order(),
        width = "full",
        dialogControl = "LMD30_Description",
      };
      for i,  tag in pairs(group.tags)
      do  if     tag.title 
          then   args[tag.title] = build_subtitle_help(tag, group)
          elseif tag.name and tag.desc
          then   args[tag.name] = build_tag_help(tag, group)
                 args["spacer_" .. i] = build_spacer();
          end;
      end;

      local w =
      { type = "group",
        name = group.title .. " " .. loc("TAGS") ,
        order = source_order(),
        args = args,
      };
        
      return w;
    end;
  
    local args = {}
    for _, group in pairs(RPTAGS.CONST.TAG_DATA)
    do  args[group.key] = build_tag_group_help(group)
    end;
  
    local w =
    { type = "group",
      name = loc("OPT_TAG_REFERENCE"),
      -- childGroups = "select",
      order = source_order(),
      args = args,
    };
  
    return w;
  
  end; -- 

  RPTAGS.options = RPTAGS.options or {};
  RPTAGS.options.
 
-- RPQ -----------------------------------------------------------------------------------------------------------------------------------------------
end);
