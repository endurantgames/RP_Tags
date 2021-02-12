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

  ACEMARKDOWNWIDGET_CONFIG.LibMarkdownConfig[ "pre"] =  "<h3>|cff00ffff";
  ACEMARKDOWNWIDGET_CONFIG.LibMarkdownConfig["/pre"] = "|r</h3>";
  ACEMARKDOWNWIDGET_CONFIG.LibMarkdownConfig[ "code"] =  "<h3>|cff00ffff";
  ACEMARKDOWNWIDGET_CONFIG.LibMarkdownConfig["/code"] = "|r</h3>";
  ACEMARKDOWNWIDGET_CONFIG.LibMarkdownConfig[ "code"] =  "<h3>|cff00ffff";
  ACEMARKDOWNWIDGET_CONFIG.LibMarkdownConfig["/code"] = "|r</h3>";
  ACEMARKDOWNWIDGET_CONFIG.LibMarkdownConfig[ "h3"  ] =  "<h2>";
  ACEMARKDOWNWIDGET_CONFIG.LibMarkdownConfig["/h3"  ] = "</h2>";

  ACEMARKDOWNWIDGET_CONFIG.HtmlStyles["Normal"].Spacing = 2;

  ACEMARKDOWNWIDGET_CONFIG.HtmlStyles.Normal.red   = 1;
  ACEMARKDOWNWIDGET_CONFIG.HtmlStyles.Normal.green = 1;
  ACEMARKDOWNWIDGET_CONFIG.HtmlStyles.Normal.blue  = 1;

  ACEMARKDOWNWIDGET_CONFIG.HtmlStyles["Heading 3"].FontFile =
    LibSharedMedia:Fetch(LibSharedMedia.MediaType.FONT, RPTAGS.CONST.FONT.FIXED) 
    or LibSharedMedia:GetDefault(LibSharedMedia.MediaType.FONT);
  ACEMARKDOWNWIDGET_CONFIG.HtmlStyles["Heading 3"].red   = 0.000;
  ACEMARKDOWNWIDGET_CONFIG.HtmlStyles["Heading 3"].green = 1.000;
  ACEMARKDOWNWIDGET_CONFIG.HtmlStyles["Heading 3"].blue  = 1.000;
  ACEMARKDOWNWIDGET_CONFIG.HtmlStyles["Heading 3"].Spacing = 6;
  ACEMARKDOWNWIDGET_CONFIG.HtmlStyles["Heading 3"].JustifyH = "CENTER";

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
