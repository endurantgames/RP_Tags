error([===[

    This file isn't meant to be run by itself. This is an example
    that can serve as a base for customizing your own default settings.

]===]);
local myConfig = _G[ "ACEMARKDOWNWIDGET_CONFIG" ];

-- myConfig[ "HyperlinksEnabled"  ]                  = true;
-- myConfig[ "HyperlinkFormat"    ]                  = "[ " .. "|c" .. "ff00dd00" .. "|H%s|h%s|h" .. "|r" .. " ] ";
-- myConfig[ "LargeFont"          ]                  = "OptionsFontLarge";
-- myConfig[ "FontStep"           ]                  = 2;
-- myConfig[ "LibMarkdownOptions" ][ "list-marker" ] = "|TInterface\\COMMON\\Indicator-Yellow.PNG:0|t";

-- myConfig[ "HtmlStyles" ][ "Normal"    ][ "FontFile"       ] , _ = select(1, GameFontNormal:GetFont());
-- myConfig[ "HtmlStyles" ][ "Normal"    ][ "FontSize"       ] , _ = select(2, GameFontNormal:GetFont());
-- myConfig[ "HtmlStyles" ][ "Normal"    ][ "FontFlags"      ] , _ = select(3, GameFontNormal:GetFont());
-- myConfig[ "HtmlStyles" ][ "Normal"    ][ "JustifyH"       ] = "LEFT";
-- myConfig[ "HtmlStyles" ][ "Normal"    ][ "JustifyV"       ] = "TOP";
-- myConfig[ "HtmlStyles" ][ "Normal"    ][ "red"            ] , _ = select(1, GameFontNormal:GetTextColor());
-- myConfig[ "HtmlStyles" ][ "Normal"    ][ "green"          ] , _ = select(2, GameFontNormal:GetTextColor());
-- myConfig[ "HtmlStyles" ][ "Normal"    ][ "blue"           ] , _ = select(3, GameFontNormal:GetTextColor());
-- myConfig[ "HtmlStyles" ][ "Normal"    ][ "Spacing"        ] = GameFontNormal:GetSpacing();
-- myConfig[ "HtmlStyles" ][ "Normal"    ][ "FontStepFactor" ] = 0;

-- myConfig[ "HtmlStyles" ][ "Highlight" ][ "FontFile"       ] , _ = select(1, GameFontNormal:GetFont());
-- myConfig[ "HtmlStyles" ][ "Highlight" ][ "FontSize"       ] , _ = select(2, GameFontNormal:GetFont());
-- myConfig[ "HtmlStyles" ][ "Highlight" ][ "FontFlags"      ] , _ = select(3, GameFontNormal:GetFont());
-- myConfig[ "HtmlStyles" ][ "Highlight" ][ "JustifyH"       ] = "LEFT";
-- myConfig[ "HtmlStyles" ][ "Highlight" ][ "JustifyV"       ] = "TOP";
-- myConfig[ "HtmlStyles" ][ "Highlight" ][ "red"            ] = 1.000;
-- myConfig[ "HtmlStyles" ][ "Highlight" ][ "green"          ] = 1.000;
-- myConfig[ "HtmlStyles" ][ "Highlight" ][ "blue"           ] = 0.100;
-- myConfig[ "HtmlStyles" ][ "Highlight" ][ "Spacing"        ] = GameFontNormal:GetSpacing();
-- myConfig[ "HtmlStyles" ][ "Highlight" ][ "FontStepFactor" ] = 0;

-- myConfig[ "HtmlStyles" ][ "Green"     ][ "FontFile"       ] , _ = select(1, GameFontNormal:GetFont());
-- myConfig[ "HtmlStyles" ][ "Green"     ][ "FontSize"       ] , _ = select(2, GameFontNormal:GetFont());
-- myConfig[ "HtmlStyles" ][ "Green"     ][ "FontFlags"      ] , _ = select(3, GameFontNormal:GetFont());
-- myConfig[ "HtmlStyles" ][ "Green"     ][ "JustifyH"       ] = "LEFT";
-- myConfig[ "HtmlStyles" ][ "Green"     ][ "JustifyV"       ] = "TOP";
-- myConfig[ "HtmlStyles" ][ "Green"     ][ "red"            ] = 0.000;
-- myConfig[ "HtmlStyles" ][ "Green"     ][ "green"          ] = 1.000;
-- myConfig[ "HtmlStyles" ][ "Green"     ][ "blue"           ] = 0.100;
-- myConfig[ "HtmlStyles" ][ "Green"     ][ "Spacing"        ] = GameFontNormal:GetSpacing();
-- myConfig[ "HtmlStyles" ][ "Green"     ][ "FontStepFactor" ] = 0;

-- myConfig[ "HtmlStyles" ][ "Heading 1" ][ "FontFile"       ] , _ = select(1, GameFontNormal:GetFont());
-- myConfig[ "HtmlStyles" ][ "Heading 1" ][ "FontSize"       ] , _ = select(2, GameFontNormal:GetFont());
-- myConfig[ "HtmlStyles" ][ "Heading 1" ][ "FontFlags"      ] , _ = select(3, GameFontNormal:GetFont());
-- myConfig[ "HtmlStyles" ][ "Heading 1" ][ "JustifyH"       ] = "LEFT";
-- myConfig[ "HtmlStyles" ][ "Heading 1" ][ "JustifyV"       ] = "TOP";
-- myConfig[ "HtmlStyles" ][ "Heading 1" ][ "red"            ] = 1.000;
-- myConfig[ "HtmlStyles" ][ "Heading 1" ][ "green"          ] = 1.000;
-- myConfig[ "HtmlStyles" ][ "Heading 1" ][ "blue"           ] = 0.100;
-- myConfig[ "HtmlStyles" ][ "Heading 1" ][ "Spacing"        ] = GameFontNormal:GetSpacing() + 3;
-- myConfig[ "HtmlStyles" ][ "Heading 1" ][ "FontStepFactor" ] = 3;

