-- RP Fonts
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International (CC BY 4.0) license.

local addOnName, ns = ...;

ns.RP_Fonts = ns.RP_Fonts or {};
ns.RP_Fonts.tmp = ns.RP_Fonts.tmp or {};

local LibSharedMedia    = LibStub("LibSharedMedia-3.0");
local AceConfig         = LibStub("AceConfig-3.0");
local AceConfigDialog   = LibStub("AceConfigDialog-3.0");
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0");

local waitingFrame = CreateFrame("Frame");
waitingFrame:RegisterEvent("ADDON_LOADED");
waitingFrame:RegisterEvent("PLAYER_ENTERING_WORLD");

local rpFontsTitle = GetAddOnMetadata(addOnName, "Title");
local rpFontsDesc  = GetAddOnMetadata(addOnName, "Notes");

-- constants
local col = { 0.2, 1.5, 1.1, 0.5 };
local BUILTIN = "Built-in font";
local MANUAL = "Manually added";

-- general utilities
--
local function stripcolor(str) return str:gsub("|cff%x%x%x%x%x%x", ""):gsub("|r", "") end;

local function     grey(  str) return  DISABLED_FONT_COLOR_CODE .. stripcolor(str) .. "|r" end;
local function      red(  str) return       RED_FONT_COLOR_CODE .. stripcolor(str) .. "|r" end;
local function   yellow(  str) return    YELLOW_FONT_COLOR_CODE .. stripcolor(str) .. "|r" end;
local function    green(  str) return     GREEN_FONT_COLOR_CODE .. stripcolor(str) .. "|r" end;
local function bluzzard(  str) return BATTLENET_FONT_COLOR_CODE .. stripcolor(str) .. "|r" end;
local function   hilite(  str) return HIGHLIGHT_FONT_COLOR_CODE .. stripcolor(str) .. "|r" end;
local function   normal(  str) return    NORMAL_FONT_COLOR_CODE .. stripcolor(str) .. "|r" end;
local function    white(  str) return              "|cffffffff" .. stripcolor(str) .. "|r" end;

local function notify(...) print("[" .. rpFontsTitle .. "]", ...) end;

local function colorName(font)
  return font.builtin  and bluzzard( font.name )
      or font.new      and green(    font.name )
      or font.active   and yellow(   font.name )
      or font.inactive and  white(   font.name )
      or font.disabled and grey(     font.name )
      or font.missing  and red(      font.name )
      or font.name;
end;

-- options
--
local options;

local function registerOptions()
  AceConfigRegistry:RegisterOptionsTable(addOnName, options);
  AceConfig:RegisterOptionsTable(  addOnName, options);
  AceConfigDialog:AddToBlizOptions(addOnName, rpFontsTitle);
end;

local function updateOptions() AceConfigRegistry:NotifyChange(addOnName); end;

local function getAddonFromPath(path) return path:match("^[iI]nterface\\[aA]dd[oO]ns\\(.-)\\") or BUILTIN; end;

local function isAddonLoaded(name)
  if name == BUILTIN or name == MANUAL then return true end;
  local _, _, _, isLoadable, reason = GetAddOnInfo(name);
  if   not isLoadable 
  then return false, reason;
  else return true;
  end;
end;

local function setFontStatus(font, value) 
  local db = _G["RP_FontsDB"];
  if font.missing or not(font.loaded or font.disabled and db.Settings.LoadDisabledFonts) then return end;

  if   value == true
  then for fileName, file in pairs(font.file)
       do  if   file.loaded or file.disabled
           then font.active = true;
                font.inactive = false;
                LibSharedMedia:Register("font", font.name, file);
                _ = db.initialized and notify("Font " .. font.name .. " set to active.");
                db.Stats.active = db.Stats.active + (db.initialized and 1 or 0);
                db.Stats.inactive = db.Stats.inactive + (db.initialized and -1 or 0);
                return;
           end;
         end;
  else font.active = false;
       font.inactive = true; 
       LibSharedMedia.MediaTable.font[font.name] = nil;
       _ = db.initialized and notify("Font " .. font.name .. " set to inactive.");
       db.Stats.inactive = db.Stats.inactive + (db.initialized and 1 or 0);
       db.Stats.active = db.Stats.active + (db.initialized and -1 or 0);
       return;
  end;
  _ = db.initialized and notify("Unable to set font " .. font .. " to " .. (value and "" or "in") .. "active.");
end;

