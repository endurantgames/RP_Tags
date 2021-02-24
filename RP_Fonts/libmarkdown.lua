-- RP Fonts
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 


if not RPTAGS
then 
  local htmlCodes   =
  { ["blockquote"]  = "<br /><p>" .. "|cffff00ff",
    ["/blockquote"] = "|r</p><br />",
    ["pre"]         = "<br /><p>" .. "|cff00ffff",
    ["/pre"]     = "|r</p><br />",
    ["h2"]          = "<br /><h2>",
    ["h3"]          = "<br /><h3>",
    ["ul"]           = "<br />",
    ["/ul"]          = "<br />",
    ["li"]           = "<p>",
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
end;
