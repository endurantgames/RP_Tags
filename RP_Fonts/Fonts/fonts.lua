local addOn    , ns = ...;

local LibSharedMedia=LibStub("LibSharedMedia-3.0");
local baseFontDir = "Interface\\AddOns\\" .. addOn     .. "\\Fonts\\";

ns.RP_Fonts = ns.RP_Fonts or {};
ns.RP_Fonts.tmp = ns.RP_Fonts.tmp or {};


local family = { 
  Source = baseFontDir .. "Source_Code_Pro\\SourceCodePro-",
  Share  = baseFontDir .. "ShareTechMono\\ShareTechMono-",
  Syne   = baseFontDir .. "Syne_Mono\\SyneMono-",
  MrsStD = baseFontDir .. "Mrs_Saint_Delafield\\MrsSaintDelafield-",
  Amara  = baseFontDir .. "Amarante\\Amarante-",
  Arima  = baseFontDir .. "Arima_Madurai\\ArimaMadurai-",
  Barlow = baseFontDir .. "Barlow_Condensed\\BarlowCondensed-",
  Bebas  = baseFontDir .. "Bebas_Neue\\BebasNeue-",
  BigSho = baseFontDir .. "Big_Shoulders_Stencil_Display\\BigShouldersStencilDisplay-",
  Bitter = baseFontDir .. "Bitter\\static\\Bitter-",
  Bree   = baseFontDir .. "Bree_Serif\\BreeSerif-",
  Cedar  = baseFontDir .. "Cedarville_Cursive\\CedarvilleCursive-",
  DotG16 = baseFontDir .. "DotGothic16\\DotGothic16-",
  East   = baseFontDir .. "East_Sea_Dokdo\\EastSeaDokdo-",
  Flame  = baseFontDir .. "Flamenco\\Flamenco-",
  Fonda  = baseFontDir .. "Fondamento\\Fontamento-",
  FontDS = baseFontDir .. "Fontdiner_Swanky\\FontdinerSwanky-",
  IMFell = baseFontDir .. "IM_Fell\\IMFell",
  Krona  = baseFontDir .. "Krona_One\\KronaOne-",
  Merri  = baseFontDir .. "Merriweather_Sans\\static\\MerriweatherSans-",
  MtXmas = baseFontDir .. "Mountains_of_Christmas\\MountainsofChristmas-",
  Oswald = baseFontDir .. "Oswald\\static\\Oswald-",
  Poppi  = baseFontDir .. "Poppins\\Poppins-",
  Press  = baseFontDir .. "Press_Start_2P\\PressStart2P-",
  Prince = baseFontDir .. "Princess_Sofia\\PrincessSofia-",
  Reggae = baseFontDir .. "Reggae_One\\ReggaeOne-",
  Uncial = baseFontDir .. "Uncial_Antiqua\\UncialAntiqua-",

};


local BLK        = "Black.ttf";
local BLK_ITA    = "BlackItalic.ttf";
local BOLD       = "Bold.ttf";
local BOLD_ITA   = "BoldItalic.ttf";
local ITA        = "Italic.ttf";
local LITE_ITA   = "LightItalic.ttf";
local LITE       = "Light.ttf";
local MED        = "Medium.ttf";
local MED_ITA    = "MediumItalic.tff";
local REG        = "Regular.ttf";
local SEMIBD     = "SemiBold.tff";
local SEMIBD_ITA = "SemiBoldItalic.tff";
local TH         = "Thin.ttf";
local TH_ITA     = "ThinItalic.ttf";
local XB         = "ExtraBold.ttf";
local XB_ITA     = "ExtraBoldItalic.ttf";
local XL         = "ExtraLight.ttf";
local XL_ITA     = "ExtraLightItalic.ttf";

