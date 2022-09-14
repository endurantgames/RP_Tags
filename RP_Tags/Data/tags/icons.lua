local RPTAGS = RPTAGS;
RPTAGS.queue:WaitUntil("DATA_TAGS",
function(self, event, ...)

  local L             = LibStub("AceLocale-3.0"):GetLocale(RPTAGS.CONST.APP_ID);
  local RPTAGS        = RPTAGS;
  local Get           = RPTAGS.utils.get;
  local CONST         = RPTAGS.CONST;
  CONST.TAG_DATA = CONST.TAG_DATA or {};

  local GROUP_DATA    =
    { key             = "ICONS",
      title           = L["TAG_GROUP_ICONS_TITLE"],
      help            = L["TAG_GROUP_ICONS_HELP"],
      tags            =
      { 
        { name        = "rp:icon",
          alias       = { "rp:icon-name", "rp:nameicon" },
          desc        = L["TAG_rp:icon_DESC"] ,
          method      = function(u) return Get.icon.unit(u) end,
          icon        = true,
        },
        { name        = "rp:gendericon",
          alias       = { "rp:sexicon", "rp:icon-gender", "rp:icon-sex" },
          desc        = L["TAG_rp:gendericon_DESC"] ,
          method      = function(u) return Get.icon.gender(u) end,
          icon        = true,
        },
        { name        = "rp:raceicon",
          alias       = { "rp:icon-race", "rp:speciesicon", "rp:icon-species" },
          desc        = L["TAG_rp:raceicon_DESC"],
          method      = function(u) return Get.icon.race(u) end,
          icon        = true,
        },
        { name        = "rp:statusicon",
          alias       = { "rp:icon-status", "rp:icicon", "rp:oocicon", "rp:npcicon", "rp:icon-ic", "rp:icon-ooc", "rp:icon-npc" },
          desc        = L["TAG_rp:statusicon_DESC"],
          method      = function(u) return Get.icon.status(u) end,
          icon        = true,
        },
        { name        = "rp:pvpicon",
          alias       = { "rp:icon-pvp" },
          desc        = L["TAG_rp:pvpicon_DESC"],
          method      = function(u) return Get.shared.pvpIcon(u) end,
          extraEvents = "PVP_ROLE_UPDATE",
          icon        = true,
        },
        { name        = "rp:pvpicon-square",
          alias       = { "rp:icon-pvp-square" },
          desc        = L["TAG_rp:pvpicon-square_DESC"],
          method      = function(u) return Get.shared.pvpIcon(u, "square") end,
          extraEvents = "PVP_ROLE_UPDATE",
          icon        = true,
        },
        { name        = "rp:relationicon",
          alias       = { "rp:icon-relation" },
          desc        = L["TAG_rp:relationicon_DESC"],
          method      = function(u) return Get.icon.relation(u) end,
          icon        = true,
        },
        { name        = "rp:sizebufficon",
          desc        = L["TAG_rp:sizebufficon_DESC"] ,
          alias       = { "rp:icon-sizebuff" },
          method      = function(u) return Get.shared.sizebuffIcon(u) end,
          extraEvents = "UNIT_AURA",
          icon        = true,
        },
        { title       = L["TAG_SUBTITLE_At First-Glance Icons"] },
        { name        = "rp:glance-1-icon",
          desc        = L["TAG_rp:glance-1-icon_DESC"] ,
          alias       = { "rp:icon-glance-1" },
          method      = function(u) return Get.text.glance(u, 1, { icon = true }) end,
          icon        = true,
        },
        { name        = "rp:glance-2-icon",
          desc        = L["TAG_rp:glance-2-icon_DESC"] ,
          alias       = { "rp:icon-glance-2" },
          method      = function(u) return Get.text.glance(u, 2, { icon = true }) end,
          icon        = true,
        },
        { name        = "rp:glance-3-icon",
          alias       = { "rp:icon-glance-3" },
          desc        = L["TAG_rp:glance-3-icon_DESC"] ,
          method      = function(u) return Get.text.glance(u, 3, { icon = true }) end,
          icon        = true,
        },
        { name        = "rp:glance-4-icon",
          alias       = { "rp:icon-glance-4" },
          desc        = L["TAG_rp:glance-4-icon_DESC"] ,
          method      = function(u) return Get.text.glance(u, 4, { icon = true }) end,
          icon        = true,
        },
        { name        = "rp:glance-5-icon",
          alias       = { "rp:icon-glance-5" },
          desc        = L["TAG_rp:glance-5-icon_DESC"] ,
          method      = function(u) return Get.text.glance(u, 5, { icon = true }) end,
          icon        = true,
        },
        { name        = "rp:glance-icons",
          desc        = L["TAG_rp:glance-icons_DESC"] ,
          alias       = { "rp:glanceicons", "rp:icon-glance" },
          method      = function(u) return Get.icon.glances(u) end,
          icon        = true,
        },
        { title       = L["TAG_SUBTITLE_Note Indicator Icons"] },
        { name        = "rp:note-1-icon",
          alias       = { "rp:icon-note-1" },
          desc        = L["TAG_rp:note-1-icon_DESC"],
          method      = function(u) return Get.text.note(u, false, 1, "ICON") end,
          icon        = true,
        },
        { name        = "rp:note-2-icon",
          alias       = { "rp:icon-note-2" },
          desc        = L["TAG_rp:note-2-icon_DESC"],
          method      = function(u) return Get.text.note(u, false, 2, "ICON") end,
          icon        = true,
        },
        { name        = "rp:note-3-icon",
          alias       = { "rp:icon-note-3" },
          desc        = L["TAG_rp:note-3-icon_DESC"],
          method      = function(u) return Get.text.note(u, false, 3, "ICON") end,
          icon        = true,
        },
        { title       = L["TAG_SUBTITLE_RP Experience Icons"] },
        { name        = "rp:xp-icon",
          alias       = { "rp:icon-xp" },
          desc        = L["TAG_rp:xp-icon_DESC"],
          method      = function(u) return Get.text.xp(u, "icon") end,
          icon        = true,
        },
        { name        = "rp:rookie-icon",
          alias       = { "rp:icon-rookie" },
          desc        = L["TAG_rp:rookie-icon_DESC"],
          method      = function(u) return Get.text.xp(u, "rookie-icon") end,
          icon        = true,
        },
        { name        = "rp:volunteer-icon",
          alias       = { "rp:icon-volunteer" },
          desc        = L["TAG_rp:volunteer-icon_DESC"],
          method      = function(u) return Get.text.xp(u, "volunteer-icon") end,
          icon        = true,
        },
        { title       = L["TAG_SUBTITLE_RP Style Icons"] },
        { name        = "rp:style-ic-icon",
          alias       = { "rp:icon-style-ic" },
          desc        = L["TAG_rp:style-ic-icon_DESC"] ,
          method      = function(u) return Get.text.style(u, "ic", "ICON") end,
          icon        = true,
        },
        { name        = "rp:style-injury-icon",
          alias       = { "rp:icon-style-injury", "rp:icon-injury", "rp:injury-icon" },
          desc        = L["TAG_rp:style-injury-icon_DESC"],
          method      = function(u) return Get.text.style(u, "injury", "ICON") end,
          icon        = true,
        },
        { name        = "rp:style-death-icon",
          alias       = { "rp:icon-style-death", "rp:icon-death", "rp:death-icon" },
          desc        = L["TAG_rp:style-death-icon_DESC"],
          method      = function(u) return Get.text.style(u, "death", "ICON") end,
          icon        = true,
        },
        { name        = "rp:style-battle-icon",
          alias       = { "rp:icon-style-battle", "rp:icon-battle", "rp:battle-icon" },
          desc        = L["TAG_rp:style-battle-icon_DESC"],
          method      = function(u) return Get.text.style(u, "battle", "ICON") end,
          icon        = true,
        },
        { name        = "rp:style-romance-icon",
          alias       = { "rp:icon-style-romance", "rp:icon-romance", "rp:romance-icon" },
          desc        = L["TAG_rp:style-romance-icon_DESC"],
          method      = function(u) return Get.text.style(u, "romance", "ICON") end,
          icon        = true,
        },
        { name        = "rp:style-guild-icon",
          desc        = L["TAG_rp:style-guild-icon_DESC"],
          alias       = { "rp:icon-style-guild", "rp:icon-guild-ic", "rp:icon-guild-ooc" },
          method      = function(u) return Get.text.style(u, "guild", "ICON") end,
          icon        = true,
        },
        { name        = "rp:style-icons",
          alias       = { "rp:style-all-icon", "rp:style-all-icons", "rp:icon-style", "rp:icon-styles", },
          desc        = L["TAG_rp:style-icons_DESC"],
          method      = function(u) return Get.text.style(u, "icons") end,
          icon        = true,
        },
      }, -- tags
    };

end);