local function makeAddonList(font, delim)
  local addons = {};

  for name, addon in pairs(font.addon)
  do  if     name == BUILTIN
      then   table.insert(addons, bluzzard("Built-in font"))
      elseif name == MANUAL
      then   table.insert(addons, green("Manually added"))
      elseif addon.missing
      then   table.insert(addons, red(name))
      elseif addon.disabled
      then   table.insert(addons,   grey(GetAddOnMetadata(name, "Title")))
      else   table.insert(addons, GetAddOnMetadata(name, "Title"))
      end;
   end;

   return table.concat(addons, delim or ", ")
end;

local function makeFileList(font, delim)
  local db = _G["RP_FontsDB"];
  local files = {}

  for name, file in pairs(font.file)
  do  if     file.addon == BUILTIN
      then   table.insert(files, bluzzard(name))
      elseif file.addon == MANUAL
      then   table.insert(files, yellow(name))
      elseif file.missing
      then   table.insert(files, red(name))
      elseif file.disabled and not db.Settings.LoadDisabledFonts
      then   table.insert(files, grey(name))
      else   table.insert(files, name);
      end;
  end;

  return table.concat(files, delim or ", ")
end;

local function newline(order) return { type = "description", name = "", width = "full", order = order }; end;

local function addFontToDatabase(fontName, fontFile)
  local new;
  local db = _G["RP_FontsDB"];
  if not db.Fonts[fontName] 
  then   db.Fonts[fontName] = {}
         db.Stats.new = db.Stats.new + (db.initialized and 0 or 1);
         new = true;
  end;

  local font = db.Fonts[fontName]
  font.name  = font.name or fontName;
  font.file  = font.file   or {};
  font.addon = font.addon or {};
  font.new   = new;

  local addon = getAddonFromPath(fontFile);
  local loaded, reason = isAddonLoaded(addon);

   font.file[fontFile] =
   { loaded            = loaded,
     reason            = reason,
     addon             = addon,
     disabled          = (reason == "DISABLED"),
     missing           = (reason == "MISSING"),
     builtin           = (addon  == "BUILTIN"),
     manual            = (addon  == "MANUAL"),
     name              = fontFile,
   };

   font.addon[addon] =
   { loaded          = loaded,
     reason          = reason,
     file            = fontFile,
     disabled        = (reason == "DISABLED"),
     missing         = (reason == "MISSING"),
     name            = (loaded or reason == "DISABLED") and GetAddOnMetadata(addon, "Title") or addon,
     builtin         = (addon == "BUILTIN"),
     manual          = (addon == "MANUAL"),
   };

   font.firstSeen = font.firstSeen or db.Stats.now;
   font.lastSeen  = db.Stats.now;

   local loaded, missing, disabled;
   for name, file in pairs(font.file)
   do  if file.loaded   then loaded   = true end;
       if file.missing  then missing  = true end;
       if file.disabled then disabled = true end;
   end;

   font.loaded   = loaded;
   font.missing  = not loaded and missing;
   font.disabled = not loaded and not missing and disabled;

   return font;
end;

local function initializeDatabase()

  _G["RP_FontsDB"] = _G["RP_FontsDB"] or {};
  local db = _G["RP_FontsDB"];
  db.Fonts = db.Fonts or {};

  db.BrowserSelect = db.BrowserSelect or "Morpheus";
  db.PreviewText = nil;
  db.Filter = "none";

  db.Stats        =
  { total         = 0,
    new           = 0,
    missing       = 0,
    active        = 0,
    inactive      = 0,
    disabled      = 0,
    now           = time(),
  };

  db.initialized  = nil;
  db.Settings     = db.Settings or {};

end;

local function scanForFonts()
  -- Get existing fonts from LSM, store them in our master list
  for fontName, fontFile in pairs(LibSharedMedia:HashTable("font"))
  do  local font = addFontToDatabase(fontName, fontFile);
  end;
end;

local function applyCachedFontData()
  -- load any data that we had cached prior to the DB loading
  --
  local db = _G["RP_FontsDB"];
  if   ns.RP_Fonts.tmp
  then for fontName, fontData in pairs(ns.RP_Fonts.tmp)
       do  if    db.Fonts[fontName]
           then

             if not db.Fonts[fontName].inactive and 
                not db.Fonts[fontName].active and
                fontData.active ~= nil
             then 
               db.Fonts[fontName].active = fontData.active;
               db.Fonts[fontName].inactive = not fontData.active;
               print("setting font status to ", fontData.active);
             end;

             if fontData.license
             then
               db.Fonts[fontName].license = fontData.licence;
             end;

          end; -- if db.Fonts
       end; -- for fontName
  end; -- if .tmp
 --  ns.RP_Fonts.tmp = nil;
