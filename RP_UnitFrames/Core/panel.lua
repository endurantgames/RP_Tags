local addOnName, ns = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("before MODULE_J", -- has to run before "frames"
function(self, event, ...)

  local CONST              = RPTAGS.CONST;
  local Utils              = RPTAGS.utils;
  local Config             = Utils.config;
  local frameUtils         = Utils.frames;
  local FRAME_NAMES        = CONST.RPUF.FRAME_NAMES;
  local eval               = Utils.tags.eval;
  local split              = Utils.text.split;
  local notify             = Utils.text.notify;

  local getLeft            = frameUtils.panels.layout.getLeft;
  local getTop             = frameUtils.panels.layout.getTop;
  local getPoint           = frameUtils.panels.layout.getPoint;
  local getHeight          = frameUtils.panels.size.getHeight;
  local getWidth           = frameUtils.panels.size.getWidth;
  local LibSharedMedia     = LibStub("LibSharedMedia-3.0");
  local linkHandler        = Utils.links.handler;

  local getUF_Size         = frameUtils.size.get;

  local scaleFrame         = frameUtils.size.scale.set;
  local toRGB              = Utils.color.hexaToNumber;

  local function initialize_panel(self, opt)

    --   -- passthrough ---------------------------------------------------------------------------------------
   
    function self.Public(self, funcName, ... ) return self:GetParent():Public(funcName,        ... ) end;
    function self.Gap(       self,       ... ) return self:GetParent():Public("Gap",           ... ) end;
    function self.GetUnit(   self,       ... ) return self:GetParent():Public("GetUnit",       ... ) end;
    function self.GetLayoutName( self,   ... ) return self:GetParent():Public("GetLayoutName", ... ) end;
    function self.ConfGet(   self,       ... ) return self:GetParent():Public("ConfGet",       ... ) end;
    function self.ConfSet(   self,       ... ) return self:GetParent():Public("ConfSet",       ... ) end;
    function self.PanelGet(  self,       ... ) return self:GetParent():Public("PanelGet",      ... ) end;

    --   -- general -------------------------------------------------------------------------------------------
    
    function self.Place(self)
      -- local layout = self:GetLayoutName();
      if self.GetPanelLeft and self.GetPanelTop and self.GetPanelHeight and self.GetPanelWidth
      then self:ClearAllPoints();

           self:SetPoint("TOPLEFT", self:GetParent(), 
                         "TOPLEFT", self:GetPanelLeft(), self:GetPanelTop() * -1);
           self:SetSize(self:GetPanelWidth(), self:GetPanelHeight());
      else self:Hide();
      end;
    end;

    function self.SetVis(self) self:SetShown( self.GetPanelVis and self:GetPanelVis() ) end;

    opt = opt or {};

    --   ---- has_statusBar -----------------------------------------------------------------------------------
    if   opt["has_statusBar"]
    then 

      self.statusBar = self:CreateTexture();
      self.statusBar:SetColorTexture(1, 1, 1, 0.5);
      self.statusBar:SetAllPoints();

      function self.SetStatusbar(   self, textureFile ) self.statusBar:SetTexture(textureFile) end;
      function self.SetVertexColor( self, ...         ) self.statusBar:SetVertexColor(...)     end;

    end;

    --   -- not no_tag_string ---------------------------------------------------------------------------------
    if not opt["no_tag_string"]
    then 

      self.text = self:CreateFontString(self:GetParent():GetName() .. 
                  self.name .. "Tag", "OVERLAY", "GameFontNormal");

      self.text:SetAllPoints();
      self.text:SetText(self.name);

      function self.SetTagString( self) self:GetParent():Tag(self.text, Config.get(self.setting)) end;
      function self.SetTextColor( self, r, g, b) self.text:SetTextColor(r, g, b)                end;

      function self.GetJustify(self)
        if     self.name == "statusBar" 
        then   return self:ConfGet("STATUS_ALIGN"), "CENTER";
        elseif (self.name == "name" or self.name == "info") 
                 and
               (self:GetLayoutName() == "PAPERDOLL" or self:GetLayout() == "THUMBNAIL")
        then   return "CENTER", "CENTER";
        else   return "LEFT", "TOP";
        end;
      end;

      if opt["has_own_align"]
      then function self.SetJustify(self)
             self.text:SetJustifyH( self:ConfGet( opt.has_own_align ) );
             self.text:SetJustifyV( "CENTER" );
           end;
      else function self.SetJustify(self)
             if self.GetPanelJustifyH and self.GetPanelJustifyV
             then self.text:SetJustifyH( self:GetPanelJustifyH() );
                  self.text:SetJustifyV( self:GetPanelJustifyV() );
             end;
           end;
      end;
  
      local step = 4;

      local font_size_hash =
      { ["extrasmall" ] = step * -2, 
        ["small"      ] = step * -1, 
        ["medium"     ] = step * 0, 
        ["large"      ] = step * 1, 
        ["extralarge" ] = step * 2 };
  
      function self.CalculateFontSize(self, fontSize)
        return opt["iconsize"] and self:ConfGet("ICONWIDTH")
               or ((fontSize or self:ConfGet("FONTSIZE"))
                   + font_size_hash[ self:ConfGet(self.setting .. "_FONTSIZE")])
      end;

      if opt["use_font"]
      then 

        function self.SetFont(self, fontFile, fontSize)

          local fontFile = self:ConfGet( opt["use_font"] )
          self.text:SetFont( LibSharedMedia:Fetch("font", fontFile) 
                          or LibSharedMedia:Fetch("font", "Arial Narrow"),
                             self:CalculateFontSize(fontSize));
          self:SetJustify();

        end;

      else

        function self.SetFont(self, fontFile, fontSize)

          fontFile = fontFile or LibSharedMedia:Fetch("font", "Arial Narrow");
          fontSize = self:CalculateFontSize(fontSize);
          self.text:SetFont(fontFile, fontSize);
          self:SetJustify();

        end;

      end;
            
    end;

    --   ---- portrait ----------------------------------------------------------------------------------------
    if   opt["portrait"]
    then 
      local portrait3D = CreateFrame("PlayerModel", nil, self, "ModelWithControlsTemplate");
      local portrait2D = self:CreateTexture(nil, "OVERLAY");

      portrait3D:SetPoint("TOPRIGHT", self, "TOPRIGHT", -5, -5);
      portrait3D:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 5, 5);
      portrait3D:Show();

      portrait2D:SetPoint("LEFT", 5, 0);
      portrait2D:SetPoint("RIGHT", -5, 0);
      portrait2D:SetHeight( portrait2D:GetWidth() );

      portrait2D:Show();

      self.pictureFrame = CreateFrame("Frame", nil, self, BackdropTemplateMixin and "BackdropTemplate");
      self.pictureFrame:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 5, 5);
      self.pictureFrame:SetPoint("TOPRIGHT",   self, "TOPRIGHT", -5, -5);

      self.pictureFrame:SetBackdrop(
      { bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background", 
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border" 
      });

      self.portrait3D = portrait3D;
      self.portrait2D = portrait2D;

      self:GetParent().Portrait = portrait3D;
      self:GetParent().Portrait3D = portrait3D;
      self:GetParent().Portrait2D = portrait2D;

    end;
 
    --   -- tooltips ------------------------------------------------------------------------------------------
    if not opt["no_tooltip"]
    then 

      self:EnableMouse();
      self:SetScript("OnEnter", function(self, ...) self:showTooltip(...) end );
      self:SetScript("OnLeave", function(self, ...) self:hideTooltip(...) end );
      self.tooltip = opt.tooltip;
      
      function self.GetTooltipColor(self, ...) return self:GetParent():Public("GetTooltipColor", ...) end;

      function self.showTooltip(self, event, ...) 
        local tooltip = eval(Config.get(self.tooltip), self.unit, self.unit, RPTAGS.oUF) or "";
        local r, g, b = self:GetTooltipColor();
    
        local striptip = tooltip:gsub("%s", ""):gsub("|cff%x%x%x%x%x%x",""):gsub("|r","");
        if striptip:len() > 0 -- only show a tooltip if there's something to show
        then 
             if   self:ConfGet("MOUSEOVER_CURSOR") then SetCursor("Interface\\CURSOR\\Inspect.PNG"); end;

             GameTooltip:ClearLines();
             GameTooltip:SetOwner(self, "ANCHOR_CURSOR");
             GameTooltip:SetOwner(self, "ANCHOR_PRESERVE");
  
             local lines = split(tooltip, "\n"); -- this is our sneaky way of getting a "title"
             for i, line in ipairs(lines) do GameTooltip:AddLine(line, r, g, b, true) end;
  
             GameTooltip:Show();
        end;
      end; 
  
      function self.hideTooltip(self) GameTooltip:Hide(); ResetCursor(); end;
  
    end;
  
    --   -- context_menu --------------------------------------------------------------------------------------
    if not opt["no_context_menu"]
    then 

      self:SetScript("OnMouseDown",
        function(self, button, ...) 
          if button == "RightButton" then linkHandler("opt://RPUF_Panels/rpufPanels" .. self.name .. "Panel" ) end;
        end);

    end;
  
    --   -- layouts -------------------------------------------------------------------------------------------
    function self.SetLayout(self, layoutName)
      layoutName = layoutName or self:GetLayoutName();

      local  layoutStruct = RPTAGS.utils.frames.RPUF_GetLayout(layoutName);
      if not layoutStruct then return end;

      for key, func in pairs(layoutStruct.panel_methods) do self[key] = func; end; 

      for hashName, hashTable in pairs(layoutStruct.panel_method_hash)
      do  
          local  item = hashTable[self.name];

          if     type(item) == "boolean" or type(item) == "number" 
          then   self[hashName] = function(self) return item end;

          elseif type(item) == "string" and type(hashTable[item]) == "function" 
          then   self[hashName] = hashTable[item];

          elseif type(item) == "string" and (type(hashTable[item]) == "boolean" or type(hashTable[item]) == "number")
          then   self[hashName] = function(self) return hashTable[item] end;

          elseif type(item) == "function" 
          then   self[hashName] = item;

          else   self[hashName] = nil;
          end;
      end;
    end;
 
    --
    --   ------------------------------------------------------------------------------------------------------
  
  end;

  RPTAGS.utils.frames.initialize_panel = initialize_panel;
  
end);
  
