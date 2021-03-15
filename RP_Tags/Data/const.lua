-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license.
--
local RPTAGS = RPTAGS;
RPTAGS.queue:WaitUntil("DATA_CONST",
function(self, event, ...)

  RPTAGS.CONST = RPTAGS.CONST or {};

  local C = RPTAGS.CONST;

  -- values we want to use later in the file
  local MALE           = 2;
  local NEUTER         = 1;
  local FEMALE         = 3;
  local THEY           = 8675309; -- this is a custom number used internally
  local GENDER_UNKNOWN = 5552368; -- also a custom number
  local GENDER_DEFAULT = NEUTER;

  C.APP_ID     = "rptags";
  C.VERSION    = RPTAGS.metadata["Version"];

    --         = Localization prefixes
  C.FLOC       = "FMT_";
  C.TAG_PREFIX = "TAG_"; -- is this used?

    --         = Configuration Options -- are these used?
  C.VERYSHORT  = 10; -- these define the lengths of things
  C.SHORT      = 20; -- need to be reconciled with ElvUI?
  C.MEDIUM     = 40;
  C.LONG       = 60;
  C.VERYLONG   = 150;

  -- colors
  C.COLOR =
  { CYAN       = "ff3399",
    GREEN      = "33ff33",
    GREY       = "999999",
    LIGHT_GREY = "bbbbbb",
    LIGHT_BLUE = "00bbbb",
    ORANGE     = "ff9966",
    PINK       = "ff66ff",
    RED        = "ff3333",
    YELLOW     = "ffff66",
    VIOLET     = "dd33aa",
    ORAIBI     = "bb00bb",
  };

  C.APP_COLOR   = "|cff" .. C.COLOR.VIOLET;
  C.ORAIBI      = "|cff" .. C.COLOR.ORAIBI .. "|r"; --
    --          =
  C.INDENT      = "     ";
    --          =
  C.BIG_PROFILE = 10;  -- what a "big profile" means; in terms of 255-character blocks
    --          = Building tags with these
  C.TAG         = "rp:";
  C.MAIN_EVENT  = "PLAYER_TARGET_CHANGED PLAYER_FOCUS_CHANGED";

    --          = relcolor
  C.RELCOLOR   = -- could move to config?
  { NONE       = "",
    FRIEND     = "|cff00ff00",
    UNFRIENDLY = "|cffff0000",
    NEUTRAL    = "|cff8080ff",
    BUSINESS   = "|cffffff00",
    LOVE       = "|cffff80ff",
    FAMILY     = "|cffffaa00",
  };

    -- ------------- = Sizebuffs
  C.SIZEBUFFS =
  { -- include them here if they have a duration of 5 min or longer
    [   8212] = { buffName = "Giant Growth Potion",  sizeChange = 30,  foodBuff = false, },
    [  16595] = { buffName = "Noggenfogger Elixir",  sizeChange = -50, foodBuff = false, },
    [  17038] = { buffName = "Winterfall Firewater", sizeChange = 25,  foodBuff = false, },
    [  58466] = { buffName = "Giant Feast",          sizeChange = 30,  foodBuff = true,  },
    [  58479] = { buffName = "Small Feast",          sizeChange = -30, foodBuff = true,  },
    [  98444] = { buffName = "Vrykul Drinking Horn", sizeChange = 30,  foodBuff = false, },
    [ 109933] = { buffName = "Darkmoon Firewater",   sizeChange = 25,  foodBuff = false, },
    [ 143034] = { buffName = "Darkmoon Seesaw",      sizeChange = -33, foodBuff = false, },
  };
    
  -- do i really need these? i replaced manually maintaining this with the lib
  C.SERVER = { -- only RP servers
    --[[
    ID = { [""]                      =   0, ["Silver Hand"]         =   12, ["Argent Dawn"]          =   75, ["Cenarion Circle"]        =   88, 
           ["Earthen Ring"]         =  100, ["Feathermoon"]         =  118, ["Shadow Council"]       =  125, ["Scarlet Crusade"]        =  126, 
           ["Emerald Dream"]        =  162, ["Maelstrom"]           =  163, ["Twisting Nether"]      =  164, ["Forscherliga"]           =  516, 
           ["Argent Dawn"]          =  536, ["Kirin Tor"]           =  537, ["Earthen Ring"]         =  561, ["Die Silberne Hand"]      =  576, 
           ["Zirkel des Cenarius"]  =  592, ["Kult der Verdammten"] =  613, ["Das Syndikat"]         =  614, ["Der Rat von Dalaran"]    =  617, 
           ["Defias Brotherhood"]   =  635, ["The Venture Co"]      =  636, ["Conseil des Ombres"]   =  644, ["Les Sentinelles"]        =  647, 
           ["Kirin Tor"]            = 1071, ["Moonglade"]           = 1085, ["La Croisade écarlate"] = 1086, ["Scarshield Legion"]      = 1096, 
           ["Steamwheedle Cartel"]  = 1117, ["Die ewige Wacht"]     = 1118, ["Die Todeskrallen"]     = 1119, ["Die Arguswacht"]         = 1121, 
           ["Confrérie du Thorium"] = 1127, ["Lightninghoof"]       = 1130, ["Thorium Brotherhood"]  = 1154, ["Steamwheedle Cartel"]    = 1260, 
           ["The Venture Co"]       = 1289, ["Sentinels"]           = 1290, ["Ravenholdt"]           = 1308, ["Darkmoon Faire"]         = 1317, 
           ["Der Abyssische Rat"]   = 1326, ["Der Mithrilorden"]    = 1327, ["Die Nachtwache"]       = 1333, ["Culte de la Rive noire"] = 1337,
           ["Blackwater Raiders"]   = 1347, ["Ravenholdt"]          = 1352, ["Sisters of Elune"]     = 1356, ["Moon Guard"]             = 1365,
           ["Wyrmrest Accord"]      = 1369, ["Farstriders"]         = 1370, ["Todeswache"]           = 1405, ["The Scryers"]            = 1570,
           ["The Sha'tar"]          = 1595, ["Sporeggar"]           = 1606, ["Die Aldor"]            = 1618, ["Das Konsortium"]         = 1619,
           ["Les Clairvoyants"]     = 1626,
         }, -- ID
    TYPE = {
              [0] = "PVE",   [12] = "RP",   [75] = "RP",   [88] = "RP",  [100] = "RP",  [118] = "RP",  [125] = "RP",  [126] = "RP",  [162] = "RP",  [163] = "RP",
            [164] = "RP",   [516] = "RP",  [536] = "RP",  [537] = "RP",  [561] = "RP",  [576] = "RP",  [592] = "RP",  [613] = "RP",  [614] = "RP",  [617] = "RP",
            [635] = "RP",   [636] = "RP",  [644] = "RP",  [647] = "RP", [1071] = "RP", [1085] = "RP", [1086] = "RP", [1096] = "RP", [1117] = "RP", [1118] = "RP",
           [1119] = "RP",  [1121] = "RP", [1127] = "RP", [1130] = "RP", [1154] = "RP", [1260] = "RP", [1289] = "RP", [1290] = "RP", [1308] = "RP", [1317] = "RP",
           [1326] = "RP",  [1327] = "RP", [1333] = "RP", [1337] = "RP", [1347] = "RP", [1352] = "RP", [1356] = "RP", [1365] = "RP", [1369] = "RP", [1370] = "RP",
           [1405] = "RP",  [1570] = "RP", [1595] = "RP", [1606] = "RP", [1618] = "RP", [1619] = "RP", [1626] = "RP", }, -- TYPE
    --]]
    
    ABBR = { -- only enUS RP realms -- are these used?
             [0] =   "",   [12] =  "SH",   [75] =  "AD",  [88]  =  "CC",  [100] = "ER",  [118] =  "FM",  [125] = "ShC", [126]  = "ScC",
           [162] = "ED",  [163] =   "M",  [164] =  "TN",  [536] =  "AD",  [537] = "KT",  [561] =  "ER",  [635] =  "DB", [636]  =  "VC",
          [1071] = "KT", [1085] =  "MG", [1096] =  "SL", [1117] =  "SC", [1130] = "LH", [1154] =  "TB", [1260] = "StC", [1289] =  "VC",
          [1290] =  "S", [1308] =  "RH", [1317] = "DMF", [1347] =  "BR", [1352] = "RH", [1356] = "SoE", [1365] =  "MG", [1369] = "WRA",
          [1370] = "FS", [1570] = "Scr", [1595] = "Sha", [1606] = "Spo", }, -- ABBR
  }; -- server
  
  C.CLIENT  = 
  { LOOKUP  =  {
      ["Total RP 3"]     = "TRP",
      ["TotalRP3"]       = "TRP",
      ["MyRolePlay"]     = "MRP",
      ["XRP"]            = "XRP",
      ["xrp"]            = "XRP",
      ["TRP3: Extended"] = "TRPE",
    }, -- lookup
    --[[
      ICON = { TRP = "", MRP = "", XRP = "", TRPE = "", }, -- not enough of them have icons
    --]]
  }; -- client
  
  C.RACE_COUNT  = 36;
  C.RACE_OTHERS = { "Bear", "Horse", "Gnoll", }; 
  C.RACE = 
  { FALLBACK = {
      RACE_12 = 2, RACE_14 = 11, RACE_15 = 5,  RACE_16 = 1,  RACE_18 = 8, RACE_19 = 6, RACE_20 = 5,  RACE_21 = 8,
      RACE_22 = 1, RACE_23 = 1,  RACE_25 = 24, RACE_26 = 24, RACE_27 = 4, RACE_28 = 6, RACE_29 = 10, RACE_30 = 11,
      RACE_31 = 8, RACE_32 = 1,  RACE_33 = 1,  RACE_34 = 3,  RACE_36 = 2, RACE_37 = 7, 
      },
  };
    
  C.ALIGN = {
    CENTER      = { H = "CENTER", V = "MIDDLE", },
    LEFT        = { H = "LEFT",   V = "MIDDLE", },
    RIGHT       = { H = "RIGHT",  V = "MIDDLE", },
    TOP         = { H = "CENTER", V = "TOP",    },
    BOTTOM      = { H = "CENTER", V = "BOTTOM", },
    TOPLEFT     = { H = "LEFT",   V = "TOP",    },
    TOPRIGHT    = { H = "RIGHT",  V = "TOP",    },
    BOTTOMLEFT  = { H = "LEFT",   V = "BOTTOM", },
    BOTTOMRIGHT = { H = "RIGHT",  V = "BOTTOM", },
  }; 
  
  C.GENDER = 
  { MALE               = MALE,
    FEMALE             = FEMALE,
    NEUTER             = NEUTER,
    THEY               = THEY,
    UNKNOWN            = GENDER_UNKNOWN,
    DEFAULT            = GENDER_DEFAULT,

    LOOKUP =
    { [ MALE           ] = "MALE",
      [ FEMALE         ] = "FEMALE",
      [ NEUTER         ] = "NEUTER",
      [ THEY           ] = "THEY",
      [ GENDER_DEFAULT ] = "NEUTER",
      [ GENDER_UNKNOWN ] = "UNKNOWN",
    },

    CREATURE =          -- defaults assigned to creature types when unknown, instead of "it"
    { [ "Giant"        ] = THEY,
      [ "Humanoid"     ] = THEY,
    },

    FAMILY =            -- defaults assigned to creature types when unknown, instead of "it"
    { [ "Doomguard"    ] = MALE,
      [ "Felguard"     ] = MALE,
      [ "Imp"          ] = MALE,
      [ "Succubus"     ] = FEMALE,
    },

    -- TexturePath:size1:size2:xoffset:yoffset:dimx:dimy:coordx1:coordx2:coordy1:coordy2
    -- path       :0    :0    :0      :0      :64  :64  :0      :64     :0      :64     
    ICON = 
    { MALE    = "Glues\\CHARACTERCREATE\\UI-CharacterCreate-Gender:0:0:0:0:128:64:0:64:0:64",
      FEMALE  = "Glues\\CHARACTERCREATE\\UI-CharacterCreate-Gender:0:0:0:0:128:64:64:128:0:64",
      NEUTER  = "ICONS\\Achievement_GuildPerk_EverybodysFriend:0:0:0:0:64:64:0:64:0:64",
      UNKNOWN = "InventoryItems\\WoWUnknownItem01:0:0:0:0:64:64:0:64:0:64",
      THEY    = "ICONS\\Achievement_DoubleRainbow:0:0:0:0:64:64:0:64:0:64", 
    },
  }; -- GENDER
    
  C.ICONS = {
    T_          = "|TInterface\\",
    _t          = ":0|t",
    
    BATTLE_1  = "ICONS\\UI_RankedPvP_05_Small",
    BATTLE_2  = "ICONS\\INV_Misd_Dice_01",
    BATTLE_3  = "ICONS\\INV_Misc_Dice_02",
    BATTLE_4  = "ICONS\\Ability_Rogue_Disguise",
    DEATH_1   = "ICONS\\Spell_Shadow_RaiseDead",
    DEATH_2   = "ICONS\\INV_Elemental_Eternal_Life",
    DEATH_3   = "RAIDFRAME\\ReadyCheck-Waiting",
    GUILD_1   = "ICONS\\Achievement_Reputation_06",
    GUILD_2   = "ICONS\\INV_Mask_01",
    IC_1      = "ICONS\\Achievement_LegionPVP3Tier4",
    IC_2      = "ICONS\\Ability_Racial_TimeIsMoney",
    IC_3      = "ICONS\\artifactability_BalanceDruid_HalfMoon",
    IC_4      = "ICONS\\INV_Misc_Basket_01",
    IC_5      = "ICONS\\UI_Calendar_FreeTShirtDay",
    INJURY_1  = "ICONS\\Ability_Butcher_GushingWounds",
    INJURY_2  = "ICONS\\Ability_Priest_ReflectiveShield",
    INJURY_3  = "RAIDFRAME\\ReadyCheck-Waiting",
    ROMANCE_1 = "ICONS\\INV_ValentinesCandy",
    ROMANCE_2 = "ICONS\\Spell_BrokenHeart",
    ROMANCE_3 = "RAIDFRAME\\ReadyCheck-Waiting",
    XP_1      = "TARGETINGFRAME\\UI-TargetingFrame-Seal",
    XP_2      = "ICONS\\XP_ICON",
    XP_3      = "TARGETINGFRAME\\PortraitQuestBadge",

    -- |Tpath:height
    --   [:width
    --     [:offsetX:offsetY:
    --       [textureWidth:textureHeight:leftTexel:rightTexel:topTexel:bottomTexel
    --         [:rVertexColor:gVertexColor:bVertexColor]
    --       ] 
    --     ] 
    --   ]|t
    -- 
    -- 
    -- TexturePath:size1:size2:xoffset:yoffset:dimx:dimy:coordx1:coordx2:coordy1:coordy2
    --            :0    :     :0      :0      :128 :64  :64     :128    :0      :64",
    -- path       :0    :0    :0      :0      :64  :64  :0      :64     :0      :64     
    COLORWHEEL          = "|TInterface\\OptionsFrame\\ColorblindSettings:0::0:0:256:256:0:148:0:148|t",
    MORE                = "Calendar\\MoreArrow",
    AFK                 = "FriendsFrame\\StatusIcon-Away",
    DND                 = "FriendsFrame\\StatusIcon-DnD",
    OOC                 = "RAIDFRAME\\ReadyCheck-NotReady",
    IC                  = "RAIDFRAME\\ReadyCheck-Ready",
    STATUS              = "RAIDFRAME\\UI-RaidFrame-Threat",
    PVP_ALLIANCE        = "PvPRankBadges\\PvPRankAlliance",
    PVP_ALLIANCE_SQUARE = "ICONS\\PVPCurrency-Honor-Alliance",
    PVP_HORDE_SQUARE    = "ICONS\\PVPCurrency-Honor-Horde",
    PVP_HORDE           = "PvPRankBadges\\PvPRankHorde",
    UI_DOT_RED          = "COMMON\\Indicator-Red",
    UI_DOT_YELLOW       = "COMMON\\Indicator-Yellow",
    UI_DOT_GREEN        = "COMMON\\Indicator-Green",
    UI_DOT_GRAY         = "COMMON\\Indicator-Gray",

    HORDE     = "GROUPFRAME\\UI-Group-PVP-Horde",
    ALLIANCE  = "GROUPFRAME\\UI-Group-PVP-Alliance",
    PVP       = "GossipFrame\\BattleMasterGossipIcon",
    BEGINNER  = "TARGETINGFRAME\\UI-TargetingFrame-Seal",
    VOLUNTEER = "TARGETINGFRAME\\PortraitQuestBadge",
    BANNED    = "EncounterJournal\\UI-EJ-HeroicTextIcon",
    GLANCE    = "MINIMAP\\TRACKING\\None",
    NEW_ABOUT = "Buttons\\UI-GuildButton-PublicNote-Up",

    ["Dwarf"] = -- why do i have these?
    { FEMALE  = "CHARACTERFRAME\\TEMPORARYPORTRAIT-FEMALE-DWARF",
      MALE    = "CHARACTERFRAME\\TEMPORARYPORTRAIT-MALE-DWARF",
      OTHER   = "",
    },
    ["Troll"] =
    { FEMALE  = "CHARACTERFRAME\\TEMPORARYPORTRAIT-FEMALE-TROLL",
      MALE    = "CHARACTERFRAME\\TEMPORARYPORTRAIT-MALE-TROLL",
      OTHER   = "",
    },

    RACE          =
    { [ "BEAR"  ] =
        { OTHER   = "CHARACTERFRAME\\TEMPORARYPORTRAIT-PET",
        },
      [ "GNOLL" ] =
        { OTHER   = "TemporaryPortrait-Monster",
        },
      [ "HORSE" ] =
        { OTHER   = "CHARACTERFRAME\\TemporaryPortrait-Vehicle-Organic",
        },
      [ 0       ] =
        { OTHER   = "CHARACTERFRAME\\TempPortrait", -- question mark
        },
      [ 1       ] =
         { FEMALE = "CHARACTERFRAME\\TEMPORARYPORTRAIT-FEMALE-HUMAN",
           MALE   = "CHARACTERFRAME\\TEMPORARYPORTRAIT-MALE-HUMAN",
        },
      [ 2       ] =
         { FEMALE = "CHARACTERFRAME\\TEMPORARYPORTRAIT-FEMALE-ORC",
           MALE   = "CHARACTERFRAME\\TEMPORARYPORTRAIT-MALE-ORC",
        },
      [ 3       ] =
         { FEMALE = "CHARACTERFRAME\\TEMPORARYPORTRAIT-FEMALE-DWARF",
           MALE   = "CHARACTERFRAME\\TEMPORARYPORTRAIT-MALE-DWARF",
        },
      [ 4       ] =
         { FEMALE = "CHARACTERFRAME\\TEMPORARYPORTRAIT-FEMALE-NIGHTELF",
           MALE   = "CHARACTERFRAME\\TEMPORARYPORTRAIT-MALE-NIGHTELF",
        },
      [ 5       ] =
         { FEMALE = "CHARACTERFRAME\\TEMPORARYPORTRAIT-FEMALE-SCOURGE",
           MALE   = "CHARACTERFRAME\\TEMPORARYPORTRAIT-MALE-SCOURGE",
        },
      [ 6       ] =
         { FEMALE = "CHARACTERFRAME\\TEMPORARYPORTRAIT-FEMALE-TAUREN",
           MALE   = "CHARACTERFRAME\\TEMPORARYPORTRAIT-MALE-TAUREN",
        },
      [ 7       ] =
         { FEMALE = "CHARACTERFRAME\\TEMPORARYPORTRAIT-FEMALE-GNOME",
           MALE   = "CHARACTERFRAME\\TEMPORARYPORTRAIT-MALE-GNOME",
        },
      [ 8       ] =
         { FEMALE = "CHARACTERFRAME\\TEMPORARYPORTRAIT-FEMALE-TROLL",
           MALE   = "CHARACTERFRAME\\TEMPORARYPORTRAIT-MALE-TROLL",
        },
      [ 9       ] =
         { FEMALE = "CHARACTERFRAME\\TEMPORARYPORTRAIT-FEMALE-GOBLIN",
           MALE   = "CHARACTERFRAME\\TemporaryPortrait-Male-Goblin",
        },
      [ 10      ] =
        { FEMALE  = "CHARACTERFRAME\\TEMPORARYPORTRAIT-FEMALE-BLOODELF",
           MALE   = "CHARACTERFRAME\\TEMPORARYPORTRAIT-MALE-BLOODELF",
        },
      [ 11      ] =
        { FEMALE  = "CHARACTERFRAME\\TEMPORARYPORTRAIT-FEMALE-DRAENEI",
           MALE   = "CHARACTERFRAME\\TEMPORARYPORTRAIT-MALE-DRAENEI",
        },
      [ 22      ] =
        { FEMALE  = "CHARACTERFRAME\\TEMPORARYPORTRAIT-FEMALE-WORGEN",
           MALE   = "CHARACTERFRAME\\TEMPORARYPORTRAIT-MALE-WORGEN",
        },
      [ 23      ] =
        { FEMALE  = "CHARACTERFRAME\\TEMPORARYPORTRAIT-FEMALE-GILNEAN",
           MALE   = "CHARACTERFRAME\\TEMPORARYPORTRAIT-MALE-GILNEAN",
        },
      [ 24      ] =
        { FEMALE  = "CHARACTERFRAME\\TEMPORARYPORTRAIT-FEMALE-PANDAREN",
           MALE   = "CHARACTERFRAME\\TEMPORARYPORTRAIT-MALE-PANDAREN",
        },
      [ 27      ] =
        { FEMALE  = "CHARACTERFRAME\\TemporaryPortrait-Female-Nightborne",
           MALE   = "CHARACTERFRAME\\TemporaryPortrait-Male-Nightborne",
        },
      [ 28      ] =
        { FEMALE  = "CHARACTERFRAME\\TemporaryPortrait-Female-HighmountainTauren",
           MALE   = "CHARACTERFRAME\\TemporaryPortrait-Male-HighmountainTauren",
        },
      [ 29      ] =
        { FEMALE  = "CHARACTERFRAME\\TemporaryPortrait-Female-VoidElf",
           MALE   = "CHARACTERFRAME\\TemporaryPortrait-Male-VoidElf",
        },
      [ 30      ] =
        { FEMALE  = "CHARACTERFRAME\\TemporaryPortrait-Female-LightforgedDraenei",
           MALE   = "CHARACTERFRAME\\TemporaryPortrait-Male-LightforgedDraenei",
        },
      [ 31      ] =
        { FEMALE  = "CHARACTERFRAME\\TemporaryPortrait-Female-ZandalariTroll",
           MALE   = "CHARACTERFRAME\\TemporaryPortrait-Male-ZandalariTroll",
        },
      [ 32      ] =
        { FEMALE  = "CHARACTERFRAME\\TemporaryPortrait-Female-KulTiran",
           MALE   = "CHARACTERFRAME\\TemporaryPortrait-Male-KulTiran",
        },
      [ 34      ] =
        { FEMALE  = "CHARACTERFRAME\\TemporaryPortrait-Female-DarkIronDwarf",
           MALE   = "CHARACTERFRAME\\TemporaryPortrait-Male-DarkIronDwarf",
        },
      [ 36      ] =
        { FEMALE  = "CHARACTERFRAME\\TemporaryPortrait-Female-MagharOrc",
           MALE   = "CHARACTERFRAME\\TemporaryPortrait-Male-MagharOrc",
        },
      }, -- add mechagnome

    GENDER    =  -- is this redundant with GENDER.ICONS?
    { NEUTER  = "ICONS\\Achievement_GuildPerk_EverybodysFriend",
      UNKNOWN = "InventoryItems\\WoWUnknownItem01",
      THEY    = "ICONS\\Achievement_DoubleRainbow",
      MALE    = "Glues\\CHARACTERCREATE\\UI-CharacterCreate-Gender",
      FEMALE  = "Glues\\CHARACTERCREATE\\UI-CharacterCreate-Gender",
    },
    PARAMS    = 
    { DEFAULT = "0::0:0:64:64:0:64:0:64",
      MALE    = "0::0:0:128:64:0:64:0:64",
      FEMALE  = "0::0:0:128:64:64:128:0:64",
    },
  }; -- icons
    
  C.FONT = { FIXED = "SourceCodePro (Regular)", }; -- is this even used?
  
  C.NBSP = "|TInterface\\Store\\ServicesAtlas:0::0:0:1024:1024:1023:1024:1023:1024|t";
  
  C.URLS = -- url database
  { discord        = { url = "URL_DISCORD",        name = "URL_DISCORD_TT",        },
    download       = { url = "URL_DOWNLOAD_CURSE", name = "URL_DOWNLOAD_CURSE_TT", },
    download_tukui = { url = "URL_DOWNLOAD_TUKUI", name = "URL_DOWNLOAD_TUKUI_TT", },
    elvui          = { url = "URL_ELVUI",          name = "URL_ELVUI_TT",          },
    mrp            = { url = "URL_MRP",            name = "URL_MRP_TT",            },
    trp3           = { url = "URL_TRP3",           name = "URL_TRP3_TT",           },
    twitter        = { url = "URL_TWITTER",        name = "URL_TWITTER_TT",        },
    xrp            = { url = "URL_XRP",            name = "URL_XRP_TT",            },
    rpfonts        = { url = "URL_RPFONTS",        name = "URL_RPFONTS_TT",        },
  };
  C.UNSUP = {};
  
  C.CONFIG =  -- this used to be CONFIG.DEFAULTS but that seems unnecessary
  { ADULT_GENDERS     = false,
    COLOR_EQUALISH    = C.COLOR.LIGHT_GREY,
    COLOR_FEMALE      = C.COLOR.PINK,
    COLOR_GREATERTHAN = C.COLOR.LIGHT_BLUE,
    COLOR_HILITE_1    = C.COLOR.CYAN,
    COLOR_HILITE_2    = C.COLOR.YELLOW,
    COLOR_HILITE_3    = C.COLOR.ORANGE,
    COLOR_IC          = C.COLOR.GREEN,
    COLOR_LESSTHAN    = C.COLOR.YELLOW,
    COLOR_MALE        = C.COLOR.LIGHT_BLUE,
    COLOR_ME          = C.COLOR.VIOLET,
    COLOR_NEUTER      = C.COLOR.LIGHT_GREY,
    COLOR_NPC         = C.COLOR.YELLOW,
    COLOR_OOC         = C.COLOR.RED,
    COLOR_THEY        = C.COLOR.YELLOW,
    COLOR_UNKNOWN     = C.COLOR.LIGHT_GREY,
    EXTEND_GENDER     = false,
    FORMATTING_TAGS   = true,
    GLANCE_COLON      = ": ",
    GLANCE_DELIM      = "\n",
    LINEBREAKS        = false,
    LOGIN_MESSAGE     = true,
    ME                = UnitName('player'),
    NOTE_1_ICON       = "INV_Misc_ScrollUnrolled03.PNG",
    NOTE_1_STRING     = "Warning:",
    NOTE_2_ICON       = "INV_Misc_ScrollUnrolled03d.PNG",
    NOTE_2_STRING     = "Reminder:",
    NOTE_3_ICON       = "INV_Misc_ScrollUnrolled02c.PNG",
    NOTE_3_STRING     = "Alt of",
    PARSE_AGE         = true,
    PARSE_GENDER      = true,
    PARSE_HW          = true,
    PROFILESIZE_FMT   = "WRD_PAR_NUM",
    REAL_ELLIPSES     = true,
    SIZEBUFF_FMT      = "PCT_BRC",
    UNITS_HEIGHT      = "CM_FT_IN",
    UNITS_WEIGHT      = "KG_LB",
    UNSUP_TAG         = "??",
    TAG_SIZE_XS       = 5,
    TAG_SIZE_S        = 10,
    TAG_SIZE_M        = 15,
    TAG_SIZE_L        = 20,
    TAG_SIZE_XL       = 50,
    NOTIFY_METHOD     = "chat",
    SETTINGS_CHANGE   = false,
  } -- config
  
  C.UIPANELS =  -- for the link handler
  { options           = "opt://general",
    parse             = "opt://general/parse",
    notes             = "opt://general/notes",
    formats           = "opt://general/formats",
    sizes             = "opt://general/sizes",
    keybind           = "opt://general/keybind",
  
    colors            = "opt://colors",
    colors_status     = "opt://colors/status",
    colors_gender     = "opt://colors/gender",
    colors_comparison = "opt://colors/comparison",
    colors_hilite     = "opt://colors/hilite",
    colors_default    = "opt://colors/default",
  
    help              = "opt://help/intro",
    tags              = "opt://help/tags",
    recipes           = "opt://help/recipes",
    tagmods           = "opt://help/tagModifiers",
  
    about             = "opt://about",
    changes           = "opt://about/changes",
    credits           = "opt://about/credits",
    version           = "opt://about/version",
    debug             = "opt://about/debut",
  
    open              = true,
    commands          = true,
  };
  
  C.CURSOR = -- for mouseouver
  { http   = "Interface\\CURSOR\\ArgusTeleporter.PNG",
    https  = "Interface\\CURSOR\\BastionTeleporter.PNG",
    mailto = "Interface\\CURSOR\\Mail.PNG",
    opt    = "Interface\\CURSOR\\QuestRepeatable.PNG",
  };
  
end);