end;

local function activateOrDeactivateFonts()
  local db = _G["RP_FontsDB"];
  -- activate or deactive fonts
  for name, font in pairs(db.Fonts)
  do  if     font.missing    then setFontStatus(font, false);
      elseif font.inactive   then setFontStatus(font, false);
      elseif not font.loaded then setFontStatus(font, false);
      else                        setFontStatus(font, true );
      end;
  end;
end;

local function generateHashTable()
  local db = _G["RP_FontsDB"];
  local list = {};
  for fontName, font in pairs(db.Fonts)
  do  list[fontName] = font.name
  end;
  return list
end;

local function buildFontBrowser()
  local db = _G["RP_FontsDB"];

  local function buildLicenseSection()

    local function licenseAuthorNotKnown() local font = db.Fonts[db.BrowserSelect]; return not font.license.person and not font.license.company; end;
  
    local function licenseAuthorBrowser()
      local license = db.Fonts[db.BrowserSelect].license;
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
      if db.Fonts[db.BrowserSelected] and db.Fonts[db.BrowserSelected].license
      then return db.Fonts[db.BrowserSelected].license.license or "Unknown"
      else return "Unknown"
      end;
    end;

    local function licenseReservedFontName()
      if db.Fonts[db.BrowserSelected] and db.Fonts[db.BrowserSelected].license
      then return db.Fonts[db.BrowserSelected].license.reservedFontName or db.Fonts[db.BrowserSelected].name or ""
      else return db.Fonts[db.BrowserSelected] and db.Fonts[db.BrowserSelected].name or ""
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
           
  local fontBrowser =
  { name = "Font Browser",
    type = "group",
    order = 2000,

    args = 
    { 
      selector =
      { type   = "select",
        width  = 2,
        name   = function() return db.BrowserSelect end,
        order  = 2100,
        values = generateHashTable,
        get    = function() return db.Fonts[db.BrowserSelect] and db.BrowserSelect or "Morpheus" end,
        set    = function(info, value) db.BrowserSelect = value end,
      },

      spacer = { type = "description", width = 0.1, name = " ", order = 2101, },

      showPreview =
      { type      = "toggle",
        width     = 0.75,
        name      = "Show Preview",
        order     = 2102,
        get       = function() return not db.HidePreview end,
        set       = function(info, value) db.HidePreview                = not value end,
        desc      = "Choose whether to show or hide the text preview.",
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
            get           = function() return db.PreviewText or db.BrowserSelect end,
            set           = function(info, value) db.PreviewText = value end,
            name          = function() return db.BrowserSelect end,
            order         = 2101,
            desc          = "Click to set custom sample text to display.",
          },
        },
      },


      buttonBar =
      { type = "group",
        name = "",
        inline = true,
        order = 2300,
        args =
        { inactive = 
          { type = "execute",
            order = 2301,
            hidden = function() return db.Fonts[db.BrowserSelect].inactive end,
            name = "Set Inactive",
            width = 0.75,
            func = function() setFontStatus(db.Fonts[db.BrowserSelect], false) end,
          },
          active = 
          { type = "execute",
            order = 2302,
            hidden = function() return db.Fonts[db.BrowserSelect].active end,
            name = "Set Active",
            width = 0.75,
            func = function() setFontStatus(db.Fonts[db.BrowserSelect], true) end,
          },
          deleteRecord =
          { type = "execute",
            order = 2303,
            name = "Delete",
            width = 0.75,
            func = function() notify("Why you wanna delete this??") end,
          },
        },
      },

      source   =
      { type   = "group",
        name   = "Source",
        order  = 2400,
        inline = true,
        args   =

        { fontAddOnLeft =
          { type     = "description",
            name     = yellow("Source Addon(s)"),
            order    = 2401,
            width    = 1,
            fontSize = "medium",
          },

          fontAddOnRight =
          { type     = "description",
            name     = function() return makeAddonList(db.Fonts[db.BrowserSelect], "\n"); end,
            order    = 2402,
            width    = 1,
            fontSize = "medium",
          },

          newline = newline(2403),

          fontFileLeft =
          { type     = "description",
            name     = yellow("File Location(s):"),
            order    = 2501,
            width    = 1,
            fontSize = "medium",
          },

          fontFileRight =
          { type     = "description",
            name     = function() return makeFileList(db.Fonts[db.BrowserSelect], "\n"); end,
            order    = 2502,
            width    = 2,
            fontSize = "small",
          },
        },
      },

      fontLicense = buildLicenseSection(),
    },
  };
        
  options.args.fontBrowser = fontBrowser;
