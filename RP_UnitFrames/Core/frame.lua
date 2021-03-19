local addOnName, ns = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("MODULE_J",
function(self, event, ...)

  local oUF             = _G[GetAddOnMetadata(addOnName, "X-oUF")];
  local LibSharedMedia  = LibStub("LibSharedMedia-3.0");
  local CONST           = RPTAGS.CONST;
  local oUF_style       = CONST.RPUF.OUF_STYLE;
  local FRAME_NAMES     = CONST.RPUF.FRAME_NAMES;
  local Utils           = RPTAGS.utils;
  local Config          = Utils.config;
  local initializePanel = Utils.frames.initialize_panel;
  local RPUF_GetLayout  = Utils.frames.RPUF_GetLayout;
  local RPUF_GetDefaultLayout = Utils.frames.RPUF_GetDefaultLayout;
  local linkHandler     = Utils.links.handler;
  local titlecase       = Utils.text.titlecase;
  local toRGB           = Utils.color.hexaToNumber;
  local AceGUI          = LibStub("AceGUI-3.0");

  local panelInfo   = CONST.RPUF.PANEL_INFO;
  -- rpuf "style" for oUF -----------------------------------------------------------------------------------------------------
  local function Constructor(self, unit)

    -- -- basics ----------------------------------------------------------------------------------------------------------------
    self.unit       = unit;
    local panels    = {};
    local tooltips  = {};
    local tagStrs   = {}
    local frameName = FRAME_NAMES[unit:upper()];
    local public    = {};

    -- -- configuration, when per-unit ------------------------------------------------------------------------------------------
    local function confGet(setting)
      if    Config.get("LINK_FRAME_" .. unit:upper())
      then return Config.get(setting)
      else return Config.get(setting .. "_" .. unit:upper())
      end;
    end;

    local function confSet(setting, value)
      if   Config.get("LINK_FRAME_" .. unit:upper())
      then Config.set(setting, value);
      else Config.set(setting .. "_" .. unit:upper(), value);
      end;
    end;


    -- -- information functions -------------------------------------------------------------------------------------------------
    -- function self.GetName(   self ) return frameName end;
    local function getUnit(caps)       return caps and unit:upper() or unit:lower(); end;
    local function getPanels()         return panels                                 end;
    local function getLayoutName()     return Config.get( unit:upper() .. "LAYOUT"); end;
    local function getPanel(panelName) return panels[panelName]                      end;

    local function getTooltipColor()
      local r, g, b = toRGB(confGet("COLOR_RPUF_TOOLTIP"))
      return r / 255, g / 255, b / 255;
    end;

    local function getFont()
      return LibSharedMedia:Fetch("font", confGet("FONTNAME")) or
             LibSharedMedia:Fetch("font", "Arial Narrow"),
             confGet("FONTSIZE");
    end;

    -- -- frame size ------------------------------------------------------------------------------------------------------------
    local function updateFrameSize()
      local width, height = self:GetFrameDimensions();
      self:SetSize( width, height);
    end;

    -- -- backdrop --------------------------------------------------------------------------------------------------------------
    local backdrop = CreateFrame("Frame", nil, self, BackdropTemplateMixin and "BackdropTemplate");
    backdrop:SetAllPoints();
    backdrop:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border" });
    backdrop:Show();

    -- -- state driver registration ---------------------------------------------------------------------------------------------
    local function generateSSDString()
      if     Config.get("DISABLE_RPUF") 
      or not Config.get("SHOW_FRAME_" .. unit:upper()) then return "hide" end;

      local conditions = {};

      local hash =
      { ["RPUF_HIDE_DEAD"     ] = "[dead] hide",
        ["RPUF_HIDE_PETBATTLE"] = "[petbattle] hide",
        ["RPUF_HIDE_VEHICLE"  ] = "[vehicleui] hide",
        ["RPUF_HIDE_PARTY"    ] = "[group:party] hide",
        ["RPUF_HIDE_RAID"     ] = "[group:raid] hide",
        ["RPUF_HIDE_COMBAT"   ] = "[combat] hide",
      };

      for k, v in pairs(hash) do if confGet(k) then table.insert(conditions, v) end; end;

      table.insert(conditions, "[@" .. self.unit .. ",exists] show");
      table.insert(conditions, "hide");
      return table.concat(conditions, ";")
    end;

    local function updateFrameVisibility() RegisterStateDriver(self, "visibility", generateSSDString()); end;

    -- -- unit frame appearance -------------------------------------------------------------------------------------------------
    local function updateFrameAppearance()

      local border     = LibSharedMedia:Fetch("border",     confGet("RPUF_BORDER")) 
                         -- or LibSharedMedia:Fetch("border",     "Blizzard Tooltip");
      local background = LibSharedMedia:Fetch("background", confGet("RPUF_BACKDROP")) 
                         -- or LibSharedMedia:Fetch("background", "Blizzard Tooltip");

      local a = confGet( "RPUFALPHA" );
      if a > 1 then a = a / 100; confSet( "RPUFALPHA") end;

      local borderWidth = confGet("RPUF_BORDER_WIDTH");
      local inset = confGet("RPUF_BORDER_INSETS");

      backdrop:SetBackdrop(
        { bgFile   = background, 
          edgeFile = border, 
          edgeSize = borderWidth,
          insets   = { left = inset, right = inset, top = inset, bottom = inset }
        }
      );

      local r, g, b = toRGB(confGet("COLOR_RPUF"))
      backdrop:SetBackdropColor(r / 255, g / 255, b / 255, a);

      r, g, b = toRGB(confGet("COLOR_RPUF_BORDER"));
    
      backdrop:SetBackdropBorderColor(r / 255, g / 255, b / 255, 1);

    end;

    -- -- panels ----------------------------------------------------------------------------------------------------------------
    local function createPanel(panelName, info)
      local panel = CreateFrame("Frame", frameName .. panelName, self);
          -- titlecase(panelName), self);

      panel.unit       = unit;
      panel.name       = panelName;
      panel.frameName  = frameName .. titlecase(panelName);
      panel.setting    = info.setting;
      panel.info       = info;
      panel.initialize = initializePanel;

      panel:initialize(info);
      panels[panelName] = panel;
    end; -- create panel

    -- collective functions, i.e. they iterate through the panels

    local function for_each_panel(func, ...)
      for panelName, panel in pairs(panels)
      do  
          if   panel[func] and type(panel[func]) == "function"
          then panel[func](panel, ...);
          end;
      end;
    end;

    local function updatePanelPlacement()  for_each_panel("Place");   end;
    local function updatePanelVisibility() for_each_panel("SetVis");  end;
    local function updateFont()            for_each_panel("SetFont"); end;

    local function updateTagStrings() for_each_panel("SetTagString"); end;

    local function updateTextColor()
      local r, g, b = toRGB(confGet("COLOR_RPUF_TEXT"))
      for_each_panel("SetTextColor", r / 255, g / 255, b / 255);
    end;

    local function panelGet(funcName, panel, ...)
      if type(panel) == "string" then panel = getPanel(panel) end;
      funcName = funcName:match("^GetPanel") and funcName or ("GetPanel" .. funcName);

      if     not panel
      then   error(funcName .. " requested for unknown panel")
      elseif type(funcName) ~= "string"
      then   error("no funcName given")
      elseif type(panel[funcName]) ~= "function"
      then   error("unknown function" .. (funcName or "nil") .. " for " .. panel:GetName())
      end;

      return panel[funcName](panel, ...);
    end;

    local function gap(num) return confGet("GAPSIZE") * (num or 1) end;

    -- -- frame locking ---------------------------------------------------------------------------------------------------------
    local function isFrameLocked()     return Config.get("LOCK_FRAME_" .. unit:upper()) end;
    local function setFrameLock(value) Config.set("LOCK_FRAME_" .. unit:upper(), value); end;
    local function toggleFrameLock()   setFrameLock(not isFrameLocked() ); end;

    function self.moverSize(self) return 24 / self:GetScale() end;

    local mover = CreateFrame("Button", nil, self);
    mover:SetSize(self:moverSize(), self:moverSize());
    mover:SetPoint("BOTTOMLEFT", self, "TOPLEFT");
    mover:SetNormalTexture("Interface\\CURSOR\\UI-Cursor-Move.PNG");
    mover:SetClampedToScreen(true);
    mover:RegisterForDrag("LeftButton");

    local padlock = CreateFrame("Button", nil, self);
    padlock:SetSize(self:moverSize(), self:moverSize());
    padlock:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT");
    padlock:SetNormalTexture("Interface\\PetBattles\\PetBattle-LockIcon.PNG");
    padlock:SetClampedToScreen(true);
  
    local function updateFrameLock()
      if   isFrameLocked()
      then padlock:Hide() mover:Hide(); -- self:RegisterForDrag(nil);
      else padlock:Show() mover:Show(); -- self:RegisterForDrag("LeftButton");
      end;
    end;

    local function updateMover()
      mover:SetSize(self:moverSize(), self:moverSize());
      padlock:SetSize(self:moverSize(), self:moverSize());
      local layout = RPUF_GetLayout( getLayoutName());
      local x, y = layout:GetMoverOffset(self, "mover");
      if x and y then mover:ClearAllPoints() mover:SetPoint("BOTTOMLEFT", self, "TOPLEFT", x, y) end;
      x, y = layout:GetMoverOffset(self, "padlock");
      if x and y then padlock:ClearAllPoints() padlock:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", x, y) end;
    end;

    padlock:RegisterForClicks("LeftButtonUp");
    padlock:SetScript("OnClick", 
      function() 
        PlaySound(8939); 
        setFrameLock(true); 
        updateFrameLock(); 
      end);

    padlock:SetScript("OnEnter", 
      function() 
        SetCursor("Interface\\CURSOR\\PickLock.PNG") 
        GameTooltip:ClearLines();
        GameTooltip:SetOwner(self, "ANCHOR_CURSOR");
        GameTooltip:SetOwner(self, "ANCHOR_PRESERVE");
        GameTooltip:AddLine("Lock this frame");
        GameTooltip:AddLine("Locking the frame prevents it from being moved.",
                      1, 1, 1, true);
        GameTooltip:Show();
      end);
    padlock:SetScript("OnLeave", 
      function() 
        GameTooltip:FadeOut();
        ResetCursor() 
      end);

    -- -- frame moving ----------------------------------------------------------------------------------------------------------

    local function saveCoords()
      local x, y = self:GetCenter();
      if x and y then RP_UnitFramesDB.coords[unit] = { x, y }; end;
    end;

    local function getDefaultCoords() return RPTAGS.CONST.RPUF.COORDS[unit] end;

    local function getSavedCoords() 
      return RP_UnitFramesDB.coords[unit] or getDefaultCoords() 
    end;

    local function setCoords(coords)
      coords = coords or getSavedCoords();
      local x, y = unpack(coords);
      if not x or not y then return end;
      self:ClearAllPoints();
      self:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y);
      saveCoords();
    end

    local function resetCoords() setCoords(getDefaultCoords()); end;

    local function onDragStart(self, button)
      if button == "LeftButton" then self:StartMoving() end;
    end;

    local function onDragStop(self) self:StopMovingOrSizing(); saveCoords(); end;

    mover:SetScript("OnDragStart", 
      function(this, button)
        if button == "LeftButton" then self:StartMoving() end;
      end);

    mover:SetScript("OnDragStop",
      function(this, button)
        self:StopMovingOrSizing(); 
        saveCoords(); 
      end);

    local function updateStatusBar()
      local statusBar = panels["statusBar"];
      local textureFile = LibSharedMedia:Fetch("statusbar", confGet("STATUS_TEXTURE")) or
              LibSharedMedia:Fetch("statusbar", "Blizzard");

      statusBar:SetStatusbar(textureFile);

      local r, g, b = toRGB(confGet("COLOR_STATUS"))
      statusBar:SetVertexColor( r / 255, g / 255, b / 255, confGet("STATUS_ALPHA" ));

      statusBar.text:SetJustifyH( confGet("STATUS_ALIGN" ))
      statusBar.text:SetJustifyV("CENTER");

      statusBar.text:ClearAllPoints();
      statusBar.text:SetPoint("BOTTOMLEFT", gap(1), gap(1));
      statusBar.text:SetPoint("TOPRIGHT", gap(-1), gap(-1));
      statusBar:SetHeight( confGet("STATUSHEIGHT"));

      statusBar:Place();

      r, g, b = toRGB(confGet("COLOR_STATUS_TEXT"));
      statusBar:SetTextColor(r / 255, g / 255, b / 255);

    end;

    local function updatePortrait()
      local portraitPanel = panels["portrait"];
      local border     = LibSharedMedia:Fetch("border", Config.get("PORTRAIT_BORDER"))
      local background = LibSharedMedia:Fetch("background", Config.get("PORTRAIT_BG"))

      if   Config.get("PORTRAIT_STYLE") == "STANDARD"
      then portraitPanel.portrait2D:Hide();
           self.Portrait = portraitPanel.portrait3D;
           self.Portrait:SetUnit(unit);
           self.Portrait:Show();
      else portraitPanel.portrait3D:Hide();
           self.Portrait = portraitPanel.portrait2D;
           self.Portrait:Show();
      end;

      portraitPanel.pictureFrame:SetBackdrop(
      { bgFile   = background,
        edgeFile = border,
        edgeSize = confGet("RPUF_BORDER_WIDTH"),
        insets   = { left = 4, right = 4, top = 4, bottom = 4 }
      });
    end;

    local function openFrameOptions(self, button)
      if button == "RightButton"
      then linkHandler("opt://RPUF_Frames/");
      end;
    end;

    local layoutSize = "small";

    local function getLayoutSize()     return layoutSize; end;
    local function setLayoutSize(size) layoutSize = size; end;

    local function updateContent() self:UpdateAllElements("now"); end;

    local function updateLayout()
      local layoutName = getLayoutName()
      local layout = RPUF_GetLayout(layoutName) or RPUF_GetDefaultLayout(self:GetLayoutSize());
      if not layout then error("Unknown layout in updateLayout: " .. (layoutName or "nil")); end;
      for funcName, func in pairs(layout.frame_methods)
      do  self[funcName] = func;
      end;
      for_each_panel("SetLayout") 
    end;

    local function updateEverything()
      updateLayout();
      updateFrameSize();
      updatePanelPlacement();
      updatePortrait();
      updatePanelVisibility();
      updateFrameVisibility();
      updateFont();
      updateTextColor();
      updateStatusBar();
      updateFrameLock();
      updateFrameAppearance();
      updateTagStrings();
      updateContent();
      updateMover();
    end;

    public.ConfGet               = confGet;
    public.ConfSet               = confSet;
    public.Gap                   = gap;
    public.GetLayoutName         = getLayoutName;
    public.GetTooltipColor       = getTooltipColor;
    public.GetUnit               = getUnit;
    public.SetLayoutSize         = setLayoutSize;
    public.PanelGet              = panelGet;
    public.ResetCoords           = resetCoords;
    public.UpdateContent         = updateContent;
    public.UpdateEverything      = updateEverything;
    public.UpdateFont            = updateFont;
    public.UpdateFrameAppearance = updateFrameAppearance;
    public.UpdateFrameLock       = updateFrameLock;
    public.UpdateFrameSize       = updateFrameSize;
    public.UpdateFrameVisibility = updateFrameVisibility;
    public.UpdateLayout          = updateLayout;
    public.UpdatePanelPlacement  = updatePanelPlacement;
    public.UpdatePanelVisibility = updatePanelVisibility;
    public.UpdatePortrait        = updatePortrait;
    public.UpdateStatusBar       = updateStatusBar;
    public.UpdateTagStrings      = updateTagStrings;
    public.UpdateTextColor       = updateTextColor;
    public.UpdateMover           = updateMover;

    function self.HasPublicFunction(self, funcName)
       return type(public[funcName]) == "function"
    end;

    function self.Public(self, funcName, ...)
      if   public[funcName]
      then return public[funcName](...)
      else error("No public function " .. funcName)
      end;
    end;

    -- initialization
    self:SetMovable(true);
    self:SetClampedToScreen(true);
    setCoords(getSavedCoords());
    for name, info in pairs( panelInfo ) do createPanel(name, info); end;
    -- self:EnableMouse(true);
    -- self:SetScript("OnMouseUp", openFrameOptions);

  end; -- style definition

  oUF:RegisterStyle(oUF_style, Constructor);

end);

