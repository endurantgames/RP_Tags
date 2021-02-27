local addOnName, ns = ...;

local LibSharedMedia=LibStub("LibSharedMedia-3.0");
local baseFontDir = "Interface\\AddOns\\" .. addOnName .. "\\Fonts\\";

ns.RP_Fonts = ns.RP_Fonts or {};
ns.RP_Fonts.tmp = ns.RP_Fonts.tmp or {};

local REG = "Regular.ttf";
local Reg = " Regular";
local ITA = "Italic.ttf";
local Ita = " Italic";

local family = { 
  SCP = baseFontDir .. "Source_Code_Pro\\SourceCodePro-",
  STM = baseFontDir .. "ShareTechMono\\ShareTechMono-",
  SYN = baseFontDir .. "Syne_Mono\\SyneMono-",
  MSD = baseFontDir .. "Mrs_Saint_Delafield\\MrsSaintDelafield-",
  AMA = baseFontDir .. "Amarante\\Amarante-",
  ARI = baseFontDir .. "Arima_Madurai\\ArimaMadurai-",
  BRC = baseFontDir .. "Barlow_Condensed\\BarlowCondensed-",
  BBN = baseFontDir .. "Bebas_Neue\\BebasNeue-",
  BSS = baseFontDir .. "Big_Shoulders_Stencil_Display\\BigShouldersStencilDisplay-",
  BTR = baseFontDir .. "Bitter\\Bitter-",
  BRE = baseFontDir .. "Bree_Serif\\BreeSerif-",
  CVC = baseFontDir .. "Cedarville_Cursive\\CedarvilleCursive-",
  DOT = baseFontDir .. "DotGothic16\\DotGothic16-",
  ESD = baseFontDir .. "East_Sea_Dokdo\\EastSeaDokdo-",
  FLM = baseFontDir .. "Flamenco\\Flamenco-",
  FND = baseFontDir .. "Fondamento\\Fontamento-",
  FDS = baseFontDir .. "Fontdiner_Swanky\\FontdinerSwanky-",
  IMF = baseFontDir .. "IM_Fell\\IMFell", 
  KRN = baseFontDir .. "Krona_One\\KronaOne-",
  MWS = baseFontDir .. "Merriweather_Sans\\MerriweatherSans-",
  MOC = baseFontDir .. "Mountains_of_Christmas\\MountainsofChristmas-",
  OSW = baseFontDir .. "Oswald\\Oswald-",
  PPN = baseFontDir .. "Poppins\\Poppins-",
  PS2 = baseFontDir .. "Press_Start_2P\\PressStart2P-",
  PCS = baseFontDir .. "Princess_Sofia\\PrincessSofia-",
  RG1 = baseFontDir .. "Reggae_One\\ReggaeOne-",
  UNA = baseFontDir .. "Uncial_Antiqua\\UncialAntiqua-",

};