end;

local filters  =
{ ["none"]     = "Filter List...",
  ["active"]   = hilite("Active Fonts"),
  ["inactive"] = normal("Inactive Fonts"),
  ["disabled"] = grey("Disabled Fonts"),
  ["missing"]  = red("Missing Fonts"),
  ["new"]      = green("New Fonts"),
};

local filter_desc =
{ [""] = "",
  ["active"] = "Active fonts are those which are loaded into LibSharedMedia and which you can use in any addon that uses LibSharedMedia.",
  ["inactive"] = "Inactive fonts are fonts which could be loaded, but you've chosen to disable them. You can re-enable them at any time.",
  ["disabled"] = "A disabled font was originally registered with LibSharedMedia by an addon that you still have installed, but is currently disabled.",
  ["missing"] = "A missing font was registered with LibSharedMedia by another addon, but you don't have that addon installed, so the font isn't available.",
  ["new"] = "New fonts are fonts which are newly registered with LibSharedMedia since the last time you logged on.", };

local filter_order = { "none", "new", "active", "inactive", "disabled", "missing", };

local function buildDataTable()

  local db        = _G["RP_FontsDB"];
  local keys      = {};
  local dataTable =
  { name          = "Font List",
    type          = "group",
    order         = 700,
  };

  local function showCurrentFilter()
     if   not db.Filter 
          or  db.Filter == "none" 
     then return "All Fonts" 
     else return filters[db.Filter] 
     end
  end;

  local args   =
  { headline   =
    { type     = "description",
      name     = showCurrentFilter,
      width    = col[1] + col[2],
      order    = 900,
      fontSize = "large";
    },

    filters   =
    { type    = "select",
      values  = filters,
      name    = "",
      width   = col[3],
      order   = 910,
      sorting = filter_order,
      get     = function() return db.Filter or "" end,
      set     = function(info, value) db.Filter = value end,
    },

    filtersDescription = 
    { type = "description",
      fontSize = "small",
      name = function() return filter_desc[db.Filter] end,
      order = 920,
      width = col[1] + col[2],
      hidden = function() return db.Filter == "" end,
    },

    filtersNewline = newline(999),

    columnActive =
    { type       = "description",
      name       = "",
      width      = col[1],
      order      = 1001,
    },

    columnName =
    { type     = "description",
      name     = "|cffffff00Font Name|r",
      width    = col[2],
      order    = 1002,
      fontSize = "medium",
    },

    columnAddOn =
    { type      = "description",
      name      = "|cffffff00Source AddOn(s)|r",
      width     = col[3],
      order     = 1003,
      fontSize  = "medium",
    },

    columnNewline = newline(1005),
  };

  local function buildDataTableLine(font)

    local function filter()
      return not (db.Filter == "none") and not db.Fonts[font.name][db.Filter] 
    end;

    args[font.name .. "_Active"] =
    { type     = "toggle",
      name     = "",
      width    = col[1],
      get      = function() return font.active end,
      set      = function(info, value) font.inactive = true; setFontStatus(font, value) end,
      disabled = function() return font.missing end,
      hidden   = filter,
    };

    args[font.name .. "_Name"] =
    { type = "description",
      name = function() return colorName(font) end,
      width = col[2],
      fontSize = "medium",
      hidden = filter,
    };
  
    args[font.name .. "_AddOn"] =
    { type = "description",
      name = function() return makeAddonList(font, ", ") end,
      width = col[3],
      fontSize = "medium",
      hidden = filter,
    };
  
    -- args[font.name .. "_Newline"] = newline();

    local function browseFont()
      db.BrowserSelect = font.name; 
      AceConfigDialog:SelectGroup(addOnName, "fontBrowser") 
    end
    
    args[font.name .. "_Details"] =
    { type = "execute",
      name = "Details",
      desc = "Click to view details about the font " .. colorName(font) .. " in the font browser.",
      width = col[4],
      func = browseFont,
      hidden = filter,
    },
    table.insert(keys, font.name);

  end;

  for fontName, font in pairs(db.Fonts) do buildDataTableLine(font); end;

  -- second pass, for displaying in order:
  table.sort(keys);

  for i, key in ipairs(keys)
  do args[key .. "_Active"   ].order = 1000 + i * 10 + 1;
     args[key .. "_Name"     ].order = 1000 + i * 10 + 2;
     args[key .. "_AddOn"    ].order = 1000 + i * 10 + 3;
     args[key .. "_Details"  ].order = 1000 + i * 10 + 4;

     local font = db.Fonts[key];

     if     font.missing  then db.Stats.missing  = db.Stats.missing  + 1;
     elseif font.disabled then db.Stats.disabled = db.Stats.disabled + 1;
     elseif font.inactive then db.Stats.inactive = db.Stats.inactive + 1;
     else                      db.Stats.active   = db.Stats.active   + 1;
     end;
     db.Stats.total = db.Stats.total + 1;

     if font.new and (db.Stats.now ~= font.firstSeen or font.builtin) then font.new = nil; end;
  end;

  dataTable.args = args;

  options.args.dataTable = dataTable;
