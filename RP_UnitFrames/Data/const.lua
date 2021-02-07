-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license.
--
local addOnName, addOn = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("DATA_CONST",
function(self, event, ...)

  local BLACK                    = "000000";
  local WHITE                    = "ffffff";
  local YELLOW                   = "ffff66";

  RPTAGS.CONST.RPUF              =
  { RPUF_COLOR                   = "|cffdd9933",
    INITIAL_POSITION             =
    { player                     =
      { pt                       = 'TOPRIGHT',
        relto                    = 'UIParent',
        relpt                    = 'CENTER',
        x                        = -100,
        y                        = -200 ,
      },
      focus                      =
      { pt                       = 'BOTTOMLEFT',
        relto                    = 'RPUF_Player',
        relpt                    = 'TOPLEFT',
        x                        = 0,
        y                        = 4,
      },
      target                     =
      { pt                       = 'TOPLEFT',
        relto                    = 'UIParent',
        relpt                    = 'CENTER',
        x                        = 100,
        y                        = -200
      },
      mouseover                  =
      { pt                       = 'TOP',
        relto                    = 'UIParent',
        relpt                    = 'TOP',
        x                        = 0,
        y                        = -200
      },
      targettarget               =
      { pt                       = 'BOTTOMRIGHT',
        relto                    = 'RPUF_Target',
        relpt                    = 'TOPRIGHT',
        x                        = 0,
        y                        = 4 },
    },
  };

  RPTAGS.CONST.BACKDROP          =
  { BLIZZTOOLTIP                 =
    { bgFile                     = "Interface\\ChatFrame\\ChatFrameBackground",
      edgeFile                   = "Interface\\Tooltips\\UI-Tooltip-Border",
      tileSize                   = 16,
      edgeSize                   = 16,
      insets                     =
      { left                     = 5,
        right                    = 5,
        top                      = 5,
        bottom                   = 4 ,
      } ,
    },
    THIN_LINE                    =
    { edgeFile                   = "Interface\\Buttons\\White8x8",
      bgFile                     = "Interface\\ChatFrame\\ChatFrameBackground",
      edgeSize                   = 1,
      insets                     =
      { top                      = 0,
        bottom                   = 0,
        left                     = 0,
        right                    = 0 ,
      } ,
    },
    THICK_LINE                   =
    { edgeFile                   = "Interface\\Buttons\\White8x8",
      bgFile                     = "Interface\\ChatFrame\\ChatFrameBackground",
      edgeSize                   = 3,
      insets                     =
      { top                      = 0,
        bottom                   = 0,
        left                     = 0,
        right                    = 0,
      } ,
    },
    ORIGINAL                     =
    { bgFile                     = "Interface\\ChatFrame\\ChatFrameBackground",
      insets                     =
      { top                      = -1,
        bottom                   = -1,
        left                     = -1,
        right                    = -1,
      } ,
    }, -- backdrop
  };
  RPTAGS.CONST.STATUSBAR_TEXTURE =
  { BAR                          =
    { bgFile                     = "Interface\\TargetingFrame\\UI-StatusBar",
      insets                     =
      { top                      = 0,
        bottom                   = 0,
        left                     = 0,
        right                    = 0,
      } ,
    },
    SKILLS                       =
    { bgFile                     = "Interface\\PaperDollInfoFrame\\UI-Character-Skills-Bar",
      insets                     =
      { top                      = 0,
        bottom                   = 0,
        left                     = 0,
        right                    = 0 ,
      } ,
    },
    BLANK                        =
    { bgFile                     = "Interface\\ChatFrame\\ChatFrameBackground",
      insets                     =
      { top                      = 0,
        bottom                   = 0,
        left                     = 0,
        right                    = 0,
      } ,
    },
    SHADED                       =
    { bgFile                     = "Interface\\ChatFrame\\ChatFrameBackground",
      insets                     =
      { top                      = 0,
        bottom                   = 0,
        left                     = 0,
        right                    = 0,
      } ,
    },
    SOLID                        =
    { bgFile                     = "Interface\\Buttons\\White8x8",
      insets                     =
      { top                      = 0,
        bottom                   = 0,
        left                     = 0,
        right                    = 0 ,
      } ,
    },
    RAID                         =
    { bgFile                     = "Interface\\\RaidFrame\\Raid-Bar-Hp-Fill",
      insets                     =
      { top                      = 0,
        bottom                   = 0,
        left                     = 0,
        right                    = 0,
      } ,
    },
  }; -- statusbar
  RPTAGS.CONST.STATUSBAR_ALPHA   =
  { BLANK                        = 0,
    SHADED                       = 0.5,
    SOLID                        = 1,
  };
  RPTAGS.CONST.ALIGN             =
  { CENTER                       =
    { H                          = "CENTER",
      V                          = "MIDDLE",
    },
    LEFT                         =
    { H                          = "LEFT",
      V                          = "MIDDLE",
    },
    RIGHT                        =
    { H                          = "RIGHT",
      V                          = "MIDDLE",
    },
    TOP                          =
    { H                          = "CENTER",
      V                          = "TOP",
    },
    BOTTOM                       =
    { H                          = "CENTER",
      V                          = "BOTTOM",
    },
    TOPLEFT                      =
    { H                          = "LEFT",
      V                          = "TOP",
    },
    TOPRIGHT                     =
    { H                          = "RIGHT",
      V                          = "TOP",
    },
    BOTTOMLEFT                   =
    { H                          = "LEFT",
      V                          = "BOTTOM",
    },
    BOTTOMRIGHT                  =
    { H                          = "RIGHT",
      V                          = "BOTTOM",
    },
  };

  RPTAGS.CONST.ICONS.COLORWHEEL   = "|TInterface\\OptionsFrame\\ColorblindSettings:0::0:0:256:256:0:148:0:148|t";
  RPTAGS.CONST.ICONS.WHITE_       = "|TInterface\\BUTTONS\\WHITE8X8.PNG:0:{w}:" .. "0:0:" .. "8:8:" ..
                                    "0:8:0:8:" .. "{r}:{g}:{b}|t";
  RPTAGS.CONST.ICONS.MORE         = "Calendar\\MoreArrow";
  RPTAGS.CONST.ICONS.AFK          = "FriendsFrame\\StatusIcon-Away"                     ;
  RPTAGS.CONST.ICONS.DND          = "FriendsFrame\\StatusIcon-DnD"                      ;
  RPTAGS.CONST.ICONS.OOC          = "RAIDFRAME\\ReadyCheck-NotReady";
  RPTAGS.CONST.ICONS.IC           = "RAIDFRAME\\ReadyCheck-Ready";
  RPTAGS.CONST.ICONS.STATUS       = "RAIDFRAME\\UI-RaidFrame-Threat";

  -- RPTAGS.CONST.FONT.FIXED        = "Interface\\AddOns\\RP_UnitFrames\\Resources\\Fonts\\Source_Code_Pro\\SourceCodePro-Regular.ttf";
  -- RPTAGS.CONST.FONT.FIXED        = "Interface\\AddOns\\RP_UnitFrames\\Resources\\Fonts\\ShareTechMono\\ShareTechMono-Regular.ttf";
  RPTAGS.CONST.FONT.FIXED        = "Interface\\AddOns\\RP_UnitFrames\\Resources\\Fonts\\Syne_Mono\\SyneMono-Regular.ttf";
  RPTAGS.CONST.NBSP              = "|TInterface\\Store\\ServicesAtlas:0::0:0:1024:1024:1023:1024:1023:1024|t";

  -- disable
  RPTAGS.CONST.CONFIG.DEFAULTS.DISABLE_RPUF        = false;
  RPTAGS.CONST.CONFIG.DEFAULTS.DISABLE_BLIZZARD    = false;
  RPTAGS.CONST.CONFIG.DEFAULTS.RPUF_WITH_ELVUI     = true;

  -- reset
  RPTAGS.CONST.CONFIG.DEFAULTS.RESET_FRAMES        = true;
  RPTAGS.CONST.CONFIG.DEFAULTS.RESET_TAGS          = true;
  RPTAGS.CONST.CONFIG.DEFAULTS.LOCK_FRAMES         = false;

  -- hiding
  RPTAGS.CONST.CONFIG.DEFAULTS.RPUF_HIDE_COMBAT    = true;
  RPTAGS.CONST.CONFIG.DEFAULTS.RPUF_HIDE_VEHICLE   = true;
  RPTAGS.CONST.CONFIG.DEFAULTS.RPUF_HIDE_PETBATTLE = true;
  RPTAGS.CONST.CONFIG.DEFAULTS.RPUF_HIDE_PARTY     = false;
  RPTAGS.CONST.CONFIG.DEFAULTS.RPUF_HIDE_DEAD      = false;
  RPTAGS.CONST.CONFIG.DEFAULTS.RPUF_HIDE_RAID      = true;

  -- appearance
  RPTAGS.CONST.CONFIG.DEFAULTS.COLOR_RPUF          = BLACK;
  RPTAGS.CONST.CONFIG.DEFAULTS.COLOR_RPUF_TEXT     = WHITE;
  RPTAGS.CONST.CONFIG.DEFAULTS.COLOR_RPUF_TOOLTIP  = YELLOW;
  RPTAGS.CONST.CONFIG.DEFAULTS.RPUFALPHA           = 65;
  RPTAGS.CONST.CONFIG.DEFAULTS.RPUF_BACKDROP       = "BLIZZTOOLTIP";
  RPTAGS.CONST.CONFIG.DEFAULTS.STATUS_ALIGN        = "CENTER";
  RPTAGS.CONST.CONFIG.DEFAULTS.STATUS_TEXTURE      = "SHADED";
  RPTAGS.CONST.CONFIG.DEFAULTS.PORTRAIT_STYLE      = "LAYOUT";

  -- scale
  RPTAGS.CONST.CONFIG.DEFAULTS.PLAYERFRAME_SCALE   = 0.9;
  RPTAGS.CONST.CONFIG.DEFAULTS.TARGETFRAME_SCALE   = 0.9;
  RPTAGS.CONST.CONFIG.DEFAULTS.FOCUSFRAME_SCALE    = 0.75;

  -- layouts
  RPTAGS.CONST.CONFIG.DEFAULTS.FOCUSLAYOUT         = "COMPACT";
  RPTAGS.CONST.CONFIG.DEFAULTS.PLAYERLAYOUT        = "ABRIDGED";
  RPTAGS.CONST.CONFIG.DEFAULTS.TARGETLAYOUT        = "FULL";
  RPTAGS.CONST.CONFIG.DEFAULTS.PARTYLAYOUT         = "ABRIDGED";    -- not implemented yet
  RPTAGS.CONST.CONFIG.DEFAULTS.RAIDLAYOUT          = "COMPACT";     -- not implemented yet
  RPTAGS.CONST.CONFIG.DEFAULTS.PARTY_ORIENTATION   = "VERTICAL";
  RPTAGS.CONST.CONFIG.DEFAULTS.RAID_GRID           = "5X8";

  -- dimensions
  RPTAGS.CONST.CONFIG.DEFAULTS.DETAILHEIGHT        = 100;
  RPTAGS.CONST.CONFIG.DEFAULTS.GAPSIZE             = 6;
  RPTAGS.CONST.CONFIG.DEFAULTS.ICONWIDTH           = 25;
  RPTAGS.CONST.CONFIG.DEFAULTS.INFOWIDTH           = 200;
  RPTAGS.CONST.CONFIG.DEFAULTS.PORTRAIT_TYPE       = "FACE";
  RPTAGS.CONST.CONFIG.DEFAULTS.PORTWIDTH           = 100;
  RPTAGS.CONST.CONFIG.DEFAULTS.STATUSHEIGHT        = 35;

  -- panels
  RPTAGS.CONST.CONFIG.DEFAULTS.DETAILPANEL         = "[rp:oocinfo]";
  RPTAGS.CONST.CONFIG.DEFAULTS.ICON_1              = "[rp:icon]";
  RPTAGS.CONST.CONFIG.DEFAULTS.ICON_2              = "[rp:glance-1-icon]";
  RPTAGS.CONST.CONFIG.DEFAULTS.ICON_3              = "[rp:glance-2-icon]";
  RPTAGS.CONST.CONFIG.DEFAULTS.ICON_4              = "[rp:glance-3-icon]";
  RPTAGS.CONST.CONFIG.DEFAULTS.ICON_5              = "[rp:glance-4-icon]";
  RPTAGS.CONST.CONFIG.DEFAULTS.ICON_6              = "[rp:glance-5-icon]";
  RPTAGS.CONST.CONFIG.DEFAULTS.INFOPANEL           = "[rp:race] [rp:class]";
  RPTAGS.CONST.CONFIG.DEFAULTS.NAMEPANEL           = "[rp:color][rp:name]";
  RPTAGS.CONST.CONFIG.DEFAULTS.STATUSPANEL         = "[rp:statuscolor][rp:ic][rp:ooc] [nocolor][rp:currently]";

  -- tooltips
  RPTAGS.CONST.CONFIG.DEFAULTS.DETAIL_TOOLTIP      = "[rp:statuscolor][rp:ic][rp:ooc][nocolor] [rp:oocinfo-label]";
  RPTAGS.CONST.CONFIG.DEFAULTS.ICON_1_TOOLTIP      = "[rp:style-yes-label][br][rp:style-ask-label][br][rp:style-no-label]";
  RPTAGS.CONST.CONFIG.DEFAULTS.ICON_2_TOOLTIP      = "[rp:glance-1-full]";
  RPTAGS.CONST.CONFIG.DEFAULTS.ICON_3_TOOLTIP      = "[rp:glance-2-full]";
  RPTAGS.CONST.CONFIG.DEFAULTS.ICON_4_TOOLTIP      = "[rp:glance-3-full]";
  RPTAGS.CONST.CONFIG.DEFAULTS.ICON_5_TOOLTIP      = "[rp:glance-4-full]";
  RPTAGS.CONST.CONFIG.DEFAULTS.ICON_6_TOOLTIP      = "[rp:glance-5-full]";
  RPTAGS.CONST.CONFIG.DEFAULTS.INFO_TOOLTIP        = "[rp:gendercolor][rp:gender][nocolor] [rp:guildcolor][race] [rp:friendcolor][class] [level]";
  RPTAGS.CONST.CONFIG.DEFAULTS.NAME_TOOLTIP        = "[rp:namecolor][rp:friendcolor][rp:firstname] [rp:nick-quoted] [rp:lastname][nocolor][br][rp:title-long][p][rp:guildcolor][rp:guild-label][nocolor] [rp:guildstatuscolor][rp:guild-status][nocolor][br][rp:guild-rank-label]";
  RPTAGS.CONST.CONFIG.DEFAULTS.PORTRAIT_TOOLTIP    = "[rp:eyecolor][rp:eyes-label][nocolor][br][rp:hair-label][br][rp:actor-label]";
  RPTAGS.CONST.CONFIG.DEFAULTS.STATUS_TOOLTIP      = "[rp:statuscolor][rp:ic][rp:ooc] [nocolor][rp:currently-label]";

 
end);
