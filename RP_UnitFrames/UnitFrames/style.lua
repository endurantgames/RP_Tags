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

  local getUF_Size = frameUtils.size.get;

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
                  has_statusBar = true,
                  has_own_align    = true,                                        },
  };


  -- rpuf "style" for oUF ----------------------------------------------------------------------------------------------------------------------------------
  local function RP_UnitFrame_Constructor(self, unit)

    self.unit     = unit;
    self.panels   = {};
    self.toolTips = {};
    self.tagStrs  = {}

    self.frameName = FRAME_NAMES[unit:upper()];

    self.bg = CreateFrame("Frame", nil, self, BackdropTemplateMixin and "BackdropTemplate");
    self.bg:SetAllPoints();
    self.bg:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border" });
    self.bg:Show();

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

    function self.GetName(self)             
      return self.frameName                              
    end;

    function self.GetUnit(self, caps)
      return caps and self.unit:upper() or self.unit:lower();
    end;

    function self.GetLayout(self)           
       return Config.get( self:GetUnit(true) .. "LAYOUT"); 
    end;

    function self.GetPanel(self, panelName) 
      return self.panels[panelName]                     
    end;

    function self.GetPanels(self) 
      return self.panels                                 
    end;

    function self.SetUF_Size(self) 
      local width, height = getUF_Size( self:GetLayout() );
      self:SetSize( width, height);
    end;
    
    function self.CreatePanel(self, panelName, opt)
      opt = opt or {};
      local panel

      panel = CreateFrame("Frame", self.frameName .. panelName, self);
      panel:SetPoint("TOPLEFT");

      if   opt["has_statusBar"]
      then panel.statusBar = panel:CreateTexture();
           panel.statusBar:SetColorTexture(1, 1, 1, 0.5);
           panel.statusBar:SetAllPoints();
           function panel.SetStatusbar(self, textureFile) 
             self.statusBar:SetTexture(textureFile) 
            end;
           function panel.SetVertexColor(self, ...) 
             self.statusBar:SetVertexColor(...) 
           end;
      end;

      panel.unitframe = self;
      panel.unit      = unit;
      panel.name      = panelName;

      local setting = opt.setting or panelName:upper();
      local tooltip = opt.tooltip or setting .. "_TOOLTIP";

      if not opt["no_tag_string"]
      then 
        panel.text = panel:CreateFontString(
          self.frameName .. panel.name .. "Tag", "OVERLAY", "GameFontNormal");
        panel.setting = setting;
        panel.text:SetAllPoints();
        panel.text:SetText(panel.name);
      end;

      if opt["portrait"]
      then panel.portrait = CreateFrame("PlayerModel", nil, panel);
           panel.portrait:SetAllPoints();
           self.Portrait = panel.portrait;

           panel.pictureFrame = CreateFrame("Frame", nil, panel,
               BackdropTemplateMixin and "BackdropTemplate");

           panel.pictureFrame:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 5, 5);

           panel.pictureFrame:SetBackdrop(
           { bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background", 
             edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border" });
      end;
 
      function panel.showTooltip(self, event, ...) 
        local tooltip = eval(Config.get(self.tooltip), self:GetUnit(), self:GetUnit());
        local r, g, b = self.unitframe:GetTooltipColor();
    
        if   self:ConfGet("MOUSEOVER_CURSOR")
        then SetCursor("Interface\\CURSOR\\Inspect.PNG");
        end;
    
        if tooltip and tooltip:len() > 0 -- only show a tooltip if there's something to show
        then GameTooltip:ClearLines();
             GameTooltip:SetOwner(self, "ANCHOR_CURSOR");
             GameTooltip:SetOwner(self, "ANCHOR_PRESERVE");

             local lines = split(tooltip, "\n"); -- this is our sneaky way of getting a "title"

             for i, line in ipairs(lines)
             do GameTooltip:AddLine(line, r, g, b, true)
             end;

             GameTooltip:Show();
        end;
      end; 

      function hideTooltip(self, ...) 
        GameTooltip:FadeOut(); 
        ResetCursor(); 
        return self, ... 
      end;

      if not opt["no_tooltip"]
      then panel:EnableMouse();
           panel:SetScript("OnEnter", showTooltip );
           panel:SetScript("OnLeave", hideTooltip );
           panel.tooltip = tooltip;
      end;
       
      function showContextMenu(self, event, ...)  -- obvious placeholder is obvious
        print("context menu for", self.name); 
      end;
  
      if   not opt["no_context_menu"]
      then self:SetScript("OnMouseUp",
             function(self, button, ...) 
               if   button == "RightButton" 
               then showContextMenu(self, button, ...)
               end; 
             end);
      end;

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
             self.text:SetJustifyH(justifyH);
             self.text:SetJustifyV(justifyV);
        end;
      end;

      function panel.SetTextColor(self, r, g, b) 
        if   self.text 
        then self.text:SetTextColor(r, g, b); 
        end; 
      end;

      function panel.SetTagString(self) 
        if   self.text 
        then self.unitframe:Tag(
               self.text, 
               Config.get(self.setting)
             ); 
        end; 
      end;

      function panel.GetVis(self) -- whether a panel is visible in a given layout
        
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

        print(self:GetLayout(), self.name, hash[self:GetLayout()][self.name]);
        return hash[self:GetLayout()][self.name]
      end;
    
      function panel.SetVis(self) 
        self:SetShown( self:GetVis() ); 
      end;

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

      self.panels[panelName] = panel; -- save it for when we need it
    end; -- create panel

    function self.CreatePanels(self)   -- this produces all the panels
      for panelName, opt in pairs( panelList )      
      do  self:CreatePanel( panelName, opt); 
      end; 
    end;
      
    -- collective functions, i.e. they iterate through the panels
    --
    function self.PlacePanels(self)   
      for _, panel in pairs( self:GetPanels() ) 
      do  panel:Place();        
      end 
    end;

    function self.SetPanelVis(self)   
      for _, panel in pairs(self:GetPanels()) 
      do  panel:SetVis();       
      end 
    end;

    function self.SetTagStrings(self) 
      for _, panel in pairs(self:GetPanels()) 
      do panel:SetTagString(); 
      end 
    end;

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
      local fontFile = LibSharedMedia:Fetch("font", fontName) -- fallback is part of LSM
              or LibSharedMedia:Fetch("font", "Arial Narrow");

      for _, panel in pairs(self:GetPanels() ) 
      do  panel:SetJustify(); 
          panel:SetFont(fontFile, fontSize) 
      end;

      self:GetPanel("name"):SetFont( 
        LibSharedMedia:Fetch("font", Config.get("NAMEPANEL_FONTNAME")), 
       fontSize);
    end;

    function self.GetTooltipColor(self)
      local r, g, b = toRGB(self:ConfGet("COLOR_RPUF_TOOLTIP"))
      return r / 255, g / 255, b / 255;
    end;

    function self.GenerateSSD_String(self)
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

    function self.Start_SSD(self)
      UnregisterStateDriver(self, "visibility");
      RegisterStateDriver(self, "visibility", self:GenerateSSD_String());
    end;

    function self.StyleStatusBar(self)
      local statusBar = self:GetPanel("statusBar");
      local textureFile = LibSharedMedia:Fetch("statusbar", self:ConfGet("STATUS_TEXTURE")) or
              LibSharedMedia:Fetch("statusbar", "Blizzard");

      statusBar:SetStatusbar(textureFile);

      local a = self:ConfGet( "RPUFALPHA" );
      if a > 1 then a = a / 100; self:ConfSet( "RPUFALPHA", a) end;

      local r, g, b = toRGB(self:ConfGet("COLOR_STATUS"))
      statusBar:SetVertexColor( r / 255, g / 255, b / 255, a );

      statusBar.text:SetJustifyH( self:ConfGet("STATUS_ALIGN" ))
      statusBar.text:SetJustifyV("CENTER");
      statusBar:SetHeight( self:ConfGet("STATUSHEIGHT"));

      r, g, b = toRGB(self:ConfGet("COLOR_STATUS_TEXT"));
      statusBar:SetTextColor(r / 255, g / 255, b / 255);

    end;
     
    function self.UpdatePortrait(self)
      local portraitPanel = self:GetPanel("portrait");
      self.Portrait:SetUnit( self:GetUnit() );

      local border = LibSharedMedia:Fetch("border", Config.get("PORTRAIT_BORDER"))
                     or LibSharedMedia:Fetch("border", "Blizzard Achievement Wood");
      local background = LibSharedMedia:Fetch("background", Config.get("PORTRAIT_BG")) 
                     or LibSharedMedia:Fetch("Blizzard Rock");
      portraitPanel.pictureFrame:SetBackdrop({ bgFile = background, edgeFile = border, 
        edgeSize = 8, insets = { left = 3, right = 3, top = 3, bottom = 3 }}); 
    end;

    function self.StyleFrame(self)
      -- local borderFile   = LibSharedMedia:Fetch("border", self:ConfGet("RPUF_BORDER"));
      --
      -- local background = 
      --   LibSharedMedia:Fetch("background", self:ConfGet("RPUF_BACKDROP")) or
      --   LibSharedMedia:Fetch("background", "Blizzard Tooltip");

      local border = LibSharedMedia:Fetch("border", self:ConfGet("RPUF_BORDER")) or LibSharedMedia:Fetch("border", "Blizzard Tooltip");
      local background = LibSharedMedia:Fetch("background", self:ConfGet("RPUF_BACKDROP")) or LibSharedMedia:Fetch("background", "Blizzard Tooltip");
      local a = self:ConfGet( "RPUFALPHA" );
      local inset = 12;
      if a > 1 then a = a / 100; self:ConfSet( "RPUFALPHA") end;
      local r, g, b      = toRGB(self:ConfGet("COLOR_RPUF"))
      self.bg:SetBackdrop({ bgFile = background, edgeFile = border, edgeSize = 10, insets = { left = 5, right = 5, top = 5, bottom = 5 }});
      self.bg:SetBackdropColor( r / 255, g / 255, b / 255, a );

      -- self.background:SetTexture( backgroundFile);
    end;
      
    function self.CallScaleHelper(self)  -- placeholder
    end;

    -- moving frames
    --
    -- this is our lock frame
    --
    self.padlock = CreateFrame("Button", nil, self);
    self.padlock:SetSize(24, 24);
    self.padlock:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT");
    self.padlock:SetNormalTexture("Interface\\PetBattles\\PetBattle-LockIcon.PNG");
    self.padlock:SetClampedToScreen(true);
    self.padlock.unitframe = self;

    self.padlock:SetScript("OnClick", 
      function(self) 
        self.unitframe:SetFrameLock(true); 
      end);

    function self.IsFrameLocked(self)
      return Config.get("LOCK_FRAMES_" .. self:GetUnit(true))
    end;

    function self.ApplyFrameLock(self) 
      if   self:IsFrameLocked()
      then self.padlock:Hide() 
           self:RegisterForDrag(nil);
      else self.padlock:Show() 
           self:RegisterForDrag("LeftButton");
      end;
    end;

    self:SetMovable(true);

    function self.SetFrameLock(self, value, andApplyIt) 
      self:ConfSet("LOCK_FRAMES", value); 
      if andApplyIt then self:ApplyFrameLock() end;
    end;

    function self.ToggleFrameLock(self)     
      self:SetLock(not self:IsFrameLocked() );      
    end;

    self:SetClampedToScreen(true);

    self:HookScript("OnDragStart", 
      function(self, button, ...) 
        if button == "LeftButton" then self:StartMoving() end; 
      end);

    self:HookScript("OnDragStop", function(self, button, ...) self:StopMovingOrSizing(); self:SaveCoords(); end);

    self:SetScript("OnEnter",
      function(self, button, ...)
        SetCursor("Interface\\CURSOR\\Inspect");
      end);

    -- location -- all values are saved as { x, y } coordinate pairs
    --
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

    function self.RestoreCoords(self) self:SetCoords( self:GetSavedCoords() ); end;

    function self.RefreshContentNow()
      self:UpdateAllElements("now");
    end;

    -- initialization: things that shouldo only be done once
    function self.Initialize(self) 
      if not self.initialized 
      then   self:CreatePanels(); 
             self:Start_SSD();
             self:RestoreCoords();
             self.initialized = true; 
      end; 
    end;

    function self.UpdateEverything(self)
      self:Initialize();
      self:SetUF_Size();
      self:PlacePanels();
      self:UpdatePortrait();
      self:SetPanelVis();
      self:SetFont();
      self:SetTextColor();
      self:StyleStatusBar();
      self:ApplyFrameLock();
      self:StyleFrame();
      self:SetTagStrings();
      self:RefreshContentNow();
    end;

  end; -- style definition

  oUF:RegisterStyle(oUF_style, RP_UnitFrame_Constructor);

end);