end;

local function applyLoadDisabledFonts(info, value)
  local db = _G["RP_FontsDB"];
  db.Settings.LoadDisabledFonts = value;
  if   value 
  then 
    for fontName, font in pairs(db.Fonts)
    do  if   font.disabled and not font.active
        then for _, file in font.file
             do  LibSharedMedia:Register("font", font.name, font.file);
                 font.active = true;
             end;
        end;
    end;
  else
    for fontName, font in pairs(db.Fonts)
    do  if   font.disabled and font.active
        then 
        for _, file in font.file
             do  LibSharedMedia:Register("font", font.name, font.file);
                 font.active = true;
             end;
        end;
    end;

  end;
end;

local function applyManuallyAddFont(info, value)
  local db = _G["RP_FontsDB"];

  value = value:gsub("^.+_retail_\\[iI]nterface","Interface");

  if not value:match(".ttf$") then value = value .. ".ttf"; end;
  local fontName = value:match("\\(.-)%ttf$");
  LibSharedMedia:Register("font", fontName, value);

  db.Fonts[fontName] = db.Fonts[fontName] or {};
  local font = db.Fonts[fontName];
  font.name = font.name or fontName;
  font.file = font.file or {};
  table.insert(font.file, value);
  font.addon = font.addon or {}
  table.insert(font.addon, MANUAL);
  font.firstSeen = db.Stats.now;
  font.lastSeen = db.Stats.now;

  notify("Font " .. yellow(fontName) .. " has been added.");
end;

