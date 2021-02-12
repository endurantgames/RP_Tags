local addOnName, ns = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("after DATA_OPTIONS",
function(self, event, ...)

  local loc               = RPTAGS.utils.locale.loc;
  local Get               = RPTAGS.utils.config.get;
  local Set               = RPTAGS.utils.config.set;
  local Default           = RPTAGS.utils.config.default;
  local addOptions        = RPTAGS.utils.modules.addOptions;
  local addOptionsPanel   = RPTAGS.utils.modules.addOptionsPanel;
  local source_order      = RPTAGS.utils.options.source_order;
  local Checkbox          = RPTAGS.utils.options.checkbox
  local Color_Picker      = RPTAGS.utils.options.color_picker
  local Common            = RPTAGS.utils.options.common
  local Dropdown          = RPTAGS.utils.options.dropdown
  local Header            = RPTAGS.utils.options.header
  local Instruct          = RPTAGS.utils.options.instruct
  local Keybind           = RPTAGS.utils.options.keybind
  local Pushbutton        = RPTAGS.utils.options.pushbutton
  local Spacer            = RPTAGS.utils.options.spacer
  local Reset             = RPTAGS.utils.options.reset
  local Frame_Scaler      = RPTAGS.utils.options.frame_scaler
  local Dim_Slider = RPTAGS.utils.options.dimensions_slider;
  local TagPanel          = RPTAGS.utils.options.tagpanel;
  local reqRPUF           = RPTAGS.utils.options.requiresRPUF;
  local collectionBrowser = RPTAGS.utils.options.collectionBrowser;
  local Font              = RPTAGS.utils.options.font;
  local split             = RPTAGS.utils.text.split;
  local listOfAllTags     = RPTAGS.utils.options.listOfAllTags;
  local ifConfig          = RPTAGS.utils.config.ifConfig;
  local Frame_Panel       = RPTAGS.utils.options.frame_panel;

  local menu = {};
  menu.backdrop  =
  { BLIZZTOOLTIP = loc("BACKDROP_BLIZZTOOLTIP" ),
    THIN_LINE    = loc("BACKDROP_ORIGINAL"     ),
    THICK_LINE   = loc("BACKDROP_THICK_LINE"   ),
    ORIGINAL     = loc("BACKDROP_THIN_LINE"    ), };
  menu.texture   =
  { BAR          = loc("BAR"                   ),
    SKILLS       = loc("SKILLS"                ),
    BLANK        = loc("BLANK"                 ),
    SHADED       = loc("SHADED"                ),
    SOLID        = loc("SOLID"                 ),
    RAID         = loc("RAID"                  ), };
  menu.align     =
  { LEFT         = loc("LEFT"                  ),
    CENTER       = loc("CENTER"                ),
    RIGHT        = loc("RIGHT"                 ), };
  menu.small     =
  { COMPACT      = loc("RPUF_COMPACT"          ),
    ABRIDGED     = loc("RPUF_ABRIDGED"         ),
    THUMBNAIL    = loc("RPUF_THUMBNAIL"        ), };
  menu.large     =
  { COMPACT      = loc("RPUF_COMPACT"          ),
    ABRIDGED     = loc("RPUF_ABRIDGED"         ),
    THUMBNAIL    = loc("RPUF_THUMBNAIL"        ),
    PAPERDOLL    = loc("RPUF_PAPERDOLL"        ),
    FULL         = loc("RPUF_FULL"             ), };

  addOptions(addOnName, "colors",
  { rpufColors =
    { type                    = "group",
      childGroups             = "inline",
      name                    = loc("OPT_COLORS_RPUF"),
      order                   = source_order(),
      args                    =
      { headerRPUF            = Header("colors rpuf", nil, reqRPUF ),
        colorRPUF             = Color_Picker("rpuf", nil, reqRPUF ),
        colorRPUFText         = Color_Picker("rpuf text", nil, reqRPUF ),
        colorRPUFTooltip      = Color_Picker("rpuf tooltip", nil, reqRPUF ),
        -- reset              = Reset( { "color rpuf", "color rpuf text", "color rpuf tooltip" } , nil, reqRPUF ),
      },
    },
  });

  addOptionsPanel("RPUF_Editor",
  { name                = loc("OPT_EDITOR"),
    order               = source_order(),
    type                = "group",
    args                = 
    { -- panel             = Header("editor", nil, reqRPUF ),
      instruct          = Instruct("editor", nil, reqRPUF ),
      useCustomFont     = Checkbox("editor custom font", nil, reqRPUF, true, true),
      customFont        = Font("config editor font", nil, function(self) print(reqRPUF()) return not reqRPUF() and not Get("EDITOR_CUSTOM_FONT") end),
      useButtonBar      = Checkbox("editor button bar", nil, reqRPUF),
      chooseButtons     = Pushbutton("editor buttons", nil, nil, 
                           function(self) return not Get("DISABLE_RPUF") and not Get("EDITOR_BUTTON_BAR") end, 
                            function(self)
                              Set("EDITOR_BUTTONS",
                                collectionBrowser(
                                  { current  = split(Get("EDITOR_BUTTONS"), "|"),
                                    all      = listOfAllTags(),
                                    defaults = split(Default("EDITOR_BUTTONS"), "|"), 
                                    nameFunc = function(str) return loc("TAG_" .. str .. "_NAME") end,
                                    descFunc = function(str) return loc("TAG_" .. str .. "_DESC") end,
                                  } -- params to collectionBrowser
                                )   -- collectionBrowser function call
                              ) -- Set function call
                            end -- "on pushed" function
                          ), -- Pushbutton function call
    }, -- tagEditor.args
  });-- beep

  addOptionsPanel("RPUF_Panels",
  { name                = loc("OPT_RPUF_PANELS"),
    order               = source_order(),
    type                = "group",
    args                =
    { -- panel             = Header("rpuf panels", nil, reqRPUF ),
      instruct          = Instruct("rpuf panels", nil, reqRPUF ),
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
  }); 

  addOptionsPanel("RPUF_Frames",
  { name                = loc("PANEL_RPUF_FRAMES"),
    order               = source_order(),
    type                = "group",
    childGroups         = "tab",
    args                =
    { -- panel          = Header("rpuf layout", nil, reqRPUF ),
      instruct          = Instruct("rpuf layout", nil, reqRPUF ),
      shared            =
      { name            = "Shared Settings",
        order           = source_order(),
        type            = "group",
        args            =
        {
          player        = Checkbox("LINK_FRAME_PLAYER", nil, 
                            function() return Get("SHOW_FRAME_PLAYER")       and reqRPUF() end),
          target        = Checkbox("LINK_FRAME_TARGET", nil, 
                            function() return Get("SHOW_FRAME_TARGET")       and reqRPUF() end),
          focus         = Checkbox("LINK_FRAME_FOCUS", nil, 
                            function() return Get("SHOW_FRAME_FOCUS")        and reqRPUF() end),
          targetTarget  = Checkbox("LINK_FRAME_TARGETTARGET", nil, 
                            function() return Get("SHOW_FRAME_TARGETTARGET") and reqRPUF() end),
          look          =  
          { type        = "group",
            inline      = true,
            name        = "Frame Appearance",
            order       = source_order(),
            args        =
            { backdrop  = Dropdown("RPUF_BACKDROP", nil, reqRPUF, menu.backdrop),
              spb       = Spacer(),
              iconWidth = Dim_Slider("ICONWIDTH", 10, 75 ,  1),
              spi       = Spacer(),
              alpha     = Dim_Slider("RPUFALPHA", 0, 1, 0.05),
              spa       = Spacer(),
            },
          },
          sizes         =
          { type        = "group",
            inline      = true,
            name        = "Panel Dimensions",
            order       = source_order(),
            args        =
            { gap       = Dim_Slider("GAPSIZE",        0,  20,  1 ), spg = Spacer(), 
              icon      = Dim_Slider("ICONWIDTH",     10,  75,  1 ), spi = Spacer(), 
              port      = Dim_Slider("PORTWIDTH",     25, 200,  5 ), spp = Spacer(), 
              info      = Dim_Slider("INFOWIDTH",    100, 400, 10 ), spn = Spacer(), 
              detail    = Dim_Slider("DETAILHEIGHT",  20, 250,  5 ), spd = Spacer(), 

            },
          },
          status        =
          { type        = "group",
            inline      = true,
            name        = "Status Bar Appearance",
            order       = source_order(),
            args        =
            { align     = Dropdown("STATUS_ALIGN",  nil, reqRPUF, menu.align),
              spa       = Spacer(),
              height    = Dim_Slider("STATUSHEIGHT", 15, 140, 5),
              sph       = Spacer(),
              texture   = Dropdown("STATUS_TEXTURE", nil, reqRPUF, menu.texture ),
              spt       = Spacer(),
            },
          },
        },
      },
      playerFrame       = Frame_Panel("player"                         ),
      targetFrame       = Frame_Panel("target"                         ),
      focusFrame        = Frame_Panel("focus",        { small = true } ),
      targetTargetFrame = Frame_Panel("targettarget", { small = true } ),
    },
  });

  addOptionsPanel("RPUF_Main",
  { name              = loc("RPUF_NAME"),
    order             = source_order(),
    childGroups       = "tab",
    type              = "group",
    args              =
    { -- panel        = Header("rpuf main", nil, reqRPUF ),
      instruct        = Instruct("rpuf main",                            nil , reqRPUF ),
      disableRPUF     = Checkbox("disable rpuf"                                             ),
      disableBlizzard = Checkbox("disable blizzard",                     nil , reqRPUF ),
      hideCombat      = Checkbox("rpuf hide combat",                     nil , reqRPUF ),
      hidePetBattle   = Checkbox("rpuf hide petbattle",                  nil , reqRPUF ),
      hideVehicle     = Checkbox("rpuf hide vehicle",                    nil , reqRPUF ),
      hideParty       = Checkbox("rpuf hide party",                      nil , reqRPUF ),
      hideRaid        = Checkbox("rpuf hide raid",                       nil , reqRPUF ),
      hideDead        = Checkbox("rpuf hide dead",                       nil , reqRPUF ),
      lockFrames      = Checkbox("lock frames",                          nil , reqRPUF ),
      resetFrames     = Pushbutton("reset frame locations", resetFrames, nil , reqRPUF ),
    },
  });

  addOptions(addOnName, "keybind",
  { disableRPUF  = Keybind("disable rpuf"),
    hideInCombat = Keybind("hide in combat"),
    lockFrames   = Keybind("lock frames"),
    tagEditor    = Keybind("tag editor"),
  });
  
end);
