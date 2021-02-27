-- RP Fonts
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International (CC BY 4.0) license.

local addOnName, ns = ...;

ns.RP_Fonts = ns.RP_Fonts or {};
ns.RP_Fonts.tmp = ns.RP_Fonts.tmp or {};

local LibSharedMedia  = LibStub("LibSharedMedia-3.0");
local AceConfig       = LibStub("AceConfig-3.0");
local AceConfigDialog = LibStub("AceConfigDialog-3.0");

-- Do we have RP_Tags?
local _, _, _, rpTagsLoadable, rpTagsReason = GetAddOnInfo("RP_Tags")

if not rpTagsLoadable and (rpTagsReason == "MISSING" or rpTagsReason == "DISABLED")
then   rpTags = false;
else   rpTags = true; -- hey we do have RPTAGS!
end;

local rpFontsTitle = GetAddOnMetadata(addOnName, "Title");
local rpFontsDesc  = GetAddOnMetadata(addOnName, "Notes");

-- constants
local col = { 0.15, 1, 1, 0.65, 0.5 };
local BUILTIN = "Built-in font";
local MANUAL = "Manually added";

-- Utility functions
--
local function stripcolor(str) return str:gsub("|cff%x%x%x%x%x%x", ""):gsub("|r", "")      end;
local function     grey(  str) return  DISABLED_FONT_COLOR_CODE .. stripcolor(str) .. "|r" end;
local function      red(  str) return       RED_FONT_COLOR_CODE .. stripcolor(str) .. "|r" end;
local function   yellow(  str) return    YELLOW_FONT_COLOR_CODE .. stripcolor(str) .. "|r" end;
local function    green(  str) return     GREEN_FONT_COLOR_CODE .. stripcolor(str) .. "|r" end;
local function bluzzard(  str) return BATTLENET_FONT_COLOR_CODE .. stripcolor(str) .. "|r" end;
local function   hilite(  str) return HIGHLIGHT_FONT_COLOR_CODE .. stripcolor(str) .. "|r" end;
local function   normal(  str) return    NORMAL_FONT_COLOR_CODE .. stripcolor(str) .. "|r" end;

local db;
local options;

local function notify(...)
  print("[" .. rpFontsTitle .. "]", ...)
end;

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
  if font.missing or not(font.loaded or font.disabled and db.Settings.LoadDisabledFonts) then return end;

  if   value 
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
      else   table.insert(addons, normal(GetAddOnMetadata(name, "Title")))
      end;
   end;

   return table.concat(addons, delim or ", ")
end;

local function makeFileList(font, delim)
  local files = {}

  for name, file in pairs(font.file)
  do  if     file.addon == BUILTIN
      then   table.insert(files, bluzzard(file))
      elseif file.addon == MANUAL
      then   table.insert(files, yellow(file))
      elseif file.missing
      then   table.insert(files, red(file))
      elseif file.disabled and not db.Settings.LoadDisabledFonts
      then   table.insert(files, grey(file))
      else   table.insert(files, file);
      end;
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

   -- We use "YES"/NO" instead of true/false, so we can do things like this:
   font.active = font.active or "YES";

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

  if not _G["RP_FontsDB"] then _G["RP_FontsDB"] = {} end;
  db              = _G["RP_FontsDB"];
  db.Fonts        = db.Fonts or {};

  db.DetailSelect = db.DetailSelect or "Morpheus";

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

  return db;

end;

local function scanForFonts()
  -- Get existing fonts from LSM, store them in our master list
  for fontName, fontFile in pairs(LibSharedMedia:HashTable("font"))
  do  local font = addFontToDatabase(fontName, fontFile);
  end;

local function applyCachedFontData()
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

local function activateOrDeactiveFonts()
  -- activate or deactive fonts
  for name, font in pairs(db.Fonts)
  do  print("setting", name, "to", font.active);
      setFontStatus(font, font.active == "YES")
  end;
end;