local function buildLibSharedMediaPanel()
  local db = _G["RP_FontsDB"];

  local function countLSM()
    local num = 0;
    for _, _ in pairs(LibSharedMedia:HashTable("font")) do num = num + 1; end;
    return num;
  end;

  options.args.libSharedMedia =
  { name = "LibSharedMedia",
    type = "group",
    order = 8000,
    args =
    { headline =
      { type = "description",
        fontSize = "large",
        order = 8001,
        name = "LibSharedMedia Status\n\n",
        width = "full",
      },
      countLeft = 
      { type = "description",
        fontSize = "medium",
        order = 8002,
        width = 1,
        name = yellow("Fonts Loaded"),
      },
      countRight =
      { type = "description",
        fontSize = "medium",
        order = 8003,
        width = 1,
        name = white( countLSM() .. " fonts")
      },
      newline = newline(8004),

      globalOverride =
      { type = "group",
        inline = true,
        name = "",
        order = 8200,
        args =
        {
          globalOverrideLeft =
          { type = "description",
            fontSize = "medium",
            order = 8201,
            width = 1,
            name = "Current Global Override",
          },
    
          globalOverrideRight =
          { type = "select",
            values = function() return LibSharedMedia:HashTable("font") end,
            dialogControl = "LSM30_Font",
            name = "",
            order = 8202,
            desc = "You can set the global override that LibSharedMedia will use. Caution, this might not be what you want!",
            get = function() return LibSharedMedia:GetGlobal("font") end,
            set = function(info, value) LibSharedMedia:SetGlobal("font", value) 
                                        db.LibSharedMedia_GlobalUnlocked = false end,
            disabled = function() return not db.LibSharedMedia_GlobalUnlocked end,
          },

          spacer = { type = "description", name = " ", order = 8203, width = 0.2, },

          globalOverrideUnlock =
          { type = "toggle",
            name = "Unlock",
            order = 8204,
            width = 0.75,
            desc = "Click this to unlock the global override for LibSharedMedia.",
            get = function() return db.LibSharedMedia_GlobalUnlocked end,
            set = function(self, value) db.LibSharedMedia_GlobalUnlocked = value end,

          },
        },
      },
      
      defaultFont =
      { type = "group",
        inline = true,
        name = "",
        order = 8100,
        args = 
        { defaultFontLeft =
          { type = "description",
            fontSize = "medium",
            order = 8101,
            width = 1,
            name = "Current Default Font",
          },

          defaultFontRight =
          { type = "select",
            values = function() return LibSharedMedia:HashTable("font") end,
            dialogControl = "LSM30_Font",
            name = "",
            order = 8102,
            desc = "You can set the default font that LibSharedMedia will use if it can't find a font of a specific name.",
            get = function() return LibSharedMedia:GetDefault("font") end,
            set = function(info, value) 
                    LibSharedMedia:SetDefault("font", value) 
                    db.LibSharedMedia_DefaultUnlocked = false 
                  end,
            disabled = function() return not db.LibSharedMedia_DefaultUnlocked end,
          },

          spacer = { type = "description", name = " ", order = 8103, width = 0.2, },

          defaultFontUnlock =
          { type = "toggle",
            name = "Unlock",
            order = 8104,
            desc = "Click this to unlock the default font for LibSharedMedia.",
            get = function() return db.LibSharedMedia_DefaultUnlocked end,
            set = function(self, value) db.LibSharedMedia_DefaultUnlocked = value end,
          },
        },
      },

      testingSandbox =
      { type = "group",
        inline = true,
        name = "Sandbox",
        order = 8500,
        args =
        { fontSelector =
          { type = "select",
            values = function() return LibSharedMedia:HashTable("font") end,
            dialogControl = "LSM30_Font",
            name = "Test Widget",
            order = 8200,
            width = 2,
            get = function() return db.SandboxFont or LibSharedMedia:GetDefault("font") end,
            set = function(info, value) db.SandboxFont = value end,
            desc = "This doesn't really do anything, but it's here in case you need to confirm whether fonts were added or removed from LibSharedMedia."
          },
          previewBox = { type          = "input",
            width         = "full",
            dialogControl = "RPF_FontPreviewEditBox",
            get           = function() return db.SandboxText or db.SandboxFont or LibSharedMedia:GetDefault("font") end,
            set           = function(info, value) db.SandboxText = value end,
            name          = function() return db.SandboxFont or LibSharedMedia:GetDefault("font") end,
            order         = 8202,
            desc          = "Click to set custom sample text to display.",
          },
        },
      },
    },
  };
end;

