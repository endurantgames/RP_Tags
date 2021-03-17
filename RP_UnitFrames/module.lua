local addOnName, ns = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:NewModule(addOnName, "rpClient");

Module:WaitUntil("ADDON_INIT",
function(self, event, ...)
  RP_UnitFramesDB = RP_UnitFramesDB or {};
end);

Module:WaitUntil("MODULE_C",
function(self, event, ...)
  local registerFunction = RPTAGS.utils.modules.registerFunction;
  
  local function openUIPanel(panel)
    return
      function() 
        RPTAGS.utils.links.handler(RPTAGS.CONST.UIPANELS[panel])
      end;
  end;

  registerFunction(addOnName, "options", openUIPanel("frames"  ));
  registerFunction(addOnName, "version", openUIPanel("version" ));
  registerFunction(addOnName, "about",   openUIPanel("about"   ));
  registerFunction(addOnName, "help",    openUIPanel("help"    ));
  registerFunction(addOnName, "on", 
    function() 
      RPTAGS.utils.config.set("DISABLE_RPUF", false) 
    end);
  registerFunction(addOnName, "off", 
    function() 
      RPTAGS.utils.config.set("DISABLE_RPUF", true) 
    end);
  registerFunction(addOnName, "on_off",
    function() 
      RPTAGS.utils.config.set("DISABLE_RPUF",
        not RPTAGS.utils.config.get("DISABLE_RPUF")) 
    end);
  registerFunction(addOnName, "hide_combat",
    function() 
      RPTAGS.utils.config.set("HIDE_COMBAT",
        not RPTAGS.utils.config.get("HIDE_COMBAT")) 
    end);
  registerFunction(addOnName, "moveframes",
    function()
      RPTAGS.utils.config.set("LOCK_FRAMES",
        not RPTAGS.utils.config.get("LOCK_FRAMES"))
    end);
  registerFunction(addOnName, "editor",
    function() 
      RPTAGS.cache.Editor:Show() 
    end);

end);

Module:WaitUntil("UTILS_TAGS",
function(self, event, ...)
  local RPTAGS = RPTAGS;
  local fontFrame = CreateFrame('frame');
  local font = fontFrame:CreateFontString(nil, 'OVERLAY', 'GameFontNormal');
  local FONTFILE, FONTSIZE, _ = font:GetFont();
  local oUF    = _G[GetAddOnMetadata(addOnName, "X-oUF")];

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

    if not oUF.Tags.Events[tagName] and not tagName:match("%(.+%)$")
        -- only make this tag if there isn't one by that name already;
    then   oUF.Tags.Events[tagName] = events;
           oUF.Tags.Methods[tagName] = tagMethod;
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
  
  local function refreshFrame(frameName, ...)
    RPTAGS.utils.frames.RPUF_Refresh(frameName, "content");
    return frameName, ...; 
  end;

  local function refreshAll(...)
    RPTAGS.utils.frames.RPUF_Refresh("all", "content");
    return ...
  end;

  RPTAGS.utils.modules.extend(
  { [ "tags.registerTag"   ] = registerTag, 
    [ "tags.sizeVariants"  ] = registerTagSizeVariants,
    [ "frames.refresh"     ] = refreshframe,
    [ "frames.refreshAll"  ] = refreshAll,
  });

  RPTAGS.utils.tags.fix             = fixTagErrors;
  RPTAGS.utils.tags.test            = testTags;

end);

Module:WaitUntil("after CORE_STATE",
function(self, event, ...)
  RPTAGS.oUF = _G[GetAddOnMetadata(addOnName, "X-oUF")]; -- let RP_Tags use our oUF for previews
end);
