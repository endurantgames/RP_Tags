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

  -- prelims
  --
  local db = RP_FontsDB;
  db.Fonts = db.Fonts or {};

  -- Get existing fonts, store them in our master last
  --
  db.active_count = 0;
  for fontName, fontFile in LibSharedMedia:HashTable("font")
  do  local sourceAddOn = fontFile:match("^Interface\\AddOns\\(.-)\\")
      if sourceAddOn then print(fontName, "is from ", sourceAddon)
      else print(fontName, "is a built-in font"); sourceAddOn = "BUILTIN";
      end;
      if   db.Fonts[fontName]
      then -- we've seen this before
      else -- it's new to us
           db.Fonts[fontName] = {};
      end;

      db.Fonts[fontName].name = db.Fonts[fontName].name or fontName;
      db.Fonts[fontName].file = db.Fonts[fontName].file or {};
      table.insert(db.Fonts[fontName].file, fontFile);
      db.Fonts[fontName].addon = db.Fonts[fontName].addon or {};
      table.insert(db.Fonts[fontName].addon, sourceAddOn)
      db.Fonts[fontName].firstSeen = db.Fonts[fontName].firstSeen or time();
      db.Fonts[fontName].lastSeen = time();
      db.Fonts[fontName].active = db.Fonts[fontName].active or "YES";
      db.Fonts[fontName].loaded = true;

      db.active_count = db.active_count + 1;
  end;

  local col = { 0.25, 0.5, 1, 0.5, 0.5 };
  -- Create an options panel
  --
  local options =
  { type = "group",
    name = rpFontsTitle,
    order = 100,
    args =
    { header = 
      { type = "description",
        name = rpFontsTitle,
        width = "full",
        order = 1,
        fontSize = "large",
      },
      blurb =
      { type = "description",
        name = rpFontsDesc,
        width = "full",
        order = 2,
        fontSize = "small" 
      },

      columnActive =
      { type = "description",
        name = "|cffffff00Active|r",
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
        size = "small",
      },
      columnAddOn =
      { type = "description",
        name = "|cffffff00First Recorded|r",
        width = col[4],
        order = 14,
        fontSize = "small",
      },
    },
  };

  local keys = {};
  db.missing_count = 0;
  db.total_count = 0;

  for fontName, font in db.Fonts
  do  db.total_count = db.total_count + 1;
      table.insert(keys, font.name)
      options.args[fontName .. "Active"] =
      { type = "toggle",
        name = "",
        width = col[1],
        get = function() return font.active == "YES" end,
        set = function(info, value) font.active = value and "YES" or "NO" end,
        disabled = function() return not font.loaded end,
      };

      local found = false;

      local addOnList = {};

      for _, addOn in ipairs(table.sort(table.addon))
      do  local _, _, _, addOnLoadable, addOnReason = GetAddOnInfo(addOn);
          if addOnLoadable
          then table.insert(addOnList, addOn)
               found = true;
          elseif addOnReason == "DISABLED"
          then table.insert(addOnList, grey(addOn))
               found = true;
          else table.insert(addOnList, red(addOn))
          end;
      end;

      db.missing_count = db.missing_count + (not found and 1 or 0);

      options.args[fontName .. "Name"] =
      { type = "description",
        name = (font.loaded and font.name) or (not found and red(font.name)) or grey(font.name),
        width = col[2],
        fontSize = "small",
      };

      options.args[fontName .. "AddOn"] =
      { type = "description",
        name = table.concat(addOnList, ", "),
        width = col[3],
        fontSize = "small",
      };

      options.args[fontName .. "FirstSeen"] =
      { type = "description",
        name = font.firstSeen,
        width = col[4],
        fontSize = "small",
      };

  end;

  for i, key in ipairs(keys)
  do options.args[key .. "Active"   ].order = 100 + i * 10 + 1;
     options.args[key .. "Name"     ].order = 100 + i * 10 + 2;
     options.args[key .. "AddOn"    ].order = 100 + i * 10 + 3;
     options.args[key .. "FirstSeen"].order = 100 + i * 10 + 4;
  end;

  AceConfig:RegisterOptionsTable(addOnName, options, "/rpfonts" );
  AceConfigDialog:AddToBlizOptions(addOnName, rpFontsTitle);

end;


if rpTags
then local RPTAGS = RPTAGS;
     local Module = RPTAGS.queue:NewModule(addOnName);
     Module:WaitUntil("ADDON_LOAD", runRpFonts);
else local waitingFrame = CreateFrame("Frame");
     waitingFrame:RegisterEvent("PLAYER_LOGIN");
     waitingFrame:SetScript("OnEvent", runRpFonts);
end;