local function buildFontDetails()

  local function licenseAuthorNotKnown() local font = db.Fonts[db.DetailSelect]; return not font.license.person and not font.license.company; end;

  local function licenseAuthorDetails()
    local license = db.Fonts[db.DetailSelect].licence;
    local text = "Copyright ";
    if license.date then text = text .. license.date .. " " end;
    if   license.person 
    then text = text .. license.person .. " ";
         if license.personEmail then text = text .. "<" .. license.personEmail .. ">" 
            if license.personUrl then text = text .. ", " else text = text .. " "; end;
            end;
         if license.personUrl then text = text .. "<" .. license.personUrl .. "> " end;
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
       
  local fontDetails =
  { name = "Font Details",
    type = "group",
    order = 5,

    args = 
    { header =
      { type = "description",
        width = "full",
        name = function() return hilite(db.DetailSelect) end,
        order = 1,
        fontSize = "large",
      },
  
      headerNewline = newline(2), 
        
      selector = 
      { type = "select",
        width = 2,
        name = "Font Details",
        order = 3,
        values = function() return LibSharedMedia:HashTable("font") end,
        dialogControl = "LSM30_Font",
        get = function() return db.DetailSelect or "Morpheus" end,
        set = function(info, value) db.DetailSelect = value end,
      },
  
      selectorNewline = newline(4),
  
      fontNameLeft =
      { type = "description",
        name = "Font Name",
        order = 11,
        width = 1,
        fontSize = "medium",
      },
  
      fontNameRight =
      { type = "description",
        name = function() return db.Fonts[db.DetailSelect].name end,
        order = 12,
        width = 2,
        fontSize = "medium",
      },
  
      fontNameNewline = newline(13),
  
      fontAddOnLeft =
      { type = "description",
        name = hilite("Source Addon(s)"),
        order = 21,
        width = 1,
        fontSize = "medium",
      },
  
      fontAddOnRight =
      { type = "description",
        name = function() return makeAddonList(db.Fonts[db.DetailSelect], "\n"); end,
        order = 22,
        width = 2,
        fontSize = "medium",
      },
  
      fontAddOnNewline = newline(23),
  
      fontFileLeft =
      { type = "description",
        name = hilite("File Location(s)"),
        order = 31,
        width = 1,
        fontSize = "medium",
      },
      fontFileRight =
      { type = "description",
        name = function() return makeAddonList(db.Fonts[db.DetailSelect], "\n"); end,
        order = 32,
        width = 2,
        fontSize = "medium",
      },
      fontFileNewline = newline(33),
  
      fontLicenceSection =
      { type = "group",
        inline = true,
        order = 41,
        name = "License",
        hidden = function() return not db.Fonts[db.DetailSelect].license end,
        args =
        { licenceLicenseLeft =
          { type = "description",
            name = "License",
            order = 1,
            width = 1,
            hidden = function() return not db.Fonts[db.DetailSelect].licence.license end,
          },
          
          licenseLicenseRight =
          { type = "description",
            name = function() return db.Fonts[db.DetailSelect].license.license end,
            order = 2,
            width = 2,
            hidden = function() return not db.Fonts[db.DetailSelect].licence.license end,
          },
  
          licenseLicenseNewline = newline({ hidden = function() return not db.Fonts[db.DetailSelect].licence.license end, order = 3 }),
  
          licenseReservedFontnameLeft =
          { type = "description",
            name = "Official Font Name",
            order = 4,
            width = 1,
            hidden = function() return not db.Fonts[db.DetailSelect].license.reservedFontName end,
          },
          licenseReservedFontNameRight =
          { type = "description",
            name = function() return '"' .. (db.Fonts[db.DetailSelect].license.reservedFontName or "") .. '"' end,
            order = 5,
            width = 2,
            hidden = function() return not db.Fonts[db.DetailSelect].license.reservedFontName end,
          },
          licenseReservedFontNameNewline = newline( { hidden = function() return not db.Fonts[db.DetailSelect].license.reservedFontName end, order = 6}),
  
          licenseAuthorLeft =
          { type = "description",
            name = "Author",
            order = 7,
            width = 1,
            hidden = licenseAuthorNotKnown,
          },
          licenseAuthorRight =
          { type = "description",
            name = licenseAuthorDetails,
            order = 8,
            width = 2,
            hidden = licenseAuthorNotKnown,
          },
          licenseAuthorNewline = newline( { hidden = licenseAuthorNotKnown, order = 9 }),
        },
      },
    },
  },
        
  options.data.fontDetails = fontDetails;
end;

