local RPTAGS = RPTAGS;
RPTAGS.queue:WaitUntil("DATA_TAGS",
function(self, event, ...)

  local L             = LibStub("AceLocale-3.0"):GetLocale(RPTAGS.CONST.APP_ID);
  local RPTAGS        = RPTAGS;
  local Get           = RPTAGS.utils.get;
  local CONST         = RPTAGS.CONST;
  CONST.TAG_DATA = CONST.TAG_DATA or {};
  local TAG_DATA = CONST.TAG_DATA;

  local GROUP_DATA      =
    { key             = "COLORS",
      title           = L["TAG_GROUP_COLORS_TITLE"],
      help            = L["TAG_GROUP_COLORS_HELP"],
      tags            =
      { { name        = "rp:color",
          alias       = { "rp:classcolor", "rp:namecolor" },
          method      = function(u) return Get.color.name(u) end,
          desc        = L["TAG_rp:color_DESC"],
          color       = true,
        },
        { name        = "rp:eyecolor",
          desc        = L["TAG_rp:eyecolor_DESC"],
          method      = function(u) return Get.color.eye(u) end,
          color       = true,
        },
        { name        = "rp:friendcolor",
          desc        = L["TAG_rp:friendcolor_DESC"] ,
          method      = function(u) return Get.shared.friendColor(u) end,
          extraEvents = "FRIENDLIST_UPDATE BN_FRIEND_INFO_CHANGED IGNORELIST_UPDATE",
          color       = true,
        },
        { name        = "rp:gendercolor",
          alias       = { "rp:sexcolor" },
          method      = function(u) return Get.color.gender(u) end,
          desc        = L["TAG_rp:gendercolor_DESC"],
          color       = true,
        },
        { name        = "rp:guildcolor",
          desc        = L["TAG_rp:guildcolor_DESC"] ,
          method      = function(u) return Get.shared.guildColor(u) end,
          extraEvents = "PLAYER_GUILD_UPDATE GUILD_ROSTER_UPDATE",
          color       = true,
        },
        { name        = "rp:guildstatuscolor",
          desc        = L["TAG_rp:guildstatuscolor_DESC"],
          method      = function(u) return Get.color.guildstatus(u) end,
          color       = true,
        },
        { name        = "rp:mecolor",
          alias       = { "rp:mycolor" },
          desc        = L["TAG_rp:mecolor_DESC"],
          method      = function(u) return Get.shared.meColor(u) end,
          color       = true,
        },
        { name        = "rp:partycolor",
          alias       = { "rp:raidcolor" },
          method      = function(u) return Get.shared.partyColor(u) end,
          extraEvents = "UNITS_OTHER_PARTY_CHANGED GROUP_JOINED GROUP_LEFT",
          desc        = L["TAG_rp:partycolor_DESC"],
          color       = true,
        },
        { name        = "rp:profilesizecolor",
          desc        = L["TAG_rp:profilesizecolor_DESC"] ,
          method      = function(u) return Get.text.profileSize(u, "color") end,
          color       = true,
        },
        { name        = "rp:relationcolor",
          desc        = L["TAG_rp:relationcolor_DESC"],
          method      = function(u) return Get.color.relation(u) end,
          color       = true,
        },
        { name        = "rp:statuscolor",
          desc        = L["TAG_rp:statuscolor_DESC"] ,
          method      = function(u) return Get.color.status(u) end,
          color       = true,
        },
        { name        = "nocolor",
          desc        = L["TAG_nocolor_DESC"],
          no_prefix   = true ,
          method      = function(u) return "|r" end,
          color       = true,
        },
        { title       = L["TAG_SUBTITLE_Comparison Colors"] , },
        { name        = "rp:agecolor",
          desc        = L["TAG_rp:agecolor_DESC"] ,
          method      = function(u) return Get.color.age(u) end,
          color       = true,
        },
        { name        = "rp:heightcolor",
          desc        = L["TAG_rp:heightcolor_DESC"] ,
          method      = function(u) return Get.color.height(u) end,
          color       = true,
        },
        { name        = "rp:weightcolor",
          desc        = L["TAG_rp:weightcolor_DESC"] ,
          method      = function(u) return Get.color.weight(u) end,
          color       = true,
        },
        { title       = L["TAG_SUBTITLE_Hilite Colors"] , },
        { name        = "rp:hilite-1",
          alias       = { "rp:hilite", "rp:hilite-color", "rp:hilite-color-1" },
          desc        = L["TAG_rp:hilite-1_DESC"],
          method      = function(u) return Get.shared.hiliteColor(1) end,
          color       = true,
        },
        { name        = "rp:hilite-2",
          alias       = { "rp:hilite-color-2" },
          method      = function(u) return Get.shared.hiliteColor(1) end,
          desc        = L["TAG_rp:hilite-2_DESC"],
          color       = true,
        },
        { name        = "rp:hilite-3",
          alias       = { "rp:hilite-color-3" },
          method      = function(u) return Get.shared.hiliteColor(1) end,
          desc        = L["TAG_rp:hilite-3_DESC"],
          color       = true,
        },
      }, -- tags
    };
    table.insert(TAG_DATA, GROUP_DATA);

end);
