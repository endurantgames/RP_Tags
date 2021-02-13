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
  local FONTSIZE           = 10;
  local FONTFILE           = RPTAGS.CONST.FONT.FIXED;
  local Utils              = RPTAGS.utils;
  local Config             = Utils.config;
  local frameUtils         = Utils.frames;
  local allFrameUtils      = Utils.frames.all;
  local getFrameLayout     = frameUtils.layout.get;
  local getLeftPoint       = frameUtils.panels.layout.getLeft;
  local getTopPoint        = frameUtils.panels.layout.getTop;
  local getPoint           = frameUtils.panels.layout.getPoint;
  local getHeight          = frameUtils.panels.size.getHeight;
  local getWidth           = frameUtils.panels.size.getWidth;
  local getPanelJustifyH   = frameUtils.panels.align.getH;
  local getFrameDimensions = frameUtils.size.get;
  local IP                 = CONST.RPUF.INITIAL_POSITION;
  local loc                = Utils.locale.loc;
  local hilite             = Utils.text.hilite;
  local notify             = Utils.text.notify;
  local refreshAll         = Utils.frames.all.refresh;
  local scaleFrame         = frameUtils.size.scale.set;
  local lockFrames         = frameUtils.all.move.lock;
  local toRGB              = Utils.color.hexaToNumber;
  local FRAME_NAMES        = CONST.FRAMES.NAMES;
  local openEditor         = Utils.config.openEditor;

  if   not Config.get("DISABLE_BLIZZARD") 
  then function oUF:DisableBlizzard() return false end; 
  end; -- prevent oUF from automatically disabling blizzard frames

  -- rpuf tooltip -------------------------------------------------------------------------------------------------------------------------------
  local TTwidth, TTborder, TTpadding = 200, 5, 5;
  local Tooltip = CreateFrame("Frame", "RPUF_Tooltip", UIParent, BackdropTemplateMixin and "BackdropTemplate")
        Tooltip:SetWidth(TTwidth);
        Tooltip:SetHeight(1)
        Tooltip:SetPoint("CENTER");
        Tooltip:SetBackdrop(CONST.BACKDROP.BLIZZTOOLTIP)
        Tooltip:SetBackdropColor(0, 0, 0, 1)
        Tooltip:SetFrameStrata("TOOLTIP")
        Tooltip:Hide();

        function Tooltip:UpdateColors()
          local bgRed, bgGreen, bgBlue = toRGB(Config.get("COLOR_RPUF"));
          self:SetBackdropColor(bgRed / 511, bgGreen / 511, bgBlue /511, 0.5 + Config.get("RPUFALPHA") / 200)
        end;
        Tooltip:UpdateColors();

  local TooltipPanel = CreateFrame('Frame', nil, Tooltip, BackdropTemplateMixin and "BackdropTemplate")
        TooltipPanel:SetFrameLevel(Tooltip:GetFrameLevel() + 1)
        TooltipPanel:SetWidth(TTwidth);
        TooltipPanel:SetHeight(1)
        TooltipPanel:SetPoint("TOPLEFT", Tooltip, "TOPLEFT", 0, 0)
        Tooltip.panel = TooltipPanel;

  local function RPUF_Panel_OnEnter(self)
    if self.tooltip:GetText() and self.tooltip:GetText():gsub("|cff%x%x%x%x%x%x",""):gsub("|r",""):match("^%s+$") then return end; -- don't show the tooltip
    if not self.tooltip:GetText() then return end; -- don't show the tooltip

    self.tooltip:SetPoint("TOPLEFT", Tooltip.panel, "TOPLEFT", TTborder + TTpadding, -1*(TTborder + TTpadding))

    Tooltip:SetHeight(2*TTborder + 2*TTpadding + self.tooltip:GetStringHeight());
    Tooltip.panel:SetHeight(2*TTborder + 2*TTpadding + self.tooltip:GetStringHeight());
    Tooltip:ClearAllPoints();
    Tooltip:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 0);
    Tooltip:Show();
  end; -- function

  local function RPUF_Panel_OnLeave(self)
    -- SetCursor(nil);
    self.tooltip:SetPoint("TOPLEFT", Tooltip.panel, "TOPLEFT", 5000, 5000)
    Tooltip:Hide();
    end;

  -- rpuf Context Menu -------------------------------------------------------------------------------------------------------------------------------------
  local function RPUF_Panel_OnMouseUp(self, button)
    if   button == "RightButton"
    then local contextMenuFrame = CreateFrame("Frame", "RPUF_Panel_ContextMenu", UIParent, "UIDropDownMenuTemplate");
         local contextMenu = { { text = loc("CONTEXT_MENU_TITLE"), isTitle = true, } };
         local subMenu = {};
         if self.source   then table.insert(subMenu, { text = hilite(loc("EDIT_TAGS_FOR").. "[[[" .. loc("CONFIG_"..self.source) .. "]]]"),
                                                       func = function() RPTAGS.utils.rpuf.tags.edit(self.source) contextMenuFrame:Hide();                    end }) end;
         if self.ttsource then table.insert(subMenu, { text = hilite(loc("EDIT_TAGS_FOR").."[["..loc("CONFIG_"..self.ttsource) .."]]"),
                                                       func = function() RPTAGS.utils.rpuf.tags.edit(self.ttsource) contextMenuFrame:Hide();                  end }) end;
         table.insert(contextMenu, { text = loc("USE_TAG_EDITOR"), hasArrow = true, menuList = subMenu, });
         if self.contextmenu then for _, item in ipairs(self.contextmenu) do table.insert(contextMenu, item) end; end; -- if contextmenu
         local unitFrameParent      = self:GetParent();
         if not unitFrameParent.unit then unitFrameParent = unitFrameParent:GetParent() end;
         local unitFrameName        = unitFrameParent:GetName();
         local unitFrameContextMenu = {};
         local layoutOpts           = RPTAGS.cache.layoutOptions[unitFrameName]
         local currentSetting       = RPTAGS.utils.config.get(layoutOpts.config);

         for _, opts in ipairs(layoutOpts.choices)
         do  label, value = unpack(opts);
             table.insert(unitFrameContextMenu,
             { text = label, value = value, checked = value == currentSetting,
               func = function(self) 
                 RPTAGS.utils.config.set(layoutOpts.config, self.value); 
                 RPTAGS.utils.rpuf.allFrames.resize(); 
                 -- RPTAGS.utils.rpuf.allFrames.portraitStyle()
                 contextMenuFrame:Hide(); end 
                 }); -- func
         end; -- for opts

         table.insert(contextMenu,
           { text = hilite(loc("SET_LAYOUT") ..  "[[[" .. loc("CONFIG_" .. RPTAGS.cache.layoutOptions[unitFrameName].config) .. "]]]"),
             hasArrow = true, menuList = unitFrameContextMenu })

         local function setScale(f, s, c) Config.set(c, s) f:SetScale(s); contextMenuFrame:Hide(); f:UpdateAllElements('now') end; 

         local scaleConfig = unitFrameParent.unit .. "FRAME_SCALE";
         scaleConfig = scaleConfig:upper();
         table.insert(contextMenu,
           { text = hilite("Set the " ..  "[[" .. loc("CONFIG_" .. scaleConfig) .. "]]"),
             hasArrow = true,
             menuList = { 
               { text =  "50%", value = 0.50, checked = 0.50 == Config.get(scaleConfig), func = function(self) setScale(unitFrameParent, self.value, scaleConfig) end }, 
               { text =  "75%", value = 0.75, checked = 0.75 == Config.get(scaleConfig), func = function(self) setScale(unitFrameParent, self.value, scaleConfig) end },
               { text =  "90%", value = 0.90, checked = 0.90 == Config.get(scaleConfig), func = function(self) setScale(unitFrameParent, self.value, scaleConfig) end },
               { text = "100%", value = 1.00, checked = 1.00 == Config.get(scaleConfig), func = function(self) setScale(unitFrameParent, self.value, scaleConfig) end },
               { text = "125%", value = 1.25, checked = 1.25 == Config.get(scaleConfig), func = function(self) setScale(unitFrameParent, self.value, scaleConfig) end },
               { text = "150%", value = 1.50, checked = 1.50 == Config.get(scaleConfig), func = function(self) setScale(unitFrameParent, self.value, scaleConfig) end },
               { text = "175%", value = 1.75, checked = 1.75 == Config.get(scaleConfig), func = function(self) setScale(unitFrameParent, self.value, scaleConfig) end },
               { text = "200%", value = 2.00, checked = 2.00 == Config.get(scaleConfig), func = function(self) setScale(unitFrameParent, self.value, scaleConfig) end },
             },
           })

         subMenu = {};
         if   Config.get("RPUF_HIDE")
         then table.insert(subMenu, { text = loc("CONTEXT_SHOW_FRAMES"), func = function(self) Config.set("RPUF_HIDE", false); RPTAGS.utils.rpuf.allFrames.visibility(); end });
         else table.insert(subMenu, { text = loc("CONTEXT_HIDE_FRAMES"), func = function(self) Config.set("RPUF_HIDE", true ); RPTAGS.utils.rpuf.allFrames.visibility(); end });
         end;
         if   Config.get("LOCK_FRAMES")
         then table.insert(subMenu, { text = loc("CONTEXT_UNLOCK_FRAMES"), func = function(self) Config.set("LOCK_FRAMES", false); RPTAGS.utils.rpuf.allFrames.lock(); end });
         else table.insert(subMenu, { text = loc("CONTEXT_LOCK_FRAMES"),   func = function(self) Config.set("LOCK_FRAMES", true);  RPTAGS.utils.rpuf.allFrames.lock(); end });
         end -- if
         table.insert(contextMenu, { text = loc("QUICK_SETTINGS"), hasArrow = true, menuList = subMenu, });

         table.insert(contextMenu,
           { text = loc("RPTAGS_OPTIONS"),
             hasArrow = true,
             menuList = { 
               { text = loc("RP_REFERENCE"),
                 func = function() contextMenuFrame:Hide() InterfaceOptionsFrame_Show(); InterfaceOptionsFrame_OpenToCategory(RPTAGS_Main_OptionsPanel)         end },
               { text = loc("OPT_MENU_GENERAL"),
                 func = function() contextMenuFrame:Hide() InterfaceOptionsFrame_Show(); InterfaceOptionsFrame_OpenToCategory(RPTAGS_General_OptionsPanel)      end },
               { text = loc("OPT_MENU_COLORS"),
                 func = function() contextMenuFrame:Hide() InterfaceOptionsFrame_Show(); InterfaceOptionsFrame_OpenToCategory(RPTAGS_Colors_OptionsPanel)       end },
               { text = loc("OPT_MENU_RPUF_MAIN"),
                 func = function() contextMenuFrame:Hide() InterfaceOptionsFrame_Show(); InterfaceOptionsFrame_OpenToCategory(RPTAGS_RPUnitFrames_OptionsPanel) end },
               { text = loc("OPT_MENU_RPUF_LAYOUT"),
                 func = function() contextMenuFrame:Hide() InterfaceOptionsFrame_Show(); InterfaceOptionsFrame_OpenToCategory(RPTAGS_Layout_OptionsPanel)       end },
               { text = loc("OPT_MENU_RPUF_PANELS"),
                 func = function() contextMenuFrame:Hide() InterfaceOptionsFrame_Show(); InterfaceOptionsFrame_OpenToCategory(RPTAGS_Tags_OptionsPanel)         end },
             }});

         table.insert(contextMenu, { text = loc("CANCEL"), func = function() contextMenuFrame:Hide() end });
         if   self.source or self.ttsource or self.contextmenu then EasyMenu(contextMenu, contextMenuFrame, "cursor", 0, 0, "MENU") end; -- if source or ttsource

       end; -- if rightbutton
  end; -- function

  -- rpuf "style" for oUF ----------------------------------------------------------------------------------------------------------------------------------
  local function RPUF_Style(self, unit)

    local fix = RPTAGS.utils.tags.fix;
          unit = unit:match('^(.-)%d+') or unit
    local layout = getFrameLayout(self);
    local framewidth, frameheight = getFrameDimensions(layout);
          self:RegisterForClicks('AnyUp');
          self:SetScript('OnEnter', UnitFrame_OnEnter);
          self:SetScript('OnLeave', UnitFrame_OnLeave);
          self:SetHeight(frameheight);
          self:SetWidth( framewidth );
          self:SetClampedToScreen(true);

    local content = CreateFrame('Frame', nil, self, BackdropTemplateMixin and "BackdropTemplate");
          self.content = content;

          content.frameType = "RPUF";
          content.tooltips    = {};
          content.layout = layout;
          content.fontStrings = {};

          content:SetWidth( framewidth );
          content:SetHeight(frameheight);


    if unit == "targettarget" then content.onUpdateFrequency = 10; end; 

    local bgRed, bgGreen, bgBlue = toRGB(Config.get("COLOR_RPUF"));
          content:SetBackdrop(RPTAGS.CONST.BACKDROP[RPTAGS.utils.config.get("RPUF_BACKDROP")])
          content:SetBackdropColor(bgRed / 255, bgGreen / 255, bgBlue / 255, Config.get("RPUFALPHA") / 100)

    local NamePanel = CreateFrame('Frame', nil, content, BackdropTemplateMixin and "BackdropTemplate") NamePanel:SetFrameLevel(20) content.NamePanel = NamePanel;
          NamePanel:SetPoint('TOPLEFT', content, 'TOPLEFT', getLeftPoint('NamePanel', layout), getTopPoint('NamePanel', layout))
          NamePanel:SetSize(getWidth('NamePanel', layout), getHeight('NamePanel', layout));

    local NameFontString = content.NamePanel:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightLarge')
          tinsert(content.fontStrings, NameFontString);
          NamePanel.text = NameFontString;
          NameFontString.setting = "NAMEPANEL";
          NameFontString:SetJustifyH(getPanelJustifyH("NamePanel", layout))
          NameFontString:SetJustifyV('TOP')
          NameFontString:SetSize(getWidth('NamePanel', layout), getHeight('NamePanel', layout));
          NameFontString:SetFont(FONTFILE, FONTSIZE + 4);
          NameFontString:SetPoint("TOPLEFT", NamePanel, "TOPLEFT", 0, 0);
          self:Tag(NameFontString, fix(Config.get("NAMEPANEL")))

    local NameTooltip       = Tooltip.panel:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
          NamePanel.tooltip = NameTooltip;
          tinsert(content.tooltips, NameTooltip);
          NameTooltip:SetPoint("TOPLEFT", Tooltip.panel, "TOPLEFT", 5000, 5000)
          NameTooltip:SetWidth(TTwidth - 2*TTborder - 2*TTpadding);
          NameTooltip:SetJustifyH('LEFT')
          NameTooltip:SetJustifyV('TOP')
          NameTooltip:SetWordWrap(true);
          NameTooltip.setting = "NAME_TOOPTIP";
          NamePanel.ttsource = "NAME_TOOLTIP"
          self:Tag(NameTooltip, fix(Config.get(NamePanel.ttsource)))
          NamePanel:SetScript("OnEnter", RPUF_Panel_OnEnter);
          NamePanel:SetScript("OnLeave", RPUF_Panel_OnLeave);
          NamePanel.source = "NAMEPANEL";
          NamePanel:SetScript("OnMouseUp", RPUF_Panel_OnMouseUp);
          -- ---------------------------------------------------------------------------------------------------------
    local InfoPanel = CreateFrame('Frame', nil, content, BackdropTemplateMixin and "BackdropTemplate") InfoPanel:SetFrameLevel(20) content.InfoPanel = InfoPanel;
          InfoPanel:SetPoint('TOPLEFT', content, 'TOPLEFT', getLeftPoint('InfoPanel', layout), getTopPoint('InfoPanel', layout))
          InfoPanel:SetSize(getWidth('InfoPanel', layout), getHeight('InfoPanel', layout));

    local InfoFontString = content.InfoPanel:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
          InfoPanel.text = InfoFontString;
          tinsert(content.fontStrings, InfoFontString);
          InfoFontString.setting = "INFOPANEL";
          InfoFontString:SetPoint("TOPLEFT", InfoPanel, "TOPLEFT", 0, 0);
          InfoFontString:SetJustifyH(getPanelJustifyH("InfoPanel", layout))
          InfoFontString:SetJustifyV('TOP')
          InfoFontString:SetWidth(getWidth('InfoPanel', layout));
          InfoFontString:SetHeight(getHeight('InfoPanel', layout));
          InfoFontString:SetFont(FONTFILE, FONTSIZE + 2);
          self:Tag(InfoFontString, fix(Config.get("INFOPANEL")))

    local InfoTooltip       = Tooltip.panel:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
          InfoPanel.tooltip = InfoTooltip;
          tinsert(content.tooltips, InfoTooltip);
          InfoTooltip:SetPoint("TOPLEFT", Tooltip.panel, "TOPLEFT", 5000, 5000)
          InfoTooltip:SetWidth(TTwidth - 2*TTborder - 2*TTpadding);
          InfoTooltip:SetJustifyH('LEFT')
          InfoTooltip:SetJustifyV('TOP')
          InfoTooltip:SetWordWrap(true);
          InfoTooltip.setting = "INFO_TOOLTIP";
          InfoPanel.ttsource = "INFO_TOOLTIP"
          self:Tag(InfoTooltip, fix(Config.get(InfoPanel.ttsource)))
          InfoPanel:SetScript("OnEnter", RPUF_Panel_OnEnter);
          InfoPanel:SetScript("OnLeave", RPUF_Panel_OnLeave);
          InfoPanel.source = "INFOPANEL";
          InfoPanel:SetScript("OnMouseUp", RPUF_Panel_OnMouseUp);
          -- ---------------------------------------------------------------------------------------------------------
    local DetailsPanel = CreateFrame('Frame', nil, content, BackdropTemplateMixin and "BackdropTemplate") DetailsPanel:SetFrameLevel(20) content.DetailsPanel = DetailsPanel;
          DetailsPanel:SetPoint('TOPLEFT', content, 'TOPLEFT', getLeftPoint('DetailsPanel', layout), getTopPoint('DetailsPanel', layout));
          DetailsPanel:SetSize(getWidth('DetailsPanel', layout), getHeight('DetailsPanel', layout));

    local DetailsFontString = content.DetailsPanel:CreateFontString(nil, 'OVERLAY', 'GameFontNormal');
          DetailsPanel.text = DetailsFontString;
          tinsert(content.fontStrings, DetailsFontString);
          DetailsFontString:SetPoint("TOPLEFT", DetailsPanel, "TOPLEFT", 0, 0);
          DetailsFontString:SetJustifyH('LEFT');
          DetailsFontString.setting = "DETAILPANEL";
          DetailsFontString:SetJustifyV('TOP');
          DetailsFontString:SetWordWrap(true);
          DetailsFontString:SetWidth(getWidth('DetailsPanel', layout));
          DetailsFontString:SetHeight(getHeight('DetailsPanel', layout));
          self:Tag(DetailsFontString, fix(Config.get("DETAILPANEL")));

    local DetailsTooltip       = Tooltip.panel:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
          DetailsPanel.tooltip = DetailsTooltip;
          tinsert(content.tooltips, DetailsTooltip);
          DetailsTooltip:SetPoint("TOPLEFT", Tooltip.panel, "TOPLEFT", 5000, 5000)
          DetailsTooltip:SetWidth(TTwidth - 2*TTborder - 2*TTpadding);
          DetailsTooltip:SetJustifyH('LEFT')
          DetailsTooltip:SetJustifyV('TOP')
          DetailsTooltip:SetWordWrap(true);
          DetailsTooltip.setting = "DETAIL_TOOLTIP";
          DetailsPanel.ttsource = "DETAIL_TOOLTIP"
          self:Tag(DetailsTooltip, fix(Config.get(DetailsPanel.ttsource)))
          DetailsPanel:SetScript("OnEnter", RPUF_Panel_OnEnter);
          DetailsPanel:SetScript("OnLeave", RPUF_Panel_OnLeave);
          DetailsPanel.source = "DETAILPANEL";
          DetailsPanel:SetScript("OnMouseUp", RPUF_Panel_OnMouseUp);
          -- ---------------------------------------------------------------------------------------------------------
    local PortraitPanel = CreateFrame('FRAME', nil, content, BackdropTemplateMixin and "BackdropTemplate")
          PortraitPanel:SetPoint("TOPLEFT", content, 'TOPLEFT', getLeftPoint('PortraitPanel', layout), getTopPoint('PortraitPanel', layout));
          PortraitPanel:SetWidth(getWidth('PortraitPanel', layout))
          PortraitPanel:SetHeight(getHeight('PortraitPanel', layout))
          content.PortraitPanel = PortraitPanel;

    local PortraitBackground = PortraitPanel:CreateTexture(nil, "BACKGROUND");
          PortraitBackground:SetTexture("Interface\\GLUES\\Models\\UI_VoidElf\\6sm_starMaskGradient")
          PortraitBackground:SetRotation(math.pi)
          PortraitBackground:SetAllPoints()
          PortraitBackground:SetVertexColor(bgRed / 255, bgGreen / 255, bgBlue / 255, Config.get("RPUFALPHA"));
          content.PortraitBackground = PortraitBackground;

    local Portrait = CreateFrame('PlayerModel', nil, PortraitPanel, BackdropTemplateMixin and "BackdropTemplate")
          Portrait:SetPoint("TOPLEFT",     PortraitPanel, "TOPLEFT",      1, -1);
          Portrait:SetPoint("BOTTOMRIGHT", PortraitPanel, "BOTTOMRIGHT", -1,  1);
          -- Portrait:SetPoint("TOPLEFT", content, 'TOPLEFT', getLeftPoint('Portrait', layout), getTopPoint('Portrait', layout));
          -- Portrait:SetFrameLevel(PortraitPanel:GetFrameLevel() - 1)
          content.Portrait = Portrait;

    local PortraitTooltip       = Tooltip.panel:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
          Portrait.tooltip = PortraitTooltip;
          tinsert(content.tooltips, PortraitTooltip);
          PortraitTooltip:SetPoint("TOPLEFT", Tooltip.panel, "TOPLEFT", 5000, 5000)
          PortraitTooltip:SetWidth(TTwidth - 2*TTborder - 2*TTpadding);
          PortraitTooltip:SetJustifyH('LEFT')
          PortraitTooltip:SetJustifyV('TOP')
          PortraitTooltip.setting = "PORTRAIT_TOOLTIP";
          PortraitTooltip:SetWordWrap(true);
          Portrait.ttsource = "PORTRAIT_TOOLTIP"
          self:Tag(PortraitTooltip, fix(Config.get(Portrait.ttsource)))
          Portrait:SetScript("OnEnter", RPUF_Panel_OnEnter);
          Portrait:SetScript("OnLeave", RPUF_Panel_OnLeave);
          Portrait:SetScript("OnMouseUp", RPUF_Panel_OnMouseUp);