local fontList=
{ -- Code   = { Load = true,  Name = "Human Readable Name",                Fam  = "FAM", File = "Regular.ttf"          },
  AMAReg    = { Load = true,  Name = "Amarante",                           Fam  = "AMA", File = REG                    },
  ARIReg    = { Load = true,  Name = "Arima Madurai",                      Fam  = "ARI", File = REG                    },
  BBNReg    = { Load = true,  Name = "Bebas Neue",                         Fam  = "BBN", File = REG                    },
  BRCReg    = { Load = true,  Name = "Barlow Condensed",                   Fam  = "BRC", File = REG                    },
  BREReg    = { Load = true,  Name = "Bree Serif",                         Fam  = "BRE", File = REG                    },
  BSSReg    = { Load = true,  Name = "Big Shoulders Stencil Display",      Fam  = "BSS", File = REG                    },
  BTRReg    = { Load = true,  Name = "Bitter",                             Fam  = "BTR", File = REG                    },
  CVCReg    = { Load = true,  Name = "Cedarville Cursive",                 Fam  = "CVC", File = REG                    },
  DOTReg    = { Load = true,  Name = "DotGothic16",                        Fam  = "DOT", File = REG                    },
  ESDReg    = { Load = true,  Name = "East Sea Dokdo",                     Fam  = "ESD", File = REG                    },
  FDSReg    = { Load = true,  Name = "Fontdiner Swanky",                   Fam  = "FDS", File = REG                    },
  FLMReg    = { Load = true,  Name = "Flamenco",                           Fam  = "FLM", File = REG                    },
  FNDReg    = { Load = true,  Name = "Fondamento",                         Fam  = "FND", File = REG                    },
  IMFReg    = { Load = true,  Name = "IM Fell",                            Fam  = "IMF", File = REG                    },
  KRNReg    = { Load = true,  Name = "Krona One",                          Fam  = "KRN", File = REG                    },
  MOCReg    = { Load = true,  Name = "Mountains of Christmas",             Fam  = "MOC", File = REG                    },
  MSDReg    = { Load = true,  Name = "Mrs Saint Delafield",                Fam  = "MSD", File = REG                    },
  MWSReg    = { Load = true,  Name = "Merriweather Sans",                  Fam  = "MWS", File = REG                    },
  OSWReg    = { Load = true,  Name = "Oswald",                             Fam  = "OSW", File = REG                    },
  PCSReg    = { Load = true,  Name = "Princess Sofia",                     Fam  = "PCS", File = REG                    },
  PPNReg    = { Load = true,  Name = "Poppins",                            Fam  = "PPN", File = REG                    },
  PS2Reg    = { Load = true,  Name = "Press Start 2P",                     Fam  = "PS2", File = REG                    },
  RG1Reg    = { Load = true,  Name = "Reggae One",                         Fam  = "RG1", File = REG                    },
  SCPBla    = { Load = false, Name = "Source Code Pro Black",              Fam  = "SCP", File = "Black.ttf"            },
  SCPBlaIta = { Load = false, Name = "Source Code Pro Black Italic",       Fam  = "SCP", File = "BlackItalic.ttf"      },
  SCPBol    = { Load = true,  Name = "Source Code Pro Bold",               Fam  = "SCP", File = "Bold.ttf"             },
  SCPBolIta = { Load = false, Name = "Source Code Pro Bold Italic",        Fam  = "SCP", File = "BoldItalic.ttf"       },
  SCPExLiIt = { Load = false, Name = "Source Code Pro Extra Light Italic", Fam  = "SCP", File = "ExtraLightItalic.ttf" },
  SCPExtLig = { Load = false, Name = "Source Code Pro Extra Light",        Fam  = "SCP", File = "ExtraLight.ttf"       },
  SCPIta    = { Load = true,  Name = "Source Code Pro Italic",             Fam  = "SCP", File = "Italic.ttf"           },
  SCPLig    = { Load = false, Name = "Source Code Pro Light",              Fam  = "SCP", File = "Light.ttf"            },
  SCPLigIta = { Load = false, Name = "Source Code Pro Light Italic",       Fam  = "SCP", File = "LightItalic.ttf"      },
  SCPMed    = { Load = false, Name = "Source Code Pro Medium",             Fam  = "SCP", File = "Medium.ttf"           },
  SCPMedIta = { Load = false, Name = "Source Code Pro Medium Italic",      Fam  = "SCP", File = "MediumItalic.ttf"     },
  SCPReg    = { Load = true,  Name = "Source Code Pro",                    Fam  = "SCP", File = REG                    },
  SCPSemBol = { Load = false, Name = "Source Code Pro Semi-Bold",          Fam  = "SCP", File = "SemiBold.ttf"         },
  SCPSmBlIt = { Load = false, Name = "Source Code Pro Semi-Bold Italic",   Fam  = "SCP", File = "SemiBoldItalic.ttf"   },
  STMReg    = { Load = true,  Name = "Share Tech Mono",                    Fam  = "STM", File = REG                    },
  SYNReg    = { Load = true,  Name = "Syne Mono",                          Fam  = "SYN", File = REG                    },
  UNAReg    = { Load = true,  Name = "Uncial Antiqua",                     Fam  = "UNA", File = REG                    },

 };

for fontCode, font in pairs(fontList)
do  LibSharedMedia:Register(LibSharedMedia.MediaType.FONT, font.Name, family[font.Fam] .. font.File); 
    ns.RP_Fonts.tmp[font.Name] = { active = font.Load };
end;

