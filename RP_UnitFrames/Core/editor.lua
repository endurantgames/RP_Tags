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
  local testTags        = RPTAGS.utils.tags.test;
  local errorDialogName = "RPTAGS_RP_UNITFRAMES_EDITOR_ERRORS";
  local editorFrameName         = "RP_UnitFrames_TagEditor";
  local db              = RP_UnitFramesDB.editor_config;
  local RGB_GRAY        = { 0.7, 0.7, 0.7 };
  local RGB_RED         = { 1.0, 0.1, 0.1 };
  local RGB_GREEN       = { 0.1, 1.0, 0.1 };

  local function CreateEditor()

    local Editor                  = AceGUI:Create("Window");
    Editor.editor                 = Editor;
    Editor.frame.editor           = Editor;

    -- toolbar config
    local ToolbarButtonWidth      = 86;
    local ToolbarSmallButtonWidth = 43;
    local ToolbarButtonHeight     = 20;
    local TOOLBAR_BUTTONS         =
    { ["rp:name"]                 = "Name",
      ["rp:color"]                = "Color",
      ["rp:eyes"]                 = "Eyes",
      ["rp:eyecolor"]             = "Eye Color",
      ["rp:class"]                = "Class",
      ["rp:icon"]                 = "Icon",
      ["rp:height"]               = "Height",
      ["rp:gender"]               = "Gender",
      ["rp:race"]                 = "Race",
      ["rp:fulltitle"]            = "Title",
      ["rp:age"]                  = "Age",
      ["rp:body"]                 = "Body",
      ["rp:status"]               = "Status",
      ["rp:statuscolor"]          = "Status Color",
      ["rp:gendercolor"]          = "Gender Color",
    };

    function Editor.CreatePane(self, name)
      if self[name .. "Pane"] then return self[name .. "Pane"] end;
      local Pane = AceGUI:Create("SimpleGroup");
      Pane:SetFullWidth(true);
      Pane:SetLayout("Flow");
      Pane.editor = self;
      self[name .. "Pane"] = Pane;
      self:AddChild(Pane);
      return Pane;
    end;

    function Editor.CreateInfoBox(self, pane)
      pane = pane or self;
      local InfoBox = AceGUI:Create("LMD30_Description")
      InfoBox:SetFullWidth(true);
      InfoBox:SetText("meep");
      pane:AddChild(InfoBox);
      self.infoBox = InfoBox;
      return InfoBox;
    end;

    function Editor.CreateHider(self, pane)
      pane = pane or self;
      local HiderButton = AceGUI:Create("Button");
      HiderButton.target = self.toolbar;
      HiderButton.editor = self;
      HiderButton:SetText("Hide!");
      HiderButton:SetWidth(50);
      HiderButton:SetCallback("OnClick",
        function(self)
          self.editor.toolbar.frame:SetShown(not self.editor.toolbar:IsShown() );
          -- self.editor:DoLayout();
        end
      );

      self.hider = HiderButton;
      pane:AddChild(HiderButton);
      return HiderButton;
    end;
  

    function Editor.CreateToolbar(self, pane)
      pane = pane or self;
      local Toolbar = AceGUI:Create("SimpleGroup");
  
      Toolbar:SetLayout("Flow");
      Toolbar:SetFullWidth(true);
      Toolbar.editor = self;

      local ColorButton = AceGUI:Create("Button");
      ColorButton.editor = self;
      ColorButton:SetWidth(ToolbarSmallButtonWidth);
      ColorButton:SetHeight(ToolbarButtonHeight);
      ColorButton:SetText(RPTAGS.CONST.ICONS.COLORWHEEL);
      ColorButton:SetCallback("OnEnter",
          function(self)
            GameTooltip:ClearLines();
            GameTooltip:SetOwner(self.frame, "ANCHOR_RIGHT");
            GameTooltip:AddLine("Change the text color.", 1, 1, 1, true);
            GameTooltip:Show();
          end);
        ColorButton:SetCallback("OnLeave", function(self) GameTooltip:FadeOut() end);
        ColorButton:SetCallback("OnClick",
          function(self)
            self.editor.editBox:Insert(RPTAGS.CONST.ICONS.WHITE_:gsub("{w}", 3):gsub("{r}", 255):gsub("{g}", 0):gsub("{b}", 255));
          end);
        self:AddChild(ColorButton);
  
      local NoColorButton = AceGUI:Create("Button");
      NoColorButton.editor = self;
      NoColorButton:SetWidth(ToolbarSmallButtonWidth);
      NoColorButton:SetHeight(ToolbarButtonHeight);
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
        NoColorButton:SetCallback("OnLeave", function(self) GameTooltip:FadeOut() end);
        NoColorButton:SetCallback("OnClick",
          function(self)
            self.editor.editBox:Insert("[nocolor]");
          end);
        self:AddChild(NoColorButton);
      
      function Toolbar.CreateButton(self, tag, label)
        local Button = AceGUI:Create("Button");
        Button.tag = tag;
        Button.editor = self.editor;
        Button:SetWidth(ToolbarButtonWidth);
        Button:SetHeight(ToolbarButtonHeight);
        Button:SetText(label);
        Button.frame.Left:SetWidth(10);
        Button.frame.Right:SetWidth(10);
  
        -- Button:SetCallback("OnEnter", 
        --   function(self)
        --     GameTooltip:ClearLines();
        --     GameTooltip:SetOwner(self.frame, "ANCHOR_RIGHT");
        --     GameTooltip:AddLine("[" .. self.tag .. "]", 0, 1, 1, false);
        --     GameTooltip:AddLine( "Insert the tag for " .. loc("TAG_" .. self.tag .. "_DESC") .. ".", 1, 1, 1, true)
        --     GameTooltip:Show();
        --   end);
        -- Button:SetCallback("OnLeave", function(self) GameTooltip:FadeOut() end);
        Button:SetCallback("OnClick", 
          function(self) 
            local cursor = self.editor.editBox:GetCursorPosition();
            local text = self.editor.editBox:GetText();
            local inTag, prev_right, prev_left, next_right, next_left = self.editor:FindTagEnds(text, cursor);
            -- print("inTag", inTag, "prev_left", prev_left, "cursor", cursor, "next_right", next_right);
            if inTag then self.editor.editBox:SetCursorPosition(next_right); end;
            self.editor.editBox:Insert("[" .. self.tag .. "]");
            self.editor.editBox:SetFocus();
          end);
        self:AddChild(Button);
      end;
  
      for tag, label in pairs(TOOLBAR_BUTTONS) do Toolbar:CreateButton(tag, label) end;
  
      self.toolbar = Toolbar;
      pane:AddChild(Toolbar);
      return Toolbar;
    end;
  
    function Editor.CreateEditBox(self, pane)
      pane = pane or self;
      local MultiLineEditBox = AceGUI:Create("MultiLineEditBox");
      MultiLineEditBox.editor = self;
      MultiLineEditBox.editBox.editor = self;
  
      MultiLineEditBox:SetNumLines(6);
      MultiLineEditBox:SetText("Edit Box [br] this is some [rp:name][rp:color] test material [rp:pronouns]");
      MultiLineEditBox:SetFullWidth(true);
      MultiLineEditBox:DisableButton(true);
      MultiLineEditBox:SetLabel(nil);
      local _, TMLEBFontSize = MultiLineEditBox.editBox:GetFont();
      MultiLineEditBox.editBox:SetFont(RPTAGS.CONST.FONT.FIXED, TMLEBFontSize);
    
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
                 if IsShiftKeyDown() then self:Insert("[br]") end;
          -- else   print("pressed: ", key);
          end;
        end);
    
      pane:AddChild(MultiLineEditBox);
      self.editBox = MultiLineEditBox.editBox;

      return MultiLineEditBox;
    end;
  
    function Editor.CreateResults(self, pane)
      pane = pane or self;

      local ResultsScrollContainer = AceGUI:Create("SimpleGroup");
            ResultsScrollContainer:SetFullWidth(true);
            ResultsScrollContainer:SetLayout("Fill");
            ResultsScrollContainer.editor = self;
  
      local ResultsScroll = AceGUI:Create("ScrollFrame");
            ResultsScroll:SetLayout("Flow");
            ResultsScroll:SetHeight(150);
            ResultsScroll.editor = self;
  
            ResultsScrollContainer:AddChild(ResultsScroll);
   
      local ResultsTitle = AceGUI:Create("LMD30_Description");
            ResultsTitle:SetText("# " .. loc("TAG_EDIT_RESULTS"));
            -- ResultsTitle:SetTextColor("h1", 0.7, 0.7, 0.7);
            ResultsTitle:SetFullWidth(true);
            ResultsTitle.editor = self;
  
            ResultsScroll:AddChild(ResultsTitle);
  
      local Results = AceGUI:Create("LMD30_Description");
            Results:SetText("");
            Results:SetFullWidth(true);
            Results.editor = self;
  
            ResultsScroll:AddChild(Results);
  
      pane:AddChild(ResultsScrollContainer);
      self.results = Results;
      self.resultsTitle = ResultsTitle;
      return ResultsScrollContainer;
    end;
  
    function Editor.CreateStatusBar(self, pane)
      pane = pane or self;
      local StatusBar = AceGUI:Create("SimpleGroup");
      StatusBar:SetLayout("Flow");
      StatusBar:SetFullWidth(true);
      StatusBar.editor = self;
      local buttons = 
      { { "Config",  function(self) print("pushed button!") end },
        { "Check",   function(self) print("pushed button!") end },
        { "Revert",  function(self) print("pushed button!") end },
        { "Default", function(self) print("pushed button!") end },
        { "Save",    function(self) print("pushed button!") end },
        { "Cancel",  function(self) print("pushed button!") end },
      };

      -- table.insert(buttons, AceGUI:Create("Button"):SetText("Config")  );
      -- table.insert(buttons, AceGUI:Create("Button"):SetText("Check")   );
      -- table.insert(buttons, AceGUI:Create("Button"):SetText("Revert")  );
      -- table.insert(buttons, AceGUI:Create("Button"):SetText("Default") );
      -- table.insert(buttons, AceGUI:Create("Button"):SetText("Save")    );
      -- table.insert(buttons, AceGUI:Create("Button"):SetText("Cancel")  );
  
      -- local CheckButton = AceGUI:Create("Button");
      --       CheckButton:SetText("Check");
      --       table.insert(buttons, SaveButton);
  
      -- local DefaultButton = AceGUI:Create("Button");
      --       DefaultButton:SetText("Default");
      --       table.insert(buttons, SaveButton);

      -- local CancelButton = AceGUI:Create("Button");
      --       CancelButton:SetText("Cancel");
      --       table.insert(buttons, SaveButton);

      for _, buttonData in ipairs(buttons)
      do  local button = AceGUI:Create("Button");
          button:SetText(buttonData[1]);
          button:SetCallback("OnClick", buttonData[2]);
          button.editor = self;
          button:SetRelativeWidth( 1 / #buttons );
          StatusBar:AddChild(button);
      end;

      self.statusBar = StatusBar;
      pane:AddChild(StatusBar);
      return StatusBar;
    end;

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
  
    function Editor.Initialize(self)
      self:SetHeight(400);
      self:SetWidth(500);
      self:SetPoint("CENTER");
      self:SetLayout("Flow");
      self.editor = self;
      self.frame:SetMinResize(375, 375);
      _G[editorFrameName] = Editor.frame;
      tinsert(UISpecialFrames, editorFrameName); -- closes when we hit escape

      self.content:ClearAllPoints();
      self.content:SetPoint("TOPLEFT", 25, -25);
      self.content:SetPoint("BOTTOMRIGHT", -25, 25);

      local UpperPane = self:CreatePane("upper");
      local CentralPane = self:CreatePane("central");
      local LowerPane = self:CreatePane("lower");

      -- Create the components
      self:CreateInfoBox(   UpperPane   );
      self:CreateHider(     UpperPane   );
      self:CreateToolbar(   CentralPane );
      self:CreateEditBox(   CentralPane );
      self:CreateResults(   LowerPane   );
      self:CreateStatusBar( LowerPane   );

      self.editBox:ClearAllPoints();
      self.editBox:SetPoint("TOPRIGHT", -10, -10);
      self.editBox:SetPoint("BOTTOMLEFT", 10, 10);
      -- default values
      self:ClearTitle();
      self:ClearInfo();

      return self;
    end;

    function Editor.LoadTitle(self, str)
      self:SetTitle(
        loc("TAG_EDITOR") .. " - " .. 
        (text or loc(self:GetKey()))
      );
      return self;
    end;

    function Editor.ClearTitle(self) 
      self:SetTitle( loc("TAG_EDITOR") ); 
      return self;
    end;
    function Editor.ClearDraft(self)        self:SetDraft(nil)                                  return self end
    function Editor.ClearFocus(self)        self.editBox:ClearFocus()                           return self end
    function Editor.ClearInfo(self)         self.infoBox:SetText()                            return self end
    function Editor.ClearResults(self)      self:SetResults(nil, nil, nil)                      return self end
    function Editor.ClearText(self)         self:SetText(" ")                                    return self end
    function Editor.LoadDraft(self)         self:SetText( self:GetDraft() )                     return self end
    function Editor.LoadInfo(self)          self.infoBox:SetText( loc( self:GetKey() .. "_TT")) return self end
    function Editor.SaveDraft(self)         self:SetDraft( self:GetText() )                     return self end
    function Editor.GetCursorPosition(self) return self.editBox:GetCursorPosition()                         end
    function Editor.GetDraft(self)          return db.draft or ""                                           end
    function Editor.GetKey(self)            return db.key                                                   end
    function Editor.ConfigLoad(self)        self:SetText( ConfigGet(     self:GetKey() ))       return self end
    function Editor.ConfigSet(self)                       ConfigSet(     self:GetKey(), self:GetText() )    end
    function Editor.ConfigGet(self)         return        ConfigGet(     self:GetKey() )                    end
    function Editor.ConfigDefault(self)     self:SetText( ConfigDefault( self:GetKey() ))                   end
    function Editor.ConfigReset(self)                     ConfigReset(   self:GetKey() ) self:ConfigLoad()  end
    function Editor.SetDraft(self, value)   db.draft = value or ""                              return self end
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

    function Editor.SetResults(self, text, title, color)
      text  = text  or "";
      title = title or loc("TAG_EDIT_RESULTS");
      color = color or RGB_GRAY;

      self.results:SetText(text);
      self.resultsTitle:SetText("# " .. title);
      -- self.resultsTitle:SetTextColor("h1", color[1], color[2], color[3]);

      return self;
    end;

    function Editor.Update(self)
      self:SetFocus();
      _ = self:GetKey()   and self:LoadTitle():LoadInfo()   or self:ClearTitle():ClearInfo();
      _ = self:GetDraft() and self:LoadDraft():ClearDraft() or self:ConfigLoad():ClearResults(); 
      return self;
    end;

    function Editor.Edit(self, key)
      key = key or self:GetKey();
      self:Hide();
      if self:GetKey() ~= key then self:ClearDraft(); end;
      self:SetKey(key):Update():Show();
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
                                       -- func  = function(self) TagEdit.textbox:Insert(tagValue); ToggleDropDownMenu(1, nil, dropDownFrame); end, });
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
            -- function(self)
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
            -- function(self)
              -- local err, good, bad = testTagsForEditor(TagEdit.textbox:GetText());
              -- if err then hiliteError(TagEdit.textbox, bad[1]) end;
            -- end);

        -- -- revertButton, a.k.a. "revert" ----------------------------------------------------------------------------------------------
  -- local revertButton = CreateFrame("button", nil, contentPane, "UIPanelButtonTemplate");
        -- revertButton:SetText(loc("TAG_EDIT_REVERT"));
        -- revertButton:SetWidth(90);
        -- revertButton:SetPoint("LEFT", testButton, "RIGHT", 7, 0)
        -- revertButton:SetScript("OnClick", function(self) TagEdit.textbox:SetText(Config.get(TagEdit.setting)); end);

        -- -- defaultButton, a.k.a. "defaults" -------------------------------------------------------------------------------------------
  -- local defaultButton = CreateFrame("button", nil, contentPane, "UIPanelButtonTemplate");
        -- defaultButton:SetText(loc("TAG_EDIT_DEFAULT"));
        -- defaultButton:SetWidth(90);
        -- defaultButton:SetPoint("LEFT", revertButton, "RIGHT", 7, 0)
        -- defaultButton:SetScript("OnClick", function(self) TagEdit.textbox:SetText(Config.default(TagEdit.setting)); end);

        -- -- cancelButton, a.k.a. "cancel" ---------------------------------------------------------------------------------------------
  -- local cancelButton = CreateFrame("button", nil, contentPane, "UIPanelButtonTemplate");
        -- cancelButton:SetText(loc("TAG_EDIT_CANCEL"));
        -- cancelButton:SetWidth(90);
        -- cancelButton:SetPoint("LEFT", defaultButton, "RIGHT", 7, 0)
        -- cancelButton:SetScript("OnClick", function(self) TagEdit.setting = nil; TagEdit.draft = nil; TagEdit:Hide(); end);

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
    
    Editor.frame:SetScript("OnShow", function(self) RPTAGS.cache.Editor:SetFocus() end);

    return Editor;
  end; -- CreateEditor
  local Editor = CreateEditor();

  Editor:Initialize();
  RPTAGS.cache.Editor = Editor;

end);
