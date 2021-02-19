-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 

local RPTAGS          = RPTAGS;

RPTAGS.queue:WaitUntil("before OPTIONS_HELP",
function(self, event, ...)
-- RPQ -----------------------------------------------------------------------------------------------------------------------------------------------
  
  local Utils              = RPTAGS.utils;
  local loc                = Utils.locale.loc;
  local source_order       = Utils.options.source_order;
  local Spacer             = Utils.options.spacer;
  local tagData            = RPTAGS.CONST.TAG_DATA;
  local Blank_Line         = Utils.options.blank_line;
  local Data_Table         = Utils.options.data_table;
  local eval               = Utils.tags.eval;

  local function build_panel_taghelp()
    
    local unsupported        = RPTAGS.CONST.UNSUP;

    -- local function build_tag_help(tag)
      -- local w =
      -- { name = tag.desc,
        -- order = source_order(),
        -- type = "input",
        -- width = 0.66,
        -- disabled = unsupported[tagName],
        -- get = function() return "[" .. tag.name .. "]" end,
      -- };
      -- return w
    -- end;
    local function build_tag_help(tag)
      RPTAGS.cache.tagHelp[tag.name] = { label = false, size = "", };
      local tagBox, tagSizer, tagLabeler;
      tagBox = 
      { type = "input",
        name = tag.desc,
        width = 2,
        order = source_order(),
        disabled = unsupported[tag.name],
        desc = "Select and copy the tag to paste into a panel.",
        get = function() 
                local cache = RPTAGS.cache.tagHelp[tag.name];
                return "[" .. 
                       tag.name .. 
                       (tag.label and (cache.label and "-label" or "") or "") ..
                       (tag.size and cache.size or "") ..
                       "]"
              end,
      };

      if tag.size
      then tagSizer =
           { type = "select",
             name = "Size",
             width = "half",
             desc = "Select the maximum size of the tag, or a blank to allow any size.",
             order = source_order(),
             disabled = unsupported[tag.name],
             values = { ["(xs)"] = loc("SIZE_XS"),
                        ["(s)" ] = loc("SIZE_SMALL"),
                        ["(m)" ] = loc("SIZE_MEDIUM"),
                        ["(l)" ] = loc("SIZE_LARGE"),
                        ["(xl)"] = loc("SIZE_XL"),
                        [""    ] = "",
                      },
             sorting = { "", "(xs)", "(s)", "(m)", "(l)", "(xl)" };
             get = function() return RPTAGS.cache.tagHelp[tag.name].size end,
             set = function(self, value) RPTAGS.cache.tagHelp[tag.name].size = value end,
           };
          tagBox.width = tagBox.width - 0.5;
      end;

      if tag.label
      then tagLabeler =
           { type = "toggle",
             name = "Label",
             width = "half",
             desc = "Check to add a label onto the tag.",
             order = source_order(),
             disabled = unsupported[tag.name],
             get = function() return RPTAGS.cache.tagHelp[tag.name].label end,
             set = function(self, value) RPTAGS.cache.tagHelp[tag.name].label = value end,
           };
         tagBox.width = tagBox.width - 0.5;
      end;

      return tagBox, tagLabeler, tagSizer;

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
  
    local function getGroupHelp(group)
      return "# " ..  group.title .. " " .. loc("TAGS") .. 
             "\n\n" .. group.help .. "\n\n";
    end;

    local function build_tag_group_help(group)
      local   args = {};

      args.groupHelp = 
      { type = "description",
        name = getGroupHelp(group),
        order = source_order(),
        width = "full",
        dialogControl = "LMD30_Description",
      };

      for i,  tag in pairs(group.tags)
      do  if     tag.title 
          then   args[tag.title] = build_subtitle_help(tag, group)
          elseif tag.name and tag.desc
          then   local box, labeler, sizer = build_tag_help(tag, group)
                 args[tag.name] = box;
                 args[tag.name .. "Labeler"]   = labeler;
                 args[tag.name .. "Sizer"]     = sizer;
                 args[tag.name .. "BlankLine"] = Blank_Line();
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
  
    local args = {};
    RPTAGS.cache.tagHelp = {};

    -- local groupList = { loc("TAG_REFERENCE_MD") };

    for _, group in ipairs(tagData)
    do  args[group.key] = build_tag_group_help(group)
        -- table.insert(groupList, 
          -- string.format(
            -- loc("FMT_GROUPLIST_MD"), 
            -- group.title, 
            -- group.key,
            -- group.help
          -- )
        -- );
    end;

    return 
    { type = "group",
      name = loc("OPT_TAG_REFERENCE"),
      order = source_order(),
      args = args,
    };

  end; -- 

  RPTAGS.options         = RPTAGS.options or {};
  RPTAGS.options.taghelp = build_panel_taghelp;
 
-- RPQ -----------------------------------------------------------------------------------------------------------------------------------------------
end);
