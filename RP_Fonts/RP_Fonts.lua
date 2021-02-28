-- RP Fonts
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International (CC BY 4.0) license.

local addOnName, ns = ...;


local LSM               = LibStub("LibSharedMedia-3.0");
local AceConfig         = LibStub("AceConfig-3.0");
local AceConfigDialog   = LibStub("AceConfigDialog-3.0");
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0");
local Interface         = InterfaceOptionsFrame;
local Interface_Open    = InterfaceOptionsFrame_OpenToCategory;
local rpFontsTitle      = GetAddOnMetadata(addOnName, "Title");
local rpFontsDesc       = GetAddOnMetadata(addOnName, "Notes");

ns.RP_Fonts             = ns.RP_Fonts     or {};
ns.RP_Fonts.tmp         = ns.RP_Fonts.tmp or {}; -- temporary cache

-- variables
local options, db, Fonts, keys, Browsing, Stats, PreviewText, Filter, SandboxText, SandboxFont;

-- constants
local col        = { 0.2, 1.5, 1.1, 0.5 };
local BUILTIN    = "Built-in font";
local POPUP      = "RPFONTS_CONFIRMATION_BUTTON";

-- general utilities -----------------------------------------------------------------------------------------------------------------------
--
local function strip(str) return str:gsub("|cff%x%x%x%x%x%x", ""):gsub("|r", "") end;

local function     grey(  str) return  DISABLED_FONT_COLOR_CODE .. strip(str) .. "|r" end;
local function      red(  str) return       RED_FONT_COLOR_CODE .. strip(str) .. "|r" end;
local function   yellow(  str) return    YELLOW_FONT_COLOR_CODE .. strip(str) .. "|r" end;
local function    green(  str) return     GREEN_FONT_COLOR_CODE .. strip(str) .. "|r" end;
local function bluzzard(  str) return BATTLENET_FONT_COLOR_CODE .. strip(str) .. "|r" end;
local function   hilite(  str) return HIGHLIGHT_FONT_COLOR_CODE .. strip(str) .. "|r" end;
local function   normal(  str) return    NORMAL_FONT_COLOR_CODE .. strip(str) .. "|r" end;
local function    white(  str) return              "|cffffffff" .. strip(str) .. "|r" end;

local function notify(...) print("[" .. rpFontsTitle .. "]", ...) end;

-- filters 
local filters    =
{ [ "none"     ] =         "Filter List..." ,
  [ "active"   ] = hilite( "Active Fonts"   ),
  [ "inactive" ] = normal( "Inactive Fonts" ),
  [ "disabled" ] = grey(   "Disabled Fonts" ),
  [ "missing"  ] = red(    "Missing Fonts"  ),
  [ "new"      ] = green(  "New Fonts"      ),
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
};

local filter_order = { "none", "new", "active", "inactive", "disabled", "missing", };

-- addons and files ------------------------------------------------------------------------------------------------------------------------
--
-- database ------------------------------------------------------------------------------------------------------------------------------
local function initializeDatabase()

  _G["RP_FontsDB"] = _G["RP_FontsDB"] or {};
  db               = _G["RP_FontsDB"];
  db.Fonts         = db.Fonts or {};
  db.Settings      = db.Settings or {};

  Filter           = "none";
  PreviewText      = nil;
  Fonts            = {};
  Browsing         = Browsing or "Morpheus";

  Stats =
  { total    = 0, new      = 0, missing = 0, active  = 0,
    inactive = 0, disabled = 0, loaded  = 0, builtin = 0,
    now      = time(),
  };

  keys = {};
 end;

local function clearCounts() 
  Stats =
  { total    = 0, new      = 0, missing = 0, active  = 0,
    inactive = 0, disabled = 0, loaded  = 0, builtin = 0,
    now      = Stats.now, -- preserve original value
  };
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
{ font  = { "active", "loaded", "inactive", "disabled", "new", "missing", "builtin" },
  addon = { "loaded", "disabled", "missing" }, 
  file  = { "loaded", "disabled", "missing" } 
};

--[[ Flag definitions:
            
     "active"   = not deactivated by the user; implies not("inactive"), not("missing")
     "inactive" = deactivated by the user; implies not("active")
     "loaded"   = has been loaded into LibSharedMedia
     "disabled" = is part of an addon that exists but is disabled; implies not("missing")
     "new"      = added since the last login; implies not("missing")
     "missing"  = is part of an addon that is no longer installed; implies not("loaded"),
                  not("loaded"), not("disabled"), not("new")
     "builtin"  = a built-in font; implies not("missing")

--]]

local objectTypes = { "font", "addon", "file" };

