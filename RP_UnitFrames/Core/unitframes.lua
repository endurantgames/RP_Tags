-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) 

local addOnName, addOn = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("ADDON_LOAD",
function(self, event, ...)

  local RPTAGS = RPTAGS;
  
  RPTAGS.utils = RPTAGS.utils or {};

  local CreateFrame = CreateFrame;
  local fontFrame   = CreateFrame('frame');
  local font        = fontFrame:CreateFontString(nil, 'OVERLAY', 'GameFontNormal');
  local FONTFILE, 
        FONTSIZE, _ = font:GetFont();
  local RP_TagsDB   = RP_TagsDB;
  local oUF         = RPTAGS.oUF;
  local Const       = RPTAGS.const;
  local Config      = RPTAGS.utils.config;
  local getLayout   = RPTAGS.utils.rpuf.frame.layout;
  local Left        = RPTAGS.utils.rpuf.element.left;
  local Top         = RPTAGS.utils.rpuf.element.top;
  local Height      = RPTAGS.utils.rpuf.element.height;
  local Width       = RPTAGS.utils.rpuf.element.width;
  local IP          = RPTAGS.const.RPUF.INITIAL_POSITION;
  local loc         = RPTAGS.utils.locale.loc;
  local loc         = RPTAGS.utils.locale.loc;
  local Utils       = RPTAGS.utils;
  local LSM         = LibStub("LibSharedMedia-3.0");
  local CW          = Const.ICONS.COLORWHEEL;
  local notify      = RPTAGS.utils.text.notify;
  local refreshAll  = RPTAGS.utils.tags.refreshAll;
  local scaleFrame  = RPTAGS.utils.rpuf.frame.scale;
  local Rpuf        = RPTAGS.utils.rpuf;
  local lockFrames  = Utils.rpuf.allFrames.lock;

  if not Config.get("DISABLE_BLIZZARD") then function oUF:DisableBlizzard() return false end; end; -- prevent oUF from disabling blizzard frames

  -- tag editor -------------------------------------------------------------------------------------------------------------------------------------------
  local function hiliteError(box, bad) local start = string.find(box:GetText(), bad, 1, true) - 1; box:HighlightText(start, start + string.len(bad)); end;

  if not RP_TagsDB.editor then RP_TagsDB.editor = {} end;

        -- base editor frame -------------------------------------------------------------------------------------------
  local TagEdit = CreateFrame("frame", "RPTAGS_TagEdit", UIParent, "BasicFrameTemplate");
        TagEdit:SetSize(500, 400);
        TagEdit:SetPoint("CENTER");
        TagEdit:SetMovable(true)
        TagEdit:EnableMouse(true)
        TagEdit:RegisterForDrag("LeftButton")
        TagEdit:SetScript("OnDragStart", TagEdit.StartMoving)
        TagEdit:SetScript("OnDragStop", TagEdit.StopMovingOrSizing)
        TagEdit:SetToplevel(true);
        TagEdit:SetUserPlaced(true);
        TagEdit:SetFrameStrata("DIALOG");
        TagEdit:SetScript("OnShow", RPTAGS.utils.rpuf.updateTagEdit);
        tinsert(UISpecialFrames, TagEdit:GetName()); -- closes when we hit escape

    -- wrapper function for testTags that stores the results in the editor test result panel(s)
  local function testTagsForEditor(s)

    local err, good, bad = RPTAGS.utils.rpuf.tags.test(s);

    if   err
    then TagEdit.testResultsLabel:SetText(loc("TAG_EDIT_RESULTS_FAIL"));
         TagEdit.testResultsLabel:SetTextColor(1, 0.1, 0.1);
         TagEdit.testResults:SetText(loc("TAG_TEST_FAIL" .. ("_SINGULAR" and err == 1 or "")) .. "|cffffffff" .. table.concat(bad, ", ") .. "|r")
    else TagEdit.testResultsLabel:SetText(loc("TAG_EDIT_RESULTS_PASS"));
         TagEdit.testResultsLabel:SetTextColor(0.1, 1, 0.1);
         TagEdit.testResults:SetText(loc("TAG_TEST_PASS"));
    end; --if
    return err, good, bad;

  end; -- function

        -- title of editor frame --------------------------------------------------------------------------------------
  local frameTitle = TagEdit:CreateFontString(nil, "OVERLAY", "GameFontNormal");
        frameTitle:SetText(loc("APP_NAME") .. loc("TAG_EDITOR"));
        frameTitle:SetPoint("TOPLEFT", TagEdit, "TOPLEFT", 5, -5);

        -- container to hold all the content that isn't part of the title ---------------------------------------------
  local contentPane = CreateFrame("Frame", nil, TagEdit, BackdropTemplateMixin and "BackdropTemplate");
        contentPane:SetPoint("TOPLEFT", TagEdit, "TOPLEFT", 5, -25);
        contentPane:SetPoint("BOTTOMRIGHT", TagEdit, "BOTTOMRIGHT", -10, 20);

        -- title of the content, i.e. the name of the setting being edited --------------------------------------------
  local contentTitle = contentPane:CreateFontString("RPTAGS_TagEditTitle", "OVERLAY", "GameFontNormalLarge");
        contentTitle:SetText("");
        contentTitle:SetPoint("TOPLEFT", contentPane, "TOPLEFT", 5, -5);
        TagEdit.contentTitle = contentTitle;

        -- the helpful message / instructions (a.k.a. "tooltip" _TT in loc) -------------------------------------------
  local displayBox = contentPane:CreateFontString("RPTAGS_TagEditDisplay", "OVERLAY", "GameFontNormal");
        displayBox:SetSize(420, 40);
        displayBox:SetJustifyH("LEFT");
        displayBox:SetJustifyV("TOP");
        displayBox:SetText(loc("CONFIG_STATUSPANEL_TT"));
        displayBox:SetPoint("TOPLEFT", contentTitle, "BOTTOMLEFT", 0, -10);
        TagEdit.displayBox = displayBox;

        -- tag insert buttons above the editbox -----------------------------------------------------------------------
  local buttons = -- CW is the Color Wheel graphic
  { {-- button    tag         width       2nd button           width      third button  tag         width     4th button             width
      { "name",   "[rp:name]",   55, }, { CW, "[rp:color]",       25 }, { "eyes",       "[rp:eyes]",   55, }, { CW, "[rp:eyecolor]",    25 },   -- 1,   2 ,  3,   4 ,
      { "class",  "[rp:class]"                                       }, { "icon",       "[rp:icon]"                                        },   -- 5,  (6),  7,  (8),
      { "height", "[rp:height]",                                     }, { CW .. " off", "[nocolor]"                                        } }, -- 9, (10), 11, (12)
    { { "ic/ooc", "[rp:status]", 55, }, { CW, "[rp:statuscolor]", 25 }, { "sex",        "[rp:gender]", 55, }, { CW, "[rp:gendercolor]", 25 },   -- 1,   2 ,  3,   4 ,
      { "race",   "[rp:race]",                                       }, { "age",        "[rp:age]",                                        },   -- 5,  (6),  7,  (8),
      { "body",   "[rp:body]",                                       },                                                                         -- 9, (10),  "More"
    } }; 

  local   lastButton, lastButtonRow;
  for _,  row in ipairs(buttons) -- button bar builder
  do  for i, buttonData in ipairs(row)
      do  local title, value, width = unpack(buttonData);
          local button = CreateFrame("button", nil, contentPane, "UIPanelButtonTemplate");
          button:SetText(title)
          button.value = value;
          button.tooltipText = vaue;
          button:SetWidth(width or 80);
          button:SetScript("OnClick", function(self) TagEdit.textbox:Insert(self.value) end);
          if not lastButton then button:SetPoint("TOPLEFT", displayBox,    "BOTTOMLEFT", 0, -10); lastButtonRow = button;
          elseif i == 1     then button:SetPoint("TOPLEFT", lastButtonRow, "BOTTOMLEFT", 0,   0); lastButtonRow = button;
          else                   button:SetPoint("LEFT",    lastButton,    "RIGHT",      0,   0); 
          end;   
          lastButton = button;
      end; -- for i,buttonData
  end;

  -- dropdown for "More..." tags ---------------------------------------------------------------------------------------
  local dropDownData = {};
  local dropDownFrame = CreateFrame("Frame", "ExampleMenuFrame", contentPane, "UIDropDownMenuTemplate")
        dropDownFrame:SetPoint("TOPLEFT", moretagsButton, "TOPRIGHT", 0, 0);
  local tagsSoFar; local currentMenu;
  for i, tagData in ipairs(RPTAGS.cache.tagorder) -- menu builder
  do  local  tagType, tagTitle, tagValue = unpack(tagData);
      if     tagType == "submenu" and not tagsSoFar  -- it's a submenu but our first apparently
      then   currentMenu = tagTitle;                 -- save the title of this submenu
             tagsSoFar = {};                         -- start a clean list of tSF
      elseif tagType == "submenu" and currentMenu    -- it's a new submenu but not our first
      then   table.insert(dropDownData, { text     = currentMenu, hasArrow = true, -- let's insert the data we have so far into the menu
                                          menuList = tagsSoFar, });
             currentMenu = tagTitle;                 -- then save the new submenu name
             tagsSoFar = {};                         -- then clear the tags
      elseif tagType == "title"
      then   table.insert(tagsSoFar, { text = tagTitle or "", isTitle = true, });
      elseif tagType == "tag"                     -- it's a tag so insert it into tagsSoFar
      then   table.insert(tagsSoFar, { text  = tagTitle, value = tagValue,
                                       func  = function(self) TagEdit.textbox:Insert(tagValue); ToggleDropDownMenu(1, nil, dropDownFrame); end, });
      end; -- if
  end; -- for tagData

  table.insert(dropDownData, { text = currentMenu, hasArrow = true, menuList = tagsSoFar }); -- do the final pass

  local moretagsButton = CreateFrame("button", "RPTAGS_TagEdit_moretagsButton", contentPane, "UIPanelButtonTemplate");
        moretagsButton:SetText(loc("MORE_TAGS"));
        moretagsButton:SetWidth(80);
        moretagsButton:SetPoint("TOP", lastButton, "TOP", 0, 0);
        moretagsButton:SetPoint("RIGHT", contentPane, "RIGHT", 0, 0);
        moretagsButton:SetScript("OnClick", function() EasyMenu(dropDownData, dropDownFrame, moretagsButton, 75, 5, "not MENU") end);

        -- container for the editbox ---------------------------------------------------------------------------------------------------------------
  local textboxContainer = CreateFrame("Frame", "RPTAGS_TagEditTextbox", contentPane, BackdropTemplateMixin and "BackdropTemplate");
        textboxContainer:SetBackdrop({ bgFile   = [[Interface\Buttons\WHITE8x8]], edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
                                       edgeSize = 14, insets = {left = 3, right = 3, top = 3, bottom = 3}, });
        textboxContainer:SetBackdropColor(0, 0, 0, 0.5)
        textboxContainer:SetSize(480,125);
        textboxContainer:SetBackdropBorderColor(0.3, 0.3, 0.3)
        textboxContainer:SetPoint("LEFT", lastButtonRow, "LEFT", 0, 0);
        textboxContainer:SetPoint("TOP", lastButtonRow, "BOTTOM", 0, -5);

        -- scroller for the editbox ---------------------------------------------------------------------------------------------------------------
  local textboxScroll = CreateFrame("ScrollFrame", nil, textboxContainer, "UIPanelScrollFrameTemplate");
        textboxScroll:SetPoint("TOPLEFT", textboxContainer, "TOPLEFT", 5, -5);
        textboxScroll:SetSize(449,115);

        -- the editbox itself ---------------------------------------------------------------------------------------------------------------------
  local textbox = CreateFrame("editbox", nil, textboxScroll, BackdropTemplateMixin and "BackdropTemplate");
        textbox:SetMultiLine(true);
        textbox:SetSize(440,120);
        local monoFont = LSM:Fetch("font", "SourceCodePro Regular"); -- set the font
        textbox:SetText("");
        textbox:SetPoint("TOP", textboxScroll, "TOP", 0, -20);
        textbox:SetAutoFocus(false)
        textbox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end);
        textbox:SetScript("OnTabPressed", function(self) self:ClearFocus() end);
        textbox:SetCursorPosition(0)
        textbox:SetJustifyH("LEFT")
        textbox:SetJustifyV("TOP")
        textbox:SetScript("OnShow", function(self) self:SetFocus() end);
        textbox:SetTextInsets(2, 2, 2, 2);
        textboxScroll:SetScrollChild(textbox);
        TagEdit.textbox = textbox;

  -- start of the lower button bar, below the editbox ------------------------------------------------------------------------------------------------------------
     -- saveButton, a.k.a. "update tags" --------------------------------------------------------------------------------------------
  local saveButton = CreateFrame("button", nil, contentPane, "UIPanelButtonTemplate");
        saveButton:SetText(loc("TAG_EDIT_UPDATE"));
        saveButton:SetWidth(90);
        saveButton:SetPoint("TOPLEFT", textboxContainer, "BOTTOMLEFT", 0, -5)
        saveButton:SetScript("OnClick",
            function(self)
              local text           = TagEdit.textbox:GetText();
              local err, good, bad = testTagsForEditor(text);

              if   err
              then StaticPopup_Show("RPTAGS_TAGEDIT_ERROR");
                   hiliteError(TagEdit.textbox, bad[1]);
              else if  TagEdit.setting == "STATUSPANEL" or TagEdit.setting == "DETAILPANEL" or TagEdit.setting:gmatch("_TOOLTIP")
                   then text = text:gsub("%[p%]", "\n\n"):gsub("%[br%]", "\n"):gsub("\n\n+", "%[p%]"):gsub("\n","%[br%]");
                   else text = text:gsub("\n", "");
                   end;
                   text = text:trim();
                   Config.set(TagEdit.setting, text);
                   TagEdit.draft = nil;
                   TagEdit:Hide(); 
                   return RPTAGS.cache.tagsRefresh and refreshAll();
              end;
           end);

        -- testButton, a.k.a. "test tags" ----------------------------------------------------------------------------------------------
  local testButton = CreateFrame("button", nil, contentPane, "UIPanelButtonTemplate");
        testButton:SetText(loc("TAG_EDIT_TEST"));
        testButton:SetWidth(90);
        testButton:SetPoint("LEFT", saveButton, "RIGHT", 7, 0)
        testButton:SetScript("OnClick",
            function(self)
              local err, good, bad = testTagsForEditor(TagEdit.textbox:GetText());
              if err then hiliteError(TagEdit.textbox, bad[1]) end;
            end);

        -- revertButton, a.k.a. "revert" ----------------------------------------------------------------------------------------------
  local revertButton = CreateFrame("button", nil, contentPane, "UIPanelButtonTemplate");
        revertButton:SetText(loc("TAG_EDIT_REVERT"));
        revertButton:SetWidth(90);
        revertButton:SetPoint("LEFT", testButton, "RIGHT", 7, 0)
        revertButton:SetScript("OnClick", function(self) TagEdit.textbox:SetText(Config.get(TagEdit.setting)); end);

        -- defaultButton, a.k.a. "defaults" -------------------------------------------------------------------------------------------
  local defaultButton = CreateFrame("button", nil, contentPane, "UIPanelButtonTemplate");
        defaultButton:SetText(loc("TAG_EDIT_DEFAULT"));
        defaultButton:SetWidth(90);
        defaultButton:SetPoint("LEFT", revertButton, "RIGHT", 7, 0)
        defaultButton:SetScript("OnClick", function(self) TagEdit.textbox:SetText(Config.default(TagEdit.setting)); end);

        -- cancelButton, a.k.a. "cancel" ---------------------------------------------------------------------------------------------
  local cancelButton = CreateFrame("button", nil, contentPane, "UIPanelButtonTemplate");
        cancelButton:SetText(loc("TAG_EDIT_CANCEL"));
        cancelButton:SetWidth(90);
        cancelButton:SetPoint("LEFT", defaultButton, "RIGHT", 7, 0)
        cancelButton:SetScript("OnClick", function(self) TagEdit.setting = nil; TagEdit.draft = nil; TagEdit:Hide(); end);

  -- end of lower button bar ---------------------------------------------------------------------------------------------------------------------------

  -- results of testing tags
        -- label for the results
  local testResultsLabel = contentPane:CreateFontString(nil, "OVERLAY", "GameFontNormal");
        testResultsLabel:SetText(loc("TAG_EDIT_RESULTS"));
        testResultsLabel:SetPoint("TOP", cancelButton, "BOTTOM", 0, -5);
        testResultsLabel:SetPoint("LEFT", contentPane, "LEFT", 5, 0);
        testResultsLabel:SetTextColor(0.7, 0.7, 0.7)
        TagEdit.testResultsLabel = testResultsLabel;

        -- text of the results
  local testResults = contentPane:CreateFontString(nil, "OVERLAY", "GameFontNormal");
        testResults:SetText("");
        testResults:SetPoint("TOPLEFT", testResultsLabel, "BOTTOMLEFT", 10, -5);
        testResults:SetPoint("RIGHT", contentPane, "RIGHT", -20, 0);
        testResults:SetHeight(40);
        testResults:SetJustifyH("LEFT");
        testResults:SetJustifyV("TOP");
        TagEdit.testResults = testResults;

  -- function to cause the tag editor to re-load its content
  local function updateTagEdit()
    TagEdit.textbox:SetFocus()
    TagEdit.contentTitle:SetText(loc("CONFIG_" .. TagEdit.setting));
    TagEdit.displayBox:SetText(loc("CONFIG_" .. TagEdit.setting .. "_TT"));
    if   TagEdit.draft
    then TagEdit.textbox:SetText(TagEdit.draft)
         TagEdit.draft = nil;
    else TagEdit.textbox:SetText(Config.get(TagEdit.setting):gsub("%[p%]", "\n\n"):gsub("%[br%]", "\n"));
         TagEdit.testResults:SetText("");
         TagEdit.testResultsLabel:SetText(loc("TAG_EDIT_RESULTS"))
         TagEdit.testResultsLabel:SetTextColor(0.7, 0.7, 0.7)
    end;
  end; -- function

  -- function to open the editor to edit a set of settings
  local function tagEdit(setting)
    TagEdit:Hide();
    if TagEdit.setting ~= setting then TagEdit.draft = nil; end;
    TagEdit.setting = setting;
    RP_TagsDB.editor.last = setting;
    updateTagEdit();
    TagEdit:Show();
  end;

  -- we'll need this elsewhere later
  RPTAGS.utils.rpuf      = RPTAGS.utils.rpuf      or {};
  RPTAGS.utils.rpuf.tags = RPTAGS.utils.rpuf.tags or {};

  RPTAGS.utils.rpuf.tags.edit = tagEdit;

  -- Popup dialog

  StaticPopupDialogs["RPTAGS_TAGEDIT_ERROR"] = {
     showAlert    =  1,
     text         =  loc("TAG_EDIT_ERRORS"),
     button1      =  loc("TAG_EDIT_ERRORS_SAVE"),
     button2      =  loc("TAG_EDIT_ERRORS_EDIT"),
     exclusive    =  true,
     timeout      =  0,
     whileDead    =  true,
     OnShow       =  function(self) TagEdit.textbox:ClearFocus(); end,
     OnAccept     =  function(self) RPTAGS.utils.config.set(TagEdit.setting, TagEdit.textbox:GetText()) TagEdit:Hide(); end,
     OnCancel     =  function(self) TagEdit.draft = TagEdit.textbox:GetText(); self:Hide();            tagEdit(TagEdit.setting); end,
  };

  -- rpuf tooltip -------------------------------------------------------------------------------------------------------------------------------
  local TTwidth, TTborder, TTpadding = 200, 5, 5;
  local Tooltip = CreateFrame("Frame", "RPUF_Tooltip", UIParent, BackdropTemplateMixin and "BackdropTemplate")
        Tooltip:SetWidth(TTwidth);
        Tooltip:SetHeight(1)
        Tooltip:SetPoint("CENTER");
        Tooltip:SetBackdrop(RPTAGS.const.BACKDROP.BLIZZTOOLTIP)
        Tooltip:SetBackdropColor(0, 0, 0, 1)
        Tooltip:SetFrameStrata("TOOLTIP")
        Tooltip:Hide();

        function Tooltip:UpdateColors()
          local bgRed, bgGreen, bgBlue = RPTAGS.utils.color.hexaToNumber(Config.get("COLOR_RPUF"));
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
         if self.source   then table.insert(subMenu, { text = RPTAGS.utils.text.hilite(loc("EDIT_TAGS_FOR").. "[[[" .. loc("CONFIG_"..self.source) .. "]]]"),
                                                       func = function() RPTAGS.utils.rpuf.tags.edit(self.source) contextMenuFrame:Hide();                    end }) end;
         if self.ttsource then table.insert(subMenu, { text = RPTAGS.utils.text.hilite(loc("EDIT_TAGS_FOR").."[["..loc("CONFIG_"..self.ttsource) .."]]"),
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
           { text = RPTAGS.utils.text.hilite(loc("SET_LAYOUT") ..  "[[[" .. loc("CONFIG_" .. RPTAGS.cache.layoutOptions[unitFrameName].config) .. "]]]"),
             hasArrow = true, menuList = unitFrameContextMenu })

         local function setScale(f, s, c) Config.set(c, s) f:SetScale(s); contextMenuFrame:Hide(); f:UpdateAllElements('now') end; 

         local scaleConfig = unitFrameParent.unit .. "FRAME_SCALE";
         scaleConfig = scaleConfig:upper();
         table.insert(contextMenu,
           { text = RPTAGS.utils.text.hilite("Set the " ..  "[[" .. loc("CONFIG_" .. scaleConfig) .. "]]"),
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

    local fix = RPTAGS.utils.rpuf.tags.fix;
          unit = unit:match('^(.-)%d+') or unit
    local layout = getLayout(self);
    local framewidth, frameheight = RPTAGS.utils.rpuf.frame.size(layout);
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

    local bgRed, bgGreen, bgBlue = RPTAGS.utils.color.hexaToNumber(Config.get("COLOR_RPUF"));
          content:SetBackdrop(RPTAGS.const.BACKDROP[RPTAGS.utils.config.get("RPUF_BACKDROP")])
          content:SetBackdropColor(bgRed / 255, bgGreen / 255, bgBlue / 255, Config.get("RPUFALPHA") / 100)

    local NamePanel = CreateFrame('Frame', nil, content, BackdropTemplateMixin and "BackdropTemplate") NamePanel:SetFrameLevel(20) content.NamePanel = NamePanel;
          NamePanel:SetPoint('TOPLEFT', content, 'TOPLEFT', Left('NamePanel', layout), Top('NamePanel', layout))
          NamePanel:SetSize(Width('NamePanel', layout), Height('NamePanel', layout));

    local NameFontString = content.NamePanel:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightLarge')
          tinsert(content.fontStrings, NameFontString);
          NamePanel.text = NameFontString;
          NameFontString.setting = "NAMEPANEL";
          NameFontString:SetJustifyH(RPTAGS.utils.rpuf.element.align("NamePanel", layout))
          NameFontString:SetJustifyV('TOP')
          NameFontString:SetSize(Width('NamePanel', layout), Height('NamePanel', layout));
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
          InfoPanel:SetPoint('TOPLEFT', content, 'TOPLEFT', Left('InfoPanel', layout), Top('InfoPanel', layout))
          InfoPanel:SetSize(Width('InfoPanel', layout), Height('InfoPanel', layout));

    local InfoFontString = content.InfoPanel:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
          InfoPanel.text = InfoFontString;
          tinsert(content.fontStrings, InfoFontString);
          InfoFontString.setting = "INFOPANEL";
          InfoFontString:SetPoint("TOPLEFT", InfoPanel, "TOPLEFT", 0, 0);
          InfoFontString:SetJustifyH(RPTAGS.utils.rpuf.element.align("InfoPanel", layout))
          InfoFontString:SetJustifyV('TOP')
          InfoFontString:SetWidth(Width('InfoPanel', layout));
          InfoFontString:SetHeight(Height('InfoPanel', layout));
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
          DetailsPanel:SetPoint('TOPLEFT', content, 'TOPLEFT', Left('DetailsPanel', layout), Top('DetailsPanel', layout));
          DetailsPanel:SetSize(Width('DetailsPanel', layout), Height('DetailsPanel', layout));

    local DetailsFontString = content.DetailsPanel:CreateFontString(nil, 'OVERLAY', 'GameFontNormal');
          DetailsPanel.text = DetailsFontString;
          tinsert(content.fontStrings, DetailsFontString);
          DetailsFontString:SetPoint("TOPLEFT", DetailsPanel, "TOPLEFT", 0, 0);
          DetailsFontString:SetJustifyH('LEFT');
          DetailsFontString.setting = "DETAILPANEL";
          DetailsFontString:SetJustifyV('TOP');
          DetailsFontString:SetWordWrap(true);
          DetailsFontString:SetWidth(Width('DetailsPanel', layout));
          DetailsFontString:SetHeight(Height('DetailsPanel', layout));
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
          PortraitPanel:SetPoint("TOPLEFT", content, 'TOPLEFT', Left('PortraitPanel', layout), Top('PortraitPanel', layout));
          PortraitPanel:SetWidth(Width('PortraitPanel', layout))
          PortraitPanel:SetHeight(Height('PortraitPanel', layout))
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
          -- Portrait:SetPoint("TOPLEFT", content, 'TOPLEFT', Left('Portrait', layout), Top('Portrait', layout));
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
          Icon_1Panel:SetPoint('TOPLEFT', content, 'TOPLEFT', Left('Icon_1Panel', layout), Top('Icon_1Panel', layout))
          Icon_1Panel:SetSize(Width('Icon_1Panel', layout), Height('Icon_1Panel', layout));

    local Icon_1FontString = content.Icon_1Panel:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightLarge')
          Icon_1Panel.text = Icon_1FontString;
          tinsert(content.fontStrings, Icon_1FontString);
          Icon_1FontString:SetPoint("TOPLEFT", Icon_1Panel, "TOPLEFT", 0, 0);
          Icon_1FontString:SetJustifyH('LEFT')
          Icon_1FontString:SetJustifyV('TOP')
          Icon_1FontString.setting = "ICON_1";
          Icon_1FontString:SetWordWrap(false)
          Icon_1FontString:SetFont(FONTFILE, Width('Icon_1Panel', layout) -1 )
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
          Icon_2Panel:SetPoint('TOPLEFT', content, 'TOPLEFT', Left('Icon_2Panel', layout), Top('Icon_2Panel', layout));
          Icon_2Panel:SetSize(Width('Icon_2Panel', layout), Height('Icon_2Panel', layout));

    local Icon_2FontString = content.Icon_2Panel:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
          Icon_2Panel.text = Icon_2FontString;
          Icon_2FontString:SetPoint("TOPLEFT", Icon_2Panel, "TOPLEFT", 0, 0);
          Icon_2FontString:SetJustifyH('LEFT')
          Icon_2FontString:SetJustifyV('TOP')
          Icon_2FontString.setting = "ICON_2";
          tinsert(content.fontStrings, Icon_2FontString);
          Icon_2FontString:SetWordWrap(false)
          Icon_2FontString:SetFont(FONTFILE, Width('Icon_2Panel', layout) -1 )
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
          Icon_3Panel:SetPoint('TOPLEFT', content, 'TOPLEFT', Left('Icon_3Panel', layout), Top('Icon_3Panel', layout));
          Icon_3Panel:SetSize(Width('Icon_3Panel', layout), Height('Icon_3Panel', layout));

    local Icon_3FontString = content.Icon_3Panel:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
          Icon_3Panel.text = Icon_3FontString;
          Icon_3FontString:SetPoint("TOPLEFT", Icon_3Panel, "TOPLEFT", 0, 0);
          Icon_3FontString:SetJustifyH('LEFT')
          Icon_3FontString:SetJustifyV('TOP')
          tinsert(content.fontStrings, Icon_3FontString);
          Icon_3FontString.setting = "ICON_3";
          Icon_3FontString:SetWordWrap(false)
          Icon_3FontString:SetFont(FONTFILE, Width('Icon_3Panel', layout) -1 )
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
          Icon_4Panel:SetPoint('TOPLEFT', content, 'TOPLEFT', Left('Icon_4Panel', layout), Top('Icon_4Panel', layout));
          Icon_4Panel:SetSize(Width('Icon_4Panel', layout), Height('Icon_4Panel', layout));

    local Icon_4FontString = content.Icon_4Panel:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
          Icon_4Panel.text = Icon_4FontString;
          Icon_4FontString:SetPoint("TOPLEFT", Icon_4Panel, "TOPLEFT", 0, 0);
          Icon_4FontString:SetJustifyH('LEFT')
          tinsert(content.fontStrings, Icon_4FontString);
          Icon_4FontString.setting = "ICON_4";
          Icon_4FontString:SetJustifyV('TOP')
          Icon_4FontString:SetWordWrap(false)
          Icon_4FontString:SetFont(FONTFILE, Width('Icon_4Panel', layout) -1 )
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
          Icon_5Panel:SetPoint('TOPLEFT', content, 'TOPLEFT', Left('Icon_5Panel', layout), Top('Icon_5Panel', layout));
          Icon_5Panel:SetSize(Width('Icon_5Panel', layout), Height('Icon_5Panel', layout));

    local Icon_5FontString = content.Icon_5Panel:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
          Icon_5Panel.text = Icon_5FontString;
          Icon_5FontString:SetPoint("TOPLEFT", Icon_5Panel, "TOPLEFT", 0, 0);
          Icon_5FontString:SetJustifyH('LEFT')
          Icon_5FontString.setting = "ICON_5";
          Icon_5FontString:SetJustifyV('TOP')
          Icon_5FontString:SetWordWrap(false)
          Icon_5FontString:SetFont(FONTFILE, Width('Icon_5Panel', layout) -1 )
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
          Icon_6Panel:SetPoint('TOPLEFT', content, 'TOPLEFT', Left('Icon_6Panel', layout), Top('Icon_6Panel', layout));
          Icon_6Panel:SetSize(Width('Icon_6Panel', layout), Height('Icon_6Panel', layout));

    local Icon_6FontString = content.Icon_6Panel:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
          Icon_6Panel.text = Icon_6FontString;
          Icon_6FontString:SetPoint("TOPLEFT", Icon_6Panel, "TOPLEFT", 0, 0);
          Icon_6FontString:SetJustifyH('LEFT')
          Icon_6FontString:SetJustifyV('TOP')
          Icon_6FontString.setting = "ICON_6";
          tinsert(content.fontStrings, Icon_6FontString);
          Icon_6FontString:SetWordWrap(false)
          Icon_6FontString:SetFont(FONTFILE, Width('Icon_6Panel', layout) -1 )
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
          StatusBarPanel:SetPoint('TOPLEFT', content, 'TOPLEFT', Left('StatusBarPanel', layout), Top('StatusBarPanel', layout));
          StatusBarPanel:SetSize(Width('StatusBarPanel', layout), Height('StatusBarPanel', layout));
          content.StatusBarPanel = StatusBarPanel;
          bgRed, bgGreen, bgBlue = RPTAGS.utils.color.hexaToNumber(Config.get("COLOR_RPUF"));
          StatusBarPanel:SetBackdrop(RPTAGS.const.STATUSBAR_TEXTURE[Config.get("STATUS_TEXTURE")]);
          StatusBarPanel:SetBackdropColor(bgRed / 255, bgGreen / 255, bgBlue / 255, RPTAGS.const.STATUSBAR_ALPHA[Config.get("STATUS_TEXTURE")]);

    local StatusBarFontString = content.StatusBarPanel:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
          StatusBarPanel.text = StatusBarFontString;
          StatusBarFontString:SetJustifyH(RPTAGS.const.ALIGN[Config.get("STATUS_ALIGN")].H);
          StatusBarFontString:SetPoint("TOPLEFT", StatusBarPanel, "TOPLEFT", Config.get("GAPSIZE"), Config.get("GAPSIZE") / -2);
          StatusBarFontString:SetJustifyH(RPTAGS.const.ALIGN[Config.get("STATUS_ALIGN")].H);
          StatusBarFontString:SetJustifyV(RPTAGS.const.ALIGN[Config.get("STATUS_ALIGN")].V);
          StatusBarFontString.setting = "STATUSPANEL";
          tinsert(content.fontStrings, StatusBarFontString);
          StatusBarFontString:SetWordWrap(true);
          StatusBarFontString:SetSize(Width('StatusBarPanel', layout) - Config.get("GAPSIZE") * 2, Height('StatusBarPanel', layout) - Config.get("GAPSIZE"));
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
          DragFrame:SetBackdrop(RPTAGS.const.BACKDROP.BLIZZTOOLTIP)
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
              local IP = RPTAGS.const.RPUF.INITIAL_POSITION[frame.unit];
              frame:ClearAllPoints();
              frame:SetPoint(IP.pt, _G[IP.relto], IP.relpt, IP.x, IP.y);
              RP_TagsDB[frame.unit .. "UFlocation"] = nil;
            end);
     local ttRed, ttGreen, ttBlue = RPTAGS.utils.color.hexaToNumber(Config.get("COLOR_RPUF_TOOLTIP"));
     for _, tt in ipairs(content.tooltips)    do tt:SetTextColor(ttRed / 255, ttGreen / 255, ttBlue / 255) end;
     local txRed, txGreen, txBlue = RPTAGS.utils.color.hexaToNumber(Config.get("COLOR_RPUF_TEXT"));
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
      -- self:Spawn("player", 'RPUF_Player', BackdropTemplateMixin and "BackdropTemplate"):SetPoint(GetRightLocation("player"));
      -- self:Spawn("foxu",   'RPUF_Focus' , BackdropTemplateMixin and "BackdropTemplate"):SetPoint(GetRightLocation("focus" ));
      -- self:Spawn("target", 'RPUF_Target', BackdropTemplateMixin and "BackdropTemplate"):SetPoint(GetRightLocation("target"));

      -- UnregisterUnitWatch(RPUF_Player);
      -- UnregisterUnitWatch(RPUF_Target);
      -- UnregisterUnitWatch(RPUF_Focus);
      
      -- RPTAGS.utils.rpuf.allFrames.visibility(true); -- true here means "initialization, i.e. it hasn't been run before
      -- RPTAGS.utils.rpuf.allFrames.disable(true);    -- same
      -- RPTAGS.utils.rpuf.allFrames.scale();

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

