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

RPTAGS.queue:WaitUntil("MODULE_C",
function(self, event, ...)
  local registerFunction = RPTAGS.utils.modules.registerFunction;

  local function openUIPanel(panel)
    return 
      function()
        RPTAGS.utils.links.handler(RPTAGS.CONST.UIPANELS[panel]);
      end;
  end;

  registerFunction(RPTAGS.addOnName, "options", openUIPanel("options" ));
  registerFunction(RPTAGS.addOnName, "version", openUIPanel("version" ));
  registerFunction(RPTAGS.addOnName, "help",    openUIPanel("help"    ));
  registerFunction(RPTAGS.addOnName, "about",   openUIPanel("about"   ));
end);

RPTAGS.queue:WaitUntil("CORE_KEYBIND",
function(self, event, ...)
  _G["BINDING_HEADER_RPTAGS"] = RPTAGS.utils.locale.loc("APP_NAME");
end);
  
RPTAGS.queue:WaitUntil("INIT_DATA",    function(self, event, ...) RPTAGS.CONST         = RPTAGS.CONST         or {} end);
RPTAGS.queue:WaitUntil("INIT_CACHE",   function(self, event, ...) RPTAGS.cache         = RPTAGS.cache         or {} end);
RPTAGS.queue:WaitUntil("INIT_LOCALE",  function(self, event, ...) RPTAGS.locale        = RPTAGS.locale        or {} end);
RPTAGS.queue:WaitUntil("INIT_UTILS",   function(self, event, ...) RPTAGS.utils         = RPTAGS.utils         or {} end);
RPTAGS.queue:WaitUntil("INIT_OPTIONS", 
  function(self, event, ...) 
    RPTAGS.options = RPTAGS.options             or {};
    RPTAGS.cache.options = RPTAGS.cache.options or {};
    RPTAGS.cache.options.optionsOrder = { "general", "colors", "help", "about" };
    RPTAGS.cache.options.optionsPanels = {};
    RPTAGS.cache.options.optionsModulesInsert = 3;
  end);