-- myConfig[ "HtmlStyles" ][ "Heading 2" ][ "FontFile"       ] , _ = select(1, GameFontNormal:GetFont());
-- myConfig[ "HtmlStyles" ][ "Heading 2" ][ "FontSize"       ] , _ = select(2, GameFontNormal:GetFont());
-- myConfig[ "HtmlStyles" ][ "Heading 2" ][ "FontFlags"      ] , _ = select(3, GameFontNormal:GetFont());
-- myConfig[ "HtmlStyles" ][ "Heading 2" ][ "JustifyH"       ] = "LEFT";
-- myConfig[ "HtmlStyles" ][ "Heading 2" ][ "JustifyV"       ] = "TOP";
-- myConfig[ "HtmlStyles" ][ "Heading 2" ][ "red"            ] = 1.000;
-- myConfig[ "HtmlStyles" ][ "Heading 2" ][ "green"          ] = 1.000;
-- myConfig[ "HtmlStyles" ][ "Heading 2" ][ "blue"           ] = 0.100;
-- myConfig[ "HtmlStyles" ][ "Heading 2" ][ "Spacing"        ] = GameFontNormal:GetSpacing() + 2;
-- myConfig[ "HtmlStyles" ][ "Heading 2" ][ "FontStepFactor" ] = 2;

-- myConfig[ "HtmlStyles" ][ "Heading 3" ][ "FontFile"       ] , _ = select(1, GameFontNormal:GetFont());
-- myConfig[ "HtmlStyles" ][ "Heading 3" ][ "FontSize"       ] , _ = select(2, GameFontNormal:GetFont());
-- myConfig[ "HtmlStyles" ][ "Heading 3" ][ "FontFlags"      ] , _ = select(3, GameFontNormal:GetFont());
-- myConfig[ "HtmlStyles" ][ "Heading 3" ][ "JustifyH"       ] = "LEFT";
-- myConfig[ "HtmlStyles" ][ "Heading 3" ][ "JustifyV"       ] = "TOP";
-- myConfig[ "HtmlStyles" ][ "Heading 3" ][ "red"            ] = 1.000;
-- myConfig[ "HtmlStyles" ][ "Heading 3" ][ "green"          ] = 1.000;
-- myConfig[ "HtmlStyles" ][ "Heading 3" ][ "blue"           ] = 0.100;
-- myConfig[ "HtmlStyles" ][ "Heading 3" ][ "Spacing"        ] = GameFontNormal:GetSpacing() + 1;
-- myConfig[ "HtmlStyles" ][ "Heading 3" ][ "FontStepFactor" ] = 1;

-- myConfig[ "HtmlTagStyles" ][ "h1" ] = "Heading 1";
-- myConfig[ "HtmlTagStyles" ][ "h2" ] = "Heading 2";
-- myConfig[ "HtmlTagStyles" ][ "h3" ] = "Heading 3";
-- myConfig[ "HtmlTagStyles" ][ "p"  ] = "Normal";

-- myConfig[ "ImportedHtmlStyles" ] = { "GameFontNormal", "GameFontNormalSmall", "GameFontNormalLarge" "OptionsFontSmall", "OptionsFontHighlight", "OptionsFontLarge" };

-- myConfig[ "LinkProtocols" ][ "default" ][ "Cursor" ]                  = "Interface\\CURSOR\\Cast.PNG";
-- myConfig[ "LinkProtocols" ][ "default" ][ "Popup"  ][ "Text"       ]  = "Copy the following, then close this window";
-- myConfig[ "LinkProtocols" ][ "default" ][ "Popup"  ][ "ButtonText" ]  = "Got It";
-- myConfig[ "LinkProtocols" ][ "http"    ][ "Cursor" ]                  = "Interface\\CURSOR\\BastionTeleporter.PNG";
-- myConfig[ "LinkProtocols" ][ "http"    ][ "Popup"  ][ "Text"       ]  = "Copy the following URL for {text} and paste it into your browser, then close this window.";
-- myConfig[ "LinkProtocols" ][ "http"    ][ "Popup"  ][ "ButtonText" ]  = "Got It";
-- myConfig[ "LinkProtocols" ][ "https"   ][ "Cursor" ]                  = "Interface\\CURSOR\\ArgusTeleporter.PNG";
-- myConfig[ "LinkProtocols" ][ "https"   ][ "Popup"  ][ "Text"       ]  = "Copy the following URL for {text} and paste it into your browser, then close this window.";
-- myConfig[ "LinkProtocols" ][ "https"   ][ "Popup"  ][ "ButtonText" ]  = "Got It";
-- myConfig[ "LinkProtocols" ][ "mailto"  ][ "Cursor" ]                  = "Interface\\CURSOR\\ArgusTeleporter.PNG";
-- myConfig[ "LinkProtocols" ][ "mailto"  ][ "Popup"  ][ "Text"       ]  = "Copy the following email address for {text}, then close this window";
-- myConfig[ "LinkProtocols" ][ "mailto"  ][ "Popup"  ][ "ButtonText" ]  = "Got It";


