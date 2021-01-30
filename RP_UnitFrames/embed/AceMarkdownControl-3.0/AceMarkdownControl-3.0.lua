local ACEMARKDOWNCONTROL = "AceMarkdownControl-3.0";
local ACEMARKDOWNCONTROL_MINOR = 1;
if not LibStub then error(ACEMARKDOWNCONTROL .. " requires LibStub."); end;
local LMD = LibStub("LibMarkdown-1.0");
local AceGUI = LibStub("AceGUI-3.0");

local lib = LibStub:NewLibrary(ACEMARKDOWNCONTROL, ACEMARKDOWNCONTROL_MINOR);

function lib:New(str)
  local libInstance = {};
  libInstance.ShowMarkdown = false;
  libInstance.controlName = str or ("Markdown-" .. math.random());
  libInstance.PopupPrefix = "";
  libInstance.PopupOKButton = "Got It";
  libInstance.HyperlinksEnabled = true;
  libInstance.HyperlinkColor = "ff00dd00";
  libInstance.FontStep = 2;
  libInstance.FontSize = {};
  libInstance.FontFile = {};
  libInstance.FontFlags = {};
  libInstance.FontColor = { p = { 1, 1, 1, 1}, h = { 1, 1, 0, 1 } };
  libInstance.LineSpacing = { base = 1 } ;
  
  libInstance.description = libInstance.controlName .. "-Description";
  libInstance.editor = libInstance.controlName .. "-Editor";

  libInstance.Cursor = {
      http = "Interface\\CURSOR\\ArgusTeleporter.PNG",
      https = "Interface\\CURSOR\\BastionTeleporter.PNG",
      mailto = "Interface\\CURSOR\\Mail.PNG" };
  
  function libInstance.SetHyperlinkFormat()
    return "[|c" .. libInstance.HyperlinkColor .. "|H%s|h%s|h|r]";
  end;
    
  function libInstance.HyperlinkCursor(protocol)
    local linkcursor = libInstance.Cursor[protocol];
    if not linkcursor
    then return nil
    elseif type(linkcursor) == "string"
    then return linkcursor
    elseif type(linkcursor) == "function"
    then return linkcursor(protocol)
    end;
  end;
  
  libInstance.Popup = {
    http = {
      OnShow =
        function(self, data)
          self.text:SetFormattedText(libInstance.PopupPrefix .. "Copy the following URL for " .. data.name .. " and paste it into your browser, then close this window.");
          self.editBox:SetText(data.url);                        
          self.editBox:SetAutoFocus(true);
          self.editBox:HighlightText();                          
          self.editBox:SetWidth(300);
          self.button1:SetPoint("RIGHT", self, "RIGHT", -12, 0); 
          self.text:SetJustifyH("LEFT");
          self.text:SetSpacing(3);
        end,
      text = "",       
      wide = true, 
      closeButton  = true,
      button1 = libInstance.PopupOKButton,
      exclusive = true, 
      timeout = 60,
      whileDead = true, 
      hasEditBox = true, 
      OnAccept = function(self) self:Hide() end,
      enterClicksFirstButton = true, 
      hideOnEscape = true,
      EditBoxOnEnterPressed = function(self) self:GetParent():Hide() end,
      EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
    },
    mailto = {
      OnShow =
        function(self, data)
          self.text:SetFormattedText(libInstance.PopupPrefix .. "Copy the following email for " .. data.name .. ", then close this window.");
          self.editBox:SetText(data.addr);                        
          self.editBox:SetAutoFocus(true);
          self.editBox:HighlightText();                          
          self.editBox:SetWidth(300);
          self.button1:SetPoint("RIGHT", self, "RIGHT", -12, 0); 
          self.text:SetJustifyH("LEFT");
          self.text:SetSpacing(3);
        end,
      text = "",       
      wide = true, 
      closeButton  = true,
      button1 = libInstance.PopupOKButton, 
      exclusive = true, 
      timeout = 60,
      whileDead = true, 
      hasEditBox = true, 
      OnAccept = function(self) self:Hide() end,
      enterClicksFirstButton = true, 
      hideOnEscape = true,
      EditBoxOnEnterPressed = function(self) self:GetParent():Hide() end,
      EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
    },
  };
  
  libInstance.Popup.https = libInstance.Popup.http;

  libInstance.OpenProtocol = {
    http = 
      function(dest, link, text, ...)
        StaticPopupDialogs["ACEMARKDOWNCONTROL_OPEN_HTTP"] = libInstance.Popup.html;
        if link and text
        then StaticPopup_Show("ACEMARKDOWNCONTROL_OPEN_HTTP", nil, nil, { url = link, name = text });
        end
      end,
    https = 
      function(dest, link, text, ...)
        StaticPopupDialogs["ACEMARKDOWNCONTROL_OPEN_HTTP"] = libInstance.Popup.html;
        if link and text
        then StaticPopup_Show("ACEMARKDOWNCONTROL_OPEN_HTTP", nil, nil, { url = link, name = text });
        end
      end,
    mailto = 
      function(dest, link, text, ...)
        StaticPopupDialogs["ACEMARKDOWNCONTROL_OPEN_MAILTO"] = libInstance.Popup.mailto;
        if dest and text
        then StaticPopup_Show("ACEMARKDOWNCONTROL_OPEN_MAILTO", nil, nil, { addr = dest, name = text });
        end
      end,
  };
  
  function libInstance.OnHyperlinkClick(f, link, text, ...)
      local protocol =  link:match("^(%a+):");
      local dest     =  link:match(":(.+)");
      local handler = libInstance.OpenProtocol[protocol];
      if    handler then handler(dest, link, text, ...); end;
  end;
  
  function libInstance.OnHyperlinkEnter(f, link, text, button, ...)
      local protocol = link:match("^(%a+):");
      SetCursor(libInstance.HyperlinkCursor(protocol));
  end;
  
  function libInstance.OnHyperlinkLeave(f, link, text, button, ...)
      SetCursor(nil);
  end;
  
 
  local containerFrame = CreateFrame("Frame", nil, UIParent)
  containerFrame:SetSize(UIParent:GetHeight(), 300)
  containerFrame:SetPoint("TOPLEFT");
  containerFrame:SetPoint("BOTTOMRIGHT");
  containerFrame.html = CreateFrame("SimpleHTML", nil, containerFrame)
  containerFrame.html:SetSize(180, 170)
  containerFrame.html:SetPoint("BOTTOMRIGHT", containerFrame)
  containerFrame.html:SetPoint("TOPLEFT", containerFrame, "TOPLEFT", 0, 0)
  
  containerFrame.html:SetScript("OnHyperlinkClick", libInstance.OnHyperlinkClick);
  containerFrame.html:SetScript("OnHyperlinkEnter", libInstance.OnHyperlinkEnter);
  containerFrame.html:SetScript("OnHyperlinkLeave", libInstance.OnHyperlinkLeave);
  containerFrame.html:SetHyperlinksEnabled(libInstance.HyperlinksEnabled);
  containerFrame.html:SetHyperlinkFormat(libInstance.SetHyperlinkFormat());
  
  libInstance.containerFrame = containerFrame;

  local fontFile, fontSize, fontFlags = GameFontNormal:GetFont();
  local colorR, colorG, colorB, colorA = GameFontNormal:GetTextColor();
  libInstance.DefaultFont = 
    { file = fontFile,
      size = fontSize,
      flags = fontFlags,
      colorR = colorR,
      colorG = colorG,
      colorB = colorB,
      colorA = colorA };

  local function MarkdownControlConstructor()
        local widget = {};
        widget.type = libInstance.description;
        widget.frame = libInstance.containerFrame;
        widget.html = libInstance.containerFrame.html;
        widget.frame.obj = widget;

        local function donothing() end;
  
        widget["OnAcquire"] = function(self) 
          self:SetText(); 
          self:SetJustifyH("left");
          self:SetFonts();
          self.frame:SetWidth(width or 450);
          self.html:SetWidth((width or 450) - 70);
          self.frame:SetHeight(height or self.html:GetContentHeight());
          self:SetAllPoints();
          self.html:SetFont(     "h1",    libInstance.FontFile.h1     
                                       or libInstance.FontFile.h     
                                       or libInstance.FontFile.base 
                                       or libInstance.DefaultFont.file, 
                                          libInstance.FontSize.h1     
                                       or ((   libInstance.FontSize.h 
                                            or libInstance.FontSize.p     
                                            or libInstance.FontSize.base 
                                            or libInstance.DefaultFont.size) + 3 * libInstance.FontStep), 
                                          libInstance.FontFlags.h1    
                                       or libInstance.FontFlags.h     
                                       or libInstance.FontFlags.base
                                       or libInstance.DefaultFont.flags);
          self.html:SetTextColor("h1",    (libInstance.FontColor.h1   and libInstance.FontColor.h1[1])
                                       or (libInstance.FontColor.h    and libInstance.FontColor.h[1])
                                       or (libInstance.FontColor.base and libInstance.FontColor.base[1])
                                       or libInstance.DefaultFont.colorR,
                                          (libInstance.FontColor.h1   and libInstance.FontColor.h1[2])
                                       or (libInstance.FontColor.h    and libInstance.FontColor.h[2])
                                       or (libInstance.FontColor.base and libInstance.FontColor.base[2])
                                       or libInstance.DefaultFont.colorG,
                                          (libInstance.FontColor.h1   and libInstance.FontColor.h1[3])
                                       or (libInstance.FontColor.h    and libInstance.FontColor.h[3])
                                       or (libInstance.FontColor.base and libInstance.FontColor.base[3])
                                       or libInstance.DefaultFont.colorB,
                                          (libInstance.FontColor.h1   and libInstance.FontColor.h1[4])
                                       or (libInstance.FontColor.h    and libInstance.FontColor.h[4])
                                       or (libInstance.FontColor.base and libInstance.FontColor.base[4])
                                       or libInstance.DefaultFont.colorA);
          self.html:SetFont(     "h2",    libInstance.FontFile.h2     
                                       or libInstance.FontFile.h     
                                       or libInstance.FontFile.base 
                                       or libInstance.DefaultFont.file, 
                                          libInstance.FontSize.h2     
                                       or ((   libInstance.FontSize.h 
                                            or libInstance.FontSize.p     
                                            or libInstance.FontSize.base 
                                            or libInstance.DefaultFont.size) + 2 * libInstance.FontStep), 
                                          libInstance.FontFlags.h2    
                                       or libInstance.FontFlags.h     
                                       or libInstance.FontFlags.base
                                       or libInstance.DefaultFont.flags);
          self.html:SetTextColor("h2",    (libInstance.FontColor.h2   and libInstance.FontColor.h2[1])
                                       or (libInstance.FontColor.h    and libInstance.FontColor.h[1])
                                       or (libInstance.FontColor.base and libInstance.FontColor.base[1])
                                       or libInstance.DefaultFont.colorR,
                                          (libInstance.FontColor.h2   and libInstance.FontColor.h2[2])
                                       or (libInstance.FontColor.h    and libInstance.FontColor.h[2])
                                       or (libInstance.FontColor.base and libInstance.FontColor.base[2])
                                       or libInstance.DefaultFont.colorG,
                                          (libInstance.FontColor.h2   and libInstance.FontColor.h2[3])
                                       or (libInstance.FontColor.h    and libInstance.FontColor.h[3])
                                       or (libInstance.FontColor.base and libInstance.FontColor.base[3])
                                       or libInstance.DefaultFont.colorB,
                                          (libInstance.FontColor.h2   and libInstance.FontColor.h2[4])
                                       or (libInstance.FontColor.h    and libInstance.FontColor.h[4])
                                       or (libInstance.FontColor.base and libInstance.FontColor.base[4])
                                       or libInstance.DefaultFont.colorA);
          self.html:SetFont(     "h3",    libInstance.FontFile.h3     
                                       or libInstance.FontFile.h     
                                       or libInstance.FontFile.base 
                                       or libInstance.DefaultFont.file, 
                                          libInstance.FontSize.h3     
                                       or ((   libInstance.FontSize.h 
                                            or libInstance.FontSize.p     
                                            or libInstance.FontSize.base 
                                            or libInstance.DefaultFont.size) + 1 * libInstance.FontStep), 
                                          libInstance.FontFlags.h3    
                                       or libInstance.FontFlags.h     
                                       or libInstance.FontFlags.base
                                       or libInstance.DefaultFont.flags);
          self.html:SetTextColor("h3",    (libInstance.FontColor.h3   and libInstance.FontColor.h3[1])
                                       or (libInstance.FontColor.h    and libInstance.FontColor.h[1])
                                       or (libInstance.FontColor.base and libInstance.FontColor.base[1])
                                       or libInstance.DefaultFont.colorR,
                                          (libInstance.FontColor.h3   and libInstance.FontColor.h3[2])
                                       or (libInstance.FontColor.h    and libInstance.FontColor.h[2])
                                       or (libInstance.FontColor.base and libInstance.FontColor.base[2])
                                       or libInstance.DefaultFont.colorG,
                                          (libInstance.FontColor.h3   and libInstance.FontColor.h3[3])
                                       or (libInstance.FontColor.h    and libInstance.FontColor.h[3])
                                       or (libInstance.FontColor.base and libInstance.FontColor.base[3])
                                       or libInstance.DefaultFont.colorB,
                                          (libInstance.FontColor.h3   and libInstance.FontColor.h3[4])
                                       or (libInstance.FontColor.h    and libInstance.FontColor.h[4])
                                       or (libInstance.FontColor.base and libInstance.FontColor.base[4])
                                       or libInstance.DefaultFont.colorA);
          self.html:SetFont(     "p",     libInstance.FontFile.p     
                                       or libInstance.FontFile.base 
                                       or libInstance.DefaultFont.file, 
                                          libInstance.FontSize.p     
                                       or libInstance.FontSize.base 
                                       or libInstance.DefaultFont.size,
                                          libInstance.FontFlags.p    
                                       or libInstance.FontFlags.base
                                       or libInstance.DefaultFont.flags);
          self.html:SetTextColor("p",    (libInstance.FontColor.p   and libInstance.FontColor.p[1])
                                       or (libInstance.FontColor.base and libInstance.FontColor.base[1])
                                       or libInstance.DefaultFont.colorR,
                                          (libInstance.FontColor.p   and libInstance.FontColor.p[2])
                                       or (libInstance.FontColor.base and libInstance.FontColor.base[2])
                                       or libInstance.DefaultFont.colorG,
                                          (libInstance.FontColor.p   and libInstance.FontColor.p[3])
                                       or (libInstance.FontColor.base and libInstance.FontColor.base[3])
                                       or libInstance.DefaultFont.colorB,
                                          (libInstance.FontColor.p   and libInstance.FontColor.p[4])
                                       or (libInstance.FontColor.base and libInstance.FontColor.base[4])
                                       or libInstance.DefaultFont.colorA);

          self.html:SetSpacing("h1", libInstance.LineSpacing.h1 or (libInstance.LineSpacing.h or libInstance.LineSpacing.base) * 3);
          self.html:SetSpacing("h2", libInstance.LineSpacing.h2 or (libInstance.LineSpacing.h or libInstance.LineSpacing.base) * 2);
          self.html:SetSpacing("h3", libInstance.LineSpacing.h3 or (libInstance.LineSpacing.h or libInstance.LineSpacing.base) * 1);
          self.html:SetSpacing("p",  libInstance.LineSpacing.p                                or libInstance.LineSpacing.base  * 1);

        end;
  
        widget["Show"]                 = function(self, ...) self.frame:Show(); end;
        widget["SetAllPoints"]         = function(self, ...) self.frame:SetAllPoints(); end;
        widget["SetSpacing"]           = function(self, ...) self.html:SetSpacing(...); end;
        widget["SetColor"]             = donothing;
        widget["OnWidthGet"]           = donothing;
        widget["SetColor"]             = donothing;
        widget["SetImage"]             = donothing;
        widget["SetFont"]              = function(self, ...) self.html:SetFont(...); end;
        widget["SetFonts"]             = function(self)
                                         end;
        widget["SetFontObject"]        = function(self, element, fontObject) self.html:SetFontObject(element, fontObject); end;
        widget["SetImageSize"]         = donothing;
        widget["SetJustifyH"]          = function(self, ...)  self.html:SetJustifyH(...); end;
        widget["SetJustifyV"]          = function(self, ...)  self.html:SetJustifyV(...); end;
        widget["SetText"]              = function(self, text) 
                                           self.markdown = text;
                                           if libInstance.ShowMarkdown 
                                           then self.html:SetText(text or "<no markdown>")
                                           elseif libInstance.ShowHTML
                                           then self.html:SetText("HTML Source: \n\n" .. LMD:ToHTML(text or ""))  
                                           else self.html:SetText(LMD:ToHTML(text or ""))  
                                           end;
                                           self.frame:SetHeight(self.html:GetContentHeight()); 
                                         end;
        widget["SetScript"]            = function(self, ...)  self.html:SetScript(...) end;
        widget["GetMarkdown"]          = function(self) return self.markdown or "" end;
  
        AceGUI:RegisterAsWidget(widget);
        return widget; -- beep
    end; -- constructor
  AceGUI:RegisterWidgetType(libInstance.description, MarkdownControlConstructor, ACEMARKDOWNCONTROL_MINOR);

  return libInstance;
end;
  
lib:New("Markdown");
