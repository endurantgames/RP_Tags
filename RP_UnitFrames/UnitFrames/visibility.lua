-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 

local addOnName, addOn = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("after MODULE_E",
function(self, event, ...)

  local Config = RPTAGS.utils.config;
  local Frames = RPTAGS.cache.UnitFrames or {};

  local function setAllVisibility(init)
    for frameName, frame in pairs(Frames)
    do  frame:SetVisibility();
    end; -- for
  end;

  RPTAGS.utils.frames.all.visibility.set  = setAllVisibility;

end);
