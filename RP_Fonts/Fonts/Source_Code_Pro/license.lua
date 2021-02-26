local addOnName, ns = ...;

local fontName     = "Source Code Pro";
local license      =
{ license          = "OFL",
  licenseUrl       = "http://scripts.sil.org/OFL",
  date             = "2010, 2012",
  reservedFontName = "Source",
  person           = nil,
  personEmail      = nil,
  personUrl        = nil,
  company          = "Adobe Systems Incorporated",
  companyEmail     = nil,
  companyUrl       = "http://www.adobe.com/",
};


RP_Fonts.tmp[ fontName .. ""                    ].license = license;
RP_Fonts.tmp[ fontName .. " Black"              ].license = license;
RP_Fonts.tmp[ fontName .. " Black Italic"       ].license = license;
RP_Fonts.tmp[ fontName .. " Bold"               ].license = license;
RP_Fonts.tmp[ fontName .. " Bold Italic"        ].license = license;
RP_Fonts.tmp[ fontName .. " Extra Light"        ].license = license;
RP_Fonts.tmp[ fontName .. " Extra Light Italic" ].license = license;
RP_Fonts.tmp[ fontName .. " Italic"             ].license = license;
RP_Fonts.tmp[ fontName .. " Light"              ].license = license;
RP_Fonts.tmp[ fontName .. " Light Italic"       ].license = license;
RP_Fonts.tmp[ fontName .. " Medium"             ].license = license;
RP_Fonts.tmp[ fontName .. " Medium Italic"      ].license = license;
RP_Fonts.tmp[ fontName .. " Semi-Bold"          ].license = license;
RP_Fonts.tmp[ fontName .. " Semi-Bold Italic"   ].license = license;

