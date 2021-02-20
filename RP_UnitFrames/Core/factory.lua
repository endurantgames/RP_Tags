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

  local RP_TagsDB          = RP_TagsDB;
  local oUF                = _G[GetAddOnMetadata(addOnName, "X-oUF")]; -- auto-added by oUF
  local CONST              = RPTAGS.CONST;
  local FRAME_NAMES        = CONST.FRAMES.NAMES;

  oUF:Factory(
    function(self)
      self:SetActiveStyle('RP_Tags')
      self:Spawn("player", FRAME_NAMES.PLAYER);
      self:Spawn("focus",  FRAME_NAMES.FOCUS);
      self:Spawn("target", FRAME_NAMES.TARGET);
      self:Spawn("targettarget", FRAME_NAMES.TARGETTARGET)
    end);
  end
);

