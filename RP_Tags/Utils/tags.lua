local RPTAGS = RPTAGS;

RPTAGS.queue:WaitUntil("after UTILS_LOCALE",
function(self, event, ...)

  local locUtils = RPTAGS.utils.locale;
  local loc = locUtils.loc;

  local function getTagDescription(tag)
    return loc("TAG_" .. tag .. "_DESC");
  end;

  local function chooseDescInstead(tag)
    local hash = 
    { ["rp:npc"] = true,
      ["rp:ooc"] = true,
      ["rp:ic"]  = true,
    };

    return tag:match("icon") 
        or tag:match("color") 
        or tag:match("^rp:%a$") 
        or hash[tag]
        or not tag:match("rp:")
  end;

  local function getTagLabel(tag)
    if chooseDescInstead(tag)
    then return getTagDescription(tag)
    else return loc("TAG_" .. tag .. "_LABEL")
    end;
  end;

  local function getTagLabelColon()
    if chooseDescInstead(tag)
    then return ""
    else return loc("TAG_" .. tag .. "_LABEL") .. ": "
    end;
  end;

  locUtils.tagLabel      = getTagLabel;
  locUtils.tagDesc       = getTagDescription;
  locUtils.tagLabelColon = getTagLabelColon;

end);

RPTAGS.queue:WaitUntil("UTILS_TAGS",
function(self, event, ...)
-- RPQ ------------------------------------------------------------------------------------------------------------------------
  
  local split = RPTAGS.utils.text.split;
  local sizeTrim = RPTAGS.utils.text.sizeTrim;
  local Config = RPTAGS.utils.config;

  local function addAllTags()
    local source = RPTAGS.CONST.TAG_DATA;
    -- As per Data\tags.lua, the source consists of a list of tag groups
  
    for _, group in ipairs(source)
    do  RPTAGS.utils.tags.addTagGroup(group)
    end;
  end;
  
  local function addTagGroup(groupData)
    -- each tag group has this structure:
    -- { key   = "KEY", -- not localized
    --   title = "Human readable title (localized)",
    --   help  = "Help for the group (localized)",
    --   tags  = { tag, tag, tag, tag } 
    --   external = false, -- boolean for whether the tag is one of ours; for the editor
    -- }
    
    for _, tag in ipairs(groupData.tags)
    do  RPTAGS.utils.tags.addTag(tag, groupData)
    end;
  end;
  
  local function addTag(tag, group)
    --  Each tag has this structure:
    --  { name = "rp:tag", -- not localized
    --    alias = { alias, alias, alias },
    --    desc = "Human readable description (localized)",
    --    method = function(u) return "Tag Value" end, -- the method for getting the tag
    --    size = false, -- boolean for whether or not the tag can take sizes
    --    label = "Human readable label (localized), -- nil if the tag has no labels
    --    external = false, -- same as group.external
    --    events = "EXTRA_EVENTS",
    --  },
    --
    --  We need to send the data to registerTag, which expects the following:
    --  
    --  registerTag("rp:tag", method,  "EXTRA_EVENTS");
    --              ^name     ^method  ^events
    
    RPTAGS.cache.help = RPTAGS.cache.help or {};
    RPTAGS.cache.help.tagIndex = RPTAGS.cache.help.tagIndex or {};
  
    local registerTag                = RPTAGS.utils.tags.registerTag;
    local registerTagAndSizeVariants = RPTAGS.utils.tags.sizeVariants;
    local registerColorTag           = RPTAGS.utils.tags.colorTag;
    local registerLabel              = RPTAGS.utils.tags.registerLabel;

    if     tag.external or group.external
    then   -- if it's an external source then skip
    elseif tag.title
    then   -- it's just a header for the documentation
    else   -- first we make the core tag
           local tagMethod, tagNames, prefix, suffix = tag.method, { tag.name }, "", "";
  
           if   RPTAGS.CONST.UNSUP[tag.name] 
           then tagMethod = RPTAGS.utils.text[RPTAGS.CONST.UNSUP[tag.name]]; 
           end;
  
           if   tag.alias 
           then for _, aka in ipairs(tag.alias) do  table.insert(tagNames, aka) end; 
           end;
  
           -- time to build our tags!
           for _, tname in ipairs(tagNames)
           do  if     tag.size -- do we have size variants?
               then   registerTagAndSizeVariants(tname, tagMethod, tag.extraEvents);
               elseif tag.color
               then   registerColorTag( tname, tagMethod, tag.extraEvents);
               else   registerTag( tname, tagMethod, tag.extraEvents);
               end;

               if   tag.label
               then RPTAGS.utils.tags.registerLabel(tname, tagMethod, tag.extraEvents, tag.label);
               end;
               RPTAGS.cache.help.tagIndex[tag.name] = "opt://help/tags/" .. group.key;
           end;
      end;
    return tag, group; -- pass these values through in case a module needs it
    -- and that tag is done!
  end;

  local function registerTagLabel(tagName, tagMethod, tagExtraEvents, label)
    local split = RPTAGS.utils.text.split;
    local lab = split(label, "|");
    local prefix, suffix = lab[1] or "", lab[2] or "";
    RPTAGS.utils.tags.registerTag(
      tagName .. "-label",
      function(...)
        local result = tagMethod( ... );
        if result and result ~= ""
        then return prefix .. ": " .. result .. suffix;
        else return result
        end;
      end,
      tagExtraEvents
    );
  end;

  -- this will be extended by UF-specific functions
  local function registerTag(             ... ) return ... end;
  local function refreshFrame(            ... ) return ... end;
  local function refreshAll(              ... ) return ... end;
  local function registerTagSizeVariants( ... ) return ... end;
  local function registerColorTag(        ... ) return ... end;
   
  local function evalTagString(tagstr, unit, realUnit, use_oUF) -- adapted from oUF/elements/tags.lua
    if not tagstr then return "" end;
    local oUF = use_oUF or RPTAGS.oUF;

    local methods = oUF.Tags.Methods;

    local TAG_PATTERN = '%[..-%]+'
    local funcResults = {};

    local function getBracketData(tag) -- full tag syntax: '[prefix$>tag-name<$suffix(a,r,g,s)]'
      local  suffixEnd                 = (tag:match('()%(') or -1) - 1
      local  prefixEnd, prefixOffset   = tag:match('()%$>'), 1
    
      if not prefixEnd
      then   prefixEnd                 = 1
      else   prefixEnd                 = prefixEnd - 1
             prefixOffset              = 3
      end;
    
      local  suffixStart, suffixOffset = tag:match('%<$()', prefixEnd), 1
    
      if not suffixStart
      then   suffixStart               = suffixEnd + 1
      else   suffixOffset              = 3
      end;
    
      return 
        tag:sub(prefixEnd + prefixOffset, suffixStart - suffixOffset), 
        prefixEnd, 
        suffixStart, 
        suffixEnd, 
        tag:match('%((.-)%)')
    end
   
    local func;
  
    local format, numTags = tagstr:gsub('%%', '%%%%'):gsub(TAG_PATTERN, '%%s')
    local args = {}
  
    for bracket in tagstr:gmatch(TAG_PATTERN) 
    do  local tagFunc;
        local tagName, prefixEnd, suffixStart, suffixEnd, customArgs = getBracketData(bracket)
        local tag = methods[tagName]
    
        if   tag 
        then if     prefixEnd ~= 1 and suffixStart - suffixEnd ~= 1  
             then   local prefix = bracket:sub(2, prefixEnd)
                    local suffix = bracket:sub(suffixStart, suffixEnd)
         
                    tagFunc = 
                      function(unit, realUnit)
                        local str
                        if   customArgs
                        then str = tag(unit, realUnit, strsplit(',', customArgs))
                        else str = tag(unit, realUnit)
                        end
                        if str and str ~= '' then return prefix .. str .. suffix end
                      end
              
             elseif prefixEnd ~= 1  
             then   local prefix = bracket:sub(2, prefixEnd)
    
                    tagFunc = 
                      function(unit, realUnit)
                      local str
                      if   customArgs  
                      then str = tag(unit, realUnit, strsplit(',', customArgs))
                      else str = tag(unit, realUnit)
                      end
                      if str and str ~= '' then return prefix .. str end
                    end
    
             elseif suffixStart - suffixEnd ~= 1  
             then   local suffix = bracket:sub(suffixStart, -2)
    
                    tagFunc = 
                      function(unit, realUnit)
                        local str
                        if   customArgs 
                        then str = tag(unit, realUnit, strsplit(',', customArgs))
                        else str = tag(unit, realUnit)
                        end
                        if str and str ~= '' then return str .. suffix end
                      end
    
             else   tagFunc = 
                      function(unit, realUnit)
                        local str
                        if   customArgs  
                        then str = tag(unit, realUnit, strsplit(',', customArgs))
                        else str = tag(unit, realUnit)
                        end
                        if str and str ~= '' then return str end
                      end
             end -- if (lotsa stuff)
        end -- if tag
    
        if   tagFunc  
        then table.insert(args, tagFunc)
        else table.insert(args, function() return "[" .. tagName .. "]" end);
        end
    end -- for
    
    for i, f in next, args do funcResults[i] = f(unit, realUnit or unit) or '' end
    
    return string.format(format, unpack(funcResults));
  end; -- function evalTagString

  local function evalTagStringAsPlayer(tagStr, use_oUF)
    return evalTagString(tagStr, "player", "player", use_oUF);
  end;

  local function tagExists(tag, oUF)
    oUF = oUF or RPTAGS.oUF;
    return tag and oUF.Tags.Methods[tag] and true or false;
  end;

  RPTAGS.utils.tags              = RPTAGS.utils.tags or {};
  RPTAGS.utils.tags.exists       = tagExists;
  RPTAGS.utils.tags.eval         = evalTagString;
  RPTAGS.utils.tags.evalPlayer   = evalTagStringAsPlayer;
  RPTAGS.utils.tags.registerTag  = registerTag;
  RPTAGS.utils.tags.sizeVariants = registerTagSizeVariants;
  RPTAGS.utils.tags.colorTag     = registerColorTag;
  RPTAGS.utils.tags.registerLabel = registerTagLabel;

  RPTAGS.utils.tags.addTag       = addTag;
  RPTAGS.utils.tags.addTagGroup  = addTagGroup;
  RPTAGS.utils.tags.addAllTags   = addAllTags;
  
  -- RPQ -----------------------------------------------------------------------------------------------------------------------
end);
  
