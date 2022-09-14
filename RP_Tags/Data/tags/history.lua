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
    { key             = "HISTORY",
      title           = L["TAG_GROUP_HISTORY_TITLE"],
      help            = L["TAG_GROUP_HISTORY_HELP"],
      tags            =
      { { name        = "rp:age",
          label       = L["TAG_rp:age_LABEL"],
          desc        = L["TAG_rp:age_DESC"],
          method      = function(u) return Get.text.age(u) end,
          size        = true,
        },
        { name        = "rp:years",
          label       = L["TAG_rp:years_LABEL"],
          desc        = L["TAG_rp:years_DESC"],
          method      = function(u) return Get.text.years(u) end,
        },
        { name        = "rp:years-old",
          label       = L["TAG_rp:years-old_LABEL"],
          desc        = L["TAG_rp:years-old_DESC"] ,
          method      = function(u) return Get.text.years(u, "old") end ,
        },
        { name        = "rp:years-ago",
          label       = L["TAG_rp:years-ago_LABEL"],
          desc        = L["TAG_rp:years-ago_DESC"] ,
          method      = function(u) return Get.text.years(u, "ago") end ,
        },
        { name        = "rp:birthday",
          alias       = { "rp:bday" },
          label       = L["TAG_rp:birthday_LABEL"],
          desc        = L["TAG_rp:birthday_DESC"],
          method      = function(u) return Get.text.misc(u, "birthday") end,
          size        = true,
        },
        { name        = "rp:birthplace",
          alias       = { "rp:born" },
          label       = L["TAG_rp:birthplace_LABEL"],
          desc        = L["TAG_rp:birthplace_DESC"],
          method      = function(u) return Get.text.birthplace(u) end,
          size        = true,
        },
      }, -- tags
    };
    table.insert(TAG_DATA, GROUP_DATA);

end);
