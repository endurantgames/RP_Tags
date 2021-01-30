-- ------------------------------------------------------------------------------
-- RP Tags 
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. To view a copy of the license, visit
--
--     https://creativecommons.org/licenses/by/4.0/

local addOnName, addOn = ...
local RPTAGS     = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("UTILS_PARSE",
function(self, event, ...)
  local function parseMrpGlanceString(data) -- yoinked from mrp's code.
    local glances = {};
    for icon, title, text in string.gmatch(data, "|T[^\n]+\\([^|:]+).-[\n]*#([^\n]+)[\n]*(.-)[\n]*%-%-%-[\n]*") 
    do table.insert(glances, { icon = icon, title = title, text = text});
    end
    return glances;
  end;
  
  RPTAGS.utils.parse.mrpGlance = parseMrpGlanceString;
end);
