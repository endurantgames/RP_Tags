local addOnName, ns = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("INIT_OPTIONS",
function(self, event, ...)

  -- We run through the registered fonts to see which ones are fixed-width
  -- and thus suitable for use in the tag editor
  --
  RPTAGS.CONST.FONT.FIXED_WIDTH = RPTAGS.CONST.FONT.FIXED_WIDTH or {};

  local frame = CreateFrame("Frame");
  local LibSharedMedia = LibStub("LibSharedMedia-3.0");

  frame:Hide();
  frame.www = frame:CreateFontString(nil, nil, "GameFontNormal");
  frame.iii = frame:CreateFontString(nil, nil, "GameFontNormal");
  frame.www:SetText("WWWWWWWWWW");
  frame.iii:SetText("iiiiiiiiii");

  for font, fontData in pairs(LibSharedMedia:HashTable("font"))
  do  local fontFile = LibSharedMedia:Fetch("font", font);
      frame.www:SetFont(fontFile, 10);
      frame.iii:SetFont(fontFile, 10);

      if   frame.www:GetUnboundedStringWidth() == frame.iii:GetUnboundedStringWidth()
      or   font:match("Source Code Pro") -- okay this is cheating a little, not sure why it's not recognized
      then RPTAGS.CONST.FONT.FIXED_WIDTH[font] = fontData;
      end;
  end;
end);