local fontList=
{ -- Code       = { Load = false, Name = "Human Readable     ",                      Fam  = "FAM", File = REG                     },
  Amara_Reg     = { Load = false, Name = "Amarante",                                 Fam = "Amara", File = REG                     },
  Arima_Black   = { Load = false, Name = "Arima Madurai Black",                      Fam = "Arima", File = BLK                     },
  Arima_Light   = { Load = false, Name = "Arima Madurai Light",                      Fam = "Arima", File = LITE                    },
  Arima_Medium  = { Load = false, Name = "Arima Madurai Medium",                     Fam = "Arima", File = MED                     },
  Arima_Reg     = { Load = false, Name = "Arima Madurai",                            Fam = "Arima", File = REG                     },
  Barlow_Bold   = { Load = false, Name = "Barlow Condensed Bold",                    Fam = "Barlow", File = BOLD                    },
  Barlow_Light  = { Load = false, Name = "Barlow Condensed Light",                   Fam = "Barlow", File = LITE                    },
  Barlow_Reg    = { Load = false, Name = "Barlow Condensed",                         Fam = "Barlow", File = REG                     },
  BigSho_Black  = { Load = false, Name = "Big Shoulders Stencil Display Black",      Fam = "BigSho", File = BLK                     },
  BigSho_Reg    = { Load = false, Name = "Big Shoulders Stencil Display",            Fam = "BigSho", File = REG                     },
  Bree_Reg      = { Load = false, Name = "Bree Serif",                               Fam = "Bree", File = REG                     },
  Cedar_Reg     = { Load = false, Name = "Cedarville Cursive",                       Fam = "Cedar", File = REG                     },
  Flame_Light   = { Load = false, Name = "Flamenco Light",                           Fam = "Flame", File = LITE                    },
  Flame_Reg     = { Load = false, Name = "Flamenco",                                 Fam = "Flame", File = REG                     },
  FontDS_Reg    = { Load = false, Name = "Fontdiner Swanky",                         Fam = "FontDS", File = REG                     },
  IMFell_EngReg = { Load = false, Name = "IM Fell English",                          Fam = "IMFell", File = "English-"       .. REG },
  IMFell_GPIta  = { Load = false, Name = "IM Fell Great Primer Italic",              Fam = "IMFell", File = "GreatPrimer-"   .. ITA },
  IMFell_GPReg  = { Load = false, Name = "IM Fell Great Primer",                     Fam = "IMFell", File = "GreatPrimer-"   .. REG },
  IMFell_GPSC   = { Load = false, Name = "IM Fell Great Primer SC",                  Fam = "IMFell", File = "GreatPrimerSC-" .. REG },
  MrsStD_Reg    = { Load = false, Name = "Mrs Saint Delafield",                      Fam = "MrsStD", File = REG                     },
  MtXmas_Bold   = { Load = false, Name = "Mountains of Christmas Bold",              Fam = "MtXmas", File = BOLD                    },
  MtXmas_Reg    = { Load = false, Name = "Mountains of Christmas",                   Fam = "MtXmas", File = REG                     },
  Oswald_Bold   = { Load = false, Name = "Oswald Bold",                              Fam = "Oswald", File = BOLD                    },
  Oswald_Reg    = { Load = false, Name = "Oswald",                                   Fam = "Oswald", File = REG                     },
  Oswald_SemiBd = { Load = false, Name = "Oswald Semi-Bold",                         Fam = "Oswald", File = SEMIBD                 },

  Poppi_BlkIta  = { Load = false, Name = "Poppins Black Italic",                     Fam = "Poppi", File = BLK_ITA                 },
  Poppi_Bold    = { Load = false, Name = "Poppins Bold",                             Fam = "Poppi", File = BOLD                    },
  Poppi_Italic  = { Load = false, Name = "Poppins Italic",                           Fam = "Poppi", File = ITA                     },
  Poppi_Reg     = { Load = false, Name = "Poppins",                                  Fam = "Poppi", File = REG                     },

  Press_Reg     = { Load = false, Name = "Press Start 2P",                           Fam = "Press", File = REG                     },
  Prince_Reg    = { Load = false, Name = "Princess Sofia",                           Fam = "Prince", File = REG                     },
  Share_Reg     = { Load = true, Name = "Share Tech Mono",                          Fam = "Share", File = REG                     },

  Source_Bol    = { Load = false, Name = "Source Code Pro Bold",                     Fam = "Source", File = BOLD                    },
  Source_BolIta = { Load = false, Name = "Source Code Pro Bold Italic",              Fam = "Source", File = BOLD_ITA                },
  Source_Ita    = { Load = false, Name = "Source Code Pro Italic",                   Fam = "Source", File = ITA                     },
  Source_Lig    = { Load = false, Name = "Source Code Pro Light",                    Fam = "Source", File = LITE                    },
  Source_Reg    = { Load = true, Name = "Source Code Pro",                          Fam = "Source", File = REG                     },
  Syne_Reg      = { Load = false, Name = "Syne Mono",                                Fam = "Syne", File = REG                     },
  Uncial_Reg    = { Load = false, Name = "Uncial Antiqua",                           Fam = "Uncial", File = REG                     },
 };

for fontCode, fontData in pairs(fontList)
do  LibSharedMedia:Register( "font", fontData.Name, family[fontData.Fam] .. fontData.File); 
    ns.RP_Fonts.tmp[fontData.Name] = { active = fontData.Load };
end;

