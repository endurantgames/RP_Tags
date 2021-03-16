local addOnName, ns = ...;
local RPTAGS        = RPTAGS;
local Module        = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("MODULE_G",
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
    fontSizeOrder = { "extrasmall", "small", "medium", "large", "extralarge" },
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

  local function build_frame_group(frameName, small)
    local str, ul_str, frame, shared;

    if frameName then str = frameName:upper(); ul_str = "_" .. str; frame  = true;
                 else str = "";                ul_str = "";         shared = true; end

    -- work out these before hand -- they're the config keys
    local f           =
    { alpha           = "RPUFALPHA"           .. ul_str,
      background      = "RPUF_BACKDROP"       .. ul_str,
      border          = "RPUF_BORDER"         .. ul_str,
      borderWidth     = "RPUF_BORDER_WIDTH"   .. ul_str,
      borderInsets    = "RPUF_BORDER_INSETS"  .. ul_str,
      detailHeight    = "DETAILHEIGHT"        .. ul_str,
      detailFont      = "DETAILPANEL_FONTNAME" .. ul_str,
      detailFontSize  = "DETAILPANEL_FONTSIZE" .. ul_str,
      fontName        = "FONTNAME"            .. ul_str,
      fontSize        = "FONTSIZE"            .. ul_str,
      gapSize         = "GAPSIZE"             .. ul_str,
      hideCombat      = "RPUF_HIDE_COMBAT"    .. ul_str,
      hideDead        = "RPUF_HIDE_DEAD"      .. ul_str,
      hideParty       = "RPUF_HIDE_PARTY"     .. ul_str,
      hidePetBattle   = "RPUF_HIDE_PETBATTLE" .. ul_str,
      hideRaid        = "RPUF_HIDE_RAID"      .. ul_str,
      hideVehicle     = "RPUF_HIDE_VEHICLE"   .. ul_str,
      iconWidth       = "ICONWIDTH"           .. ul_str,
      infoWidth       = "INFOWIDTH"           .. ul_str,
      infoFont        = "INFOPANEL_FONTNAME"  .. ul_str,
      infoFontSize    = "INFOPANEL_FONTSIZE"  .. ul_str,
      layout          = str                   .. "LAYOUT",
      link            = "LINK_FRAME"          .. ul_str,
      lockFrame       = "LOCK_FRAME"          .. ul_str,
      nameFont        = "NAMEPANEL_FONTNAME"  .. ul_str,
      nameFontSize    = "NAMEPANEL_FONTSIZE"  .. ul_str,
      mouseoverCursor = "MOUSEOVER_CURSOR"    .. ul_str,
      portWidth       = "PORTWIDTH"           .. ul_str,
      statusAlign     = "STATUS_ALIGN"        .. ul_str,
      statusFont      = "STATUSPANEL_FONTNAME"  .. ul_str,
      statusFontSize  = "STATUSPANEL_FONTSIZE"  .. ul_str,
      statusHeight    = "STATUSHEIGHT"        .. ul_str,
      statusAlpha     = "STATUS_ALPHA"        .. ul_str,
      statusTexture   = "STATUS_TEXTURE"      .. ul_str,
      scale           = str                   .. "FRAME_SCALE",
      show            = "SHOW_FRAME"          .. ul_str,
      name            = str                   .. "FRAME",
    };

    -- hider constructors                     [---------------------- constructed hider --------------------------------]
    function not_show()                return function() return f.show and not Get(f.show)                           end;  end;
    function disableRpuf()             return function() return Get("DISABLE_RPUF")                                  end;  end;
    function not_show_or_disableRpuf() return function() return f.show and not Get(f.show) or Get("DISABLE_RPUF")    end;  end;
    function linked()                  return function() return f.link and Get(f.link)                               end;  end;
    function linked_or_not_show()      return function() return f.link and f.show and Get(f.link) or not Get(f.show) end;  end;

    local frameGroup            =
    { name                      = frame and loc(str .. "FRAME") or oloc("SHARED_SETTINGS"),
      order                     = source_order(),
      type                      = "group",
      hidden                    = function() return Get("DISABLE_RPUF") end,
      args                      = {},
    };

    frameGroup.args.show        = frame and
    { type                      = "toggle",
      name                      = cloc(f.show),
      desc                      = tloc(f.show),
      get                       = get(f.show),
      set                       = function(info, value) Set(f.show, value); Refresh(frameName, "hiding"); end,
      width = 0.75,
      hidden                    = disableRpuf(),
      order                     = source_order(),
    } or nil;

    frameGroup.args.spa         = frame and Spacer() or nil;

    frameGroup.args.link        = frame and 
    { type                      = "toggle",
      name                      = cloc(f.link),
      width = 1.25,
      desc                      = tloc(f.link),
      get                       = get(f.link),
      hidden                    = not_show(),
      set                       = function(info, value) Set(f.link, value); Refresh(frameName, "all"); end,
      order                     = source_order(),
    } or nil;

    frameGroup.args.layout      = frame and
    { type                      = "select",
      name                      = cloc(f.layout),
      desc                      = tloc(f.layout),
      width = 0.75,
      get                       = get(f.layout),
      set                       = function(info, value) Set(f.layout, value); Refresh(frameName, "layout", "framesize", "sizes", "vis"); end,
      values                    = small and menu.small or menu.large,
      order                     = source_order(),
      hidden                    = not_show(),
    } or nil;

    frameGroup.args.spc         = frame and Spacer() or nil;

    frameGroup.args.scale       = frame and
    { type                      = "range",
      min                       = 0.25,
      max                       = 3.00,
      isPercent                 = true,
      width = 1.25,
      step                      = 0.05,
      get                       = get(f.scale),
      set                       = function(info, value) Set(f.scale, value); 
                                    if   frameName 
                                    then scaleFrame(frameName)
                                    else scaleAllFrames() 
                                    end
                                  end,
      order                     = source_order(),
      hidden                    = not_show(),
      name                      = cloc(f.scale),
      desc                      = tloc(f.scale),
    } or nil;

    local visiSubGroup                =
    { type                      = "group",
      name                      = "Visibility",
      order                     = source_order(),
      hidden                    = frame and linked_or_not_show(),
      disabled                  = disabled,
      args                      = {},
    };

    visiSubGroup.args.hideCombat      =
    { type                      = "toggle",
      name                      = cloc(f.hideCombat),
      desc                      = tloc(f.hideCombat),
      set                       = function(info, value) Set(f.hideCombat, value); Refresh(frameName, "hiding"); end,
      get                       = get(f.hideCombat),
      order                     = source_order(),
    };

    visiSubGroup.args.hidePetBattle   =
    { type                      = "toggle",
      name                      = cloc(f.hidePetBattle),
      desc                      = tloc(f.hidePetBattle),
      set                       = function(info, value) Set(f.hidePetBattle, value); Refresh(frameName, "hiding"); end,
      get                       = get(f.hidePetBattle),
      order                     = source_order(),
    };

    visiSubGroup.args.hideVehicle     =
    { type                      = "toggle",
      name                      = cloc(f.hideVehicle),
      desc                      = tloc(f.hideVehicle),
      set                       = set(f.hideVehicle, "hiding"),
      set                       = function(info, value) Set(f.hideVehicle, value); Refresh(frameName, "hiding"); end,
      get                       = get(f.hideVehicle),
      order                     = source_order(),
    };

    visiSubGroup.args.hideParty       =
    { type                      = "toggle",
      name                      = cloc(f.hideParty),
      desc                      = tloc(f.hideParty),
      set                       = function(info, value) Set(f.hideParty, value); Refresh(frameName, "hiding"); end,
      get                       = get(f.hideParty),
      order                     = source_order(),
    };

    visiSubGroup.args.hideRaid        =
    { type                      = "toggle",
      name                      = cloc(f.hideRaid),
      desc                      = tloc(f.hideRaid),
      set                       = function(info, value) Set(f.hideRaid, value); Refresh(frameName, "hiding"); end,
      get                       = get(f.hideRaid),
      order                     = source_order(),
    };

    visiSubGroup.args.hideDead        =
    { type                      = "toggle",
      name                      = cloc(f.hideDead),
      desc                      = tloc(f.hideDead),
      set                       = function(info, value) Set(f.hideDead, value); Refresh(frameName, "hiding"); end,
      get                       = get(f.hideDead),
      order                     = source_order(),
    };

    visiSubGroup.args.mouseoverCursor =
    { type                      = "toggle",
      name                      = cloc(f.mouseoverCursor),
      desc                      = tloc(f.mouseoverCursor),
      set                       = function(info, value) Set(f.mouseoverCursor, value); end,
      get                       = get(f.mouseoverCursor),
      order                     = source_order(),
    };

    frameGroup.args.visiSubGroup      = visiSubGroup;

    local posiSubGroup          =
    { type                      = "group",
      name                      = "Positioning",
      order                     = source_order(),
      inline                    = true,
      args                      = {},
    };

    posiSubGroup.args.lockFrames      = frame and
    { type                      = "toggle",
      name                      = cloc(f.lockFrame),
      desc                      = tloc(f.lockFrame),
      width                     = 1,
      get                       = get(f.lockFrame),
      set                       = function(info, value) 
                                    Set(f.lockFrame, value); 
                                    Refresh(frameName, "lock");
                                  end,
      order                     = source_order(),
    } or nil;

    posiSubGroup.args.lockFrames = not frame and
    { type = "execute",
      name = cloc("LOCK_FRAMES"),
      desc = tloc("LOCK_FRAMES"),
      width = 1,
      order = source_order(),
      func = function() for frameName, frame in pairs(RPTAGS.cache.UnitFrames)
                        do  Set("LOCK_FRAME_" .. frame.unit:upper(), true)
                        end;
                        Refresh("all", "lock")
              end,
      disabled = function() for frameName, frame in pairs(RPTAGS.cache.UnitFrames)
                            do  if not Get("LOCK_FRAME_" .. frame.unit:upper())
                                then return false;
                                end;
                            end;
                            return true
                end,
    } or nil;

    posiSubGroup.args.unlockFrames = not frame and
    { type = "execute",
      name = cloc("UNLOCK_FRAMES"),
      desc = tloc("UNLOCK_FRAMES"),
      width = 1,
      order = source_order(),
      func = function() for frameName, frame in pairs(RPTAGS.cache.UnitFrames)
                        do  Set("LOCK_FRAME_" .. frame.unit:upper(), false)
                        end;
                        Refresh("all", "lock")
              end,
      disabled = function() for frameName, frame in pairs(RPTAGS.cache.UnitFrames)
                            do  if Get("LOCK_FRAME_" .. frame.unit:upper())
                                then return false;
                                end;
                            end;
                            return true
                end,
    } or nil;

    posiSubGroup.args.resetFrames     =
    { type                      = "execute",
      name                      = cloc("RESET_FRAME_LOCATION" .. (frame and "" or "S")),
      desc                      = tloc("RESET_FRAME_LOCATION" .. (frame and "" or "S")),
      func                      = function() Refresh(frameName, "location") end,
      width                     = 1,
      order                     = source_order(),
    };

    frameGroup.args.posiSubGroup      = posiSubGroup;

    local lookSubGroup                =
    { type                      = "group",
      name                      = "Frame Appearance",
      order                     = source_order(),
      hidden                    = frame and linked_or_not_show(),
      args                      = {}
    };

    lookSubGroup.args.background      =
    { type                      = "select",
      dialogControl             = "LSM30_Background",
      values                    = function() return LibSharedMedia:HashTable("background") end,
      width                     = 1.5,
      get                       = get(f.background),
      set                       = function(info, value) Set(f.background, value); Refresh(frameName, "style"); end,
      name                      = cloc(f.background),
      desc                      = tloc(f.background),
      order                     = source_order(),
    };

    lookSubGroup.args.spbg = Spacer(); 

    lookSubGroup.args.borderInsets = 
        { type                      = "range",
          width                     = 0.75,
          get                       = get(f.borderInsets),
          set                       = function(info, value) Set(f.borderInsets, value); Refresh(frameName, "style", "statusbar"); end,
          name                      = cloc(f.borderInsets),
          desc                      = tloc(f.borderInsets),
          order                     = source_order(),
          min                       = 1,
          max                       = 32,
          step                      = 1
        };

    lookSubGroup.args.border =
        { type                      = "select",
          dialogControl             = "LSM30_Background",
          values                    = function() return LibSharedMedia:HashTable("border") end,
          width                     = 1.5,
          get                       = get(f.border),
          set                       = function(info, value) Set(f.border, value); Refresh(frameName, "style"); end,
          name                      = cloc(f.border),
          desc                      = tloc(f.border),
          order                     = source_order(),
        };

    lookSubGroup.args.spb             = Spacer();

    lookSubGroup.args.borderWidth =
        { type                      = "range",
          width                     = 0.75,
          get                       = get(f.borderWidth),
          set                       = function(info, value) Set(f.borderWidth, value); Refresh(frameName, "style", "statusbar"); end,
          name                      = cloc(f.borderWidth),
          desc                      = tloc(f.borderWidth),
          order                     = source_order(),
          min                       = 1,
          max                       = 32,
          step                      = 1
        };


    lookSubGroup.args.alpha           =
    { type                      = "range",
      name                      = cloc(f.alpha),
      desc                      = tloc(f.alpha),
      get                       = get(f.alpha),
      set                       = function(info, value) Set(f.alpha, value); Refresh(frameName, "style", "statusbar" ); end,
      min                       = 0,
      max                       = 1,
      width                     = 1.5,
      step                      = 0.01,
      bigStep                   = 0.05,
      isPercent                 = true,
      order                     = source_order(),
    };

    lookSubGroup.args.spa             = Spacer();

    lookSubGroup.args.colors          =
    { type                      = "execute",
      name                      = "Colors",
      func                      = function() linkHandler("opt://colors/rpufColors") end,
      width                     = 0.75,
      order                     = source_order(),
    };

    local statSSubGroup               =
    { type                      = "group",
      inline                    = true,
      name                      = "Status Bar Appearance",
      order                     = source_order(),
      hidden                    = frame and linked_or_not_show(),
      args                      = {}
    };

    statSSubGroup.args.texture        =
    { type                      = "select",
      dialogControl             = "LSM30_Statusbar",
      name                      = cloc(f.statusTexture),
      desc                      = tloc(f.statusTexture),
      width                     = 1.40,
      get                       = get(f.statusTexture),
      set                       = function(info, value) Set(f.statusTexture, value); Refresh(frameName, "statusbar") end,
      values                    = function() return LibSharedMedia:HashTable("statusbar") end,
      order                     = source_order(),
    };

    statSSubGroup.args.spa            = Spacer();

    statSSubGroup.args.align          =
    { type                      = "select",
      name                      = cloc(f.statusAlign),
      desc                      = tloc(f.statusAlign),
      order                     = source_order(),
      get                       = get(f.statusAlign),
      set                       = function(info, value) Set(f.statusAlign, value); Refresh(frameName, "statusbar") end,
      values                    = menu.align,
      width = 0.75,
    };

    statSSubGroup.args.alpha          =
    { type = "range",
      name = cloc(f.statusAlpha),
      desc = tloc(f.statusAlpha),
      get = get(f.statusAlpha),
      set = function(info, value) Set(f.statusAlpha, value); Refresh(frameName, "statusbar") end,
      order = source_order(),
      width = 1.40,
      step                      = 0.01,
      bigStep                   = 0.05,
      isPercent                 = true,
      min = 0,
      max = 1,
    };


    lookSubGroup.args.statSSubGroup         = statSSubGroup;
    frameGroup.args.lookSubGroup      = lookSubGroup;

    local dimiSubGroup                =
    { type                      = "group",
      name                      = "Panel Dimensions",
      order                     = source_order(),
      hidden                    = frame and linked_or_not_show(),
      args                      = {}
    };

    dimiSubGroup.args.gap             =
    { type                      = "range",
      name                      = cloc(f.gapSize),
      desc                      = cloc(f.gapSize),
      get                       = get(f.gapSize),
      set                       = function(info, value) Set(f.gapSize, value); Refresh(frameName, "framesize", "sizes") end,
      min                       = 0,
      softMax                   = 20,
      max                       = 30,
      step                      = 1,
      order                     = source_order(),
    };

    dimiSubGroup.args.spg             = Spacer();

    dimiSubGroup.args.icon            =
    { type                      = "range",
      name                      = cloc(f.iconWidth),
      desc                      = cloc(f.iconWidth),
      get                       = get(f.iconWidth),
      set                       = function(info, value) Set(f.iconWidth, value); Refresh(frameName, "fonts", "framesize", "sizes") end,
      min                       = 5,
      softMin                   = 10,
      softMax                   = 50,
      max                       = 100,
      step                      = 1,
      order                     = source_order(),
    };

    dimiSubGroup.args.spi             = Spacer();

    dimiSubGroup.args.port            =
    { type                      = "range",
      name                      = cloc(f.portWidth),
      desc                      = cloc(f.portWidth),
      get                       = get(f.portWidth),
      set                       = function(info, value) Set(f.portWidth, value); Refresh(frameName, "framesize", "sizes") end,
      min                       = 10,
      softMin                   = 25,
      softMax                   = 100,
      max                       = 200,
      step                      = 5,
      order                     = source_order(),
    };

    dimiSubGroup.args.spp             = Spacer();

    dimiSubGroup.args.info            =
    { type                      = "range",
      name                      = cloc(f.infoWidth),
      desc                      = cloc(f.infoWidth),
      get                       = get(f.infoWidth),
      set                       = function(info, value) Set(f.infoWidth, value); Refresh(frameName, "framesize", "sizes") end,
      min                       = 20,
      softMin                   = 50,
      softMax                   = 300,
      max                       = 400,
      step                      = 10,
      order                     = source_order(),
    };

    dimiSubGroup.args.height         =
    { type                      = "range",
      name                      = cloc(f.statusHeight),
      desc                      = tloc(f.statusHeight),
      order                     = source_order(),
      get                       = get(f.statusHeight),
      set                       = function(info, value) Set(f.statusHeight, value); Refresh(frameName, "statusbar", "framesize", "sizes") end,
      min                       = 5,
      softMin                   = 10,
      softMax                   = 75,
      max                       = 150,
      step                      = 1,
    };

    dimiSubGroup.args.spn             = Spacer();

    detail                      =
    { type                      = "range",
      name                      = cloc(f.detailHeight),
      desc                      = cloc(f.detailHeight),
      get                       = get(f.detailHeight),
      set                       = function(info, value) Set(f.detailHeight, value); Refresh(frameName, "framesize", "sizes"); end,
      min                       = 20,
      softMin                   = 50,
      softMax                   = 300,
      max                       = 400,
      step                      = 10,
      order                     = source_order(),
    };

    frameGroup.args.dimiSubGroup      = dimiSubGroup;

    local fontSubGroup               =
    { type                      = "group",
      name                      = "Fonts",
      order                     = source_order(),
      hidden                    = frame and linked_or_not_show(),
      args                      = 
      { header =
        { type = "description",
          name = "## Fonts",
          order = source_order(),
          width = "full",
          dialogControl = "LMD30_Description",
        },
        instruct =
        { type = "description",
          name = "You can choose specific fonts for each panel. Font sizes are relative " ..
                 "to the base font size.",
          order = source_order(),
          width = "full",
          dialogControl = "LMD30_Description",
        }, 
        mainSize =
        { type                      = "range",
          min                       = 6,
          max                       = 24,
          step                      = 1,
          name                      = cloc(f.fontSize),
          desc                      = tloc(f.fontSize),
          order                     = source_order(),
          get                       = get(f.fontSize),
          width                     = "full",
          set                       = function(info, value) Set(f.fontSize, value) Refresh(frameName, "fonts", "sizes") end,
        },
        nameFont =
        { type = "group",
          order = source_order(),
          name = "Name Panel",
          inline = true,
          args =
          { nameFontName  =
            { type                      = "select",
              values                    = function() return LibSharedMedia:HashTable("font") end,
              width                     = 1.25,
              dialogControl             = "LSM30_Font",
              name                      = cloc(f.nameFont),
              desc                      = tloc(f.nameFont),
              order                     = source_order(),
              get                       = get(f.nameFont),
              set                       = function(info, value) Set(f.nameFont, value) Refresh(frameName, "fonts", "sizes", "framesize") end,
            },
            nameSpacer = Spacer(),
            nameFontSize =
            { type = "select",
              values = menu.fontSize,
              sorting = menu.fontSizeOrder,
              get = function() return Get(f.nameFontSize) end,
              set = function(info, value) Set(f.nameFontSize, value) Refresh(frameName, "fonts", "sizes", "framesize") end,
              order = source_order(),
              name = cloc(f.nameFontSize),
              desc = tloc(f.nameFontSize),
              width = 0.75,
            },
          },
        },
        statusBarFont =
        { type = "group",
          order = source_order(),
          name = "Status Bar Panel",
          inline = true,
          args =
          {
            statusFontName  =
            { type                      = "select",
              values                    = function() return LibSharedMedia:HashTable("font") end,
              width                     = 1.25,
              dialogControl             = "LSM30_Font",
              name                      = cloc(f.statusFont),
              desc                      = tloc(f.statusFont),
              order                     = source_order(),
              get                       = get(f.statusFont),
              set                       = function(info, value) Set(f.statusFont, value) Refresh(frameName, "fonts", "statusbar") end,
            },
            statusSpacer = Spacer(),
            statusFontSize =
            { type = "select",
              values = menu.fontSize,
              sorting = menu.fontSizeOrder,
              get = function() return Get(f.statusFontSize) end,
              set = function(info, value) Set(f.statusFontSize, value) Refresh(frameName, "fonts", "statusbar") end,
              order = source_order(),
              name = cloc(f.statusFontSize),
              desc = tloc(f.statusFontSize),
              width = 0.75,
            },
          },
        },
        detailFont =
        { type = "group",
          order = source_order(),
          name = "Details Panel",
          inline = true,
          args =
          {
            detailFontName  =
            { type                      = "select",
              values                    = function() return LibSharedMedia:HashTable("font") end,
              width                     = 1.25,
              dialogControl             = "LSM30_Font",
              name                      = cloc(f.detailFont),
              desc                      = tloc(f.detailFont),
              order                     = source_order(),
              get                       = get(f.detailFont),
              set                       = function(info, value) Set(f.detailFont, value) Refresh(frameName, "fonts") end,
            },
            detailSpacer = Spacer(),
            detailFontSize =
            { type = "select",
              values = menu.fontSize,
              sorting = menu.fontSizeOrder,
              get = function() return Get(f.detailFontSize) end,
              set = function(info, value) Set(f.detailFontSize, value) Refresh(frameName, "fonts") end,
              order = source_order(),
              name = cloc(f.detailFontSize),
              desc = tloc(f.detailFontSize),
              width = 0.75,
            },
          },
        },
        infoFont =
        { type = "group",
          order = source_order(),
          name = "Info Panel",
          inline = true,
          args =
          {
            infoFontName  =
            { type                      = "select",
              values                    = function() return LibSharedMedia:HashTable("font") end,
              width                     = 1.25,
              dialogControl             = "LSM30_Font",
              name                      = cloc(f.infoFont),
              desc                      = tloc(f.infoFont),
              order                     = source_order(),
              get                       = get(f.infoFont),
              set                       = function(info, value) Set(f.infoFont, value) Refresh(frameName, "fonts") end,
            },
            infoSpacer = Spacer(),
            infoFontSize =
            { type = "select",
              values = menu.fontSize,
              sorting = menu.fontSizeOrder,
              get = function() return Get(f.infoFontSize) end,
              set = function(info, value) Set(f.infoFontSize, value) Refresh(frameName, "fonts") end,
              order = source_order(),
              name = cloc(f.infoFontSize),
              desc = tloc(f.infoFontSize),
              width = 0.75,
            },
          },
        }
      }
    };
        
    frameGroup.args.fontSubGroup      = fontSubGroup;

    return frameGroup;

  end;

  local sharedGroup           = build_frame_group();

  local function statusName(frameName)
    return { type     = "description",
             name     = string.format("[%s](opt://RPUF_Frames/%s)", 
                                        loc(frameName .. "FRAME"),
                                        frameName:lower()),
             dialogControl = "LMD30_Description",
             width    = 0.85,
             fontSize = "medium",
             order    = source_order()
          };
  end;

  local function statusShow(frameName)
    return { type     = "toggle",
             name     = "Enabled",
             get      = get("SHOW_FRAME_" .. frameName),
             set      = function(info, value) Set("SHOW_FRAME_" .. frameName,  value); Refresh(frameName, "hiding") end,
             disabled = function() return Get("DISABLE_PRUF") end,
             width    = 0.5,
             order    = source_order(),
           };
  end;

  local function statusLinked(frameName)
    return { type     = "toggle",
             name     = "Linked",
             get      = get("LINK_FRAME_" .. frameName),
             set      = function(info, value) Set("LINK_FRAME_" .. frameName, value); Refresh(frameName, "all") end,
             width    = 0.5,
             disabled = function() return Get("DISABLE_RPUF") or not Get("SHOW_FRAME_" .. frameName) end,
             order    = source_order(),
          };
  end;

  local function statusLocked(frameName)
    return { type = "toggle",
             name = "Locked",
             get = get("LOCK_FRAME_" .. frameName),
             set = function(info, value) Set("LOCK_FRAME_" .. frameName, value); Refresh(frameName, "lock") end,
             width = 0.5,
             disabled = function() return Get("DISABLE_RPUF") or not Get("SHOW_FRAME_" .. frameName) end,
             order = source_order(),
          };
  end;


  -- -------------------------------------------------------------------------------------------------------------

  local panelGroup            =
  { name                      = loc("OPT_RPUF_FRAMES"),
    order                     = source_order(),
    type                      = "group",
    hidden                    = function() return Get("DISABLE_RPUF") end,
    args                      = {},
  };

  local statusGroup = 
  { type = "group",
    order = 10,
    inline = true,
    name = "Frames Status",
    args = {}
  };

  for _, frameData in ipairs(frameList)
  do  local frameName, small = unpack(frameData);
      local name = frameName:lower();
      statusGroup.args[name .. "Name"   ] = statusName(frameName);
      statusGroup.args[name .. "Show"   ] = statusShow(frameName);
      statusGroup.args[name .. "Linked" ] = statusLinked(frameName);
      statusGroup.args[name .. "Locked" ] = statusLocked(frameName);
  end;

  sharedGroup.args.status = statusGroup;
  panelGroup.args.shared  = sharedGroup;

  for _, frameData in ipairs(frameList)
  do  local name, small = unpack(frameData);
      panelGroup.args[name:lower()] = build_frame_group(name, small);
  end;

  addOptionsPanel("RPUF_Frames", panelGroup);

end);
