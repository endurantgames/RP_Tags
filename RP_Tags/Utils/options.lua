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
  local notify             = RPTAGS.utils.text.notify;
  local AceConfigDialog    = LibStub("AceConfigDialog-3.0");
  local AceGUI             = LibStub("AceGUI-3.0");
  local split              = RPTAGS.utils.text.split;

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
  
  
  local function source_order()
        RPTAGS.cache.orderCount = (RPTAGS.cache.orderCount or 0) + 1;
        return RPTAGS.cache.orderCount;
  end;
  
  local function build_markdown(text, hidden, disabled)

      local w =
      { order = source_order(),
        type = "description",
        dialogControl = "LMD30_Description",
        width = 2,
      };

      if type(text) == "table"
      then w.name = hilite(text[2], true);
           w = 
           { type = "group",
             name = hilite(text[1], true),
             width = "full",
             order = source_order(),
             args = { 
               text = w }
           };
      elseif type(text) == "string"
      then w.name = hilite(text, true);
      end;

      return w
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
  
  local function build_textbox_wide(str, hidden, disabled)
        local w    = build_common("input", "CONFIG_", str, hidden, disabled, true, true);
        w.width = "full";
        return w;
  end;  

  local function build_dropdown(str, hidden, disabled)
        local w    = build_common("select", "CONFIG_", str, hidden, disabled, true, true);
        w.values   = menus[str:upper():gsub("%s+","_")]
        return w;
  end;
  
  local function build_color_picker(str, hidden, disabled)
        str = "COLOR_" .. string.upper(str):gsub("%s","_");
        local w =
        { name = loc("CONFIG_" .. str),
          order = source_order(),
          width = "full",
          type = "group" ,
            inline = true,
        };

        local c    = build_common("color", "UI_", "BLANK", hidden, disabled);
        c.hasAlpha = false;
        c.get      = function(info, value) 
                       local  hexString = Config.get(str);
                       if     type(hexString) == "number" then hexString = "000000"; end;
                       local  r, g, b, a = RPTAGS.utils.color.colorToDecimals(hexString);
                       return r, g, b, a;
                     end;
        c.set      = function(info, r, g, b, a) 
                       local value = RPTAGS.utils.color.decimalsToColor(r, g, b);
                       Config.set(str, value);
                     end;
        c.width = 0.25;
        c.desc = loc("CONFIG_" .. str .. "_TT");

        local s = build_spacer();

        local l = build_markdown(loc("CONFIG_" .. str .. "_TT"));

        w.args = { color = c, spacer = s, label = l };

        return w;
  end;
  
  local function build_slider(str, min, max, step, width, hidden, disabled, get, set)
        local w = build_common("range", "config_", str, hidden, disbled, true, true);
        w.width = width or "full";
  
        if     not min
        then   min = 0
        elseif type(min) == "table"
        then   w.min     = min[2];
               w.softMin = min[1];
        else   w.min = min;
        end;

        if     not max
        then   max = 0
        elseif type(max) == "table"
        then   w.max     = max[2];
               w.softMax = max[1];
        else   w.max = max;
        end;

        if     not step
        then   step = 0
        elseif type(step) == "table"
        then   w.step = step[1];
               w.bigStep = step[2];
        else   w.step = step;
        end;

        return w;
  end;
  
  local function build_pushbutton(str, func, hidden, disabled)
        local w    = build_common("execute", "config ", str, hidden, disabled);
        w.func = func;
        return w;
  end
  
  local function build_multi_reset(list, hidden, disabled)
        local w = build_pushbutton(
          "reset these values", 
          function() 
            for _, s in ipairs(list) 
            do  Config.reset(string.upper(s):gsub("%s+","_")) 
            end 
          end, 
          hidden, disabled);
        return w;
  end;
  
  local function build_reset(str, hidden, disabled)
        local w = build_pushbutton(
          "reset",
          function() Config.reset(str:upper():gsub("%s+","_")) end,
          hidden, disabled
        );
        w.width = 1 / 2;
        return w
  end;

  local function build_question_mark(str, hidden, disabled)
        local w = build_common("execute", "question_", "mark", hidden, disabled);
        w.func = function() end;
        w.desc = str;
        w.width = 0.10;
        return w;
  end;

  local function build_header(str, level, hidden, disabled)
        local w = build_markdown(
                    string.rep("#", level or 1) .. 
                    loc("OPT_" .. str:upper():gsub("%s+","_")), 
                    hidden, disabled);
        w.width = "full";
        -- w.type = "header";
        -- local w = build_common("header", "opt ", str, hidden, disabled, nil, nil, true);
        return w;
  end;
  
  local function build_instruct(str, hidden, disabled)
        local w = build_common("description", "opt ", str .. "_i", hidden, disabled, nil, nil, true);
        w.fontSize = "medium";
        w.dialogControl = "LMD30_Description";
        return w;
  end; -- beep
  
  local function build_keybind(str, hidden, disabled)
        local str = "KEYBIND_" .. str:upper():gsub("%s+", "");
        local w = 
        { name = loc(str),
          type = "group",
          order = source_order(),
          inline = true,
        };

        local kb1 = build_common("keybinding", "UI_", "BLANK", hidden, disabled);
        local kb2 = build_common("keybinding", "UI_", "BLANK", hidden, disabled);
        local desc = build_markdown(loc(str .. "_TT"));

        w.args =
        { kb1 = kb1,
          kb2 = kb2,
          desc = desc,
        };

        return w
  end;

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
        
         args[addOn.name .. "Name"] =
         { type           = "description",
           fontSize       = "small",
           order          = source_order(),
           width          = 1.5,
           name           = name,
         };

         args[addOn.name .. "Version"]     =
         { type           = "description",
           order          = source_order(),
           width          = 0.5,
           fontSize       = "small",
           name           = version,
         };

         args[addOn.name .. "Type"] =
         { type           = "description",
           order          = source_order(),
           width          = 1,
           fontSize       = "small",
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

--   local function openDialog(dest)
--         local protocol, path = dest:match("^(opt)://(.+)$");
--         path = RPTAGS.utils.text.split(path, "/");
--         local panel = path[1];
--         if RPTAGS.cache.panels[panel] and protocol == "opt"
--         else notify(loc("SLASH_COMMAND_LIST"))
--         end;
--         -- AceConfigDialog:SelectGroup(loc("APP_NAME"), unpack(path));
--         -- AceConfigDialog:Open(loc("APP_NAME"))
--         -- AceConfigDialog:SelectGroup(loc("APP_NAME"), unpack(path));
--   end;

  local function linkHandler(dest, link, text, amdwProtocol)
        link = link or dest;
        local protocol, path = link:match("^(%a+)://(.+)$");
        path = split(path, "/");
        local path1 = path[1];
        if     (protocol == "opt"
               or protocol == "setting")
               and RPTAGS.cache.panels[path1]
        then   InterfaceOptionsFrame:Show()
               InterfaceOptionsFrame_OpenToCategory(RPTAGS.cache.panels[path1])
               AceConfigDialog:SelectGroup(loc("APP_NAME"), unpack(path));
        elseif protocol == "help"
        then   InterfaceOptionsFrame:Show()
               InterfaceOptionsFrame_OpenToCategory("help");
               AceConfigDialog:SelectGroup(loc("APP_NAME"), unpack(path));
        elseif protocol == "tag" and RPTAGS.cache.help.tagIndex[path1]
        then   linkHandler(RPTAGS.cache.help.tagIndex[path1])
        elseif protocol == "urldb" and RPTAGS.CONST.URLS[path1] and amdwProtocol
        then   link = loc(RPTAGS.CONST.URLS[path1].url);
               text = loc(RPTAGS.CONST.URLS[path1].name);
               amdwProtocol:ShowPopup(dest, link, text);
        else   print("oops", dest, link, text);
        end;
   end;
  
   local function linkHandlerCustomClick(amdwProtocol, dest, link, text) return 
                  linkHandler(dest, link, text, amdwProtocol) end;

  ACEMARKDOWNWIDGET_CONFIG.LibMarkdownConfig[ "pre"] =  "<h3>|cff00ffff";
  ACEMARKDOWNWIDGET_CONFIG.LibMarkdownConfig["/pre"] = "|r</h3>";
  ACEMARKDOWNWIDGET_CONFIG.LibMarkdownConfig[ "code"] =  "<h3>|cff00ffff";
  ACEMARKDOWNWIDGET_CONFIG.LibMarkdownConfig["/code"] = "|r</h3>";
  ACEMARKDOWNWIDGET_CONFIG.LibMarkdownConfig[ "code"] =  "<h3>|cff00ffff";
  ACEMARKDOWNWIDGET_CONFIG.LibMarkdownConfig["/code"] = "|r</h3>";
  ACEMARKDOWNWIDGET_CONFIG.LibMarkdownConfig[ "h3"  ] =  "<h2>";
  ACEMARKDOWNWIDGET_CONFIG.LibMarkdownConfig["/h3"  ] = "</h2>";

  ACEMARKDOWNWIDGET_CONFIG.HtmlStyles.Normal.red   = 1;
  ACEMARKDOWNWIDGET_CONFIG.HtmlStyles.Normal.green = 1;
  ACEMARKDOWNWIDGET_CONFIG.HtmlStyles.Normal.blue  = 1;

  ACEMARKDOWNWIDGET_CONFIG.HtmlStyles["Heading 3"].FontFile =
    RPTAGS.CONST.FONT.FIXED;
  ACEMARKDOWNWIDGET_CONFIG.HtmlStyles["Heading 3"].red   = 0.000;
  ACEMARKDOWNWIDGET_CONFIG.HtmlStyles["Heading 3"].green = 1.000;
  ACEMARKDOWNWIDGET_CONFIG.HtmlStyles["Heading 3"].blue  = 1.000;
  ACEMARKDOWNWIDGET_CONFIG.HtmlStyles["Heading 3"].Spacing = 6;
  ACEMARKDOWNWIDGET_CONFIG.HtmlStyles["Heading 3"].JustifyH = "CENTER";

  ACEMARKDOWNWIDGET_CONFIG.LinkProtocols.default.Popup =
    { Text = loc("LINK_DEFAULT_TEXT"),
      PrefixText = loc("APP_NAME") .. "\n\n",
      ButtonText = loc("UI_GOT_IT"), 
    };

  ACEMARKDOWNWIDGET_CONFIG.LinkProtocols.http.Popup =
    { Text = loc("LINK_HTTP_TEXT"),
      PrefixText = loc("APP_NAME") .. "\n\n",
      ButtonText = loc("UI_GOT_IT"), 
    };

  ACEMARKDOWNWIDGET_CONFIG.LinkProtocols.https.Popup =
    { Text = loc("LINK_HTTPS_TEXT"),
      PrefixText = loc("APP_NAME") .. "\n\n",
      ButtonText = loc("UI_GOT_IT"), 
    };

  ACEMARKDOWNWIDGET_CONFIG.LinkProtocols.mailto.Popup =
    { Text = loc("LINK_MAILTO_TEXT"),
      PrefixText = loc("APP_NAME") .. "\n\n",
      ButtonText = loc("UI_GOT_IT"), 
    };

  ACEMARKDOWNWIDGET_CONFIG.LinkProtocols.opt =
    { Cursor = "Interface\\CURSOR\\QuestTurnIn.PNG",
      CustomClick = linkHandlerCustomClick,
    };
    
  ACEMARKDOWNWIDGET_CONFIG.LinkProtocols.help =
    { Cursor = "Interface\\CURSOR\\QuestRepeatable.PNG",
      CustomClick = linkHandlerCustomClick,
    };
    
  ACEMARKDOWNWIDGET_CONFIG.LinkProtocols.urldb =
    -- { Cursor = "Interface\\CURSOR\\MapPinCursor.PNG",
    { Cursor = "Interface\\CURSOR\\QuestRepeatable.PNG",
      CustomClick = linkHandlerCustomClick,
      Popup = 
      { Text = loc("LINK_URLDB_TEXT"),
        PrefixText = loc("APP_NAME") .. "\n\n",
        ButtonText = loc("UI_GOT_IT"), 
      },
    };

  ACEMARKDOWNWIDGET_CONFIG.LinkProtocols.setting =
    { Cursor = "Interface\\CURSOR\\Interact.PNG",
      CustomClick = linkHandlerCustomClick,
    };
    
  ACEMARKDOWNWIDGET_CONFIG.LinkProtocols.tag =
    { Cursor = "Interface\\CURSOR\\Interact.PNG",
      CustomClick = linkHandlerCustomClick, 
    };

  RPTAGS.utils.options                   = RPTAGS.utils.options or {};
  RPTAGS.utils.options.panel             = RPTAGS.utils.options.panel or {};

  RPTAGS.utils.options.source_order      = source_order;
  RPTAGS.utils.options.open              = linkHandler;

  RPTAGS.utils.options.blank_line        = build_blank_line;
  RPTAGS.utils.options.checkbox          = build_checkbox
  RPTAGS.utils.options.color_picker      = build_color_picker
  RPTAGS.utils.options.common            = build_common
  RPTAGS.utils.options.dropdown          = build_dropdown
  RPTAGS.utils.options.header            = build_header
  RPTAGS.utils.options.instruct          = build_instruct
  RPTAGS.utils.options.markdown          = build_markdown
  RPTAGS.utils.options.multi_reset       = build_multi_reset
  RPTAGS.utils.options.panel.taghelp     = build_panel_taghelp
  RPTAGS.utils.options.panel.version     = build_panel_version
  RPTAGS.utils.options.pushbutton        = build_pushbutton
  RPTAGS.utils.options.recipe            = build_recipe;
  RPTAGS.utils.options.reset             = build_reset
  RPTAGS.utils.options.slider            = build_slider;
  RPTAGS.utils.options.spacer            = build_spacer;
  RPTAGS.utils.options.textbox           = build_textbox;
  RPTAGS.utils.options.question_mark     = build_question_mark;
  RPTAGS.utils.options.keybind           = build_keybind;
  RPTAGS.utils.options.textbox_wide      = build_textbox_wide;
 
-- RPQ -----------------------------------------------------------------------------------------------------------------------------------------------
end);
