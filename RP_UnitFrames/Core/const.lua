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
  local TEAL                     = "006060";

  RPTAGS.CONST.RPUF              =
  { RPUF_COLOR                   = "|cffdd9933",
    OUF_STYLE                    = "RP_UnitFrames_UnitFrame",
    COORDS                       =
    { player                     = { 200, 200 },
      focus                      = { 250, 200 },
      target                     = { 600, 200 },
      targettarget               = { 550, 200 },
    },
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

  RPTAGS.CONST.FRAMES = 
  { NAMES = 
    { PLAYER       = "RP_UnitFrames_PlayerUnitFrame",
      TARGET       = "RP_UnitFrames_TargetUnitFrame",
      FOCUS        = "RP_UnitFrames_FocusUnitFrame",
      TARGETTARGET = "RP_UnitFrames_TargetTargetUnitFrame",
    },
   PANELS = 
   { "NamePanel", 
     "InfoPanel", 
     "PortraitPanel", 
     "DetailsPanel", 
     "StatusBarPanel", 
     "Icon_1Panel", 
     "Icon_2Panel", 
     "Icon_3Panel", 
   },
  };
  -- RPTAGS.CONST.ICONS.COLORWHEEL   = "|TInterface\\OptionsFrame\\ColorblindSettings:0::0:0:256:256:0:148:0:148|t";
  RPTAGS.CONST.ICONS.COLORWHEEL   = "|A:colorblind-colorwheel:0:0|a";
  RPTAGS.CONST.ICONS.WHITE_       = "|TInterface\\BUTTONS\\WHITE8X8.PNG:0:{w}:" .. "0:0:" .. "8:8:" ..
                                    "0:8:0:8:" .. "{r}:{g}:{b}|t";
  RPTAGS.CONST.ICONS.MORE         = "Calendar\\MoreArrow";
  RPTAGS.CONST.ICONS.AFK          = "FriendsFrame\\StatusIcon-Away"                     ;
  RPTAGS.CONST.ICONS.DND          = "FriendsFrame\\StatusIcon-DnD"                      ;
  RPTAGS.CONST.ICONS.OOC          = "RAIDFRAME\\ReadyCheck-NotReady";
  RPTAGS.CONST.ICONS.IC           = "RAIDFRAME\\ReadyCheck-Ready";
  RPTAGS.CONST.ICONS.STATUS       = "RAIDFRAME\\UI-RaidFrame-Threat";

  RPTAGS.CONST.FONT.FIXED        = "Syne Mono";
  RPTAGS.CONST.NBSP              = "|TInterface\\Store\\ServicesAtlas:0::0:0:1024:1024:1023:1024:1023:1024|t";

  local CONFIG = RPTAGS.CONST.CONFIG.DEFAULTS;

  -- disable
  CONFIG.DISABLE_RPUF     = false;
  CONFIG.DISABLE_BLIZZARD = false;

  local perFrame          =
  { RPUFALPHA             = 65,
    RPUF_BACKDROP         = "Blizzard Parchment 2",
    RPUF_BORDER           = "Blizzard Tooltip",
    COLOR_RPUF_BORDER     = YELLOW,
    DETAILHEIGHT          = 100,
    FONTNAME              = "Arial Narrow",
    FONTSIZE              = 12,
    GAPSIZE               = 6,
    RPUF_HIDE_COMBAT      = true,
    RPUF_HIDE_DEAD        = false,
    RPUF_HIDE_PARTY       = false,
    RPUF_HIDE_PETBATTLE   = true,
    RPUF_HIDE_RAID        = true,
    RPUF_HIDE_VEHICLE     = true,
    ICONWIDTH             = 25,
    INFOWIDTH             = 200,
    LINK_FRAME            = true,
    LOCK_FRAMES           = true,
    MOUSEOVER_CURSOR      = true,
    PORTWIDTH             = 100,
    PORTRAIT_STYLE        = "Standard",
    PORTRAIT_BG           = "None",
    PORTRAIT_BORDER       = "None",
    STATUSHEIGHT          = 35,
    STATUS_ALIGN          = "CENTER",
    STATUS_TEXTURE        = "Blizzard Character Skills Bar",
    SHOW_FRAME            = true,
    COLOR_RPUF            = BLACK,
    COLOR_RPUF_TEXT       = WHITE,
    COLOR_RPUF_TOOLTIP    = YELLOW,
    COLOR_STATUS          = TEAL,
    COLOR_STATUS_TEXT     = WHITE,

  };

  for k, v in pairs(perFrame)
  do CONFIG[k] = v;
     for frame, _ in pairs(RPTAGS.CONST.FRAMES.NAMES)
     do  CONFIG[k .. "_" .. frame] = v
     end;
  end;

  CONFIG.SHOW_FRAME_TARGETTARGET = false;

  -- scale
  CONFIG.PLAYERFRAME_SCALE   = 0.9;
  CONFIG.TARGETFRAME_SCALE   = 0.9;
  CONFIG.FOCUSFRAME_SCALE    = 0.75;
  CONFIG.TARGETTARGETFRAME_SCALE = 0.75;

  -- layouts
  CONFIG.FOCUSLAYOUT         = "COMPACT";
  CONFIG.PLAYERLAYOUT        = "ABRIDGED";
  CONFIG.TARGETLAYOUT        = "FULL";
  CONFIG.TARGETTARGETLAYOUT  = "COMPACT";
  CONFIG.PARTYLAYOUT         = "ABRIDGED";    -- not implemented yet
  CONFIG.RAIDLAYOUT          = "COMPACT";     -- not implemented yet
  CONFIG.PARTY_ORIENTATION   = "VERTICAL";
  CONFIG.RAID_GRID           = "5X8";

  -- panels
  CONFIG.DETAILPANEL         = "[rp:oocinfo]";
  CONFIG.ICON_1              = "[rp:icon]";
  CONFIG.ICON_2              = "[rp:glance-1-icon]";
  CONFIG.ICON_3              = "[rp:glance-2-icon]";
  CONFIG.ICON_4              = "[rp:glance-3-icon]";
  CONFIG.ICON_5              = "[rp:glance-4-icon]";
  CONFIG.ICON_6              = "[rp:glance-5-icon]";
  CONFIG.INFOPANEL           = "[rp:race] [rp:class]";
  CONFIG.NAMEPANEL           = "[rp:color][rp:name]";
  CONFIG.STATUSPANEL         = "[rp:statuscolor][rp:ic][rp:ooc] [nocolor][rp:currently]";

  -- fonts
  CONFIG.DETAILPANEL_FONTSIZE = "medium";
  CONFIG.ICON_1_FONTSIZE = "large";
  CONFIG.ICON_2_FONTSIZE = "large";
  CONFIG.ICON_3_FONTSIZE = "large";
  CONFIG.ICON_4_FONTSIZE = "large";
  CONFIG.ICON_5_FONTSIZE = "large";
  CONFIG.ICON_6_FONTSIZE = "large";
  CONFIG.INFOPANEL_FONTSIZE = "medium";
  CONFIG.NAMEPANEL_FONTSIZE = "extralarge";
  CONFIG.STATUSPANEL_FONTSIZE = "medium";

  CONFIG.NAMEPANEL_FONTNAME = "Morpheus";

  --
  -- tooltips
  CONFIG.DETAIL_TOOLTIP      = "[rp:statuscolor][rp:ic][rp:ooc][nocolor] [rp:oocinfo-label]";
  -- CONFIG.DETAIL_TOOLTIP      = "[rp:statuscolor][rp:ic][rp:ooc][nocolor] [rp:oocinfo]";
  CONFIG.ICON_1_TOOLTIP      = "[rp:style-yes-label][br][rp:style-ask-label][br][rp:style-no-label]";
  -- CONFIG.ICON_1_TOOLTIP      = "[rp:style-yes][br][rp:style-ask][br][rp:style-no]";
  CONFIG.ICON_2_TOOLTIP      = "[rp:glance-1-full]";
  CONFIG.ICON_3_TOOLTIP      = "[rp:glance-2-full]";
  CONFIG.ICON_4_TOOLTIP      = "[rp:glance-3-full]";
  CONFIG.ICON_5_TOOLTIP      = "[rp:glance-4-full]";
  CONFIG.ICON_6_TOOLTIP      = "[rp:glance-5-full]";
  CONFIG.INFO_TOOLTIP        = "[rp:gendercolor][rp:gender][nocolor] [rp:guildcolor][race] [rp:friendcolor][class] [level]";
  CONFIG.NAME_TOOLTIP        = "[rp:namecolor][rp:friendcolor][rp:firstname] [rp:nick-quoted] [rp:lastname][nocolor][br][rp:title-long][p][rp:guildcolor][rp:guild-label][nocolor] [rp:guildstatuscolor][rp:guild-status][nocolor][br][rp:guild-rank-label]";
  -- CONFIG.NAME_TOOLTIP        = "[rp:namecolor][rp:friendcolor][rp:firstname] [rp:nick-quoted] [rp:lastname][nocolor][br][rp:title-long][p][rp:guildcolor][rp:guild][nocolor] [rp:guildstatuscolor][rp:guild-status][nocolor][br][rp:guild-rank]";
  CONFIG.PORTRAIT_TOOLTIP    = "[rp:eyecolor][rp:eyes-label][nocolor][br][rp:hair-label][br][rp:actor-label]";
  -- CONFIG.PORTRAIT_TOOLTIP    = "[rp:eyecolor][rp:eyes][nocolor][br][rp:hair][br][rp:actor]";
  CONFIG.STATUS_TOOLTIP      = "[rp:statuscolor][rp:ic][rp:ooc] [nocolor][rp:currently-label]";
  -- CONFIG.STATUS_TOOLTIP      = "[rp:statuscolor][rp:ic][rp:ooc] [nocolor][rp:currently]";

  -- editor
  CONFIG.EDITOR_FONT         = "Syne Mono";
  CONFIG.EDITOR_FONTSIZE     = 10;
  CONFIG.EDITOR_BUTTONS      = "rp:name|rp:color|rp:eyes|rp:eyecolor|rp:class|rp:icon|rp:height|rp:gender|rp:race|rp:fulltitle|rp:age|rp:body|rp:status|rp:statuscolor|rp:gendercolor";
  CONFIG.EDITOR_BUTTON_BAR   = true;
 
  RPTAGS.CONST.RPUF.EDITOR_MAX_BUTTONS = 13;

  CONFIG.EDITOR_NUM_BUTTONS = 7;
  CONFIG.EDITOR_BUTTON_RPNAME          = true;
  CONFIG.EDITOR_BUTTON_RPFIRSTNAME     = false;
  CONFIG.EDITOR_BUTTON_RPLASTNAME      = false;
  CONFIG.EDITOR_BUTTON_RPNICK          = false;
  CONFIG.EDITOR_BUTTON_RPTITLE         = false;
  CONFIG.EDITOR_BUTTON_RPFULLTITLE     = true;
  CONFIG.EDITOR_BUTTON_RPCLASS         = true;
  CONFIG.EDITOR_BUTTON_RPRACE          = true;
  CONFIG.EDITOR_BUTTON_RPGENDER        = false;
  CONFIG.EDITOR_BUTTON_RPPRONOUNS      = false;
  CONFIG.EDITOR_BUTTON_RPAGE           = false;
  CONFIG.EDITOR_BUTTON_RPWEIGHT        = false;
  CONFIG.EDITOR_BUTTON_RPHEIGHT        = false;
  CONFIG.EDITOR_BUTTON_RPSTATUS        = false;
  CONFIG.EDITOR_BUTTON_RPIC            = false;
  CONFIG.EDITOR_BUTTON_RPOOC           = false;
  CONFIG.EDITOR_BUTTON_RPNPC           = false;
  CONFIG.EDITOR_BUTTON_RPCURR          = false;
  CONFIG.EDITOR_BUTTON_RPINFO          = false;
  CONFIG.EDITOR_BUTTON_RPCOLOR         = true;
  CONFIG.EDITOR_BUTTON_RPEYECOLOR      = false;
  CONFIG.EDITOR_BUTTON_RPGENDERCOLOR   = false;
  CONFIG.EDITOR_BUTTON_RPRELATIONCOLOR = false;
  CONFIG.EDITOR_BUTTON_RPSTATUSCOLOR   = false;
  CONFIG.EDITOR_BUTTON_RPAGECOLOR      = false;
  CONFIG.EDITOR_BUTTON_RPHEIGHTCOLOR   = false;
  CONFIG.EDITOR_BUTTON_RPWEIGHTCOLOR   = false;
  CONFIG.EDITOR_BUTTON_RPICON          = true;
  CONFIG.EDITOR_BUTTON_RPGENDERICON    = false;
  CONFIG.EDITOR_BUTTON_RPRACEICON      = false;
  CONFIG.EDITOR_BUTTON_RPSTATUSICON    = false;
  CONFIG.EDITOR_BUTTON_RPGLANCE1ICON   = false;
  CONFIG.EDITOR_BUTTON_RPGLANCE2ICON   = false;
  CONFIG.EDITOR_BUTTON_RPGLANCE3ICON   = false;
  CONFIG.EDITOR_BUTTON_RPGLANCE4ICON   = false;
  CONFIG.EDITOR_BUTTON_RPGLANCE5ICON   = false;
  CONFIG.EDITOR_BUTTON_RPGLANCEICONS   = false;
  CONFIG.EDITOR_BUTTON_RPALIGNMENT     = false;
  CONFIG.EDITOR_BUTTON_RPBIRTHPLACE    = false;
  CONFIG.EDITOR_BUTTON_RPFAMILY        = false;
  CONFIG.EDITOR_BUTTON_RPGUILD         = false;
  CONFIG.EDITOR_BUTTON_RPMOTTO         = false;
  CONFIG.EDITOR_BUTTON_RPRSTATUS       = false;
  CONFIG.EDITOR_BUTTON_RPSEXUALITY     = false;
  CONFIG.EDITOR_BUTTON_RPHOME          = false;
  CONFIG.EDITOR_BUTTON_P               = false;
  CONFIG.EDITOR_BUTTON_BR              = true;

  RPTAGS.CONST.RPUF.EDITOR_BUTTON_LIST = 
  { "rp:name", "rp:firstname", "rp:lastname", "rp:nick",
    "rp:title", "rp:fulltitle", "rp:class", "rp:race",
    "rp:gender", "rp:pronouns", "rp:age", "rp:height",
    "rp:weight",
    "rp:status", "rp:ic", "rp:ooc", "rp:npc", "rp:curr", "rp:info",
    "rp:color", "rp:eyecolor", "rp:gendercolor", "rp:relationcolor",
    "rp:statuscolor", "rp:agecolor", "rp:heightcolor", 
    "rp:weightcolor",
    "rp:icon", "rp:gendericon", "rp:statusicon", "rp:raceicon",
    "rp:glance-1-icon", "rp:glance-2-icon", "rp:glance-3-icon",
    "rp:glance-4-icon", "rp:glance-5-icon", "rp:glance-icons",
    "rp:alignment", "rp:birthplace", "rp:family", "rp:guild",
    "rp:motto", "rp:rstatus", "rp:home", "rp:sexuality",
    "p", "br",
  };

  RPTAGS.CONST.UIPANELS.frames            = "opt://RPUF_Main";
  RPTAGS.CONST.UIPANELS.frames_shared     = "opt://RPUF_Main/shared";
  RPTAGS.CONST.UIPANELS.frames_visibility = "opt://RPUF_Main/visibilty";
  RPTAGS.CONST.UIPANELS.frames_look       = "opt://RPUF_Main/look";
  RPTAGS.CONST.UIPANELS.frames_sizes      = "opt://RPUF_Main/sizes";
  RPTAGS.CONST.UIPANELS.frames_position   = "opt://RPUF_Main/position";
  RPTAGS.CONST.UIPANELS.player            = "opt://RPUF_Main/playerFrame";
  RPTAGS.CONST.UIPANELS.target            = "opt://RPUF_Main/targetFrame";
  RPTAGS.CONST.UIPANELS.focus             = "opt://RPUF_Main/focusFrame";
  RPTAGS.CONST.UIPANELS.targetTarget      = "opt://RPUF_Main/targetTargetFrame";
  RPTAGS.CONST.UIPANELS.panels            = "opt://RPUF_Panels";
  RPTAGS.CONST.UIPANELS.panel_name        = "opt://RPUF_Panels/namePanel";
  RPTAGS.CONST.UIPANELS.panel_info        = "opt://RPUF_Panels/infoPanel";
  RPTAGS.CONST.UIPANELS.panel_status      = "opt://RPUF_Panels/statusPanel";
  RPTAGS.CONST.UIPANELS.panel_detail      = "opt://RPUF_Panels/detailPanel";
  RPTAGS.CONST.UIPANELS.panel_portrait    = "opt://RPUF_Panels/portraitPanel";
  RPTAGS.CONST.UIPANELS.panel_icon1       = "opt://RPUF_Panels/iconAPanel";
  RPTAGS.CONST.UIPANELS.panel_icon2       = "opt://RPUF_Panels/iconBPanel";
  RPTAGS.CONST.UIPANELS.panel_icon3       = "opt://RPUF_Panels/iconCPanel";
  RPTAGS.CONST.UIPANELS.panel_icon4       = "opt://RPUF_Panels/iconDPanel";
  RPTAGS.CONST.UIPANELS.panel_icon5       = "opt://RPUF_Panels/iconEPanel";
  RPTAGS.CONST.UIPANELS.panel_icon6       = "opt://RPUF_Panels/iconFPanel";
  RPTAGS.CONST.UIPANELS.editor            = "opt://RPUF_Editor";
  RPTAGS.CONST.UIPANELS.editor_buttons    = "opt://RPUF_Editor/buttonBar";

end);
