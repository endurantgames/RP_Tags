local RPTAGS = RPTAGS;
local addOnName, ns = ...;

RPTAGS.queue:WaitUntil("MODULE_C",
function(self, event, ...)
  local LSM=LibStub("LibSharedMedia-3.0");
  local baseFontDir = "Interface\\AddOns\\"
                      .. (GetAddOnMetadata(addOnName, "X-FontDir") 
                      or (addOnName ..  "\\Media\\Fonts") .. "\\");


  local family = { 
    SCP = baseFontDir .. "Source_Code_Pro\\SourceCodePro-",
  };

  local fontList=
  { -- FONBolIta = { Load = 1,     Name = "Human Readable Name",                  
    --               Fam  = "FAM", File = "Regular.ttf" },
    SCPBla       = { Load = 0,     Name = "Source Code Pro (Black)",              
                     Fam  = "SCP", File = "Black.ttf" }, 
    SCPBlaIta    = { Load = 0,     Name = "Source Code Pro (Italic)",             
                     Fam  = "SCP", File = "BlackItalic.ttf" }, 
    SCPBol       = { Load = 0,     Name = "Source Code Pro (Bold)",               
                     Fam  = "SCP", File = "Bold.ttf" }, 
    SCPBolIta    = { Load = 0,     Name = "Source Code Pro (Bold Italic)",        
                     Fam  = "SCP", File = "BoldItalic.ttf" }, 
    SCPExtLig    = { Load = 0,     Name = "Source Code Pro (Extra Light)",        
                     Fam  = "SCP", File = "ExtraLight.ttf" }, 
    SCPExtLigIta = { Load = 0,     Name = "Source Code Pro (Extra Light Italic)", 
                     Fam  = "SCP", File = "ExtraLightItalic.ttf" }, 
    SCPIta       = { Load = 0,     Name = "Source Code Pro (Italic)",             
                     Fam  = "SCP", File = "Italic.ttf" }, 
    SCPLig       = { Load = 0,     Name = "Source Code Pro (Light)",              
                     Fam  = "SCP", File = "Light.ttf" }, 
    SCPLigIta    = { Load = 0,     Name = "Source Code Pro (Light Italic)",       
                     Fam  = "SCP", File = "LightItalic.ttf" }, 
    SCPMed       = { Load = 0,     Name = "Source Code Pro (Medium)",             
                     Fam  = "SCP", File = "Medium.ttf" }, 
    SCPMedIta    = { Load = 0,     Name = "Source Code Pro (Medium Italic)",      
                     Fam  = "SCP", File = "MediumItalic.ttf" }, 
    SCPReg       = { Load = 1,     Name = "Source Code Pro",                      
                     Fam  = "SCP", File = "Regular.ttf" }, 
    SCPSemBol    = { Load = 0,     Name = "Source Code Pro (Semi-Bold)",          
                     Fam  = "SCP", File = "SemiBold.ttf" }, 
    SCPSemBolIta = { Load = 0,     Name = "Source Code Pro (Semi-Bold Italic)",   
                     Fam  = "SCP", File = "SemiBoldItalic.ttf" }, 

 };

  for fontCode, font in pairs(fontList)
  do  if   font.Load == 1 
      then LSM:Register(LSM.MediaType.FONT, font.Name, family[font.Fam] .. font.File); 
      end;
  end;

end);