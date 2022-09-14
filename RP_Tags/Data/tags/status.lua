local RPTAGS = RPTAGS;
RPTAGS.queue:WaitUntil("DATA_TAGS",
function(self, event, ...)

  local L             = LibStub("AceLocale-3.0"):GetLocale(RPTAGS.CONST.APP_ID);
  local RPTAGS        = RPTAGS;
  local Get           = RPTAGS.utils.get;
  local CONST         = RPTAGS.CONST;
  CONST.TAG_DATA = CONST.TAG_DATA or {};
  local TAG_DATA = CONST.TAG_DATA;

  local GROUP_DATA    =
    { key             = "STATUS",
      title           = L["TAG_GROUP_STATUS_TITLE"],
      help            = L["TAG_GROUP_STATUS_HELP"],
      tags            =
      { 
        { name        = "rp:status",
          label       = L["TAG_rp:status_LABEL"],
          desc        = L["TAG_rp:status_DESC"],
          method      = function(u) return Get.text.status(u) end,
        },
        { name        = "rp:ic",
          alias       = { "rp:incharacter", "rp:in-character" },
          desc        = L["TAG_rp:ic_DESC"],
          method      = function(u) return Get.text.ic(u) end,
        },
        { name        = "rp:ooc",
          alias       = { "rp:outofcharacter", "rp:out-of-character" },
          desc        = L["TAG_rp:ooc_DESC"],
          method      = function(u) return Get.text.ooc(u) end,
        },
        { name        = "rp:npc",
          alias       = { "rp:nonplayer-character" },
          desc        = L["TAG_rp:npc_DESC"] ,
          method      = function(u) return Get.shared.npc(u) end,
        },
        { name        = "rp:open",
          alias       = { "rp:lfc", "rp:lfm", },
          method      = function(u) return Get.text.extStatus(u, "open") end,
          desc        = L["TAG_rp:open_DESC"],
        },
        { name        = "rp:storyteller",
          alias       = { "rp:gm" },
          method      = function(u) return Get.text.extStatus(u, "storyteller") end,
          desc        = L["TAG_rp:storyteller_DESC"],
        },
        { title       = L["TAG_SUBTITLE_Currently"] },
        { name        = "rp:curr",
          alias       = { "rp:currently" },
          method      = function(u) return Get.text.curr(u) end,
          label       = L["TAG_rp:curr_LABEL"],
          desc        = L["TAG_rp:curr_DESC"],
          size        = true,
        },
        { name        = "rp:info",
          alias       = { "rp:oocinfo", },
          method      = function(u) return Get.text.info(u) end,
          label       = L["TAG_rp:info_LABEL"],
          desc        = L["TAG_rp:info_DESC"],
          size        = true,
        },
        { title       = L["TAG_SUBTITLE_Roleplaying Experience"] },
        { name        = "rp:experience",
          label       = L["TAG_rp:experience_LABEL"],
          method      = function(u) return Get.text.xp(u, "long") end,
          desc        = L["TAG_rp:experience_DESC"],
        },
        { name        = "rp:xp",
          desc        = L["TAG_rp:xp_DESC"],
          method      = function(u) return Get.text.xp(u, "short") end,
        },
        { name        = "rp:rookie",
          alias       = { "rp:new" },
          desc        = L["TAG_rp:rookie_DESC"],
          method      = function(u) return Get.text.xp(u, "rookie") end,
        },
        { name        = "rp:volunteer",
          desc        = L["TAG_rp:volunteer_DESC"],
          method      = function(u) return Get.text.xp(u, "volunteer") end,
        },
      }, -- tags
    }; -- status
    table.insert(TAG_DATA, GROUP_DATA);

end);
