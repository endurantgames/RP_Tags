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
RPTAGS.queue:WaitUntil("UTILS_TEXT",
function(self, event, ...)
  
  RPTAGS.utils = RPTAGS.utils or {};
  RPTAGS.utils.text = RPTAGS.utils.text or {};
  RPTAGS.cache = RPTAGS.cache or {};
  
  local Utils  = RPTAGS.utils;
  local Cache = RPTAGS.cache;
  
  local loc     = Utils.locale.loc;
  local Config  = Utils.config;
  
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
  
  local function textTruncate(text, maxLength)
        local ellipse;
  
        if Config("REAL_ELLIPSES") 
           then ellipse = "…" 
           else ellipse = "..." 
           end; -- if
  
        if text:len() > maxLength 
           then text = text:sub(1, maxLength) .. ellipse 
           end; -- if
  
        return text 
  end;
  -- ---------------------------------------------------------------------------------------------------------------------
  
        -- changes multiple [[[these]]] into hilited text
  local function hiliteTags(s, forHTML)
        if not s then return "" end;
        local reset = "|r";
  
        s = s:gsub("%[%[%[",    "|cff" .. Config.get("COLOR_HILITE_3"));
        s = s:gsub("%]%]%]",    reset);
        s = s:gsub("%[%[",      "|cff" .. Config.get("COLOR_HILITE_2"));
        s = s:gsub("%]%]",      reset);
        if forHTML
           then s = s:gsub("(<a [^>]+>.-</a>)", "|cff00dd00%1|r");
                s = s:gsub("\n\n", "\n<br />\n");
                s = s:gsub("&nbsp;", RPTAGS.CONST.NBSP);
                s = s:gsub("%[(.-)%]", "[<a href='rptag:%1'>" .. RPTAGS.CONST.APP_COLOR .. "%1|r</a>]")
           else s = s:gsub("%[", "[" .. "|cff" .. Config.get("COLOR_HILITE_1"));
                s = s:gsub("%]",        reset .. "]");
        end;
          
        s = s:gsub("RPTAGS",    loc("APP_NAME"));
        return s;
  end  
  
  -- ---------------------------------------------------------------------------------------------------
  -- 
  -- Function encrypts and decrypts using ROT13
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
  local function addOnList()
    local active_addons = { "# Active Addons ", };
    local disabled_addons = { "# Disabled Addons", };
    local num = GetNumAddOns();
    for i = 1, num, 1
    do  local name, _, _, enabled = GetAddOnInfo(i)
        local version = GetAddOnMetadata(name, "X-Curse-Packaged-Version") or GetAddOnMetadata(name, "Version") or ""
        name = name:gsub("|cff%x%x%x%x%x%x",""):gsub("|r",""):gsub("_","\\_");
        if   enabled 
        then table.insert(active_addons, "<p>|cff00dd00" .. name .. "|r (" .. version .. ")</p>")
        else table.insert(disabled_addons, "<p>|cff808080" .. name .. " (" .. version .. ")|r</p>")
        end;
    end;
    return table.concat(active_addons, "\n") .. "\n\n" .. table.concat(disabled_addons, "\n");
  end;
  
  local function vText()
    local v = { };
    -- for _, i in ipairs(Cache.state.rpClients)  do table.insert(v, loc("ADDON_" .. i:upper())) end;
    -- for _, i in ipairs(Cache.state.unitFrames) do table.insert(v, loc("ADDON_" .. i:upper())) end;
    return "v" .. RPTAGS.CONST.VERSION -- ..  "-" ..table.concat(v, "-"):gsub("[ :,]","");
  end;
  
  local function versionText() 
    return string.format(loc("FMT_APP_LOAD"), vText(), "/" .. split(loc("APP_SLASH"), "|")[1]);
  end;
  
  local function changesText() return "v" .. RPTAGS.CONST.VERSION .. " " .. loc("CHANGES") .. ": " .. loc("APP_CHANGES") end;
  
  local function notify(message) print(hiliteTags("[RPTAGS] " .. message)); end;
  
       -- debugging function
  local function tellOra(message) print(hiliteTags("|cffbb00bbOra|r, ", message)) end;
  
  local function notSupported()       return "|cff" .. Config.get("COLOR_UNKNOWN") .. Config.get("UNSUP_TAG") .. "|r" end;
  local function dontChangeTheColor() return "" end;
  local function iconNotSupported()   if Config.get("UNSUP_TAG") == "" then return "" else return "|TRAIDFRAME\\ReadyCheck-NotReady:0|t" end; end;
  
  -- Utilities available under RPTAGS.utils.text
  --
  RPTAGS.utils.text.hilite     = hiliteTags;
  RPTAGS.utils.text.isnum      = isNumber;
  RPTAGS.utils.text.match      = match;
  RPTAGS.utils.text.rot13      = rot13;
  RPTAGS.utils.text.split      = split;
  RPTAGS.utils.text.truncate   = textTruncate;
  RPTAGS.utils.text.titlecase  = titleCase;
  RPTAGS.utils.text.notify     = notify;
  RPTAGS.utils.text.ora        = tellOra;
  RPTAGS.utils.text.version    = versionText;
  RPTAGS.utils.text.v          = vText;
  RPTAGS.utils.text.addons     = addOnList;
  RPTAGS.utils.text.changes    = changesText;
  RPTAGS.utils.text.unsup      = notSupported;
  RPTAGS.utils.text.unsupcolor = dontChangeTheColor;
  RPTAGS.utils.text.unsupicon  = iconNotSupported;
  
end);
