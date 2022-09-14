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
    { key             = "GENDER",
      title           = L["TAG_GROUP_GENDER_TITLE"],
      help            = L["TAG_GROUP_GENDER_HELP"],
      tags            =
      { { name        = "rp:gender",
          alias       = { "rp:sex" },
          label       = L["TAG_rp:gender_LABEL"],
          method      = function(u) return Get.text.gender(u) end,
          desc        = L["TAG_rp:gender_DESC"],
          size        = true,
        },
        { name        = "rp:pronouns",
          label       = L["TAG_rp:pronouns_LABEL"],
          desc        = L["TAG_rp:pronouns_DESC"],
          method      = function(u) return Get.text.pronouns(u) end,
          size        = true,
        },
        { title       = L["TAG_SUBTITLE_Nominative Pronouns"] },
        { name        = "rp:s",
          desc        = L["TAG_rp:s_DESC"] ,
          method      = function(u) return Get.text.pronoun(u, "s") end,
        },
        { name        = "rp:S",
          desc        = L["TAG_rp:S_DESC"] ,
          method      = function(u) return Get.text.pronoun(u, "S") end,
        },
        { title       = L["TAG_SUBTITLE_Object Pronouns"] },
        { name        = "rp:o",
          desc        = L["TAG_rp:o_DESC"] ,
          method      = function(u) return Get.text.pronoun(u, "o") end,
        },
        { name        = "rp:O",
          desc        = L["TAG_rp:O_DESC"] ,
          method      = function(u) return Get.text.pronoun(u, "O") end,
        },
        { title       = L["TAG_SUBTITLE_Possessive Pronouns"] },
        { name        = "rp:p",
          desc        = L["TAG_rp:p_DESC"] ,
          method      = function(u) return Get.text.pronoun(u, "p") end,
        },
        { name        = "rp:P",
          desc        = L["TAG_rp:P_DESC"] ,
          method      = function(u) return Get.text.pronoun(u, "P") end,
        },
        { title       = L["TAG_SUBTITLE_Absolute Pronouns"] },
        { name        = "rp:a",
          desc        = L["TAG_rp:a_DESC"] ,
          method      = function(u) return Get.text.pronoun(u, "a") end,
        },
        { name        = "rp:A",
          desc        = L["TAG_rp:A_DESC"] ,
          method      = function(u) return Get.text.pronoun(u, "A") end,
        },
        { title       = L["TAG_SUBTITLE_Reflexive Pronouns"] },
        { name        = "rp:r",
          desc        = L["TAG_rp:r_DESC"] ,
          method      = function(u) return Get.text.pronoun(u, "r") end,
        },
        { name        = "rp:R",
          desc        = L["TAG_rp:R_DESC"] ,
          method      = function(u) return Get.text.pronoun(u, "R") end,
        },
      }, -- tags
    };

    table.insert(TAG_DATA, GROUP_DATA);

end);
