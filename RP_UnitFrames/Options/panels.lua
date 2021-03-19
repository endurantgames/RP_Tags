local addOnName, ns = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("MODULE_G",
function(self, event, ...)
  local Utils           = RPTAGS.utils;
  local loc             = Utils.locale.loc;
  local Config          = Utils.config;
  local Get             = Utils.config.get;
  local Set             = Utils.config.set;
  local addOptionsPanel = Utils.modules.addOptionsPanel;
  local source_order    = Utils.options.source_order;
  local Instruct        = Utils.options.instruct
  local Pushbutton      = Utils.options.pushbutton
  local Spacer          = Utils.options.spacer
  local Reset           = Utils.options.reset
  local reqRPUF         = Utils.options.requiresRPUF;
  local split           = Utils.text.split;
  local LibSharedMedia  = LibStub("LibSharedMedia-3.0");
  local RPUF_Refresh    = Utils.frames.RPUF_Refresh;
  local panelInfo       = RPTAGS.CONST.RPUF.PANEL_INFO;
  local evalTagString   = Utils.tags.eval;
  local openEditor      = Config.openEditor;

  local menu = 
  { fontSize =
    { extrasmall = loc("SIZE_EXTRA_SMALL"),
      small = loc("SIZE_SMALL"),
      medium = loc("SIZE_MEDIUM"),
      large = loc("SIZE_LARGE"),
      extralarge = loc("SIZE_EXTRA_LARGE"),
    },
    fontSizeOrder = { "extrasmall", "small", "medium", "large", "extralarge" },
    portraitStyle =
    { STANDARD = "Standard 3D portrait",
      FROZEN = "Non-animated 2D portrait",
    },
  };

  local function build_tagpanel(opt)

    opt.setting = opt.setting or opt.tooltip;
    local w    = 
    { type = "group",
      name  = loc("CONFIG_" .. opt.setting ),
      order = source_order(),
      args = {},
    };

    w.args.header =
    { type = "header",
      width = "full",
      name = "# " .. loc("CONFIG_" .. (opt["no_text"] and opt.setting  or opt.tooltip) ),
      dialogControl = "LMD30_Description",
      order = source_order(),
    };

    if not opt["no_text"]
    then 
         w.args.instruct = 
         { type = "description",
           width = "full",
           name = loc("CONFIG_" .. opt.setting .. "_TT"),
           order = source_order(),
         };

         w.args.current = 
         { type = "input",
           width = 1,
           name = loc("CONFIG_" .. opt.setting),
           get = function(self) return Get(opt.setting) end,
           set = function(self, value) Set(opt.setting, value) RPUF_Refresh("all", "tags", "content" ) end;
           order = source_order(),
         };

         w.args.currentSpacer = Spacer();

         w.args.editPanel = 
         { type = "execute",
           name = "Open in Tag Editor",
           order = source_order(),
           width = 1,
           func = function() InterfaceOptionsFrame:Hide() openEditor(opt.setting) end
         };

         w.args.tagPreview = 
         { type = "group",
           order = source_order(),
           name = "Live Preview",
           inline = true,
           args = 
           { preview = 
             { type = "description",
               order = source_order(),
               name = function() return evalTagString(Get(opt.setting), "player", "player") end,
               fontSize = function() return opt.setting:match("ICON") and "large" or "medium" end,
             },
           },
         };
    end;
    if   not opt["no_tooltip"]
    then w.args.instruct_tt = 
         { type = "description",
           width = "full",
           name = loc("CONFIG_" .. opt.tooltip .. "_TT"),
           order = source_order(),
         };

         w.args.currentTooltip = 
         { type = "input",
           width = 1,
           name = loc("CONFIG_" .. opt.tooltip),
           get = function(self) return Get(opt.tooltip) end,
           set = function(self, value) Set(opt.tooltip, value) end,
           order = source_order(),
         };

         w.args.currentTooltipSpacer = Spacer();

         w.args.editTooltip = 
         { type = "execute",
           name = "Open in Tag Editor",
           order = source_order(),
           width = 1,
           func = function() InterfaceOptionsFrame:Hide() openEditor(opt.tooltip) end
         };

         w.args.tooltipPreview = 
         { type = "group",
           order = source_order(),
           name = "Live Preview",
           inline = true,
           args = 
           { preview = 
             { type = "description",
               order = source_order(),
               name = function(self) return evalTagString(Get(opt.tooltip), "player", "player") end,
               fontSize = "medium",
             },
           },
         };
    end;

    return w;
  end;

  local rpufPanels = 
  { name                = loc("OPT_RPUF_PANELS"),
    order               = source_order(),
    type                = "group",
    hidden              = function() return Get("DISABLE_RPUF") end,
    args                =
    { instruct          = Instruct("rpuf panels", nil, reqRPUF ),
    }
  };

  for _, panel in pairs({ "name", "info", "statusBar", "details", "portrait", 
                          "icon1", "icon2", "icon3", "icon4", "icon5", "icon6" } )
  do  rpufPanels.args[ panel .. "Panel" ] = build_tagpanel(panelInfo[panel])
  end;

  addOptionsPanel("RPUF_Panels", rpufPanels);
  
end);
