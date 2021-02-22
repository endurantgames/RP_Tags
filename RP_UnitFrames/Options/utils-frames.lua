local addOnName, addOn = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("before MODULE_G", -- module options must load before RPTAGS options
function(self, event, ...)

  local Utils = RPTAGS.utils;
  local Config = Utils.config;
  local Get = Config.get;
  local Set = Config.set;
  local Locale = Utils.locale;
  local loc = Locale.loc;
  local CONST = RPTAGS.CONST;
  local optUtils = Utils.options;
  local source_order = optUtils.source_order
  local Spacer = optUtils.spacer;
  local linkHandler = Utils.links.handler;

  local menu =
  { align =
    { LEFT = loc("LEFT"                            ),
      CENTER = loc("CENTER"                          ),
      RIGHT = loc("RIGHT"                           ), },
    small =
    { COMPACT = loc("RPUF_COMPACT"                    ),
      ABRIDGED = loc("RPUF_ABRIDGED"                   ),
      THUMBNAIL = loc("RPUF_THUMBNAIL"                  ), },
    large =
    { COMPACT = loc("RPUF_COMPACT"                    ),
      ABRIDGED = loc("RPUF_ABRIDGED"                   ),
      THUMBNAIL = loc("RPUF_THUMBNAIL"                  ),
      PAPERDOLL = loc("RPUF_PAPERDOLL"                  ),
      FULL = loc("RPUF_FULL"                       ), },
    font = LibSharedMedia:HashTable("font"       ),
    background = LibSharedMedia:HashTable("background" ),
    border = LibSharedMedia:HashTable("border"     ),
    statusbar = LibSharedMedia:HashTable("statusbar"  ),
    fontSize =
    { extrasmall = loc("SIZE_EXTRA_SMALL"),
      small = loc("SIZE_SMALL"),
      medium = loc("SIZE_MEDIUM"),
      large = loc("SIZE_LARGE"),
      extralarge = loc("SIZE_EXTRA_LARGE"), },
  };

  local refreshFuncs =
  { framesize = "SetDimensions",
    layout = "PlacePanels",
    fonts = "SetFont",
    textcolor = "SetTextColor",
    tags = "SetTagStrings",
    backdrop = "StyleFrame",
    hiding = "SetVisibility",
    lock = "ApplyLock",
    statusBar = "StyleStatusBar",
    style = "StyleFrame",
    location = "SetPosition",
    vis = "SetPanelVis",
    scale = "CallScaleHelper",
    sizes = "PlacePanels",
  };

  local function refresh(w, ...)
    local funcsToRun = {}
    local whatList = { ... };

    for _,     what in ipairs(whatList)
    do  if     what == "all"
        then   for k, v in pairs(refreshFuncs)
               do funcsToRun[k] = v;
               end;
               break;
        elseif refreshFuncs[what]
        then   funcsToRun[what] = refreshFuncs[what];
        end;
    end;

    for  _,   func in ipairs(funcsToRun)
    do   for  frameName, frame in pairs(RPTAGS.cache.UnitFrames)
         do   print(frame.unit,"running",func);
              frame[func](frame);
         end;
    end;
  end;

  local function build_frame_group(frameName)
    local LibSharedMedia = LibStub("LibSharedMedia-3.0"),
    local str, ul_str, frame, shared;

    if   frameName
    then str = frameName:upper(); ul_str = "_" .. str;
         frame = true;
    else str = "";                ul_str = "";
         shared = true;
    end

    -- work out these before hand -- they're the config keys
    local f =
    { alpha = "RPUFALPHA"           .. ul_str,
      backdrop = "RPUF_BACKDROP"       .. ul_str,
      detailHeight = "DETAILHEIGHT"        .. ul_str,
      gapSize = "GAPSIZE_"            .. ul_str,
      iconWidth = "ICONWIDTH_"          .. ul_str,
      infoWidth = "INFOWIDTH_"          .. ul_str,
      layout = str                   .. "LAYOUT",
      link = "LINK_FRAME"          .. ul_str,
      scale = str                   .. "FRAME_SCALE",
      portWidth = "PORTWIDTH"           .. ul_str,
      show = "SHOW_FRAME"          .. ul_str,
      sAlign = "STATUS_ALIGN"        .. ul_str,
      sHeight = "STATUSHEIGHT"        .. ul_str,
      sTexture = "STATUS_TEXTURE"      .. ul_str,
      hideCombat = "RPUF_HIDE_COMBAT"    .. ul_str,
      hidePetBattle = "RPUF_HIDE_PETBATTLE" .. ul_str,
      hideVehicle = "RPUF_HIDE_VEHICLE"   .. ul_str,
      hideParty = "RPUF_HIDE_PARTY"     .. ul_str,
      hideRaid = "RPUF_HIDE_RAID"      .. ul_str,
      hideDead = "RPUF_HIDE_DEAD"      .. ul_str,
      mouseoverCursor = "MOUSEOVER_CURSOR"    .. ul_str,
      lockFrame = "LOCK_FRAMES"         .. ul_str,
      name = str                   .. "FRAME",
    };

    -- specialized loc()
    local function cloc(s) return loc("CONFIG_" .. s)          end;
    local function tloc(s) return loc("CONFIG_" .. s .. "_TT") end;
    local function oloc(s) return loc("OPT_".. s)              end;

    -- spacer

    -- constructor functions
    function get(setting)  return function() return Get(setting) end end; -- builds a Getter function

    function set(setting, ...) -- builds a Setter function
      local what = { ... }; 
      return function(info, value)
               Set(setting, value);
               refresh(what); -- works out what to refresh
             end;
    end;

    -- hider constructors                 [-----------------------------------------------------------]
    function not_show()            return function() return not Get(f.show)                        end;  end;
    function disable()             return function() return Get("DISABLE_RPUF")                    end;  end;
    function not_show_or_disable() return function() return not Get(f.show) or Get("DISABLE_RPUF") end;  end;
    function linked()              return function() return Get(f.link)                            end;  end;
    function linked_or_not_show()  return function() return Get(f.link) or not Get(f.show)         end;  end;

    local frameGroup =
    { name = frame and loc(str .. "FRAME") or oloc("SHARED_SETTINGS"),
      order = source_order(),
      type = "group",
      hidden = function() return Get("DISABLE_RPUF") end,
      args = {},
    };

    frameGroup.args.show = frame and
    { type = "toggle",
      name = cloc(f.show),
      desc = tloc(f.show),
      get = get(f.show),
      set = set(f.show, "hiding"),
      hidden = disabled(),
      order = source_order(),
    };

    frameGroup.args.spa = Spacer();

    frameGroup.args.link = frame and
    { type = "toggle",
      name = cloc(f.link),
      desc = tloc(f.link),
      get = get(f.link),
      hidden = not_show(),
      set = set(f.link, "all"),
      order = source_order(),
    };

    frameGroup.args.spb = Spacer();

    frameGroup.args.layout = frame and
    { type = "select",
      name = cloc(f.layout),
      desc = tloc(f.layout),
      get = get(f.layout),
      set = set(f.layout, "framesize", "sizes", "vis" ),
      values = info.small and menu.small or menu.large,
      order = source_order(),
      hidden = not_show(),
    };

    frameGroup.args.spc = Spacer();

    frameGroup.args.scale = frame and
    { type = "range",
      min = 0.25,
      max = 3.00,
      isPercent = true,
      step = 0.05,
      get = get(f.scale),
      set = set(f.scale, { "scale" }),
      order = source_order(),
      hidden = not_show(),
      name = cloc(f.scale),
      desc = tloc(f.scale),
    };

    local visiSubgroup =
    { type = "group",
      inline = true,
      name = "Visibility",
      order = source_order(),
      hidden = not_show(),
      disabled = disabled,
      args = {},
    };

    visiSubgroup.args.hideCombat =
    { type = "toggle",
      name = cloc(f.hideCombat),
      desc = tloc(f.hideCombat),
      set = set(f.hideCombat, "hiding"),
      get = get(f.hideCombat),
      order = source_order(),
    };

    visiSubgroup.args.hidePetBattle =
    { type = "toggle",
      name = cloc(f.hidePetBattle),
      desc = tloc(f.hidePetBattle),
      set = set(f.hidePetBattle, "hiding"),
      get = get(f.hidePetBattle),
      order = source_order(),
    };

    visiSubgroup.args.hideVehicle =
    { type = "toggle",
      name = cloc(f.hideVehicle),
      desc = tloc(f.hideVehicle),
      set = set(f.hideVehicle, "hiding"),
      get = get(f.hideVehicle),
      order = source_order(),
    };

    visiSubgroup.args.hideParty =
    { type = "toggle",
      name = cloc(f.hideParty),
      desc = tloc(f.hideParty),
      set = set(f.hideParty, "hiding"),
      get = get(f.hideParty),
      order = source_order(),
    };

    visiSubgroup.args.hideRaid =
    { type = "toggle",
      name = cloc(f.hideRaid),
      desc = tloc(f.hideRaid),
      set = set(f.hideRaid, "hiding"),
      get = get(f.hideRaid),
      order = source_order(),
    };

    visiSubgroup.args.hideDead =
    { type = "toggle",
      name = cloc(f.hideDead),
      desc = tloc(f.hideDead),
      set = set(f.hideDead, "hiding"),
      get = get(f.hideDead),
      order = source_order(),
    };

    visiSubgroup.args.mouseoverCursor =
    { type = "toggle",
      name = cloc(f.mouseoverCursor),
      desc = tloc(f.mouseoverCursor),
      set = set(f.mouseoverCursor),
      get = get(f.mouseoverCursor),
      order = source_order(),
    };

    frameGroup.args.visiSubgroup = visiSubgroup;

    local posiSubgroup =
    { type = "group",
      name = "Positioning",
      order = source_order(),
      inline = true,
      hidden = linked_or_not_show(),
      args = {},
    };

    posiSubgroup.args.lockFrames =
    { type = "toggle",
      name = cloc(f.lockFrame),
      desc = tloc(f.lockFrame),
      width = "full",
      get = get(f.lockFrame),
      set = set(f.lockFrame, "lock"),
      order = source_order(),
    };

    posiSubgroup.args.resetFrames =
    { type = "execute",
      name = cloc("RESET_FRAME_LOCATIONS"),
      desc = tloc("RESET_FRAME_LOCATIONS"),
      func = function() refresh("location") end,
      order = source_order(),
    };

    frameGroup.args.posiSubgroup = posiSubgroup;

    local lookSubgroup =
    look =
    { type = "group",
      name = "Frame Appearance",
      order = source_order(),
      hidden = linked_or_not_show(),
      args = {}
    };

    lookSubgroup.args.backdrop =
    { type = "select",
      dialogControl = "LSM30_Background",
      values = LibSharedMedia:HashTable("background"),
      get = get(f.backdrop),
      set = set(f.backdrop, "backdrop"),
      name = cloc(f.backdrop),
      desc = tloc(f.backdrop),
      order = source_order(),
    };

    lookSubgroup.args.spb = Spacer();

    lookSubgroup.args.alpha =
    { type = "range",
      name = cloc(f.alpha),
      desc = tloc(f.alpha),
      get = get(f.alpha),
      set = set(f.alpha),
      min = 0,
      max = 1,
      step = 0.01,
      bigStep = 0.05,
      isPercent = true,
      order = source_order(),
    };

    lookSubgroup.args.spa = Spacer();

    lookSubgroup.args.colors =
    { type = "execute",
      name = "Colors",
      func = function() linkHandler("opt://colors/rpuf") end,
      order = source_order(),
    };

    local fontSubSubgroup =
    { type = "group",
      inline = true,
      name = "Font",
      order = source_order(),
      hidden = linked_or_not_snow(),
      args = {};
    };

    fontSubSubgroup.args.name =
    { type = "select",
      values = LibSharedMedia:HashTable("font"),
      name = cloc(f.fontName),
      desc = tloc(f.fontName),
      order = source_order(),
      get = get(f.fontName),
      set = set(f.fontName, "fonts"),
    };

    fontSubSubgroup.args.Size =
    { type = "range",
      min = 6,
      max = 24,
          step = 1,
          name = cloc(f.fontSize),
          desc = tloc(f.fontSize),
          order = source_order(),
          get = get(f.fontSize),
          set = set(f.fontSize, "fonts"),
    };

    lookSubgroup.args.fontSubSubgroup = fontSubSubgroup;

    local statSubsubgroup =
    { type = "group",
      inline = true,
      name = "Status Bar Appearance",
      order = source_order(),
      hidden = linked_or_not_show(),
      args = {}
    };

    statSubsubgroup.args.align =
    { type = "select",
      name = cloc(f.sAlign),
      desc = tloc(f.sAlign),
      order = source_order(),
      get = get(f.sAlign),
      set = set(f.sAlign, "statusBar"),
      values = menu.align,
    };

    statSubsubgroup.args.spa = Spacer();

    statSubsubgroup.args.texture =
    { type = "select",
      dialogControl = "LSM30_Statusbar",
      name = cloc(f.sTexture),
      desc = tloc(f.sTexture),
      get = get(f.sTexture),
      set = get(f.sTexture, "statusBar"),
      values = LibSharedMedia:HashTable("statusbar"),
      order = source_order(),
    };

    statSubsubgroup.args.spt = Spacer();

    statSubsubgroup.args.height =
    { type = "range",
      name = cloc(f.sHeight),
      desc = tloc(f.sHeight),
      order = source_order(),
      get = get(f.sHeight),
      set = set(f.sHeight, "statusBar", "framesize", "sizes"),
      min = 10,
      max = 100,
      step = 1,
      bigStep = 5,
    };

    lookSubgroup.args.statSubsubgroup = statSubsubgroup;

    frameGroup.args.lookSubgroup = lookSubgroup;

    local dimiSubgroup =
    { type = "group",
      name = "Panel Dimensions",
      order = source_order(),
      hidden = linked_or_not_show(),
      args = {}
    };

    dimiSubgroup.args.gap =
    { type = "range",
      name = cloc(f.gapSize),
      desc = cloc(f.gapSize),
      get = get(f.gapSize),
      set = get(f.gapSize, "framesize", "sizes"),
      min = 0,
      max = 20,
      step = 1,
      order = source_order(),
    };

    dimiSubgroup.args.spg = Spacer();

    dimiSubgroup.args.icon =
    { type = "range",
      name = cloc(f.iconWidth),
      desc = cloc(f.iconWidth),
      get = get(f.iconWidth),
      set = get(f.iconWidth, "framesize", "sizes"),
      min = 10,
      max = 50,
      step = 1,
      bigStep = 5,
      order = source_order(),
    };

    dimiSubgroup.args.spi = Spacer();

    dimiSubgroup.args.port =
    { type = "range",
      name = cloc(f.portWidth),
      desc = cloc(f.portWidth),
      get = get(f.portWidth),
      set = get(f.portWidth, "framesize", "sizes"),
      min = 50,
      max = 150,
      step = 5,
      order = source_order(),
    };

    dimiSubgroup.args.spp = Spacer();

    dimiSubgroup.args.info =
    { type = "range",
      name = cloc(f.infoWidth),
      desc = cloc(f.infoWidth),
      get = get(f.infoWidth),
      set = get(f.infoWidth, "framesize", "sizes"),
      min = 100,
      max = 400,
      step = 10,
      order = source_order(),
    };

    dimiSubgroup.args.spn = Spacer();

    detail =
    { type = "range",
      name = cloc(f.detailHeight),
      desc = cloc(f.detailHeight),
      get = get(f.detailHeight),
      set = get(f.detailHeight, "framesize", "sizes"),
      min = 20,
      max = 250,
      step = 5,
      order = source_order(),
    };

    frameGroup.args.dimiSubgroup = dimiSubgroup;

    return frameGroup;

  end;
  RPTAGS.utils.options.frame_scaler = build_frame_scaler;
  RPTAGS.utils.options.tagpanel = build_tagpanel;
  RPTAGS.utils.options.requiresRPUF = requiresRPUF;
  RPTAGS.utils.options.frame_panel = build_frame_panel;
  RPTAGS.utils.options.editor_button = build_tag_editor_button;
  RPTAGS.utils.options.editor_bar_mockup = build_editor_bar_mockup;
  RPTAGS.utils.options.refresh = Refresh;

end);
