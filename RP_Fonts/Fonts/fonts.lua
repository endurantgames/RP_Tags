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
  Arima_Bold    = { Load = false, Name = "Arima Madurai Bold",                       Fam = "Arima", File = BOLD                    },
  Arima_Light   = { Load = false, Name = "Arima Madurai Light",                      Fam = "Arima", File = LITE                    },
  Arima_Medium  = { Load = false, Name = "Arima Madurai Medium",                     Fam = "Arima", File = MED                     },
  Arima_Reg     = { Load = false, Name = "Arima Madurai",                            Fam = "Arima", File = REG                     },
  Arima_Thin    = { Load = false, Name = "Arima Madurai Thin",                       Fam = "Arima", File = TH                      },
  Arima_XBold   = { Load = false, Name = "Arima Madurai Extra Bold",                 Fam = "Arima", File = XB                      },
  Arima_XLight  = { Load = false, Name = "Arima Madurai Extra Light",                Fam = "Arima", File = XL                      },
  Barlow_Black  = { Load = false, Name = "Barlow Condensed Black",                   Fam = "Barlow", File = BLK                     },
  Barlow_BldIta = { Load = false, Name = "Barlow Condensed Bold Italic",             Fam = "Barlow", File = BOLD_ITA                },
  Barlow_BlkIta = { Load = false, Name = "Barlow Condensed Black Italic",            Fam = "Barlow", File = BLK_ITA                 },
  Barlow_Bold   = { Load = false, Name = "Barlow Condensed Bold",                    Fam = "Barlow", File = BOLD                    },
  Barlow_Italic = { Load = false, Name = "Barlow Condensed Italic",                  Fam = "Barlow", File = ITA                     },
  Barlow_Light  = { Load = false, Name = "Barlow Condensed Light",                   Fam = "Barlow", File = LITE                    },
  Barlow_LtIta  = { Load = false, Name = "Barlow Condensed Light Italic",            Fam = "Barlow", File = LITE_ITA                },
  Barlow_Medium = { Load = false, Name = "Barlow Condensed Medium",                  Fam = "Barlow", File = MED                     },
  Barlow_Reg    = { Load = false, Name = "Barlow Condensed",                         Fam = "Barlow", File = REG                     },
  Barlow_SemiB  = { Load = false, Name = "Barlow Condensed Semi-Bold",               Fam = "Barlow", File = SEMIBD                 },
  Barlow_SmBIta = { Load = false, Name = "Barlow Condensed Semi-Bold Italic",        Fam = "Barlow", File = SEMIBD_ITA              },
  Barlow_Thin   = { Load = false, Name = "Barlow Condensed Thin",                    Fam = "Barlow", File = TH                      },
  Barlow_ThnIta = { Load = false, Name = "Barlow Condensed Thin Italic",             Fam = "Barlow", File = TH_ITA                 },
  Barlow_XBldIt = { Load = false, Name = "Barlow Condensed Extra Bold Italic",       Fam = "Barlow", File = XB_ITA                  },
  Barlow_XBold  = { Load = false, Name = "Barlow Condensed Extra Bold",              Fam = "Barlow", File = XB                      },
  Barlow_XLight = { Load = false, Name = "Barlow Condensed Extra Light",             Fam = "Barlow", File = XL                      },
  Barlow_XLtIta = { Load = false, Name = "Barlow Condensed Extra Light Italic",      Fam = "Barlow", File = XL_ITA                  },
  Bebas_Reg     = { Load = false, Name = "Bebas Neue",                               Fam = "Bebas", File = REG                     },
  BigSho_Black  = { Load = false, Name = "Big Shoulders Stencil Display Black",      Fam = "BigSho", File = BLK                     },
  BigSho_Bold   = { Load = false, Name = "Big Shoulders Stencil Display Bold",       Fam = "BigSho", File = BOLD                    },
  BigSho_Light  = { Load = false, Name = "Big Shoulders Stencil Display Light",      Fam = "BigSho", File = LITE                    },
  BigSho_Medium = { Load = false, Name = "Big Shoulders Stencil Display Medium",     Fam = "BigSho", File = MED                     },
  BigSho_Reg    = { Load = false, Name = "Big Shoulders Stencil Display",            Fam = "BigSho", File = REG                     },
  BigSho_SemiBl = { Load = false, Name = "Big Shoulders Stencil Display Semi-Bold",  Fam = "BigSho", File = SEMIBD                 },
  BigSho_Thin   = { Load = false, Name = "Big Shoulders Stencil Display Thin",       Fam = "BigSho", File = TH                      },
  BigSho_XBold  = { Load = false, Name = "Big Shoulders Stencil Display Extra Bold", Fam = "BigSho", File = XB                      },
  Bitter_Black  = { Load = false, Name = "Bitter Italic",                            Fam = "Bitter", File = ITA                     },
  Bitter_BldIta = { Load = false, Name = "Bitter Bold Italic",                       Fam = "Bitter", File = BOLD_ITA                },
  Bitter_BlkIta = { Load = false, Name = "Bitter Black Italic",                      Fam = "Bitter", File = BLK_ITA                 },
  Bitter_Bold   = { Load = false, Name = "Bitter Bold",                              Fam = "Bitter", File = BOLD                    },
  Bitter_Italic = { Load = false, Name = "Bitter Italic",                            Fam = "Bitter", File = ITA                     },
  Bitter_Light  = { Load = false, Name = "Bitter Light",                             Fam = "Bitter", File = LITE                    },
  Bitter_LitIta = { Load = false, Name = "Bitter Light Italic",                      Fam = "Bitter", File = LITE_ITA                },
  Bitter_Medium = { Load = false, Name = "Bitter Medium",                            Fam = "Bitter", File = MED                     },
  Bitter_Reg    = { Load = false, Name = "Bitter",                                   Fam = "Bitter", File = REG                     },
  Bitter_SemiBd = { Load = false, Name = "Bitter Semi-Bold",                         Fam = "Bitter", File = SEMIBD                 },
  Bitter_SmBdIt = { Load = false, Name = "Bitter Semi-Bold Italic",                  Fam = "Bitter", File = SEMIBD_ITA              },
  Bitter_Thin   = { Load = false, Name = "Bitter Thin",                              Fam = "Bitter", File = TH                      },
  Bitter_ThnIta = { Load = false, Name = "Bitter Thin Italic",                       Fam = "Bitter", File = TH_ITA                 },
  Bitter_XBdIta = { Load = false, Name = "Bitter Extra Bold Italic",                 Fam = "Bitter", File = XB_ITA                  },
  Bitter_XBold  = { Load = false, Name = "Bitter Extra Bold",                        Fam = "Bitter", File = XB                      },
  Bitter_XLight = { Load = false, Name = "Bitter Extra Light",                       Fam = "Bitter", File = XL                      },
  Bitter_XLitIt = { Load = false, Name = "Bitter Extra Light Italic",                Fam = "Bitter", File = XL_ITA                  },
  Bree_Reg      = { Load = false, Name = "Bree Serif",                               Fam = "Bree", File = REG                     },
  Cedar_Reg     = { Load = false, Name = "Cedarville Cursive",                       Fam = "Cedar", File = REG                     },
  DotG16_Reg    = { Load = false, Name = "DotGothic16",                              Fam = "DotG16", File = REG                     },
  East_Reg      = { Load = false, Name = "East Sea Dokdo",                           Fam = "East", File = REG                     },
  Flame_Light   = { Load = false, Name = "Flamenco Light",                           Fam = "Flame", File = LITE                    },
  Flame_Reg     = { Load = false, Name = "Flamenco",                                 Fam = "Flame", File = REG                     },
  Fonda_Italic  = { Load = false, Name = "Fondamento Italic",                        Fam = "Fonda", File = ITA                     },
  Fonda_Reg     = { Load = false, Name = "Fondamento",                               Fam = "Fonda", File = REG                     },
  FontDS_Reg    = { Load = false, Name = "Fontdiner Swanky",                         Fam = "FontDS", File = REG                     },
  IMFell_DP     = { Load = false, Name = "IM Fell Double Pica",                      Fam = "IMFell", File = "DoublePica-"    .. REG },
  IMFell_DPIta  = { Load = false, Name = "IM Fell Double Pica Italic",               Fam = "IMFell", File = "DoublePica-"    .. ITA },
  IMFell_DPSC   = { Load = false, Name = "IM Fell Double Pica SC",                   Fam = "IMFell", File = "DoublePicaSC-"  .. REG },
  IMFell_DWPIta = { Load = false, Name = "IM Fell DW Pica Italic",                   Fam = "IMFell", File = "DWPica-"        .. ITA },
  IMFell_DWPReg = { Load = false, Name = "IM Fell DW Pica",                          Fam = "IMFell", File = "DWPica-"        .. REG },
  IMFell_DWPSCR = { Load = false, Name = "IM Fell DW Pica SC",                       Fam = "IMFell", File = "DWPicaSC-"      .. REG },
  IMFell_EngIta = { Load = false, Name = "IM Fell English Italic",                   Fam = "IMFell", File = "English-"       .. ITA },
  IMFell_EngRSC = { Load = false, Name = "IM Fell English SC",                       Fam = "IMFell", File = "EnglishSC-"     .. REG },
  IMFell_EngReg = { Load = false, Name = "IM Fell English",                          Fam = "IMFell", File = "English-"       .. REG },
  IMFell_FCSC   = { Load = false, Name = "IM Fell French Canon SC",                  Fam = "IMFell", File = "FrenchCanonSC-" .. REG },
  IMFell_GPIta  = { Load = false, Name = "IM Fell Great Primer Italic",              Fam = "IMFell", File = "GreatPrimer-"   .. ITA },
  IMFell_GPReg  = { Load = false, Name = "IM Fell Great Primer",                     Fam = "IMFell", File = "GreatPrimer-"   .. REG },
  IMFell_GPSC   = { Load = false, Name = "IM Fell Great Primer SC",                  Fam = "IMFell", File = "GreatPrimerSC-" .. REG },
  Krona_Reg     = { Load = false, Name = "Krona One",                                Fam = "Krona", File = REG                     },
  Merri_BldIta  = { Load = false, Name = "Merriweather Sans Bold Italic",            Fam = "Merri", File = BOLD_ITA                },
  Merri_Bold    = { Load = false, Name = "Merriweather Sans Bold",                   Fam = "Merri", File = BOLD                    },
  Merri_Italic  = { Load = false, Name = "Merriweather Sans Italic",                 Fam = "Merri", File = ITA                     },
  Merri_Light   = { Load = false, Name = "Merriweather Sans Light",                  Fam = "Merri", File = LITE                    },
  Merri_MedIta  = { Load = false, Name = "Merriweather Sans Medium Italic",          Fam = "Merri", File = MED_ITA                 },
  Merri_Medium  = { Load = false, Name = "Merriweather Sans Medium",                 Fam = "Merri", File = MED                     },
  Merri_Reg     = { Load = false, Name = "Merriweather Sans",                        Fam = "Merri", File = REG                     },
  Merri_SemiBd  = { Load = false, Name = "Merriweather Sans Semi-Bold",              Fam = "Merri", File = SEMIBD                 },
  Merri_SmBdIt  = { Load = false, Name = "Merriweather Sans Semi-Bold Italic",       Fam = "Merri", File = SEMIBD_ITA              },
  Merri_XBldIta = { Load = false, Name = "Merriweather Sans Extra Bold Italic",      Fam = "Merri", File = XB_ITA                  },
  Merri_XBold   = { Load = false, Name = "Merriweather Sans Extra Bold",             Fam = "Merri", File = XB                      },
  MrsStD_Reg    = { Load = false, Name = "Mrs Saint Delafield",                      Fam = "MrsStD", File = REG                     },
  MtXmas_Bold   = { Load = false, Name = "Mountains of Christmas Bold",              Fam = "MtXmas", File = BOLD                    },
  MtXmas_Reg    = { Load = false, Name = "Mountains of Christmas",                   Fam = "MtXmas", File = REG                     },
  Oswald_Bold   = { Load = false, Name = "Oswald Bold",                              Fam = "Oswald", File = BOLD                    },
  Oswald_Light  = { Load = false, Name = "Oswald Light",                             Fam = "Oswald", File = LITE                    },
  Oswald_Medium = { Load = false, Name = "Oswald Medium",                            Fam = "Oswald", File = MED                     },
  Oswald_Reg    = { Load = false, Name = "Oswald",                                   Fam = "Oswald", File = REG                     },
  Oswald_SemiBd = { Load = false, Name = "Oswald Semi-Bold",                         Fam = "Oswald", File = SEMIBD                 },
  Oswald_XLight = { Load = false, Name = "Oswald Extra Light",                       Fam = "Oswald", File = XL                      },
  Poppi_BdIta   = { Load = false, Name = "Poppins Bold Italic",                      Fam = "Poppi", File = BOLD_ITA                },
  Poppi_Black   = { Load = false, Name = "Poppins Black",                            Fam = "Poppi", File = BLK                     },
  Poppi_BlkIta  = { Load = false, Name = "Poppins Black Italic",                     Fam = "Poppi", File = BLK_ITA                 },
  Poppi_Bold    = { Load = false, Name = "Poppins Bold",                             Fam = "Poppi", File = BOLD                    },
  Poppi_Italic  = { Load = false, Name = "Poppins Italic",                           Fam = "Poppi", File = ITA                     },
  Poppi_Light   = { Load = false, Name = "Poppins Light",                            Fam = "Poppi", File = LITE                    },
  Poppi_LtIta   = { Load = false, Name = "Poppins Light Italic",                     Fam = "Poppi", File = LITE_ITA                },
  Poppi_MedIta  = { Load = false, Name = "Poppins Medium Italic",                    Fam = "Poppi", File = MED_ITA                 },
  Poppi_Medium  = { Load = false, Name = "Poppins Medium",                           Fam = "Poppi", File = MED                     },
  Poppi_Reg     = { Load = false, Name = "Poppins",                                  Fam = "Poppi", File = REG                     },
  Poppi_SemiBd  = { Load = false, Name = "Poppins Semi-Bold",                        Fam = "Poppi", File = SEMIBD                 },
  Poppi_SmBdIt  = { Load = false, Name = "Poppins Semi-Bold Italic",                 Fam = "Poppi", File = SEMIBD_ITA              },
  Poppi_Thin    = { Load = false, Name = "Poppins Thin",                             Fam = "Poppi", File = TH                      },
  Poppi_ThnIta  = { Load = false, Name = "Poppins Thin Italic",                      Fam = "Poppi", File = TH_ITA                  },
  Poppi_XBdIta  = { Load = false, Name = "Poppins Extra Bold Italic",                Fam = "Poppi", File = XB_ITA                  },
  Poppi_XBold   = { Load = false, Name = "Poppins Extra Bold",                       Fam = "Poppi", File = XB                      },
  Poppi_XLight  = { Load = false, Name = "Poppins Extra Light",                      Fam = "Poppi", File = XL                      },
  Poppi_XLtIta  = { Load = false, Name = "Poppins Extra Light Italic",               Fam = "Poppi", File = XL_ITA                  },
  Press_Reg     = { Load = false, Name = "Press Start 2P",                           Fam = "Press", File = REG                     },
  Prince_Reg    = { Load = false, Name = "Princess Sofia",                           Fam = "Prince", File = REG                     },
  Reggae_Reg    = { Load = false, Name = "Reggae One",                               Fam = "Reggae", File = REG                     },
  Share_Reg     = { Load = true, Name = "Share Tech Mono",                          Fam = "Share", File = REG                     },
  Source_Bla    = { Load = false, Name = "Source Code Pro Black",                    Fam = "Source", File = BLK                     },
  Source_BlaIta = { Load = false, Name = "Source Code Pro Black Italic",             Fam = "Source", File = BLK_ITA                 },
  Source_Bol    = { Load = false, Name = "Source Code Pro Bold",                     Fam = "Source", File = BOLD                    },
  Source_BolIta = { Load = false, Name = "Source Code Pro Bold Italic",              Fam = "Source", File = BOLD_ITA                },
  Source_ExLiIt = { Load = false, Name = "Source Code Pro Extra Light Italic",       Fam = "Source", File = XL_ITA                  },
  Source_ExtLig = { Load = false, Name = "Source Code Pro Extra Light",              Fam = "Source", File = XL                      },
  Source_Ita    = { Load = false, Name = "Source Code Pro Italic",                   Fam = "Source", File = ITA                     },
  Source_Lig    = { Load = false, Name = "Source Code Pro Light",                    Fam = "Source", File = LITE                    },
  Source_LigIta = { Load = false, Name = "Source Code Pro Light Italic",             Fam = "Source", File = LITE_ITA                },
  Source_Med    = { Load = false, Name = "Source Code Pro Medium",                   Fam = "Source", File = MED                     },
  Source_MedIta = { Load = false, Name = "Source Code Pro Medium Italic",            Fam = "Source", File = MED_ITA                 },
  Source_Reg    = { Load = true, Name = "Source Code Pro",                          Fam = "Source", File = REG                     },
  Source_SemBol = { Load = false, Name = "Source Code Pro Semi-Bold",                Fam = "Source", File = SEMIBD                  },
  Source_SmBlIt = { Load = false, Name = "Source Code Pro Semi-Bold Italic",         Fam = "Source", File = SEMIBD_ITA              },
  Syne_Reg      = { Load = false, Name = "Syne Mono",                                Fam = "Syne", File = REG                     },
  Uncial_Reg    = { Load = false, Name = "Uncial Antiqua",                           Fam = "Uncial", File = REG                     },
 };

for fontCode, fontData in pairs(fontList)
do  LibSharedMedia:Register( "font", fontData.Name, family[fontData.Fam] .. fontData.File); 
    ns.RP_Fonts.tmp[fontData.Name] = { active = fontData.Load };
end;

