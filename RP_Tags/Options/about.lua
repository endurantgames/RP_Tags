-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 

local RPTAGS = RPTAGS;
local addOnName, ns = ...;

RPTAGS.queue:WaitUntil("OPTIONS_ABOUT",
function(self, event, ...)
-- RPQ -----------------------------------------------------------------------------------------------------------------------------
--
  local Config       = RPTAGS.utils.config;
  local Utils        = RPTAGS.utils;
  local loc          = Utils.locale.loc;
  local hasFunc      = Utils.modules.getFunction;
  local optUtils     = Utils.options;
  local source_order = optUtils.source_order
  local Blank_Line   = optUtils.blank_line;
  local Header       = optUtils.header
  local Instruct     = optUtils.instruct
  local Markdown     = optUtils.markdown
  local Spacer       = optUtils.spacer
  local db           = RP_TagsDB

  local debugMessage = loc("DEBUGGING_MESSAGE_MD");

  RPTAGS.cache.debug = debugMessage;

  local AboutHeader = Markdown(
         string.format(
           loc("FMT_ABOUT_HEADER"),
           loc("APP_NAME"),
           GetAddOnMetadata(addOnName, "Version"),
           GetAddOnMetadata(addOnName, "X-VersionDate")));

  AboutHeader.fontSize = "medium";
  AboutHeader.width = "full";

  local args = {}

  local function build_addOn(addOn)
    local function grey(str)
      return str and "|cff808080" .. str:gsub("|cff%x%x%x%x%x%x",""):gsub("|r","") .. "|r" or "";
    end;

    local name    = addOn.title or addOn.name;
    local version = addOn.version and 
                    addOn.version:gsub(" ?alpha ?(.+)", "|cffff0000a%1|r"):gsub(" ?beta ?(.*)", "|cffffff00b%1|r") or "";
    local rpqType = addOn.rpqType and loc("RPQ_TYPE_" .. addOn.rpqType:upper()) or "";
    local desc    = addOn.desc or "";

    if rpqType ~= loc("RPQ_TYPE_CORE") and addOn.rpqId then name = RPTAGS.CONST.NBSP .. name; end;

    local links = {};
    for i, func in pairs({ "open", "options", "help"})
    do  if hasFunc(addOn, func)
        then table.insert(links, "[" .. func .. "](addon://" .. addOn.name .. "?" .. func .. ")");
        end;
    end;

    if not addOn.enabled 
    then name, version, rpqType, desc = grey(name), grey(version), grey(rpqType), grey(desc);
         links = {}
    end;
   
    args[addOn.name .. "Name"] =
    { type           = "description",
      fontSize       = "small",
      order          = source_order(),
      width          = 1.35,
      name           = name,
      dialogControl = "LMD30_Description",
    };

    args[addOn.name .. "Version"]     =
    { type           = "description",
      order          = source_order(),
      width          = 0.60,
      fontSize       = "small",
      dialogControl = "LMD30_Description",
      name           = version,
    };

    args[addOn.name .. "Type"] =
    { type           = "description",
      order          = source_order(),
      width          = 0.90,
      fontSize       = "small",
      dialogControl  = "LMD30_Description",
      name           = rpqType,
    };

    args[addOn.name .. "Links"] =
    { type           = "description",
      order          = source_order(),
      width          = 1.00,
      fontSize       = "small",
      dialogControl = "LMD30_Description",
      name           = table.concat(links, RPTAGS.CONST.NBSP),
    };
  end;

  args.tableHeader = build_addOn(
   { name = "TableHeader", 
     title = loc("RPQ_HEADER_NAME"),
     version = loc("RPQ_HEADER_VERSION"),
     links = { loc("RPQ_HEADER_LINKS") } ,
     rpqType = "header",
     enabled = true,
   }
 );   

 args.blankAfterHeader = Blank_Line();

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

 for category, _ in pairs( RPTAGS.queue:GetModuleTypes())
 do  local category_0 = category .. "_0";
     if RPTAGS.cache.addOns[category  ] then build_category(category  ); end;
     if RPTAGS.cache.addOns[category_0] then build_category(category_0); end;
 end;

 if   RPTAGS.cache.addOns.targets ~= {}
 then args.blankBeforeTargets = Blank_Line();
      build_category("targets");
 end;

 args.blankBeforeFollowUp = Blank_Line();
 args.followUpText = Markdown(loc("RPQ_FOLLOWUP"));

 local Version =
 { type = "group",
   name = loc("OPT_VERSION"),
   order = source_order(),
   args = args,
 };

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
   
       local function tagList()
         local tagHeader = "| rp:tag | " .. loc("UI_DISPLAYS") .. "|\n" ..
                           "| :---------------------- | :-------------------------- |";

         table.insert(details, "# " .. loc("UI_TAG_LIST"));
         addB();
         table.insert(
           details, 
           string.format(
             loc("FMT_CURRENT_AS_OF"),
             RPTAGS.metadata.Version, 
             GetAddOnMetadata("RP_Tags", "X-VersionDate")));

         local allTags = {};
         local function add(tag) table.insert(allTags, "`[" .. tag .. "]`"); end;

         for _, tagGroup in pairs(RPTAGS.CONST.TAG_DATA)
         do  addB(); 
             table.insert(details, "## " .. tagGroup.title);
             addB();
             table.insert(details, tagGroup.help);
             addB();
             table.insert(details, tagHeader);
             for _, tag in pairs(tagGroup.tags)
             do  if tag.title
                 then addB();
                      table.insert(details, "### " .. tag.title);
                      addB();
                      table.insert(details, tagHeader);
                 else table.insert(details, "| `[" .. tag.name .. "]` | " .. tag.desc .. " |");
                      if not tag.external and not tagGroup.external
                      then add(tag.name);
                           if tag.label then add(tag.name .. "-label") end;
                           if tag.alias 
                           then for _, aka in ipairs(tag.alias)
                                do add(aka);
                                   if tag.label then add(aka .. "-label") end;
                                end;
                           end;
                      end;
                 end;
             end;
         end;

         table.sort(allTags, function(a, b) return a:lower() < b:lower() end);
         table.insert(details, "# " .. loc("UI_ALL_TAGS") .. 
                             " (" .. #allTags .. ")" )
         addB();
         table.insert(details, "\n - " .. table.concat(allTags, "\n - ") );
         
       end;

       local sections = { strsplit(" ", value:gsub("^debug ", "")) };
       for i = 1, math.min(#sections, 2)
       do  local sec = sections[i];
           if sec:match("^lib")
           then addH(loc("UI_LIBRARIES"), 0); 
                for lib in LibStub:IterateLibraries() 
                do  local _, minor = LibStub(lib); addP(lib, minor, 1); 
                end;
          elseif sec:match("^addon")
          then addH(loc("UI_ADDONS"), 0); 
               walk(RPTAGS.cache.addOns, 1);
          elseif sec:match("^config")
          then addH(loc("UI_CONFIG"), 0); 
               walk(db, 1); 
          elseif sec:match("^tags")
          then tagList();
          else addH("Unknown Parameter", 0);
               addP("debug", sec);
          end;
          addB();
       end;

       addH("Done", 0);
       return table.concat(details, "\n");
    end;
  end;
   
  local Changes = 
  { type = "group",
    name = loc("OPT_CHANGES"), 
    order = source_order(),
    width = "full",
    args =
    { panel = 
      { type = "description",
        name = loc("CHANGES_MD"),
        order = source_order(),
        width = "full", 
        dialogControl = "LMD30_Description",
        fontSize = "medium",
      },
    },
  };

  local Credits = Markdown({ loc("OPT_CREDITS"), loc("CREDITS_MD") });

  local Debug =
  { type = "group",
    name = loc("OPT_DEBUGGING_CMDS"),
    order = source_order(),
    width = "full",
    args = 
    { header = 
      { type = "description",
        name = "## " .. loc("OPT_DEBUGGING_CMDS"),
        dialogControl = "LMD30_Description",
        order = source_order(),
        width = "full",
      },
      details =
      { type = "input",
        name = loc("OPT_DEBUGGING_DETAILS"),
        width = "full",
        order = source_order(),
        get = function(self) return get_debug_info(RPTAGS.cache.debug) end,
        set = function(self, value) RPTAGS.cache.debug = value; end,
        multiline = 10,
        desc = debugMessage,
      },
    },
  };
            
  local aboutScreen        =
  { name                   = loc("PANEL_ABOUT"),
    order                  = source_order(),
    type                   = "group",
    childGroups            = "tab",
    args                   =
    { header  = AboutHeader,
      version = Version,
      changes = Changes,
      credits = Credits,
      debug   = Debug,
    },
  };

  RPTAGS.options.about = aboutScreen;
  
end);
