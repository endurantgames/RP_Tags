local RPTAGS = RPTAGS;
RPTAGS.queue:WaitUntil("DATA_TAGS",
function(self, event, ...)

  local L             = LibStub("AceLocale-3.0"):GetLocale(RPTAGS.CONST.APP_ID);
  local RPTAGS        = RPTAGS;
  local Get           = RPTAGS.utils.get;
  local CONST         = RPTAGS.CONST;
  RPTAGS.CONST.TAG_DATA = RPTAGS.CONST.TAG_DATA or {};

  local GROUP_DATA    =
    { key             = "FORMATTING",
      title           = L["TAG_GROUP_FORMATTING_TITLE"],
      help            = L["TAG_GROUP_FORMATTING_HELP"],
      tags            =
      { { name        = "br",
          desc        = L["TAG_br_DESC"],
          alias       = { "newline", "nl" },
          no_prefix   = true,
          method      = function() return "\n"   end,
        },
        { name        = "p",
          desc        = L["TAG_p_DESC"],
          no_prefix   = true,
          method      = function() return "\n\n" end,
        },
      }, -- tags
    };

    table.insert(TAG_DATA, GROUP_DATA);

end);
