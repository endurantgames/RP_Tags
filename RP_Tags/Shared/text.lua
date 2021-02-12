-- ------------------------------------------------------------------------------
-- RP Tags
-- by Oraibi, Moon Guard (US) server
--
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. To view a copy of the license, visit
--
--     https://creativecommons.org/licenses/by/4.0/

-- Utils-Text: Utilities for manipulating text strings
--
-- List of utils at the end

local RPTAGS     = RPTAGS;
local addOnName, ns = ...;

RPTAGS.queue:WaitUntil("UTILS_TEXT",
function(self, event, ...)
  
  RPTAGS.utils      = RPTAGS.utils or {};
  RPTAGS.utils.text = RPTAGS.utils.text or {};
  RPTAGS.cache      = RPTAGS.cache or {};
  local Utils       = RPTAGS.utils;
  local Cache       = RPTAGS.cache;
  local loc         = Utils.locale.loc;
  local Config      = Utils.config;

        -- function to split a string based on a pattern
  local function split(str, pat)
        local t          = {};
        local fpat       = "(.-)" .. pat;
        local last_end   = 1;
        local s, e, cap  = str:find(fpat, 1)
        while s do if s ~= 1 or cap ~= ""
                      then table.insert(t,cap);
                   end -- if
                   last_end  = e+1;
                   s, e, cap = str:find(fpat, last_end);
                end -- while/do
        if last_end <= #str
           then cap = str:sub(last_end);
                table.insert(t, cap);
           end -- if
        return t;
  end; 
  
        -- matching function
  local function match(s, p) 
        if not s or not p then return false; end;
        return string.find(string.lower(s), string.lower(p)); 
  end; 
  
        -- check if it's a number
  local function isNumber(s) 
        return (tonumber(s) ~= nil); 
  end; 
  
        -- from http://lua-users.org/wiki/StringRecipes
  local function titleCase(str)
        local function tchelper(first, rest) return first:upper()..rest:lower() end
        
         -- Add extra characters to the pattern if you need to. _ and ' are
         --  found in the middle of identifiers and English words.
         -- We must also put %w_' into [%w_'] to make it handle normal stuff
         -- and extra stuff the same.
         -- This also turns hex numbers into, eg. 0Xa7d4
        if not str then return "" end;
        return str:gsub("(%a)([%w_']*)", tchelper)
  end;
  
  function sliceUp(tableOfStrings)
    local dups = {};
    local uniq = {};
    for _, fullString in ipairs(tableOfStrings)
    do  local aliases = split(fullString, "|");
        for i, str in ipairs(aliases)
        do local s = "";
           for c in str:gmatch(".")
           do  s = s .. c;
               if not dups[s] and not uniq[s] 
               then   uniq[s] = aliases[1]
               elseif dups[s]                 
               then   dups[s] = dups[s] .. "|" .. aliases[1];
               elseif uniq[s] and uniq[s] ~= aliases[1]
               then   dups[s] = uniq[s] .. "|" .. aliases[1];
                      uniq[s] = nil;
               end;
           end;
        end;
    end;
    return uniq, dups;
  end;

  local function textTruncate(text, maxLength)
        local ellipse = Config("REAL_ELLIPSES")  and "…" or "..." ;
        if text:len() > maxLength 
           then text = text:sub(1, maxLength) .. ellipse 
           end; -- if
        return text 
  end;

  local function sizeTrim(text, size)
    size = size or "0";
    size = size:gsub("%s",""):lower();
    local uniq = RPTAGS.cache.sizeCodes;
    if   not uniq
    then local keys =
         { loc("SIZE_CODE_XS"),
           loc("SIZE_CODE_S"),
           loc("SIZE_CODE_M"),
           loc("SIZE_CODE_L"),
           loc("SIZE_CODE_XL"),
         };
        uniq, _ = sliceUp(keys)
        RPTAGS.cache.sizeCodes = uniq;
    end;
    size = uniq[size] and Config.get("TAG_SIZE_" .. uniq[size])
        or tonumber(size);

    return size > 0 and textTruncate(text, size) or text;

  end;
  -- ---------------------------------------------------------------------------------------------------------------------
  
        -- changes multiple [[[these]]] into hilited text
  local function hiliteTags(s)
        if not s then return "" end;
        local reset = "|r";
  
        s = s:gsub("%[%[%[", "|cff" .. Config.get("COLOR_HILITE_3"));
        s = s:gsub("%]%]%]", reset);
        s = s:gsub("%[%[",   "|cff" .. Config.get("COLOR_HILITE_2"));
        s = s:gsub("%]%]",   reset);
        s = s:gsub("RPTAGS",    loc("APP_NAME"));
        return s;
  end  
  
  -- ---------------------------------------------------------------------------------------------------
  -- 
  -- Function "encrypts" and "decrypts" using ROT13
  -- source: https://gist.github.com/obikag/7035680
  --
  local function rot13(str)
    local cipher = { A="N",B="O",C="P",D="Q",E="R",F="S",G="T",H="U",I="V",J="W",K="X",L="Y",M="Z",
                     N="A",O="B",P="C",Q="D",R="E",S="F",T="G",U="H",V="I",W="J",X="K",Y="L",Z="M",
                     a="n",b="o",c="p",d="q",e="r",f="s",g="t",h="u",i="v",j="w",k="x",l="y",m="z",
                     n="a",o="b",p="c",q="d",r="e",s="f",t="g",u="h",v="i",w="j",x="k",y="l",z="m" }
    local estr = ""
    for c in str:gmatch(".") do if (c:match("%a")) then estr = estr..cipher[c] else estr = estr..c end end
    return estr
  end 
  -- ---------------------------------------------------------------------------------------------------
  --
  local function vText()
    local v = { };
    return "v" .. RPTAGS.CONST.VERSION -- ..  "-" ..table.concat(v, "-"):gsub("[ :,]","");
  end;
  
  local function versionText() 
    return string.format(loc("FMT_APP_LOAD"), vText(), "/" .. split(loc("APP_SLASH"), "|")[1]);
  end;
  
  local function notify(message) print(hiliteTags("[RPTAGS] " .. message)); end;
  local function notifyFmt(format, ...) notify(string.format(format, ...)) end;
  
  -- Utilities available under RPTAGS.utils.text
  --
  RPTAGS.utils.text.hilite       = hiliteTags;
  RPTAGS.utils.text.isnum        = isNumber;
  RPTAGS.utils.text.match        = match;
  RPTAGS.utils.text.rot13        = rot13;
  RPTAGS.utils.text.split        = split;
  RPTAGS.utils.text.sliceUp      = sliceUp;
  RPTAGS.utils.text.truncate     = textTruncate;
  RPTAGS.utils.text.sizeTrim     = sizeTrim;
  RPTAGS.utils.text.titlecase    = titleCase;
  RPTAGS.utils.text.notify       = notify;
  RPTAGS.utils.text.version      = versionText;
  RPTAGS.utils.text.v            = vText;
  RPTAGS.utils.text.addons       = addOnList;
  RPTAGS.utils.text.changes      = changesText;
  RPTAGS.utils.text.notifyFmt    = notifyFmt;

end);