local function buildSettingsPanel()
  local db = _G["RP_FontsDB"];
  local settings =
  { name = "Settings",
    type = "group",
    order = 9000,
    args = 
    { 
      loadDisabledFonts =
      { type = "toggle",
        name = "Load fonts from disabled addons",
        desc = "If " .. rpFontsTitle .. " has recorded a font from another addon and the addon is still installed, it can load the font even if the addon itself is disabled.",
        get = function() return db.Settings.LoadDisabledFonts end,
        set = applyLoadDisabledFonts,
        order = 9002,
        width = "full",
      },

      -- manuallyAddFont =
      -- { type = "input",
      --   name = "Manually enter a font",
      --   desc = "You can manually enter the path to a font to add it to LibSharedMedia.",
      --   get = function() return "Interface\\AddOns\\Fonts" end,
      --   set = applyManuallyAddFont,
      --   order = 9003,
      --   width = "full",
      -- },

      forceDefault =
      { 
        type = "group",
        inline = true,
        name = "",
        order = 9100,
        args = 
        { forceDefaultFont =
          { type = "toggle",
            name = "Set LSM's default font upon loading",
            width = 2,
            desc = "You can force LibSharedMedia to use a specific font if it can't find a font of another name. " .. rpFontsTitle .. " normally does not do this, but you can enable it here.",
            get = function() return db.Settings.ForceDefaultFont end,
            set = function(info, value) 
                    db.Settings.ForceDefaultFont = value 
                    _ = not value and notify("LibSharedMedia's default font will " .. yellow("not") .. " be set upon loading.")
                    end,
            order = 9100,
          },
    
          defaultFontToForce =
          { type = "select",
            name = "Default Font",
            width = 1,
            values = function() return LibSharedMedia:HashTable("font") end,
            dialogControl = "LSM30_Font",
            get = function() return db.Settings.DefaultFontToForce or LibSharedMedia:GetDefault("font") end,
            set = function(info, value) 
                    db.Settings.DefaultFontToForce = value ;
                    notify("LibSharedMedia's default font " .. green("will") .. " be set upon loading.")
                  end,
            order = 9101,
            disabled = function() return not db.Settings.ForceDefaultFont end,
          },

          resetForceDefaultFont =
          { type = "execute",
            name = "Reset",
            width = 0.5,
            desc = "Reset to the default.",
            order = 9110,
            hidden = function() return not db.Settings.ForceDefaultFont or not db.Settings.DefaultFontToForce  end,
            func = function() 
                     db.Settings.ForceDefaultFont = nil;
                     db.Settings.DefaultFontToForce = nil; 
                     notify("LibSharedMedia's default font will " .. yellow("not") .. " be set upon loading.")
                   end,
          },
        },
      },
      forceGlobal =
      { 
        type = "group",
        inline = true,
        name = "",
        order = 9200,
        args = 
        { forceGlobalFont =
          { type = "toggle",
            name = "Set LSM's global override font upon loading",
            width = 2,
            desc = "You can force LibSharedMedia to return a specific font instead of the font requested. " .. rpFontsTitle .. " normally does not do this, but you can enable it here. " .. red("It's really not a good idea."),
            get = function() return db.Settings.ForceGlobalFont end,
            set = function(info, value) 
                    db.Settings.ForceGlobalFont = value 
                    _ = not value and notify("LibSharedMedia's global override font will " .. yellow("not") .. " be set upon loading.")
                  end,
            order = 9201,
          },
    
          defaultFontToForce =
          { type = "select",
            name = "Global Font",
            width = 1,
            values = function() return LibSharedMedia:HashTable("font") end,
            dialogControl = "LSM30_Font",
            get = function() return db.Settings.GlobalFontToForce or LibSharedMedia:GetGlobal("font") end,
            set = function(info, value) 
                    db.Settings.GlobalFontToForce = value 
                    notify("LibSharedMedia's global override font " .. red("will") .. " be set upon loading.")
                  end,
            order = 9202,
            disabled = function() return not db.Settings.ForceGlobalFont end,
          },

          resetForceDefaultFont =
          { type = "execute",
            name = "Reset",
            width = 0.5,
            desc = "Reset to the default.",
            order = 9210,
            hidden = function() return not db.Settings.ForceGlobalFont or not db.Settings.GlobalFontToForce  end,
            func = function() 
                     db.Settings.GlobalFontToForce = nil; 
                     db.Settings.ForceGlobalFont  = nil;
                     notify("LibSharedMedia's global override font will " .. yellow("not") .. " be set upon loading.")
                   end,
          },

          anotherWarning =
          { type = "description",
            name = red("You can make this change if you want to. However, it's a really bad idea and you should think twice about doing this."),
            order = 9213,
            width = "full",
            fontSize = "medium",
            hidden = function() return not db.Settings.ForceGlobalFont and not db.Settings.GlobalFontToForce end,
          },
        },
      },
    },
  };
  
  options.args.settings = settings;
end;

local POPUP = "RPFONTS_CONFIRMATION_BUTTON";

StaticPopupDialogs["RPFONTS_CONFIRMATION_BUTTON"] =
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
  local db = _G["RP_FontsDB"];
  local num = 0;
  for fontName, font in pairs(db.Fonts)
  do  if font[fontState] then db.Fonts[fontName] = nil;
         num = num + 1;
      end;
  end;
  if   num > 0 
  then notify(num .. " font records deleted.")
  else notify("No font records deleted.");
  end;
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

