-- RP Tags 
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license.

local addOnName, ns = ...
local RPTAGS        = RPTAGS;
local Module        = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("UTILS_PARSE",
function(self, event, ...)
  local pattern = "|T[^\n]+\\([^|:]+).-[\n]*#([^\n]+)[\n]*(.-)[\n]*%-%-%-[\n]*";
  local function parseMrpGlanceString(data) -- yoinked from mrp's code.
    local glances = {};
    for icon, title, text in string.gmatch(data, pattern)
    do table.insert(glances, { icon = icon, title = title, text = text});
    end
    return glances;
  end;
  
  RPTAGS.utils.parse.mrpGlance = parseMrpGlanceString;
end);
