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
  local weights            = RPTAGS.utils.format.kg;
  local heights            = RPTAGS.utils.format.cm;
  local sizebuffs          = RPTAGS.utils.format.sizebuff;
  local profilesizes       = RPTAGS.utils.format.sizewords;
  local unsup              = RPTAGS.utils.format.unsup;
  local AceMarkdownControl = LibStub("AceMarkdownControl-3.0");
  
  local menus =
  { UNITS_HEIGHT          =
    { CM                  =  heights(168, "CM"),
      CM_FT_IN            =  heights(168, "CM_FT_IN"),
      CM_IN               =  heights(168, "CM_IN"),
      FT_IN               =  heights(168, "FT_IN"),
      FT_IN_CM            =  heights(168, "FT_IN_CM"),
      IN                  =  heights(168, "IN"),
      IN_CM               =  heights(168, "IN_CM"),
      HEIGHT_PASSTHRU     =  heights(168, "HEIGHT_PASSTHRU"),
    },
  
    UNITS_WEIGHT =
    { KG                  =  weights(73, "KG"),
      KG_LB               =  weights(73, "KG_LB"),
      KG_ST_LB            =  weights(73, "KG_ST_LB"),
      LB_KG               =  weights(73, "LB_KG"),
      LB_ST               =  weights(73, "LB_ST"),
      ST_LB               =  weights(73, "ST_LB"),
      ST_LB_KG            =  weights(73, "ST_LB_KG"),
      ST_LB_LB_KG         =  weights(73, "ST_LB_LB_KG"),
      WEIGHT_PASSTHRU     =  weights(73, "WEIGHT_PASSTHRU"),
    },
  
    PROFILESIZE_FMT =
    { WRD_BRC_NUM         =  profilesizes(7, BIG_PROFILE, "WRD_BRC_NUM"),
      WRD_PAR_NUM         =  profilesizes(7, BIG_PROFILE, "WRD_PAR_NUM"),
      BRC_WRD_NUM         =  profilesizes(7, BIG_PROFILE, "BRC_WRD_NUM"),
      PAR_WRD             =  profilesizes(7, BIG_PROFILE, "PAR_WRD"),
      WRD                 =  profilesizes(7, BIG_PROFILE, "WRD"),
      BRC_LTR_NUM         =  profilesizes(7, BIG_PROFILE, "BRC_LTR_NUM"),
      BRC_LTR             =  profilesizes(7, BIG_PROFILE, "BRC_LTR"),
      LTR                 =  profilesizes(7, BIG_PROFILE, "LTR"),
      BRC_NUM             =  profilesizes(7, BIG_PROFILE, "BRC_NUM"),
      NUM                 =  profilesizes(7, BIG_PROFILE, "NUM"),
    },
  
    SIZEBUFF_FMT =
    { PCT                 =  sizebuffs(8212, "PCT"),
      PCT_BRC             =  sizebuffs(8212, "PCT_BRC"),
      PCT_BUFF            =  sizebuffs(8212, "PCT_BUFF"),
      BUFF_PCT            =  sizebuffs(8212, "BUFF_PCT"),
      BUFF                =  sizebuffs(8212, "BUFF"),
      BUFF_BRC            =  sizebuffs(8212, "BUFF_BRC"),
      BUFF_PCT_BRC        =  sizebuffs(8212, "BUFF_PCT_BRC"),
    },
  
    GLANCE_COLON =
    { [": "]              =  loc("CONFIG_GLANCE_COLON_COLON"),
      [", "]              =  loc("CONFIG_GLANCE_COLON_COMMAS"),
      [" - "]             =  loc("CONFIG_GLANCE_COLON_DASHES"),
      [" / "]             =  loc("CONFIG_GLANCE_COLON_SLASHES"),
      [" "]               =  loc("CONFIG_GLANCE_COLON_SPACES"),
    },
  
    GLANCE_DELIM =
    { [", "]              =  loc("CONFIG_GLANCE_DELIM_COMMAS"),
      ["\n"]              =  loc("CONFIG_GLANCE_DELIM_NEWLINES"),
      ["; "]              =  loc("CONFIG_GLANCE_DELIM_SEMICOLONS"),
      [" / "]             =  loc("CONFIG_GLANCE_DELIM_SLASHES"),
      [" "]               =  loc("CONFIG_GLANCE_DELIM_SPACES"),
    },
  
    UNSUP_TAG =
    { ["?"]               =  "?",
      ["??"]              =  "??",
      ["???"]             =  "???",
      ["[?]"]             =  "[?]",
      ["|cffdddd00?|r"]   =  "|cffdddd00?|r",
      ["|cffdd0000?|r"]   =  "|cffdd0000?|r",
      ["|cffdddd00[?]|r"] =  "|cffdddd00[?]|r",
      ["|cffdd0000[?]|r"] =  "|cffdd0000[?]|r",
      [""]                =  loc("CONFIG_UNSUP_NONE"),
  
      ["|TInterface\\RAIDFRAME\\ReadyCheck-NotReady:0|t"] = "|TInterface\\RAIDFRAME\\ReadyCheck-NotReady:0|t",
    },
  } ;
  
  local function openUrl(site, url, name)
        if site and loc("URL_" .. site:upper()) ~= "" then url = loc("URL_" .. site:upper()) end;
        StaticPopup_Show("RPTAGS_OPEN_URL", nil, nil, { url = url, name = name, });
  end;
  
  local version     = Utils.text.v(); -- yes, meant as a function call
  
  -- libraries
  --
  
  local LSM         = LibStub("LibSharedMedia-3.0")
  
  -- handlers
  
  local function source_order()
        RPTAGS.cache.orderCount = (RPTAGS.cache.orderCount or 0) + 1;
        return RPTAGS.cache.orderCount;
  end;
  
  local function build_common(type, prefix, str, hidden, disabled, get, set, no_tooltip)
        local widget = {};
  
        str    = str:upper():gsub("%s", "_");
        prefix = prefix:upper():gsub("%s", "_");
  
        widget.order    = source_order();
        widget.hidden   = hidden;
        widget.disabled = disabled;
        widget.name     = hi(loc(prefix .. str));
        widget.type     = type;
  
        if     get == true 
        then   widget.get = function() return Config.get(str) end;
        elseif get
        then   widget.get = get;
        end;
  
        if     set == true 
        then   widget.set = function(info, value) return Config.set(str, value) end;
        elseif set
        then   widget.set = set;
        end;
  
        if not no_tooltip then widget.desc = hi(loc(prefix .. str .. "_TT")); end;
  
       return widget;
  end;
  
  local function build_spacer()     return { name = "", order = source_order(), width = 0.05,   type = "description", fontSize = "medium", }; end;
  local function build_blank_line() return { name = "", order = source_order(), width = "full", type = "description", fontSize = "medium", }; end;

  local function build_checkbox(str, hidden, disabled)
        local w    = build_common("toggle", "CONFIG_", str, hidden, disabled, true, true);
        return w;
  end;
  
  local function build_textbox(str, hidden, disabled)
        local w    = build_common("input", "CONFIG_", str, hidden, disabled, true, true);
        return w;
  end;  
  
  local function build_dropdown(str, hidden, disabled)
        local w    = build_common("select", "CONFIG_", str, hidden, disabled, true, true);
        w.values   = menus[str:upper():gsub("%s+","_")]
        return w;
  end;
  
  local function build_color_picker(str, hidden, disabled)
        local w    = build_common("color", "CONFIG_COLOR_", str, hidden, disabled);
        str = "COLOR_" .. string.upper(str):gsub("%s","_");
        w.hasAlpha = false;
        w.get      = function(info, value) 
                       local  hexString = Config.get(str);
                       if     type(hexString) == "number" then hexString = "000000"; end;
                       local  r, g, b, a = RPTAGS.utils.color.colorToDecimals(hexString);
                       return r, g, b, a;
                     end;
        w.set      = function(info, r, g, b, a) 
                       local value = RPTAGS.utils.color.decimalsToColor(r, g, b);
                       Config.set(str, value);
                     end;
        return w;
  end;
  
  local function build_frame_scaler(str, hidden, disabled)
        local w    = build_common("range", "CONFIG_", str .. "frame scale", hidden, disabled, true, true);
        w.min      = 0.25;
        w.max      = 2;
        w.step     = 0.05;
        return w;
  end;
  local function build_dimensions_slider(str, min, max, step, hidden, disabled)
        local w    = build_common("range", "CONFIG_", str, hidden, disabled, true);
        w.min      = min or 0;
        w.max      = max or 100;
        w.step     = step or 1;
        w.set      = function(info, value) Config.set(str, value); resizeAll(); end;
        return w;
  end;
  
  local function build_pushbutton(str, func, hidden, disabled)
        local w    = build_common("execute", "config ", str, hidden, disabled);
        w.func = func;
        return w;
  end;

  local function build_tagpanel(str, ttstr, hidden, disabled)
        local str = str:upper():gsub("%s", "_");
        local w    = 
        { type = "group",
          name     = loc("CONFIG_" .. str);
          args     = 
          { panel   = build_pushbutton(str,   function() openEditor(str)   end, hidden, disabled),
            tooltip = build_pushbutton(ttstr, function() openEditor(ttstr) end, hidden, disabled),
          };
        };
        return w;
  end;

  local function build_markdown(title, str, hidden, disabled)
      local w =
      { type = "group",
        name = title,
        order = source_order(),
        args = 
        { panel =
          { order = source_order(),
            type = "description",
            dialogControl = AceMarkdownControl:New().description,
            name = str,
          },
        },
      };
      return title and w or w.args.panel;
  end;

  
  local function build_reset(list, hidden, disabled)
        local w = build_pushbutton(
                    "reset these values", 
                    function() 
                      for _, s in ipairs(list) 
                      do  Config.reset(string.upper(s):gsub("%s","")) 
                      end 
                    end, 
                    hidden, disabled);
        return w;
  end;
  
  local function build_header(str, hidden, disabled)
        local w = build_common("header", "opt ", str, hidden, disabled, nil, nil, true);
        return w;
  end;
  
  local function build_instruct(str, hidden, disabled)
        local w = build_common("description", "opt ", str .. "_i", hidden, disabled, nil, nil, true);
        w.fontSize = "medium";
        return w;
  end; -- beep
  
  local function build_panel_version(hidden, disabled)
        
       local args = {}

       local function build_addOn(addOn)
         local name = addOn.title or addOn.name;
         local version = addOn.version 
                         and addOn.version:gsub(" alpha ", "a"):gsub(" beta ", "b")
                         or "";
         local rpqType = addOn.rpqType;

         if not rpqType then rpqType = ""
         elseif rpqType == "core" or rpqType == "header" or rpqType:match("^targetOf")
         then   rpqType = loc("RPQ_TYPE_" .. rpqType:upper()); 
         else   rpqType = loc("RPQ_TYPE_" .. rpqType:upper());
                name = RPTAGS.CONST.NBSP .. name;
         end;

         if not addOn.enabled 
         then    name = "|cff808080" ..    name:gsub("|cff%x%x%x%x%x%x",""):gsub("|r","") .. "|r";
              version = "|cff808080" .. version:gsub("|cff%x%x%x%x%x%x",""):gsub("|r","") .. "|r";
              rpqType = "|cff808080" .. rpqType:gsub("|cff%x%x%x%x%x%x",""):gsub("|r","") .. "|r";
         end;
        
         args[addOn.name .. "Name"] =
         { type           = "description",
           fontSize       = "medium",
           order          = source_order(),
           width          = 1.15,
           name           = name,
         };

         args[addOn.name .. "Version"]     =
         { type           = "description",
           order          = source_order(),
           width          = 0.35,
           fontSize       = "medium",
           name           = version,
         };

         args[addOn.name .. "Type"]        =
         { type           = "description",
           order          = source_order(),
           width          = 0.65,
           fontSize       = "medium",
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

      args.followUpText = build_markdown(nil, loc("RPQ_FOLLOWUP"));

      local w =
      { type = "group",
        name = loc("OPT_VERSION"),
        order = source_order(),
        args = args,
      };

      return w;
  end;

  local function build_recipe(str)
      local str = "RECIPE_" .. str:gsub("%s+","_"):upper();
      local w = 
      { type = "group",
        name = loc(str .. "_TITLE"),
        order = source_order(),
        inline = true,
        args =
        { recipeBox = 
          { type = "input",
            order = source_order(),
            name = "",
            get = function() return loc(str) end,
            width = "full",
            desc = loc(str .. "_TT"),
          },
          recipeDesc =
          { type = "description",
            
            order = source_order(),
            name = loc(str .. "_TT"),
            width = "full",
            dialogControl = AceMarkdownControl:New().description,
          },
        },
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
        dialogControl = AceMarkdownControl:New().description,
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
      childGroups = "select",
      order = source_order(),
      args = args,
    };
  
    return w;
  
  end; -- 

  RPTAGS.utils.options                         = RPTAGS.utils.options or {};
  RPTAGS.utils.options.panel                   = RPTAGS.utils.options.panel or {};
  RPTAGS.utils.options.build_common            = build_common
  RPTAGS.utils.options.build_checkbox          = build_checkbox
  RPTAGS.utils.options.build_textbox           = build_textbox
  RPTAGS.utils.options.build_dropdown          = build_dropdown
  RPTAGS.utils.options.build_color_picker      = build_color_picker
  RPTAGS.utils.options.build_frame_scaler      = build_frame_scaler
  RPTAGS.utils.options.build_dimensions_slider = build_dimensions_slider
  RPTAGS.utils.options.build_pushbutton        = build_pushbutton
  RPTAGS.utils.options.build_tagpanel          = build_tagpanel
  RPTAGS.utils.options.build_reset             = build_reset
  RPTAGS.utils.options.build_header            = build_header
  RPTAGS.utils.options.build_instruct          = build_instruct
  RPTAGS.utils.options.build_markdown          = build_markdown
  RPTAGS.utils.options.build_recipe            = build_recipe;
  RPTAGS.utils.options.panel.version           = build_panel_version
  RPTAGS.utils.options.panel.taghelp           = build_panel_taghelp
  RPTAGS.utils.options.source_order            = source_order;

 
-- RPQ -----------------------------------------------------------------------------------------------------------------------------------------------
end);
