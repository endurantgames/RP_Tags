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

  local refreshFuncs =
  { framesize        = "SetDimensions",
    layout           = "PlacePanels",
    fonts            = "SetFont",
    textcolor        = "SetTextColor",
    tags             = "SetTagStrings",
    hiding           = "SetVisibility",
    lock             = "ApplyLock",
    statusbar        = "StyleStatusBar",
    style            = "StyleFrame",
    location         = "SetPosition",
    vis              = "SetPanelVis",
    scale            = "CallScaleHelper",
    sizes            = "PlacePanels",
  };

  local function refresh(frameName, ...)

    local function helper(funcName, frame) -- takes a name of a method (from the list above)
      local func = frame[funcName];        -- and a frame, and calls the func if possible
      if func and type(func) == "function" then func(frame) end;
    end;

    for _, param in ipairs({ ... })
    do  local what = refreshFuncs[param:lower()];
        if    what
        then  local  ufCache = RPTAGS.cache.UnitFrames;
              if     (not frameName) or (frameName:lower() == "all")
              then   for name, frame in pairs(ufCache) do helper(what, frame); end;
              elseif ufCache[frameName:lower()]
              then   helper(what, ufCache[frameName:lower()]);
              end;
        end
    end;
  end;

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

    if   frameName then str = frameName:upper(); ul_str = "_" .. str; frame  = true;
                   else str = "";                ul_str = "";         shared = true; end

    -- work out these before hand -- they're the config keys
    local f           =
    { alpha           = "RPUFALPHA"           .. ul_str,
      backdrop        = "RPUF_BACKDROP"       .. ul_str,
      detailHeight    = "DETAILHEIGHT"        .. ul_str,
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
      layout          = str                   .. "LAYOUT",
      link            = "LINK_FRAME"          .. ul_str,
      lockFrame       = "LOCK_FRAMES"         .. ul_str,
      mouseoverCursor = "MOUSEOVER_CURSOR"    .. ul_str,
      portWidth       = "PORTWIDTH"           .. ul_str,
      statusAlign     = "STATUS_ALIGN"        .. ul_str,
      statusHeight    = "STATUSHEIGHT"        .. ul_str,
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
      set                       = function(info, value) Set(f.show, value); refresh(frameName, "hiding"); end,
      hidden                    = disableRpuf(),
      order                     = source_order(),
    };

    frameGroup.args.spa         = Spacer();

    frameGroup.args.link        = frame and
    { type                      = "toggle",
      name                      = cloc(f.link),
      desc                      = tloc(f.link),
      get                       = get(f.link),
      hidden                    = not_show(),
      set                       = function(info, value) Set(f.link, value); refresh(frameName, "all"); end,
      order                     = source_order(),
    };

    frameGroup.args.spb         = Spacer();

    frameGroup.args.layout      = frame and
    { type                      = "select",
      name                      = cloc(f.layout),
      desc                      = tloc(f.layout),
      get                       = get(f.layout),
      set                       = function(info, value) Set(f.layout, value); refresh(frameName, "framesize", "sizes", "vis"); end,
      values                    = small and menu.small or menu.large,
      order                     = source_order(),
      hidden                    = not_show(),
    };

    frameGroup.args.spc         = Spacer();

    frameGroup.args.scale       = frame and
    { type                      = "range",
      min                       = 0.25,
      max                       = 3.00,
      isPercent                 = true,
      step                      = 0.05,
      get                       = get(f.scale),
      set                       = function(info, value) Set(f.scale, value); refresh(frameName, "scale") end,
      order                     = source_order(),
      hidden                    = not_show(),
      name                      = cloc(f.scale),
      desc                      = tloc(f.scale),
    };

    local visiSG                =
    { type                      = "group",
      inline                    = true,
      name                      = "Visibility",
      order                     = source_order(),
      hidden                    = not_show(),
      disabled                  = disabled,
      args                      = {},
    };

    visiSG.args.hideCombat      =
    { type                      = "toggle",
      name                      = cloc(f.hideCombat),
      desc                      = tloc(f.hideCombat),
      set                       = function(info, value) Set(f.hideCombat, value); refresh(frameName, "hiding"); end,
      get                       = get(f.hideCombat),
      order                     = source_order(),
    };

    visiSG.args.hidePetBattle   =
    { type                      = "toggle",
      name                      = cloc(f.hidePetBattle),
      desc                      = tloc(f.hidePetBattle),
      set                       = function(info, value) Set(f.hidePetBattle, value); refresh(frameName, "hiding"); end,
      get                       = get(f.hidePetBattle),
      order                     = source_order(),
    };

    visiSG.args.hideVehicle     =
    { type                      = "toggle",
      name                      = cloc(f.hideVehicle),
      desc                      = tloc(f.hideVehicle),
      set                       = set(f.hideVehicle, "hiding"),
      set                       = function(info, value) Set(f.hideVehicle, value); refresh(frameName, "hiding"); end,
      get                       = get(f.hideVehicle),
      order                     = source_order(),
    };

    visiSG.args.hideParty       =
    { type                      = "toggle",
      name                      = cloc(f.hideParty),
      desc                      = tloc(f.hideParty),
      set                       = function(info, value) Set(f.hideParty, value); refresh(frameName, "hiding"); end,
      get                       = get(f.hideParty),
      order                     = source_order(),
    };

    visiSG.args.hideRaid        =
    { type                      = "toggle",
      name                      = cloc(f.hideRaid),
      desc                      = tloc(f.hideRaid),
      set                       = function(info, value) Set(f.hideRaid, value); refresh(frameName, "hiding"); end,
      get                       = get(f.hideRaid),
      order                     = source_order(),
    };

    visiSG.args.hideDead        =
    { type                      = "toggle",
      name                      = cloc(f.hideDead),
      desc                      = tloc(f.hideDead),
      set                       = function(info, value) Set(f.hideDead, value); refresh(frameName, "hiding"); end,
      get                       = get(f.hideDead),
      order                     = source_order(),
    };

    visiSG.args.mouseoverCursor =
    { type                      = "toggle",
      name                      = cloc(f.mouseoverCursor),
      desc                      = tloc(f.mouseoverCursor),
      set                       = function(info, value) Set(f.mouseoverCursor, value); end,
      get                       = get(f.mouseoverCursor),
      order                     = source_order(),
    };

    frameGroup.args.visiSG      = visiSG;

    local posiSG                =
    { type                      = "group",
      name                      = "Positioning",
      order                     = source_order(),
      inline                    = true,
      hidden                    = linked_or_not_show(),
      args                      = {},
    };

    posiSG.args.lockFrames      =
    { type                      = "toggle",
      name                      = cloc(f.lockFrame),
      desc                      = tloc(f.lockFrame),
      width                     = "full",
      get                       = get(f.lockFrame),
      set                       = function(info, value) Set(f.lockFrame, value); refresh(frameName, "lock"); end,
      order                     = source_order(),
    };

    posiSG.args.resetFrames     =
    { type                      = "execute",
      name                      = cloc("RESET_FRAME_LOCATIONS"),
      desc                      = tloc("RESET_FRAME_LOCATIONS"),
      func                      = function() refresh(frameName, "location") end,
      order                     = source_order(),
    };

    frameGroup.args.posiSG      = posiSG;

    local lookSG                =
    { type                      = "group",
      name                      = "Frame Appearance",
      order                     = source_order(),
      hidden                    = linked_or_not_show(),
      args                      = {}
    };

    lookSG.args.backdrop        =
    { type                      = "select",
      dialogControl             = "LSM30_Background",
      values                    = LibSharedMedia:HashTable("background"),
      width                     = "full",
      get                       = get(f.backdrop),
      set                       = function(info, value) Set(f.backdrop, value); refresh(frameName, "style"); end,
      name                      = cloc(f.backdrop),
      desc                      = tloc(f.backdrop),
      order                     = source_order(),
    };

    lookSG.args.spb             = Spacer();

    lookSG.args.alpha           =
    { type                      = "range",
      name                      = cloc(f.alpha),
      desc                      = tloc(f.alpha),
      get                       = get(f.alpha),
      set                       = function(info, value) Set(f.alpha, value); refresh(frameName, "style", "statusbar" ); end,
      min                       = 0,
      max                       = 1,
      step                      = 0.01,
      bigStep                   = 0.05,
      isPercent                 = true,
      order                     = source_order(),
    };

    lookSG.args.spa             = Spacer();

    lookSG.args.colors          =
    { type                      = "execute",
      name                      = "Colors",
      func                      = function() linkHandler("opt://colors/rpuf") end,
      order                     = source_order(),
    };

    local fontSSG               =
    { type                      = "group",
      inline                    = true,
      name                      = "Font",
      order                     = source_order(),
      hidden                    = linked_or_not_show(),
      args                      = {};
    };

    fontSSG.args.name           =
    { type                      = "select",
      values                    = LibSharedMedia:HashTable("font"),
      dialogControl             = "LSM30_Font",
      name                      = cloc(f.fontName),
      desc                      = tloc(f.fontName),
      order                     = source_order(),
      get                       = get(f.fontName),
      set                       = function(info, value) Set(f.fontName, value) refresh(frameName, "fonts", "statusbar") end,
    };

    fontSSG.args.Size           =
    { type                      = "range",
      min                       = 6,
      max                       = 24,
      step                      = 1,
      name                      = cloc(f.fontSize),
      desc                      = tloc(f.fontSize),
      order                     = source_order(),
      get                       = get(f.fontSize),
      set                       = function(info, value) Set(f.fontSize, value) refresh(frameName, "fonts") end,
    };

    lookSG.args.fontSSG         = fontSSG;

    local statSSG               =
    { type                      = "group",
      inline                    = true,
      name                      = "Status Bar Appearance",
      order                     = source_order(),
      hidden                    = linked_or_not_show(),
      args                      = {}
    };

    statSSG.args.align          =
    { type                      = "select",
      name                      = cloc(f.statusAlign),
      desc                      = tloc(f.statusAlign),
      order                     = source_order(),
      get                       = get(f.statusAlign),
      set                       = function(info, value) Set(f.statusAlign, value); refresh(frameName, "statusbar") end,
      values                    = menu.align,
    };

    statSSG.args.spa            = Spacer();

    statSSG.args.texture        =
    { type                      = "select",
      dialogControl             = "LSM30_Statusbar",
      name                      = cloc(f.statusTexture),
      desc                      = tloc(f.statusTexture),
      get                       = get(f.statusTexture),
      set                       = function(info, value) Set(f.statusTexture, value); refresh(frameName, "statusbar") end,
      values                    = LibSharedMedia:HashTable("statusbar"),
      order                     = source_order(),
    };

    statSSG.args.spt            = Spacer();

    statSSG.args.height         =
    { type                      = "range",
      name                      = cloc(f.statusHeight),
      desc                      = tloc(f.statusHeight),
      order                     = source_order(),
      get                       = get(f.statusHeight),
      set                       = function(info, value) Set(f.statusHeight, value); refresh(frameName, "statusbar", "framesize", "sizes") end,
      min                       = 5,
      softMin                   = 10,
      softMax                   = 50,
      max                       = 100,
      step                      = 1,
    };

    lookSG.args.statSSG         = statSSG;
    frameGroup.args.lookSG      = lookSG;

    local dimiSG                =
    { type                      = "group",
      name                      = "Panel Dimensions",
      order                     = source_order(),
      hidden                    = linked_or_not_show(),
      args                      = {}
    };

    dimiSG.args.gap             =
    { type                      = "range",
      name                      = cloc(f.gapSize),
      desc                      = cloc(f.gapSize),
      get                       = get(f.gapSize),
      set                       = function(info, value) Set(f.gapSize, value); refresh(frameName, "framesize", "sizes") end,
      min                       = 0,
      softMax                   = 10,
      max                       = 20,
      step                      = 1,
      order                     = source_order(),
    };

    dimiSG.args.spg             = Spacer();

    dimiSG.args.icon            =
    { type                      = "range",
      name                      = cloc(f.iconWidth),
      desc                      = cloc(f.iconWidth),
      get                       = get(f.iconWidth),
      set                       = function(info, value) Set(f.iconWidth, value); refresh(frameName, "framesize", "sizes") end,
      min                       = 5,
      softMin                   = 10,
      max                       = 50,
      step                      = 1,
      order                     = source_order(),
    };

    dimiSG.args.spi             = Spacer();

    dimiSG.args.port            =
    { type                      = "range",
      name                      = cloc(f.portWidth),
      desc                      = cloc(f.portWidth),
      get                       = get(f.portWidth),
      set                       = function(info, value) Set(f.portWidth, value); refresh(frameName, "framesize", "sizes") end,
      min                       = 10,
      softMin                   = 25,
      softMax                   = 100,
      max                       = 200,
      step                      = 5,
      order                     = source_order(),
    };

    dimiSG.args.spp             = Spacer();

    dimiSG.args.info            =
    { type                      = "range",
      name                      = cloc(f.infoWidth),
      desc                      = cloc(f.infoWidth),
      get                       = get(f.infoWidth),
      set                       = function(info, value) Set(f.infoWidth, value); refresh(frameName, "framesize", "sizes") end,
      min                       = 20,
      softMin                   = 50,
      softMax                   = 300,
      max                       = 400,
      step                      = 10,
      order                     = source_order(),
    };

    dimiSG.args.spn             = Spacer();

    detail                      =
    { type                      = "range",
      name                      = cloc(f.detailHeight),
      desc                      = cloc(f.detailHeight),
      get                       = get(f.detailHeight),
      set                       = function(info, value) Set(f.detailHeight, value); refresh(frameName, "framesize", "sizes"); end,
      min                       = 20,
      softMin                   = 50,
      softMax                   = 300,
      max                       = 400,
      step                      = 10,
      order                     = source_order(),
    };

    frameGroup.args.dimiSG      = dimiSG;
    return frameGroup;

  end;

  local function statusName(frameName)
    return { type     = "description",
             name     = loc(frameName .. "FRAME"),
             width    = 1,
             fontSize = "medium",
             width    = 1.0,
             order    = source_order()
          };
  end;

  local function statusShow(frameName)
    return { type     = "toggle",
             name     = "Enabled",
             get      = get("SHOW_FRAME_" .. frameName),
             set      = function(info, value) Set("SHOW_FRAME_" .. frameName,  value); refresh(frameName, "hiding") end,
             disabled = disableRpuf(),
             width    = 0.5,
             order    = source_order(),
           };
  end;

  local function statusLinked(frameName)
    return { type     = "toggle",
             name     = "Linked",
             get      = get("LINK_FRAME_" .. frameName),
             set      = function(info, value) Set("LINK_FRAME_" .. frameName, value); refresh(frameName, "all") end,
             width    = 0.5,
             disabled = function() return Get("DISABLE_RPUF") or not Get("SHOW_FRAME_" .. frameName) end,
             order    = source_order(),
          };
  end;

  -- -------------------------------------------------------------------------------------------------------------

  local panelGroup            =
  { name                      = loc("RPUF_NAME"),
    order                     = source_order(),
    type                      = "group",
    args                      = {},
  };

  panelGroup.args.instruct    =
  { type                      = "description",
    dialogControl             = "LMD30_Description",
    name                      = loc("PANEL_RPUF_MAIN"),
    order                     = source_order(),
  };

  panelGroup.args.disableUF   =
  { type                      = "toggle",
    order                     = source_order(),
    name                      = loc("CONFIG_DISABLE_RPUF"),
    desc                      = loc("CONFIG_DISABLE_RPUF_TT"),
    get                       = get("DISABLE_RPUF"),
    set                       = function(info, value) Set("DISABLE_RPUF", value); refresh("hiding"); end,
    width                     = 1.5,
  };

  panelGroup.args.disableBliz =
  { type                      = "toggle",
    order                     = source_order(),
    name                      = cloc("DISABLE_BLIZZARD"),
    desc                      = tloc("DISABLE_BLIZZARD"),
    get                       = get("DISABLE_BLIZZARD"),
    set                       = function(info, value) Set("DISABLE_BLIZZARD", value); refresh("hiding"); end,
    width                     = 1.5,
  };

  local sharedGroup           = build_frame_group();

  local statusGroup = 
  { type = "group",
    order = source_order(),
    inline = true,
    name = "Frames Status",
    args = {}
  };

  for _, frameData in ipairs(frameList)
  do  local frameName, small = unpack(frameData);
      local name = frameName:lower();
      statusGroup.args[name .. "Name"   ] = statusName(frameName);
      statusGroup.args[name .. "Spacer1"] = Spacer();
      statusGroup.args[name .. "Show"   ] = statusShow(frameName);
      statusGroup.args[name .. "Spacer2"] = Spacer();
      statusGroup.args[name .. "Linked" ] = statusLinked(frameName);

  end;

  for _, frameData in ipairs(frameList)
  do  local name, small = unpack(frameData);
      panelGroup.args[name:lower()] = build_frame_group(name, small);
  end;

  sharedGroup.args.statusGroup = statusGroup;
  panelGroup.args.sharedGroup  = sharedGroup;

  addOptionsPanel("RPUF_Main", panelGroup);

end);
