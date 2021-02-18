-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 

local addOnName, addOn = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);
local oUF    = RPTAGS.oUF;

Module:WaitUntil("UTILS_TAGS",
function(self, event, ...)
  local RPTAGS = RPTAGS;
  local fontFrame = CreateFrame('frame');
  local font = fontFrame:CreateFontString(nil, 'OVERLAY', 'GameFontNormal');
  local FONTFILE, FONTSIZE, _ = font:GetFont();

  local function testTags(s)
    local err, good, bad = false, {}, {};
    for tag in string.gmatch(s, "%[([^%]]+)%]")
    do  if   RPTAGS.utils.tags.exists(tag)
        then table.insert(good, tag)
        else table.insert(bad, tag); err = true;
        end; --if
    end; -- do
    return err, good, bad;
  end; -- function

  local function fixTagErrors(s)
    local err, good, bad = testTags(s);
    if not err then return s end;
    for _, badTag in ipairs(bad) do s = s:gsub("%[" .. badTag .. "%]", "%[err%]" .. badTag .. "%[/err%]"); end;
    return s;
  end -- function
  
        -- registers one tag, an event to wait for, and a method to invoke when found --------------------------
  local function registerTag(tagName, tagMethod, extraEvents)
    local events = RPTAGS.CONST.MAIN_EVENT .. (extraEvents and (" " .. extraEvents) or "");

    if not RPTAGS.oUF.Tags.Events[tagName] and not tagName:match("%(.+%)$")
        -- only make this tag if there isn't one by that name already;
    then   RPTAGS.oUF.Tags.Events[tagName] = events;
           RPTAGS.oUF.Tags.Methods[tagName] = tagMethod;
    end;

    return tagName, tagMethod, extraEvents;
  end; -- function

  local function registerTagSizeVariants(tagName, tagMethod, tagExtraEvents)
    local sizeTrim = RPTAGS.utils.text.sizeTrim;
    RPTAGS.utils.tags.registerTag(
      tagName,
      function(u1, u2, size) return sizeTrim(tagMethod( u1, u2), size) end,
      tagExtraEvents
    );
    return tagName, tagMethod, tagExtraEvents;
  end;
  
  local function registerTagLabel(tagName, tagMethod, tagExtraEvents, label)
    local split = RPTAGS.utils.text.split;
    local lab = split(label, "|");
    local prefix, suffix = lab[1] or "", lab[2] or "";
    RPTAGS.utils.tags.registerTag( 
      prefix .. "$>" .. tagName .. "-label<$" .. suffix,
      tagMethod, 
      tagExtraEvents
    );
    return tagName, tagMethod, tagExtraEvents, label;
  end;

  RPTAGS.utils.modules.extend(
  { [ "tags.registerTag"   ] = registerTag, 
    [ "tags.registerLabel" ] = registerTagLabel,
    [ "tags.sizeVariants"  ] = registerTagSizeVariants,
  });

  RPTAGS.utils.tags.fix             = fixTagErrors;
  RPTAGS.utils.tags.test            = testTags;

end);
