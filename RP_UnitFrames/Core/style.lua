-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) 

local addOnName, addOn = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("MODULE_J",
function(self, event, ...)

  local RP_TagsDB          = RP_TagsDB;
  local oUF                = _G[GetAddOnMetadata(addOnName, "X-oUF")]; -- auto-added by oUF
  local CONST              = RPTAGS.CONST;
  local Utils              = RPTAGS.utils;
  local Config             = Utils.config;
  local frameUtils         = Utils.frames;
  local allFrameUtils      = Utils.frames.all;

  local getFrameLayout     = frameUtils.layout.get;
  local getLeft            = frameUtils.panels.layout.getLeft;
  local getTop             = frameUtils.panels.layout.getTop;
  local getPoint           = frameUtils.panels.layout.getPoint;
  local getHeight          = frameUtils.panels.size.getHeight;
  local getWidth           = frameUtils.panels.size.getWidth;
  local getJustifyH        = frameUtils.panels.align.getH;
  local getVis             = frameUtils.panels.layout.getVis;

  local getFrameDimensions = frameUtils.size.get;
  local fontFile           = frameUtils.font.file;
  local fontSize           = frameUtils.font.size;

  local refreshAll         = Utils.frames.all.refresh;
  local scaleFrame         = frameUtils.size.scale.set;
  local lockFrames         = frameUtils.all.move.lock;
  local toRGB              = Utils.color.hexaToNumber;
  local FRAME_NAMES        = CONST.FRAMES.NAMES;
  local openEditor         = Utils.config.openEditor;

  local panelList =
  { name      = { setting       = "NAMEPANEL",   tooltip = "NAME_TOOLTIP"                            },
    info      = { setting       = "INFOPANEL",   tooltip = "INFO_TOOLTIP"                            },
    details   = { setting       = "DETAILPANEL", tooltip = "DETAIL_TOOLTIP"                          },
    portrait  = { no_tag_string = true,          tooltip = "PORTRAIT_TOOLTIP", portrait       = true },
    icon1     = { setting       = "ICON_1",      tooltip = "ICON_1_TOOLTIP"                          },
    icon2     = { setting       = "ICON_2",      tooltip = "ICON_2_TOOLTIP"                          },
    icon3     = { setting       = "ICON_3",      tooltip = "ICON_3_TOOLTIP"                          },
    icon4     = { setting       = "ICON_4",      tooltip = "ICON_4_TOOLTIP"                          },
    icon5     = { setting       = "ICON_5",      tooltip = "ICON_5_TOOLTIP"                          },
    icon6     = { setting       = "ICON_6",      tooltip = "ICON_6_TOOLTIP"                          },
    statusbar = { setting       = "STATUSPANEL", tooltip = "STATUS_TOOLTIP", has_own_backdrop = true },
  };

  -- rpuf "style" for oUF ----------------------------------------------------------------------------------------------------------------------------------
  local function RP_UnitFrame_Constructor(self, unit)

    self.unit        = unit;
    self.layout      = getFrameLayout(unit);
    self.framewidth,
    self.frameheight = getFrameDimensions(self.layout);
    self.panels      = {};
    self.toolTips    = {};
    self.tagStrs     = {}

    self.frameName = FRAME_NAMES[unit:upper()];
    self.content = CreateFrame(self.frameName .. "Backdrop", nil, BackdropTemplateMixin and "BackdropTemplate");

    function self.CreatePanel(self, panelName, opt)
      opt = opt or {};
      local panel
      if   opt["has_own_backdrop"]
      then panel = CreateFrame("Frame", self.frameName .. panelName, self.content, 
                     BackdropTemplateMixin and "BackdropTemplate");
      else panel = CreateFrame("Frame", self.frameName .. panelName, self.content);
      end;

      panel.backdrop = self.content;
      panel.unitframe = self;
      panel.unit = unit;
      panel.name = panelName;
      panel.opt = opt; 

      local setting  = opt.setting  or panelName:upper();
      local tooltip  = opt.tooltip  or setting .. "_TOOLTIP";

      panel:SetAllPoints();

      if not opt["no_tag_string"]
      then 
        panel.text = panel:CreateFontString(self.frameName .. panel.name .. "Tag" ..  "OVERLAY", "GameFontNormal");
        panel.text:SetAllPoints();
        self:Tag(panel.text, "");
      end;

      if not opt["no_tooltip"]
      then panel:SetScript( "OnEnter", showTooltip );
           panel:SetScript( "OnLeave", hideTooltip );
           panel.tooltip = tooltip;
      end;

      if not opt["no_context_menu"]
      then panel:SetScript( "OnMouseUp", showMenu);
           panel.contextMenu = true;
      end;

      if opt["portrait"]
      then panel.portrait = CreateFrame("PlayerModel", nil, panel);
           panel.portrait:SetAllPoints();
           self.content.Portrait = Portrait;
      end;

      if not opt["no_tag_string"]
      then 
        panel.text = panel:CreateFontString(panel.name .. "Tag" ..  "OVERLAY", "GameFontNormal");
        panel.text:SetAllPoints();
        self:Tag(panel.text, "");
      end;

      if not opt["no_tooltip"]
      then panel:SetScript( "OnEnter", showTooltip );
           panel:SetScript( "OnLeave", hideTooltip );
           panel.tooltip = tooltip;
      end;

      if not opt["no_context_menu"]
      then panel:SetScript( "OnMouseUp", showMenu);
           panel.contextMenu = true;
      end;
  
      if opt["portrait"]
      then panel.portrait = CreateFrame("PlayerModel", nil, panel);
           panel.portrait:SetPoint("TOPLEFT", panel, "TOPLEFT", 1, -1);
           panel.portrait:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -1, 1);
           self.content.Portrait = Portrait;
      end;

      function panel.showContextMenu(self, event, ...)
        print("context menu for", self.name);
      end;
  
      function panel.showTooltip(self, event, ...)
        print("tooltip for", self.name, "=", self.tooltip)
      end;
  
      function panel.hideTooltip(self, event, ...)
        print("hide tooltip for", self.name);
      end;
  
      function panel.SetLayout(self, layout) self.layout = layout; end;
      function panel.GetLayout(self, layout) return self.layout end;

      function panel.Place(self, opt)
        opt = opt or self.opt or {};
        local layout   = opt.layout or self:GetLayout();
        local left     = opt.left     or getLeft(     self.name, layout);
        local top      = opt.right    or getRight(    self.name, layout);
        local height   = opt.height   or getHeight(   self.name, layout);
        local width    = opt.width    or getWidth(    self.name, layout);

        panel:ClearAllPoints();
        panel:SetPoint("TOPLEFT", self.content, "TOPLEFT", left, top);
        panel:SetSize(width, height);
      end;

      function panel.SetFont(self, opt)
        opt = opt or self.opt or {};
        local layout   = opt.layout or self:GetLayout();
        local fontSize = opt.fontSize or getFontSize( self.name, layout);
        local fontFile = opt.fontFile or getFontFile( self.name, layout);
        local justifyH = opt.justifyH or getJustifyH( self.name, layout);
        local justifyV = opt.justifyV or "TOP";

        panel.text:SetJustifyH(justifyH);
        panel.text:SetJustifyV(justifyV);
      end;

      function panel.SetTagString(self, opt)
        opt = opt or self.opt or {};
        local tagStr = opt.tagStr or Config.get(self.setting)
        self.unitframe:Tag(self.text, tagStr);
      end;
        
      function panel.SetVis(self, opt)
        opt = opt or self.opt or {};
        local layout = opt.layout or self:GetLayout();
        local vis = opt.vis or getVisible( self.name, layout );
        self:SetShown(vis);
      end;
       
      self.panels[panelName] = panel;
    end; -- create panel

    function self.CreatePanels(self)
      for panelName, opt in pairs( panelList )
      do  self:CreatePanel( panelName, opt);
      end;
    end;

    function self.GetPanel(self, panelName) return self.panels[panelName] end;
    function self.GetAllPanels(self) return self.panels end;

    function self.SetFont(self)      for _, panel in pairs(self.panels) do panel:SetFont();      end; end;
    function self.PlacePanels(self)  for _, panel in pairs(self.panels) do panel:Place();        end; end;
    function self.SetVis(self)       for _, panel in pairs(self.panels) do panel:SetVis();       end; end;
    function self.SetTagString(self) for _, panel in pairs(self.panels) do panel:SetTagString(); end; end;

    function self.SetPanelTagString(self, panelName, tagStr)
      if   self.panels[panelName] and self.panels[panelName].text
      then self:Tag(self.panels[panelName].text, tagStr)
      end;
    end;

    function self.SetLayout(self, layout)
      layout = layout or self.layout;
      self.framewidth,
      self.frameheight = getFrameDimensions(layout);
      self:PlacePanels();
      self:SetVis();
    end;

  end; -- style definition

  oUF:RegisterStyle("RP_UnitFrame", RP_UnitFrame_Constructor);

end);

