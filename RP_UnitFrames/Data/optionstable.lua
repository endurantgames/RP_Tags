local addOnName, addOn = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("before DATA_OPTIONS",
function(self, event, ...)
  local RPTAGS = RPTAGS;

  local loc = RPTAGS.utils.locale.loc;
  local Get = RPTAGS.utils.config.get;
  local addOptions        = RPTAGS.utils.modules.addOptions;
  local source_order      = RPTAGS.utils.options.source_order;

  local Checkbox          = RPTAGS.utils.options.checkbox
  local Color_Picker      = RPTAGS.utils.options.color_picker
  local Common            = RPTAGS.utils.options.common
  local Dropdown          = RPTAGS.utils.options.dropdown
  local Header            = RPTAGS.utils.options.header
  local Instruct          = RPTAGS.utils.options.instruct
  local Pushbutton        = RPTAGS.utils.options.pushbutton
  local Reset             = RPTAGS.utils.options.reset
  local Frame_Scaler      = RPTAGS.utils.options.frame_scaler
  local Dimensions_Slider = RPTAGS.utils.options.dimensions_slider;
  local TagPanel          = RPTAGS.utils.options.tagpanel;
  local requiresRPUF      = RPTAGS.utils.options.requiresRPUF;


  addOptions("color",
  { type                    = "group",
    childGroups             = "inline",
    name                    = loc("OPT_COLORS_RPUF"),
    order                   = source_order(),
    args                    =
    { headerRPUF            = Header("colors rpuf", nil, requiresRPUF ),
      colorRPUF             = Color_Picker("rpuf", nil, requiresRPUF ),
      colorRPUFText         = Color_Picker("rpuf text", nil, requiresRPUF ),
      colorRPUFTooltip      = Color_Picker("rpuf tooltip", nil, requiresRPUF ),
      -- reset                 = Reset( { "color rpuf", "color rpuf text", "color rpuf tooltip" } , nil, requiresRPUF ),
    },
  });

  addOptions("module",
  { name                    = loc("OPT_RPUF_MAIN"),
    order                   = 3,
    type                    = "group",
    args                    =
    { panel                 = Header("rpuf main", nil, requiresRPUF ),
      instruct              = Instruct("rpuf main", nil, requiresRPUF ),
      disableRPUF           = Checkbox("disable rpuf"),
      disableBlizzard       = Checkbox("disable blizzard",    nil, requiresRPUF),
      hideCombat            = Checkbox("rpuf hide combat",    nil, requiresRPUF),
      hidePetBattle         = Checkbox("rpuf hide petbattle", nil, requiresRPUF),
      hideVehicle           = Checkbox("rpuf hide vehicle",   nil, requiresRPUF),
      hideParty             = Checkbox("rpuf hide party",     nil, requiresRPUF),
      hideRaid              = Checkbox("rpuf hide raid",      nil, requiresRPUF),
      hideDead              = Checkbox("rpuf hide dead",      nil, requiresRPUF),
      lockFrames            = Checkbox("lock frames",         nil, requiresRPUF),
      playerFrameScale      = Frame_Scaler("player",    nil, requiresRPUF),
      targetFrameScale      = Frame_Scaler("target",    nil, requiresRPUF),
      focusFrameScale       = Frame_Scaler("focus",     nil, requiresRPUF),
      resetFrames           = Pushbutton("reset frame locations", resetFrames, nil, requiresRPUF ),
      layout                =
      { name                = loc("OPT_RPUF_LAYOUT"),
        order               = source_order(),
        type                = "group",
        args                =
        { panel             = Header("rpuf layout", nil, requiresRPUF ),
          instruct          = Instruct("rpuf layout", nil, requiresRPUF ),
          iconWidth         = Dimensions_Slider("iconwidth",     10, 75 ,  1),
          portWidth         = Dimensions_Slider("portwidth",     25, 200,  5),
          infoWidth         = Dimensions_Slider("infowidth",    100, 400, 10),
          detailHeight      = Dimensions_Slider("detailheight",  20, 250,  5),
          statusAlign       = Dropdown("status align", nil, requiresRPUF ),
          statusHeight      = Dimensions_Slider("statusheight",  15, 140,  5),
          statusTexture     = Dropdown("status texture", nil, requiresRPUF ),
          gapSize           = Dimensions_Slider("gapsize",        0,  20,  1),
          rpufBackdrop      = Dropdown("rpuf backdrop", nil, requiresRPUF ),
          rpufAlpha         = Dimensions_Slider("rpufalpha",      0,   1,  0.05),
          playerLayout      = Dropdown("playerlayout", nil, requiresRPUF ),
          targetLayout      = Dropdown("targetlayout", nil, requiresRPUF ),
          focusLayout       = Dropdown("focuslayout", nil, requiresRPUF ),
        },
      },
      tagPanels             =
      { name                = loc("OPT_RPUF_PANELS"),
        order               = source_order(),
        type                = "group",
        args                =
        { panel             = Header("rpuf panels", nil, requiresRPUF ),
          instruct          = Instruct("rpuf panels", nil, requiresRPUF ),
          namePanel         = TagPanel("namepanel",   "name tooltip"),
          infoPanel         = TagPanel("infopanel",   "info tooltip"),
          statusPanel       = TagPanel("statuspanel", "status tooltip"),
          detailPanel       = TagPanel("detailpanel", "detail tooltip"),
          portraitPanel     = TagPanel("portrait",    "portrait tooltip"),
          iconAPanel        = TagPanel("icon 1", "icon 1 tooltip"),
          iconBPanel        = TagPanel("icon 2", "icon 2 tooltip"),
          iconCPanel        = TagPanel("icon 3", "icon 3 tooltip"),
          iconDPanel        = TagPanel("icon 4", "icon 4 tooltip"),
          iconEPanel        = TagPanel("icon 5", "icon 5 tooltip"),
          iconFPanel        = TagPanel("icon 6", "icon 6 tooltip"),
        },
      },
    },
  });

  addOptions("keybindings",
  { disableRPUF             =
    { name                  = "Disable RPUF",
      order                 = source_order(),
      type                  = "keybinding",
    },
    hideInCombat            =
    { name                  = "Hide in Combat",
      order                 = source_order(),
      type                  = "keybinding",
    },
    lockFrames              =
    { name                  = "Lock Frames",
      order                 = source_order(),
      type                  = "keybinding",
    },
    tagEditor               =
    { name                  = "Tag Editor",
      order                 = source_order(),
      type                  = "keybinding",
    }
  });

  addOptions("about",
  { order                   = source_order(),
    type                    = "group",
    name                    = loc("OPT_ADDONS"),
    args                    =
    { panel                 =
      { order               = source_order(),
        type                = "description",
        dialogControl       = "LMD30_Description",
        name                = "About RPUF",
      },
    },
  });

end);
