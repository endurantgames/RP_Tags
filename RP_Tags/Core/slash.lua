-- ------------------------------------------------------------------------------
-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. To view a copy of the license, visit
--
--     https://creativecommons.org/licenses/by/4.0/
-- slash commands

local RPTAGS     = RPTAGS;

RPTAGS.queue:WaitUntil("UTILS_HELP",
function(self, event, ...)

  local function openDialog(...)
        -- local AceConfigDialog = LibStub("AceConfigDialog-3.0");
        -- local loc = RPTAGS.utils.locale.loc;
        -- AceConfigDialog:Open(loc("APP_NAME"));
        -- AceConfigDialog:SelectGroup(loc("APP_NAME"), ...);
  end;

  RPTAGS.utils.help = RPTAGS.utils.help or {};
  RPTAGS.utils.help.openDialog = openDialog;
end);

RPTAGS.queue:WaitUntil("CORE_SLASH",
function(self, event, ...)

  RPTAGS.cache      = RPTAGS.cache or {};
  RPTAGS.utils      = RPTAGS.utils or {};
  RPTAGS.utils.help = RPTAGS.utils.help or {};
  
  local CONST      = RPTAGS.CONST;
  local Utils      = RPTAGS.utils;
  local Cache      = RPTAGS.cache;
  
  local loc        = Utils.locale.loc;
  local hilite     = Utils.text.hilite;
  local Config     = Utils.config;
  local notify     = Utils.text.notify;
  local APP_NAME   = loc("APP_NAME");
  local openDialog = Utils.help.openDialog()
  
  
  -- slash commands ---------------------------------------------------------------------------------------------------------------------------
  
  for i, slash_cmd in ipairs(RPTAGS.utils.text.split(loc("APP_SLASH"), "|"))
  do  _G["SLASH_RPTAGS" .. i] = "/" .. slash_cmd
  end;
  
  -- 
  local slashPanels = 
  { config  = { "generalOptions",                      }, 
    help    = { "helpIntro",                           }, 
    color   = { "colorsOptions",                       }, 
    layout  = { "unitFramesOptions",                   }, 
    tags    = { "unitFramesOptions",                   }, 
    keybind = { "keyBindings",                         }, 
    about   = { "about",                               }, 
    changes = { "about",              "aboutChanges",  }, 
    version = { "about",              "aboutVersion",  }, 
    addons  = { "about",              "aboutAddOns",   }, 
    credits = { "about",              "aboutCredits",  }, 
  };
  
  local slashPanelDefault = slashPanels["about"];
  RPTAGS.cache.slashPanels = slashPanels;
  
  -- To add a new panel to open, such as in a module, do this:
  --
  --    RPTAGS.cache.slashPanels["panel"] = { "pathTo", "yourPanel" };
  -- 
  -- Add a localized string that looks like this:
  --
  --    L["SLASH_PANEL"] = "x|execute|ex";
  --
  
  SlashCmdList["RPTAGS"] =
    function(a)
      -- for panel, path in pairs(slashPanels)
      -- do  for _, s in pairs(RPTAGS.utils.text.split(loc("SLASH_" .. panel:upper()), "|"))
      --     do  if a == s then return openDialog(unpack(path)) end;
      --     end;
      -- end;
      -- openDialog(unpack(slashPanelDefault));
    end;
  
end);
