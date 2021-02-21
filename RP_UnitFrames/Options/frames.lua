local addOnName, ns = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("MODULE_G",
function(self, event, ...)

  local Utils           = RPTAGS.utils;
  local Config          = Utils.config;
  local optUtils        = Utils.options;
  local loc             = RPTAGS.utils.locale.loc;
  local Get             = Config.get;
  local Set             = Config.set;
  local Default         = Config.default;
  local addOptions      = Utils.modules.addOptions;
  local addOptionsPanel = Utils.modules.addOptionsPanel;
  local split           = RPTAGS.utils.text.split;
  local source_order    = optUtils.source_order;
  local Checkbox        = optUtils.checkbox
  local Color_Picker    = optUtils.color_picker
  local Common          = optUtils.common
  local Dropdown        = optUtils.dropdown
  local Header          = optUtils.header
  local Instruct        = optUtils.instruct
  local Keybind         = optUtils.keybind
  local Pushbutton      = optUtils.pushbutton
  local Spacer          = optUtils.spacer
  local Reset           = optUtils.reset
  local Frame_Scaler    = optUtils.frame_scaler
  local Dim_Slider      = optUtils.dimensions_slider;
  local TagPanel        = optUtils.tagpanel;
  local reqRPUF         = optUtils.requiresRPUF;
  local Font            = optUtils.font;
  local Frame_Panel     = optUtils.frame_panel;
  local Wide            = optUtils.set_width;
  local linkHandler     = Utils.links.handler;

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

  addOptionsPanel("RPUF_Main",
  { name                = loc("RPUF_NAME"),
    order               = source_order(),
    type                = "group",
    args                =
    { 
      instruct        = Instruct("rpuf main",                            nil , reqRPUF ),
      disableRPUF     = Wide(Checkbox("disable rpuf"                                             ), 1.5),
      disableBlizzard = Wide(Checkbox("disable blizzard",                     nil , reqRPUF ), 1.5),
      shared            =
      { name            = "Shared Settings",
        order           = source_order(),
        hidden          = function() return Get("DISABLE_RPUF") end,
        type            = "group",
        args            =
        { 
          frameStatus =
          { type = "group",
            order = source_order(),
            name = "Frames Status",
            inline = true,
            args =
            { player =
              { type = "description",
                name = loc("PLAYERFRAME"),
                width = 1,
                fontSize = "medium",
                order = source_order(),
              },
              playerSpacer = Spacer(),
              playerShow =
              { type = "toggle",
                name = "Enabled",
                get = function() return Get("SHOW_FRAME_PLAYER") end,
                width = 0.5,
                set = function(self, value) Set("SHOW_FRAME_PLAYER", value) end,
                disabled = function() Get("DISABLE_RPUF") end,
                order = source_order(),
              },
              playerLinked  = 
              { type = "toggle",
                name = "Linked",
                get = function() return Get("LINK_FRAME_PLAYER") end,
                width = 0.5,
                set = function(self, value) Set("LINK_FRAME_PLAYER", value) end,
                disabled = function() return Get("DISABLE_RPUF") or not Get("SHOW_FRAME_PLAYER") end,
                order = source_order(),
              },
              target =
              { type = "description",
                width = 1,
                fontSize = "medium",
                name = loc("TARGETFRAME"),
                order = source_order(),
              },
              targetSpacer = Spacer(),
              targetShow =
              { type = "toggle",
                name = "Enabled",
                get = function() return Get("SHOW_FRAME_TARGET") end,
                width = 0.5,
                set = function(self, value) Set("SHOW_FRAME_TARGET", value) end,
                disabled = function() Get("DISABLE_RPUF") end,
                order = source_order(),
              },
              targetLinked  = 
              { type = "toggle",
                name = "Linked",
                get = function() return Get("LINK_FRAME_TARGET") end,
                width = 0.5,
                set = function(self, value) Set("LINK_FRAME_TARGET", value) end,
                disabled = function() return Get("DISABLE_RPUF") or not Get("SHOW_FRAME_TARGET") end,
                order = source_order(),
              },
              focus =
              { type = "description",
                name = loc("FOCUSFRAME"),
                width = 1,
                fontSize = "medium",
                order = source_order(),
              },
              focusSpacer = Spacer(),
              focusShow =
              { type = "toggle",
                name = "Enabled",
                get = function() return Get("SHOW_FRAME_FOCUS") end,
                set = function(self, value) Set("SHOW_FRAME_FOCUS", value) end,
                width = 0.5,
                disabled = function() Get("DISABLE_RPUF") end,
                order = source_order(),
              },
              focusLinked   = 
              { type = "toggle",
                name = "Linked",
                get = function() return Get("LINK_FRAME_FOCUS") end,
                width = 0.5,
                set = function(self, value) Set("LINK_FRAME_FOCUS", value) end,
                disabled = function() return Get("DISABLE_RPUF") or not Get("SHOW_FRAME_FOCUS") end,
                order = source_order(),
              },
              targetTarget = 
              { type = "description",
                name = loc("TARGETTARGETFRAME"),
                width = 1,
                fontSize = "medium",
                order = source_order(),
              },
              targetTargetSpacer = Spacer(),
              targetTargetShow =
              { type = "toggle",
                name = "Enabled",
                get = function() return Get("SHOW_FRAME_TARGETTARGET") end,
                set = function(self, value) Set("SHOW_FRAME_TARGETTARGET", value) end,
                disabled = function() Get("DISABLE_RPUF") end,
                width = 0.5,
                order = source_order(),
              },
              targetTargetLinked        = 
              { type = "toggle",
                name = "Linked",
                get = function() return Get("LINK_FRAME_TARGETTARGET") end,
                set = function(self, value) Set("LINK_FRAME_TARGETTARGET", value) end,
                disabled = function() return Get("DISABLE_RPUF") or not Get("SHOW_FRAME_TARGETTARGET") end,
                order = source_order(),
                width = 0.5,
              }, 
            },
          },
          visibility    =
          { type        = "group",
            inline = true,
            name = "Visibility",
            order = source_order(),
            args =
            { 
              hideCombat      = Wide(Checkbox("rpuf hide combat",                     nil , reqRPUF ), 1),
              hidePetBattle   = Wide(Checkbox("rpuf hide petbattle",                  nil , reqRPUF ), 1),
              hideVehicle     = Wide(Checkbox("rpuf hide vehicle",                    nil , reqRPUF ), 1),
              hideParty       = Wide(Checkbox("rpuf hide party",                      nil , reqRPUF ), 1),
              hideRaid        = Wide(Checkbox("rpuf hide raid",                       nil , reqRPUF ), 1),
              hideDead        = Wide(Checkbox("rpuf hide dead",                       nil , reqRPUF ), 1),
              mouseover       = Wide(Checkbox("mouseover cursor"), "full"),
            },
          },
          look          =  
          { type        = "group",
            -- inline      = true,
            name        = "Frame Appearance",
            order       = source_order(),
            args        =
            { backdrop  = Dropdown("RPUF_BACKDROP", nil, reqRPUF, menu.backdrop),
              spb       = Spacer(),
              iconWidth = Dim_Slider("ICONWIDTH", 10, 75 ,  1),
              spi       = Spacer(),
              alpha     = Dim_Slider("RPUFALPHA", 0, 1, 0.05),
              spa       = Spacer(),
              colors    = 
              { type = "execute",
                name = "Colors",
                func = function() linkHandler("opt://colors/rpuf") end,
                order = source_order(),
              },
              statusBar        =
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
          sizes         =
          { type        = "group",
            -- inline      = true,
            name        = "Panel Dimensions",
            order       = source_order(),
            args        =
            { instruct  = Instruct("rpuf layout", nil, reqRPUF ),
              gap       = Dim_Slider("GAPSIZE",        0,  20,  1 ), spg = Spacer(), 
              icon      = Dim_Slider("ICONWIDTH",     10,  75,  1 ), spi = Spacer(), 
              port      = Dim_Slider("PORTWIDTH",     25, 200,  5 ), spp = Spacer(), 
              info      = Dim_Slider("INFOWIDTH",    100, 400, 10 ), spn = Spacer(), 
              detail    = Dim_Slider("DETAILHEIGHT",  20, 250,  5 ), spd = Spacer(), 

            },
          },
          position =
          { type = "group",
            inline = true,
            name = "Positioning",
            order = source_order(),
            args = 
            {
              lockFrames      = Checkbox("lock frames",                          nil , reqRPUF ),
              resetFrames     = Pushbutton("reset frame locations", resetFrames, nil , reqRPUF ),
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

end);
