local RPTAGS = RPTAGS;
local addOnName, ns = ...;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("after MODULE_E",
function(self, event, ...)

  local function openEditor(setting) RPTAGS.cache.Editor:Edit(setting); end;

  RPTAGS.utils.config.openEditor = openEditor;
    
end);
