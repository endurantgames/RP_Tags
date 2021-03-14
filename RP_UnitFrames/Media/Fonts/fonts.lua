local RPTAGS = RPTAGS;
local addOnName, ns = ...;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("MODULE_C",
function(self, event, ...)
  local LSM=LibStub("LibSharedMedia-3.0");
  local baseFontDir = "Interface\\AddOns\\" .. addOnName .. 
                      (GetAddOnMetadata(addOnName, "X-FontDir") or "\\Media\\Fonts\\");

  local family = { SCP = baseFontDir .. "Source_Code_Pro\\SourceCodePro-", };

  local fontList=
  { SCPReg = { Load = 1, Name = "Source Code Pro", Fam  = "SCP", File = "Regular.ttf" }, };

  for fontCode, font in pairs(fontList)
  do  if font.Load == 1 then LSM:Register(LSM.MediaType.FONT, font.Name, family[font.Fam] .. font.File); end;
  end;

end);
