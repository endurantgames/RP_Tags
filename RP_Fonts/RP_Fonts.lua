-- RP Fonts
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license.

local addOnName, ns = ...;

local RP_Fonts = LibStub("AceAddon-3.0"):NewAddon("RP_Fonts");
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
local rpFontsDesc = GetAddOnMetadata(addOnName, "Notes");

-- constants
local col = { 0.15, 1, 1, 0.65, 0.5 };
local BUILTIN = "Builtin, i.e. no addon found in path";

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

local function getAddonFromPath(path)
  return path:match("^Interface\\[aA]dd[oO]ns\\(.-)\\") or BUILTIN;
end;

local function isAddonLoaded(name)
  local _, _, _, isLoadable, reason = GetAddOninfo(name);
  if   not isLoadable 
  then return false, reason;
  else return true;
  end;
end;

local function makeAddonList(list, delim)
  local addons = {};

   for i, item in list
   do 
      if     item == BUILTIN
      then   table.insert(addons, bluzzard("Built-In"))
      else local loaded, reason = isAddonLoaded(item)
           if loaded 
           then   table.insert(addons, item)
           elseif reason == "MISSING"
           then   table.insert(addons, red(item))
           elseif reason == "DISABLED"
           then   table.insert(addons, grey(item))
           end;
      end;
   end;

   return table.concat(addons, delim or ", ")
end;

local function makeFileList(list, delim)
  local files = {}

  for i, item in list
  do  local addon = getAddonFromPath(item);
      if addon == BUILTIN 
      then table.insert(files, bluzzard(item))
      else local loaded, reason = isAddonLoaded(addon);
           if    loaded
           then table.insert(files, item)
           elseif reason == "MISSING"
           then table.insert(files, red(item))
           elseif reason == "DISABLED"
           then table.insert(addons, grey(item))
           end;
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

local function disableFont(fontName) LibSharedMedia.MediaTable.font[fontName] = nil; end;

local function readDatabase()
  -- prelims
  RP_FontsDB = RP_FontsDB or {};
  local db   = RP_FontsDB;
  db.Fonts   = db.Fonts or {};

  if db.stats then db.stats = { last = db.stats } else db.stats = {} end;

  db.DetailSelect = db.DetailSelect or "Morpheus";

  db.stats.total    = 0;
  db.stats.new      = 0;
  db.stats.missing  = 0;
  db.stats.active   = 0;
  db.stats.disabled = 0;
  db.stats.now      = time();

  -- Get existing fonts from LSM, store them in our master list
  for fontName, fontFile in pairs(LibSharedMedia:HashTable("font"))
  do  
      if not db.Fonts[fontName] 
      then   db.Fonts[fontName] = {}; 
             db.stats.new = db.stats.new + 1;
      end;

      local font = db.Fonts[fontName];

      -- Add and/or update the information
      font.name = font.name or fontName;

      font.file = font.file or {}; -- a font could be supplied from multiple sources, so we'll keep track of that

      if not tContains(   font.file, fontFile)
      then   table.insert(font.file, fontFile) 
      end;

      font.addon = font.addon or {};

      if not tContains(   font.addon, sourceAddOn) 
      then   table.insert(font.addon, sourceAddOn); 
      end;

      -- Just keeping track of when we've seen things
      font.firstSeen = font.firstSeen or time();
      font.lastSeen  = time();

      -- We use "YES"/NO" instead of true/false, so we can do things like this:
      font.active = font.active or "YES";
      font.loaded = true;
      
      if font.active
      then db.active_count = db.active_count + 1;
      else disableFont(font.name);
      end;

  end;
end;

local function buildOptions()
  -- Create an options panel
  --
  local options =
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

      statsTotalLeft =
      { type = "description",
        name = hilite("Total Fonts"),
        width = 1,
        order = 4,
        fontSize = "medium",
      },
      statsTotalRight =
      { type = "description",
        name = function() return normal(db.stats.total .. " known") end,
        width = 1,
        order = 5,
        fontSize = "medium",
      },
      statsTotalNewline = newline(6),
      statsNewLeft =
      { type = "description",
        name = hilite("New Fonts"),
        width = 1,
        order = 7,
        fontSize = "medium",
        hidden = function() return (db.stats.new == 0) end,
      },
      statsNewRight =
      { type = "description",
        name = function() return green(db.stats.new .. " fonts") end,
        width = 1,
        order = 8,
        fontSize = "medium",
        hidden = function() return (db.stats.new == 0) end,
      },
      statsNewNewline = newline({ order = 9, hidden = function () return (db.stats.new == 0) end } ),

      statsActiveLeft =
      { type = "description",
        name = hilite("Active Fonts"),
        width = 1,
        order = 10,
        fontSize = "medium",
        hidden = function() return (db.stats.active == 0) end,
      },
      statsActiveRight =
      { type = "description",
        name = function() return yellow(db.stats.active .. " fonts") end,
        width = 1,
        order = 11,
        fontSize = "medium",
        hidden = function() return (db.stats.active == 0) end,
      }
      statsActiveNewline = newline({ order = 12, hidden = function () return (db.stats.active == 0) end } ),

      statsDisabledLeft =
      { type = "description",
        name = hilite("Disabled Fonts"),
        width = 1,
        order = 13,
        fontSize = "medium",
        hidden = function() return (db.stats.disabled == 0) end,
      },
      statsDisabledRight =
      { type = "description",
        name = function() return yellow(db.stats.disabled .. " fonts") end,
        width = 1,
        order = 14,
        fontSize = "medium",
        hidden = function() return (db.stats.disabled == 0) end,
      },
      statsDisabledNewline = newline({ order = 15, hidden = function () return (db.stats.disabled == 0) end } ),
      dataTable = 
      { name = "Font List",
        type = "group",
        order = 4,       
      },

      fontDetails =
      { name = "Font Details",
        type = "group",
        order = 5,
      },
    },
  };
  return options;
