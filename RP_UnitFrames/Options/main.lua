local addOnName, ns = ...;
local RPTAGS        = RPTAGS;
local Module        = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("before MODULE_G",
function(self, event, ...)

  local Utils           = RPTAGS.utils;
  local Config          = Utils.config;
  local Locale          = Utils.locale;
  local loc             = Locale.loc;
  local Get             = Config.get;
  local Set             = Config.set;
  local source_order    = Utils.options.source_order;
  local Spacer          = Utils.options.spacer;
  local linkHandler     = Utils.links.handler;
  local addOptions      = Utils.modules.addOptions;
  local addOptionsPanel = Utils.modules.addOptionsPanel;
  local LibSharedMedia  = LibStub("LibSharedMedia-3.0");
  local scaleFrame      = Utils.frames.scale;
  local scaleAllFrames  = Utils.frames.scaleAll;
  local Refresh         = Utils.frames.RPUF_Refresh;
  local RPUF_Disable    = Utils.frames.RPUF_Disable;

  local popup1 = "RP_UNITFRAMES_CONFIRM_RELOAD_UI";
  local popup2 = "RP_UNITFRAMES_CONFIRM_RELOAD_UI_ENABLE";

  local menu     =
  { align        =
    { LEFT       = loc("LEFT"                            ),
      CENTER     = loc("CENTER"                          ),
      RIGHT      = loc("RIGHT"                           ), },
    small        =
    { COMPACT    = loc("RPUF_COMPACT"                    ),
      ABRIDGED   = loc("RPUF_ABRIDGED"                   ),
      THUMBNAIL  = loc("RPUF_THUMBNAIL"                  ), },
    large        =
    { COMPACT    = loc("RPUF_COMPACT"                    ),
      ABRIDGED   = loc("RPUF_ABRIDGED"                   ),
      THUMBNAIL  = loc("RPUF_THUMBNAIL"                  ),
      PAPERDOLL  = loc("RPUF_PAPERDOLL"                  ),
      FULL       = loc("RPUF_FULL"                       ), },
    fontSize     =
    { extrasmall = loc("SIZE_EXTRA_SMALL"                ),
      small      = loc("SIZE_SMALL"                      ),
      medium     = loc("SIZE_MEDIUM"                     ),
      large      = loc("SIZE_LARGE"                      ),
      extralarge = loc("SIZE_EXTRA_LARGE"                ), },
  };

  local frameList =    -- uppercase name, isSmallFrame
  { { "PLAYER",        false },
    { "TARGET",        false },
    { "FOCUS",         true  },
    { "TARGETTARGET",  true  }, 
  };

  -- specialized loc()
  local function cloc(s) return loc( "CONFIG_" .. ( s or "" )          ) end;
  local function tloc(s) return loc( "CONFIG_" .. ( s or "" ) .. "_TT" ) end;
  local function oloc(s) return loc( "OPT_"    .. ( s or "" )          ) end;
  local function iloc(s) return loc( "OPT_"    .. ( s or "" ) .. "_I"  ) end;
  local function ploc(s) return loc( "PANEL_"  .. ( s or "" )          ) end;

  -- constructor functions            [---------------------------------------------]
  local function get(setting)  return function()            return Get(setting)  end; end; -- builds a Getter function

local function set(setting)    return function(info, value) Set(setting, value); end; end; -- builds a Setter function

  local mainGroup             =
  { name                      = loc("RPUF_NAME"),
    order                     = source_order(),
    type                      = "group",
    args                      = {},
  };

  mainGroup.args.instruct    =
  { type                      = "description",
    dialogControl             = "LMD30_Description",
    name                      = loc("PANEL_RPUF_MAIN"),
    order                     = source_order(),
  };

  mainGroup.args.disableUF   =
  { type                      = "toggle",
    order                     = source_order(),
    name                      = loc("CONFIG_DISABLE_RPUF"),
    desc                      = loc("CONFIG_DISABLE_RPUF_TT"),
    get                       = get("DISABLE_RPUF"),
    set                       = 
      function(info, value) 
        if Get("DISABLE_BLIZZARD") and value == true
        then StaticPopup_Show(popup2)
        else Set("DISABLE_RPUF", value); 
             Refresh("all", "hiding"); 
        end;
      end,
    width                     = 1.5,
  };

  mainGroup.args.disableBliz =
  { type                      = "toggle",
    order                     = source_order(),
    name                      = cloc("DISABLE_BLIZZARD"),
    desc                      = tloc("DISABLE_BLIZZARD"),
    get                       = get("DISABLE_BLIZZARD"),
    set                       = function(info, value) StaticPopup_Show(popup1); end,
    disabled                  = get("DISABLE_RPUF"),
    width                     = 1.5,
  };

  addOptionsPanel("RPUF_Main", mainGroup);

  StaticPopupDialogs[popup1] = {
    showAlert      = 1,
    text           = loc("RELOAD_UI_WARNING"),
    button1        = loc("RELOAD_UI_WARNING_YES"),
    button2        = loc("RELOAD_UI_WARNING_NO"),
    exclusive      = true,
    OnAccept       = function() Config.set("DISABLE_BLIZZARD", not(Config.get("DISABLE_BLIZZARD"))); ReloadUI() end,
    timeout        = 60,
    whileDead      = true,
    hideOnEscape   = true,
    hideOnCancel   = true,
    preferredIndex = 3,
  };

  StaticPopupDialogs[popup2] = {
    showAlert      = 1,
    text           = loc("RELOAD_UI_WARNING_RPUF"),
    button1        = loc("RELOAD_UI_WARNING_YES"),
    button2        = loc("RELOAD_UI_WARNING_NO"),
    exclusive      = true,
    OnAccept       = function() Config.set("DISABLE_BLIZZARD", false); Config.set("DISABLE_RPUF", true); ReloadUI() end,
    timeout        = 60,
    whileDead      = true,
    hideOnEscape   = true,
    hideOnCancel   = true,
    preferredIndex = 3,
  };

end);
