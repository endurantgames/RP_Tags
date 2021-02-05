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
RPTAGS.queue:WaitUntil("after UTILS_OPTIONS",
function(self, event, ...)
-- RPQ ----------------------------------------------------------------------------------------------------------------------------------

  ACEMARKDOWNWIDGET_CONFIG.HtmlStyles.Normal.red   = 1;
  ACEMARKDOWNWIDGET_CONFIG.HtmlStyles.Normal.green = 1;
  ACEMARKDOWNWIDGET_CONFIG.HtmlStyles.Normal.blue  = 1;

  ACEMARKDOWNWIDGET_CONFIG.LinkProtocols.opt =
    { Cursor = "Interface\\CURSOR\\QuestTurnIn.PNG",
      CustomClick = RPTAGS.utils.options.open };
    
  ACEMARKDOWNWIDGET_CONFIG.LinkProtocols.help =
    { Cursor = "Interface\\CURSOR\\QuestRepeatable.PNG",
      CustomClick = RPTAGS.utils.options.open };
    
  ACEMARKDOWNWIDGET_CONFIG.LinkProtocols.urldb =
    { Cursor = "Interface\\CURSOR\\MapPinCursor.PNG",
      CustomClick = RPTAGS.utils.options.open };

  ACEMARKDOWNWIDGET_CONFIG.LinkProtocols.setting =
    { Cursor = "Interface\\CURSOR\\Interact.PNG",
      CustomClick = RPTAGS.utils.options.open };
    
  ACEMARKDOWNWIDGET_CONFIG.LinkProtocols.tag =
    { Cursor = "Interface\\CURSOR\\Interact.PNG",
      CustomClick = RPTAGS.utils.options.open };

-- /RPQ ---------------------------------------------------------------------------------------------------------------------------------
end);