local methods =
{ 
  ["WhatAmI"] = function(self) return tContains(objectTypes, self.what) and self.what or nil end,
  ["GetData"] = function(self) return self.data end,
  ["GetName"] = function(self) return self.name end,

  ["SetFlag"] = 
    function(self, flag, value) 
      if value == nil then value = true end;

      if   flag and tContains(flags[ self:WhatAmI()], flag)
      then self.data.flag = value;
      end;
    end,

  ["HasFlag"] = "GetFlag",
  ["GetFlag"] = 
    function(self, flag)
      if flag and tContains(flags[ self:WhatAmI()], flag)
      then return self.data.flag;
      end;
    end,

  ["ClearFlag"] =
    function(self, flag)
      if flag and tContains(flags[ self:WhatAmI()], flag)
      then self.data.flag = false;
      end;
    end,

  ["ColorName"] =
    function(self)
      if     self:HasFlag( "builtin"  ) then return bluzzard( self.name ) 
      elseif self:HasFlag( "missing"  ) then return      red( self.name ) 
      elseif self:HasFlag( "new"      ) then return    green( self.name ) 
      elseif self:HasFlag( "disabled" ) and  
         not db.Settings.LoadDisabled   then return     grey( self.name ) 
      elseif self:HasFlag( "active"   ) then return   yellow( self.name )
      elseif self:HasFlag( "inactive" ) then return    white( self.name )
      else                                            return  self.name
      end;
    end,

  ["SetFont"] =
    function(self, font)
      if     self:WhatAmI() == "font"
      then   self.font = self; 
      elseif type(font) == "table" and font.WhatAmI and font:WhatAmI() == "font"
      then   self.font = font;
      elseif type(font) == "string" 
      then   font = getFontFromDatabase(font);
             if font then self.font = font else error("Unknown font: " .. font) end;
      else   error("Invalid font: " .. type(font));
      end;
    end,

  ["GetFont"] = function(self) return self.font; end,

  ["InitData"] =
    function(self)
      local what = self:WhatAmI();
      local name = self:GetName();

      self.data = self.data or {};
      self.data.what = "data";

      if   what == "font"
      then db.Fonts[name] = db.Fonts[name] or self.data;
      else local fontData = self:GetFont():GetData();
           fontData[what]       = fontData[what] or {};
           fontData[what][name] = fontData[what][name] or self.data or {};
      end;

      return self.data;
    end,

  font =
    { ["InitList"] =
        function(self, objType)
          if   type(objType) == "string" and tContains(objectTypes, objType)
          then self.objType = self.objType or {};
               self:GetData().objType = self:GetData().objType or {}
          else error("Invalid objectType " .. (type(objType) == "string" and objType or type(objType)))
          end;
        end,

      ["HasItem"] = "GetItem",
      ["GetItem"] =
        function(self, objType, name)
          if   tContains(objectTypes, objType)
           and self[objType] and self[objType][name]
          then return self[objType][name]
          else return nil
          end
        end,

      ["AddItem"] = "SetItem",
      ["SetItem"] =
        function(self, objType, item)
          if   tContains(objectTypes, objType) and
               type(item) == "table" and item.WhatAmI and item:WhatAmI() == objType
          then if type(self:GetItem(item)) == "table"
               then self[objType][item:GetName()] = item
                    self:GetData()[objType] = item:GetData();
               else self[objType] = item;
                    self:GetData()[objType] = item:GetData();
               end;
          else error("Unknown file: " .. type(file));
          end;
        end,

      ["GetList"] =
        function(self, objType)
          if   tContains(objectTypes) and type(self[objType]) == "table"
          then return self[objType], self:getData()[objType]
          end;
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

      local list = self:GetList(what) or self:InitList(what) and {};
      local item = self:GetItem(what, name) or {};
      item.name  = name;

      attachMethods(item, what, self);
      self:AddItem(what, item);
      local data = item:InitData();

      return item, data;

    end;

  end; 

  function font.NewAddon(self, name)
    local addon, data = self:New("addon", name);
   
    function addon.IsLoaded(self)
      if self.name == BUILTIN then return true end;
      local _, _, _, isLoadable, reason = GetAddOnInfo(self.name);
      if not isLoadable then return false, reason; else return true, nil; end;
    end;

    return addon, data
  end;

  function font.NewFile(self, name)

    local file, data = self:New("file", name);

    function file.IsLoaded(self) return self.addon and self.addon:IsLoaded() end;

    function file.GetAddonFromPath(self) 
      return self.name:match("^[iI]nterface\\[aA]dd[oO]ns\\(.-)\\") or BUILTIN; 
    end;

    return file, data

  end;

  function font.GetAddons(self)       return self:GetList("addon")       end;
  function font.GetFiles( self)       return self:GetList("file")        end;
  function font.GetAddon( self, name) return self:GetItem("addon", name) end;
  function font.GetFile(  self, name) return self:GetItem("file",  name) end;

  function font.SetFlagsFromAddons(self)

    local any = {};

    for name, addon in pairs(self:GetAddons())

    do  for _, flag in ipairs(flags.addon)
        do  if addon:GetFlag(flag) then any[flag] = true; end;
        end;
    end;

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

  end;

  function font.FindPrimaryFile(self)

    for  name, file in pairs( self:GetFiles() )
    do   if file:IsLoaded() 
         then self.primaryFile = file 
              self.data.primaryFile = file.data;
              return file, file.data;
         end;
    end; 
    self.primaryFile = nil;
    self.data.primaryFile = nil;
    return nil, nil;

  end;

  function font.GetPrimaryFile(self) return self.primaryFile, self.data.primaryFile; end;
  function font.IsLoaded(self) return self:GetFlag("loaded")                         end;

  function font.Register(self)
    local primary = self:GetPrimaryFile()
    if self.name and primary.name then  LSM:Register("font", self.name, primary.name); self:SetFlag("loaded"); end;
  end;

  function font.Deregister(self)
    if self.name then LSM.MediaTable.font[self.name] = nil self:ClearFlag("loaded", false); end;
  end;
    
  function font.GetStatus(self)              -- returns true/false if it should be shown, and the primary status

    if     self:HasFlag( "missing"  ) then return false, "missing"
    elseif self:HasFlag( "inactive" ) then return false, "inactive"
    elseif self:HasFlag( "disabled" ) and  not db.Settings.LoadDisabled 
                                      then return false, "disabled"
    elseif self:HasFlag( "builtin"  ) then return true,  "builtin"
    elseif self:HasFlag( "new"      ) then return true,  "new"
    elseif self:HasFlag( "active"   ) then return true,  "active"
    elseif self:HasFlag( "loaded"   ) then return true,  "loaded"
    else                                   return false, "unknown"
    end
  end;

  function font.SetRegistrationStatus(self, status)
    if status == nil then status, _ = self:GetStatus() end;
    if status then self:Register() else self:Deregister(); 
    end;
  end;

  function font.Count(self)
    local _, primaryStatus = self:GetStatus();
    if primaryStatus ~= "unknown"
    then Stats[primaryStatus] = Stats[primaryStatus] + 1;
    end;
  end;

  function font.FormatListForDisplay(self, what, delim)
    if tContains(objectTypes, what) and self:HasList(what)
    then local text = {};
         for _, item in pairs(self:GetItems("what")) do table.insert(text, item:ColorName()); end;
         return table.concat(text, delim or ", ");
    end;
  end;

  function font.GetOptionsTableArgs(self)

    local function filter() return false end;
   -- not (Filter == "none") and not self:HasFlag(Filter); end;

    local function browseFont()
      Browsing = self:GetName(); 
      AceConfigDialog:SelectGroup(addOnName, "fontBrowser") 
    end

    local name = self:GetName();

    local args = 
    { [name .. "_Active"]  =
        { type             = "toggle",
          name             = "",
          width            = col[1],
          get              = function() return self:HasFlag("active")                      end,
          set              = function(info, value) self:SetRegistrationStatus(value)       end,
          disabled         = function() local disable, _ = self:GetStatus() return disable end,
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
          name             = function() return self:FormatListForDisplay("font", ", ") end,
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
  end;

  db.Fonts[fontName] = font;

  if   fontFile 
  then local  file,  fileData  = font:NewFile(fontFile)
       local newAddonName = file:GetAddonFromPath();
       local  addon, addonData = font:NewAddon( newAddonName );
       return font, data, file, addon;
  end;
       
  return font, data;
  
end;
  
-- -------------------------------------------------------------------------------------------------------------------------------
local function restoreSavedData()
  for fontName, data in pairs(db.Fonts)
  do  local font, data = makeFont(fontName);

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
};

local function scaryWarningMessage(fontState)

  return "This will permanently delete the records of " .. fontState .. " fonts from " .. 
         rpFontsTitle .. "'s records. It can't be undone. " ..
         "Your font files themselves won't be harmed." .. 
         "\n\nIf you load addons that register those fonts with LibSharedMedia, " ..
         rpFontsTitle .. " will create new records for them, as it will no longer " ..
         "have stored records telling it to deactivate or activate the fonts." ..
         "\n\nAre you sure this is what you want to do?";

end;

local function doPurge(fontState)
  local num = 0;
  for name, font in pairs(Fonts)
  do  if font[fontState] 
      then font.data   = nil; 
           Fonts[name] = nil; 
           num         = num + 1; 
      end;
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

  --[[
  local function buildLicenseSection()

    local function licenseAuthorNotKnown() 
    local font = db.Fonts[db.Browsing]; return not font.license.person and not font.license.company; end;
  
    local function licenseAuthorBrowser()
      local license = db.Fonts[db.Browsing].license;
      if not license then return "" end;
      local text = "Copyright ";
      if license.date then text = text .. license.date .. " " end;
      if   license.person 
      then text = text .. license.person .. " ";
  
           if   license.personEmail  
           then text = text .. "<" .. license.personEmail .. ">" 
                if license.personUrl then text = text .. ", " else text = text .. " "; end;
           end;
  
           if   license.personUrl 
           then text = text .. "<" .. license.personUrl .. "> " 
           end;
  
           if license.company then text = text .. ", " end;
      end;
      if   license.company 
      then text = text .. license.company .. " ";
           if license.companyEmail then text = text .. "<" .. license.companyEmail .. ">" 
              if license.companyUrl then text = text .. ", " else text = text .. " "; end;
              end;
           if license.companyUrl then text = text .. "<" .. license.companyUrl .. "> " end;
      end;
      return text;
    end;

    local function licenseName() 
      if db.Fonts[db.Browsinged] and db.Fonts[db.Browsinged].license
      then return db.Fonts[db.Browsinged].license.license or "Unknown"
      else return "Unknown"
      end;
    end;

    local function licenseReservedFontName()
      if db.Fonts[db.Browsinged] and db.Fonts[db.Browsinged].license
      then return db.Fonts[db.Browsinged].license.reservedFontName or db.Fonts[db.Browsinged].name or ""
      else return db.Fonts[db.Browsinged] and db.Fonts[db.Browsinged].name or ""
      end;
    end;

    return
    { type = "group",
      inline = true,
      order = 2600,
      name = "License",
      args =
      { licenseLicenseLeft =
        { type = "description",
          name = "License",
          order = 2610,
          width = 1,
        },
        
        licenseLicenseRight =
        { type = "description",
          name = licenseName,
          order = 2611,
          width = 2,
        },

        licenseLicenseNewline = newline(2612),

        licenseReservedFontNameLeft =
        { type = "description",
          name = "Official Font Name",
          order = 2621,
          width = 1,
        },
        licenseReservedFontNameRight =
        { type = "description",
          name = licenseReservedFontName,
          order = 2622,
          width = 2,
        },
        licenseReservedFontNameNewline = newline(2623),

        licenseAuthorLeft =
        { type = "description",
          name = "Author",
          order = 2631,
          width = 1,
        },
        licenseAuthorRight =
        { type = "description",
          name = licenseAuthorBrowser,
          order = 2632,
          width = 2,
        },
        licenseAuthorNewline = newline(2633),
      },
    };
  end;
  --]]
           
  local fontBrowser       =
  { name                  = "Font Browser",
    type                  = "group",
    order                 = 2000,

    args                  =
    {
      selector            =
      { type              = "select",
        width             = 2,
        name              = function() return Browsing and Browsing:GetName() or "" end,
        order             = 2100,
        values            = generateHashTable,
        get               = function() return Fonts[Browsing] and Browsing:GetName() or "Morpheus" end,
        set               = function(info, value) Browsing = Fonts[value] end,
      },

      spacer              = { type = "description", width = 0.1, name = " ", order = 2101, },

      showPreview         =
      { type              = "toggle",
        width             = 0.75,
        name              = "Show Preview",
        order             = 2102,
        get               = function() return not db.HidePreview end,
        set               = function(info, value) db.HidePreview = not value end,
        desc              = "Choose whether to show or hide the text preview.",
      },

      previewBox          =
      { type              = "group",
        inline            = true,
        name              = "Font Preview",
        order             = 2200,
        hidden            = function() return db.HidePreview end,
        args              =
        { preview         =
          { type          = "input",
            width         = "full",
            dialogControl = "RPF_FontPreviewEditBox",
            get           = function() return PreviewText or (Browsing and Browsing:GetName()) end,
            set           = function(info, value) PreviewText = value end,
            name          = function() return Browsing:GetName() end,
            order         = 2101,
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
            name          = function() return Browsing and Browsing:FormatListforDisplay("addon", "\n") or "" end,
            order         = 2402,
            width         = 1,
            fontSize      = "medium",
          },

          newline         = newline(2403),

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
        },
      },

      -- fontLicense         = buildLicenseSection(),
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

  for fontName, font in pairs(Fonts) 
  do  local font_args = font:GetOptionsTableArgs()
      for k, v in pairs(font_args) do args[k] = v end;
  end;

  -- second pass, for displaying in order:
  table.sort(keys);

  for i, keys in ipairs(keys)
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
    local num = 0; for _, _ in pairs(LSM:HashTable("font")) do num = num + 1; end; return num;
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
        name                  = function() return yellow(LSM:GetDefault("font") or "none") end,
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
        name                  = function() return yellow(LSM:GetGlobal("font") or "none") end,
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
            values            = function() return LSM:HashTable("font") end,
            dialogControl     = "LSM30_Font",
            name              = "Test Widget",
            order             = 8200,
            width             = 2,
            get               = function() return SandboxFont or LSM:GetDefault("font") end,
            set               = function(info, value) SandboxFont = value               end,
            desc              = "This doesn't really do anything, but it's here in case you " ..  
                                "need to confirm whether fonts were added to or removed from " ..  
                                "LibSharedMedia. Or you can just look at the fonts."
          },
          previewBox          = 
          { type              = "input",
            width             = "full",
            dialogControl     = "RPF_FontPreviewEditBox",
            get               = function() return     SandboxText or SandboxFont         end,
            set               = function(info, value) SandboxText = value                   end,
            name              = function() return     SandboxFont or LSM:GetDefault("font") end,
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
    },
  };

end;

-- core options ---------------------------------------------------------------------------------------------------------------------
local function buildCoreOptions()

  options                  =
  { type                   = "group",
    name                   = rpFontsTitle,
    order                  = 1,
    childGroups            = "tab",
    args                   =
    { blurb                =
      { type               = "description",
        name               = rpFontsDesc,
        width              = "full",
        order              = 2,
        fontSize           = "medium"
      },

      newline              =
      { type               = "description",
        name               = " ",
        width              = "full",
        order              = 3,
        fontSize           = "medium",
      },

      StatsTotalLeft       =
      { type               = "description",
        name               = hilite("Total Fonts"),
        width              = 1,
        order              = 104,
        fontSize           = "medium",
      },

      StatsTotalRight      =
      { type               = "description",
        name               = function() return normal(Stats.total .. " known")    end,
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
        name               = hilite("New Fonts"),
        width              = 1,
        order              = 201,
        fontSize           = "medium",
        hidden             = function() return (Stats.new == 0)                   end,
      },

      StatsNewRight        =
      { type               = "description",
        name               = function() return green(Stats.new .. " fonts")       end,
        width              = 1,
        order              = 202,
        fontSize           = "medium",
        hidden             = function() return (Stats.new == 0)                   end,
      },

      StatsNewNewline      =
      { type               = "description",
        name               = "",
        width              = "full",
        order              = 203,
        fontSize           = "small",
        hidden             = function() return (Stats.new == 0)                   end,
      },

      StatsActiveLeft      =
      { type               = "description",
        name               = hilite("Active Fonts"),
        width              = 1,
        order              = 301,
        fontSize           = "medium",
        hidden             = function() return (Stats.active == 0)                end,
      },

      StatsActiveRight     =
      { type               = "description",
        name               = function() return yellow(Stats.active .. " fonts")   end,
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
        name               = hilite("Inactive Fonts"),
        width              = 1,
        order              = 401,
        fontSize           = "medium",
        hidden             = function() return (Stats.inactive == 0)              end,
      },

      StatsInactiveRight   =
      { type               = "description",
        name               = function() return yellow(Stats.inactive .. " fonts") end,
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

      StatsDisabledLeft    =
      { type               = "description",
        name               = hilite("Disabled Fonts"),
        width              = 1,
        order              = 501,
        fontSize           = "medium",
        hidden             = function() return (Stats.disabled == 0)              end,
      },

      StatsDisabledRight   =
      { type               = "description",
        name               = function() return yellow(Stats.disabled .. " fonts") end,
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
        name               = hilite("Missing Fonts"),
        width              = 1,
        order              = 601,
        fontSize           = "medium",
        hidden             = function() return (Stats.missing == 0)               end,
      },

      StatsMissingRight    =
      { type               = "description",
        name               = function() return yellow(Stats.missing .. " fonts")  end,
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
  for fontName, fontFile in pairs(LSM:HashTable("font"))
  do  local font, data, addon, file = makeFont(fontName, fontFile)
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

-- main --------------------------------------------------------------------------------------------------------------------------------
--
local function main()
  restoreSavedData();
  scanForFonts();
  applyCachedData();
  cycleThroughFonts();
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
