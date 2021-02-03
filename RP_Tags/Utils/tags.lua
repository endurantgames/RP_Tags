local RPTAGS = RPTAGS;
RPTAGS.queue:WaitUntil("UTILS_TAGS",
function(self, event, ...)
-- RPQ ------------------------------------------------------------------------------------------------------------------------

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

  local registerTag = RPTAGS.utils.tags.registerTag;
  local function sizeTrim(t, s) return t end; -- this is a dummy function for now

  if     tag.external or group.external
  then   -- if it's an external source then skip
  elseif tag.title
  then   -- it's just a header for the documentation
  else   -- first we make the core tag

         local tagMethod = tag.method

         if RPTAGS.CONST.UNSUP[tag.name]
         then tagMethod = RPTAGS.utils.text[RPTAGS.CONST.UNSUP[tag.name]];
         end;

         RPTAGS.cache.help.tagIndex[tag.name] = "opt://help/tags/" .. group.key;

         registerTag(tag.name, tagMethod, tag.events);

         -- then does it have a label?
         if tag.label
         then registerTag(
                 tag.name .. "-label",
                 function(u) return tag.label .. ": " .. method(u) end,
                 tag.events
              );
         end;

         -- does it have aliases?
         if tag.alias
         then for _, aka in ipairs(tag.alias)
              do  registerTag(aka, tag.method, tag.events);
                  -- if the core tag has a label then the aliases do too
                  if tag.label
                  then registerTag(
                         aka .. "-label",
                         function(u) return tag.label .. ": " .. method(u) end,
                         tag.events
                       );
                  end;
              end;
         end;

         -- finally, does it have size variants?
         if tag.size == true
         then for size, chars in pairs(RPTAGS.CONST.SCALE)
              do  registerTag(
                    tag.name .. size,
                    function(u) return sizeTrim(method(u), chars) end,
                    tag.events
                  );
              end;

         end;

         return tag, group; -- pass these values through in case a module needs it

  end;
  -- and that tag is done!
end;

local function registerTag(...) return ... end;
 
RPTAGS.utils.tags             = RPTAGS.utils.tags or {};
RPTAGS.utils.tags.registerTag = registerTag;
RPTAGS.utils.tags.addTag      = addTag;
RPTAGS.utils.tags.addTagGroup = addTagGroup;
RPTAGS.utils.tags.addAllTags  = addAllTags;

-- RPQ -----------------------------------------------------------------------------------------------------------------------
end);

