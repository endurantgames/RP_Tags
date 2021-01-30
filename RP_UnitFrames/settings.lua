local RPTAGS = RPTAGS;

RPTAGS.queue:WaitUntil("LOAD_SETTINGS",
function(self, event, ...)

  RPTAGS.CONST                   = RPTAGS.CONST or {};
  RPTAGS.CONST.CONFIG          = RPTAGS.CONST.SETTINGS or {};
  RPTAGS.CONST.CONFIG.DEFAULTS = RPTAGS.CONST.SETTINGS.DEFAULTS or {};

  local Defaults                 = RPTAGS.CONST.SETTINGS.DEFAULTS;

  local BLACK                    = "000000";
  local WHITE                    = "ffffff";
  local YELLOW                   = "ffff66";

  -- disable
  Defaults.DISABLE_RPUF          = false;
  Defaults.DISABLE_BLIZZARD      = false;
  Defaults.RPUF_WITH_ELVUI       = true;

  -- reset
  Defaults.RESET_FRAMES          = true;
  Defaults.RESET_TAGS            = true;
  Defaults.LOCK_FRAMES           = false;

  -- hiding
  Defaults.RPUF_HIDE_COMBAT      = true;
  Defaults.RPUF_HIDE_VEHICLE     = true;
  Defaults.RPUF_HIDE_PETBATTLE   = true;
  Defaults.RPUF_HIDE_PARTY       = false;
  Defaults.RPUF_HIDE_DEAD        = false;
  Defaults.RPUF_HIDE_RAID        = true;

  -- appearance
  Defaults.COLOR_RPUF            = BLACK;
  Defaults.COLOR_RPUF_TEXT       = WHITE;
  Defaults.COLOR_RPUF_TOOLTIP    = YELLOW;
  Defaults.RPUFALPHA             = 65;
  Defaults.RPUF_BACKDROP         = "BLIZZTOOLTIP";
  Defaults.STATUS_ALIGN          = "CENTER";
  Defaults.STATUS_TEXTURE        = "SHADED";
  Defaults.PORTRAIT_STYLE        = "LAYOUT";

  -- scale
  Defaults.PLAYERFRAME_SCALE     = 0.9;
  Defaults.TARGETFRAME_SCALE     = 0.9;
  Defaults.FOCUSFRAME_SCALE      = 0.75;

  -- layouts
  Defaults.FOCUSLAYOUT           = "COMPACT";
  Defaults.PLAYERLAYOUT          = "ABRIDGED";
  Defaults.TARGETLAYOUT          = "FULL";
  Defaults.PARTYLAYOUT           = "ABRIDGED";    -- not implemented yet
  Defaults.RAIDLAYOUT            = "COMPACT";     -- not implemented yet
  Defaults.PARTY_ORIENTATION     = "VERTICAL";
  Defaults.RAID_GRID             = "5X8";

  -- dimensions
  Defaults.DETAILHEIGHT          = 100;
  Defaults.GAPSIZE               = 6;
  Defaults.ICONWIDTH             = 25;
  Defaults.INFOWIDTH             = 200;
  Defaults.PORTRAIT_TYPE         = "FACE";
  Defaults.PORTWIDTH             = 100;
  Defaults.STATUSHEIGHT          = 35;

  -- panels
  Defaults.DETAILPANEL           = "[rp:oocinfo]";
  Defaults.ICON_1                = "[rp:icon]";
  Defaults.ICON_2                = "[rp:glance-1-icon]";
  Defaults.ICON_3                = "[rp:glance-2-icon]";
  Defaults.ICON_4                = "[rp:glance-3-icon]";
  Defaults.ICON_5                = "[rp:glance-4-icon]";
  Defaults.ICON_6                = "[rp:glance-5-icon]";
  Defaults.INFOPANEL             = "[rp:race] [rp:class]";
  Defaults.NAMEPANEL             = "[rp:color][rp:name]";
  Defaults.STATUSPANEL           = "[rp:statuscolor][rp:ic][rp:ooc] [nocolor][rp:currently]";

  -- tooltips
  Defaults.DETAIL_TOOLTIP        = "[rp:statuscolor][rp:ic][rp:ooc][nocolor] [rp:oocinfo-label]";
  Defaults.ICON_1_TOOLTIP        = "[rp:style-yes-label][br][rp:style-ask-label][br][rp:style-no-label]";
  Defaults.ICON_2_TOOLTIP        = "[rp:glance-1-full]";
  Defaults.ICON_3_TOOLTIP        = "[rp:glance-2-full]";
  Defaults.ICON_4_TOOLTIP        = "[rp:glance-3-full]";
  Defaults.ICON_5_TOOLTIP        = "[rp:glance-4-full]";
  Defaults.ICON_6_TOOLTIP        = "[rp:glance-5-full]";
  Defaults.INFO_TOOLTIP          = "[rp:gendercolor][rp:gender][nocolor] [rp:guildcolor][race] [rp:friendcolor][class] [level]";
  Defaults.NAME_TOOLTIP          = "[rp:namecolor][rp:friendcolor][rp:firstname] [rp:nick-quoted] [rp:lastname][nocolor][br][rp:title-long][p][rp:guildcolor][rp:guild-label][nocolor] [rp:guildstatuscolor][rp:guild-status][nocolor][br][rp:guild-rank-label]";
  Defaults.PORTRAIT_TOOLTIP      = "[rp:eyecolor][rp:eyes-label][nocolor][br][rp:hair-label][br][rp:actor-label]";
  Defaults.STATUS_TOOLTIP        = "[rp:statuscolor][rp:ic][rp:ooc] [nocolor][rp:currently-label]";

end
);