--           local portraitEvent;
--           if     unit == "target" then portraitEvent = "PLAYER_TARGET_CHANGED";
--           elseif unit == "focus"  then portraitEvent = "PLAYER_FOCUS_CHANGED";
--           elseif unit == "player" then portraitEvent = "PLAYER_ENTERING_WORLD";
--           elseif unit == "player" then portraitEvent = "PORTRAITS_UPDATED";
--           end;
--           Portrait.portraitEvent = portraitEvent;
--           Portrait.camera = 0;
--           Portrait:RegisterEvent(portraitEvent);
--           Portrait:SetScript("OnEvent", function(content, event) if event == content.portraitEvent then RPTAGS.utils.rpuf.frame.portraitStyle(content:GetParent()) end; end); -- ##

          -- ---------------------------------------------------------------------------------------------------------
    local Icon_1Panel = CreateFrame('Frame', nil, content, BackdropTemplateMixin and "BackdropTemplate") Icon_1Panel:SetFrameLevel(20) content.Icon_1Panel = Icon_1Panel;
          Icon_1Panel:SetPoint('TOPLEFT', content, 'TOPLEFT', getLeftPoint('Icon_1Panel', layout), getTopPoint('Icon_1Panel', layout))
          Icon_1Panel:SetSize(getWidth('Icon_1Panel', layout), getHeight('Icon_1Panel', layout));

    local Icon_1FontString = content.Icon_1Panel:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightLarge')
          Icon_1Panel.text = Icon_1FontString;
          tinsert(content.fontStrings, Icon_1FontString);
          Icon_1FontString:SetPoint("TOPLEFT", Icon_1Panel, "TOPLEFT", 0, 0);
          Icon_1FontString:SetJustifyH('LEFT')
          Icon_1FontString:SetJustifyV('TOP')
          Icon_1FontString.setting = "ICON_1";
          Icon_1FontString:SetWordWrap(false)
          Icon_1FontString:SetFont(FONTFILE, getWidth('Icon_1Panel', layout) -1 )
          self:Tag(Icon_1FontString, fix(Config.get("ICON_1")))

    local Icon_1Tooltip       = Tooltip.panel:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
          Icon_1Panel.tooltip = Icon_1Tooltip;
          tinsert(content.tooltips, Icon_1Tooltip);
          Icon_1Tooltip:SetPoint("TOPLEFT", Tooltip.panel, "TOPLEFT", 5000, 5000)
          Icon_1Tooltip:SetWidth(TTwidth - 2*TTborder - 2*TTpadding);
          Icon_1Tooltip:SetJustifyH('LEFT')
          Icon_1Tooltip:SetJustifyV('TOP')
          Icon_1Tooltip.setting = "ICON_1_TOOLTIP";
          Icon_1Tooltip:SetWordWrap(true);
          Icon_1Panel.ttsource = "ICON_1_TOOLTIP"
          self:Tag(Icon_1Tooltip, fix(Config.get(Icon_1Panel.ttsource)))
          Icon_1Panel:SetScript("OnEnter", RPUF_Panel_OnEnter);
          Icon_1Panel:SetScript("OnLeave", RPUF_Panel_OnLeave);
          Icon_1Panel.source = "ICON_1";
          Icon_1Panel:SetScript("OnMouseUp", RPUF_Panel_OnMouseUp);
          -- ---------------------------------------------------------------------------------------------------------
    local Icon_2Panel = CreateFrame('Frame', nil, content, BackdropTemplateMixin and "BackdropTemplate") Icon_2Panel:SetFrameLevel(20) content.Icon_2Panel = Icon_2Panel;
          Icon_2Panel:SetPoint('TOPLEFT', content, 'TOPLEFT', getLeftPoint('Icon_2Panel', layout), getTopPoint('Icon_2Panel', layout));
          Icon_2Panel:SetSize(getWidth('Icon_2Panel', layout), getHeight('Icon_2Panel', layout));

    local Icon_2FontString = content.Icon_2Panel:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
          Icon_2Panel.text = Icon_2FontString;
          Icon_2FontString:SetPoint("TOPLEFT", Icon_2Panel, "TOPLEFT", 0, 0);
          Icon_2FontString:SetJustifyH('LEFT')
          Icon_2FontString:SetJustifyV('TOP')
          Icon_2FontString.setting = "ICON_2";
          tinsert(content.fontStrings, Icon_2FontString);
          Icon_2FontString:SetWordWrap(false)
          Icon_2FontString:SetFont(FONTFILE, getWidth('Icon_2Panel', layout) -1 )
          self:Tag(Icon_2FontString, fix(Config.get("ICON_2")))

    local Icon_2Tooltip       = Tooltip.panel:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
          Icon_2Panel.tooltip = Icon_2Tooltip;
          tinsert(content.tooltips, Icon_2Tooltip);
          Icon_2Tooltip:SetPoint("TOPLEFT", Tooltip.panel, "TOPLEFT", 5000, 5000)
          Icon_2Tooltip:SetWidth(TTwidth - 2*TTborder - 2*TTpadding);
          Icon_2Tooltip:SetJustifyH('LEFT')
          Icon_2Tooltip:SetJustifyV('TOP')
          Icon_2Tooltip:SetWordWrap(true);
          Icon_2Tooltip.setting = "ICON_2_TOOLTIP";
          Icon_2Panel.ttsource = "ICON_2_TOOLTIP"
          self:Tag(Icon_2Tooltip, fix(Config.get(Icon_2Panel.ttsource)))
          Icon_2Panel:SetScript("OnEnter", RPUF_Panel_OnEnter);
          Icon_2Panel:SetScript("OnLeave", RPUF_Panel_OnLeave);
          Icon_2Panel.source = "ICON_2";
          Icon_2Panel:SetScript("OnMouseUp", RPUF_Panel_OnMouseUp);
          -- ---------------------------------------------------------------------------------------------------------
    local Icon_3Panel = CreateFrame('Frame', nil, content, BackdropTemplateMixin and "BackdropTemplate") Icon_3Panel:SetFrameLevel(20) content.Icon_3Panel = Icon_3Panel;
          Icon_3Panel:SetPoint('TOPLEFT', content, 'TOPLEFT', getLeftPoint('Icon_3Panel', layout), getTopPoint('Icon_3Panel', layout));
          Icon_3Panel:SetSize(getWidth('Icon_3Panel', layout), getHeight('Icon_3Panel', layout));

    local Icon_3FontString = content.Icon_3Panel:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
          Icon_3Panel.text = Icon_3FontString;
          Icon_3FontString:SetPoint("TOPLEFT", Icon_3Panel, "TOPLEFT", 0, 0);
          Icon_3FontString:SetJustifyH('LEFT')
          Icon_3FontString:SetJustifyV('TOP')
          tinsert(content.fontStrings, Icon_3FontString);
          Icon_3FontString.setting = "ICON_3";
          Icon_3FontString:SetWordWrap(false)
          Icon_3FontString:SetFont(FONTFILE, getWidth('Icon_3Panel', layout) -1 )
          self:Tag(Icon_3FontString, fix(Config.get("ICON_3")))

    local Icon_3Tooltip       = Tooltip.panel:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
          Icon_3Panel.tooltip = Icon_3Tooltip;
          tinsert(content.tooltips, Icon_3Tooltip);
          Icon_3Tooltip:SetPoint("TOPLEFT", Tooltip.panel, "TOPLEFT", 5000, 5000)
          Icon_3Tooltip:SetWidth(TTwidth - 2*TTborder - 2*TTpadding);
          Icon_3Tooltip:SetJustifyH('LEFT')
          Icon_3Tooltip.setting = "ICON_3_TOOLTIP";
          Icon_3Tooltip:SetJustifyV('TOP')
          Icon_3Tooltip:SetWordWrap(true);
          Icon_3Panel.ttsource = "ICON_3_TOOLTIP"
          self:Tag(Icon_3Tooltip, fix(Config.get(Icon_3Panel.ttsource)))
          Icon_3Panel:SetScript("OnEnter", RPUF_Panel_OnEnter);
          Icon_3Panel:SetScript("OnLeave", RPUF_Panel_OnLeave);
          Icon_3Panel.source = "ICON_3";
          Icon_3Panel:SetScript("OnMouseUp", RPUF_Panel_OnMouseUp);
          -- ---------------------------------------------------------------------------------------------------------
    local Icon_4Panel = CreateFrame('Frame', nil, content, BackdropTemplateMixin and "BackdropTemplate") Icon_4Panel:SetFrameLevel(20) content.Icon_4Panel = Icon_4Panel;
          Icon_4Panel:SetPoint('TOPLEFT', content, 'TOPLEFT', getLeftPoint('Icon_4Panel', layout), getTopPoint('Icon_4Panel', layout));
          Icon_4Panel:SetSize(getWidth('Icon_4Panel', layout), getHeight('Icon_4Panel', layout));

    local Icon_4FontString = content.Icon_4Panel:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
          Icon_4Panel.text = Icon_4FontString;
          Icon_4FontString:SetPoint("TOPLEFT", Icon_4Panel, "TOPLEFT", 0, 0);
          Icon_4FontString:SetJustifyH('LEFT')
          tinsert(content.fontStrings, Icon_4FontString);
          Icon_4FontString.setting = "ICON_4";
          Icon_4FontString:SetJustifyV('TOP')
          Icon_4FontString:SetWordWrap(false)
          Icon_4FontString:SetFont(FONTFILE, getWidth('Icon_4Panel', layout) -1 )
          self:Tag(Icon_4FontString, fix(Config.get("ICON_4")))

    local Icon_4Tooltip       = Tooltip.panel:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
          Icon_4Panel.tooltip = Icon_4Tooltip;
          Icon_4Tooltip:SetPoint("TOPLEFT", Tooltip.panel, "TOPLEFT", 5000, 5000)
          Icon_4Tooltip:SetWidth(TTwidth - 2*TTborder - 2*TTpadding);
          Icon_4Tooltip:SetJustifyH('LEFT')
          tinsert(content.tooltips, Icon_4Tooltip);
          Icon_4Tooltip:SetJustifyV('TOP')
          Icon_4Tooltip.setting = "ICON_4_TOOLTIP";
          Icon_4Tooltip:SetWordWrap(true);
          Icon_4Panel.ttsource = "ICON_4_TOOLTIP"
          self:Tag(Icon_4Tooltip, fix(Config.get(Icon_4Panel.ttsource)))
          Icon_4Panel:SetScript("OnEnter", RPUF_Panel_OnEnter);
          Icon_4Panel:SetScript("OnLeave", RPUF_Panel_OnLeave);
          Icon_4Panel.source = "ICON_4";
          Icon_4Panel:SetScript("OnMouseUp", RPUF_Panel_OnMouseUp);
          -- ---------------------------------------------------------------------------------------------------------
    local Icon_5Panel = CreateFrame('Frame', nil, content, BackdropTemplateMixin and "BackdropTemplate") Icon_5Panel:SetFrameLevel(20) content.Icon_5Panel = Icon_5Panel;
          Icon_5Panel:SetPoint('TOPLEFT', content, 'TOPLEFT', getLeftPoint('Icon_5Panel', layout), getTopPoint('Icon_5Panel', layout));
          Icon_5Panel:SetSize(getWidth('Icon_5Panel', layout), getHeight('Icon_5Panel', layout));

    local Icon_5FontString = content.Icon_5Panel:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
          Icon_5Panel.text = Icon_5FontString;
          Icon_5FontString:SetPoint("TOPLEFT", Icon_5Panel, "TOPLEFT", 0, 0);
          Icon_5FontString:SetJustifyH('LEFT')
          Icon_5FontString.setting = "ICON_5";
          Icon_5FontString:SetJustifyV('TOP')
          Icon_5FontString:SetWordWrap(false)
          Icon_5FontString:SetFont(FONTFILE, getWidth('Icon_5Panel', layout) -1 )
          self:Tag(Icon_5FontString, fix(Config.get("ICON_5")))
          tinsert(content.fontStrings, Icon_5FontString);

    local Icon_5Tooltip       = Tooltip.panel:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
          Icon_5Panel.tooltip = Icon_5Tooltip;
          Icon_5Tooltip:SetPoint("TOPLEFT", Tooltip.panel, "TOPLEFT", 5000, 5000)
          Icon_5Tooltip:SetWidth(TTwidth - 2*TTborder - 2*TTpadding);
          tinsert(content.tooltips, Icon_5Tooltip);
          Icon_5Tooltip:SetJustifyH('LEFT')
          Icon_5Tooltip.setting = "ICON_5_TOOLTIP";
          Icon_5Tooltip:SetJustifyV('TOP')
          Icon_5Tooltip:SetWordWrap(true);
          Icon_5Panel.ttsource = "ICON_5_TOOLTIP"
          self:Tag(Icon_5Tooltip, fix(Config.get(Icon_5Panel.ttsource)))
          Icon_5Panel:SetScript("OnEnter", RPUF_Panel_OnEnter);
          Icon_5Panel:SetScript("OnLeave", RPUF_Panel_OnLeave);
          Icon_5Panel.source = "ICON_5";
          Icon_5Panel:SetScript("OnMouseUp", RPUF_Panel_OnMouseUp);
          -- ---------------------------------------------------------------------------------------------------------
    local Icon_6Panel = CreateFrame('Frame', nil, content, BackdropTemplateMixin and "BackdropTemplate") Icon_6Panel:SetFrameLevel(20) content.Icon_6Panel = Icon_6Panel;
          Icon_6Panel:SetPoint('TOPLEFT', content, 'TOPLEFT', getLeftPoint('Icon_6Panel', layout), getTopPoint('Icon_6Panel', layout));
          Icon_6Panel:SetSize(getWidth('Icon_6Panel', layout), getHeight('Icon_6Panel', layout));

    local Icon_6FontString = content.Icon_6Panel:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
          Icon_6Panel.text = Icon_6FontString;
          Icon_6FontString:SetPoint("TOPLEFT", Icon_6Panel, "TOPLEFT", 0, 0);
          Icon_6FontString:SetJustifyH('LEFT')
          Icon_6FontString:SetJustifyV('TOP')
          Icon_6FontString.setting = "ICON_6";
          tinsert(content.fontStrings, Icon_6FontString);
          Icon_6FontString:SetWordWrap(false)
          Icon_6FontString:SetFont(FONTFILE, getWidth('Icon_6Panel', layout) -1 )
          self:Tag(Icon_6FontString, fix(Config.get("ICON_6")))

    local Icon_6Tooltip       = Tooltip.panel:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
          Icon_6Panel.tooltip = Icon_6Tooltip;
          Icon_6Tooltip:SetPoint("TOPLEFT", Tooltip.panel, "TOPLEFT", 5000, 5000)
          Icon_6Tooltip:SetWidth(TTwidth - 2*TTborder - 2*TTpadding);
          tinsert(content.tooltips, Icon_6Tooltip);
          Icon_6Tooltip:SetJustifyH('LEFT')
          Icon_6Tooltip.setting = "ICON_6_TOOLTIP";
          Icon_6Tooltip:SetJustifyV('TOP')
          Icon_6Tooltip:SetWordWrap(true);
          Icon_6Panel.ttsource = "ICON_6_TOOLTIP"
          self:Tag(Icon_6Tooltip, fix(Config.get(Icon_6Panel.ttsource)))
          Icon_6Panel:SetScript("OnEnter", RPUF_Panel_OnEnter);
          Icon_6Panel:SetScript("OnLeave", RPUF_Panel_OnLeave);
          Icon_6Panel.source = "ICON_6";
          Icon_6Panel:SetScript("OnMouseUp", RPUF_Panel_OnMouseUp);
          -- ---------------------------------------------------------------------------------------------------------
    local StatusBarPanel = CreateFrame('Frame', nil, content, BackdropTemplateMixin and "BackdropTemplate") StatusBarPanel:SetFrameLevel(20) content.StatusBarPanel = StatusBarPanel;
          StatusBarPanel:SetPoint('TOPLEFT', content, 'TOPLEFT', getLeftPoint('StatusBarPanel', layout), getTopPoint('StatusBarPanel', layout));
          StatusBarPanel:SetSize(getWidth('StatusBarPanel', layout), getHeight('StatusBarPanel', layout));
          content.StatusBarPanel = StatusBarPanel;
          bgRed, bgGreen, bgBlue = toRGB(Config.get("COLOR_RPUF"));
          StatusBarPanel:SetBackdrop(RPTAGS.CONST.STATUSBAR_TEXTURE[Config.get("STATUS_TEXTURE")]);
          StatusBarPanel:SetBackdropColor(bgRed / 255, bgGreen / 255, bgBlue / 255, RPTAGS.CONST.STATUSBAR_ALPHA[Config.get("STATUS_TEXTURE")]);

    local StatusBarFontString = content.StatusBarPanel:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
          StatusBarPanel.text = StatusBarFontString;
          StatusBarFontString:SetJustifyH(RPTAGS.CONST.ALIGN[Config.get("STATUS_ALIGN")].H);
          StatusBarFontString:SetPoint("TOPLEFT", StatusBarPanel, "TOPLEFT", Config.get("GAPSIZE"), Config.get("GAPSIZE") / -2);
          StatusBarFontString:SetJustifyH(RPTAGS.CONST.ALIGN[Config.get("STATUS_ALIGN")].H);
          StatusBarFontString:SetJustifyV(RPTAGS.CONST.ALIGN[Config.get("STATUS_ALIGN")].V);
          StatusBarFontString.setting = "STATUSPANEL";
          tinsert(content.fontStrings, StatusBarFontString);
          StatusBarFontString:SetWordWrap(true);
          StatusBarFontString:SetSize(getWidth('StatusBarPanel', layout) - Config.get("GAPSIZE") * 2, getHeight('StatusBarPanel', layout) - Config.get("GAPSIZE"));
          self:Tag(StatusBarFontString, fix(Config.get("STATUSPANEL")))

    local StatusBarTooltip       = Tooltip.panel:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
          StatusBarPanel.tooltip = StatusBarTooltip;
          StatusBarTooltip:SetPoint("TOPLEFT", Tooltip.panel, "TOPLEFT", 5000, 5000)
          StatusBarTooltip:SetWidth(TTwidth - 2*TTborder - 2*TTpadding);
          tinsert(content.tooltips, StatusBarTooltip);
          StatusBarTooltip:SetJustifyH('LEFT')
          StatusBarTooltip:SetJustifyV('TOP')
          StatusBarTooltip:SetWordWrap(true);
          StatusBarTooltip.setting = "STATUS_TOOLTIP";
          StatusBarPanel.ttsource = "STATUS_TOOLTIP"
          self:Tag(StatusBarTooltip, fix(Config.get(StatusBarPanel.ttsource)))
          StatusBarPanel:SetScript("OnEnter", RPUF_Panel_OnEnter);
          StatusBarPanel:SetScript("OnLeave", RPUF_Panel_OnLeave);
          StatusBarPanel.source = "STATUSPANEL";
          StatusBarPanel:SetScript("OnMouseUp", RPUF_Panel_OnMouseUp);

    -- Drag panel for moving the frame -------------------------------------------------------------------------
    local DragFrame = CreateFrame("frame", nil, content, BackdropTemplateMixin and "BackdropTemplate")
          content.DragFrame = DragFrame;
          DragFrame:SetBackdrop(RPTAGS.CONST.BACKDROP.BLIZZTOOLTIP)
          DragFrame:SetBackdropColor(0, 0, 0, 1)
          DragFrame:SetSize(50, 72);
          DragFrame:SetPoint("TOPRIGHT", content, "TOPLEFT", 5, 0)

          DragFrame:SetScript("OnMouseDown",
            function(content) content:GetParent():SetMovable(true); content:GetParent():EnableMouse(true); content:GetParent():StartMoving(); end);
          DragFrame:SetScript("OnMouseUp",
            function(content)
              content:GetParent():SetMovable(false);
              content:GetParent():EnableMouse(false);
              content:GetParent():StopMovingOrSizing();
              local point, relativeTo, relativePoint, xOfs, yOfs = content:GetParent():GetPoint()
              if relativeTo == nil then relativeTo = "UIParent" else relativeTo = relativeTo:GetName(); end;
              RP_TagsDB[content:GetParent().unit .. "UFlocation"] = { point, relativeTo, relativePoint, xOfs, yOfs };
            end);
          if Config.get("LOCK_FRAMES") then DragFrame:Hide() end;
    local DragFrameArrows = DragFrame:CreateTexture();
          DragFrameArrows:SetTexture([[Interface\Cursor\UI-Cursor-Move]]);
          DragFrameArrows:SetSize(36,36);
          DragFrameArrows:SetPoint("TOP", DragFrame, "TOP", 0, -9);
    local DragFrameLockButton = CreateFrame("button", nil, DragFrame, BackdropTemplateMixin and "BackdropTemplate")
          DragFrameLockButton:SetSize(26,26);
          DragFrameLockButton:SetNormalAtlas("Garr_LockedBuilding");
          DragFrameLockButton:SetPoint("BOTTOMRIGHT", DragFrame, "BOTTOMRIGHT", -1, 2);
          DragFrameLockButton:SetScript("OnClick", function(content) Config.set("LOCK_FRAMES", true); lockFrames() end);
    local DragFrameResetButton = CreateFrame("button", nil, DragFrame, BackdropTemplateMixin and "BackdropTemplate")
          DragFrameResetButton:SetSize(24,24);
          DragFrameResetButton:SetNormalAtlas("transmog-icon-revert")
          DragFrameResetButton:SetPoint("BOTTOMLEFT", DragFrame, "BOTTOMLEFT", 4, 3);
          DragFrameResetButton:SetScript("OnClick",
            function(content)
              local frame = content:GetParent():GetParent();
              local IP = RPTAGS.CONST.RPUF.INITIAL_POSITION[frame.unit];
              frame:ClearAllPoints();
              frame:SetPoint(IP.pt, _G[IP.relto], IP.relpt, IP.x, IP.y);
              RP_TagsDB[frame.unit .. "UFlocation"] = nil;
            end);
     local ttRed, ttGreen, ttBlue = toRGB(Config.get("COLOR_RPUF_TOOLTIP"));
     for _, tt in ipairs(content.tooltips)    do tt:SetTextColor(ttRed / 255, ttGreen / 255, ttBlue / 255) end;
     local txRed, txGreen, txBlue = toRGB(Config.get("COLOR_RPUF_TEXT"));
     for _, tx in ipairs(content.fontStrings) do tx:SetTextColor(txRed / 255, txGreen / 255, txBlue / 255) end;
          -- ---------------------------------------------------------------------------------------------------------
  end;

  local function GetRightLocation(framename)
    if not  RP_TagsDB[framename .. "UFlocation"]
       then return IP[framename].pt, _G[IP[framename].relto], IP[framename].relpt, IP[framename].x, IP[framename].y 
       else return RP_TagsDB[framename .. "UFlocation"][1]  or IP[framename].pt,
                _G[RP_TagsDB[framename .. "UFlocation"][2]] or UIParent,
                   RP_TagsDB[framename .. "UFlocation"][3]  or IP[framename].relpt,
                   RP_TagsDB[framename .. "UFlocation"][4]  or IP[framename].x,
                   RP_TagsDB[framename .. "UFlocation"][5]  or IP[framename].y
       end;
  end;

  oUF:RegisterStyle('RP_Tags', RPUF_Style)

  oUF:Factory(
    function(self)
      self:SetActiveStyle('RP_Tags')
      -- print("[[============== this is where we would create frames ==================]]");
      -- self:Spawn('player', 'RPUF_Player'):SetPoint(GetRightLocation("player"));
      -- self:Spawn('focus',  'RPUF_Focus' ):SetPoint(GetRightLocation("focus"));
      -- self:Spawn('target', 'RPUF_Target'):SetPoint(GetRightLocation("target"));
      local playerFrame = self:Spawn("player", 
             FRAME_NAMES.PLAYER, 
             BackdropTemplateMixin and "BackdropTemplate"):SetPoint(GetRightLocation("player")
           );
      local focusFrame = self:Spawn("focus",   
             FRAME_NAMES.FOCUS,
             BackdropTemplateMixin and "BackdropTemplate"):SetPoint(GetRightLocation("focus")
           );
      local targetFrame = self:Spawn("target", 
             FRAME_NAMES.TARGET,
             BackdropTemplateMixin and "BackdropTemplate"):SetPoint(GetRightLocation("target")
           );

      RPTAGS.cache.UnitFrames = RPTAGS.cache.UnitFrames or {};

      RPTAGS.cache.UnitFrames.RPUF_Player = playerFrame;
      RPTAGS.cache.UnitFrames.RPUF_Focus = focusFrame;
      RPTAGS.cache.UnitFrames.RPUF_Target = targetFrame;

      UnregisterUnitWatch( FRAME_NAMES.PLAYER );
      UnregisterUnitWatch( FRAME_NAMES.FOCUS  );
      UnregisterUnitWatch( FRAME_NAMES.TARGET );
      
      RPTAGS.utils.frames.all.visibility.set(true); -- true here means "initialization, i.e. it hasn't been run before
      -- RPTAGS.utils.frames.all.disable.set(true);    -- same
      RPTAGS.utils.frames.all.size.scale.set();

--    self:SpawnHeader(nil, nil, 
--      'custom [group:party] show; [@raid3,exists] show; [@raid26,exists] hide; hide', 
--      'showParty',     true, 
--      'showRaid',      true, 
--      'showPlayer',    true, 
--      'yOffset',       -6, 
--      'groupBy',       'ASSIGNEDROLE', 
--      'groupingOrder', 'TANK,HEALER,DAMAGER',
--      'oUF-initialConfigFunction', [[ self:SetHeight(19) self:SetWidth(126) ]]):SetPoint('TOP', Minimap, 'BOTTOM', 0, -10)
    end);

  end
);