end;

local function buildFontDetails()

  local fontDetails =
  { header =
    { type = "description",
      width = "full",
      name = function() return hilite(db.DetailSelect) end,
      order = 1,
      size = "large",
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
      name = function() return #db.Fonts[db.DetailSelect].addon == 1 and "Source AddOn" or "Source AddOns" end,
      order = 21,
      width = 1,
      fontSize = "medium",
    },

    fontAddOnRight =
    { type = "description",
      name = function() return makeAddonList(db.Fonts[db.DetailSelect].addon, "\n"); end,
      order = 22,
      width = 2,
      fontSize = "medium",
    },

    fontAddOnNewline = newline(23),

    fontFileLeft =
    { type = "description",
      name = function() return #db.Fonts[db.DetailSelect].file == 1 and "File Location" or "File Locations" end,
      order = 31,
      width = 1,
      fontSize = "medium",
    },
    fontFileRight =
    { type = "description",
      name = function() return table.concat(db.Fonts[db.DetailSelect].file, "\n"); end,
      order = 32,
      width = 2,
      fontSize = "medium",
    },
    fontFileNewline = newline(33),
  };
      
  return fontDetails;
end;
  -- options.args.fontDetails.args = fontDetails;

local function buildFontDataTable()
  local dataTable =
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
    };

  local keys = {};
  db.missing_count = 0;
  db.total_count = 0;

  local function setActiveState(fontStruct, value)
    fontStruct.active = value and "YES" or "NO";
    db.stats.active   = db.stats.active + (value and  1 or -1);
    db.stats.disabled = db.stats.active + (value and -1 or  1);
  end;

  for fontName, font in pairs(db.Fonts)
  do  db.total_count = db.total_count + 1;

      table.insert(keys, font.name)
      dataTable[fontName .. "_Active"] =
      { type     = "toggle",
        name     = "",
        width    = col[1],
        get      = function() return font.active == "YES" end,
        set      = function(info, value) setActiveState(font) end,
        disabled = function() return not font.loaded end,
      };

      local found = false;

      -- table.sort(font.addon);

      local addOnList = {};

      for _, addOn in ipairs(font.addon)
      do  local _, _, _, addOnLoadable, addOnReason = GetAddOnInfo(addOn);
          if addOn == "BUILTIN"
          then table.insert(addOnList, "Built-in")
          elseif addOnLoadable
          then table.insert(addOnList, GetAddOnMetadata(addOn, "Title"))
               found = true;
          elseif addOnReason == "DISABLED"
          then table.insert(addOnList, grey(addOn))
               found = true;
          else table.insert(addOnList, red(addOn))
          end;
      end;

      db.missing_count = db.missing_count + (not found and 1 or 0);

      dataTable[fontName .. "_Name"] =
      { type = "description",
        name = (font.loaded and font.name) or (not found and red(font.name)) or grey(font.name),
        width = col[2],
        fontSize = "small",
      };

      dataTable[fontName .. "_AddOn"] =
      { type = "description",
        name = table.concat(addOnList, ", ") .."",
        width = col[3],
        fontSize = "small",
      };

      dataTable[fontName .. "_FirstSeen"] =
      { type = "description",
        name = font.firstSeen .. "",
        width = col[4],
        fontSize = "small",
      };
 
      dataTable[fontName .. "_Newline"] =
      { type = "description",
        name = "",
        width = "full",
        fontSize = "small",
      };

  end;

  for i, key in ipairs(keys)
  do dataTable[key .. "_Active"   ].order = 100 + i * 10 + 1;
     dataTable[key .. "_Name"     ].order = 100 + i * 10 + 2;
     dataTable[key .. "_AddOn"    ].order = 100 + i * 10 + 3;
     dataTable[key .. "_FirstSeen"].order = 100 + i * 10 + 4;
     dataTable[key .. "_Newline"  ].order = 100 + i * 10 + 5;
  end;

  return dataTable;
end;
  -- options.args.dataTable.args = dataTable;

local function buildSettingsPanel()

end;

local function registerOptionsTable(optionsTable)
  optionsTable

  AceConfig:RegisterOptionsTable(addOnName, optionsTable);
  AceConfigDialog:AddToBlizOptions(addOnName, rpFontsTitle);

end;

local function registerSlashCommand()
  _G["SLASH_RPFONTS1"] = "/rpfonts";
  _G["SLASH_RPFONTS2"] = "/rpfont";

  if db.Options.UseFontsSlashCommand then _["SLASH_RPFONTS3"] = "/fonts"; end;
  
  SlashCmdList["RPFONTS"] = 
    function() 
      InterfaceOptionsFrame:Show();
      -- InterfaceOptionsFrame_OpenToCategory(rpFontsTitle);
      InterfaceOptionsFrame_OpenToCategory(addOnName);
    end;

end;


-- Whether we're using rpTags' scheduling or internal
--
if rpTags
then local RPTAGS = RPTAGS;
     local Module = RPTAGS.queue:NewModule(addOnName);
     Module:WaitUntil("ADDON_LOAD", runRpFonts);
else local waitingFrame = CreateFrame("Frame");
     waitingFrame:RegisterEvent("PLAYER_LOGIN");
     waitingFrame:SetScript("OnEvent", runRpFonts);
end;

