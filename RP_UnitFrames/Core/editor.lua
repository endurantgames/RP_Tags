-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. To view a copy of the license, visit
--
--     https://creativecommons.org/licenses/by/4.0/

local addOnName, addOn = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("MODULE_F",
function(self, event, ...)

  RP_UnitFramesDB.editor_config = RP_UnitFramesDB.editor_config or {};
  local _

  local AceGUI          = LibStub("AceGUI-3.0");
  local loc             = RPTAGS.utils.locale.loc;
  local ConfigSet       = RPTAGS.utils.config.set;
  local ConfigGet       = RPTAGS.utils.config.get;
  local ConfigValid     = RPTAGS.utils.config.valid;
  local ConfigDefault   = RPTAGS.utils.config.default;
  local ConfigReset     = RPTAGS.utils.config.reset;
  local errorDialogName = "RPTAGS_RP_UNITFRAMES_EDITOR_ERRORS";
  local editorFrameName = "RP_UnitFrames_TagEditor";
  local db              = RP_UnitFramesDB.editor_config;
  local RGB_GRAY        = { 0.7, 0.7, 0.7 };
  local RGB_RED         = { 1.0, 0.1, 0.1 };
  local RGB_GREEN       = { 0.1, 1.0, 0.1 };
  local htmlstyle         -- temporary values holder
  local editorWidth     = 510
  local editorHeight    = 420
  local tagEval         = RPTAGS.utils.tags.eval;
  -- toolbar config
  local toolBarButtonWidth      = 100;
  local toolBarSmallButtonWidth = 50;
  local statusBarButtonWidth = 100;

  local TOOLBAR_BUTTONS = { "rp:name", "rp:class", "rp:race", "rp:gender", "rp:age", "rp:icon", "rp:color", "rp:eyecolor", "rp:gendercolor" };

  local Editor                  = AceGUI:Create("Window");
  Editor.editor                 = Editor;
  Editor.frame.editor           = Editor;

  Editor:SetWidth(editorWidth);
  Editor:SetHeight(editorHeight);
  Editor:SetPoint("CENTER");
  Editor:SetLayout("List");

  Editor.editor = Editor;
  Editor.frame:SetMinResize(editorWidth, editorHeight);
  _G[editorFrameName] = Editor.frame;
  tinsert(UISpecialFrames, editorFrameName); -- closes when we hit escape

  Editor.content:ClearAllPoints();
  Editor.content:SetPoint("TOPLEFT", 25, -35);
  Editor.content:SetPoint("BOTTOMRIGHT", -25, 35);


  local upperPane = AceGUI:Create("SimpleGroup");
        upperPane:SetFullWidth(true);
        upperPane:SetLayout("Flow");
        upperPane.editor = Editor;
        Editor.upperPane = upperPane;
        Editor:AddChild(upperPane);

  local infoBox = AceGUI:Create("LMD30_Description")
        htmlstyle = infoBox:GetHtmlStyleByTag("p");
        htmlstyle:SetFontSize(10);
        infoBox:ApplyHtmlStyle("p", htmlstyle);
        infoBox:SetFullWidth(true);
        infoBox:SetHeight(30);
        infoBox.editor = Editor;
        Editor.infoBox = infoBox;

  local toolBar = AceGUI:Create("SimpleGroup");
        toolBar:SetLayout("Flow");
        toolBar:SetFullWidth(true);
        toolBar.editor = Editor;

  local ColorButton = AceGUI:Create("Button");
        ColorButton.editor = Editor;
        ColorButton:SetWidth(toolBarSmallButtonWidth);
        ColorButton:SetText(RPTAGS.CONST.ICONS.COLORWHEEL);
        ColorButton:SetCallback("OnEnter",
          function(self)
            GameTooltip:ClearLines();
            GameTooltip:SetOwner(self.frame, "ANCHOR_RIGHT");
            GameTooltip:AddLine("Change the text color.", 1, 1, 1, true);
            GameTooltip:Show();
          end);
        ColorButton:SetCallback("OnLeave", function() GameTooltip:FadeOut() end);
        ColorButton:SetCallback("OnClick",
          function(self)
            self.editor.editBox:Insert(
              RPTAGS.CONST.ICONS.WHITE_:gsub("{w}", 3):gsub("{r}", 255):gsub("{g}", 0):gsub("{b}", 255)
            );
          end);
        toolBar:AddChild(ColorButton);

  local NoColorButton = AceGUI:Create("Button");
        NoColorButton.editor = Editor;
        NoColorButton:SetWidth(toolBarSmallButtonWidth);
        NoColorButton:SetText(RPTAGS.CONST.ICONS.COLORWHEEL);
        NoColorButton.frame.Left:SetDesaturated(true);
        NoColorButton.frame.Right:SetDesaturated(true);
        NoColorButton.frame.Middle:SetDesaturated(true);
        NoColorButton:SetCallback("OnEnter",
          function(self)
            GameTooltip:ClearLines();
            GameTooltip:SetOwner(self.frame, "ANCHOR_RIGHT");
            GameTooltip:AddLine("[nocolor]", 0, 1, 1, false);
            GameTooltip:AddLine("Insert a tag to reset the text color.");
            GameTooltip:Show();
          end);
        NoColorButton:SetCallback("OnLeave", function() GameTooltip:FadeOut() end);
        NoColorButton:SetCallback("OnClick", function(self) self.editor.editBox:Insert("[nocolor]"); end);
        toolBar:AddChild(NoColorButton);

  local function CreateButton(tag, label)
    local Button = AceGUI:Create("Button");
          Button.tag = tag;
          Button.editor = Editor;
          Button:SetWidth(toolBarButtonWidth);
          Button:SetText(label);
          Button.frame.Left:SetWidth(10);
          Button.frame.Right:SetWidth(10);

         Button:SetCallback("OnEnter", 
           function(self)
             GameTooltip:ClearLines();
             GameTooltip:SetOwner(Editor.frame, "ANCHOR_RIGHT");
             GameTooltip:AddLine("[" .. Editor.tag .. "]", 0, 1, 1, false);
             GameTooltip:AddLine( "Insert the tag for " .. loc("TAG_" .. Editor.tag .. "_DESC") .. ".", 1, 1, 1, true)
             GameTooltip:Show();
           end);
         Button:SetCallback("OnLeave", function(Editor) GameTooltip:FadeOut() end);
         Button:SetCallback("OnClick", 
           function(self) 
             local cursor = self.editor.editBox:GetCursorPosition();
             local text   = self.editor.editBox:GetText();
             local inTag, prev_right, prev_left, next_right, next_left 
                          = self.editor:FindTagEnds(text, cursor);
             -- print("inTag", inTag, "prev_left", prev_left, "cursor", cursor, "next_right", next_right);
             if inTag then self.editor.editBox:SetCursorPosition(next_right); end;
             self.editor.editBox:Insert("[" .. self.tag .. "]");
             self.editor.editBox:SetFocus();
           end);
         toolBar:AddChild(Button);
  end;

  for i, tag in ipairs(TOOLBAR_BUTTONS) do CreateButton(tag) end;

  upperPane:AddChild( toolBar);
  upperPane:AddChild(infoBox);

  local centralPane = AceGUI:Create("SimpleGroup");
        centralPane:SetFullWidth(true);
        centralPane:SetLayout("Flow");
        centralPane.editor = Editor;
        Editor.centralPane = centralPane;
        Editor:AddChild(centralPane);
      
        local MultiLineEditBox = AceGUI:Create("MultiLineEditBox");
        MultiLineEditBox.editor = Editor;
        MultiLineEditBox.editBox.editor = Editor;
      
        MultiLineEditBox:SetNumLines(8);
        MultiLineEditBox:SetText("");
        MultiLineEditBox:SetFullWidth(true);
        MultiLineEditBox:DisableButton(true);
        MultiLineEditBox:SetLabel(nil);
        local _, TMLEBFontSize = MultiLineEditBox.editBox:GetFont();
        MultiLineEditBox.editBox:SetFont(RPTAGS.CONST.FONT.FIXED, TMLEBFontSize);
        
        MultiLineEditBox.editBox:ClearAllPoints();
        MultiLineEditBox.editBox:SetPoint("TOPRIGHT", -10, -10);
        MultiLineEditBox.editBox:SetPoint("BOTTOMLEFT", 10, 10);
      
        MultiLineEditBox.editBox:SetScript("OnKeyDown", 
          function(self, key)
            local  cursor = self:GetCursorPosition();
            local  text = self:GetText();
            local  inTag, prev_right, prev_left, next_right, next_left = self.editor:FindTagEnds(text, cursor);
            if     key == "BACKSPACE" and not inTag and prev_right and prev_left and prev_right == cursor - 1
            then   self:HighlightText(prev_left, cursor);
            elseif key == "DELETE" and not inTag and next_left and next_right and next_left == cursor + 1
            then   self:HighlightText(cursor, next_right)
            elseif key == "ENTER" and inTag
            then   self:SetCursorPosition( next_right);
                   if IsShiftKeyDown() then self:Insert("[br]\n") end;
            end;
          end);
        
      Editor.editBox = MultiLineEditBox.editBox;
      centralPane:AddChild( MultiLineEditBox );

  local lowerPane = AceGUI:Create("SimpleGroup");
        lowerPane:SetFullWidth(true);
        lowerPane:SetLayout("Fill");
        lowerPane.editor = Editor;
        Editor.lowerPane = lowerPane;
        Editor:AddChild(lowerPane);
      
  local Preview = AceGUI:Create("LMD30_Description");
        Preview:SetText("");
        Preview:SetFullWidth(true);
        Preview.editor = Editor;
        Preview:SetHeight(50);
        Editor.preview = Preview;
        
  local lowerTabGroup = AceGUI:Create("TabGroup");
        lowerTabGroup:SetLayout("Flow");
        lowerTabGroup:SetTabs(
          { { text = "Live Preview", value = "livePreview" },
          }
        );
        lowerTabGroup:AddChild(Preview)
        lowerTabGroup:SelectTab("livePreview");

  lowerPane:AddChild(lowerTabGroup);

  local statusBar = AceGUI:Create("SimpleGroup");
        statusBar:SetLayout("Flow");
        statusBar:SetFullWidth(true);
        statusBar.editor = Editor;
      
        local statusButtons = 
        { { "Config",  function(self) print("pushed button!") end },
          { "Revert",  function(self) print("pushed button!") end },
          { "Default", function(self) print("pushed button!") end },
          { "Save",    function(self) print("pushed button!") end },
          { "Cancel",  function(self) print("pushed button!") end },
        };
      
        for _, buttonData in ipairs(statusButtons)
        do  local button = AceGUI:Create("Button");
            button:SetText(buttonData[1]);
            button:SetCallback("OnClick", buttonData[2]);
            button.editor = Editor;
            button:SetWidth( statusBarButtonWidth );
            statusBar:AddChild(button);
        end;
      
        Editor.statusBar = statusBar;

        Editor:AddChild( statusBar);

  function Editor.FindTagEnds(self, text, cursor)
    local next_str          = text:sub(cursor + 1)
    local prev_str          = text:sub(0, cursor):reverse();
    local next_left_offset  = next_str:find("[", nil, true);
    local next_right_offset = next_str:find("]", nil, true);
    local prev_left_offset  = prev_str:find("[", nil, true);
    local prev_right_offset = prev_str:find("]", nil, true);
    local next_left         = next_left_offset  and (cursor + next_left_offset)       or nil;
    local next_right        = next_right_offset and (cursor + next_right_offset + 14) or nil;
    local prev_left         = prev_left_offset  and (cursor - prev_left_offset + 14)  or nil;
    local prev_right        = prev_right_offset and (cursor - prev_right_offset)      or nil;

    if     not next_right then inTag = false;
    elseif not prev_left  then inTag = false;
    elseif prev_left  and prev_right and (prev_left < prev_right) then inTag = false;
    elseif next_right and next_left  and (next_right > next_left) then inTag = false;
    else   inTag = true;
    end;

    -- print( inTag, prev_right, prev_left, inTag and 
    --        ("|cff00ff00" .. cursor .. "|r") or cursor, next_right, next_left
    --      );
    
    return inTag, prev_right, prev_left, next_right, next_left;
  end;

  function Editor.LoadTitle(self, str)
    self:SetTitle(loc("TAG_EDITOR") .. " - " .. (text or loc("CONFIG_" .. self:GetKey())));
    return self;
  end;

  function Editor.ClearTitle(self) self:SetTitle( loc("TAG_EDITOR") ); return Editor; end;

  function Editor.ClearDraft(self)        self:SetDraft(nil)                                  return self end
  function Editor.ClearFocus(self)        self.editBox:ClearFocus()                           return self end
  function Editor.ClearInfo(self)         self.infoBox:SetText()                            return self end
  function Editor.ClearResults(self)      self:SetResults(nil, nil, nil)                      return self end
  function Editor.ClearText(self)         self:SetText(" ")                                    return self end
  function Editor.LoadDraft(self)         self:SetText( self:GetDraft() )                     return self end
  function Editor.LoadInfo(self)          self.infoBox:SetText( loc( "CONFIG_" .. self:GetKey() .. "_TT")) return self end
  function Editor.SaveDraft(self)         self:SetDraft( self:GetText() )                     return self end
  function Editor.GetCursorPosition(self) return self.editBox:GetCursorPosition()                         end
  function Editor.GetDraft(self)          return db.draft                                                 end
  function Editor.GetKey(self)            return db.key                                                   end
  function Editor.ConfigLoad(self)        self:SetText( ConfigGet(     self:GetKey() ))       return self end
  function Editor.ConfigSet(self)                       ConfigSet(     self:GetKey(), self:GetText() )    end
  function Editor.ConfigGet(self)         return        ConfigGet(     self:GetKey() )                    end
  function Editor.ConfigDefault(self)     self:SetText( ConfigDefault( self:GetKey() ))                   end
  function Editor.ConfigReset(self)                     ConfigReset(   self:GetKey() ) self:ConfigLoad()  end
  function Editor.SetDraft(self, value)   db.draft = value                                    return self end
  function Editor.SetFocus(self)          self.editBox:SetFocus()                             return self end
  function Editor.SetInfo(self, text)     self.infoBox:SetText(text or " ")                          return self end
  function Editor.SetKey(self, key)       if ConfigValid(key) then db.key = key end           return self end

  function Editor.SetText(self, text)
    text = text:gsub("%[p%]","\n\n"):gsub("%[br%]", "\n");
    text = text:gsub("|cff(%x%x%x%x%x%x)", "[colorcode(%1)]");
    text = text:gsub("|r", "[nocolor]");
    self.editBox:SetText(text)
    db.text = text;
    return self;
  end;

  function Editor.GetText(self) 
    local  text = self.editBox:GetText();
    text = text:gsub("%[colorcode%(%x%x%x%x%x%x)%]","|cff%1");
    text = text:gsub("\n\n", "[p]");
    text = text:gsub("\n", "[br]");
    return text;
  end;

  function Editor.SetPreview(self, text)
    text  = text  or "";
    self.preview:SetText(text);
    return Editor;
  end;

  function Editor.LoadPreview(self)
    self:SetPreview(tagEval( self:GetText(), "player", "player" ) )
  end;
    
  function Editor.Edit(self, key)
    self:Hide();
    key = key or self:GetKey();
    if self:GetKey() ~= key then self:ClearDraft(); end;
    self:SetKey(key)
    self:LoadTitle():LoadInfo();
    if   self:GetDraft() then self:LoadDraft():ClearDraft(); else self:ConfigLoad() end;
    self:LoadPreview();
    self:Show();
    return self;
  end;

  function Editor.TestTags(self)
    local err, good, bad = testTags(self:GetText());
    if    err
    then  self:SetResults(
            loc("TAG_TEST_FAIL" .. (err == 1 and "_SINGULAR" or "")) 
                .. "|cffffffff" .. table.concat(bad, ", ") .. "|r",
            loc("TAG_EDIT_RESULTS_FAIL"),
            RGB_RED
          );
    else  self:SetResults(
            loc("TAG_TEST_PASS"),
            loc("TAG_EDIT_RESULTS_PASS"),
            RGB_GREEN
          );
    end;  --if
  end; -- function

-- -- dropdown for "More..." tags ---------------------------------------------------------------------------------------
-- local dropDownData = {};
-- local dropDownFrame = CreateFrame("Frame", "ExampleMenuFrame", contentPane, "UIDropDownMenuTemplate")
      -- dropDownFrame:SetPoint("TOPLEFT", moretagsButton, "TOPRIGHT", 0, 0);
-- local tagsSoFar; local currentMenu;
-- for i, tagData in ipairs(RPTAGS.cache.tagorder) -- menu builder
-- do  local  tagType, tagTitle, tagValue = unpack(tagData);
    -- if     tagType == "submenu" and not tagsSoFar  -- it's a submenu but our first apparently
    -- then   currentMenu = tagTitle;                 -- save the title of this submenu
           -- tagsSoFar = {};                         -- start a clean list of tSF
    -- elseif tagType == "submenu" and currentMenu    -- it's a new submenu but not our first
    -- then   table.insert(dropDownData, { text     = currentMenu, hasArrow = true, -- let's insert the data we have so far into the menu
                                        -- menuList = tagsSoFar, });
           -- currentMenu = tagTitle;                 -- then save the new submenu name
           -- tagsSoFar = {};                         -- then clear the tags
    -- elseif tagType == "title"
    -- then   table.insert(tagsSoFar, { text = tagTitle or "", isTitle = true, });
    -- elseif tagType == "tag"                     -- it's a tag so insert it into tagsSoFar
    -- then   table.insert(tagsSoFar, { text  = tagTitle, value = tagValue,
                                     -- func  = function(Editor) TagEdit.textbox:Insert(tagValue); ToggleDropDownMenu(1, nil, dropDownFrame); end, });
    -- end; -- if
-- end; -- for tagData

-- table.insert(dropDownData, { text = currentMenu, hasArrow = true, menuList = tagsSoFar }); -- do the final pass

-- local moretagsButton = CreateFrame("button", "RPTAGS_TagEdit_moretagsButton", contentPane, "UIPanelButtonTemplate");
      -- moretagsButton:SetText(loc("MORE_TAGS"));
      -- moretagsButton:SetWidth(80);
      -- moretagsButton:SetPoint("TOP", lastButton, "TOP", 0, 0);
      -- moretagsButton:SetPoint("RIGHT", contentPane, "RIGHT", 0, 0);
      -- moretagsButton:SetScript("OnClick", function() EasyMenu(dropDownData, dropDownFrame, moretagsButton, 75, 5, "not MENU") end);

   -- -- saveButton, a.k.a. "update tags" --------------------------------------------------------------------------------------------
-- local saveButton = CreateFrame("button", nil, contentPane, "UIPanelButtonTemplate");
      -- saveButton:SetText(loc("TAG_EDIT_UPDATE"));
      -- saveButton:SetWidth(90);
      -- saveButton:SetPoint("TOPLEFT", textboxContainer, "BOTTOMLEFT", 0, -5)
      -- saveButton:SetScript("OnClick",
          -- function(Editor)
            -- local text           = TagEdit.textbox:GetText();
            -- local err, good, bad = testTagsForEditor(text);

            -- if   err
            -- then StaticPopup_Show("RPTAGS_TAGEDIT_ERROR");
                 -- hiliteError(TagEdit.textbox, bad[1]);
            -- else if  TagEdit.setting == "STATUSPANEL" or TagEdit.setting == "DETAILPANEL" or TagEdit.setting:gmatch("_TOOLTIP")
                 -- then text = text:gsub("%[p%]", "\n\n"):gsub("%[br%]", "\n"):gsub("\n\n+", "%[p%]"):gsub("\n","%[br%]");
                 -- else text = text:gsub("\n", "");
                 -- end;
                 -- text = text:trim();
                 -- Config.set(TagEdit.setting, text);
                 -- TagEdit.draft = nil;
                 -- TagEdit:Hide(); 
                 -- return RPTAGS.cache.tagsRefresh and refreshAll();
            -- end;
         -- end);

      -- -- testButton, a.k.a. "test tags" ----------------------------------------------------------------------------------------------
-- local testButton = CreateFrame("button", nil, contentPane, "UIPanelButtonTemplate");
      -- testButton:SetText(loc("TAG_EDIT_TEST"));
      -- testButton:SetWidth(90);
      -- testButton:SetPoint("LEFT", saveButton, "RIGHT", 7, 0)
      -- testButton:SetScript("OnClick",
          -- function(Editor)
            -- local err, good, bad = testTagsForEditor(TagEdit.textbox:GetText());
            -- if err then hiliteError(TagEdit.textbox, bad[1]) end;
          -- end);

      -- -- revertButton, a.k.a. "revert" ----------------------------------------------------------------------------------------------
-- local revertButton = CreateFrame("button", nil, contentPane, "UIPanelButtonTemplate");
      -- revertButton:SetText(loc("TAG_EDIT_REVERT"));
      -- revertButton:SetWidth(90);
      -- revertButton:SetPoint("LEFT", testButton, "RIGHT", 7, 0)
      -- revertButton:SetScript("OnClick", function(Editor) TagEdit.textbox:SetText(Config.get(TagEdit.setting)); end);

      -- -- defaultButton, a.k.a. "defaults" -------------------------------------------------------------------------------------------
-- local defaultButton = CreateFrame("button", nil, contentPane, "UIPanelButtonTemplate");
      -- defaultButton:SetText(loc("TAG_EDIT_DEFAULT"));
      -- defaultButton:SetWidth(90);
      -- defaultButton:SetPoint("LEFT", revertButton, "RIGHT", 7, 0)
      -- defaultButton:SetScript("OnClick", function(Editor) TagEdit.textbox:SetText(Config.default(TagEdit.setting)); end);

      -- -- cancelButton, a.k.a. "cancel" ---------------------------------------------------------------------------------------------
-- local cancelButton = CreateFrame("button", nil, contentPane, "UIPanelButtonTemplate");
      -- cancelButton:SetText(loc("TAG_EDIT_CANCEL"));
      -- cancelButton:SetWidth(90);
      -- cancelButton:SetPoint("LEFT", defaultButton, "RIGHT", 7, 0)
      -- cancelButton:SetScript("OnClick", function(Editor) TagEdit.setting = nil; TagEdit.draft = nil; TagEdit:Hide(); end);

-- -- end of lower button bar ---------------------------------------------------------------------------------------------------------------------------

-- local function updateTagEdit()
  -- TagEdit.textbox:SetFocus()
  -- TagEdit.contentTitle:SetText(loc("CONFIG_" .. TagEdit.setting));
  -- TagEdit.displayBox:SetText(loc("CONFIG_" .. TagEdit.setting .. "_TT"));
  -- if   TagEdit.draft
  -- then TagEdit.textbox:SetText(TagEdit.draft)
       -- TagEdit.draft = nil;
  -- else TagEdit.textbox:SetText(Config.get(TagEdit.setting):gsub("%[p%]", "\n\n"):gsub("%[br%]", "\n"));
       -- TagEdit.testResults:SetText("");
       -- TagEdit.testResultsLabel:SetText(loc("TAG_EDIT_RESULTS"))
       -- TagEdit.testResultsLabel:SetTextColor(0.7, 0.7, 0.7)
  -- end;
-- end; -- function

  StaticPopupDialogs[errorDialogName] = {
    showAlert    = 1,
    text         = loc("TAG_EDIT_ERRORS"),
    button1      = loc("TAG_EDIT_ERRORS_SAVE"),
    button2      = loc("TAG_EDIT_ERRORS_EDIT"),
    exclusive    = true,
    timeout      = 0,
    whileDead    = true,
    OnShow       = function() RPTAGS.cache.Editor:ClearFocus()       end,
    OnAccept     = function() RPTAGS.cache.Editor:ConfigSet():Hide() end,
    OnCancel     = function() RPTAGS.cache.Editor:SaveDraft():Edit() end,
  };
  
    -- default values
  Editor:ClearTitle();
  Editor:ClearInfo();
  MultiLineEditBox:SetCallback("OnTextChanged", function() Editor:LoadPreview() end);
  Editor.frame:SetScript("OnSizeChanged", 
    function(self) 
      MultiLineEditBox:SetHeight(Editor.frame:GetHeight() - 300) 
    end
  );
  RPTAGS.cache.Editor = Editor;

end);
