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
  local function registerTag(tagName, tagMethod, extraEvents, ...)
    local events = RPTAGS.CONST.MAIN_EVENT .. (extraEvents and (" " .. extraEvents) or "");

    if not oUF.Tags.Events[tagName] and not tagName:match("%(.+%)$")
        -- only make this tag if there isn't one by that name already;
    then   oUF.Tags.Events[tagName] = events;
           oUF.Tags.Methods[tagName] = tagMethod;
    end;

    return tagName, tagMethod, extraEvents, ...;
  end; -- function

  local function registerTagSizeVariants(tagName, tagMethod, tagExtraEvents, ...)
    local sizeTrim = RPTAGS.utils.text.sizeTrim;
    RPTAGS.utils.tags.registerTag(
      tagName,
      function(u1, u2, size) return sizeTrim(tagMethod( u1, u2), size) end,
      tagExtraEvents
    );
    return tagName, tagMethod, tagExtraEvents, ...;
  end;
  
  local function colorTagHandler(result, xform, param)
    local doTransform = RPTAGS.utils.color.transform;

    local hash =
    { 
      black      = { what = "L",            negative = true, },
      blackness  = { what = "L",            negative = true, },
      blacker    = { what = "L", er = true, negative = true, },
      blacken    = { what = "L", er = true, negative = true, },
      dark       = { what = "L",            negative = true  },
      darkness   = { what = "L",            negative = true  },
      darker     = { what = "L", er = true, negative = true  },
      darken     = { what = "L", er = true, negative = true  },

      l          = { what = "L"                              },
      b          = { what = "L"                              },
      light      = { what = "L"                              },
      lighter    = { what = "L", er = true,                  },
      lighten    = { what = "L", er = true,                  },
      lightness  = { what = "L"                              },
      white      = { what = "L"                              },
      whiteness  = { what = "L"                              },
      whiter     = { what = "L", er = true,                  },
      whiten     = { what = "L", er = true,                  },

      bright     = { what = "V"                              },
      brighter   = { what = "V", er = true,                  },
      brighten   = { what = "V", er = true,                  },
      brightness = { what = "V"                              },
      dim        = { what = "V",            negative = true  },
      dimness    = { what = "V",            negative = true  },
      dimmer     = { what = "V", er = true, negative = true  },
      v          = { what = "V"                              },

      h          = { what = "H"                              },
      hue        = { what = "H"                              },

      s          = { what = "S"                              },
      sat        = { what = "S"                              },
      saturation = { what = "S"                              },
      saturate   = { what = "S"                              },
      desaturate = { what = "S",            negative = true  },
      desat      = { what = "S",            negative = true  },

    };

    xform = strtrim(xform or ""); 
    param = strtrim(param or ""); 

    param = "half"      and "0.5"  or "max"       and "1"    or "min" and "0" or 
            "more"      and "+25%" or "less"      and "-25%" or 
            "lots more" and "+50%" or "lots less" and "-50%" or
            "lotsmore"  and "+50%" or "lotsless"  and "-50%" or
            param;
    if xform:len() * param:len() == 0 then return result end;

    local transform = hash[xform];          
    if not transform then return result end;

    local PATTERN = "(=? ?)" .. "(%+? ?)" .. "(%-? ?)" .. "(%d+%.?%d*)" .. "(%%?)$"
    local equal, plus, minus, value, percent = param:match(PATTERN);

    if not value then return result end;

    equal   = equal:len()   > 0;
    plus    = plus:len()    > 0;
    minus   = minus:len()   > 0;
    percent = percent:len() > 0;

    if plus and minus then return result end; -- illogical

    value = tonumber(value);
    if not value then return result end;

    percent = (value > 1 and value <= 100) or percent;
    value = percent and value / 100 or value;

    value = math.max(math.min(value, 1), 0);

    value = value * (transform.negative and -1 or 1) * (minus and -1 or 1);

    if     transform.er and percent then return "|cff" .. select(4, doTransform(result, "rel" .. transform.what, value))
    elseif transform.er             then return "|cff" .. select(4, doTransform(result, "add" .. transform.what, value))
    elseif equal                    then return "|cff" .. select(4, doTransform(result, "set" .. transform.what, value))
    elseif not (plus or minus)      then return "|cff" .. select(4, doTransform(result, "set" .. transform.what, value))
    elseif percent                  then return "|cff" .. select(4, doTransform(result, "rel" .. transform.what, value))
                                    else return "|cff" .. select(4, doTransform(result, "add" .. transform.what, value))
    end;

  end;

  local function registerColorTag(tagName, tagMethod, tagExtraEvents, ...)
    RPTAGS.utils.tags.registerTag( 
      tagName, 
      function(u1, u2, transform, p1, p2, ...) 
        return colorTagHandler( tagMethod(u1, u2, transform, p1, p2, ...), transform, p1, p2 ) 
      end, 
    tagExtraEvents);
    return tagName, tagMethod, tagExtraEvents, ...;
  end;

  local function refreshFrame(frameName, ...)
    if RPTAGS.utils.UnitFrames[frameName]
    then RPTAGS.utils.frames.RPUF_Refresh(frameName, "content");
    end;

    return frameName, ...; 
  end;

  local function refreshAll(...)
    RPTAGS.utils.frames.RPUF_Refresh("all", "content");
    return ...
  end;

  RPTAGS.utils.modules.extend(
  { [ "tags.registerTag"   ] = registerTag, 
    [ "tags.sizeVariants"  ] = registerTagSizeVariants,
    [ "tags.colorTag"      ] = registerColorTag,
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
