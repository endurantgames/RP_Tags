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
local col = { 0.2, 1.5, 1, 0.5 };
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

local function notify(...) print("[" .. rpFontsTitle .. "]", ...) end;

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
           then font.active = "YES";
                LibSharedMedia:Register("font", font.name, file);
                _ = db.initialized and notify("Font " .. font.name .. " set to active.");
                db.Stats.active = db.Stats.active + (db.initialized and 1 or 0);
                db.Stats.inactive = db.Stats.inactive + (db.initialized and -1 or 0);
                return;
           end;
         end;
  else font.active = "NO";
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
      print(files[#files]);
  end;

  return table.concat(files, delim or ", ")
end;

local function newline(template_or_order) 
  local newline = {};
  if type(template_or_order) == "table" then newline = template_or_order; end;

  local newline = template or {};
  newline["name"] = newline.name or " ";
  newline["type"] = "description";

  if type(template_or_order) == "number"
  then newline["order"] = template_or_order
  else newline["order"] = newline.order or 1;
  end;

  newline["fontSize"] = newline.fontSize or "small";
  return newline;
end;

local function addFontToDatabase(fontName, fontFile)
  local db = _G["RP_FontsDB"];
  if not db.Fonts[fontNane] 
  then   db.Fonts[fontName] = {}
         db.Stats.new = db.Stats.new + (db.initialized and 0 or 1);
  end;

  local font = db.Fonts[fontName]
  font.name  = font.name or fontName;
  font.file  = font.file   or {};
  font.addon = font.addon or {};

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

   font.firstSeen = font.firstSeen or time();
   font.lastSeen  = time();

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
  db.Fonts        = db.Fonts or {};

  db.BrowserSelect = "Morpheus";
  db.PreviewText = nil;

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
  local db = _G["RP_FontsDB"];
  -- load any data that we had cached prior to the DB loading
  if   ns.RP_Fonts.tmp
  then for fontName, fontData in pairs(ns.RP_Fonts.tmp)
       do   for field, value  in pairs(fontData)
            do  db.Fonts[fontName] = db.Fonts[fontName] or {};
                db.Fonts[fontName].field = value;
                print("adding data for " .. fontName);
            end;
       end;
  end;
  ns.RP_Fonts.tmp = nil;
end;

local function activateOrDeactivateFonts()
  local db = _G["RP_FontsDB"];
  -- activate or deactive fonts
  for name, font in pairs(db.Fonts)
  do  if     font.missing    then setFontStatus(font, false);
      elseif font.disabled   then setFontStatus(font, false);
      elseif font.inactive   then setFontStatus(font, false);
      elseif not font.loaded then setFontStatus(font, false);
      else                        setFontStatus(font, true );
      end;
  end;
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
    { previewBox =
      { type = "group",
        inline = true,
        name = "Font Preview",
        order = 2200,
        hidden = function() return db.HidePreview end,
        args =
        { preview =
          { type = "input",
            width = "full",
            dialogControl = "RPF_FontPreviewEditBox",
            get = function() return db.PreviewText or db.BrowserSelect end,
            set = function(info, value) db.PreviewText = value end,
            name = function() return db.BrowserSelect end,
            order = 2101,
            desc = "Click to set custom sample text to display.",
          },
        },
      },
  
      selector = 
      { type = "select",
        width = 2,
        name = function() return db.BrowserSelect end,
        order = 2100,
        values = function() return LibSharedMedia:HashTable("font") end,
        dialogControl = "LSM30_Font",
        get = function() return db.BrowserSelect or "Morpheus" end,
        set = function(info, value) db.BrowserSelect = value end,
      },

      spacer =
      { type = "description",
        width = 0.1,
        name = " ",
        order = 2101,
      },
      showPreview = 
      { type = "toggle",
        width = 0.75,
        name = "Show Preview",
        order = 2102,
        get = function() return not db.HidePreview end,
        set = function(info, value) db.HidePreview = not value end,
        desc = "Choose whether to show or hide the text preview.",
      },

      source =
      { type = "group",
        name = "Source",
        order = 2400,
        inline = true,
        args =
        { fontAddOnLeft =
          { type = "description",
            name = yellow("Source Addon(s)"),
            order = 2401,
            width = 1,
            fontSize = "medium",
          },
  
          fontAddOnRight =
          { type = "description",
            name = function() return makeAddonList(db.Fonts[db.BrowserSelect], "\n"); end,
            order = 2402,
            width = 1,
            fontSize = "medium",
          },
  
          newline = newline(2403),

          fontFileLeft =
          { type = "description",
            name = yellow("File Location(s):"),
            order = 2501,
            width = "full",
            fontSize = "medium",
          },
          fontFileRight =
          { type = "description",
            name = function() return makeFileList(db.Fonts[db.BrowserSelect], "\n"); end,
            order = 2502,
            width = "full",
            fontSize = "small",
          },
        },
      },
      
      fontLicense = buildLicenseSection(),
    },
  };
        
  options.args.fontBrowser = fontBrowser;
end;

local function buildDataTable()
  local db = _G["RP_FontsDB"];
  local keys = {};

  local dataTable = 
  { name = "Font List",
    type = "group",
    order = 1000,
  };

  local args =
  { columnActive =
    { type = "description",
      name = "",
      width = col[1],
      order = 1001,
      fontSize = "medium",
    },

    columnName = 
    { type = "description",
      name = "|cffffff00Font Name|r",
      width = col[2],
      order = 1002,
      fontSize = "medium",
    },

    columnAddOn =
    { type = "description",
      name = "|cffffff00Source AddOn(s)|r",
      width = col[3],
      order = 1003,
      fontSize = "medium",
    },

    columnNewline = newline(1005),
  };

  local function buildDataTableLine(font)
    args[font.name .. "_Active"] =
    { type     = "toggle",
      name     = "",
      width    = col[1],
      get      = function() return (font.active == "YES") end,
      set      = function(info, value) setFontStatus(font, value) end,
      disabled = function() return font.missing end,
    };
  
    args[font.name .. "_Name"] =
    { type = "description",
      name = function() return font.missing  and red(font.name)
                            or font.disabled and gray(font.name)
                            or font.manual   and green(font.name)
                            or font.builtin  and bluzzard(font.name)
                            or font.name
                        end,
      width = col[2],
      fontSize = "medium",
    };
  
    args[font.name .. "_AddOn"] =
    { type = "description",
      name = function() return makeAddonList(font, ", ") end,
      width = col[3],
      fontSize = "medium",
    };
  
    args[font.name .. "_Newline"] =
    { type = "description",
      name = "",
      width = "full",
      fontSize = "small",
    };

    args[font.name .. "_Details"] =
    { type = "execute",
      name = "Details",
      width = col[4],
      func = function() db.BrowserSelect = font.name; AceConfigDialog:SelectGroup(addOnName, "fontBrowser") end,
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
     args[key .. "_Newline"  ].order = 1000 + i * 10 + 5;

     local font = db.Fonts[key];

     if     font.missing  then db.Stats.missing  = db.Stats.missing  + 1;
     elseif font.disabled then db.Stats.disabled = db.Stats.disabled + 1;
     elseif font.inactive then db.Stats.inactive = db.Stats.inactive + 1;
     else                      db.Stats.active   = db.Stats.active   + 1;
     end;
     db.Stats.total = db.Stats.total + 1;
  end;

  dataTable.args = args;

  options.args.dataTable = dataTable;
end;

local function applyUseFontsSlashCommand(info, value)
  local db = _G["RP_FontsDB"];
  db.Settings.UseFontsSlashCommand = value; 
  _G["SLASH_RPFONTS3"] = value and "/fonts" or nil
end;

local function applyLoadDisabledFonts(info, value)
  local db = _G["RP_FontsDB"];
  db.Settings.LoadDisabledFonts = value;
  if   value 
  then 
    for fontName, font in pairs(db.Fonts)
    do  if   font.disabled and font.active == "NO"
        then for _, file in font.file
             do  LibSharedMedia:Register("font", font.name, font.file);
                 font.active = "YES";
             end;
        end;
    end;
  else
    for fontName, font in pairs(db.Fonts)
    do  if   font.disabled and font.active == "YES"
        then 
        for _, file in font.file
             do  LibSharedMedia:Register("font", font.name, font.file);
                 font.active = "YES";
             end;
        end;
    end;

  end;
end;

local function applyManuallyAddFont(info, value)
  local db = _G["RP_FontsDB"];
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
  font.firstSeen = time();
  font.lastSeen = time();

  notify("Font " .. yellow(fontName) .. " has been added.");
end;

local function buildSettingsPanel()
  local db = _G["RP_FontsDB"];
  local settings =
  { name = "Settings",
    type = "group",
    order = 3000,
    args = 
    { useFontsSlash = 
      { type = "toggle",
        name = "Enable /fonts command",
        desc = "By default, only the /rpfonts command is active. You can choose to use /fonts as well.",
        get = function() return db.Settings.UseFontsSlashCommand end,
        set = applyUseFontsSlashCommand,
        order = 3001,
        width = 1.5,
      },
      loadDisabledFonts =
      { type = "toggle",
        name = "Load fonts from disabled addons",
        desc = "If " .. rpFontsTitle .. " has recorded a font from another addon and the addon is still installed, it can load the font even if the addon itself is disabled.",
        get = function() return db.Settings.LoadDisabledFonts end,
        set = applyLoadDisabledFonts,
        order = 3002,
        width = 1.5,
      },
      manuallyAddFont =
      { type = "input",
        name = "Manually enter a font",
        desc = "You can manually enter the path to a font to add it to LibSharedMedia.",
        get = function() return "Interface\\AddOns\\" end,
        set = applyManuallyAddFont,
        order = 3003,
        width = "full",
      },
    },
  };
  
  options.args.settings = settings;
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

      StatsDisabledNewline = 
      { type = "description",
        name = "",
        width = "full",
        order = 503,
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

    },
  };
end;

local function registerSlashCommand()
  local db = _G["RP_FontsDB"];
  _G["SLASH_RPFONTS1"] = "/rpfonts";
  _G["SLASH_RPFONTS2"] = "/rpfont";

  if db.Settings.UseFontsSlashCommand then _G["SLASH_RPFONTS3"] = "/fonts"; end;
  
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
           registerOptions();
           registerSlashCommand();
    end;
  end
);
