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
local baseFontDir       = "Interface\\AddOns\\" .. addOnName .. "\\Fonts\\";
local newFontsFound     = 0;
local failsafeThreshold = 50;

local rpFontsFrame = CreateFrame("Frame");
      rpFontsFrame:RegisterEvent("ADDON_LOADED");
      rpFontsFrame:RegisterEvent("PLAYER_ENTERING_WORLD");

local listOfIncludedFonts = [===[
|cff00ffffAmarante|r
Copyright (c) 2012 by Sorkin Type Co (www.sorkintype.com), with Reserved Font Name "Amarante".

|cff00ffffAlmendra Display|r
Copyright (c) 2011-2012, Ana Sanfelippo (anasanfe@gmail.com), with Reserved Font Name 'Almendra'

|cff00ffffArima Madruai|r
Copyright 2015 The Arima Project Authors (info@ndiscovered.com)

|cff00ffffBarlow Condensed|r
Copyright 2017 The Barlow Project Authors (https://github.com/jpt/barlow)

|cff00ffffBellefair|r
Copyright 2015 The Bellefair Project Authors (https://github.com/shinntype/bellefair)

|cff00ffffBerkshire Swash|r
Copyright (c) 2012 by Brian J. Bonislawsky DBA Astigmatic (AOETI) (astigma@astigmatic.com), with Reserved Font Names "Berkshire Swash"

|cff00ffffBig Shoulders Stencil Display|r
Copyright 2019 The Big Shoulders Project Authors (https://github.com/xotypeco/big_shoulders)

|cff00ffffCinzel Decorative|r
Copyright (c) 2012 Natanael Gama (info@ndiscovered.com), with Reserved Font Name 'Cinzel'

|cff00ffffCreepster|r
Copyright (c) 2011, Font Diner, Inc (diner@fontdiner.com),
with Reserved Font Names "Creepster"

|cff00ffffElsie Swash Caps|r
Copyright (c) 2010-2012, Alejandro Inler (alejandroinler@gmail.com), with Reserved Font Name 'Elsie'

|cff00ffffFlamenco|r
Copyright (c) 2011 by LatinoType Limitada (luciano@latinotype.com),

|cff00ffffIM_Fell Types|r
Copyright (c) 2010, Igino Marini (mail@iginomarini.com)

|cff00ffffLimelight|r
Copyright (c) 2011 by Sorkin Type Co (www.sorkintype.com),
with Reserved Font Name "Limelight".

|cff00ffffMiltonian|r
Copyright (c) 2011 by Pablo Impallari (www.impallari.com impallari@gmail.com). Igino Marini (www.ikern.com)

|cff00ffffMrs Saint Delafield|r
Copyright (c) 2011 Alejandro Paul (sudtipos@sudtipos.com), with Reserved Font Name "Mrs Saint Delafield"

|cff00ffffNosifer|r
Copyright (c) 2011, Typomondo, with Reserved Font Name "Nosifer".

|cff00ffffOswald|r
Copyright 2016 The Oswald Project Authors (https://github.com/googlefonts/OswaldFont)

|cff00ffffPoppins|r
Copyright 2020 The Poppins Project Authors (https://github.com/itfoundry/Poppins)

|cff00ffffPress Start 2P|r
Copyright 2012 The Press Start 2P Project Authors (cody@zone38.net), with Reserved Font Name "Press Start 2P".

|cff00ffffShareTechMono|r
Copyright (c) 2012, Carrois Type Design, Ralph du Carrois (post@carrois.com www.carrois.com), with Reserved Font Name 'Share'

|cff00ffffSource Code Pro Copyright 2010, 2012 Adobe Systems Incorporated (http|r//www.adobe.com/), with Reserved Font Name 'Source'. All Rights Reserved. Source is a trademark of Adobe Systems Incorporated in the United States and/or other countries.

|cff00ffffSyne_Mono|r
Copyright 2017 The Syne Project Authors (https://gitlab.com/bonjour-monde/fonderie/syne-typeface)

|cff00ffffTangerine|r
Copyright (c) 2010, Toshi Omagari (tosche@mac.com)

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
local options, db, Fonts, keys, SearchTerms, SearchResults, Browsing,
      Stats, PreviewText, PreviewSize, Filter, SandboxText, SandboxFont,
      ViewFontList, ViewLicense, Initialized, HashTable;

-- constants
local col        = { 0.2, 1.5, 0.9, 0.5 };
local BUILTIN    = "Built-in font";
local POPUP      = "RPFONTS_CONFIRMATION_BUTTON";
local TEST_STRIP = "This is a TEST STRIP for testing. We use it to detect if fonts are being applied.";
local ORANGE_BALL = "|A:nameplates-icon-orb-orange:0:0|a";
local PURPLE_BALL = "|A:nameplates-icon-orb-purple:0:0|a";
local BLUE_BALL   = "|A:nameplates-icon-orb-blue:0:0|a";

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
local function   orange(str, r) return colorize(   ORANGE_FONT_COLOR_CODE, str, r) end;
local function   normal(str, r) return colorize(   NORMAL_FONT_COLOR_CODE, str, r) end;
local function    white(str, r) return colorize(             "|cffffffff", str, r) end;
local function   purple(str, r) return colorize(             "|cffc745f9", str, r) end;
local function     cyan(str, r) return colorize(             "|cff00ffff", str, r) end;

local function notify(...) print("[" .. rpFontsTitle .. "]", ...) end;

-- filters
local filters    =
{ [ "none"     ] =           "Filter List..." ,
  [ "active"   ] =   yellow( "Active Fonts"   ),
  [ "inactive" ] =    white( "Inactive Fonts" ),
  [ "disabled" ] =     grey( "Disabled Fonts" ),
  [ "missing"  ] =      red( "Missing Fonts"  ),
  [ "new"      ] =    green( "New Fonts"      ),
  [ "verified" ] =   orange( "Verified Fonts" ),
  [ "unverified"] = purple( "Unverified Fonts" ),
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
  [ "verified" ] = "A verified font has been automatically tested by checked by "           ..
                   rpFontsTitle .. " to see if it can be used successfully."                 ,
  [ "unverified"] = "An unverified font is one that was tested by " .. rpFontsTitle         ..
                    " and could not be successfully applied in-game."                        ,
};

local filter_order = { "none", "new", "active", "inactive", "disabled", "missing", "builtin", "verified", "unverified"};

-- addons and files ------------------------------------------------------------------------------------------------------------------------
--
-- database ------------------------------------------------------------------------------------------------------------------------------
local function clearCounts()
  Stats =
  { total          = 0, new      = 0, missing = 0, active  = 0,
    inactive       = 0, disabled = 0, loaded  = 0, builtin = 0,
    builtin_active = 0, new_active = 0, unverified = 0,
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

  Stats = { now = time() };
  clearCounts();

  keys = {};

end;

local testStrip = rpFontsFrame:CreateFontString();
testStrip.file, _ = GameFontNormal:GetFont();
testStrip.size = 10;
testStrip.sampleText = TEST_STRIP;
local fixedStrip = rpFontsFrame:CreateFontString()
testStrip.fixed = fixedStrip;
testStrip.fixed.sampleText = TEST_STRIP:gsub("%w", "X");

function testStrip.Reset(self)
  self:SetFont(self.file, self.size);
  self:SetText(self.sampleText)
  self.fixed:SetFont(self.file, self.size)
  self.fixed:SetText(self.fixed.sampleText);
end;

function testStrip.TestFile(self, file)
  self:SetFont( file:GetName(), self.size);
  self.fixed:SetFont( file:GetName(), self.size);
  local stripWidth = self:GetUnboundedStringWidth();
  local fixedWidth = self.fixed:GetUnboundedStringWidth();
  -- return self:GetUnboundedStringWidth(), self.baseline, self:GetUnboundedStringWidth() - self.baseline,
  return stripWidth, self.baseline, stripWidth - self.baseline, stripWidth - fixedWidth;
end;

testStrip:Reset();
testStrip.baseline = testStrip:GetUnboundedStringWidth()

local countRecount = 0
local function recount()
  clearCounts();
  countRecount = countRecount + 1;
  notify(green("countRecount"), green(countRecount), grey("ah ah ah"));
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
local objectTypes = { "font", "addon", "file" };
local flags  =
{ font  = { "active", "loaded",   "inactive", "disabled", "new", "missing", "builtin", "verified", "unverified", "deleted" },
  addon = { "loaded", "disabled", "missing",  "builtin", "initialized" },
  file  = { "loaded", "disabled", "missing", "verified", "unverified" }
};

--[[ Flag definitions:

     "active"   = not deactivated by the user; implies not("inactive"), not("missing")
     "inactive" = deactivated by the user; implies not("active")
     "loaded"   = the addon associated with the font file has been loaded into WoW
     "disabled" = is part of an addon that exists but is disabled; implies not("missing")
     "new"      = added since the last login; implies not("missing")
     "missing"  = is part of an addon that is no longer installed; implies, not("disabled"), not("new")
     "builtin"  = a built-in font; implies not("missing")
     "verified" = the font has been tested and has proven to load correctly
     "unverified" = the opposite of verified
     "deleted"  = a victim of a purge

--]]

-- this one's too big/complex to make a tidy entry on the methods table

local function getOptionsTableArgs(self)

  local function filter()
    local  condition1 = self:HasFlag("deleted");
    return self.db.flags.deleted
        or Filter ~= "none" and not self.db.flags[Filter]
        or SearchTerms and not self.match[SearchTerms]
  end;

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
    print("change registration value", value);
    self:Uncount();
    self:SetFlag("active",       value);
    self:SetFlag("inactive", not value);
    self:DoRegistration(  value);
    self:Count();
  end;

  local function getFancyFontName()
    local  name = self:ColorName();
    return (db.Settings.VerifyFonts
            and
            ( (self.db.flags.builtin and BLUE_BALL
                 or
                 self.db.flags.verified and ORANGE_BALL
                 or
                 PURPLE_BALL) .. " ")
            or " ") .. name

    -- if     db.Settings.VerifyFonts and self:HasFlag("builtin")
    -- then   name = BLUE_BALL .. " " .. name
    -- elseif db.Settings.VerifyFonts and self:HasFlag("verified")
    -- then   name = ORANGE_BALL .. " " .. name
    -- elseif db.Settings.VerifyFonts
    -- then   name = PURPLE_BALL .. " " .. name
    -- end;
    -- return name;

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
        name             = getFancyFontName,
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

    [name .. "_Newline"] =
      { type = "description",
        width = "full",
        fontSize = "small",
        name = "",
        hidden           = filter,
      },
  };

  table.insert(keys, self.name);

  return args;
end;


local methods =
{
  ["WhatAmI"]   = function(self) return tContains(objectTypes, self.what) and self.what or nil end,
  ["GetData"]   = function(self) return self.db end,
  ["GetName"]   = function(self) return self.name end,
  ["HasFlag"]   = "GetFlag",
  ["GetFlag"]   = function(self, flag) if tContains(flags[ self:WhatAmI()], flag) then return self.db.flags[flag]; end; end,
  ["ClearFlag"] = function(self, flag) if tContains(flags[ self:WhatAmI()], flag) then self.db.flags[flag] = false; end; end,
  ["ClearAllFlags"] = function(self) for _, flag in ipairs(objectTypes[self.what]) do  self.db.flags[flag] = nil; end; end,
  ["GetFont"] = function(self) return self.font; end,
  ["SetFlag"] =
    function(self, flag, value)
      if value == nil then value = true end;
      if   flag and tContains(flags[ self:WhatAmI()], flag)
      then self.db.flags[flag] = value;
      end;
    end,

  ["ColorName"] =
    function(self)
      local name = self.GetTitle and self:GetTitle() or self:GetName();
      local _, status = self.font:GetStatus();

      return status == "builtin"  and bluzzard(name, true  )
          or status == "missing"  and red(name,      true  )
          or status == "new"      and green(name,    false )
          or status == "disabled" and grey(name,     true  )
          or status == "active"   and yellow(name,   false )
          or status == "white"    and white(name,    false )
          or name;
    end,
  addon =  -- methods for addons only
    {
      ["GetTitle"] = function(self) return GetAddOnMetadata(self:GetName(), "Title"); end,
      ["IsLoaded"] =
        function(self)
          if self.name == BUILTIN then return true end;
          local _, _, _, isLoadable, reason = GetAddOnInfo(self.name);
          self:SetFlag("loaded", isLoadable);
          if not isLoadable then return false, reason; else return true, nil; end;
        end,
    },

  file = -- methods for files only
    { ["Verify"] =
        function(self)
          testStrip:Reset();
          local result, baseline, diff, fixed = testStrip:TestFile( self );
          return result, baseline, diff, fixed
        end,
      ["IsLoaded"] = function(self) return self.addon:IsLoaded(); end,
      ["GetAddonFromPath"] =
        function(self)
          return self and self.addon and self.addon.name
              or self.name:match("^[iI]nterface\\[aA]dd[oO]ns\\(.-)\\")
              or BUILTIN;
        end,
    },

  font = -- methods for fonts only
    {
      ["Verify"] =
        function(self)
          local verified = false;
          for fileName, file in pairs(self:GetList("file"))
          do  local result, baseline, diff = file:Verify();
              if math.abs(diff) > (db.Settings.VerifyTolerance or 0.05) or self:HasFlag("builtin")
              then file:SetFlag("verified");
                   verified = true
              else file:SetFlag("unverified");
              end;
          end;

          self:SetFlag("verified",       verified);
          self:SetFlag("unverified", not verified);
        end,

      ["GetTitle"] =
        function(self)
          if self:HasFlag("builtin") and LibSharedMedia:GetDefault("font") == self:GetName()
          then return self:GetName() .. " (LSM Default)"
          else return self:GetName()
          end
        end,

      ["IsLoaded"] = function(self) return self:GetFlag("loaded") end,
      ["NewAddon"] =
        function(self, name)
          local addon = self:New("addon", name);
          self:SetFlag("builtin", name == BUILTIN);
          return addon;
        end,

      ["GetPrimaryFile"] =
        function(self)
          for name, file in pairs( self:GetFiles() )
          do  if file:HasFlag("loaded") then return file end;
          end;
          return nil;
        end,
      ["NewFile"] = function(self, name) return self:New("file", name); end,
      ["HasItem"] = "GetItem",
      ["GetItem"] = function(self, objType, name) return self[objType] and self[objType][name] or nil end,
      ["AddItem"] = "SetItem",
      ["SetItem"] = function(self, objType, item) local name = item:GetName(); self[objType][name] = item; end,
      ["SetTimestamp"] = function(self, timeStamp) self.db.stamp[timeStamp] = Stats.now end, -- note: not the current time()
      ["GetTimestamp"] = function(self, timeStamp) return self.db.stamp[timeStamp]; end,

      ["GetList"] =
        function(self, objType)
          if   type(self[objType]) == "table"
          then return self[objType]
          else return nil;
          end;
        end,
      ["GetAddons"] = function(self) return self:GetList("addon") end,
      ["GetFiles"] = function(self) return self:GetList("file") end,
      ["GetAddon"] = function (self, name) return self:GetItem("addon", name) end,
      ["GetFile"]=  function(self, name) return self:GetItem("file",  name) end,

      ["Register"] =
        function(self)
          local file = self:GetPrimaryFile();
          print("registering", self:GetName());
          if file then LibSharedMedia:Register("font", self:GetName(), file:GetName()); end;
          self.primaryFile = file;
        end,

      ["Deregister"] =
        function(self)
          print("deregistering", self:GetName());
          LibSharedMedia.MediaTable.font[self:GetName()] = nil
        end,
      ["GetStatus"] =
        function(self) -- returns true/false if it should be shown, and the primary status

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

        end,

      ["DoRegistration"] =
        function(self, status)
          self:Uncount();
          if status == nil then status, _ = self:GetStatus() end;
          if status then self:Register() else self:Deregister() end;
          self:Count();
        end,

      ["Count"] = -- this the font walking up and saying "count me! count me!"
        function(self, uncount)
          -- helpers
          local function incr(cat) Stats[cat] = Stats[cat] + (uncount and -1 or 1) end;

          if self.db.flags.unverified then incr("unverified") end;
          if self.db.flags.active     then incr("active")     end;
          if self.db.flags.builtin    
            then incr("builtin")
                 if self.db.flags.active then incr("builtin_active") end
            end;
          if self.db.flags.unverified then incr("unverified") end;
          if self.db.flags.verified   then incr("verified") end;
          if self.db.flags.inactive and not self.db.flags.missing 
            then incr("inactive") end;
          if self.db.flags.missing    then incr("missing") end;
          if self.db.flags.new        
            then incr("new")
              if self.db.flags.active then incr("new_active") end;
          end;
          incr("total");
        end,

      ["Uncount"] = function(self) self:Count(true) end,
      ["GetOptionsTableArgs"] = getOptionsTableArgs,
      ["SetFlagsFromAddons"] =
        function(self)
          local any = {};

          for name, addon in pairs(self:GetAddons())
          do
            for  _, flag in ipairs(flags.addon)
            do   if addon:HasFlag(flag) then any[flag] = true; end; -- make a composite value of all the flags
            end;  -- for _, flag

            if     any.builtin  then self:SetFlag("builtin", true  ); end;

            if     any.loaded   then self:SetFlag("loaded",   true );
                                     self:SetFlag("disabled", false);
                                     self:SetFlag("missing",  false);
            elseif any.disabled then self:SetFlag("loaded",   false);
                                     self:SetFlag("disabled", true );
                                     self:SetFlag("missing",  false);
            elseif any.missing  then self:SetFlag("loaded",   false);
                                     self:SetFlag("disabled", false);
                                     self:SetFlag("missing",  true);
            end;

            if not self:GetFlag("active") and not self:GetFlag("inactive")
            then   self:SetFlag("active")
            end;

            if self:GetFlag("active") and self:GetFlag("inactive") then self:ClearFlag("active") end;

            _ = self:GetTimestamp("FirstSeen") or self:SetTimestamp("FirstSeen");
            self:SetTimestamp("LastSeen");
          end; -- for name, addon
        end, -- method

      ["FormatListForDisplay"] =
        function(self, what, delim)
          local text = {};
          for _, item in pairs(self:GetList(what))
          do  table.insert(text, item:ColorName());
          end;
          return table.concat(text, delim or ", ");
        end,
   },
};


local function attachMethods(object, objType)
  if tContains(objectTypes, objType) and not object.initialized
  then object.what = objType
    for funcName, func in pairs(methods)
    do  if type(func) == "function"
        then object[funcName] = func;
        elseif type(func) == "string" and methods[func] and type(methods[func]) == "function"
        then object[funcName] = methods[func]
        end;
    end;

    if type(methods[objType]) == "table"
    then for funcName, func in pairs(methods[objType])
         do  if     type(func) == "function"
             then   object[funcName] = func;
             elseif type(func) == "string" and methods[objType][func] and type(methods[objType][func]) == "function"
             then   object[funcName] = methods[objType][func]
             end;
         end;
    end;
    object.initialized = true;
  elseif object.initialized
  then -- nothing really here
  else error("Unknown object type " .. (objType or type(objType)));
  end;
end;

methods["New"] =
  function(self, what, name)
    local item = self[what][name] or {};
    item.name = name;
    item.font = self;
    attachMethods(item, what, self);
    self.db[what][name] = self.db[what][name] or {};
    item.db             = self.db[what][name];
    item.db.flags       = item.db.flags or {};

    self:AddItem(what, item);
    return item;
  end;

-- font object --------------------------------------------------------------------------------------------------------------------
  --
local function makeFontRecord(fontName, fontFile)
  if type(fontName) ~= "string" then error("fontName must be a string") return end;
  local font = Fonts[fontName] or {};

  font.font = font;
  font.name  = fontName;
  font.flags = font.flags or {};
  attachMethods(font, "font", font);

  db.Fonts[fontName] = db.Fonts[fontName] or {};
  font.db = db.Fonts[fontName];

  for _, subDir in ipairs({ "flags", "file", "addon", "stamp" })
  do  font[subDir]    = font[subDir]    or {}; -- this stores objects
      font.db[subDir] = font.db[subDir] or {}; -- this stores data
  end;

  Fonts[fontName] = font;

  if   fontFile
  then local file = font:NewFile(fontFile);
       return font, file, font:NewAddon( file:GetAddonFromPath() );
  else return font;
  end;
end;

-- -------------------------------------------------------------------------------------------------------------------------------
local function restoreSavedData()
  for fontName, info in pairs(db.Fonts)
  do  if info and info.flags and info.flags.deleted then db.Fonts[fontName] = nil;
      else
        local font = makeFontRecord(fontName);
        if   info.file
        then for fileName, fileData in pairs(info.file)
             do  local file  = font:NewFile(fileName)
                 local addon = font:NewAddon( file:GetAddonFromPath() );
                       file:SetFlag("loaded", addon:IsLoaded());
                       addon:SetFlag("loaded", addon:IsLoaded());
             end;
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
  OnShow   =
    function(self)
      self.text:SetJustifyH("LEFT");
      self.text:SetSpacing(3);
    end,
};

local function scaryWarningMessage(fontState)
  return
    "This will permanently delete information on " .. fontState .. " from " ..
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
  do  if flag == "all" or font:HasFlag(flag)
      then font:SetFlag("deleted")
      num = num + 1; end;
  end;

  if num > 0
  then notify(num .. " font records deleted.")
       recount();
       updateOptions();
  else notify("No font records deleted.")
  end;
end;

local function purgeMissing()
  StaticPopupDialogs[POPUP].text = scaryWarningMessage(red("missing fonts"));
  StaticPopupDialogs[POPUP].OnAccept = function() doPurge("missing") end;
  StaticPopup_Show(POPUP);
end;

local function purgeDisabled()
  StaticPopupDialogs[POPUP].text = scaryWarningMessage(grey("disabled fonts"));
  StaticPopupDialogs[POPUP].OnAccept = function() doPurge("disabled") end;
  StaticPopup_Show(POPUP);
end;

local function purgeEverything()
  StaticPopupDialogs[POPUP].text = scaryWarningMessage(yellow("all fonts"));
  StaticPopupDialogs[POPUP].OnAccept = function() doPurge("all") end;
  StaticPopup_Show(POPUP);
end;

--[[
local function purgeBrowsingFont()
  StaticPopupDialogs[POPUP].text = scaryWarningMessage(Browsing:ColorName());
  StaticPopupDialogs[POPUP].OnAccept =
    function()
      Browsing:SetFlag("deleted");
      Browsing = Fonts[ LibSharedMedia:GetDefault("font") ];
    end;
  StaticPopup_Show(POPUP);
end;
--]]

local function generateHashTable()
  local list = {};
  for fontName, font in pairs(Fonts) do list[fontName] = font:ColorName() end;
  HashTable = list;
  return list
end;

-- --------------------------------------------------------------------------------------------------------------------------------------
local function applyLoadDisabled(info, value)
  db.Settings.LoadDisabled = value;
  for _, font in pairs(Fonts)
  do if font:HasFlag("disabled") then font:DoRegistration() end;
  end;
end;

-- browser ----------------------------------------------------------------------------------------------------------------------------
--
local function buildFontBrowser()

  local fontBrowser       =
  { name                  = "Font Browser",
    type                  = "group",
    order                 = 1000,

    args                  =
    {
      selector            =
      { type              = "select",
        width             = 2,
        name              = "Font Selector", -- function() return Browsing and Browsing:GetName() or db.Browsing or "" end,
        order             = 2100,
        values            = generateHashTable,
        get               = function() return Browsing and Browsing:GetName() or db.Browsing or "Morpheus" end,
        set               = function(info, value) db.Browsing = Fonts[value]; Browsing = Fonts[value] end,
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
            hidden        = function() return Browsing and not Browsing:HasFlag("active") end,
            name          = "Set Inactive",
            width         = 0.75,
            func          = function() Browsing:DoRegistration(false) end,
            disabled      = function() return Browsing and LibSharedMedia:GetDefault("font") == Browsing:GetName() end,
          },
          active          =
          { type          = "execute",
            order         = 2302,
            hidden        = function() return Browsing and not Browsing:HasFlag("inactive") end,
            name          = "Set Active",
            width         = 0.75,
            func          = function() Browsing:DoRegistration(true) end,
          },
          --[[
          deleteRecord    =
          { type          = "execute",
            order         = 2303,
            name          = "Delete Record",
            width         = 0.75,
            desc          = "Deleting this record won't delete the font file from your computer, or even from " ..
                            "LibSharedMedia. All that deleting will do is delete " .. rpFontsTitle .. "'s record of " ..
                            "the font, which means that it won't know whether to set the font active or inactive -- " ..
                            "and will likely default to active.",
            func          = purgeBrowsingFont,
          },
          --]]
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

          lastSeenLeft   =
          { type          = "description",
            name          = yellow("Last Active"),
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

        },
      },

    },
  };

  options.args.fontBrowser = fontBrowser;
end;

-- font list -----------------------------------------------------------------------------------------------------------------------------

local function buildDataTable()
  local function showFontList()
    return (db.Settings.OverrideFailsafe and db.Settings.ShowHugeList)
        or (db.Settings.OverrideFailsafe and Stats.total <= (db.Settings.FailsafeThreshold or failsafeThreshold))
        or ((not db.SettingsOverrideThreshold) and Stats.total <= failsafeThreshold);
  end;

  local function showCurrentFilter()
    if not Filter or Filter == "none"
    then return "All Fonts"
    else return filters[Filter]
    end
  end;

  local dataTable      =
  { name               = "Font List",
    type               = "group",
    order              = 1900,
    hidden             = function() return not showFontList() end,
    args           =
    {
      shadowHeadline     =
      { type = "description",
        name = " ",
        width = col[1] + col[2] + col[3] + 0.1,
        order = 890,
        fontSize = "small",
        hidden = function() return db.Settings.DataTools end,
      },

      headline           =
      { type             = "description",
        name             = showCurrentFilter,
        width            = 1.1,
        order            = 900,
        fontSize         = "large",
        hidden           = function() return not db.Settings.DataTools end,
      },

      filters            =
      { type             = "select",
        values           = filters,
        name             = "",
        width            = col[1] + col[2] + col[3] - 1.5,
        order            = 905,
        sorting          = filter_order,
        get              = function() return Filter or "" end,
        set              = function(info, value) Filter = value end,
        hidden           = function() return not db.Settings.DataTools end,
      },

      spacer             =
      { type = "description",
        name = " ",
        order = 906,
        width = 0.5,
        fontSize = "small",
        hidden           = function() return not db.Settings.DataTools end,
      },
      toolsToggle        =
      { type             = "toggle",
        name             = "Tools",
        width            = col[4],
        order            = 908,
        get              = function() return db.Settings.DataTools end,
        set              = function(info, value)
                             db.Settings.DataTools = value
                             if not value then Filter = "none"; SearchTerms = nil; SearchResults = nil; end;
                           end,
        desc             = "You can turn off or on tools for working with the table here.",
      },
      filtersDescription =
      { type             = "description",
        fontSize         = "small",
        name             = function() return filter_desc[Filter] end,
        order            = 920,
        width            = col[1] + col[2] + col[3],
        hidden           = function() return not db.Settings.DataTools end,
      },
      filtersSpacer =
      { type = "description",
        fontSize = "large",
        name = "\n\n\n",
        width = col[4],
        hidden           = function() return not db.Settings.DataTools end,
        order = 922,
      },
      searchBarBlank =
      { type = "description",
        fontSize = "small",
        name = " ",
        hidden  = function() return not db.Settings.DataTools end,
        width = "full",
        order = 930,
      },
      searchBarLabel =
      { type = "description",
        fontSize = "medium",
        name = "Search",
        width = 0.4,
        hidden  = function() return not db.Settings.DataTools end,
        order = 935,
      },
      searchBar =
      { type = "input",
        name = "",
        width = col[1] + col[2] + col[3] - 0.5,
        get = function() return SearchTerms end,
        set = function(info, value)
                SearchTerms = value
                if   SearchTerms
                then local count = 0;
                     for _, font in pairs(Fonts)
                     do  if   font:GetName():lower():match( SearchTerms:lower() )
                              and ( not Filter or font:HasFlag(Filter))
                         then count = count + 1;
                         end;
                     end;
                     SearchResults = count;
                else SearchResults = nil;
                end;
            end,
        hidden = function() return not db.Settings.DataTools end,
        order = 940,
      },
      searchBarSpacer =
      { type = "description",
        fontSize = "medium",
        name = " ",
        width = 0.2,
        hidden  = function() return not db.Settings.DataTools end,
        order = 945,
      },
      searchBarClear =
      { type = "execute",
        name = "Clear",
        width = col[4],
        order = 945,
        hidden = function() return not db.Settings.DataTools end,
        disabled = function() return not SearchTerms end,
        func = function() SearchTerms = nil; SearchResults = nil; end,
      },
      columns =
      {
        type = "group",
        inline = true,
        name = function() return SearchResults and (SearchResults .. " |4match:matches;") or " " end,
        order = 950,
        args =
        {
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

          filterPlaceholder =
          { type = "header",
            name = white("Nothing to display"),
            width = "full",
            order = 1006,
            hidden = function() return not(Stats[Filter] == 0) or SearchTerms and SearchResults ~= nil and SearchResults == 0 end,
          },
        },
      },
    },
  };

  if   Fonts
  then
       for fontName, font in pairs(Fonts)
       do  local font_args = font:GetOptionsTableArgs()
           for k, v in pairs(font_args) do dataTable.args.columns.args[k] = v end;
       end;
  end;

  -- second pass, for displaying in order:
  table.sort(keys);

  for i, key in ipairs(keys)
  do dataTable.args.columns.args[key .. "_Active"   ].order = 1000 + i * 10 + 1;
     dataTable.args.columns.args[key .. "_Name"     ].order = 1000 + i * 10 + 2;
     dataTable.args.columns.args[key .. "_AddOn"    ].order = 1000 + i * 10 + 3;
     dataTable.args.columns.args[key .. "_Details"  ].order = 1000 + i * 10 + 4;
     dataTable.args.columns.args[key .. "_Newline"  ].order = 1000 + i * 10 + 5;
  end;

  options.args.dataTable = dataTable;
  options.args.dataTableHidden =
  { name               = "Font List",
    type               = "group",
    order              = 1901,
    hidden = function() return showFontList() end ,
    args           =
    {
      whereIsTheTable =
      { type = "description",
        name = "Where's the Font List?",
        order = 710,
        fontSize = "large",
        width = "full",
      },
      tableIsHidden =
      { type = "description",
        name = "The font list is currently hidden because you have more than " ..
               (db.Settings.FailsafeThreshold or failsafeThreshold) ..
               " fonts registered. \n\nIn order to prevent possible slowdown whenever you open " ..
               "the options panel, " .. rpFontsTitle .. " isn't showing the font list.\n\n" ..
               "You can disable this behavior in settings.",
        order = 720,
        fontSize = "medium",
        width = col[1] + col[2] + col[3],
      },
      hiddenNewline = newline(725),
      spacer =
      { type = "description",
        width = col[1] + col[2] - 0.5,
        name = " ",
        order = 727,
      },
      goToOptions =
      { type = "execute",
        name = "Settings",
        order = 730,
        width = col[3],
        func = function() AceConfigDialog:SelectGroup(addOnName, "settings") end,
      },
    },
  };
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
            get               = function() return SandboxFont or LibSharedMedia:GetDefault("font") end,
            set               = function(info, value) SandboxFont = value end,
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
                                  return
                                    SandboxText or
                                    (SandboxFont and SandboxFont:GetName()) or
                                    LibSharedMedia:GetDefault("font")
                                  end,
            set               = function(info, value) SandboxText = value end,
            name              = function() return (SandboxFont and SandboxFont:GetName()) or LibSharedMedia:GetDefault("font") end,
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
        width           = 1.5,
      },

      resetAll      =
      { type            = "execute",
        name            = "Clear all font records",
        order           = 9005,
        width           = 1.25,
        desc            = "You can reset all font information stored by " .. rpFontsTitle .. ". (Not recommended.)",
        func            = purgeEverything,
      },

      defaultForNewFonts =
      { type = "select",
        name = "Default status for new fonts",
        order = 9007,
        width = 1.25,
        desc = "Should new fonts start out as enabled or disabled?",
        values = { enabled = "Enabled", disabled = "Disabled" },
        get = function() return db.Settings.NewFontsStartDisabled and "disabled" or "enabled" end,
        set = function(info, value) db.Settings.NewFontsStartDisabled = (value == "disabled") end,
      },

      spacerDefault    =
      { type = "description",
        name = " ",
        width = 0.25,
        order = 9008,
      },

      overrideProtect =
      { type = "toggle",
        name = "Override the long list failsafe",
        desc = "By default, " .. rpFontsTitle .. " will disable the font list whenever you have more " ..
               "than " .. failsafeThreshold .. " fonts, because this can lead to poor performance. Check this box to override " ..
               "that behavior.",
        width = 1.5,
        order = 9009,
        get = function() return db.Settings.OverrideFailsafe end,
        set = function(info, value) db.Settings.OverrideFailsafe = value end,
      },
      overrideAdvanced =
      { type = "group",
        name = "Override the Failsafe",
        width = "full",
        order = 9010,
        inline = true,
        hidden = function() return not db.Settings.OverrideFailsafe end,
        args =
        { showHugeListList =
          { type = "toggle",
            name = "No limits on the list size",
            desc = "Remove all safeguards against displaying a long list. " .. red("Not recommended!"),
            width = 1.5,
            order = 9100,
            get = function() return db.Settings.ShowHugeList end,
            set = function(info, value) db.Settings.ShowHugeList = value end,
          },
          threshold =
          { type = "range",
            width = 1.5,
            order = 9120,
            name = "Failsafe Threshold",
            desc = "Set the number of fonts that will trigger the failsafe.",
            min = 10,
            max = 200,
            softMin = 20,
            softMax = 100,
            step = 10,
            get = function() return db.Settings.FailsafeThreshold or failsafeThreshold end,
            set = function(info, value) db.Settings.FailsafeThreshold = value end,
            disabled = function() return db.Settings.ShowHugeList end,
          },
        },
      },

      verifyFonts       =
      { type            = "toggle",
        name            = "Verify fonts when loading",
        desc            = rpFontsTitle .. " can try to verify that a given font is valid. This may slow down your " ..
                          "loading time if you have a lot of fonts.",
        get             = function() return db.Settings.VerifyFonts end,
        set             = function(info, value) db.Settings.VerifyFonts = value end,
        width           = 1.50,
        order           = 9011,
      },

      verifyAdvanced =
      { type = "group",
        inline = true,
        name = "Verification Settings",
        order = 9013,
        hidden = function() return not db.Settings.VerifyFonts end,
        args =
        {
          onlyVerifyActive  =
          { type            = "toggle",
            name            = "Active fonts only",
            desc            = "Only attempt to verify active fonts.",
            get             = function() return db.Settings.OnlyVerifyActive end,
            set             = function(info, value) db.Settings.OnlyVerifyActive = value end,
            order           = 9013,
            width           = 1.00,
          },

          verifyTolerance   =
          { type            = "range",
            name            = "Verification Tolerance",
            desc            = "Choose how much tolerance there should be in the verification process.",
            order           = 9015,
            width           = 0.75,
            min             = 0,
            max             = 2.0,
            step            = 0.01,
            get             = function() return db.Settings.VerifyTolerance or 0.05 end,
            set             = function(info, value) db.Settings.VerifyTolerance = value end,
          },

          spacer            =
          { type            = "description",
            name            = " ",
            width           = 0.2,
            order           = 9016,
          },

          verifyNow         =
          { type            = "execute",
            name            = "Verify Now",
            desc            = "Run a verification check on all fonts.",
            order           = 9017,
            width           = 0.75,
            func            = function() for _, font in pairs(Fonts) do font:Verify() end end,
          },

        },
      },


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
  do  local font, addon, file = makeFontRecord(fontName, fontFile)
      addon:SetFlag( "loaded" );
      file:SetFlag(  "loaded" );
  end;

end;

local function registerSlashCommand()

  _G[ "SLASH_RPFONTS1"  ] = "/rpfonts";
  _G[ "SLASH_RPFONTS2"  ] = "/rpfont";
  SlashCmdList["RPFONTS"] = function() Interface:Show(); Interface_Open(rpFontsTitle); end;

end;

local function cycleThroughFonts()
  clearCounts();
  for fontName, font in pairs(Fonts)
  do  font:SetFlagsFromAddons();
      font:DoRegistration();
      font:Count();
      if db.Settings.VerifyFonts and not db.Settings.VerifyOnlyActive
      then font:Verify();
      end;
      font:SetFlag("new", font:GetTimestamp("FirstSeen") == Stats.now);
  end;
  if Stats.new > 0
  then notify(green(Stats.new .. " new fonts found!"), "Type", cyan("/rpfonts"),  "to manage fonts.")
  end;
end;

local function initializationDone()
  local LSM_Default = LibSharedMedia:GetDefault("font");
  if    LSM_Default and Fonts[LSM_Default]:HasFlag("inactive")
  then  Fonts[LSM_Default]:SetFlag("active");
        Fonts[LSM_Default]:ClearFlag("inactive");
        Fonts[LSM_Default]:DoRegistration(true)
  end;

  local LSM_Global = LibSharedMedia:GetGlobal("font");
  if    LSM_Global and Fonts[LSM_Global]:HasFlag("inactive")
  then  Fonts[LSM_Global]:SetFlag("active");
        Fonts[LSM_Global]:ClearFlag("inactive");
        Fonts[LSM_Global]:DoRegistration(true)
  end;

  Browsing = Fonts[db.Browsing] or Fonts[LSM_Default];
  SandboxFont = Fonts[LSM_Default];

  Initialized = true;
end;

-- our fonts -------------------------------------------------------------------------------
local family = {
  Almen  = baseFontDir .. "Almendra_Display\\AlmendraDisplay-",
  Amara  = baseFontDir .. "Amarante\\Amarante-",
  Arima  = baseFontDir .. "Arima_Madurai\\ArimaMadurai-",
  Barlow = baseFontDir .. "Barlow_Condensed\\BarlowCondensed-",
  Belle  = baseFontDir .. "Bellefair\\Bellefair-",
  Berk   = baseFontDir .. "Berkshire_Swash\\BerkshireSwash-",
  BigSho = baseFontDir .. "Big_Shoulders_Stencil_Display\\BigShouldersStencilDisplay-",
  Cinzel = baseFontDir .. "Cinzel_Decorative\\CinzelDecorative-",
  Creep  = baseFontDir .. "Creepster\\Creepster-",
  Elsie  = baseFontDir .. "Elsie_Swash_Caps\\ElsieSwashCaps-",
  Flame  = baseFontDir .. "Flamenco\\Flamenco-",
  FontDS = baseFontDir .. "Fontdiner_Swanky\\FontdinerSwanky-",
  IMFell = baseFontDir .. "IM_Fell\\IMFell",
  Lime   = baseFontDir .. "Limelight\\Limelight-",
  Milton = baseFontDir .. "Miltonian\\Miltonian-",
  MrsStD = baseFontDir .. "Mrs_Saint_Delafield\\MrsSaintDelafield-",
  MtXmas = baseFontDir .. "Mountains_of_Christmas\\MountainsofChristmas-",
  Nosif  = baseFontDir .. "Nosifer\\Nosifer-",
  Oswald = baseFontDir .. "Oswald\\Oswald-",
  Poppi  = baseFontDir .. "Poppins\\Poppins-",
  Press  = baseFontDir .. "Press_Start_2P\\PressStart2P-",
  Share  = baseFontDir .. "ShareTechMono\\ShareTechMono-",
  Source = baseFontDir .. "Source_Code_Pro\\SourceCodePro-",
  Synco  = baseFontDir .. "Syncopate\\Syncopate-",
  Syne   = baseFontDir .. "Syne_Mono\\SyneMono-",
  Tanger = baseFontDir .. "Tangerine\\Tangerine-",
  Uncial = baseFontDir .. "Uncial_Antiqua\\UncialAntiqua-",
};

local BLK        = "Black.ttf";
local BLK_ITA    = "BlackItalic.ttf";
local BOLD       = "Bold.ttf";
local BOLD_ITA   = "BoldItalic.ttf";
local ITA        = "Italic.ttf";
local LITE_ITA   = "LightItalic.ttf";
local LITE       = "Light.ttf";
local MED        = "Medium.ttf";
local MED_ITA    = "MediumItalic.tff";
local REG        = "Regular.ttf";
local SEMIBD     = "SemiBold.tff";
local SEMIBD_ITA = "SemiBoldItalic.tff";
local TH         = "Thin.ttf";
local TH_ITA     = "ThinItalic.ttf";
local XB         = "ExtraBold.ttf";
local XB_ITA     = "ExtraBoldItalic.ttf";
local XL         = "ExtraLight.ttf";
local XL_ITA     = "ExtraLightItalic.ttf";
local ENG_REG    = "English-Regular.ttf";
local GP_ITA     = "GreatPrimer-Italic.ttf";
local GP_REG     = "GreatPrimer-Regular.ttf";
local GPSC_REG   = "GreatPrimerSC-Regular.ttf";
local BSSDB      = "Big Shoulders Stencil Display Black";

local fontList=
{ -- Code       = { Load = false, Name = "Human Readable     ",         Fam = "FAM",    File = REG      },
  Almen_Reg     = { Load = false, Name = "Almendra Display",            Fam = "Almen",  File = REG      },
  Amara_Reg     = { Load = false, Name = "Amarante",                    Fam = "Amara",  File = REG      },
  Arima_Light   = { Load = false, Name = "Arima Madurai Light",         Fam = "Arima",  File = LITE     },
  Arima_Reg     = { Load = false, Name = "Arima Madurai",               Fam = "Arima",  File = REG      },
  Barlow_Light  = { Load = false, Name = "Barlow Condensed Light",      Fam = "Barlow", File = LITE     },
  Belle_Reg     = { Load = true,  Name = "Bellefair",                   Fam = "Belle",  File = REG      },
  Berk_Reg      = { Load = false, Name = "Berkshire Swash",             Fam = "Berk",   File = REG      },
  BigSho_Black  = { Load = false, Name = BSSDB,                         Fam = "BigSho", File = BLK      },
  Cinzel_Bold   = { Load = false, Name = "Cinzel Decorative Bold",      Fam = "Cinzel", File = BOLD     },
  Cinzel_Reg    = { Load = true,  Name = "Cinzel Decorative",           Fam = "Cinzel", File = REG      },
  Creep_Reg     = { Load = false, Name = "Creepster",                   Fam = "Creep",  File = REG      },
  Elsie_Reg     = { Load = false, Name = "Elsie Swash Caps",            Fam = "Elsie",  File = REG      },
  Flame_Reg     = { Load = false, Name = "Flamenco",                    Fam = "Flame",  File = REG      },
  FontDS_Reg    = { Load = false, Name = "Fontdiner Swanky",            Fam = "FontDS", File = REG      },
  IMFell_EngReg = { Load = false, Name = "IM Fell English",             Fam = "IMFell", File = ENG_REG  },
  IMFell_GPIta  = { Load = false, Name = "IM Fell Great Primer Italic", Fam = "IMFell", File = GP_ITA   },
  IMFell_GPSC   = { Load = false, Name = "IM Fell Great Primer SC",     Fam = "IMFell", File = GPSC_REG },
  Lime_Reg      = { Load = false, Name = "Limelight",                   Fam = "Lime",   File = REG      },
  Milton_Reg    = { Load = false, Name = "Miltonian",                   Fam = "Milton", File = REG      },
  MrsStD_Reg    = { Load = true,  Name = "Mrs Saint Delafield",         Fam = "MrsStD", File = REG      },
  MtXmas_Bold   = { Load = false, Name = "Mountains of Christmas Bold", Fam = "MtXmas", File = BOLD     },
  Nosif_Reg     = { Load = false, Name = "Nosifer",                     Fam = "Nosif",  File = REG      },
  Oswald_Reg    = { Load = false, Name = "Oswald",                      Fam = "Oswald", File = REG      },
  Poppi_BlkIta  = { Load = false, Name = "Poppins Black Italic",        Fam = "Poppi",  File = BLK_ITA  },
  Poppi_Reg     = { Load = false, Name = "Poppins",                     Fam = "Poppi",  File = REG      },
  Press_Reg     = { Load = false, Name = "Press Start 2P",              Fam = "Press",  File = REG      },
  Share_Reg     = { Load = true,  Name = "Share Tech Mono",             Fam = "Share",  File = REG      },
  Source_Lig    = { Load = false, Name = "Source Code Pro Light",       Fam = "Source", File = LITE     },
  Source_Reg    = { Load = true,  Name = "Source Code Pro",             Fam = "Source", File = REG      },
  Synco_Reg     = { Load = false, Name = "Syncopate",                   Fam = "Synco",  File = REG      },
  Syne_Reg      = { Load = false, Name = "Syne Mono",                   Fam = "Syne",   File = REG      },
  Tanger_Bold   = { Load = false, Name = "Tangerine Bold",              Fam = "Tanger", File = BOLD     },
  Uncial_Reg    = { Load = false, Name = "Uncial Antiqua",              Fam = "Uncial", File = REG      },
 };

local function loadOurFonts()

  for fontCode, fontData in pairs(fontList)
  do  local fontName = fontData.Name
      local fontFile = family[ fontData.Fam ] .. fontData.File;
      LibSharedMedia:Register( "font", fontName, fontFile);
  end
end;

-- main --------------------------------------------------------------------------------------------------------------------------------
--
local function main()
  restoreSavedData();
  loadOurFonts();
  scanForFonts();
  cycleThroughFonts();
  initializationDone();
  createOptionsTable();
  registerSlashCommand();
end;

rpFontsFrame:SetScript("OnEvent",
  function(self, event, addOnLoaded, ...)
    if     event == "ADDON_LOADED"          and addOnLoaded == addOnName then initializeDatabase();
    elseif event == "PLAYER_ENTERING_WORLD"                              then main();
    end;
  end
);

--[[-----------------------------------------------------------------------------
this section based on: EditBox Widget from AceGUI
-------------------------------------------------------------------------------]]
local widgetType, widgetVersion = "RPF_FontPreviewEditBox", 2

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
            local fontFile;

            if text and Fonts[text]
            then local file = Fonts[text]:GetPrimaryFile();
                  fontFile = file:GetName();
             else
                  fontFile, _, _ = text or GameFontNormal:GetFont();
            end;

            self.editbox:SetFont(fontFile, PreviewSize or 30);
            self:SetHeight(math.max(60, PreviewSize + 15));
        end,

        ["DisableButton"] = function(self, disabled) self.disablebutton = disabled if disabled then HideButton(self) end end,
        ["SetMaxLetters"] = function(self, num) self.editbox:SetMaxLetters(num or 0) end,
        ["ClearFocus"   ] = function(self) self.editbox:ClearFocus() self.frame:SetScript("OnShow", nil) end,

        ["SetFocus"] =
          function(self)
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
