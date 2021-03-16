local addOnName, ns = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("DATA_CONST",
function(self, event, ...)

  -- constants we want to use in this file
  local BLACK                    = "000000";
  local WHITE                    = "ffffff";
  local YELLOW                   = "ffff66";
  local TEAL                     = "006060";

  local frameNames =
  { PLAYER       = addOnName .. "_PlayerUnitFrame",
    TARGET       = addOnName .. "_TargetUnitFrame",
    FOCUS        = addOnName .. "_FocusUnitFrame",
    TARGETTARGET = addOnName .. "_TargetTargetUnitFrame",
  };

  local ourConstants = 
  { RPUF_COLOR         = "|cffdd9933",
    OUF_STYLE          = "RP_UnitFrames_UnitFrame",
    FRAME_NAMES        = frameNames,
    EDITOR_MAX_BUTTONS = 13,

    COORDS         =
    { player       = { 125, 550 },
      focus        = { 425, 425 },
      target       = { 425, 550 },
      targettarget = { 700, 750 },
    },

    EDITOR_BUTTON_LIST = 
    {    "rp:name",           "rp:firstname",      "rp:lastname",       "rp:nick",
         "rp:title",          "rp:fulltitle",      "rp:class",          "rp:race",
         "rp:gender",         "rp:pronouns",       "rp:age",            "rp:height",
         "rp:weight",         "rp:status",         "rp:ic",             "rp:ooc",
         "rp:npc",            "rp:curr",           "rp:info",           "rp:color",
         "rp:eyecolor",       "rp:gendercolor",    "rp:relationcolor",  "rp:statuscolor",
         "rp:agecolor",       "rp:heightcolor",    "rp:weightcolor",    "rp:icon",
         "rp:gendericon",     "rp:statusicon",     "rp:raceicon",       "rp:glance-1-icon",
         "rp:glance-2-icon",  "rp:glance-3-icon",  "rp:glance-4-icon",  "rp:glance-5-icon",
         "rp:glance-icons",   "rp:alignment",      "rp:birthplace",     "rp:family",
         "rp:guild",          "rp:motto",          "rp:rstatus",        "rp:home",
         "rp:sexuality",      "p",                 "br",
    },

    --[[ i think this is unused
    ALIGN         =
    { CENTER      = { H = "CENTER", V = "MIDDLE", },
      LEFT        = { H = "LEFT", V   = "MIDDLE", },
      RIGHT       = { H = "RIGHT", V  = "MIDDLE", },
      TOP         = { H = "CENTER", V = "TOP",    },
      BOTTOM      = { H = "CENTER", V = "BOTTOM", },
      TOPLEFT     = { H = "LEFT", V   = "TOP",    },
      TOPRIGHT    = { H = "RIGHT", V  = "TOP",    },
      BOTTOMLEFT  = { H = "LEFT", V   = "BOTTOM", },
      BOTTOMRIGHT = { H = "RIGHT", V  = "BOTTOM", },
    },
    --]]

    PANEL_INFO =
    { name            =
      { setting       = "NAMEPANEL",
        tooltip       = "NAME_TOOLTIP",
        use_font      = "NAMEPANEL_FONTNAME",
      },
      info            =
      { setting       = "INFOPANEL",
        tooltip       = "INFO_TOOLTIP",
        use_font      = "INFOPANEL_FONTNAME",
      },
      details         =
      { setting       = "DETAILPANEL",
        tooltip       = "DETAIL_TOOLTIP",
        use_font      = "DETAILPANEL_FONTNAME",
      },
      icon1           =
      { setting       = "ICON_1",
        iconsize      = true,
        tooltip       = "ICON_1_TOOLTIP",
      },
      icon2           =
      { setting       = "ICON_2",
        iconsize      = true,
        tooltip       = "ICON_2_TOOLTIP",
      },
      icon3           =
      { setting       = "ICON_3",
        iconsize      = true,
        tooltip       = "ICON_3_TOOLTIP",
      },
      icon4           =
      { setting       = "ICON_4",
        iconsize      = true,
        tooltip       = "ICON_4_TOOLTIP",
      },
      icon5           =
      { setting       = "ICON_5",
        iconsize      = true,
        tooltip       = "ICON_5_TOOLTIP",
      },
      icon6           =
      { setting       = "ICON_6",
        iconsize      = true,
        tooltip       = "ICON_6_TOOLTIP",
      },
      portrait        =
      { no_tag_string = true,
        tooltip       = "PORTRAIT_TOOLTIP",
        portrait      = true,
      },
      statusBar       =
      { setting       = "STATUSPANEL",
        tooltip       = "STATUS_TOOLTIP",
        has_statusBar = true,
        has_own_align = "STATUS_ALIGN",
        use_font      = "STATUSPANEL_FONTNAME",
      },
    },
  };
  
  local ourIcons =
  { COLORWHEEL   = "|A:colorblind-colorwheel:0:0|a",
    WHITE        = "|TInterface\\BUTTONS\\WHITE8X8.PNG:0:{w}:0:0:8:8:0:8:0:8:%s:%s:%s|t",
    MORE         = "Calendar\\MoreArrow",
    AFK          = "FriendsFrame\\StatusIcon-Away",
    DND          = "FriendsFrame\\StatusIcon-DnD",
    OOC          = "RAIDFRAME\\ReadyCheck-NotReady",
    IC           = "RAIDFRAME\\ReadyCheck-Ready",
    STATUS       = "RAIDFRAME\\UI-RaidFrame-Threat",
  };

  local ourFrameConfig    =
  { COLOR_RPUF          = WHITE,
    COLOR_RPUF_BORDER   = YELLOW,
    COLOR_RPUF_TEXT     = WHITE,
    COLOR_RPUF_TOOLTIP  = YELLOW,
    COLOR_STATUS        = TEAL,
    COLOR_STATUS_TEXT   = WHITE,
    DETAILHEIGHT        = 100,
    DETAILPANEL_FONTNAME = "Arial Narrow",
    DETAILPANEL_FONTSIZE = "medium",
    INFOPANEL_FONTNAME   = "Arial Narrow",
    INFOPANEL_FONTSIZE   = "medium",
    NAMEPANEL_FONTNAME   = "Morpheus", 
    NAMEPANEL_FONTSIZE   = "extralarge",
    STATUSPANEL_FONTNAME   = "Arial Narrow",
    STATUSPANEL_FONTSIZE   = "medium",
    FONTSIZE            = 10,
    GAPSIZE             = 6,
    ICONWIDTH           = 25,
    INFOWIDTH           = 200,
    LINK_FRAME          = true,
    LOCK_FRAME          = true,
    MOUSEOVER_CURSOR    = true,
    PORTRAIT_BG         = "None",
    PORTRAIT_BORDER     = "None",
    PORTRAIT_STYLE      = "STANDARD",
    PORTWIDTH           = 100,
    RPUFALPHA           = 0.65,
    RPUF_BACKDROP       = "Blizzard Parchment 2",
    RPUF_BORDER         = "Blizzard Tooltip",
    RPUF_BORDER_WIDTH   = 12,
    RPUF_BORDER_INSETS  = 4,
    RPUF_HIDE_COMBAT    = true,
    RPUF_HIDE_DEAD      = false,
    RPUF_HIDE_PARTY     = false,
    RPUF_HIDE_PETBATTLE = true,
    RPUF_HIDE_RAID      = true,
    RPUF_HIDE_VEHICLE   = true,
    SHOW_FRAME          = true,
    STATUSHEIGHT        = 35,
    STATUS_ALIGN        = "CENTER",
    STATUS_TEXTURE      = "Blizzard Character Skills Bar",
    STATUS_ALPHA        = 0.65,
  };

  local ourConfig = 
  { SHOW_FRAME_TARGETTARGET = false,

    -- disable
    DISABLE_RPUF            = false,
    DISABLE_BLIZZARD        = false,

    -- scale
    PLAYERFRAME_SCALE       = 1,
    TARGETFRAME_SCALE       = 1,
    FOCUSFRAME_SCALE        = 1,
    TARGETTARGETFRAME_SCALE = 1,

    -- layouts
    FOCUSLAYOUT               = "COMPACT",
    PLAYERLAYOUT              = "ABRIDGED",
    TARGETLAYOUT              = "FULL",
    TARGETTARGETLAYOUT        = "COMPACT",
    --[[ not implemented yet(?):
    PARTYLAYOUT               = "ABRIDGED",
    RAIDLAYOUT                = "COMPACT",
    PARTY_ORIENTATION         = "VERTICAL",
    RAID_GRID                 = "5X8",
    --]]

    -- panel initial values
    DETAILPANEL = "[rp:oocinfo]",
    ICON_1      = "[rp:icon]",
    ICON_2      = "[rp:glance-1-icon]",
    ICON_3      = "[rp:glance-2-icon]",
    ICON_4      = "[rp:glance-3-icon]",
    ICON_5      = "[rp:glance-4-icon]",
    ICON_6      = "[rp:glance-5-icon]",
    INFOPANEL   = "[rp:race] [rp:class]",
    NAMEPANEL   = "[rp:color][rp:name]",
    STATUSPANEL = "[rp:statuscolor][rp:ic][rp:ooc] [nocolor][rp:currently]",

    -- tooltip initial values
    DETAIL_TOOLTIP   = "[rp:statuscolor][rp:ic][rp:ooc][nocolor] [rp:oocinfo-label]",
    ICON_1_TOOLTIP   = "[rp:style-yes-label][br][rp:style-ask-label][br][rp:style-no-label]",
    ICON_2_TOOLTIP   = "[rp:glance-1-full]",
    ICON_3_TOOLTIP   = "[rp:glance-2-full]",
    ICON_4_TOOLTIP   = "[rp:glance-3-full]",
    ICON_5_TOOLTIP   = "[rp:glance-4-full]",
    ICON_6_TOOLTIP   = "[rp:glance-5-full]",
    INFO_TOOLTIP     = "[rp:gendercolor][rp:gender][nocolor] [rp:guildcolor][race] [rp:friendcolor][class] [level]",
    NAME_TOOLTIP     = "[rp:namecolor][rp:friendcolor][rp:firstname] [rp:nick-quoted] [rp:lastname][nocolor][br][rp:title-long][p][rp:guildcolor][rp:guild-label][nocolor] [rp:guildstatuscolor][rp:guild-status][nocolor][br][rp:guild-rank-label]",
    PORTRAIT_TOOLTIP = "[rp:eyecolor][rp:eyes-label][nocolor][br][rp:hair-label][br][rp:actor-label]",
    STATUS_TOOLTIP   = "[rp:statuscolor][rp:ic][rp:ooc] [nocolor][rp:currently-label]",
    --[[
    STATUS_TOOLTIP   = "[rp:statuscolor][rp:ic][rp:ooc] [nocolor][rp:currently]",
    PORTRAIT_TOOLTIP = "[rp:eyecolor][rp:eyes][nocolor][br][rp:hair][br][rp:actor]",
    NAME_TOOLTIP     = "[rp:namecolor][rp:friendcolor][rp:firstname] [rp:nick-quoted] [rp:lastname][nocolor][br][rp:title-long][p][rp:guildcolor][rp:guild][nocolor] [rp:guildstatuscolor][rp:guild-status][nocolor][br][rp:guild-rank]",
    DETAIL_TOOLTIP   = "[rp:statuscolor][rp:ic][rp:ooc][nocolor] [rp:oocinfo]",
    ICON_1_TOOLTIP   = "[rp:style-yes][br][rp:style-ask][br][rp:style-no]",
    --]]

    EDITOR_FONT          = "Source Code Pro",
    EDITOR_FONTSIZE      = 10,

    -- editor buttons
    EDITOR_BUTTON_RPNAME          = true,
    EDITOR_BUTTON_RPFIRSTNAME     = false,
    EDITOR_BUTTON_RPLASTNAME      = false,
    EDITOR_BUTTON_RPNICK          = false,
    EDITOR_BUTTON_RPTITLE         = false,
    EDITOR_BUTTON_RPFULLTITLE     = true,
    EDITOR_BUTTON_RPCLASS         = true,
    EDITOR_BUTTON_RPRACE          = true,
    EDITOR_BUTTON_RPGENDER        = false,
    EDITOR_BUTTON_RPPRONOUNS      = false,
    EDITOR_BUTTON_RPAGE           = false,
    EDITOR_BUTTON_RPWEIGHT        = false,
    EDITOR_BUTTON_RPHEIGHT        = false,
    EDITOR_BUTTON_RPSTATUS        = false,
    EDITOR_BUTTON_RPIC            = false,
    EDITOR_BUTTON_RPOOC           = false,
    EDITOR_BUTTON_RPNPC           = false,
    EDITOR_BUTTON_RPCURR          = false,
    EDITOR_BUTTON_RPINFO          = false,
    EDITOR_BUTTON_RPCOLOR         = true,
    EDITOR_BUTTON_RPEYECOLOR      = false,
    EDITOR_BUTTON_RPGENDERCOLOR   = false,
    EDITOR_BUTTON_RPRELATIONCOLOR = false,
    EDITOR_BUTTON_RPSTATUSCOLOR   = false,
    EDITOR_BUTTON_RPAGECOLOR      = false,
    EDITOR_BUTTON_RPHEIGHTCOLOR   = false,
    EDITOR_BUTTON_RPWEIGHTCOLOR   = false,
    EDITOR_BUTTON_RPICON          = true,
    EDITOR_BUTTON_RPGENDERICON    = false,
    EDITOR_BUTTON_RPRACEICON      = false,
    EDITOR_BUTTON_RPSTATUSICON    = false,
    EDITOR_BUTTON_RPGLANCE1ICON   = false,
    EDITOR_BUTTON_RPGLANCE2ICON   = false,
    EDITOR_BUTTON_RPGLANCE3ICON   = false,
    EDITOR_BUTTON_RPGLANCE4ICON   = false,
    EDITOR_BUTTON_RPGLANCE5ICON   = false,
    EDITOR_BUTTON_RPGLANCEICONS   = false,
    EDITOR_BUTTON_RPALIGNMENT     = false,
    EDITOR_BUTTON_RPBIRTHPLACE    = false,
    EDITOR_BUTTON_RPFAMILY        = false,
    EDITOR_BUTTON_RPGUILD         = false,
    EDITOR_BUTTON_RPMOTTO         = false,
    EDITOR_BUTTON_RPRSTATUS       = false,
    EDITOR_BUTTON_RPSEXUALITY     = false,
    EDITOR_BUTTON_RPHOME          = false,
    EDITOR_BUTTON_P               = false,
    EDITOR_BUTTON_BR              = true,
  };

  local ourUIPanels = 
  { frames            = "opt://RPUF_Main",
    frames_shared     = "opt://RPUF_Main/shared",
    frames_visibility = "opt://RPUF_Main/visibilty",
    frames_look       = "opt://RPUF_Main/look",
    frames_sizes      = "opt://RPUF_Main/sizes",
    frames_position   = "opt://RPUF_Main/position",
    player            = "opt://RPUF_Main/playerFrame",
    target            = "opt://RPUF_Main/targetFrame",
    focus             = "opt://RPUF_Main/focusFrame",
    targetTarget      = "opt://RPUF_Main/targetTargetFrame",
    panels            = "opt://RPUF_Panels",
    panel_name        = "opt://RPUF_Panels/namePanel",
    panel_info        = "opt://RPUF_Panels/infoPanel",
    panel_status      = "opt://RPUF_Panels/statusPanel",
    panel_detail      = "opt://RPUF_Panels/detailPanel",
    panel_portrait    = "opt://RPUF_Panels/portraitPanel",
    panel_icon1       = "opt://RPUF_Panels/iconAPanel",
    panel_icon2       = "opt://RPUF_Panels/iconBPanel",
    panel_icon3       = "opt://RPUF_Panels/iconCPanel",
    panel_icon4       = "opt://RPUF_Panels/iconDPanel",
    panel_icon5       = "opt://RPUF_Panels/iconEPanel",
    panel_icon6       = "opt://RPUF_Panels/iconFPanel",
    editor            = "opt://RPUF_Editor",
    editor_buttons    = "opt://RPUF_Editor/buttonBar",
  };

  local ourConfigBlanks = { "LINK_FRAME", "SHOW_FRAME", };

  local ourUrls = {};
  --[[
  local ourConstants   =
  local ourIcons       =
  local ourFrameConfig =
  local ourConfig      =
  local ourUIPanels    =
  local ourConfigBlanks =
  --]]

  RPTAGS.CONST.RPUF = RPTAGS.CONST.RPUF or {};

  for baseKey, value in pairs(ourFrameConfig)
  do  RPTAGS.CONST.CONFIG[baseKey] = value;
      for frame, _ in pairs(frameNames)
      do  RPTAGS.CONST.CONFIG[baseKey .. "_" .. frame] = value;
     end;
  end;

  for const,   value in pairs(ourConstants)     do RPTAGS.CONST.RPUF[     const   ] = value; end ;
  for icon,    value in pairs(ourIcons)         do RPTAGS.CONST.ICONS[    icon    ] = value; end ;
  for _,       key   in ipairs(ourConfigBlanks) do RPTAGS.CONST.CONFIG[   key     ] = nil;   end ;
  for key,     value in pairs(ourConfig)        do RPTAGS.CONST.CONFIG[   key     ] = value; end ;
  for uipanel, value in pairs(ourUIPanels)      do RPTAGS.CONST.UIPANELS[ uipanel ] = value; end ;
  for url,     data  in pairs(ourUrls)          do RPTAGS.CONST.URLS[     url     ] = data;  end ;

end);
