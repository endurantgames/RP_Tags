local addOnName, ns = ...;

local fontName     = "Share Tech Mono";
local license      =
{ license          = "OFL",
  licenseUrl       = "http://scripts.sil.org/OFL",
  date             = "2012",
  reservedFontName = "Share",
  person           = "Ralph du Carrois",
  personEmail      = "postcarrois.com",
  personUrl        = nil,
  company          = "Carrois Type Design",
  companyEmail     = nil,
  companyUrl       = "http://www.carrois.com",
};

RP_Fonts.tmp[fontName].license = license;
