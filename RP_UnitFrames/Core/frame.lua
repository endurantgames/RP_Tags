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
  local titlecase       = Utils.text.titlecase;
  local toRGB           = Utils.color.hexaToNumber;

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
      local width, height = self:GetDimensions();
      self:SetSize( width, height);
    end;

    -- -- backdrop --------------------------------------------------------------------------------------------------------------
    local backdrop = CreateFrame("Frame", nil, self, BackdropTemplateMixin and "BackdropTemplate");
    backdrop:SetAllPoints();
    backdrop:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border" });
    backdrop:Show();

    -- -- state driver registration ---------------------------------------------------------------------------------------------
    local function generateSSDString()
      local conditions = {};
      if confGet("DISABLE_RPUF") then return "hide" end;
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

    local function updateFrameVisibility(self)
      UnregisterStateDriver(self, "visibility");
      RegisterStateDriver(self,   "visibility", generateSSDString());
    end;

    -- -- unit frame appearance -------------------------------------------------------------------------------------------------
    local function updateFrameAppearance()

      local border     = LibSharedMedia:Fetch("border",     confGet("RPUF_BORDER")) or
                         LibSharedMedia:Fetch("border",     "Blizzard Tooltip");
      local background = LibSharedMedia:Fetch("background", confGet("RPUF_BACKDROP")) or
                         LibSharedMedia:Fetch("background", "Blizzard Tooltip");

      local a = confGet( "RPUFALPHA" );
      if a > 1 then a = a / 100; confSet( "RPUFALPHA") end;

      local r, g, b      = toRGB(confGet("COLOR_RPUF"))

      local insent = 5;

      backdrop:SetBackdrop({ bgFile = background, edgeFile = border, edgeSize = 10, insets = { left = inset, right = inset, top = inset, bottom = 5 }});
      backdrop:SetBackdropColor( r / 255, g / 255, b / 255, a );

    end;

    -- -- panels ----------------------------------------------------------------------------------------------------------------
    local function createPanel(panelName, info)
      local panel = CreateFrame("Frame", frameName .. titlecase(panelName), self);

      panel.unit       = unit;
      panel.name       = panelName;
      panel.frameName  = frameName .. titlecase(panelName);
      panel.setting    = info.setting;
      panel.info = info;

      initializePanel(panel);
      panels[panelName] = panel;
    end; -- create panel

    -- collective functions, i.e. they iterate through the panels

    local function for_each_panel(func, ...)
      for _, panel in pairs(panels)
      do  if   panel[func] and type(panel[func]) ~= "function"
          then panel[func](panel, ...);
          end;
      end;
    end;

    local function updatePanelPlacement() for_each_panel("Place"  ); end;
    local function updatePanelVisibility() for_each_panel("SetVis" ); end;
    local function updateFont()     for_each_panel("SetFont"); end;

    local function updateTagStrings() for_each_panel("SetTagString"); end;

    local function updateTextColor()
      local r, g, b = toRGB(confGet("COLOR_RPUF_TEXT"))
      for_each_panel("SetTextColor", r / 255, g / 255, b / 255);
    end;

    local function panelGet(funcName, panel)
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

    local function gap(num) return confGet("GAPSIZE") * (num or 1) end;

    -- -- frame locking ---------------------------------------------------------------------------------------------------------
    local function isFrameLocked()     return Config.get("LOCK_FRAMES_" .. unit:upper()) end;
    local function setFrameLock(value) confSet("LOCK_FRAMES", value); end;
    local function toggleFrameLock()   setFrameLock(not isFrameLocked() ); end;

    local padlock = CreateFrame("Button", nil, self);
    padlock:SetSize(24, 24);
    padlock:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT");
    padlock:SetNormalTexture("Interface\\PetBattles\\PetBattle-LockIcon.PNG");
    padlock:SetClampedToScreen(true);

    local function updateFrameLock()
      if   isFrameLocked()
      then padlock:Hide() self:RegisterForDrag(nil);
      else padlock:Show() self:RegisterForDrag("LeftButton");
      end;
    end;

    padlock:SetScript("OnClick", function() setFrameLock(true); end);

    -- -- frame moving ----------------------------------------------------------------------------------------------------------

    local function saveCoords()
      local x, y = self:GetCenter();
      if x and y then RP_UnitFramesDB.coords[unit] = { x, y }; end;
    end;

    local function getDefaultCoords() return RPTAGS.CONST.RPUF.COORDS[unit] end;
    local function getSavedCoords() return RP_UnitFramesDB.coords[unit] or getDefaultCoords() end;

    local function setCoords(coords)
      coords = coords or getSavedCoords();
      local x, y = unpack(coords);
      if not x or not y then return end;
      self:ClearAllPoints();
      self:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y);
      saveCoords();
    end

    local function onDragStart(self, button)
      if button == "LeftButton" then self:StartMoving() end;
    end;

    local function onDragStop(self)
      self:StopMovingOrSizing();
      saveCoords();
    end;

    local function updateStatusBar()
      local statusBar = panels["statusBar"];
      local textureFile = LibSharedMedia:Fetch("statusbar", confGet("STATUS_TEXTURE")) or
              LibSharedMedia:Fetch("statusbar", "Blizzard");

      statusBar:SetStatusbar(textureFile);

      local a = confGet( "RPUFALPHA" );

      if a > 1 then a = a / 100; confSet( "RPUFALPHA", a) end;

      local r, g, b = toRGB(confGet("COLOR_STATUS"))
      statusBar:SetVertexColor( r / 255, g / 255, b / 255, a );

      statusBar.text:SetJustifyH( confGet("STATUS_ALIGN" ))
      statusBar.text:SetJustifyV("CENTER");
      statusBar:SetHeight( confGet("STATUSHEIGHT"));

      r, g, b = toRGB(confGet("COLOR_STATUS_TEXT"));
      statusBar:SetTextColor(r / 255, g / 255, b / 255);

    end;

    local function updatePortrait()
      print (unit .. " portrait updating now");
      local portraitPanel = panels["portrait"];
      self.Portrait:SetUnit(unit);
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

    local function updateContent()
      self:UpdateAllElements("now");
    end;

    local function updateLayout()
      local layoutName = getLayoutName()
      local layout = RPUF_GetLayout(layoutName);
      if not layout then error("Unknown layout in updateLayout"); end;

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
      updateFonts();
      updateTextColor();
      updateStatusBar();
      updateFrameLock();
      updateFrameAppearance();
      updateTagStrings();
      updateContent();
    end;

    public.ConfGet               = confGet;
    public.ConfSet               = confSet;
    public.Gap                   = gap;
    public.GetFont               = getFont;
    public.GetLayoutName         = getLayoutName;
    public.GetTooltipColor       = getTooltipColor;
    public.GetUnit               = getUnit;
    public.PanelGet              = panelGet;
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
    for name, info in pairs( panelInfo ) do createPanel( name, info); end;
    self:SetScript("OnDragStart", onDragStart);
    self:SetScript("OnDragStop",  onDragStop);

  end; -- style definition

  oUF:RegisterStyle(oUF_style, Constructor);

end);

