-- ------------------------------------------------------------------------------
-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. To view a copy of the license, visit
--
--     https://creativecommons.org/licenses/by/4.0/

local addOnNames, addOn = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnNames, "rpClient");

Module:WaitUntil("UTILS_FRAMES", 
function(self, ...) 
  -- RPTAGS.utils.rpuf.tags.registerall(...)  
  -- RPTAGS.utils.rpuf.frames.refresh(...)
  -- RPTAGS.utils.rpuf.frames.refreshAll(...)
end);
