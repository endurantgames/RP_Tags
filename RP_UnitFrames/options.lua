local RPTAGS = RPTAGS;

RPTAGS.queue:WaitUntil("LOAD_OPTIONS",
function(self, event, ...)
  local RPTAGS = RPTAGS;
  RPTAGS.utils = RPTAGS.utils or {};
  RPTAGS.utils.config = RPTAGS.utils.config or {};

  local Config = RPTAGS.utils.config;
  local function requiresRPUF() return Config.get("DISABLE_RPUF"); end;
  
  local build_common            = RPTAGS.utils.options.build_common
  local build_checkbox          = RPTAGS.utils.options.build_checkbox
  local build_textbox           = RPTAGS.utils.options.build_textbox
  local build_dropdown          = RPTAGS.utils.options.build_dropdown
  local build_color_picker      = RPTAGS.utils.options.build_color_picker
  local build_frame_scaler      = RPTAGS.utils.options.build_frame_scaler
  local build_dimensions_slider = RPTAGS.utils.options.build_dimensions_slider
  local build_pushbutton        = RPTAGS.utils.options.build_pushbutton
  local build_tagpanel          = RPTAGS.utils.options.build_tagpanel
  local build_reset             = RPTAGS.utils.options.build_reset
  local build_header            = RPTAGS.utils.options.build_header
  local build_instruct          = RPTAGS.utils.options.build_instruct
  local source_order            = RPTAGS.utils.options.source_order
   
  local function build_rpuf_toggle() 
    local w = build_common("toggle", "config_", "disable rpuf", nil, nil, true, 
                function(info, value) 
                  local self = RPTAGS.modules:Get("rpuf");
                  self:SetEnabled(value);
                  return Config.set("DISABLE_RPUF", value) 
                end); 
    return w; 
  end;
  
  self.RegisterOptions("color",
  { hidden           = requiresRPUF,
    type             = "group",
    childGroups = "inline",
    name             = loc("OPT_COLORS_RPUF"),
    order            = source_order(),
    args             = 
    { headerRPUF       = build_header("colors rpuf"),
      colorRPUF        = build_color_picker("rpuf"),
      colorRPUFText    = build_color_picker("rpuf text"),
      colorRPUFTooltip = build_color_picker("rpuf tooltip"),
      reset            = build_reset( { "color rpuf", "color rpuf text", "color rpuf tooltip" } ),
    }, 
  });
  
  self.RegisterOptions("module",
  { name = loc("OPT_RPUF_MAIN"),
    order = 3,
    type = "group",
    args = 
    { panel = build_header("rpuf main"),
      instruct = build_instruct("rpuf main"),
      disableRPUF      = build_rpuf_toggle(),
      disableBlizzard  = build_checkbox("disable blizzard",    requiresRPUF),
      hideCombat       = build_checkbox("rpuf hide combat",    requiresRPUF),
      hidePetBattle    = build_checkbox("rpuf hide petbattle", requiresRPUF),
      hideVehicle      = build_checkbox("rpuf hide vehicle",   requiresRPUF),
      hideParty        = build_checkbox("rpuf hide party",     requiresRPUF),
      hideRaid         = build_checkbox("rpuf hide raid",      requiresRPUF),
      hideDead         = build_checkbox("rpuf hide dead",      requiresRPUF),
      lockFrames       = build_checkbox("lock frames",         requiresRPUF),
      playerFrameScale = build_frame_scaler("player",          requiresRPUF),
      targetFrameScale = build_frame_scaler("target",          requiresRPUF),
      focusFrameScale  = build_frame_scaler("focus",           requiresRPUF), 
      resetFrames      = build_pushbutton("reset frame locations", 
                           function() 
                             RPTAGS.utils.rpuf.allFrames.resetloc(); 
                             notify("FRAME_LOCATIONS_ARE_RESET"); 
                             end,  
                           requiresRPUF ),
      layout =  
      { name = loc("OPT_RPUF_LAYOUT"),
        order = source_order(),
        type = "group",
        hidden = requiresRPUF,
        args = 
        { panel = build_header("rpuf layout"),
          instruct = build_instruct("rpuf layout"),
          iconWidth     = build_dimensions_slider("iconwidth",     10, 75 ,  1),
          portWidth     = build_dimensions_slider("portwidth",     25, 200,  5),
          infoWidth     = build_dimensions_slider("infowidth",    100, 400, 10),
          detailHeight  = build_dimensions_slider("detailheight",  20, 250,  5),
          statusAlign   = build_dropdown("status align"),
          statusHeight  = build_dimensions_slider("statusheight",  15, 140,  5),
          statusTexture = build_dropdown("status texture"),
          gapSize       = build_dimensions_slider("gapsize",        0,  20,  1),
          rpufBackdrop  = build_dropdown("rpuf backdrop"),
          rpufAlpha     = build_dimensions_slider("rpufalpha",      0,   1,  0.05),
          playerLayout  = build_dropdown("playerlayout"),
          targetLayout  = build_dropdown("targetlayout"),
          focusLayout   = build_dropdown("focuslayout"), 
        }, 
      }, 
      tagPanels = 
      { name = loc("OPT_RPUF_PANELS"),
        order = source_order(),
        type = "group",
        hidden = requiresRPUF,
        args = 
        { panel = build_header("rpuf panels"),
          instruct      = build_instruct("rpuf panels"),
    
          namePanel     = build_tagpanel("namepanel",   "name tooltip"),
          infoPanel     = build_tagpanel("infopanel",   "info tooltip"),
          statusPanel   = build_tagpanel("statuspanel", "status tooltip"),
          detailPanel   = build_tagpanel("detailpanel", "detail tooltip"),
          portraitPanel = build_tagpanel("portrait",    "portrait tooltip"), 
          iconAPanel      = build_tagpanel("icon 1", "icon 1 tooltip"),
          iconBPanel      = build_tagpanel("icon 2", "icon 2 tooltip"),
          iconCPanel      = build_tagpanel("icon 3", "icon 3 tooltip"),
          iconDPanel      = build_tagpanel("icon 4", "icon 4 tooltip"),
          iconEPanel      = build_tagpanel("icon 5", "icon 5 tooltip"),
          iconFPanel      = build_tagpanel("icon 6", "icon 6 tooltip"), 
        },  
      }, 
    }, 
  });
  
  self:RegisterOptions("keybindings",
  { disableRPUF =
    { name = "Disable RPUF",
      order = source_order(),
      type = "keybinding",
    },
    hideInCombat = 
    { name = "Hide in Combat",
      order = source_order(),
      type = "keybinding",
    },
    lockFrames = 
    { name = "Lock Frames",
      order = source_order(),
      type = "keybinding",
    },
    tagEditor =
    { name = "Tag Editor",
      order = source_order(),
      type = "keybinding",
    }
  });
  
  self:RegisterOptions("about",
  { order             = source_order(),
    type              = "group",
    name              = loc("OPT_ADDONS"),
    args              =
    { panel           =
      { order         = source_order(),
        type          = "description",
        dialogControl = AMDC.description,
        name = RPTAGS.utils.text.addons,
      },
    },
  });
end);
