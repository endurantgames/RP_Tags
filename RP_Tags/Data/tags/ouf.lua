local RPTAGS = RPTAGS;
RPTAGS.queue:WaitUntil("DATA_TAGS",
function(self, event, ...)

  local L             = LibStub("AceLocale-3.0"):GetLocale(RPTAGS.CONST.APP_ID);
  local RPTAGS        = RPTAGS;
  local Get           = RPTAGS.utils.get;
  local CONST         = RPTAGS.CONST;
  CONST.TAG_DATA = CONST.TAG_DATA or {};

  local GROUP_DATA    =
    { key             = "OUF",
      title           = L["TAG_GROUP_OUF_TITLE"],
      help            = L["TAG_GROUP_OUF_HELP"],
      external        = true,
      tags            =
      { { name        = "level",
          desc        = L["TAG_level_DESC"],
          no_prefix   = true,
        },
        { name        = "smartclass",
          desc        = L["TAG_smartclass_DESC"],
          no_prefix   = true,
        },
        { name        = "creature",
          desc        = L["TAG_creature_DESC"],
          no_prefix   = true,
        },
        { name        = "dead",
          desc        = L["TAG_dead_DESC"],
          no_prefix   = true,
        },
        { name        = "class",
          desc        = L["TAG_class_DESC"],
          no_prefix   = true,
        },
        { name        = "faction",
          desc        = L["TAG_faction_DESC"],
          no_prefix   = true,
        },
        { name        = "name",
          desc        = L["TAG_name_DESC"],
          no_prefix   = true,
        },
        { name        = "race",
          desc        = L["TAG_race_DESC"],
          no_prefix   = true,
        },
        { name        = "sex",
          desc        = L["TAG_sex_DESC"],
          no_prefix   = true,
        },
        { name        = "status",
          desc        = L["TAG_status_DESC"],
          no_prefix   = true,
        },
        { name        = "group",
          desc        = L["TAG_group_DESC"],
          no_prefix   = true,
        },
        { name        = "offline",
          desc        = L["TAG_offline_DESC"],
          no_prefix   = true,
        },
        { name        = "pvp",
          desc        = L["TAG_pvp_DESC"],
          no_prefix   = true,
        },
        { name        = "difficulty",
          desc        = L["TAG_difficulty_DESC"],
          no_prefix   = true,
        },
        { name        = "resting",
          desc        = L["TAG_resting_DESC"],
          no_prefix   = true,
        },
        { name        = "classification",
          desc        = L["TAG_classification_DESC"],
          no_prefix   = true,
        },
        { name        = "powercolor",
          desc        = L["TAG_powercolor_DESC"],
          no_prefix   = true,
          color       = true,
        },
        { name        = "raidcolor",
          desc        = L["TAG_raidcolor_DESC"],
          no_prefix   = true,
          color       = true,
        },
        { name        = "classcolor",
          desc        = L["TAG_classcolor_DESC"],
          no_prefix   = true,
          color       = true,
        },
        { name        = "threatcolor",
          desc        = L["TAG_threatcolor_DESC"],
          no_prefix   = true,
          color       = true,
        },
      }, -- tags
    }; -- ouf
    table.insert(TAG_DATA, GROUP_DATA);

end);
