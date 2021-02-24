-- RP Fonts
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license.

local addOnName, ns = ...;

local LibSharedMedia  = LibStub("LibSharedMedia-3.0");
local AceConfig       = LibStub("AceConfig-3.0");
local AceConfigDialog = LibStub("AceConfigDialog-3.0");

local rpTags;

-- Do we have RP_Tags?

local _, _, _, rpTagsLoadable, rpTagsReason = GetAddOnInfo("RP_Tags")

if not rpTagsLoadable and (rpTagsReason == "MISSING" or rpTagsReason == "DISABLED")
then   rpTags = false;
else   rpTags = true; -- hey we do have RPTAGS
end;

local rpFontsTitle = GetAddOnMetadata(addOnName, "Title");
local rpFontsDesc = GetAddOnMetadata(addOnName, "Notes");

local function grey(str) return "|cff808080" .. str:gsub("|cff%x%x%x%x%x%x", ""):gsub("|r", "") .. "|r"; end;
local function  red(str) return "|cffff0000" .. str:gsub("|cff%x%x%x%x%x%x", ""):gsub("|r", "") .. "|r"; end;

local function runRpFonts()
  -- This is going to go off only once, when rpFonts is fully loaded

  local LMD = "LMD30_Description";
  LMD = nil; 

  -- prelims
  --
  RP_FontsDB = RP_FontsDB or {};
  local db = RP_FontsDB;
  db.Fonts = db.Fonts or {};

  db.DetailSelect = db.DetailSelect or "Morpheus";
  -- Get existing fonts, store them in our master last
  --
  db.active_count = 0;
  for fontName, fontFile in pairs(LibSharedMedia:HashTable("font"))
  do  local sourceAddOn = fontFile:match("^Interface\\[aA]dd[oO]ns\\(.-)\\")
      sourceAddOn = sourceAddOn or "BUILTIN";
      if   db.Fonts[fontName]
      then -- we've seen this before
      else -- it's new to us
           db.Fonts[fontName] = {};
      end;

      local font = db.Fonts[fontName];

      font.name = font.name or fontName;
      font.file = font.file or {};
      if not tContains(font.file, fontFile) then table.insert(font.file, fontFile) end;
      font.addon = font.addon or {};
      if not tContains(font.addon, sourceAddOn) then table.insert(font.addon, sourceAddOn); end;
      font.firstSeen = font.firstSeen or time();
      font.lastSeen = time();
      font.active = font.active or "YES";
      font.loaded = true;

      db.active_count = db.active_count + 1;
  end;

  local col = { 0.15, 1, 1, 0.65, 0.5 };
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
        dialogControl = LMD,
        width = "full",
        order = 2,
        fontSize = "small" 
      },
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

  local fontDetails =
  { selector = 
    { type = "select",
      width = "full",
      name = "Font Details",
      order = 1,
      values = LibSharedMedia:HashTable("font"),
      dialogControl = "LSM30_Font",
      get = function() return db.DetailSelect or "Morpheus" end,
      set = function(info, value) db.DetailSelect = value end,
    },
    fontNameLeft =
    { type = "description",
      name = "Font Name",
      order = 11,
        dialogControl = LMD,
      width = 1,
      fontSize = "medium",
    },
    fontNameRight =
    { type = "description",
      name = function() return db.Fonts[db.DetailSelect].name end,
      order = 12,
        dialogControl = LMD,
      width = 2,
      fontSize = "medium",
    },
    fontNameNewline =
    { type = "description",
      name = "",
      order = 13,
      width = "full",
      fontSize = "medium",
    },
    fontAddOnLeft =
    { type = "description",
      name = "Source AddOn(s)",
      order = 21,
        dialogControl = LMD,
      width = 1,
      fontSize = "medium",
    },
    fontAddOnRight =
    { type = "description",
      name = function() return table.concat(db.Fonts[db.DetailSelect].addon, "\n"); end,
      order = 22,
      width = 2,
        dialogControl = LMD,
      fontSize = "medium",
    },
    fontAddOnNewline =
    { type = "description",
      name = "",
      order = 23,
        dialogControl = LMD,
      width = "full",
      fontSize = "medium",
    },
    fontFileLeft =
    { type = "description",
      name = "File",
      order = 31,
      dialogControl =LMD,
      width = 1,
      fontSize = "medium",
    },
    fontFileRight =
    { type = "description",
      name = function() return table.concat(db.Fonts[db.DetailSelect].file, "\n"); end,
      order = 32,
      dialogControl = LMD,
      width = 2,
      fontSize = "medium",
    },
    fontFileNewline =
    { type = "description",
      name = "",
      order = 33,
      width = "full",
      fontSize = "medium",
    },
  };
      
  options.args.fontDetails.args = fontDetails;

  local dataTable =
    { 
      columnActive =
      { type = "description",
        name = "",
        dialogControl = LMD,
        width = col[1],
        order = 11,
        fontSize = "small",
      },
      columnName = 
      { type = "description",
        name = "|cffffff00Font Name|r",
        dialogControl = LMD,
        width = col[2],
        order = 12,
        fontSize = "small",
      },
      columnAddOn =
      { type = "description",
        name = "|cffffff00Source AddOn(s)|r",
        dialogControl = LMD,
        width = col[3],
        order = 13,
        fontSize = "small",
      },
      columnFirstRecorded =
      { type = "description",
        name = "|cffffff00First Recorded|r",
        dialogControl = LMD,
        width = col[4],
        order = 14,
        fontSize = "small",
      },
      columnLine =
      { type = "description",
        name = "",
        width = "full",
        order = 15,
        fontSize = "small",
      },
    };

  local keys = {};
  db.missing_count = 0;
  db.total_count = 0;

  for fontName, font in pairs(db.Fonts)
  do  db.total_count = db.total_count + 1;
      table.insert(keys, font.name)
      dataTable[fontName .. "_Active"] =
      { type = "toggle",
        name = "",
        width = col[1],
        get = function() return font.active == "YES" end,
        dialogControl = LMD,
        set = function(info, value) font.active = value and "YES" or "NO" end,
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
        dialogControl = LMD,
        name = (font.loaded and font.name) or (not found and red(font.name)) or grey(font.name),
        width = col[2],
        fontSize = "small",
      };

      dataTable[fontName .. "_AddOn"] =
      { type = "description",
        name = table.concat(addOnList, ", ") .."",
        dialogControl = LMD,
        width = col[3],
        fontSize = "small",
      };

      dataTable[fontName .. "_FirstSeen"] =
      { type = "description",
        name = font.firstSeen .. "",
        dialogControl = LMD,
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

  options.args.dataTable.args = dataTable;
  AceConfig:RegisterOptionsTable(addOnName, options);
  AceConfigDialog:AddToBlizOptions(addOnName, rpFontsTitle);

  _G["SLASH_RPFONTS1"] = "/rpfonts";
  _G["SLASH_RPFONTS2"] = "/rpfont";
  _G["SLASH_RPFONTS3"] = "/fonts";
  
  SlashCmdList["RPFONTS"] = 
    function() 
      -- InterfaceOptionsFrame:Show();
      -- InterfaceOptionsFrame_OpenToCategory(rpFontsTitle);
      InterfaceOptionsFrame_OpenToCategory(addOnName);
    end;

end;


if rpTags
then local RPTAGS = RPTAGS;
     local Module = RPTAGS.queue:NewModule(addOnName);
     Module:WaitUntil("ADDON_LOAD", runRpFonts);
else local waitingFrame = CreateFrame("Frame");
     waitingFrame:RegisterEvent("PLAYER_LOGIN");
     waitingFrame:SetScript("OnEvent", runRpFonts);
end;

