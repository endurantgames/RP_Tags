-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license.

local addOnName, addOn = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("MODULE_F",
function(self, event, ...)

  RP_UnitFramesDB.editor_config = RP_UnitFramesDB.editor_config or {};
  local _

  local AceGUI          = LibStub("AceGUI-3.0");
  local Utils           = RPTAGS.utils;
  local loc             = Utils.locale.loc;
  local tagLabel        = Utils.locale.tagLabel;
  local tagDesc         = Utils.locale.tagDesc;
  local notify          = Utils.text.notify;

  local ConfigSet       = Utils.config.set;
  local ConfigGet       = Utils.config.get;
  local ConfigValid     = Utils.config.valid;
  local ConfigDefault   = Utils.config.default;
  local ConfigReset     = Utils.config.reset;

  local errorDialogName = "RPTAGS_RP_UNITFRAMES_EDITOR_ERRORS";
  local editorFrameName = "RP_UnitFrames_TagEditor";
  local db              = RP_UnitFramesDB.editor_config;
  local RGB_GRAY        = { 0.7, 0.7, 0.7 };
  local RGB_RED         = { 1.0, 0.1, 0.1 };
  local RGB_GREEN       = { 0.1, 1.0, 0.1 };
  local htmlstyle         -- temporary values holder
  local editorWidth     = 510
  local editorHeight    = 420
  local tagEval         = Utils.tags.eval;
  local linkHandler     = RPTAGS.utils.links.handler;
  -- toolbar config
  local toolBarButtonWidth      = 100;
  local toolBarSmallButtonWidth = 50;
  local statusBarButtonWidth = 75;
  local editBoxInset = 2;

  local Editor                  = AceGUI:Create("Window");

  Editor:SetWidth(editorWidth);
  Editor:SetHeight(editorHeight);
  Editor:SetPoint("CENTER");
  Editor:SetLayout("Flow");

  Editor.frame:SetMinResize(editorWidth, editorHeight);
  _G[editorFrameName] = Editor.frame;
  tinsert(UISpecialFrames, editorFrameName); -- closes when we hit escape

  Editor.content:ClearAllPoints();
  Editor.content:SetPoint("TOPLEFT", 25, -35);
  Editor.content:SetPoint("BOTTOMRIGHT", -25, 35);

  function Editor.CreateInfoBox(self)
    local infoBox = AceGUI:Create("LMD30_Description")
    htmlstyle = infoBox:GetHtmlStyleByTag("p");
    htmlstyle:SetFontSize(10);
    infoBox:ApplyHtmlStyle("p", htmlstyle);
    infoBox:SetFullWidth(true);
    infoBox:SetHeight(30);
    self.infoBox = infoBox;
    self:AddChild(infoBox);
    return self;
  end;

  -- hijack the color picker's "OK" button
  local function SetFinalColorFromPicker()
    local r, g, b = ColorPickerFrame:GetColorRGB(); 
    db.color_picker_r = r;
    db.color_picker_g = g;
    db.color_picker_b = b;
    local rgb = string.format(
                  "%02x%02x%02x", 
                   math.floor(r * 255), math.floor(g * 255), math.floor(b * 255)
                );
    Editor:Insert(
      string.format(
        "[colorcode(|cff%s%s|r)]", 
        rgb, rgb
      ));
  end;

  ColorPickerOkayButton:HookScript("OnClick", SetFinalColorFromPicker);

  function Editor.CreateColorButton(self)
    local ColorButton = AceGUI:Create("Button");
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
        OpenColorPicker(
        { hasOpacity = false,
          swatchFunc = function() return nil end,
          r = db.color_picker_r or 1,
          g = db.color_picker_g or 1,
          b = db.color_picker_b or 1,
        });
      end);
    self:AddChild( ColorButton );
    return self;
  end;

  function Editor.CreateNoColorButton(self) 
    local NoColorButton = AceGUI:Create("Button");
    NoColorButton:SetWidth(toolBarSmallButtonWidth);
    NoColorButton:SetText(RPTAGS.CONST.ICONS.COLORWHEEL);
    NoColorButton:SetCallback("OnEnter",
      function(self)
        GameTooltip:ClearLines();
        GameTooltip:SetOwner(self.frame, "ANCHOR_RIGHT");
        GameTooltip:AddLine("[nocolor]", 0, 1, 1, false);
        GameTooltip:AddLine("Insert a tag to reset the text color.");
        GameTooltip:Show();
      end);
    NoColorButton:SetCallback("OnLeave", function() GameTooltip:FadeOut() end);
    NoColorButton:SetCallback("OnClick", function(self) self:Insert("[nocolor]"); end);
    self:AddChild( NoColorButton );
    return self;
  end;
  
  function Editor.CreateButton(self, tag)
    local Button = AceGUI:Create("Button");
    Button.tag = tag;
    Button:SetWidth(toolBarButtonWidth);
    Button:SetText(tagLabel(tag));
    Button.frame.Left:SetWidth(10);
    Button.frame.Right:SetWidth(10);

    Button:SetCallback("OnEnter", 
      function(self)
        GameTooltip:ClearLines();
        GameTooltip:SetOwner(self.frame, "ANCHOR_RIGHT");
        GameTooltip:AddLine("[" .. tag .. "]", 0, 1, 1, false);
        GameTooltip:AddLine( "Insert the tag for " .. tagLabel(tag) .. ".", 1, 1, 1, true)
        GameTooltip:Show();
      end);
    Button:SetCallback("OnLeave", function() GameTooltip:FadeOut() end);
    Button:SetCallback("OnClick", 
      function(self) 
        -- local cursor = Editor.editBox:GetCursorPosition();
        -- local text   = Editor.editBox:GetText();
        -- local inTag, prev_right, prev_left, next_right, next_left 
        --              = Editor:FindTagEnds(text, cursor);
        -- -- print("inTag", inTag, "prev_left", prev_left, "cursor", cursor, "next_right", next_right);
        -- if inTag then Editor.editBox:SetCursorPosition(next_right); end;
        -- Editor.editBox:Insert("[" .. tag .. "]");
        -- Editor.editBox:SetFocus();
        Editor:Insert("[" .. tag .. "]");
      end);
    self:AddChild ( Button );
    return self;
  end;
 
  function Editor.CreateToolBar(self)
    self:CreateColorButton();
    self:CreateNoColorButton();
    local count = 0;
    for i, tag in ipairs(RPTAGS.CONST.RPUF.EDITOR_BUTTON_LIST) 
    do  if   ConfigGet("EDITOR_BUTTON_" .. tag:upper():gsub("[:%-]","") )
        then self:CreateButton(tag);
             count = count + 1;
        end;
    end;
    db.num_buttons = count;
    return self;
  end;

  function Editor.CountToolBar(self)
    local count = 0;
    for i, tag in ipairs(RPTAGS.CONST.RPUF.EDITOR_BUTTON_LIST) 
    do  if ConfigGet("EDITOR_BUTTON_" .. tag:upper():gsub("[:%-]","") ) then count = count + 1; end;
    end;
    db.num_buttons = count;
    return count;
  end;

  function Editor.CreateEditBox(self)
    local EditBoxFrame = AceGUI:Create("MultiLineEditBox");
    EditBoxFrame:SetNumLines(5);
    EditBoxFrame:SetText("");
    EditBoxFrame:SetFullWidth(true);
    EditBoxFrame:DisableButton(true);
    EditBoxFrame:SetMaxLetters(1024);
    EditBoxFrame:SetLabel(nil);
    local _, TMLEBFontSize = EditBoxFrame.editBox:GetFont();
    EditBoxFrame.editBox:SetFont(RPTAGS.CONST.FONT.FIXED, TMLEBFontSize);
    
    EditBoxFrame.editBox:ClearAllPoints();
    EditBoxFrame.editBox:SetPoint("TOPRIGHT",   editBoxInset * -1, editBoxInset * -1);
    EditBoxFrame.editBox:SetPoint("BOTTOMLEFT", editBoxInset *  1, editBoxInset *  1);
  
    EditBoxFrame.editBox:SetScript("OnKeyDown", 
      function(self, key)
        local  cursor = self:GetCursorPosition();
        local  text = self:GetText();
        local  inTag, prev_right, prev_left, next_right, next_left = Editor:FindTagEnds(text, cursor);
        if     key == "BACKSPACE" and not inTag and prev_right and prev_left and prev_right == cursor - 1
        then   self:HighlightText(prev_left, cursor);
        elseif key == "DELETE" and not inTag and next_left and next_right and next_left == cursor + 1
        then   self:HighlightText(cursor, next_right)
        elseif key == "ENTER" and inTag
        then   self:SetCursorPosition( next_right);
               if IsShiftKeyDown() then Editor:Insert("[br]\n") end;
        end;
      end);
    
    EditBoxFrame:SetCallback("OnTextChanged", 
      function() self:LoadPreview():SetChanged():UpdateTitle(); end);
    self.editBox = EditBoxFrame.editBox;
    self.EditBoxFrame = EditBoxFrame;
    self:AddChild( EditBoxFrame );
    return self;
  end;

  function Editor.CreatePreview(self)
    local Preview = AceGUI:Create("LMD30_Description");
    Preview:SetText("");
    Preview:SetFullWidth(true);
    Preview:SetHeight(50);
    self.preview = Preview;
    self:AddChild(Preview);
    return self;
  end;

  local statusButtons = 
  { { name = "Config",  
      push = function(self) 
               linkHandler("setting://RPUF_Editor");
               Editor:SaveDraft();
               Editor:Hide();
             end,
      tt   = "Configure the tag editor.",
    },
    { name = "Revert",  
      push = function(self) 
               Editor:LoadDraft();
               Editor:SetSaved();
               Editor:UpdateTitle();
               notify( Editor:GetKeyName() .. " has been reverted to its last saved value.");
             end,
      tt = "Revert back to the last saved version."
    },
    { name = "Default", 
      push = function(self) 
               notify( Editor:GetKeyName() .. " has been reset to its default value.");
               Editor:ConfigReset();
               Editor:SetChanged();
               Editor:UpdateTitle();
             end,
      tt = "Reset to the default value.",
    },
    { name = "Save",    
      push = function(self) 
               Editor:ConfigSet();
               Editor:SaveDraft();
               Editor:SetSaved();
               Editor:UpdateTitle();
               notify( Editor:GetKeyName() .. " saved.");
             end,
      tt = "Save the current value.",
    },
    { name = "Done",
      push = function(self) 
               Editor:ConfigSet();
               Editor:ClearDraft();
               Editor:Hide();
               notify( Editor:GetKeyName() .. " saved.");
             end,
      tt = "Save the current value and exit the edtior.",
    },
    { name = "Cancel",  
      push = function(self) 
               Editor:Hide();
               if Editor:IsSaved()
               then notify( Editor:GetKeyName() .. " edit cancelled.");
               else notify( Editor:GetKeyName() .. " changes discarded.");
               end;
             end,
      tt = "Exit the editor without saving.",
    },
  };

  function Editor.CreateStatusBar(self)
    for _, buttonData in ipairs(statusButtons)
    do  local button = AceGUI:Create("Button");
        button:SetText(buttonData.name);
        button:SetCallback("OnClick", buttonData.push);
        button:SetCallback("OnEnter",
          function(self)
            GameTooltip:ClearLines();
            GameTooltip:SetOwner(self.frame, "ANCHOR_RIGHT");
            GameTooltip:AddLine(buttonData.name, 0, 1, 0, false);
            GameTooltip:AddLine(buttonData.tt, 1, 1, 1, true)
            GameTooltip:Show();
          end);
        button:SetCallback("OnLeave", function() GameTooltip:FadeOut() end);
        button:SetRelativeWidth( 1 / #statusButtons)
        self:AddChild(button);
    end;
    return self;
  end;
  
  function Editor.UpdateLayout(self)
    self:ReleaseChildren();
    return self:CreateToolBar():CreateInfoBox():CreateEditBox():CreatePreview():CreateStatusBar();
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

    return inTag, prev_right, prev_left, next_right, next_left;
  end;

  function Editor.Insert(self, str)
    local cursor = self.editBox:GetCursorPosition();
    local text   = self.editBox:GetText();
    local inTag, _, _, next_right, _ = self:FindTagEnds(text, cursor);
    if inTag then self.editBox:SetCursorPosition(next_right); end;
    self.editBox:Insert(str);
    self.editBox:SetFocus();
    return self;
  end;

  function Editor.UpdateTitle(self, str)
    self:SetTitle(
      loc("TAG_EDITOR") .. " - " .. 
      (text or loc("CONFIG_" .. self:GetKey())) ..
      (db.saved and "" or " (not saved)")
    );
    return self;
  end;

  function Editor.ClearTitle(self) self:SetTitle( loc("TAG_EDITOR") ); return Editor; end;

  function Editor.ClearDraft(self)        self:SetDraft(nil)                                  return self end
  function Editor.ClearFocus(self)        self.editBox:ClearFocus()                           return self end
  function Editor.ClearInfo(self)         self.infoBox:SetText()                            return self end
  function Editor.ClearResults(self)      self:SetResults(nil, nil, nil)                      return self end
  function Editor.ClearText(self)         self:SetText(" ")                                    return self end
  function Editor.LoadDraft(self)         self:SetText( self:GetDraft() or "" )                     return self end
  function Editor.LoadInfo(self)          self.infoBox:SetText( loc( "CONFIG_" .. self:GetKey() .. "_TT")) return self end
  function Editor.SaveDraft(self)         self:SetDraft( self:GetText() )                     return self end
  function Editor.GetCursorPosition(self) return self.editBox:GetCursorPosition()                         end
  function Editor.GetDraft(self)          return db.draft                                                 end
  function Editor.GetKey(self)            return db.key                                                   end
  function Editor.GetKeyName(self)        return loc("CONFIG_" .. self:GetKey() )                         end
  function Editor.ConfigLoad(self)        self:SetText( ConfigGet(     self:GetKey() ))       return self end
  function Editor.ConfigSet(self)                       ConfigSet(     self:GetKey(), self:GetText() )    end
  function Editor.ConfigGet(self)         return        ConfigGet(     self:GetKey() )                    end
  function Editor.ConfigDefault(self)     self:SetText( ConfigDefault( self:GetKey() ))                   end
  function Editor.ConfigReset(self)                     ConfigReset(   self:GetKey() ) self:ConfigLoad()  end
  function Editor.SetDraft(self, value)   db.draft = value                                    return self end
  function Editor.SetFocus(self)          self.editBox:SetFocus()                             return self end
  function Editor.SetInfo(self, text)     self.infoBox:SetText(text or " ")                          return self end
  function Editor.SetKey(self, key)       if ConfigValid(key) then db.key = key end           return self end
  function Editor.SetChanged(self)        db.saved = false; return self; end;
  function Editor.SetSaved(self)          db.saved = true; return self; end;
  function Editor.IsSaved(self)           return db.saved end;

  function Editor.SetText(self, text)
    text = text:gsub("%[p%]","\n\n"):gsub("%[br%]", "\n");
    text = text:gsub("|cff(%x%x%x%x%x%x)", "[colorcode(|cff%1%1|r)]");
    text = text:gsub("|r", "[nocolor]");
    self.editBox:SetText(text)
    db.text = text;
    return self;
  end;

  function Editor.GetText(self) 
    local  text = self.editBox:GetText();
    text = text:gsub("%[colorcode%(|cff(%x%x%x%x%x%x).-%)%]","|cff%1");
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
    return self:SetPreview(tagEval( self:GetText(), "player", "player" ) )
  end;
    
  function Editor.Init(self)
    return self:UpdateLayout():UpdateTitle();
  end;

  function Editor.Edit(self, key)
    self:Hide();
    key = key or self:GetKey();
    if self:GetKey() ~= key then self:ClearDraft(); end;
    self:SetKey(key)
    self:Init():UpdateTitle():LoadInfo();
    if   self:GetDraft() then self:LoadDraft():ClearDraft():SetChanged(); else self:ConfigLoad():SetSaved() end;
    self:LoadPreview();
    self:Show();
    return self;
  end;

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

  StaticPopupDialogs[errorDialogName] = {
    showAlert    = 1,
    text         = loc("TAG_EDIT_ERRORS"),
    button1      = loc("TAG_EDIT_ERRORS_SAVE"),
    button2      = loc("TAG_EDIT_ERRORS_EDIT"),
    exclusive    = true,
    timeout      = 0,
    whileDead    = true,
    OnShow       = function() Editor:ClearFocus()       end,
    OnAccept     = function() Editor:ConfigSet():Hide() end,
    OnCancel     = function() Editor:SaveDraft():Edit() end,
  };
  
    -- default values
  Editor.frame:SetScript("OnSizeChanged", 
    function() 
      Editor.EditBoxFrame:SetHeight(Editor.frame:GetHeight() - 300) 
    end
  );

  RPTAGS.Editor = Editor;

end);