local function buildDataTable()
  local keys = {};

  local 
  dataTable = 
  { name = "Font List",
    type = "group",
    order = 18,
    args =
    { columnActive =
      { type = "description",
        name = "",
        width = col[1],
        order = 11,
        fontSize = "small",
      },
  
      columnName = 
      { type = "description",
        name = "|cffffff00Font Name|r",
        width = col[2],
        order = 12,
        fontSize = "small",
      },
  
      columnAddOn =
      { type = "description",
        name = "|cffffff00Source AddOn(s)|r",
        width = col[3],
        order = 13,
        fontSize = "small",
      },
  
      columnFirstRecorded =
      { type = "description",
        name = "|cffffff00First Recorded|r",
        width = col[4],
        order = 14,
        fontSize = "small",
      },
  
      columnNewline = newline(15),
    },
  };
  
  local function buildDataTableLine(font)
    dataTable[font.name .. "_Active"] =
    { type     = "toggle",
      name     = "",
      width    = col[1],
      get      = function() return (font.active == "YES") end,
      set      = function(info, value) setFontStatus(font, value) end,
      disabled = function() return font.missing end,
    };
  
    dataTable[font.name .. "_Name"] =
    { type = "description",
      name = function() return font.missing and red(font.name)
                            or font.disabled and gray(font.name)
                            or font.manual and green(font.name)
                            or font.builtin and bluzzard(font.name)
                            or normal(font.name)
                        end,
      width = col[2],
      fontSize = "small",
    };
  
    dataTable[font.name .. "_AddOn"] =
    { type = "description",
      name = function() return makeAddonList(font, ", ") end,
      width = col[3],
      fontSize = "small",
    };
  
    dataTable[font.name .. "_FirstSeen"] =
    { type = "description",
      name = function() return date("%c", font.firstSeen) end,
      width = col[4],
      fontSize = "small",
    };
   
    dataTable[font.name .. "_Newline"] =
    { type = "description",
      name = "",
      width = "full",
      fontSize = "small",
    };

    table.insert(keys, font.name);

  end;

  for fontName, font in pairs(db.Fonts) do buildDataTableLine(font); end;

  -- second pass, for displaying in order:
  
  table.sort(keys);

  for i, key in ipairs(keys)
  do dataTable[key .. "_Active"   ].order = 100 + i * 10 + 1;
     dataTable[key .. "_Name"     ].order = 100 + i * 10 + 2;
     dataTable[key .. "_AddOn"    ].order = 100 + i * 10 + 3;
     dataTable[key .. "_FirstSeen"].order = 100 + i * 10 + 4;
     dataTable[key .. "_Newline"  ].order = 100 + i * 10 + 5;

     local font = db.Fonts[key];

     if     font.missing  then db.Stats.missing  = db.Stats.missing  + 1;
     elseif font.disabled then db.Stats.disabled = db.Stats.disabled + 1;
     elseif font.inactive then db.Stats.inactive = db.Stats.inactive + 1;
     else                      db.Stats.active   = db.Stats.active   + 1;
     end;
     db.Stats.total = db.Stats.total + 1;
  end;

  options.args.dataTable = dataTable;
  return dataTable;
end;

local function applyUseFontsSlashCommand(info, value)
  db.Settings.UseFontsSlashCommand = value; 
  _G["SLASH_RPFONTS3"] = value and "/fonts" or nil
end;

local function applyLoadDisabledFonts(info, value)
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
  local settings =
  { name = "Settings",
    type = "group",
    order = 20,
    args = 
    { useFontsSlash = 
      { type = "toggle",
        name = "Enable /fonts command",
        desc = "By default, only the /rpfonts command is active. You can choose to use /fonts as well.",
        get = function() return db.Settings.UseFontsSlashCommand end,
        set = applyUseFontsSlashCommand,
        order = 1,
        width = 1.5,
      },
      loadDisabledFonts =
      { type = "toggle",
        name = "Load fonts from disabled addons",
        desc = "If " .. rpFontsTitle .. " has recorded a font from another addon and the addon is still installed, it can load the font even if the addon itself is disabled.",
        get = function() return db.Settings.LoadDisabledFonts end,
        set = applyLoadDisabledFonts,
        order = 2,
        width = 1.5,
      },
      manuallyAddFont =
      { type = "input",
        name = "Manually enter a font",
        desc = "You can manually enter the path to a font to add it to LibSharedMedia.",
        get = function() return "Interface\\AddOns\\" end,
        set = applyManuallyAddFont,
        order = 3,
        width = "full",
      },
    },
  };
  
  options.args.settings = settings;
