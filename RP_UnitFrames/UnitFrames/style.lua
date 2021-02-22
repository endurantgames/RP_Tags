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

  local oUF                = _G[GetAddOnMetadata(addOnName, "X-oUF")]; -- auto-added by oUF
  local CONST              = RPTAGS.CONST;
  local Utils              = RPTAGS.utils;
  local Config             = Utils.config;
  local frameUtils         = Utils.frames;
  local allFrameUtils      = Utils.frames.all;
  local FRAME_NAMES        = CONST.FRAMES.NAMES;
  local eval               = Utils.tags.eval;
  local split              = Utils.text.split;
  local oUF_style          = CONST.RPUF.OUF_STYLE;

  local getLeft            = frameUtils.panels.layout.getLeft;
  local getTop             = frameUtils.panels.layout.getTop;
  local getPoint           = frameUtils.panels.layout.getPoint;
  local getHeight          = frameUtils.panels.size.getHeight;
  local getWidth           = frameUtils.panels.size.getWidth;
  local LibSharedMedia     = LibStub("LibSharedMedia-3.0");

  local getFrameDimensions = frameUtils.size.get;
  local fontFile           = frameUtils.font.getFile;
  local fontSize           = frameUtils.font.getSize;

  local scaleFrame         = frameUtils.size.scale.set;
  local toRGB              = Utils.color.hexaToNumber;
  local openEditor         = Utils.config.openEditor;

  local panelList =
  { name      = { setting          = "NAMEPANEL",   tooltip = "NAME_TOOLTIP"      },
    info      = { setting          = "INFOPANEL",   tooltip = "INFO_TOOLTIP"      },
    details   = { setting          = "DETAILPANEL", tooltip = "DETAIL_TOOLTIP"    },
    icon1     = { setting          = "ICON_1",      tooltip = "ICON_1_TOOLTIP"    },
    icon2     = { setting          = "ICON_2",      tooltip = "ICON_2_TOOLTIP"    },
    icon3     = { setting          = "ICON_3",      tooltip = "ICON_3_TOOLTIP"    },
    icon4     = { setting          = "ICON_4",      tooltip = "ICON_4_TOOLTIP"    },
    icon5     = { setting          = "ICON_5",      tooltip = "ICON_5_TOOLTIP"    },
    icon6     = { setting          = "ICON_6",      tooltip = "ICON_6_TOOLTIP"    },
    portrait  = { no_tag_string    = true,          tooltip = "PORTRAIT_TOOLTIP",
                  portrait         = true                                         },
    statusBar = { setting          = "STATUSPANEL", tooltip = "STATUS_TOOLTIP",
                  has_own_backdrop = true,
                  has_own_align    = true,                                        },
  };


  -- rpuf "style" for oUF ----------------------------------------------------------------------------------------------------------------------------------
  local function RP_UnitFrame_Constructor(self, unit)

    self.unit     = unit;
    self.panels   = {};
    self.toolTips = {};
    self.tagStrs  = {}

    self.frameName = FRAME_NAMES[unit:upper()];

    self.backdrop = self:CreateTexture(nil, "BACKGROUND");
    self.backdrop:SetAllPoints();
    self.backdrop:SetColorTexture(0, 0, 0, 0.75);

    function self.ConfGet(self, setting)
      if    Config.get("LINK_FRAME_" .. self.unit:upper())
      then return Config.get(setting)
      else return Config.get(setting .. "_" .. self.unit:upper())
      end;
    end;

    function self.ConfSet(self, setting, value)
      if   Config.get("LINK_FRAME_" .. self.unit:upper())
      then Config.set(setting, value);
      else Config.set(setting .. "_" .. self.unit:upper(), value);
      end;
    end;

    function self.GetName(self)             return self.frameName                              end;
    function self.GetUnit(self)             return self.unit;                                  end;
    function self.GetLayout(self)           return Config.get( self.unit:upper() .. "LAYOUT"); end;
    function self.GetPanel(self, panelName) return self.panels[panelName]                      end;
    function self.GetPanels(self)           return self.panels                                 end;

    function self.SetDimensions(self) 
      local frameWidth, frameHeight = getFrameDimensions(self:GetLayout());
      self:SetWidth(frameWidth);
      self:SetHeight(frameHeight);
    end;
    
    function self.CreatePanel(self, panelName, opt)
      opt = opt or {};
      local panel

      panel = CreateFrame("Frame", self.frameName .. panelName, self);
      panel:SetPoint("TOPLEFT");

      if   opt["has_own_backdrop"]
      then panel.backdrop = panel:CreateTexture(nil, "BACKGROUND");
           panel.backdrop:SetColorTexture(1, 1, 1, 0.5);
           panel.backdrop:SetAllPoints();
           function panel.SetBackdrop(self, textureFile) self.backdrop:SetTexture(textureFile) end;
           function panel.SetVertexColor(self, ...) self.backdrop:SetVertexColor(...) end;
      end;

      panel.unitframe = self;
      panel.unit      = unit;
      panel.name      = panelName;

      local setting = opt.setting or panelName:upper();
      local tooltip = opt.tooltip or setting .. "_TOOLTIP";


      if not opt["no_tag_string"]
      then 
        panel.text = panel:CreateFontString(self.frameName .. panel.name .. "Tag", 
          "OVERLAY", "GameFontNormal");
        panel.setting = setting;
        panel.text:SetAllPoints();
        panel.text:SetText(panel.name);
      end;

      if opt["portrait"]
      then panel.portrait = CreateFrame("PlayerModel", nil, panel);
           panel.portrait:SetAllPoints();
           self.Portrait = Portrait;
      end;
 
      function panel.showTooltip(self, event, ...) 
        local tooltip = eval(Config.get(self.tooltip), self:GetUnit(), self:GetUnit());
        local r, g, b = self.unitframe:GetTooltipColor();
    
        if   self:ConfGet("MOUSEOVER_CURSOR")
        then SetCursor("Interface\\CURSOR\\Inspect.PNG");
        end;
    
        if tooltip and tooltip:len() > 0
        then 
             GameTooltip:ClearLines();
             GameTooltip:SetOwner(self, "ANCHOR_CURSOR");
             GameTooltip:SetOwner(self, "ANCHOR_PRESERVE");
             local lines = split(tooltip, "\n");
             for i, line in ipairs(lines)
             do GameTooltip:AddLine(line, r, g, b, true)
             end;
             GameTooltip:Show();
        end;
      end; 

      function hideTooltip(self, ...) GameTooltip:FadeOut(); ResetCursor(); return self, ... end;

      if not opt["no_tooltip"]
      then panel:SetScript("OnEnter", showTooltip );
           panel:SetScript("OnLeave", hideTooltip );
           panel.tooltip = tooltip;
      end;
       
      function showContextMenu(self, event, ...) print("context menu for", self.name); end;
  
      if   not opt["no_context_menu"]
      then panel.showContextMenu = showContextMenu;
           self:SetScript("OnMouseUp",
             function(self, button) if button == "RightButton" then self:showContextMenu() end; end);
      end;

      panel:RegisterForDrag("LeftButton");
      panel:HookScript("OnDragStart", 
        function(self, ...) 
          if not self.unitframe:IsLocked()
          then self.unitframe:StartMoving()        
          end;
          return self, ...  
        end);

      panel:HookScript("OnDragStop",  
        function(self, ...) 
          self.unitframe:StopMovingOrSizing();
          self.unitframe:SaveCoords();
          return self, ...  end
        );

      function panel.GetUnit(self,   ...) return self.unitframe:GetUnit(   ...) end;
      function panel.GetLayout(self, ...) return self.unitframe:GetLayout( ...) end;
      function panel.ConfGet(self,   ...) return self.unitframe:ConfGet(   ...) end;
      function panel.ConfSet(self,   ...) return self.unitframe:ConfSet(   ...) end;
  
      function panel.Place(self)
        local layout   = self:GetLayout();
        local left     = getLeft(   self.name, layout);
        local top      = getTop(    self.name, layout);
        local height   = getHeight( self.name, layout);
        local width    = getWidth(  self.name, layout);

        if top and left
        then self:ClearAllPoints();
             self:SetPoint("TOPLEFT", self.unitframe, "TOPLEFT", left, top);
             self:SetSize(width, height);
        end;
      end;

      function panel.GetJustify(self)
        if      self.name == "statusBar" 
        then   return self:ConfGet("STATUS_ALIGN"), "CENTER";
        elseif (self.name == "name" or self.name == "info") and
               (self:GetLayout() == "PAPERDOLL" or
                self:GetLayout() == "THUMBNAIL")
        then   return "CENTER", "CENTER";
        else   return "LEFT", "TOP";
        end;
      end;

      function panel.SetJustify(self)
        if   self.text 
        then local justifyH, justifyV = self:GetJustify();
             self:SetJustifyH(justifyH);
             self:SetJustifyV(justifyV);
        end;
      end;

      function panel.SetJustifyH(self, justifyH) 
         if self.text then self.text:SetJustifyH(justifyH); end; end;
      function panel.SetJustifyV(self, justifyV) 
         if self.text then self.text:SetJustifyV(justifyV); end; end;

      function panel.SetTextColor(self, r, g, b) 
         if self.text then self.text:SetTextColor(r, g, b); end; end;

      function panel.SetTagString(self) 
        if self.text then self.unitframe:Tag(self.text, Config.get(self.setting)); end; end;

      function panel.GetVis(self)
        
        local hash =
        { COMPACT   = { name  = true, icon1 = true, info      = true                   },
          THUMBNAIL = { name  = true, icon1 = true, portrait  = true                   },
          PAPERDOLL = { name  = true, info  = true, portrait  = true,
                        icon1 = true, icon2 = true, icon3     = true,
                        icon4 = true, icon5 = true, icon6     = true                   },
          ABRIDGED  = { name  = true, info  = true, statusBar = true, portrait = true,
                        icon1 = true, icon2 = true, icon3     = true,
                        icon4 = true, icon5 = true, icon6     = true                   },
          FULL      = { name  = true, info  = true, statusBar = true, details  = true,
                        icon1 = true, icon2 = true, icon3     = true, portrait = true,
                        icon4 = true, icon5 = true, icon6     = true                   },
        };

        return hash[self:GetLayout()][self.name]
      end;
    
      function panel.SetVis(self) self:SetShown( self:GetVis() ); end;

      function panel.SetFont(self, fontFile, fontSize) 
        if   self.text
        then local hash =
             { ["extrasmall" ] = -4,
               ["small"      ] = -2,
               ["medium"     ] =  0,
               ["large"      ] =  2,
               ["extralarge" ] =  4, };

             local relativeSize = hash[Config.get( self.setting .. "_FONTSIZE")];
             self.text:SetFont(fontFile, fontSize + relativeSize);  
        end; 
      end;
      self.panels[panelName] = panel;

    end; -- create panel

    function self.CreatePanels(self)  
      for panelName, opt in pairs( panelList )      
      do  self:CreatePanel( panelName, opt); 
      end; 
    end;
      
    function self.PlacePanels(self)   for _, panel in pairs(self:GetPanels()) do panel:Place();        end end;
    function self.SetPanelVis(self)   for _, panel in pairs(self:GetPanels()) do panel:SetVis();       end end;
    function self.SetTagStrings(self) for _, panel in pairs(self:GetPanels()) do panel:SetTagString(); end end;

    function self.SetTextColor(self) 
      local r, g, b = toRGB(self:ConfGet("COLOR_RPUF_TEXT"))
      for _, panel in pairs(self:GetPanels()) 
      do  panel:SetTextColor(r / 255, g / 255, b / 255) 
      end;
    end;

    function self.SetFont(self)
      local layout   = self:GetLayout();
      local fontSize = self:ConfGet("FONTSIZE");
      local fontName = self:ConfGet("FONTNAME");
      local fontFile = LibSharedMedia:Fetch("font", fontName) or LibSharedMedia:Fetch("font", "Arial Narrow");
      for _, panel in pairs(self:GetPanels()) 
      do  panel:SetJustify(); 
          panel:SetFont(fontFile, fontSize) 
      end;
      self:GetPanel("name"):SetFont( LibSharedMedia:Fetch("font", Config.get("NAMEPANEL_FONTNAME")), fontSize);
    end;

    function self.GetTooltipColor(self)
      local r, g, b = toRGB(self:ConfGet("COLOR_RPUF_TOOLTIP"))
      return r / 255, g / 255, b / 255;
    end;

    function self.GenerateVisibilityString(self)
      local conditions = {};
      if self:ConfGet("DISABLE_RPUF") then return "hide" end;
      local hash =
      { ["RPUF_HIDE_DEAD"]      = "[dead] hide",
        ["RPUF_HIDE_PETBATTLE"] = "[petbattle] hide",
        ["RPUF_HIDE_VEHICLE"]   = "[vehicleui] hide",
        ["RPUF_HIDE_PARTY"]     = "[group:party] hide",
        ["RPUF_HIDE_RAID"]      = "[group:raid] hide",
        ["RPUF_HIDE_COMBAT"]    = "[combat] hide",
      };
      for k, v in pairs(hash) do if self:ConfGet(k) then table.insert(conditions, v) end; end;

      table.insert(conditions, "[@" .. self.unit .. ",exists] show");
      table.insert(conditions, "hide");
      return table.concat(conditions, ";")
    end;

    function self.SetVisibility(self)
      UnregisterStateDriver(self, "visibility");
      RegisterStateDriver(self, "visibility", self:GenerateVisibilityString());
    end;

    function self.StyleStatusBar(self)
      local statusBar = self:GetPanel("statusBar");
      local textureFile = LibSharedMedia:Fetch("statusbar", self:ConfGet("STATUS_TEXTURE"));
      local r, g, b = toRGB(self:ConfGet("COLOR_RPUF"))
      statusBar:SetBackdrop(textureFile or LibSharedMedia:Fetch("statusbar", "Blizzard"));
      statusBar:SetJustifyH( self:ConfGet("STATUS_ALIGN"))
      statusBar:SetHeight( self:ConfGet("STATUSHEIGHT"));
      statusBar:SetJustifyV("CENTER");
      statusBar:SetVertexColor( r / 255, g / 255, b / 255, self:ConfGet( "RPUFALPHA" ) );
    end;
     
    function self.StyleFrame(self)
      local backdropFile = LibSharedMedia:Fetch("background", self:ConfGet("RPUF_BACKDROP"));
      local borderFile   = LibSharedMedia:Fetch("border", self:ConfGet("RPUF_BORDER"));
      local r, g, b      = toRGB(self:ConfGet("COLOR_RPUF"))
      self.backdrop:SetTexture( self:ConfGet("RPUF_BACKDROP"));
      self.backdrop:SetVertexColor( r / 255, g / 255, b / 255, self:ConfGet( "RPUFALPHA" ));
    end;
      
    function self.CallScaleHelper(self) end;

    -- moving frames
    --
    self.lock = CreateFrame("Button", nil, self);
    self.lock:SetSize(24, 24);
    self.lock:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT");
    self.lock:SetNormalTexture("Interface\\LFGFRAME\\UI-LFG-ICON-LOCK.PNG");
    self.lock:SetClampedToScreen(true);
    self.lock.unitframe = self;

    self.lock:SetScript("OnClick", 
      function(self) 
        self.unitframe:SetLock(true); 
      end);

    function self.ApplyLock(self) 
      self.locked = self:ConfGet("LOCK_FRAMES"); 
      self.lock:SetShown( not self.locked ) 
    end;

    function self.IsLocked(self)
      self:ConfGet("LOCK_FRAMES")
    end;

    function self.SetLock(self, value) 
      self:ConfSet("LOCK_FRAMES", value); 
      self:ApplyLock(); 
    end;

    function self.ToggleLock(self)     
      self:SetLock(not self:IsLocked() );      
    end;


    self:SetMovable(true);
    self:SetClampedToScreen(true);
    self:RegisterForDrag("LeftButton");
    self:HookScript("OnDragStart", 
      function(self, ...) 
        if not self:IsLocked() 
        then   self:StartMoving() end; 
        return self, ...  
      end);
    self:HookScript("OnDragStop",  
      function(self, ...) 
        self:StopMovingOrSizing();
        self:SaveCoords();
        return self, ...  
      end);

    RP_UnitFramesDB = RP_UnitFramesDB or {};
    RP_UnitFramesDB.coords = RP_UnitFramesDB.coords or {}

    function self.GetDefaultCoords(self) 
      return RPTAGS.CONST.RPUF.COORDS[self.unit:lower()] 
    end;

    function self.SaveCoords(self)
      local x, y = self:GetCenter();
      if x and y then RP_UnitFramesDB.coords[self.unit:lower()] = { x, y }; end;
    end;

    function self.GetSavedCoords(self)
      return RP_UnitFramesDB.coords[self.unit] or self:GetDefaultCoords()
    end;

    function self.SetCoords(self, coords)
      coords = coords or self:GetSavedCoords();
      local x, y = unpack(coords);
      if not x or not y then return end;
      self:ClearAllPoints();
      self:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y);
      self:SaveCoords();
    end

    function self.RestoreCoords(self)
      self:SetCoords( self:GetSavedCoords() );
    end;

    function self.Initialize(self) 
      if not self.initialized 
      then   self:CreatePanels(); 
             self.initialized = true; 
      end; 
    end;

    function self.UpdateEverything(self)
      self:Initialize();
      self:RestoreCoords();
      self:SetDimensions();
      self:PlacePanels();
      self:SetPanelVis();
      self:SetFont();
      self:SetTextColor();
      self:SetTagStrings();
      self:SetVisibility();
      self:StyleStatusBar();
      self:ApplyLock();
      self:StyleFrame();
    end;

  end; -- style definition

  oUF:RegisterStyle(oUF_style, RP_UnitFrame_Constructor);

end);