local function buildCoreOptions()
  local db = _G["RP_FontsDB"];
  -- Create an options panel
  --
  options =
  { type = "group",
    name = rpFontsTitle,
    order = 1,
    childGroups = "tab",
    args = 
    { blurb =
      { type = "description",
        name = rpFontsDesc,
        width = "full",
        order = 2,
        fontSize = "medium" 
      },

      newline =
      { type = "description",
        name = " ",
        width = "full",
        order = 3,
        fontSize = "medium",
      },

      StatsTotalLeft =
      { type = "description",
        name = hilite("Total Fonts"),
        width = 1,
        order = 104,
        fontSize = "medium",
      },

      StatsTotalRight =
      { type = "description",
        name = function() return normal(db.Stats.total .. " known") end,
        width = 1,
        order = 105,
        fontSize = "medium",
      },

      StatsTotalNewline = 
      { type = "description",
        name = "",
        width = "full",
        order = 106,
        fontSize = "small",
      },

      StatsNewLeft =
      { type = "description",
        name = hilite("New Fonts"),
        width = 1,
        order = 201,
        fontSize = "medium",
        hidden = function() return (db.Stats.new == 0) end,
      },

      StatsNewRight =
      { type = "description",
        name = function() return green(db.Stats.new .. " fonts") end,
        width = 1,
        order = 202,
        fontSize = "medium",
        hidden = function() return (db.Stats.new == 0) end,
      },

      StatsNewNewline = 
      { type = "description",
        name = "",
        width = "full",
        order = 203,
        fontSize = "small",
        hidden = function() return (db.Stats.new == 0) end,
      },

      StatsActiveLeft =
      { type = "description",
        name = hilite("Active Fonts"),
        width = 1,
        order = 301,
        fontSize = "medium",
        hidden = function() return (db.Stats.active == 0) end,
      },

      StatsActiveRight =
      { type = "description",
        name = function() return yellow(db.Stats.active .. " fonts") end,
        width = 1,
        order = 302,
        fontSize = "medium",
        hidden = function() return (db.Stats.active == 0) end,
      },

      StatsActiveNewline = 
      { type = "description",
        name = "",
        width = "full",
        order = 303, 
        fontSize = "small",
        hidden = function() return (db.Stats.active == 0) end,
      },

      StatsInactiveLeft =
      { type = "description",
        name = hilite("Inactive Fonts"),
        width = 1,
        order = 401,
        fontSize = "medium",
        hidden = function() return (db.Stats.inactive == 0) end,
      },

      StatsInactiveRight =
      { type = "description",
        name = function() return yellow(db.Stats.inactive .. " fonts") end,
        width = 1,
        order = 402,
        fontSize = "medium",
        hidden = function() return (db.Stats.inactive == 0) end,
      },

      StatsInactiveNewline = 
      { type = "description",
        name = "",
        width = "full",
        order = 403,
        fontSize = "small",
        hidden = function() return (db.Stats.inactive == 0) end,
      },

      StatsDisabledLeft =
      { type = "description",
        name = hilite("Disabled Fonts"),
        width = 1,
        order = 501,
        fontSize = "medium",
        hidden = function() return (db.Stats.disabled == 0) end,
      },

      StatsDisabledRight =
      { type = "description",
        name = function() return yellow(db.Stats.disabled .. " fonts") end,
        width = 1,
        order = 502,
        fontSize = "medium",
        hidden = function() return (db.Stats.disabled == 0) end,
      },

      StatsDisabledPurge =
      { type = "execute",
        name = "Purge",
        width = 0.5,
        order = 503,
        hidden = function() return (db.Stats.disabled == 0) end,
        func = purgeDisabled,
      },

      StatsDisabledNewline = 
      { type = "description",
        name = "",
        width = "full",
        order = 504,
        fontSize = "small",
        hidden = function() return (db.Stats.disabled == 0) end,
      },

      StatsMissingLeft =
      { type = "description",
        name = hilite("Missing Fonts"),
        width = 1,
        order = 601,
        fontSize = "medium",
        hidden = function() return (db.Stats.missing == 0) end,
      },

      StatsMissingRight =
      { type = "description",
        name = function() return yellow(db.Stats.missing .. " fonts") end,
        width = 1,
        order = 602,
        fontSize = "medium",
        hidden = function() return (db.Stats.missing == 0) end,
      },

      StatsMissingNewline = 
      { type = "description",
        name = "",
        width = "full",
        order = 603,
        fontSize = "small",
        hidden = function() return (db.Stats.missing == 0) end,
      },

      StatsMissingPurge =
      { type = "execute",
        name = "Purge",
        width = 0.5,
        order = 503,
        hidden = function() return (db.Stats.missing == 0) end,
        func = purgeMissing,
      },
    },
  };
end;

local function registerSlashCommand()
  local db = _G["RP_FontsDB"];
  _G["SLASH_RPFONTS1"] = "/rpfonts";
  _G["SLASH_RPFONTS2"] = "/rpfont";

  SlashCmdList["RPFONTS"] = 
    function() 
      InterfaceOptionsFrame:Show();
      InterfaceOptionsFrame_OpenToCategory(rpFontsTitle);
    end;

end;

waitingFrame:SetScript("OnEvent", 
  function(self, event, addOnLoaded, ...)
    if     event == "ADDON_LOADED" and addOnLoaded == addOnName
    then   initializeDatabase();
    elseif event == "PLAYER_ENTERING_WORLD"
    then   scanForFonts();
           applyCachedFontData();
           activateOrDeactivateFonts();
           buildCoreOptions();
           buildDataTable()
           buildFontBrowser()
           buildSettingsPanel()
           buildLibSharedMediaPanel()
           registerOptions();
           registerSlashCommand();
    end;
  end
);
