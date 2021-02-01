local RPTAGS = RPTAGS;
RPTAGS.queue:WaitUntil("ADDON_INIT", 
function(self, event, ...)
-- RPQ -----------------------------------------------------------------------------------------------------------------------------------
  
  RPTAGS.metadata = {};
  
  for _, i in ipairs({"Interface", "Version", "Title", "Author", "Notes", 
                      "OptionalDeps", "RequiredDeps", "URL", "SavedVariables", 
                      "X-oUF", "X-RPQVersion" })
  do  RPTAGS.metadata[i] = GetAddOnMetadata(RPTAGS.addOnName, i);
  end;
  
  -- make sure our saved values exist
  --
  _G["RP_TagsDB"]          = _G["RP_TagsDB"]          or {};
  _G["RP_TagsDB"].settings = _G["RP_TagsDB"].settings or {};
  
  -- /RPQ ----------------------------------------------------------------------------------------------------------------------------------
end);

RPTAGS.queue:WaitUntil("INIT_DATA",    function(self, event, ...) RPTAGS.CONST         = RPTAGS.CONST         or {} end);
RPTAGS.queue:WaitUntil("INIT_CACHE",   function(self, event, ...) RPTAGS.cache         = RPTAGS.cache         or {} end);
RPTAGS.queue:WaitUntil("INIT_LOCALE",  function(self, event, ...) RPTAGS.locale        = RPTAGS.locale        or {} end);
RPTAGS.queue:WaitUntil("INIT_UTILS",   function(self, event, ...) RPTAGS.utils         = RPTAGS.utils         or {} end);
RPTAGS.queue:WaitUntil("INIT_OPTIONS", function(self, event, ...) RPTAGS.cache.options = RPTAGS.cache.options or {} end);

local RPTAGS     = RPTAGS;
RPTAGS.queue:WaitUntil("INIT_OPTIONS",
function(self, event, ...)
-- RPQ ----------------------------------------------------------------------------------------------------------------------------------

  local CONST      = RPTAGS.CONST;
  
  local loc        = RPTAGS.utils.locale.loc;
  local notify     = RPTAGS.utils.text.notify;
  local APP_NAME   = loc("APP_NAME");
  
  local AceMarkdownControl = LibStub("AceMarkdownControl-3.0"):New();
  local AceConfigDialog = LibStub("AceConfigDialog-3.0");
  
  AceMarkdownControl.FontStep         = 4;
  AceMarkdownControl.FontFile.h3      = RPTAGS.CONST.FONT.FIXED;
  AceMarkdownControl.FontSize.h3      = 10;
  AceMarkdownControl.FontColor.h3     = { 0.0, 0.9, 0.9, 1};
  AceMarkdownControl.LineSpacing.h3   = 10;
  AceMarkdownControl.LineSpacing.base = 3;
  AceMarkdownControl.PopupPrefix      = APP_NAME;
  AceMarkdownControl.Cursor.help      = "Interface\\CURSOR\\QuestRepeatable.PNG";
  AceMarkdownControl.Cursor.urldb     = "Interface\\CURSOR\\MapPinCursor.PNG";
  AceMarkdownControl.Cursor.setting   = "Interface\\CURSOR\\Interact.PNG";
  
  AceMarkdownControl.OpenProtocol.urldb = function(dest, link, text, ... )
    local linkData = RPTAGS.CONST.URLS[dest];
    if dest and linkData
    then StaticPopupDialogs["ACEMARKDOWNCONTROL_OPEN_HTTP"] = ADMC.Popup.html;
    StaticPopup_Show("ACEMARKDOWNCONTROL_OPEN_HTTP", nil, nil, { url = loc(linkData.url), name = loc(linkData.name) });
    end;
  end;
  
  AceMarkdownControl.OpenProtocol.help = function(dest, link, text, ... )
    if dest and RPTAGS.cache.Tag_Groups[dest:upper()]
    then AceConfigDialog:SelectGroup(APP_NAME, "tagReference", dest:upper());
    end;
  end;
  
  AceMarkdownControl.OpenProtocol.setting = function(dest, link, text, ... )
    local path = RPTAGS.utils.text.split(dest, "/");
    AceConfigDialog:SelectGroup(APP_NAME, unpack(path));
  end;

  RPTAGS.cache.AceMarkdownControl = AceMarkdownControl;

-- /RPQ ---------------------------------------------------------------------------------------------------------------------------------
end);
