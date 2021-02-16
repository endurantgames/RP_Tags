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
  local build_spacer       = Utils.options.spacer;
  local tagData            = RPTAGS.CONST.TAG_DATA;

  local function build_panel_taghelp()
    
    local unsupported        = RPTAGS.CONST.UNSUP;

    local function build_tag_help(tag)
      local w =
      { name = tag.desc,
        order = source_order(),
        type = "input",
        width = 0.66,
        disabled = unsupported[tagName],
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
  
    local function getGroupHelp(group)
      return "## " ..  group.title .. loc("TAGS") .. 
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
  
    local function build_group_link(group)
      local w =
      { type = "description",
        order = source_order(),
        dialogControl = "LMD30_Description",
        name = "[" .. group.title .. " Tags]" ..
               "(opt://help/tags/" .. group.key .. ")",
        fontSize = "medium",
      };
      return w;
    end;

    function build_group_text(group)
      local w =
      { type = "description",
        order = source_order(),
        dialogControl = "LMD30_Description",
        name = group.help,
        fontSize = "small",
      };
      return w;
    end;

    local groupListText = loc("TAG_REFERENCE_MD") .. "\n\n";
    local args =  
    { header = 
      { type = "description",
        name = loc("TAG_REFERENCE_MD"),
        dialogControl = "LMD30_Description",
        order = source_order(),
      },
    };

    for _, group in pairs(tagData)
    do  args[group.key] = build_tag_group_help(group)
        args[group.key .. "_Link"] = build_group_link(group)
        args[group.key .. "_Text"] = build_group_text(group)
    end;
  
    args.groupList = groupList;

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
  RPTAGS.options.taghelp = build_panel_taghelp;
 
-- RPQ -----------------------------------------------------------------------------------------------------------------------------------------------
end);
