-- RP Fonts
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International (CC BY 4.0) license.

local addOnName, ns = ...;

local LibSharedMedia    = LibStub("LibSharedMedia-3.0");
local AceGUI            = LibStub("AceGUI-3.0", true)
local AceConfig         = LibStub("AceConfig-3.0");
local AceConfigDialog   = LibStub("AceConfigDialog-3.0");
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0");
local Interface         = InterfaceOptionsFrame;
local Interface_Open    = InterfaceOptionsFrame_OpenToCategory;
local rpFontsTitle      = GetAddOnMetadata(addOnName, "Title");
local rpFontsDesc       = GetAddOnMetadata(addOnName, "Notes");
local rpFontsVersion    = GetAddOnMetadata(addOnName, "Version");

ns.RP_Fonts             = ns.RP_Fonts     or {};
ns.RP_Fonts.tmp         = ns.RP_Fonts.tmp or {}; -- temporary cache

local listOfIncludedFonts = [===[
|cff00ffffAmarante|r
Copyright (c) 2012 by Sorkin Type Co (www.sorkintype.com), with Reserved Font Name "Amarante".

|cff00ffffArima Madruai|r
Copyright 2015 The Arima Project Authors (info@ndiscovered.com)

|cff00ffffBarlow Condensed|r
Copyright 2017 The Barlow Project Authors (https://github.com/jpt/barlow)

|cff00ffffBebas Neue|r
Copyright © 2010 by Dharma Type.

|cff00ffffBig Shoulders Stencil Display|r
Copyright 2019 The Big Shoulders Project Authors (https://github.com/xotypeco/big_shoulders)

|cff00ffffBitter|r
Copyright 2011 The Bitter Project Authors (https://github.com/solmatas/BitterPro)

|cff00ffffBree Serif|r
Copyright (c) 2011, TypeTogether (www.type-together.com), 

|cff00ffffCedarville Cursive|r
Copyright (c) 2010, Kimberly Geswein (kimberlygeswein.com)

|cff00ffffDotGothic16|r
Copyright 2020 The DotGothic16 Project Authors (https://github.com/fontworks-fonts/DotGothic16)

|cff00ffffEast Sea Dokdo|r
Copyright (c) YoonDesign Inc. All Rights Reserved.

|cff00ffffFlamenco|r
Copyright (c) 2011 by LatinoType Limitada (luciano@latinotype.com), 

|cff00ffffFondamento|r
Copyright (c) 2011 by Brian J. Bonislawsky DBA Astigmatic (AOETI) (astigma@astigmatic.com), with Reserved Font Names "Fondamento" and "Fondamento Italic"

|cff00ffffIM_Fell Types|r
Copyright (c) 2010, Igino Marini (mail@iginomarini.com)

|cff00ffffKrona One|r
Copyright (c) 2011 by Sorkin Type Co (www.sorkintype.com), with Reserved Font Names "Krona" and "Krona One".

|cff00ffffMerriweather Sans|r
Copyright 2019 The Merriweather Project Authors (https://github.com/SorkinType/Merriweather-Sans) with Reserved Font Name 'Merriweather'

|cff00ffffMrs Saint Delafield|r
Copyright (c) 2011 Alejandro Paul (sudtipos@sudtipos.com), with Reserved Font Name "Mrs Saint Delafield"

|cff00ffffOswald|r
Copyright 2016 The Oswald Project Authors (https://github.com/googlefonts/OswaldFont)

|cff00ffffPoppins|r
Copyright 2020 The Poppins Project Authors (https://github.com/itfoundry/Poppins)

|cff00ffffPress Start 2P|r
Copyright 2012 The Press Start 2P Project Authors (cody@zone38.net), with Reserved Font Name "Press Start 2P".

|cff00ffffPrincess Sofia|r
Copyright (c) 2011, Font Diner (www.fontdiner.com), with Reserved Font Name "Princess Sofia".

|cff00ffffReggae_One|r
Copyright 2020 The Reggae Project Authors (https://github.com/fontworks-fonts/Reggae)

|cff00ffffShareTechMono|r
Copyright (c) 2012, Carrois Type Design, Ralph du Carrois (post@carrois.com www.carrois.com), with Reserved Font Name 'Share'

|cff00ffffSource Code Pro Copyright 2010, 2012 Adobe Systems Incorporated (http|r//www.adobe.com/), with Reserved Font Name 'Source'. All Rights Reserved. Source is a trademark of Adobe Systems Incorporated in the United States and/or other countries.

|cff00ffffSyne_Mono|r
Copyright 2017 The Syne Project Authors (https://gitlab.com/bonjour-monde/fonderie/syne-typeface)

|cff00ffffUncial Antiqua|r
Copyright (c) 2011 by Brian J. Bonislawsky DBA Astigmatic (AOETI) (astigma@astigmatic.com), with Reserved Font Names "Uncial Antiqua"
]===];

local openFontLicense = [===[
This Font Software is licensed under the SIL Open Font License, Version 1.1.
This license is copied below, and is also available with a FAQ at:
http://scripts.sil.org/OFL


-----------------------------------------------------------
|cffffff00SIL OPEN FONT LICENSE Version 1.1 - 26 February 2007|r
-----------------------------------------------------------

|cff00ffffPREAMBLE|r
The goals of the Open Font License (OFL) are to stimulate worldwide
development of collaborative font projects, to support the font creation
efforts of academic and linguistic communities, and to provide a free and
open framework in which fonts may be shared and improved in partnership
with others.

The OFL allows the licensed fonts to be used, studied, modified and
redistributed freely as long as they are not sold by themselves. The
fonts, including any derivative works, can be bundled, embedded, 
redistributed and/or sold with any software provided that any reserved
names are not used by derivative works. The fonts and derivatives,
however, cannot be released under any other type of license. The
requirement for fonts to remain under this license does not apply
to any document created using the fonts or their derivatives.

|cff00ffffDEFINITIONS|r
"Font Software" refers to the set of files released by the Copyright
Holder(s) under this license and clearly marked as such. This may
include source files, build scripts and documentation.

"Reserved Font Name" refers to any names specified as such after the
copyright statement(s).

"Original Version" refers to the collection of Font Software components as
distributed by the Copyright Holder(s).

"Modified Version" refers to any derivative made by adding to, deleting,
or substituting -- in part or in whole -- any of the components of the
Original Version, by changing formats or by porting the Font Software to a
new environment.

"Author" refers to any designer, engineer, programmer, technical
writer or other person who contributed to the Font Software.

|cff00ffffPERMISSION & CONDITIONS|r
Permission is hereby granted, free of charge, to any person obtaining
a copy of the Font Software, to use, study, copy, merge, embed, modify,
redistribute, and sell modified and unmodified copies of the Font
Software, subject to the following conditions:

1) Neither the Font Software nor any of its individual components,
in Original or Modified Versions, may be sold by itself.

2) Original or Modified Versions of the Font Software may be bundled,
redistributed and/or sold with any software, provided that each copy
contains the above copyright notice and this license. These can be
included either as stand-alone text files, human-readable headers or
in the appropriate machine-readable metadata fields within text or
binary files as long as those fields can be easily viewed by the user.

3) No Modified Version of the Font Software may use the Reserved Font
Name(s) unless explicit written permission is granted by the corresponding
Copyright Holder. This restriction only applies to the primary font name as
presented to the users.

4) The name(s) of the Copyright Holder(s) or the Author(s) of the Font
Software shall not be used to promote, endorse or advertise any
Modified Version, except to acknowledge the contribution(s) of the
Copyright Holder(s) and the Author(s) or with their explicit written
permission.

5) The Font Software, modified or unmodified, in part or in whole,
must be distributed entirely under this license, and must not be
distributed under any other license. The requirement for fonts to
remain under this license does not apply to any document created
using the Font Software.

|cff00ffffTERMINATION|r
This license becomes null and void if any of the above conditions are
not met.

|cff00ffffDISCLAIMER|r
THE FONT SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT
OF COPYRIGHT, PATENT, TRADEMARK, OR OTHER RIGHT. IN NO EVENT SHALL THE
COPYRIGHT HOLDER BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
INCLUDING ANY GENERAL, SPECIAL, INDIRECT, INCIDENTAL, OR CONSEQUENTIAL
DAMAGES, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF THE USE OR INABILITY TO USE THE FONT SOFTWARE OR FROM
OTHER DEALINGS IN THE FONT SOFTWARE.
]===];

-- variables
local options, db, Fonts, keys, Browsing, Stats, PreviewText, PreviewSize, Filter, SandboxText, SandboxFont, ViewFontList, ViewLicense;

-- constants
local col        = { 0.2, 1.5, 1.1, 0.5 };
local BUILTIN    = "Built-in font";
local POPUP      = "RPFONTS_CONFIRMATION_BUTTON";

-- general utilities -----------------------------------------------------------------------------------------------------------------------
--
local function strip(str) return str:gsub("|cff%x%x%x%x%x%x", ""):gsub("|r", "") end;

local function colorize(color, str, remove) return color .. (remove and strip(str) or str) .. "|r"; end;

local function     grey(str, r) return colorize( DISABLED_FONT_COLOR_CODE, str, r) end;
local function      red(str, r) return colorize(      RED_FONT_COLOR_CODE, str, r) end;
local function   yellow(str, r) return colorize(   YELLOW_FONT_COLOR_CODE, str, r) end;
local function    green(str, r) return colorize(    GREEN_FONT_COLOR_CODE, str, r) end;
local function bluzzard(str, r) return colorize(BATTLENET_FONT_COLOR_CODE, str, r) end;
local function   hilite(str, r) return colorize(HIGHLIGHT_FONT_COLOR_CODE, str, r) end;
local function   normal(str, r) return colorize(   NORMAL_FONT_COLOR_CODE, str, r) end;
local function    white(str, r) return colorize(             "|cffffffff", str, r) end;

local function notify(...) print("[" .. rpFontsTitle .. "]", ...) end;

-- filters 
local filters    =
{ [ "none"     ] =           "Filter List..." ,
  [ "active"   ] =   yellow( "Active Fonts"   ),
  [ "inactive" ] =    white( "Inactive Fonts" ),
  [ "disabled" ] =     grey( "Disabled Fonts" ),
  [ "missing"  ] =      red( "Missing Fonts"  ),
  [ "new"      ] =    green( "New Fonts"      ),
  [ "builtin"  ] = bluzzard( "Built-In Fonts" ),
};

local filter_desc =
{ [ "none"     ] = "",
  [ "active"   ] = "Active fonts are those which are loaded into LibSharedMedia "           .. 
                   "and which you can use in any addon that uses LibSharedMedia."            ,
  [ "inactive" ] = "Inactive fonts are fonts which could be loaded, but at some point you " .. 
                   "chose to disable them. You can re-enable them at any time."              ,
  [ "disabled" ] = "A disabled font was originally registered with LibSharedMedia by an "   .. 
                   "addon that you still have installed, but is currently disabled."         ,
  [ "missing"  ] = "A missing font was registered with LibSharedMedia by another addon, "   .. 
                   "but you don't have that addon installed, so the font isn't available."   ,
  [ "new"      ] = "New fonts are fonts which are newly registered with LibSharedMedia "    .. 
                   "since the last time you logged on."                                      ,
  [ "builtin"  ] = "Builtin fonts are supplied by Blizzard and registered automatically "   ..
                   "by LibSharedMedia."                                                      ,
};

local filter_order = { "none", "new", "active", "inactive", "disabled", "missing", "builtin"};

-- addons and files ------------------------------------------------------------------------------------------------------------------------
--
-- database ------------------------------------------------------------------------------------------------------------------------------
local function clearCounts() 
  Stats =
  { total    = 0, new      = 0, missing = 0, active  = 0,
    inactive       = 0, disabled = 0, loaded  = 0, builtin = 0,
    builtin_active = 0, new_active = 0,
    now            = Stats.now, -- preserve original value
  };
end;

local function initializeDatabase()

  _G["RP_FontsDB"] = _G["RP_FontsDB"] or {};
  db               = _G["RP_FontsDB"];
  db.Fonts         = db.Fonts or {};
  db.Settings      = db.Settings or {};

  Filter           = "none";
  PreviewText      = nil;
  PreviewSize      = 30;
  SandboxSize      = 30;
  Fonts            = {};

  ns.RP_Fonts.Fonts = Fonts;

  Stats = { now = time() };
  clearCounts();

  keys = {};

end;


local function recount()
  clearCounts();
  for _, font in pairs(Fonts) do font:Count() end;
end;
-- options -----------------------------------------------------------------------------------------------------------------------
--
local function registerOptions()
  AceConfigRegistry:RegisterOptionsTable(addOnName, options);
  AceConfig:RegisterOptionsTable( addOnName, options);
  AceConfigDialog:AddToBlizOptions(addOnName, rpFontsTitle);
end;

local function updateOptions() AceConfigRegistry:NotifyChange(addOnName); end;

local function newline(order) return { type = "description", name = "", width = "full", order = order }; end;

-- object methods

local flags  = 
{ font  = { "active", "loaded",   "inactive", "disabled", "new", "missing", "builtin" },
  addon = { "loaded", "disabled", "missing",  "builtin", }, 
  file  = { "loaded", "disabled", "missing" } 
};

--[[ Flag definitions:
            
     "active"   = not deactivated by the user; implies not("inactive"), not("missing")
     "inactive" = deactivated by the user; implies not("active")
     "loaded"   = the addon associated with the font file has been loaded into WoW
     "disabled" = is part of an addon that exists but is disabled; implies not("missing")
     "new"      = added since the last login; implies not("missing")
     "missing"  = is part of an addon that is no longer installed; implies, not("disabled"), not("new")
     "builtin"  = a built-in font; implies not("missing")

--]]

local objectTypes = { "font", "addon", "file" };

local methods =
{ 
  ["WhatAmI"] = function(self) return tContains(objectTypes, self.what) and self.what or nil end,
  ["GetData"] = function(self) return self.db end,
  ["GetName"] = function(self) return self.name end,

  ["SetFlag"] = 
    function(self, flag, value) 
      if value == nil then value = true end;
      if   flag and tContains(flags[ self:WhatAmI()], flag)
      then self.db.flags[flag] = value;
      end;
    end,

  ["HasFlag"] = "GetFlag",
  ["GetFlag"] = 
    function(self, flag)
      if flag and tContains(flags[ self:WhatAmI()], flag)
      then return self.db.flags[flag];
      end;
    end,

  ["ClearFlag"] =
    function(self, flag)
      if flag and tContains(flags[ self:WhatAmI()], flag)
      then self.db.flags[flag] = false;
      end;
    end,

  ["ColorName"] =
    function(self)
      local name = self.GetTitle and self:GetTitle() or self:GetName();
      local _, status = Fonts[self:GetFont()]:GetStatus();

      return status == "builtin"  and bluzzard(name, true  )
          or status == "missing"  and red(name,      true  )
          or status == "new"      and green(name,    false )
          or status == "disabled" and grey(name,     true  )
          or status == "active"   and yellow(name,   false )
          or status == "white"    and white(name,    false )
          or name;

    end,

  ["SetFont"] =
    function(self, font)
      if     self:WhatAmI() == "font" then self.font = self:GetName(); 
      elseif type(font)     == "table" 
        and  font.WhatAmI 
        and  font:WhatAmI() == "font" then self.font      =  font:GetName();
      elseif type(font)     == "string" 
        and Fonts[font]               then self.font      =  font;
      else   error("Invalid font: " .. type(font));
      end;
    end,

    ["InitData"] =
      function(self)
        local what = self:WhatAmI();
        local name = self:GetName();

        if not name then print("no name found") return end;

        if    what == "font"
        then db.Fonts[name]          = db.Fonts[name]        or {};
             db.Fonts[name].flags    = db.Fonts[name].flags  or {};
             db.Fonts[name].lists    = db.Fonts[name].lists  or {};
             db.Fonts[name].stamps   = db.Fonts[name].lists  or {};
             self.db                 = db.Fonts[name];
        elseif tContains(objectTypes, what)
        then local lists             = db.Fonts[self:GetFont()].lists
             lists[what]             = lists[what]             or {};
             lists[what][name]       = lists[what][name]       or {};
             lists[what][name].flags = lists[what][name].flags or {};
             self.db                 = lists[what][name];
        end;
        return self.db;
      end,

  ["GetFont"] = function(self) return self.font; end,

  addon =
    { 
      ["GetTitle"] = function(self) return GetAddOnMetadata(self:GetName(), "Title"); end,
    },
  font =
    { ["InitList"] =
        function(self, objType)

          if   type(objType) == "string" and tContains(objectTypes, objType)
          then self.lists             = self.lists             or {};
               self.lists[objType]    = self.lists[objType]    or {};
               self.db.lists          = self.db.lists          or {}
               self.db.lists[objType] = self.db.lists[objType] or {};
          end;
        end,
      ["GetTitle"] =
        function(self)
          if self:HasFlag("builtin") and LibSharedMedia:GetDefault("font") == self:GetName()
          then return self:GetName() .. " (LSM Default)"
          else return self:GetName()
          end
        end,

      ["HasItem"] = "GetItem",
      ["GetItem"] =
        function(self, objType, name)
          if   tContains(objectTypes, objType) 
           and self.lists[objType] 
           and self.lists[objType][name]
          then return self.lists[objType][name], self.db.lists[objType][name]
          else return nil, nil
          end
        end,

      ["AddItem"] = "SetItem",
      ["SetItem"] =
        function(self, objType, item)
          local name = item:GetName();
          if   tContains(objectTypes, objType) 
           and type(item) == "table" 
           and item.WhatAmI 
           and item:WhatAmI() == objType
          then self.lists[objType]        = self.lists[objType]        or {};
               self.lists[objType][name]  = item;
               local lists                = self.db.lists[objType]
               lists[objType]             = lists[objType]             or {};
               lists[objType][name]       = lists[objType][name]       or {};
               lists[objType][name].flags = lists[objType][name].flags or {};
               lists[objType][name].name  = lists[objType][name].name  or name;
          end;

        end,

      ["SetTimestamp"] =
        function(self, timeStamp)
          if  type(timeStamp) == "string"
          then self.db.stamps[timeStamp] = Stats.now; -- not the actual time()!
          end;
        end,
      ["GetTimestamp"] =
        function(self, timeStamp)
          if type(timeStamp) == "string" then return self.db.stamps[timeStamp]; end
        end,
      ["HasList"] = "GetList",
      ["GetList"] =
        function(self, objType)
          if   tContains(objectTypes, objType) and type(self.lists[objType]) == "table"
          then return self.lists[objType], self.db.lists[objType];
          end
        end,
    },
};

local function attachMethods(object, objType, font) 
  if tContains(objectTypes, objType)
  then object.what = objType
       for funcName, func in pairs(methods) 
       do  if type(func) == "function"
           then object[funcName] = func; 
           elseif type(func) == "string" and methods[func] and type(methods[func]) == "function"
           then object[funcName] = methods[func]
           end; 
       end;
       if font then object:SetFont(font) end;

       if type(methods[objType]) == "table"
       then for funcName, func in pairs(methods[objType]) 
            do  if     type(func) == "function"
                then   object[funcName] = func; 
                elseif type(func) == "string" and methods[objType][func] and type(methods[objType][func]) == "function"
                then   object[funcName] = methods[objType][func]
                end; 
            end;
       end;
  else error("Unknown object type " .. (objType or type(objType)));
  end;
end;

-- font object --------------------------------------------------------------------------------------------------------------------
local function makeFont(fontName, fontFile)
  if not fontName then return end;

  local font = Fonts[fontName] or {};
  font.name  = fontName;
  attachMethods(font, "font", font);
  local data = font:InitData();
  font:InitList("addon");
  font:InitList("file");

  function font.New(self, what, name)

    if name and tContains(objectTypes, what)
    then 

      local list = self:GetList(what)       or self:InitList(what) and {};
      local item = self:GetItem(what, name) or                         {};
      item.name  = name;

      attachMethods(item, what, self);
      self:AddItem(what, item);
      local data = item:InitData();

      return item

    end;

  end; 

  function font.NewAddon(self, name)
    local addon = self:New("addon", name);
   
    function addon.IsLoaded(self)
      if self.name == BUILTIN then return true end;
      local _, _, _, isLoadable, reason = GetAddOnInfo(self.name);
      self:SetFlag("loaded", isLoadable);
      if not isLoadable 
      then return false, reason; 
      else return true, nil; end;
    end;

    if name == BUILTIN then self:SetFlag("builtin", name == BUILTIN); end;

    return addon
  end;

  function font.NewFile(self, name)

    local file = self:New("file", name);

    function file.IsLoaded(self) return self.addon:IsLoaded(); end;

    function file.GetAddonFromPath(self) 
      return self.name:match("^[iI]nterface\\[aA]dd[oO]ns\\(.-)\\") or BUILTIN; 
    end;

    return file

  end;

  function font.GetAddons(self)       return self:GetList("addon")       end;
  function font.GetFiles( self)       return self:GetList("file")        end;
  function font.GetAddon( self, name) return self:GetItem("addon", name) end;
  function font.GetFile(  self, name) return self:GetItem("file",  name) end;

  function font.SetFlagsFromAddons(self)

    local any = {};

    if   self:GetAddons()
    then for name, addon in pairs(self:GetAddons())
         do  for _, flag in ipairs(flags.addon)
             do  if addon:GetFlag(flag) then any[flag] = true; end;
             end;
         end;

         if     any.builtin  then self:SetFlag("builtin", true  ); end;

         if     any.loaded   then self:SetFlag("loaded",   true );
                                  self:SetFlag("disabled", false);
                                  self:SetFlag("missing",  false);
     
         elseif any.disabled then self:SetFlag("loaded",   false);
                                  self:SetFlag("disabled", true );
                                  self:SetFlag("missing",  false);
     
         elseif any.missing  then self:SetFlag("loaded",   false);
                                  self:SetFlag("disabled", false);
                                  self:SetFlag("missing",  false);
         end;

         if   not self:GetFlag("active") and not self:GetFlag("inactive")
         then self:SetFlag("active") 
         end;

    end;

    if not self:GetTimestamp("FirstSeen") then self:SetTimestamp("FirstSeen"); end;
    self:SetTimestamp("LastSeen");
  end;
     
  function font.GetPrimaryFile(self)
    for  name, file in pairs( self:GetFiles() )
    do   if    file:HasFlag("loaded")
         then  return name, file
         end;
    end; 
    return nil, nil;
  end;

  function font.IsLoaded(self) return self:GetFlag("loaded") end;

  function font.Register(self)
    local fileName, _ = self:GetPrimaryFile()
    if    fileName 
    then  LibSharedMedia:Register("font", self:GetName(), fileName);
          self:SetFlag("loaded"); 
    end;
  end;

  function font.Deregister(self)
    if   self:GetName()
    then LibSharedMedia.MediaTable.font[self:GetName()] = nil 
         self:ClearFlag("loaded"); 
    end;
  end;
    
  function font.GetStatus(self)              -- returns true/false if it should be shown, and the primary status

    if     self:HasFlag( "missing"  ) then return false, "missing"
    elseif self:HasFlag( "builtin"  ) then return true,  "builtin"
    elseif self:HasFlag( "inactive" ) then return false, "inactive"
    elseif self:HasFlag( "disabled" ) and  not db.Settings.LoadDisabled 
                                      then return false, "disabled"
    elseif self:HasFlag( "new"      ) then return true,  "new"
    elseif self:HasFlag( "active"   ) then return true,  "active"
    elseif self:HasFlag( "loaded"   ) then return true,  "loaded"
    else                                   return false, "unknown"
    end
  end;

  function font.SetRegistrationStatus(self, status)
    status = (status ~= nil) and status or self:GetStatus();
    if status then self:Register() else self:Deregister() end;
    recount();
  end;

  function font.Count(self)
    local function incr(category) Stats[category] = Stats[category] + 1 end;
    local function have(category) return self:HasFlag(category) end;

    if   self:GetTimestamp("FirstSeen") == Stats.now 
    then self:SetFlag("new") 
    else self:ClearFlag("new");
    end;

    if have( "active"   )                           then incr( "active"         ) end;
    if have( "builtin"  )                           then incr( "builtin"        ) end;
    if have( "inactive" ) and not have( "missing" ) then incr( "inactive"       ) end;
    if have( "missing"  )                           then incr( "missing"        ) end;
    if have( "new"      )                           then incr( "new"            ) end;
    if have( "new"      ) and     have( "active"  ) then incr( "new_active"     ) end;
    if have( "builtin"  ) and     have( "active"  ) then incr( "builtin_active" ) end;

    incr("total");
  end;

  function font.FormatListForDisplay(self, what, delim)
    if tContains(objectTypes, what) and self:HasList(what)
    then local text = {};
         for _, item in pairs(self:GetList(what)) do table.insert(text, item:ColorName()); end;
         return table.concat(text, delim or ", ");
    end;
  end;

  function font.GetOptionsTableArgs(self)

    local function filter() return not (Filter == "none") and not self:HasFlag(Filter); end;

    local function browseFont()
      Browsing = self;
      db.Browsing = self:GetName();
      AceConfigDialog:SelectGroup(addOnName, "fontBrowser") 
    end

    local function disableToggle()
      local _, status = self:GetStatus()
      return (status == "missing") 
          or (status == "disabled" and not db.Options.LoadDisabled)
          or (LibSharedMedia:GetDefault("font") == self:GetName())
          or (LibSharedMedia:GetGlobal("font")  == self:GetName())
      ;
    end;

    local function changeRegistrationStatus(info, value)
      self:SetFlag("active", value);
      self:SetFlag("inactive", not value);
      self:SetRegistrationStatus(value);
    end;

    local name = self:GetName();

    local args = 
    { [name .. "_Active"]  =
        { type             = "toggle",
          name             = "",
          width            = col[1],
          get              = function() return self:HasFlag("active") end,
          set              = changeRegistrationStatus,
          disabled         = disableToggle,
          hidden           = filter,
        },

      [name .. "_Name"]    =
        { type             = "description",
          name             = function() return self:ColorName() end,
          width            = col[2],
          fontSize         = "medium",
          hidden           = filter,
        },

      [name .. "_AddOn"]   =
        { type             = "description",
          name             = function() return self:FormatListForDisplay("addon", ", ") end,
          width            = col[3],
          fontSize         = "medium",
          hidden           = filter,
        },

      [name .. "_Details"] =
        { type             = "execute",
          name             = "Details",
          desc             = "Click to view details about the font " .. self:ColorName() .. " in the font browser.",
          width            = col[4],
          func             = browseFont,
          hidden           = filter,
      },
    };

    table.insert(keys, font.name);

    return args;
  end;


  Fonts[fontName] = font;

  if   fontFile 
  then local file = font:NewFile(fontFile)
       local addon_name = file:GetAddonFromPath();

       local addon = font:NewAddon( addon_name);
       return font, file, addon;
  end;
       
  return font, data;
  
end;
  
-- -------------------------------------------------------------------------------------------------------------------------------
local function restoreSavedData()
  for fontName, data in pairs(db.Fonts)
  do  local font = makeFont(fontName);

      if   data and data.file 
      then for fileName, fileData in pairs(data.file)
           do  local file  = font:NewFile(fileName)
               local addon = font:NewAddon( file:GetAddonFromPath() );
           end;
      end;
  end;
end;

-- -------------------------------------------------------------------------------------------------------------------------------

-- purge -------------------------------------------------------------------------------
--
StaticPopupDialogs[POPUP] =
{
  button1 = YES,
  button2 = NO,
  hideOnEscape = 1,
  timeout = 60,
  whileDead = 1,
  OnCancel = function(self) notify("Purge cancelled.") end,
  OnHide   = function(self) notify("Purge cancelled.") end,
  OnShow   = 
    function(self) 
      self.text:SetJustifyH("LEFT"); 
      self.text:SetSpacing(3); 
    end,
};

local function scaryWarningMessage(fontState)

  return "This will permanently delete the records of " .. fontState .. " fonts from " .. 
         rpFontsTitle .. "'s records. It can't be undone. " ..
         "Your font files themselves won't be harmed." .. 
         "\n\nIf you load addons that register those fonts with LibSharedMedia, " ..
         rpFontsTitle .. " will create new records for them, as it will no longer " ..
         "have stored records telling it to deactivate or activate the fonts." ..
         "\n\nAre you |cffffff00sure|r this is what you want to do?";

end;

local function doPurge(flag)

  local num = 0;
  for name, font in pairs(Fonts)
  do  if flag == "all" or font:HasFlag(flag) then Fonts[name] = nil; num = num + 1; end;
  end;

  notify( (num > 0) and (num .. " font records deleted.") or "No font records deleted."); 
end;

local function purgeMissing()
  StaticPopupDialogs[POPUP].text = scaryWarningMessage(red("missing"));
  StaticPopupDialogs[POPUP].OnAccept = function() doPurge("missing") end;
  StaticPopup_Show(POPUP);  
end;

local function purgeDisabled()
  StaticPopupDialogs[POPUP].text = scaryWarningMessage(grey("disabled"));
  StaticPopupDialogs[POPUP].OnAccept = function() doPurge("disabled") end;
  StaticPopup_Show(POPUP);  
end;

local function purgeEverything()
  StaticPopupDialogs[POPUP].text = scaryWarningMessage(yellow("all"));
  StaticPopupDialogs[POPUP].OnAccept = function() doPurge("all") end;
  StaticPopup_Show(POPUP);  
end;

local function generateHashTable()
  local list = {};
  for fontName, font in pairs(Fonts) do list[fontName] = font:GetName(); end;
  return list
end;

-- --------------------------------------------------------------------------------------------------------------------------------------
local function applyLoadDisabled(info, value)
  db.Settings.LoadDisabled = value;
  for _, font in pairs(Fonts) do if font:HasFlag("disabled") then font:SetRegistrationStatus() end; end;
end;

-- browser ----------------------------------------------------------------------------------------------------------------------------
--
local function buildFontBrowser()

  local fontBrowser       =
  { name                  = "Font Browser",
    type                  = "group",
    order                 = 2000,

    args                  =
    {
      selector            =
      { type              = "select",
        width             = 2,
        name              = function() return Browsing and Browsing:GetName() or db.Browsing or "" end,
        order             = 2100,
        values            = generateHashTable,
        get               = function() return Browsing and Browsing:GetName() or db.Browsing or "Morpheus" end,
        set               = function(info, value) Browsing = Fonts[value] end,
      },

      spacer              = { type = "description", width = 0.1, name = " ", order = 2101, },

      hidePreview         =
      { type              = "toggle",
        width             = 0.75,
        name              = "Hide Preview",
        order             = 2102,
        get               = function() return db.Settings.HidePreview             end,
        set               = function(info, value) db.Settings.HidePreview = value end,
        desc              = "Choose whether to show or hide the text preview.",
      },

      previewBox          =
      { type              = "group",
        inline            = true,
        name              = "Font Preview",
        order             = 2220,
        hidden            = function() return db.Settings.HidePreview end,
        args              =
        { previewSize     =
          { type          = "range",
            min           = 1,
            softMin       = 6,
            max           = 128,
            softMax       = 60,
            order         = 2150,
            step          = 1,
            width         = "full",
            name          = "Preview Size",
            get           = function() return PreviewSize end,
            set           = function(info, value) PreviewSize = value end,
            desc          = "Set the size of the font preview text.",
          },
          preview         =
          { type          = "input",
            width         = "full",
            dialogControl = "RPF_FontPreviewEditBox",
            get           = function() return PreviewText or (Browsing and Browsing:GetName() or db.Browsing) or "" end,
            set           = function(info, value) PreviewText = value end,
            name          = function() return Browsing and Browsing:GetName() or db.Browsing or "Morpheus" end,
            order         = 2175,
            desc          = "Click to set custom sample text to display.",
          },
        },
      },

      buttonBar           =
      { type              = "group",
        name              = "",
        inline            = true,
        order             = 2300,
        args              =
        { inactive        =
          { type          = "execute",
            order         = 2301,
            hidden        = function() return Browsing and Browsing:HasFlag("inactive") end,
            name          = "Set Inactive",
            width         = 0.75,
            func          = function() Browsing:SetRegistrationStatus(false) end,
          },
          active          =
          { type          = "execute",
            order         = 2302,
            hidden        = function() return Browsing and Browsing:HasFlag("active") end,
            name          = "Set Active",
            width         = 0.75,
            func          = function() Browsing:SetRegistrationStatus(true) end,
          },
          deleteRecord    =
          { type          = "execute",
            order         = 2303,
            name          = "Delete",
            width         = 0.75,
            func          = function() notify("Why you wanna delete this??") end,
          },
        },
      },

      source              =
      { type              = "group",
        name              = "Source",
        order             = 2400,
        inline            = true,
        args              =

        { fontAddOnLeft   =
          { type          = "description",
            name          = yellow("Source Addon(s)"),
            order         = 2401,
            width         = 1,
            fontSize      = "medium",
          },

          fontAddOnRight  =
          { type          = "description",
            name          = function() return Browsing and Browsing:FormatListForDisplay("addon", "\n") or "" end,
            order         = 2402,
            width         = 2,
            fontSize      = "medium",
          },

          -- newline         = newline(2403),

          fontFileLeft    =
          { type          = "description",
            name          = yellow("File Location(s):"),
            order         = 2501,
            width         = 1,
            fontSize      = "medium",
          },

          fontFileRight   =
          { type          = "description",
            name          = function() return Browsing and Browsing:FormatListForDisplay("file", "\n") or "" end,
            order         = 2502,
            width         = 2,
            fontSize      = "small",
          },
          -- newline2        = newline(2503),
         
          firstSeenLeft   =
          { type          = "description",
            name          = yellow("Date Installed"),
            order         = 2550,
            width         = 1,
            fontSize      = "medium",
            hidden        = function() return Browsing and not(Browsing:GetTimestamp("FirstSeen"))  end,
          },

          firstSeenRight  = 
          { type          = "description",
            name          = function() 
                              return 
                                Browsing 
                                and Browsing:GetTimestamp("FirstSeen")
                                and white(date( "%c", Browsing:GetTimestamp("FirstSeen"))) or "" 
                              end,
            order         = 2551,
            width         = 2,
            fontSize      = "medium",
            hidden        = function() return Browsing and not(Browsing:GetTimestamp("FirstSeen")) end,
          },

       -- firstSeenBlank  =
       -- { type          = "description",
         -- name          = " ",
         -- order         = 2555,
         -- width         = "full",
         -- fontSize      = "small",
         -- hidden        = function() return Browsing and not(Browsing:GetTimestamp("FirstSeen")) end,
       -- },

          lastSeenLeft   =
          { type          = "description",
            name          = yellow("Last Loaded in LSM"),
            order         = 2580,
            width         = 1,
            fontSize      = "medium",
            hidden        = function() return Browsing and not(Browsing:GetTimestamp("LastSeen")) end,
          },

          lastSeenRight  = 
          { type          = "description",
            name          = function() 
                              return 
                                Browsing 
                                and Browsing:GetTimestamp("LastSeen")
                                and white(date( "%c", Browsing:GetTimestamp("LastSeen"))) or "" 
                            end,
            order         = 2581,
            width         = 2,
            fontSize      = "medium",
            hidden        = function() return Browsing and not(Browsing:GetTimestamp("LastSeen")) end,
          },

       -- lastSeenBlank  =
       -- { type          = "description",
         -- name          = " ",
         -- order         = 2585,
         -- width         = "full",
         -- fontSize      = "small",
         -- hidden        = function() return Browsing and not(Browsing:GetTimestamp("LastSeen")) end,
       -- },


        },
      },

    },
  };

  options.args.fontBrowser = fontBrowser;
end;

-- font list -----------------------------------------------------------------------------------------------------------------------------

local function buildDataTable()

  local function showCurrentFilter() if not Filter or Filter == "none" then return "All Fonts" else return filters[Filter] end end;

  local dataTable      =
  { name               = "Font List",
    type               = "group",
    order              = 700,
  };

  local args           =
  { headline           =
    { type             = "description",
      name             = showCurrentFilter,
      width            = col[1] + col[2],
      order            = 900,
      fontSize         = "large";
    },

    filters            =
    { type             = "select",
      values           = filters,
      name             = "",
      width            = col[3],
      order            = 910,
      sorting          = filter_order,
      get              = function() return Filter or "" end,
      set              = function(info, value) Filter = value end,
    },

    filtersDescription =
    { type             = "description",
      fontSize         = "small",
      name             = function() return filter_desc[Filter] end,
      order            = 920,
      width            = col[1] + col[2],
      hidden           = function() return Filter == "" end,
    },

    filtersNewline     = newline(999),

    columnActive       =
    { type             = "description",
      name             = "",
      width            = col[1],
      order            = 1001,
    },

    columnName         =
    { type             = "description",
      name             = "|cffffff00Font Name|r",
      width            = col[2],
      order            = 1002,
      fontSize         = "medium",
    },

    columnAddOn        =
    { type             = "description",
      name             = "|cffffff00Source AddOn(s)|r",
      width            = col[3],
      order            = 1003,
      fontSize         = "medium",
    },

    columnNewline      = newline(1005),
  };

  if   Fonts 
  then for fontName, font in pairs(Fonts) 
       do  local font_args = font:GetOptionsTableArgs()
           for k, v in pairs(font_args) do args[k] = v end;
       end;
  end;

  -- second pass, for displaying in order:
  table.sort(keys);

  for i, key in ipairs(keys)
  do args[key .. "_Active"   ].order = 1000 + i * 10 + 1;
     args[key .. "_Name"     ].order = 1000 + i * 10 + 2;
     args[key .. "_AddOn"    ].order = 1000 + i * 10 + 3;
     args[key .. "_Details"  ].order = 1000 + i * 10 + 4;
  end;

  dataTable.args = args;

  options.args.dataTable = dataTable;

end;


-- LSM panel ---------------------------------------------------------------------------------------------------------------------------
local function buildLibSharedMediaPanel()

  local function countLSM()
    local num = 0; for _, _ in pairs(LibSharedMedia:HashTable("font")) do num = num + 1; end; return num;
  end;

  options.args.libSharedMedia =
  { name                      = "LibSharedMedia",
    type                      = "group",
    order                     = 8000,
    args                      =
    { headline                =
      { type                  = "description",
        fontSize              = "large",
        order                 = 8001,
        name                  = "LibSharedMedia Status\n\n",
        width                 = "full",
      },
      countLeft               =
      { type                  = "description",
        fontSize              = "medium",
        order                 = 8002,
        width                 = 1,
        name                  = white("Fonts Loaded"),
      },
      countRight              =
      { type                  = "description",
        fontSize              = "medium",
        order                 = 8003,
        width                 = 2,
        name                  = yellow(countLSM() .. " fonts")
      },
      defaultFontLeft         =
      { type                  = "description",
        fontSize              = "medium",
        order                 = 8101,
        width                 = 1,
        name                  = "Current Default Font",
      },
      defaultFontRight        =
      { type                  = "description",
        fontSize              = "medium",
        order                 = 8102,
        width                 = 2,
        name                  = function() return yellow(LibSharedMedia:GetDefault("font") or "none") end,
      },
      globalOverrideLeft      =
      { type                  = "description",
        fontSize              = "medium",
        order                 = 8201,
        width                 = 1,
        name                  = white("Current Global Override"),
      },
      globalOverrideRight     =
      { type                  = "description",
        fontSize              = "medium",
        name                  = function() return yellow(LibSharedMedia:GetGlobal("font") or "none") end,
        fontSize              = "medium",
        order                 = 8202,
        width                 = 2
      },
      testingSandbox          =
      { type                  = "group",
        inline                = true,
        name                  = "Sandbox",
        order                 = 8500,
        args                  =
        { fontSelector        =

          { type              = "select",
            values            = function() return LibSharedMedia:HashTable("font") end,
            dialogControl     = "LSM30_Font",
            name              = "Test Widget",
            order             = 8200,
            width             = 2,
            get               = function() 
                                  return SandboxFont and SandboxFont:GetName() 
                                      or LibSharedMedia:GetDefault("font") 
                                end,
            set               = function(info, value) SandboxFont = Fonts[value] end,
            desc              = "This doesn't really do anything, but it's here in case you " ..  
                                "need to confirm whether fonts were added to or removed from " ..  
                                "LibSharedMedia. Or you can just look at the fonts."
          },

          fontSize            =
          { type              = "range",
            min               = 1,
            softMin           = 6,
            max               = 128,
            softMax           = 60,
            order             = 8201,
            step              = 1,
            width             = 1,
            name              = "Sandbox Text Size",
            get               = function() return PreviewSize end,
            set               = function(info, value) PreviewSize = value end,
            desc              = "Set the size of the font preview text.",
          },

          previewBox          = 
          { type              = "input",
            width             = "full",
            dialogControl     = "RPF_FontPreviewEditBox",
            get               = function() 
                                  return SandboxText 
                                      or (SandboxFont and SandboxFont:GetName()) 
                                      or LibSharedMedia:GetDefault("font") 
                                end,
            set               = function(info, value) SandboxText = value end,
            name              = function() 
                                  return (SandboxFont and SandboxFont:GetName())
                                      or LibSharedMedia:GetDefault("font") 
                                  end, 
            order             = 8202,
            desc              = "Click to set custom sample text to display.",
          },
        },
      },
    },
  };
end;

-- settings --------------------------------------------------------------------------------------------------------------------------
local function buildSettingsPanel()

  options.args.settings = 
  { name                = "Settings",
    type                = "group",
    order               = 9000,
    args                =
    {
      headline          =
      { type            = "description",
        name            = rpFontsTitle .. " Settings\n\n",
        order           = 9001, -- it's over 9000
        width           = "full",
        fontSize        = "large",
      },

      loadDisabledFonts =
      { type            = "toggle",
        name            = "Load fonts from disabled addons",
        desc            = "If " .. rpFontsTitle .. " has recorded a font from another addon and " ..  
                          "the addon is still installed, it can load the font even if the addon itself is disabled.",
        get             = function() return db.Settings.LoadDisabled end,
        set             = applyLoadDisabled,
        order           = 9002,
        width           = "full",
      },
      resetAllLeft      =
      { type            = "execute",
        name            = "Clear all font records",
        order           = 9021,
        width           = 1,
        func            = purgeEverything,
      },
      resetAllMiddle    =
      { type            = "description",
        name            = " ",
        order           = 9022,
        width           = 0.2,
      },
      resetAllRight     =
      { type            = "description",
        name            = white("You can reset all font information stored by " .. rpFontsTitle),
        order           = 9023,
        width           = 2,
        fontSize        = "medium",
      },

      blank0            = newline(9024),

      creditsHeadline   =
      { type            = "description",
        name            = "\n" .. rpFontsTitle .. " Credits\n\n",
        order           = 9100,
        width           = "full",
        fontSize        = "large",
      },

      creditsLeft       = 
      { type            = "description",
        name            = yellow("Created By"),
        order           = 9101,
        width           = 1,
        fontSize        = "medium",
      },

      creditsRight      =

      { type            = "description",
        name            = "|cffff00ffOraibi-MoonGuard|r",
        order           = 9102,
        width           = 2,
        fontSize        = "medium",
      },

      blank1            = newline(9103),
      rpTagsLeft        = 
      { type            = "description",
        name            = white("rp|cffdd33aaTags|r Download"),
        order           = 9151,
        width           = 1,
        fontSize        = "medium",
      },
      rpTagsRight       =
      { type            = "input",
        width           = 2,
        order           = 9152,
        name            = "",
        get             = function() return "http://spindrift.games/rptags" end,
      },

      blank2            = newline(9153),
      libsLeft          =
      { type            = "description",
        name            = yellow("Libraries Used"),
        order           = 9200,
        width           = 1,
        fontSize        = "medium",
      },

      libsRight         = 
      { type            = "description",
        name            = table.concat( 
                            { yellow("LibSharedMedia"), white("Ace3"),
                              green("AceGUI-SharedMediaWidgets") },
                            ", "),
        order           = 9202,
        width           = 2,
        fontSize        = "medium",
      },

      blank3            = newline(9203),

      fontsLeft         =
      { type            = "description",
        name            = yellow("Included Fonts"),
        order           = 9400,
        width           = 1,
        fontSize        = "medium",
      },
      fontsToggle       = 
      { type            = "toggle",
        name            = "View font list",
        order           = 9401,
        width           = 2,
        get             = function() return ViewFontList end,
        set             = function(info, value) ViewFontList = value end,
      },

      fontsFull         = 
      { type            = "group",
        name            = "Included Fonts",
        order           = 9402,
        inline          = true,
        hidden          = function() return not ViewFontList end,
        args            =
        { text = 
          { type        = "description",
            name        = listOfIncludedFonts,
            order       = 9403,
            width       = "full", 
            fontSize    = "medium",
          },
        },
      },
      blank4            = newline(9404),

      oflLeft           =
      { type            = "description",
        name            = yellow("Open Font License 1.1"),
        order           = 9500,
        width           = 1,
        fontSize        = "medium",
      },

      oflToggle         = 
      { type            = "toggle",
        name            = "View font license",
        order           = 9502,
        width           = 2,
        get             = function() return ViewLicense end,
        set             = function(info, value) ViewLicense = value end,
      },

      oflFull           =
      { type            = "group",
        name            = "Open Font License, Version 1.1",
        order           = 9550,
        inline          = true,
        hidden          = function() return not ViewLicense end,
        args            =
        { text          =
          { type        = "description",
            name        = openFontLicense,
            fontSize    = "small",
            width       = "full",
          },
        },
      },
    },
  };

end;

-- core options ---------------------------------------------------------------------------------------------------------------------
local function buildCoreOptions()

  options                      =
  { type                       = "group",
    name                       = rpFontsTitle,
    order                      = 1,
    childGroups                = "tab",
    args                       =
    { blurb                    =
      { type                   = "description",
        name                   = rpFontsDesc,
        width                  = "full",
        order                  = 2,
        fontSize               = "medium"
      },

      newline                  =
      { type                   = "description",
        name                   = " ",
        width                  = "full",
        order                  = 3,
        fontSize               = "medium",
      },

      Stats                    =
      { type                   = "group",
        name                   = "Status (v. " .. rpFontsVersion .. ")",
        inline                 = true,
        order                  = 4,
        args                   =
        {
          StatsTotalLeft       =
          { type               = "description",
            name               = white("Total Fonts"),
            width              = 1,
            order              = 104,
            fontSize           = "medium",
          },

          StatsTotalRight      =
          { type               = "description",
            name               = function() return white(Stats.total .. " known")    end,
            width              = 1,
            order              = 105,
            fontSize           = "medium",
          },

          StatsTotalNewline    =
          { type               = "description",
            name               = "",
            width              = "full",
            order              = 106,
            fontSize           = "small",
          },

          StatsNewLeft         =
          { type               = "description",
            name               = green("New Fonts"),
            width              = 1,
            order              = 201,
            fontSize           = "medium",
            hidden             = function() return (Stats.new == 0)                   end,
          },

          StatsNewRight        =
          { type               = "description",
            name               = function() 
                                   return 
                                     white(Stats.new .. " (" ..
                                     yellow(Stats.new_active .. " active") ..
                                     ", " .. (Stats.new - Stats.new_active) .. " inactive)")
                                 end,
            width              = 2,
            order              = 203,
            fontSize           = "medium",
            hidden             = function() return (Stats.new == 0) end,
          },
                                         
          StatsNewNewline      =
          { type               = "description",
            name               = "",
            width              = "full",
            order              = 204,
            fontSize           = "small",
            hidden             = function() return (Stats.new == 0)                   end,
          },

          StatsActiveLeft      =
          { type               = "description",
            name               = yellow("Active Fonts"),
            width              = 1,
            order              = 301,
            fontSize           = "medium",
            hidden             = function() return (Stats.active == 0)                end,
          },

          StatsActiveRight     =
          { type               = "description",
            name               = function() return white(Stats.active .. " fonts")   end,
            width              = 1,
            order              = 302,
            fontSize           = "medium",
            hidden             = function() return (Stats.active == 0)                end,
          },

          StatsActiveNewline   =
          { type               = "description",
            name               = "",
            width              = "full",
            order              = 303,
            fontSize           = "small",
            hidden             = function() return (Stats.active == 0)                end,
          },

          StatsInactiveLeft    =
          { type               = "description",
            name               = white("Inactive Fonts"),
            width              = 1,
            order              = 401,
            fontSize           = "medium",
            hidden             = function() return (Stats.inactive == 0)              end,
          },

          StatsInactiveRight   =
          { type               = "description",
            name               = function() return white(Stats.inactive .. " fonts") end,
            width              = 1,
            order              = 402,
            fontSize           = "medium",
            hidden             = function() return (Stats.inactive == 0)              end,
          },

          StatsInactiveNewline =
          { type               = "description",
            name               = "",
            width              = "full",
            order              = 403,
            fontSize           = "small",
            hidden             = function() return (Stats.inactive == 0)              end,
          },

          StatsBuiltinLeft     =
          { type               = "description",
            name               = bluzzard("Built-In Fonts"),
            width              = 1,
            order              = 451,
            fontSize           = "medium",
            hidden             = function() return (Stats.builtin == 0) end,
          },
          StatsBuiltinRight    =
          { type               = "description",
            name               = function() 
                                   return 
                                     white(Stats.builtin .. " (" ..
                                     yellow(Stats.builtin_active .. " active") ..
                                     ", " .. (Stats.builtin - Stats.builtin_active) .. " inactive)")
                                 end,
            width              = 2,
            order              = 452,
            fontSize           = "medium",
            hidden             = function() return (Stats.builtin == 0) end,
          },
                                         
          StatsBuiltinNewline  =
          { type               = "description",
            name               = "",
            width              = "full",
            order              = 453,
            fontSize           = "small",
            hidden             = function() return (Stats.builtin == 0)              end,
          },
          StatsDisabledLeft    =
          { type               = "description",
            name               = grey("Disabled Fonts"),
            width              = 1,
            order              = 501,
            fontSize           = "medium",
            hidden             = function() return (Stats.disabled == 0)              end,
          },

          StatsDisabledRight   =
          { type               = "description",
            name               = function() return white(Stats.disabled .. " fonts") end,
            width              = 1,
            order              = 502,
            fontSize           = "medium",
            hidden             = function() return (Stats.disabled == 0)              end,
          },

          StatsDisabledPurge   =
          { type               = "execute",
            name               = "Purge",
            width              = 0.5,
            order              = 503,
            hidden             = function() return (Stats.disabled == 0)              end,
            func               = purgeDisabled,
          },

          StatsDisabledNewline =
          { type               = "description",
            name               = "",
            width              = "full",
            order              = 504,
            fontSize           = "small",
            hidden             = function() return (Stats.disabled == 0)              end,
          },

          StatsMissingLeft     =
          { type               = "description",
            name               = red("Missing Fonts"),
            width              = 1,
            order              = 601,
            fontSize           = "medium",
            hidden             = function() return (Stats.missing == 0)               end,
          },

          StatsMissingRight    =
          { type               = "description",
            name               = function() return white(Stats.missing .. " fonts")  end,
            width              = 1,
            order              = 602,
            fontSize           = "medium",
            hidden             = function() return (Stats.missing == 0)               end,
          },

          StatsMissingNewline  =
          { type               = "description",
            name               = "",
            width              = "full",
            order              = 603,
            fontSize           = "small",
            hidden             = function() return (Stats.missing == 0)               end,
          },

          StatsMissingPurge    =
          { type               = "execute",
            name               = "Purge",
            width              = 0.5,
            order              = 503,
            hidden             = function() return (Stats.missing == 0)               end,
            func               = purgeMissing,
          },
        },
      },
    },
  };
end;

-- top-level functions -----------------------------------------------------------------------------------------------------------------

local function createOptionsTable()

  buildCoreOptions();
  buildDataTable()
  buildFontBrowser()
  buildSettingsPanel()
  buildLibSharedMediaPanel()
  registerOptions();

end;

local function scanForFonts()

  -- Get existing fonts from LSM, store them in our master list
  for fontName, fontFile in pairs(LibSharedMedia:HashTable("font"))
  do  local font, addon, file = makeFont(fontName, fontFile)
      addon:SetFlag( "loaded" );
      file:SetFlag(  "loaded" );
  end;

end;

local function applyCachedData()
  --[[ load any data that we had cached prior to the DB loading
     
       At present, only two types of data can be pre-cached: a default 
       active flag (true/false), and a license structure
  --]]
  --
  local function foundFont(font, fontName, cachedData)

    if   cachedData.active ~= nil 
     and font:GetFlag("inactive") == nil 
     and font:GetFlag("active") == nil
    then font:SetFlag("active", cachedData.active);
         font:SetFlag("inactive", not cachedData.active);
    end;

    if   cachedData.license and cachedData.license.what == "license" and font.license == nil
    then font.license = CopyTable(cachedData.license)
    end;
  end;
     
  if  not ns.RP_Fonts.tmp then return end;
  for fontName, fontData in pairs(ns.RP_Fonts.tmp)
  do  if Fonts[fontName] then foundFont(Fonts[fontName], fontName, fontData) end;
  end;

end;

local function registerSlashCommand()

  _G[ "SLASH_RPFONTS1"  ] = "/rpfonts";
  _G[ "SLASH_RPFONTS2"  ] = "/rpfont";
  SlashCmdList["RPFONTS"] = function() Interface:Show(); Interface_Open(rpFontsTitle); end;

end;

local function markDatabaseInitialized() db.initialized = true; end;


local function cycleThroughFonts()
  clearCounts();
  for fontName, font in pairs(Fonts)
  do  
      font:SetFlagsFromAddons();
      font:SetRegistrationStatus();
      font:Count();
  end;
end;

local function initializationDone()
  local LSM_Default = LibSharedMedia:GetDefault("font");
  if    LSM_Default and Fonts[LSM_Default]:HasFlag("inactive") 
  then  Fonts[LSM_Default]:SetFlag("active");
        Fonts[LSM_Default]:ClearFlag("inactive");
        Fonts[LSM_Default]:SetRegistrationStatus(true)
  end;

  local LSM_Global = LibSharedMedia:GetGlobal("font");
  if    LSM_Global and Fonts[LSM_Global]:HasFlag("inactive") 
  then  Fonts[LSM_Global]:SetFlag("active");
        Fonts[LSM_Global]:ClearFlag("inactive");
        Fonts[LSM_Global]:SetRegistrationStatus(true)
  end;

  Browsing = Fonts[db.Browsing] or Fonts[LSM_Default];
  SandboxFont = Fonts[LSM_Default];
end;

-- main --------------------------------------------------------------------------------------------------------------------------------
--
local function main()
  restoreSavedData();
  scanForFonts();
  applyCachedData();
  cycleThroughFonts();
  initializationDone();
  createOptionsTable();
  registerSlashCommand();
end;

local waitingFrame = CreateFrame("Frame");
      waitingFrame:RegisterEvent("ADDON_LOADED");
      waitingFrame:RegisterEvent("PLAYER_ENTERING_WORLD");

waitingFrame:SetScript("OnEvent", 
  function(self, event, addOnLoaded, ...)
    if     event == "ADDON_LOADED"          and addOnLoaded == addOnName then initializeDatabase();
    elseif event == "PLAYER_ENTERING_WORLD"                              then main();
    end;
  end
);

--[[-----------------------------------------------------------------------------
this section based on: EditBox Widget from AceGUI
-------------------------------------------------------------------------------]]
local widgetType, widgetVersion = "RPF_FontPreviewEditBox", 1

-- Lua APIs
local tostring, pairs = tostring, pairs

-- WoW APIs
local PlaySound = PlaySound
local GetCursorInfo, ClearCursor, GetSpellInfo = GetCursorInfo, ClearCursor, GetSpellInfo
local CreateFrame, UIParent = CreateFrame, UIParent

-- Global vars/functions that we don't upvalue since they might get hooked, or upgraded
-- List them here for Mikk's FindGlobals script
-- GLOBALS: AceGUIEditBoxInsertLink, ChatFontNormal, OKAY

--[[-----------------------------------------------------------------------------
Support functions
-------------------------------------------------------------------------------]]
if not AceGUIEditBoxInsertLink then
        -- upgradeable hook
        hooksecurefunc("ChatEdit_InsertLink", 
          function(...) return _G.AceGUIEditBoxInsertLink(...) end)
end

function _G.AceGUIEditBoxInsertLink(text)
        for i = 1, AceGUI:GetWidgetCount(widgetType) do
                local editbox = _G["AceGUI-3.0EditBox"..i]
                if editbox and editbox:IsVisible() and editbox:HasFocus() then
                        editbox:Insert(text)
                        return true
                end
        end
end

local function ShowButton(self) if not self.disablebutton then self.button:Show() self.editbox:SetTextInsets(0, 20, 3, 3) end end
local function HideButton(self) self.button:Hide() self.editbox:SetTextInsets(0, 0, 3, 3) end

--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]
local function Control_OnEnter(frame) frame.obj:Fire("OnEnter") end
local function Control_OnLeave(frame) frame.obj:Fire("OnLeave") end
local function Frame_OnShowFocus(frame) frame.obj.editbox:SetFocus() frame:SetScript("OnShow", nil) end
local function EditBox_OnEscapePressed(frame) AceGUI:ClearFocus() end

local function EditBox_OnEnterPressed(frame)
        local self = frame.obj
        local value = frame:GetText()
        local cancel = self:Fire("OnEnterPressed", value)
        if not cancel then PlaySound(856) HideButton(self) end
end

local function EditBox_OnReceiveDrag(frame)
        local self = frame.obj
        local type, id, info = GetCursorInfo()
        local name
        if type == "item" then name = info
        elseif type == "spell" then name = GetSpellInfo(id, info)
        elseif type == "macro" then name = GetMacroInfo(id)
        end
        if name then
                self:SetText(name)
                self:Fire("OnEnterPressed", name)
                ClearCursor()
                HideButton(self)
                AceGUI:ClearFocus()
        end
end

local function EditBox_OnTextChanged(frame)
        local self = frame.obj
        local value = frame:GetText()
        if tostring(value) ~= tostring(self.lasttext) then
                self:Fire("OnTextChanged", value)
                self.lasttext = value
                ShowButton(self)
        end
end

local function EditBox_OnFocusGained(frame) AceGUI:SetFocus(frame.obj) end
local function Button_OnClick(frame) local editbox = frame.obj.editbox editbox:ClearFocus() EditBox_OnEnterPressed(editbox) end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
        ["OnAcquire"] = function(self)
                -- height is controlled by SetLabel
                self:SetWidth(200)
                self:SetDisabled(false)
                self:SetLabel()
                self:SetText()
                self:DisableButton(false)
                self:SetMaxLetters(0)
        end,

        ["OnRelease"] = function(self) self:ClearFocus() end,

        ["SetDisabled"] = function(self, disabled)
                self.disabled = disabled
                if disabled then
                        self.editbox:EnableMouse(false)
                        self.editbox:ClearFocus()
                        self.editbox:SetTextColor(0.5,0.5,0.5)
                        self.label:SetTextColor(0.5,0.5,0.5)
                else
                        self.editbox:EnableMouse(true)
                        self.editbox:SetTextColor(1,1,1)
                        self.label:SetTextColor(1,.82,0)
                end
        end,

        ["SetText"] = function(self, text)
                self.lasttext = text or ""
                self.editbox:SetText(text or "")
                self.editbox:SetCursorPosition(0)
                HideButton(self)
        end,

        ["GetText"] = function(self, text) return self.editbox:GetText() end,

        ["SetLabel"] = 
          function(self, text)
            self.label:SetText("")
            self.label:Hide()
            self.editbox:SetPoint("TOPLEFT",self.frame,"TOPLEFT",7,0)
            self.alignoffset = 12
            local file, _, _ = GameFontNormal:GetFont();
        
            if   text and Fonts[text] 
            then local fileName, _ = Fonts[text]:GetPrimaryFile();
                 file = fileName;
            end;
            self.editbox:SetFont(file, PreviewSize);
            self:SetHeight(math.max(60, PreviewSize + 10));
        end,

        ["DisableButton"] = function(self, disabled) self.disablebutton = disabled if disabled then HideButton(self) end end,
        ["SetMaxLetters"] = function(self, num) self.editbox:SetMaxLetters(num or 0) end,
        ["ClearFocus"   ] = function(self) self.editbox:ClearFocus() self.frame:SetScript("OnShow", nil) end,

        ["SetFocus"] = function(self)
                self.editbox:SetFocus()
                if not self.frame:IsShown() then self.frame:SetScript("OnShow", Frame_OnShowFocus) end
        end,

        ["HighlightText"] = function(self, from, to) self.editbox:HighlightText(from, to) end
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local function Constructor()
        local num  = AceGUI:GetNextWidgetNum(widgetType)
        local frame = CreateFrame("Frame", nil, UIParent)
        frame:Hide()

        local editbox = CreateFrame("EditBox", "AceGUI-3.0EditBox"..num, frame, "InputBoxTemplate")
        editbox:SetAutoFocus(false)

        editbox:SetFontObject(ChatFontNormal)
        editbox:SetScript("OnEnter", Control_OnEnter)
        editbox:SetScript("OnLeave", Control_OnLeave)
        editbox:SetScript("OnEscapePressed", EditBox_OnEscapePressed)
        editbox:SetScript("OnEnterPressed", EditBox_OnEnterPressed)
        editbox:SetScript("OnTextChanged", EditBox_OnTextChanged)
        editbox:SetScript("OnReceiveDrag", EditBox_OnReceiveDrag)
        editbox:SetScript("OnMouseDown", EditBox_OnReceiveDrag)
        editbox:SetScript("OnEditFocusGained", EditBox_OnFocusGained)
        editbox:SetTextInsets(0, 0, 3, 3)
        editbox:SetMaxLetters(256)
        editbox:SetPoint("BOTTOMLEFT", 6, 0)
        editbox:SetPoint("BOTTOMRIGHT")
        editbox:SetHeight(50);
        editbox.Left:SetVertexColor(1, 1, 1, 0);    -- make the backdrops transparent
        editbox.Right:SetVertexColor(1, 1, 1, 0);
        editbox.Middle:SetVertexColor(1, 1, 1, 0);

        local label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        label:SetPoint("TOPLEFT", 0, -2)
        label:SetPoint("TOPRIGHT", 0, -2)
        label:SetJustifyH("LEFT")
        label:SetHeight(18)

        local button = CreateFrame("Button", nil, editbox, "UIPanelButtonTemplate")
        button:SetWidth(40)
        button:SetHeight(20)
        button:SetPoint("RIGHT", -2, 0)
        button:SetText(OKAY)
        button:SetScript("OnClick", Button_OnClick)
        button:Hide()

        local widget = {
                alignoffset = 30,
                editbox     = editbox,
                label       = label,
                button      = button,
                frame       = frame,
                type        = widgetType
        }
        for method, func in pairs(methods) do widget[method] = func end
        editbox.obj, button.obj = widget, widget
        return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(widgetType, Constructor, widgetVersion)
