-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 

local RPTAGS          = RPTAGS;

RPTAGS.queue:WaitUntil("UTILS_OPTIONS",
function(self, event, ...)
-- RPQ -----------------------------------------------------------------------------------------------------------------------------------------------
  
  local LibSharedMedia = LibStub("LibSharedMedia-3.0");

  local Utils       = RPTAGS.utils;
  local linkHandler = Utils.links.handlerCustomClick;
  local loc         = Utils.locale.loc;
  local nbsp        = RPTAGS.CONST.NBSP;

  local htmlCodes   =
  { ["blockquote"]  = "<br /><p>" .. nbsp .. "|cffff00ff",
    ["/blockquote"] = "|r</p><br />",
    ["pre"]         = "<br /><p>" .. nbsp .. "|cff00ffff",
    ["/pre"]     = "|r</p><br />",
    ["h2"]          = "<br /><h2>",
    ["h3"]          = "<br /><h3>",
    ["ul"]           = "<br />",
    ["/ul"]          = "<br />",
    ["li"]           = "<p>" .. nbsp,
    ["/li"]          = "</p>",
    ["list_marker"] = "|TInterface\\COMMON\\Indicator-Yellow.PNG:0|t",
  };

  for k, v in pairs(htmlCodes)
  do ACEMARKDOWNWIDGET_CONFIG.LibMarkdownConfig[k] = v;
  end;

  ACEMARKDOWNWIDGET_CONFIG.HtmlStyles["Normal"].Spacing = 2;

  ACEMARKDOWNWIDGET_CONFIG.HtmlStyles.Normal.red   = 1;
  ACEMARKDOWNWIDGET_CONFIG.HtmlStyles.Normal.green = 1;
  ACEMARKDOWNWIDGET_CONFIG.HtmlStyles.Normal.blue  = 1;

  ACEMARKDOWNWIDGET_CONFIG.LinkProtocols.default.Popup =
    { Text = loc("LINK_DEFAULT_TEXT"),
      PrefixText = loc("APP_NAME") .. "\n\n",
      ButtonText = loc("UI_GOT_IT"), 
    };

  ACEMARKDOWNWIDGET_CONFIG.LinkProtocols.http.Popup =
    { Text = loc("LINK_HTTP_TEXT"),
      PrefixText = loc("APP_NAME") .. "\n\n",
      ButtonText = loc("UI_GOT_IT"), 
    };

  ACEMARKDOWNWIDGET_CONFIG.LinkProtocols.https.Popup =
    { Text = loc("LINK_HTTPS_TEXT"),
      PrefixText = loc("APP_NAME") .. "\n\n",
      ButtonText = loc("UI_GOT_IT"), 
    };

  ACEMARKDOWNWIDGET_CONFIG.LinkProtocols.mailto.Popup =
    { Text = loc("LINK_MAILTO_TEXT"),
      PrefixText = loc("APP_NAME") .. "\n\n",
      ButtonText = loc("UI_GOT_IT"), 
    };

  ACEMARKDOWNWIDGET_CONFIG.LinkProtocols.opt =
    { Cursor = "Interface\\CURSOR\\QuestTurnIn.PNG",
      CustomClick = linkHandler,
    };
    
  ACEMARKDOWNWIDGET_CONFIG.LinkProtocols.help =
    { Cursor = "Interface\\CURSOR\\QuestRepeatable.PNG",
      CustomClick = linkHandler,
    };
    
  ACEMARKDOWNWIDGET_CONFIG.LinkProtocols.urldb =
    -- { Cursor = "Interface\\CURSOR\\MapPinCursor.PNG",
    { Cursor = "Interface\\CURSOR\\QuestRepeatable.PNG",
      CustomClick = linkHandler,
      Popup = 
      { Text = loc("LINK_URLDB_TEXT"),
        PrefixText = loc("APP_NAME") .. "\n\n",
        ButtonText = loc("UI_GOT_IT"), 
      },
    };

  ACEMARKDOWNWIDGET_CONFIG.LinkProtocols.setting =
    { Cursor = "Interface\\CURSOR\\Interact.PNG",
      CustomClick = linkHandler,
    };
    
  ACEMARKDOWNWIDGET_CONFIG.LinkProtocols.tag =
    { Cursor = "Interface\\CURSOR\\Interact.PNG",
      CustomClick = linkHandler, 
    };

  ACEMARKDOWNWIDGET_CONFIG.LinkProtocols.addon =
    { Cursor = "Interface\\CURSOR\\Trainer.PNG",
      CustomClick = linkHandler,
    };
 
-- RPQ -----------------------------------------------------------------------------------------------------------------------------------------------
end);