end;

local function buildCoreOptions()
  -- Create an options panel
  --
  options =
  { type = "group",
    name = rpFontsTitle,
    order = 100,
    childGroups = "tab",
    args = 
    { blurb =
      { type = "description",
        name = rpFontsDesc,
        width = "full",
        order = 2,
        fontSize = "medium" 
      },

      blankLine =
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
        order = 4,
        fontSize = "medium",
      },
      StatsTotalRight =
      { type = "description",
        name = function() return normal(db.Stats.total .. " known") end,
        width = 1,
        order = 5,
        fontSize = "medium",
      },
      StatsTotalNewline = newline(6),

      StatsNewLeft =
      { type = "description",
        name = hilite("New Fonts"),
        width = 1,
        order = 7,
        fontSize = "medium",
        hidden = function() return (db.Stats.new == 0) end,
      },
      StatsNewRight =
      { type = "description",
        name = function() return green(db.Stats.new .. " fonts") end,
        width = 1,
        order = 8,
        fontSize = "medium",
        hidden = function() return (db.Stats.new == 0) end,
      },
      StatsNewNewline = newline({ order = 9, hidden = function () return (db.Stats.new == 0) end } ),

      StatsActiveLeft =
      { type = "description",
        name = hilite("Active Fonts"),
        width = 1,
        order = 10,
        fontSize = "medium",
        hidden = function() return (db.Stats.active == 0) end,
      },
      StatsActiveRight =
      { type = "description",
        name = function() return yellow(db.Stats.active .. " fonts") end,
        width = 1,
        order = 11,
        fontSize = "medium",
        hidden = function() return (db.Stats.active == 0) end,
      },

      StatsActiveNewline = newline({ order = 12, hidden = function () return (db.Stats.active == 0) end } ),

      StatsDisabledLeft =
      { type = "description",
        name = hilite("Disabled Fonts"),
        width = 1,
        order = 13,
        fontSize = "medium",
        hidden = function() return (db.Stats.disabled == 0) end,
      },
      StatsDisabledRight =
      { type = "description",
        name = function() return yellow(db.Stats.disabled .. " fonts") end,
        width = 1,
        order = 14,
        fontSize = "medium",
        hidden = function() return (db.Stats.disabled == 0) end,
      },
      StatsDisabledNewline = newline({ order = 15, hidden = function () return (db.Stats.disabled == 0) end } ),

    },
  };
end;

local function registerSlashCommand()
  _G["SLASH_RPFONTS1"] = "/rpfonts";
  _G["SLASH_RPFONTS2"] = "/rpfont";

  if db.Settings.UseFontsSlashCommand then _G["SLASH_RPFONTS3"] = "/fonts"; end;
  
  SlashCmdList["RPFONTS"] = 
    function() 
      InterfaceOptionsFrame:Show();
      InterfaceOptionsFrame_OpenToCategory(rpFontsTitle);
      -- InterfaceOptionsFrame_OpenToCategory(addOnName);
    end;

end;

local function main()
  initializeDatabase();
  readDatabase();
  local options = buildOptions();


  AceConfig:RegisterOptionsTable(  addOnName, options);
  AceConfigDialog:AddToBlizOptions(addOnName, rpFontsTitle);

  registerSlashCommand();

  db.initialized = true;
end;

local waitingFrame = CreateFrame("Frame");
waitingFrame:RegisterEvent("ADDON_LOADED");
waitingFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
waitingFrame:SetScript("OnEvent", 
  function(self, event, addOnLoaded, ...)
    if     event == "ADDON_LOADED" and addOnLoaded == addOnName
    then   initializeDatabase();
    elseif event == "PLAYER_ENTERING_WORLD"
    then   scanForFonts();
           applyCachedFontData();
           activateOrDeactivateFonts();
           buildOptions();
           AceConfig:RegisterOptionsTable(  addOnName, options);
           AceConfigDialog:AddToBlizOptions(addOnName, rpFontsTitle);
           registerSlashCommand();
    end;
  end
);

