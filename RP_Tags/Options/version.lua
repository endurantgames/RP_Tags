-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 

local RPTAGS          = RPTAGS;

RPTAGS.queue:WaitUntil("before OPTIONS_ABOUT",
function(self, event, ...)
-- RPQ -----------------------------------------------------------------------------------------------------------------------------------------------
  
  local Utils              = RPTAGS.utils;
  local build_markdown     = Utils.options.markdown;
  local build_blank_line   = Utils.options.blank_line;
  local loc                = Utils.locale.loc;

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

  RPTAGS.options = RPTAGS.options or {};
  RPTAGS.options.version = RPTAGS.build_panel_version;
 
-- RPQ -----------------------------------------------------------------------------------------------------------------------------------------------
end);
