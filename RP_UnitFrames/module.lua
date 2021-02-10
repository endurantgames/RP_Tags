-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 

local addOnName, addOn = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:NewModule(addOnName, "rpClient");

_G["RP_UnitFramesDB"] = RP_UnitFramesDB or {};

RPTAGS.oUF = addOn.oUF;   -- give RPTAGS access to our oUF
