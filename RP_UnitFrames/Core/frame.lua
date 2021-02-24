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
  local initialzize_panel  = frameUtils.panels.initialize;
  local titlecase          = Utils.text.titlecase;

  local getUF_Size         = frameUtils.size.get;

  local scaleFrame         = frameUtils.size.scale.set;
  local toRGB              = Utils.color.hexaToNumber;
  local openEditor         = Utils.config.openEditor;

  local panelList =
  { name      = { setting          = "NAMEPANEL",   tooltip = "NAME_TOOLTIP", use_font = "NAMEPANEL"      },
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

    -- -- basics ---------------------------------------------------------------------------------------------------------------------------------------------
    self.unit      = unit;
    self.panels    = {};
    self.toolTips  = {};
    self.tagStrs   = {}
    self.frameName = FRAME_NAMES[unit:upper()];

    -- -- configuration, when per-unit -----------------------------------------------------------------------------------------------------------------------
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

    -- -- information functions ------------------------------------------------------------------------------------------------------------------------------
    function self.GetName(   self )           return self.frameName                                   end;
    function self.GetUnit(   self, caps)      return caps and self.unit:upper() or self.unit:lower(); end;
    function self.GetLayout( self )           return Config.get( self:GetUnit(true) .. "LAYOUT");     end;
    function self.GetPanel(  self, panelName) return self.panels[panelName]                           end;
    function self.GetPanels( self )           return self.panels                                      end;

    function self.GetTooltipColor(self)

      local r, g, b = toRGB(self:ConfGet("COLOR_RPUF_TOOLTIP"))
      return r / 255, g / 255, b / 255;

    end;

    function self.GetFont(self)

      return LibSharedMedia:Fetch("font", self:ConfGet("FONTNAME")) or
             LibSharedMedia:Fetch("font", "Arial Narrow"),
             self:ConfGet("FONTSIZE");

    end;

    -- -- frame size -----------------------------------------------------------------------------------------------------------------------------------------
    function self.SetUF_Size(self)

      local width, height = getUF_Size( self:GetLayout() );
      self:SetSize( width, height);

    end;

    -- -- backdrop -------------------------------------------------------------------------------------------------------------------------------------------
    self.bg = CreateFrame("Frame", nil, self, BackdropTemplateMixin and "BackdropTemplate");
    self.bg:SetAllPoints();
    self.bg:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border" });
    self.bg:Show();

    -- -- state driver registration --------------------------------------------------------------------------------------------------------------------------
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
      RegisterStateDriver(self,   "visibility", self:GenerateSSD_String());
    end;

    -- -- unit frame appearance ------------------------------------------------------------------------------------------------------------------------------
    function self.StyleFrame(self)

      local border     = LibSharedMedia:Fetch("border",     self:ConfGet("RPUF_BORDER")) or 
                         LibSharedMedia:Fetch("border",     "Blizzard Tooltip");
      local background = LibSharedMedia:Fetch("background", self:ConfGet("RPUF_BACKDROP")) or 
                         LibSharedMedia:Fetch("background", "Blizzard Tooltip");

      local a = self:ConfGet( "RPUFALPHA" );
      if a > 1 then a = a / 100; self:ConfSet( "RPUFALPHA") end;

      local r, g, b      = toRGB(self:ConfGet("COLOR_RPUF"))

      local insent = 5;

      self.bg:SetBackdrop({ bgFile = background, edgeFile = border, edgeSize = 10, insets = { left = inset, right = inset, top = inset, bottom = 5 }});
      self.bg:SetBackdropColor( r / 255, g / 255, b / 255, a );

    end;

    -- -- panels ---------------------------------------------------------------------------------------------------------------------------------------------
    function self.CreatePanel(self, panelName, opt)
      opt = opt or {};
      local panel

      panel = CreateFrame("Frame", self:GetName().. titlecase(panelName), self);
      panel:SetPoint("TOPLEFT");

      panel.unitframe  = self;
      panel.unit       = unit;
      panel.name       = panelName;
      panel.frameName  = self:GetName() .. titlecase(panelName);
      panel.setting    = opt.setting;
      panel.initialize = initialize_panel;

      self.panels[panelName] = panel; -- save it for when we need it

      panel:Initialize();

    end; -- create panel

    function self.CreatePanels(self)   -- this produces all the panels
    end;

    -- collective functions, i.e. they iterate through the panels
    
    local function for_each_panel(func, ...)
      for _, panel in pairs( self:GetPanels() )
      do  if   panel[func] and type(panel[func]) ~= "function" 
          then panel[func](panel, ...); 
          end;
      end;
    end; 

    function self.PlacePanels(   self ) for_each_panel( "Place"       ); end;
    function self.SetPanelVis(   self ) for_each_panel( "SetVis"      ); end;
    function self.SetFont(       self ) for_each_panel( "SetFont"     ); end;
    function self.SetTagStrings( self ) for_each_panel( "SetTagString"); end;

    function self.SetTextColor(self)
      local r, g, b = toRGB(self:ConfGet("COLOR_RPUF_TEXT"))
      for_each_panel("SetTextColor", r / 255, g / 255, b / 255);
    end;

    function self.PanelGet(self, funcName, panel)
      panel = (type(panel) == "string") and self:GetPanel(panel);
      funcName = funcName:match("^GetPanel") and funcName or ("GetPanel" .. funcName);

      if     not panel 
      then   error("width requested for unknown panel") 
      elseif type(funcName) ~= "string" 
      then   error("no funcName given") 
      elseif type(panel[funcName]) ~= "function" 
      then   error("unknown function") 
      end;

      return panel[funcName](self);
    end;

    -- -- frame locking --------------------------------------------------------------------------------------------------------------------------------------
    function self.IsFrameLocked(   self )       return Config.get("LOCK_FRAMES_" .. self:GetUnit(true)) end;
    function self.SetFrameLock(    self, value) self:ConfSet("LOCK_FRAMES", value); end;
    function self.ToggleFrameLock( self )       self:SetLock(not self:IsFrameLocked() ); end;

    function self.ApplyFrameLock(self)
      if   self:IsFrameLocked() 
      then self.padlock:Hide() self:RegisterForDrag(nil);
      else self.padlock:Show() self:RegisterForDrag("LeftButton");
      end;
    end;

    -- -- padlock --------------------------------------------------------------------------------------------------------------------------------------------
    self.padlock = CreateFrame("Button", nil, self);
    self.padlock:SetSize(24, 24);
    self.padlock:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT");
    self.padlock:SetNormalTexture("Interface\\PetBattles\\PetBattle-LockIcon.PNG");
    self.padlock:SetClampedToScreen(true);

    self.padlock:SetScript("OnClick", function(self) self:GetParent():SetFrameLock(true); end);

    -- -- frame moving ---------------------------------------------------------------------------------------------------------------------------------------
    self:SetMovable(true);
    self:SetClampedToScreen(true);

    function self.GetDefaultCoords(self) return RPTAGS.CONST.RPUF.COORDS[self.unit:lower()] end;
    function self.GetSavedCoords(self) return RP_UnitFramesDB.coords[self.unit] or self:GetDefaultCoords() end;
    function self.RestoreCoords(self) self:SetCoords( self:GetSavedCoords() ); end;

    function self.SaveCoords(self)
      local x, y = self:GetCenter();
      if x and y then RP_UnitFramesDB.coords[self.unit:lower()] = { x, y }; end;
    end;

    function self.SetCoords(self, coords)
      coords = coords or self:GetSavedCoords();
      local x, y = unpack(coords);
      if not x or not y then return end;
      self:ClearAllPoints();
      self:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y);
      self:SaveCoords();
    end

    self:SetScript("OnDragStart", function(self, button, ...) if button == "LeftButton" then self:StartMoving() end; end);
    self:SetScript("OnDragStop",  function(self, button, ...) self:StopMovingOrSizing(); self:SaveCoords();          end);

    -- -- frame updating -------------------------------------------------------------------------------------------------------------------------------------
    function self.RefreshContentNow() 
      self:UpdateAllElements("now"); 
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

    function self.UpdateThePortrait(self)

      print (self.unit .. "portrait updating now");

      local portraitPanel = self:GetPanel("portrait");
      self.Portrait:SetUnit( self:GetUnit() );

      local border     = LibSharedMedia:Fetch("border", Config.get("PORTRAIT_BORDER"))
                         or LibSharedMedia:Fetch("border", "Blizzard Achievement Wood");
      local background = LibSharedMedia:Fetch("background", Config.get("PORTRAIT_BG"))
                         or LibSharedMedia:Fetch("Blizzard Rock");

      portraitPanel.pictureFrame:SetBackdrop(
      { bgFile   = background,
        edgeFile = border,
        edgeSize = 8,
        insets   = { left = 3, right = 3, top = 3, bottom = 3 }
      });

    end;

    function self.UpdateEverything(self)
      self:Initialize();
      self:SetUF_Size();
      self:PlacePanels();
      self:UpdateThePortrait();
      self:SetPanelVis();
      self:SetFont();
      self:SetTextColor();
      self:StyleStatusBar();
      self:ApplyFrameLock();
      self:StyleFrame();
      self:SetTagStrings();
      self:RefreshContentNow();
    end;

    for panelName, opt in pairs( panelList ) do self:CreatePanel( panelName, opt); end;
    self:Start_SSD();
    self:RestoreCoords();
    
  end; -- style definition

  oUF:RegisterStyle(oUF_style, RP_UnitFrame_Constructor);

end);

