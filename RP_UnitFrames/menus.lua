local RPTAGS = RPTAGS;

RPTAGS.queue:WaitUntil("LOAD_DATA_MENUS",
function(self, event, ...)
  local loc = RPTAGS.utils.locale.loc;
  
  RPTAGS.utils               = RPTAGS.utils               or {};
  RPTAGS.utils.config        = RPTAGS.utils.config        or {};
  RPTAGS.CONST.CONFIG        = RPTAGS.CONST.CONFIG        or {};
  RPTAGS.CONST.CONFIG.VALUES = RPTAGS.CONST.CONFIG.VALUES or {};

  local Values = RPTAGS.CONST.CONFIG.VALUES;
  
  Values.STATUS_ALIGN              = {
    { "TOPLEFT"               , loc("TOPLEFT")                         },
    { "TOPRIGHT"              , loc("TOPRIGHT")                        },
    { "CENTER"                , loc("CENTER")                          },
    { "BOTTOMLEFT"            , loc("BOTTOMLEFT")                      },
    { "BOTTOMRIGHT"           , loc("BOTTOMRIGHT")                     }, };
  
  Values.STATUS_TEXTURE            = {
    { "BLANK"                 , loc("BLANK")                           },
    { "SHADED"                , loc("SHADED")                          },
    { "SOLID"                 , loc("SOLID")                           },
    { "BAR"                   , loc("BAR")                             },
    { "RAID"                  , loc("RAID")                            },
    { "SKILLS"                , loc("SKILLS")                          }, };
  
  Values.RPUF_BACKDROP             = {
    { "ORIGINAL"              , loc("BACKDROP_ORIGINAL" )              },
    { "BLIZZTOOLTIP"          , loc("BACKDROP_BLIZZTOOLTIP")           },
    { "THIN_LINE"             , loc("BACKDROP_THIN_LINE" )             },
    { "THICK_LINE"            , loc("BACKDROP_THICK_LINE" )            }, };
  
  Values.PLAYERLAYOUT              = {
    { "FULL"                  , loc("RPUF_FULL")                       },
    { "ABRIDGED"              , loc("RPUF_ABRIDGED")                   },
    { "COMPACT"               , loc("RPUF_COMPACT")                    },
    { "PAPERDOLL"             , loc("RPUF_PAPERDOLL")                  },
    { "THUMBNAIL"             , loc("RPUF_THUMBNAIL")                  }, };
  
  Values.TARGETLAYOUT              = {
    { "FULL"                  , loc("RPUF_FULL")                       },
    { "ABRIDGED"              , loc("RPUF_ABRIDGED")                   },
    { "COMPACT"               , loc("RPUF_COMPACT")                    },
    { "PAPERDOLL"             , loc("RPUF_PAPERDOLL")                  },
    { "THUMBNAIL"             , loc("RPUF_THUMBNAIL")                  }, };
  
  Values.FOCUSLAYOUT               = {
    { "ABRIDGED"              , loc("RPUF_ABRIDGED")                   },
    { "COMPACT"               , loc("RPUF_COMPACT")                    },
    { "THUMBNAIL"             , loc("RPUF_THUMBNAIL")                  }, };
end);