Module:WaitUntil("after MODULE_F",
function(self, event, ...)

  local function openEditor(setting) 
    RPTAGS.Editor:Edit(setting); 
  end;

  RPTAGS.utils.config.openEditor = openEditor;
    
end);

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
  local LibSharedMedia  = LibStub("LibSharedMedia-3.0");

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

  local toolBarButtonRelWidth      = 0.199;
  local toolBarSmallButtonRelWidth = 0.099;
  local toolBarWideButtonRelWidth  = 0.399;

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

  local function SetFinalColorFromPicker(...)
    if   Editor:IsVisible()
    then local r, g, b = ColorPickerFrame:GetColorRGB(); 
         db.color_picker_r = r;
         db.color_picker_g = g;
         db.color_picker_b = b;
         local rgb = string.format("%02x%02x%02x", math.floor(r * 255), math.floor(g * 255), math.floor(b * 255));
         Editor:Insert( string.format( "colorcode(|cff%s%s|r)", rgb, rgb));
    end;
    return ...; -- pass variables through
  end;

  -- hijack the color picker's "OK" button
  ColorPickerOkayButton:HookScript("OnClick", SetFinalColorFromPicker);

  function Editor.CreateColorButton(self)
    local ColorButton = AceGUI:Create("Button");
    -- ColorButton:SetWidth(toolBarSmallButtonWidth);
    ColorButton:SetRelativeWidth(toolBarSmallButtonRelWidth);
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
    -- NoColorButton:SetWidth(toolBarSmallButtonWidth);
    NoColorButton:SetRelativeWidth(toolBarSmallButtonRelWidth);
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
    NoColorButton:SetCallback("OnClick", function(self) self:Insert("nocolor"); end);
    self:AddChild( NoColorButton );
    return self;
  end;
  
  function Editor.CreateButton(self, tag)
    local Button = AceGUI:Create("Button");
    Button.tag = tag;
    -- Button:SetWidth(toolBarButtonWidth);
    Button:SetRelativeWidth(toolBarButtonRelWidth);
    Button:SetText(tagLabel(tag));
    Button.frame.Left:SetWidth(10);
    Button.frame.Right:SetWidth(10);

    Button:SetCallback("OnEnter", 
      function(self)
        GameTooltip:ClearLines();
        GameTooltip:SetOwner(self.frame, "ANCHOR_RIGHT");
        GameTooltip:AddLine("[" .. tag .. "]", 0, 1, 1, false);
        GameTooltip:AddLine( "Insert the tag for " .. tagLabel(tag) .. ".", 1, 1, 1, true)
        if   Editor.tagIndex[tag] and Editor.tagIndex[tag].label
        then GameTooltip:AddDoubleLine("Shift-Click", "Create a labeled tag.", 
               0, 1, 0, 1, 1, 1, true);
        end;
        if   Editor.tagIndex[tag] and Editor.tagIndex[tag].size
        then GameTooltip:AddDoubleLine("Alt-Click", "Set the tag to size |cff00ffffsmall|r.",
               0, 1, 0, 1, 1, 1, true);
             GameTooltip:AddDoubleLine("Control-Click", "Set the size manually.", 
               0, 1, 0, 1, 1, 1, true);
        end;
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
        Editor:Insert(tag);
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

  function Editor.CreateMore(self)
    local source = RPTAGS.CONST.TAG_DATA;

    local More = AceGUI:Create("Dropdown");
    More:SetRelativeWidth(toolBarWideButtonRelWidth);
    More:SetText(loc("MORE_TAGS"));
    for g, group in ipairs(source)
    do  More:AddItem(group.key, group.title, "Dropdown-Item-Header");
        for t, tag in ipairs(group.tags)
        do  if     tag.name
            then   More:AddItem(tag.name, RPTAGS.CONST.NBSP .. (tag.desc or tag.label or tag.name))
            elseif tag.title
            then   More:AddItem(tag.title, RPTAGS.CONST.NBSP .. tag.title, "Dropdown-Item-Header");
            end;
        end;
        More:AddItem(group.key .. "sep", group.key, "Dropdown-Item-Separator");
    end;

    More:SetCallback("OnValueChanged",
       function(self, callbackName, key, checked)
         Editor:Insert(key);
         More:SetText(loc("MORE_TAGS"));
       end);
    self:AddChild(More);
  end;
    
  function Editor.CreateEditBox(self)
    local EditBoxFrame = AceGUI:Create("MultiLineEditBox");
    EditBoxFrame:SetNumLines(5);
    EditBoxFrame:SetText("");
    EditBoxFrame:SetFullWidth(true);
    EditBoxFrame:DisableButton(true);
    EditBoxFrame:SetMaxLetters(1024);
    EditBoxFrame:SetLabel(nil);

    EditBoxFrame.editBox:SetFont(
        LibSharedMedia:Fetch("font", ConfigGet("EDITOR_FONT")), 
        ConfigGet("EDITOR_FONTSIZE"));
    
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
               if IsShiftKeyDown() then Editor:Insert("[br]\n", true) end;
        end;
      end);
    
    EditBoxFrame:SetCallback("OnTextChanged", 
      function() self:LoadPreview():SetChanged():UpdateTitle(); end);
    self.editBox = EditBoxFrame.editBox;
    self.EditBoxFrame = EditBoxFrame;
    self:AddChild( EditBoxFrame );

    Editor.frame:SetScript("OnSizeChanged", 
      function() 
        Editor.EditBoxFrame:SetHeight(Editor.frame:GetHeight() - 300) 
      end
    );

    return self;
  end;

  function Editor.CreatePreview(self)
    local PreviewBox = AceGUI:Create("InlineGroup");
    PreviewBox:SetFullWidth(true);
    PreviewBox:SetTitle("Live Preview");

    local Preview = AceGUI:Create("LMD30_Description");
    Preview:SetText("");
    Preview:SetFullWidth(true);
    Preview:SetHeight(60);
    self.preview = Preview;

    PreviewBox:AddChild(Preview);
    self:AddChild(PreviewBox);
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
               if   Editor:IsSaved()
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
    -- order counts
    self:ReleaseChildren();
    self:CreateToolBar();
    self:CreateMore();
    self:CreateInfoBox();
    self:CreateEditBox();
    self:CreatePreview();
    self:CreateStatusBar();
    return self;
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

  function Editor.Insert(self, tag, isRaw)
    local cursor = self.editBox:GetCursorPosition();
    local text   = self.editBox:GetText();
    local inTag, _, _, next_right, _ = self:FindTagEnds(text, cursor);
    if inTag then self.editBox:SetCursorPosition(next_right); end;
    if isRaw then self.editBox:Insert(tag)
    else local tagIndex = self.tagIndex[tag] or {};
         local mod = { ctrl = IsControlKeyDown(),
                       alt  = IsAltKeyDown(),
                       shift = IsShiftKeyDown() };
         if     mod.shift and tagIndex.label then tag = tag .. "-label" end;
         if     mod.alt   and tagIndex.size  then tag = tag .. "(small)"
         elseif mod.ctrl  and tagIndex.size  then tag = tag .. "()" end;
         self.editBox:Insert("[" .. tag .. "]");
    end;
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
  function Editor.LoadFont(self)          
    if self.editBox
    then self.editBox:SetFont( 
           LibSharedMedia:Fetch("font", ConfigGet("EDITOR_FONT")),
           ConfigGet("EDITOR_FONTSIZE")
         );
    end;
  end;

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
    if   self:GetDraft() 
    then self:LoadDraft():SetChanged(); 
    else self:ConfigLoad():SaveDraft():SetSaved() end;
    self:LoadPreview();
    self:Show();
    return self;
  end;

  Editor.tagIndex = {} 
  for _, group in ipairs(RPTAGS.CONST.TAG_DATA)
  do  for _, tag in ipairs(group.tags)
      do if tag.name then Editor.tagIndex[tag.name] = tag; end;
      end;
  end;

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

  RPTAGS.Editor = Editor;

end);
