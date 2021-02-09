local RPTAGS = RPTAGS;
local addOnName, ns = ...;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("UTILS_TAGS",
function(self, event, ...)

  RPTAGS.cache.workAround = RPTAGS.cache.workAround or {};
  local loc               = RPTAGS.utils.locale.loc;
  local sliceUp           = RPTAGS.utils.text.sliceUp;
  local sizeTrim          = RPTAGS.utils.text.sizeTrim;
  local registerTag       = RPTAGS.utils.tags.registerTag;

  local function registerTagWorkaround(tagName, method, extraEvents)
    local prefix, baseTag, suffix = tagName:match("^(.*)%$>(rp:[.-])-label<$(.*)$")
    if baseTag
    then return 
           baseTag .. "-label",
           function(...)
             return (prefix or "") .. method(...) .. (suffix or "")
           end,
           extraEvents;
    else return tag, method, extraEvents;
    end;
  end;

  local function addTagWorkaround(tag, group)
    if   tag.size
    then RPTAGS.cache.sizeCodes = RPTAGS.cache.sizeCodes 
           or sliceUp({ loc("SIZE_CODE_XS"), loc("SIZE_CODE_S"), 
                        loc("SIZE_CODE_M"), loc("SIZE_CODE_L"), 
                        loc("SIZE_CODE_XL") 
                      });
        for code, chars in pairs(RPTAGS.cache.sizeCodes)
        do  registerTag(
              tag.name .. "(" .. code .. ")",
              function(...) return sizeTrim( tag.method(...), chars) end,
              tag.extraEvents);
            if   tag.alias
            then for _, aka in ipairs(tag.alias)
                 do  registerTag(
                       aka .. "(" .. code .. ")",
                       function(...) return sizeTrim( tag.method(...), chars) end,
                       tag.extraEvents);
                 end;
            end;
        end;
    end;
    return tag, group;
  end;

  if RPTAGS.cache.workAround["ElvUI's oUF is old."]
  then RPTAGS.utils.modules.extend(
       { --         ["tags.registerTag"] = registerTagWorkaround,
          ["tags.addTag"] = addTagWorkaround,
         });
       print("Implementing work-around for: " .. "ElvUI's oUF is old.");
  end;
end);

Module:WaitUntil("ADDON_LOAD",
function(self, event, ...)

  local function addTagInfoWorkaround(self, tagName, category, description, order)
    if type(order) == "number" then order = order + 10 else order = nil end;

    if not tagName:match("%(") and not tagName:match("-label")
    then self.TagInfo[tagName] = self.TagInfo[tagName] or {};
         self.TagInfo[tagName].category = category or "Miscellaneous";
         self.TagInfo[tagName].description = description or "";
         self.TagInfo[tagName].order = order or nil;
    end;
  end;

  if RPTAGS.cache.workAround["ElvUI loads too much tag info."]
  then local E, _, _, _, _ = unpack(ElvUI)
       E.AddTagInfo = addTagInfoWorkaround;
       E.Options.args.tagGroup.args.Miscellaneous.args = {};
  end;
end);
