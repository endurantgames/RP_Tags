-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. To view a copy of the license, visit
--
--     https://creativecommons.org/licenses/by/4.0/

local RPTAGS = RPTAGS;

RPTAGS.queue:WaitUntil("ADDON_LOAD",
function(self, event, ...)

  local CreateFrame = CreateFrame;
  local fontFrame   = CreateFrame('frame');
  local font        = fontFrame:CreateFontString(nil, 'OVERLAY', 'GameFontNormal');
  local FONTFILE, FONTSIZE, _ = font:GetFont();
  local RP_TagsDB   = RP_TagsDB;
  local oUF         = RPTAGS.oUF;
  local CONST       = RPTAGS.CONST;
  local Config      = RPTAGS.utils.config;
  local Config      = RPTAGS.utils.config;
  local getLayout   = RPTAGS.utils.rpuf.frame.layout;
  local Left        = RPTAGS.utils.rpuf.element.left;
  local Top         = RPTAGS.utils.rpuf.element.top;
  local Height      = RPTAGS.utils.rpuf.element.height;
  local Width       = RPTAGS.utils.rpuf.element.width;
  local IP          = RPTAGS.CONST.RPUF.INITIAL_POSITION;
  local loc         = RPTAGS.utils.locale.loc;
  local Utils       = RPTAGS.utils;
  local LSM         = LibStub("LibSharedMedia-3.0");
  local CW          = CONST.ICONS.COLORWHEEL;
  local Ora         = RPTAGS.utils.text.ora;
  local notify      = RPTAGS.utils.text.notify;
  local refreshAll  = RPTAGS.utils.tags.refreshAll;
  local scaleFrame  = RPTAGS.utils.rpuf.frame.scale;
  local Rpuf        = RPTAGS.utils.rpuf;
  local lockFrames  = Utils.rpuf.allFrames.lock;
  local AceGUI      = LibStub("AceGUI-3.0");

  -- tag editor -------------------------------------------------------------------------------------------------------------------------------------------
  local function hiliteError(box, bad) local start = string.find(box:GetText(), bad, 1, true) - 1; box:HighlightText(start, start + string.len(bad)); end;

  if not RP_TagsDB.editor then RP_TagsDB.editor = {} end;

  local TagEdit = AceGUI:Create("Frame");
        TagEdit:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end);
        TagEdit:SetTitle(loc("APP_NAME") .. " " .. loc("TAG_EDITOR"));
        TagEdit:SetStatusText("Status");
        TagEdit:SetLayout("Flow");
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
        if monoFont then textbox:SetFont(monoFont, 14); else Ora("|cffdd0000Ora! The font didn't load!") end;
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
  if not RPTAGS.utils.rpuf then RPTAGS.utils.rpuf = {}; end;
  if not RPTAGS.utils.rpuf.tags then RPTAGS.utils.rpuf.tags = {} end;
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

  return "rpuf-editor" -- ##

end);
