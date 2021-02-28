local addOnName, ns = ...;

local LibSharedMedia=LibStub("LibSharedMedia-3.0");
local baseFontDir = "Interface\\AddOns\\" .. addOnName .. "\\Fonts\\";

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
  IMFell = baseFontDir .. "IM_Fell\\IMFellell",
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


local BLK      = "Black.ttf";
local BLK_ITA  = "BlackItalic.ttf";
local BOLD     = "Bold.ttf";
local BOLD_ITA = "BoldItalic.ttf";
local ITA      = "Italic.ttf";
local LITE_ITA = "LightItalic.ttf";
local LITE     = "Light.ttf";
local MED      = "Medium.ttf";
local MED_ITA  = "MediumItalic.tff";
local REG      = "Regular.ttf";
local SEMIBD   = "SemiBold.tff";
local SEMIBD_ITA = "SemiBoldItalic.tff";
local TH       = "Thin.ttf";
local TH_ITA   = "ThinItalic.ttf";
local XB       = "ExtraBold.ttf";
local XB_ITA   = "ExtraBoldItalic.ttf";
local XL       = "ExtraLight.ttf";
local XL_ITA   = "ExtraLightItalic.ttf";

local fontList=
{ -- Code       = { Load = false, Name = "Human Readable Name",                Fam  = "FAM",   File = "Regular.ttf"          },
  Amara_Reg     = { Load = false, Name = "Amarante",                           Fam = "Amara",  File = REG                    },
  Arima_Black   = { Load = false, Name = "Arima Madurai Black",                Fam = "ARI",    File = BLK                    },
  Arima_Bold    = { Load = false, Name = "Arima Madurai Bold",                 Fam = "ARI",    File = BOLD                   },
  Arima_XBold   = { Load = false, Name = "Arima Madurai Extra Bold",           Fam = "ARI",    File = XB                     },
  Arima_XLight  = { Load = false, Name = "Arima Madurai Extra Light",          Fam = "ARI",    File = XL                     },
  Arima_Light   = { Load = false, Name = "Arima Madurai Light",                Fam = "ARI",    File = LITE                   },
  Arima_Reg     = { Load = false, Name = "Arima Madurai",                      Fam = "ARI",    File = REG                    },
  Arima_Medium  = { Load = false, Name = "Arima Madurai Medium",               Fam = "ARI",    File = MED                    },
  Arima_Thin    = { Load = false, Name = "Arima Madurai Thin",                 Fam = "ARI",    File = TH                     },
  Bebas_Reg     = { Load = false, Name = "Bebas Neue",                         Fam = "Bebas",  File = REG                    },
  Barlow_Reg    = { Load = false, Name = "Barlow Condensed",                    Fam = "Barlow", File = REG                    },
  Barlow_Black  = { Load = false, Name = "Barlow Condensed Black",              Fam = "Barlow", File = BLK                    },
  Barlow_BlkIta = { Load = false, Name = "Barlow Condensed Black Italic",       Fam = "Barlow", File = BLK_ITA         },
  Barlow_Bold   = { Load = false, Name = "Barlow Condensed Bold",               Fam = "Barlow", File = BOLD                   },
  Barlow_BldIta = { Load = false, Name = "Barlow Condensed Bold Italic",        Fam = "Barlow", File = BOLD_ITA          },
  Barlow_XBold  = { Load = false, Name = "Barlow Condensed Extra Bold",         Fam = "Barlow", File = XB                     },
  Barlow_XBldIt = { Load = false, Name = "Barlow Condensed Extra Bold Italic",  Fam = "Barlow", File = XB_ITA     },
  Barlow_XLight = { Load = false, Name = "Barlow Condensed Extra Light",        Fam = "Barlow", File = XL                     },
  Barlow_XLtIta = { Load = false, Name = "Barlow Condensed Extra Light Italic", Fam = "Barlow", File = XL_ITA    },
  Barlow_Italic = { Load = false, Name = "Barlow Condensed Italic",             Fam = "Barlow", File = ITA                    },
  Barlow_Light  = { Load = false, Name = "Barlow Condensed Light",              Fam = "Barlow", File = LITE                   },
  Barlow_LtIta  = { Load = false, Name = "Barlow Condensed Light Italic",       Fam = "Barlow", File = LITE_ITA         },
  Barlow_Medium = { Load = false, Name = "Barlow Condensed Medium",             Fam = "Barlow", File = MED                    },
  Barlow_SemiB  = { Load = false, Name = "Barlow Condensed Semi-Bold",          Fam = "Barlow", File = SEMI_BD         },
  Barlow_SmBIta = { Load = false, Name = "Barlow Condensed Semi-Bold Italic",   Fam = "Barlow", File = SEMIBD_ITA      },
  Barlow_Thin   = { Load = false, Name = "Barlow Condensed Thin",               Fam = "Barlow", File = TH                     },
  Barlow_ThnIta = { Load = false, Name = "Barlow Condensed Thin Italic",        Fam = "Barlow", File = THI_ITA          },
  Cedar_Reg     = { Load = false, Name = "Cedarville Cursive",                 Fam = "Cedar",  File = REG                    },
  Bree_Reg      = { Load = false, Name = "Bree Serif",                         Fam = "Bree",   File = REG                    },
  DotG16_Reg    = { Load = false, Name = "DotGothic16",                        Fam = "DotG16", File = REG                    },
  East_Reg      = { Load = false, Name = "East Sea Dokdo",                     Fam = "East",   File = REG                    },
  FontDS_Reg    = { Load = false, Name = "Fontdiner Swanky",                   Fam = "FontDS", File = REG                    },
  Flame_Reg     = { Load = false, Name = "Flamenco",                           Fam = "Flame",  File = REG                    },
  Flame_Light   = { Load = false, Name = "Flamenco Light",                      Fam = "Flame",  File = LITE                   },
  Fonda_Italic  = { Load = false, Name = "Fondamento Italic",                   Fam = "Fonda",  File = ITA                    },
  Fonda_Reg     = { Load = false, Name = "Fondamento",                         Fam = "Fonda",  File = REG                    },
  Krona_Reg     = { Load = false, Name = "Krona One",                          Fam = "Krona",  File = REG                    },
  MtXmas_Reg    = { Load = false, Name = "Mountains of Christmas",             Fam = "MtXmas", File = REG                    },
  MtXmas_Bold   = { Load = false, Name = "Mountains of Christmas Bold",             Fam = "MtXmas", File = BOLD                   },
  MrsStD_Reg    = { Load = false, Name = "Mrs Saint Delafield",                Fam = "MrsStD", File = REG                    },
  Prince_Reg    = { Load = false, Name = "Princess Sofia",                     Fam = "Prince", File = REG                    },
  Press_Reg     = { Load = false, Name = "Press Start 2P",                     Fam = "Press",  File = REG                    },

  Reggae_Reg    = { Load = false, Name = "Reggae One",                         Fam = "Reggae", File = REG                    },
  Source_Bla    = { Load = false, Name = "Source Code Pro Black",              Fam = "Source", File = BLK                    },
  Source_BlaIta = { Load = false, Name = "Source Code Pro Black Italic",       Fam = "Source", File = BLK_ITA                },
  Source_Bol    = { Load = false, Name = "Source Code Pro Bold",               Fam = "Source", File = BOLD                   },
  Source_BolIta = { Load = false, Name = "Source Code Pro Bold Italic",        Fam = "Source", File = BOLD_ITA                 },
  Source_ExLiIt = { Load = false, Name = "Source Code Pro Extra Light Italic", Fam = "Source", File = XL_ITA                 },
  Source_ExtLig = { Load = false, Name = "Source Code Pro Extra Light",        Fam = "Source", File = XL                     },
  Source_Ita    = { Load = false, Name = "Source Code Pro Italic",             Fam = "Source", File = ITA                    },
  Source_Lig    = { Load = false, Name = "Source Code Pro Light",              Fam = "Source", File = LITE                   },
  Source_LigIta = { Load = false, Name = "Source Code Pro Light Italic",       Fam = "Source", File = LITE_ITA               },
  Source_Med    = { Load = false, Name = "Source Code Pro Medium",             Fam = "Source", File = MED                    },
  Source_MedIta = { Load = false, Name = "Source Code Pro Medium Italic",      Fam = "Source", File = MED_ITA                },
  Source_Reg    = { Load = false, Name = "Source Code Pro",                    Fam = "Source", File = REG                    },
  Source_SemBol = { Load = false, Name = "Source Code Pro Semi-Bold",          Fam = "Source", File = SEMIBD                 },
  Source_SmBlIt = { Load = false, Name = "Source Code Pro Semi-Bold Italic",   Fam = "Source", File = SEMIBD_ITA             },
  Share_Reg     = { Load = false, Name = "Share Tech Mono",                    Fam = "Share",  File = REG                    },
  Syne_Reg      = { Load = false, Name = "Syne Mono",                          Fam = "Syne",   File = REG                    },
  Uncial_Reg    = { Load = false, Name = "Uncial Antiqua",                     Fam = "Uncial", File = REG                    },

  BigSho_Reg    = { Load = false, Name = "Big Shoulders Stencil Display",            Fam = "BigSho", File = REG                    },
  BigSho_Black  = { Load = false, Name = "Big Shoulders Stencil Display Black",      Fam = "BigSho", File = BLK                    },
  BigSho_Bold   = { Load = false, Name = "Big Shoulders Stencil Display Bold",       Fam = "BigSho", File = BOLD                   },
  BigSho_XBold  = { Load = false, Name = "Big Shoulders Stencil Display Extra Bold", Fam = "BigSho", File = XB                     },
  BigSho_Light  = { Load = false, Name = "Big Shoulders Stencil Display Light",      Fam = "BigSho", File = LITE                   },
  BigSho_Medium = { Load = false, Name = "Big Shoulders Stencil Display Medium",     Fam = "BigSho", File = MED                    },
  BigSho_SemiBl = { Load = false, Name = "Big Shoulders Stencil Display Semi-Bold",  Fam = "BigSho", File = SEMI_BD         },
  BigSho_Thin   = { Load = false, Name = "Big Shoulders Stencil Display Thin",       Fam = "BigSho", File = TH                     },

  Bitter_Reg    = { Load = false, Name = "Bitter",                    Fam = "Bitter", File = REG                    },
  Bitter_Black  = { Load = false, Name = "Bitter Italic",             Fam = "Bitter", File = ITA                    },
  Bitter_BlkIta = { Load = false, Name = "Bitter Black Italic",       Fam = "Bitter", File = BLK_ITA         },
  Bitter_Bold   = { Load = false, Name = "Bitter Bold",               Fam = "Bitter", File = BOLD                   },
  Bitter_BldIta = { Load = false, Name = "Bitter Bold Italic",        Fam = "Bitter", File = BOLD_ITA          },
  Bitter_XBold  = { Load = false, Name = "Bitter Extra Bold",         Fam = "Bitter", File = XB                     },
  Bitter_XBdIta = { Load = false, Name = "Bitter Extra Bold Italic",  Fam = "Bitter", File = XB_ITA      },
  Bitter_XLight = { Load = false, Name = "Bitter Extra Light",        Fam = "Bitter", File = XL                     },
  Bitter_XLitIt = { Load = false, Name = "Bitter Extra Light Italic", Fam = "Bitter", File = XL_ITA    },
  Bitter_Italic = { Load = false, Name = "Bitter Italic",             Fam = "Bitter", File = ITA                    },

  Bitter_Light  = { Load = false, Name = "Bitter Light",              Fam = "Bitter", File = LITE                   },
  Bitter_LitIta = { Load = false, Name = "Bitter Light Italic",       Fam = "Bitter", File = LITE_ITA         },
  Bitter_Medium = { Load = false, Name = "Bitter Medium",             Fam = "Bitter", File = MED                    },
  Bitter_SemiBd = { Load = false, Name = "Bitter Semi-Bold",          Fam = "Bitter", File = SEMI_BD         },
  Bitter_SmBdIt = { Load = false, Name = "Bitter Semi-Bold Italic",   Fam = "Bitter", File = SEMIBD_ITA      },
  Bitter_Thin   = { Load = false, Name = "Bitter Thin",               Fam = "Bitter", File = TH                     },
  Bitter_ThnIta = { Load = false, Name = "Bitter Thin Italic",        Fam = "Bitter", File = THI_ITA          },

  Merri_Bold    = { Load = false, Name = "Merriweather Sans Bold",              Fam = "Merri",  File = BOLD                   },
  Merri_BldIta  = { Load = false, Name = "Merriweather Sans Bold Italic",       Fam = "Merri",  File = BOLD_ITA          },
  Merri_XBold   = { Load = false, Name = "Merriweather Sans Extra Bold",        Fam = "Merri",  File = XB                     },
  Merri_XBldIta = { Load = false, Name = "Merriweather Sans Extra Bold Italic", Fam = "Merri",  File = XB_ITA     },

  Merri_Italic  = { Load = false, Name = "Merriweather Sans Italic",            Fam = "Merri",  File = ITA                    },
  Merri_Light   = { Load = false, Name = "Merriweather Sans Light",             Fam = "Merri",  File = LITE                   },
  Merri_Medium  = { Load = false, Name = "Merriweather Sans Medium",            Fam = "Merri",  File = MED                    },
  Merri_MedIta  = { Load = false, Name = "Merriweather Sans Medium Italic",     Fam = "Merri",  File = MED_ITA        },
  Merri_Reg     = { Load = false, Name = "Merriweather Sans",                   Fam = "Merri",  File = REG                    },
  Merri_SemiBd  = { Load = false, Name = "Merriweather Sans Semi-Bold",         Fam = "Merri",  File = SEMI_BD         },
  Merri_SmBdIt  = { Load = false, Name = "Merriweather Sans Semi-Bold Italic",  Fam = "Merri",  File = SEMIBD_ITA      },

  Oswald_Bold   = { Load = false, Name = "Oswald Bold",        Fam = "Oswald", File = BOLD                   },
  Oswald_XLight = { Load = false, Name = "Oswald Extra Light", Fam = "Oswald", File = XL                     },
  Oswald_Light  = { Load = false, Name = "Oswald Light",       Fam = "Oswald", File = LITE                   },
  Oswald_Medium = { Load = false, Name = "Oswald Medium",      Fam = "Oswald", File = MED                    },
  Oswald_Reg    = { Load = false, Name = "Oswald",             Fam = "Oswald", File = REG                    },
  Oswald_SemiBd = { Load = false, Name = "Oswald Semi-Bold",   Fam = "Oswald", File = SEMI_BD         },

  Poppi_Black   = { Load = false, Name = "Poppins Black",              Fam = "Poppi",  File = BLK                    },
  Poppi_BlkIta  = { Load = false, Name = "Poppins Black Italic",       Fam = "Poppi",  File = BLK_ITA         },
  Poppi_Bold    = { Load = false, Name = "Poppins Bold",               Fam = "Poppi",  File = BOLD                   },
  Poppi_BdIta   = { Load = false, Name = "Poppins Bold Italic",        Fam = "Poppi",  File = BOLD_ITA          },
  Poppi_XBold   = { Load = false, Name = "Poppins Extra Bold",         Fam = "Poppi",  File = XB                     },
  Poppi_XBdIta  = { Load = false, Name = "Poppins Extra Bold Italic",  Fam = "Poppi",  File = XB_ITA     },
  Poppi_XLight  = { Load = false, Name = "Poppins Extra Light",        Fam = "Poppi",  File = XL                     },
  Poppi_XLtIta  = { Load = false, Name = "Poppins Extra Light Italic", Fam = "Poppi",  File = XL_ITA    },
  Poppi_Italic  = { Load = false, Name = "Poppins Italic",             Fam = "Poppi",  File = ITA                    },
  Poppi_Light   = { Load = false, Name = "Poppins Light",              Fam = "Poppi",  File = LITE                   },
  Poppi_LtIta   = { Load = false, Name = "Poppins Light Italic",       Fam = "Poppi",  File = LITE_ITA         },
  Poppi_Medium  = { Load = false, Name = "Poppins Medium",             Fam = "Poppi",  File = MED                    },
  Poppi_MedIta  = { Load = false, Name = "Poppins Medium Italic",      Fam = "Poppi",  File = MED_ITA        },
  Poppi_Reg     = { Load = false, Name = "Poppins",                    Fam = "Poppi",  File = REG                    },
  Poppi_SemiBd  = { Load = false, Name = "Poppins Semi-Bold",          Fam = "Poppi",  File = SEMI_BD         },
  Poppi_SmBdIt  = { Load = false, Name = "Poppins Semi-Bold Italic",   Fam = "Poppi",  File = SEMIBD_ITA      },
  Poppi_Thin    = { Load = false, Name = "Poppins Thin",               Fam = "Poppi",  File = TH                     },
  Poppi_ThnIta  = { Load = false, Name = "Poppins Thin Italic",        Fam = "Poppi",  File = THI_ITA          },

 };



for fontCode, font in pairs(fontList)
do  LibSharedMedia:Register(LibSharedMedia.MediaType.FONT, font.Name, family[font.Fam] .. font.File); 
    ns.RP_Fonts.tmp[font.Name] = { active = font.Load };
end;

