-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) 

local addOnName, addOn = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("after MODULE_J",
function(self, event, ...)

  local oUF                = _G[GetAddOnMetadata(addOnName, "X-oUF")]; -- auto-added by oUF
  local CONST              = RPTAGS.CONST;
  local FRAME_NAMES        = CONST.FRAMES.NAMES;


  function oUF:DisableBlizzard() end;

  oUF:Factory(
    function(self)
      RPTAGS.cache.UnitFrames = RPTAGS.cache.UnitFrames or {};
      self:SetActiveStyle('RP_UnitFrame')
      for unit, frameName in pairs(CONST.FRAMES.NAMES)
      do  local u = unit:lower();
          self:Spawn(u, frameName);
          RPTAGS.cache.UnitFrames[u] = _G[frameName];
          RPTAGS.cache.UnitFrames[u]:Enable();
      end;
    end);
  end
);

