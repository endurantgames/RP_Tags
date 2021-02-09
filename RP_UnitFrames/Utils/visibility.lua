-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 

local addOnName, addOn = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

-- local oUF    = RPTAGS.oUF;

Module:WaitUntil("UTILS_FRAMES",
function(self, event, ...)

  local Config = RPTAGS.utils.config;
  local Frames = RPTAGS.cache.UnitFrames;

  local function generateVisibilityString(unit)
    local conditions = {};

    if Config.get("DISABLE_RPUF"       ) then return "hide"                                   end;
    if Config.get("RPUF_HIDE_DEAD"     ) then table.insert(conditions, "[dead] hide"       ); end;
    if Config.get("RPUF_HIDE_PETBATTLE") then table.insert(conditions, "[petbattle] hide"  ); end;
    if Config.get("RPUF_HIDE_VEHICLE"  ) then table.insert(conditions, "[vehicleui] hide"  ); end;
    if Config.get("RPUF_HIDE_PARTY"    ) then table.insert(conditions, "[group:party] hide"); end;
    if Config.get("RPUF_HIDE_RAID"     ) then table.insert(conditions, "[group:raid] hide" ); end;
    if Config.get("RPUF_HIDE_COMBAT"   ) then table.insert(conditions, "[combat] hide"     ); end;

    table.insert(conditions, "[@" .. unit .. ",exists] show");
    table.insert(conditions, "hide");

    if unit == 'mouseover' then return "show" else return table.concat(conditions, ";"); end;
  end;

  local function setAllVisibility(init)
    for frameName, frame in pairs(Frames)
    do UnregisterStateDriver(frame, 'visibility');
         RegisterStateDriver(frame, 'visibility', 
           generateVisibilityString(frame.unit));
    end; -- for
  end;

  RPTAGS.utils.frames.all.visibility.set  = setAllVisibility;
  RPTAGS.utils.frames.visibility.generate = generateVisibilityString;
  RPTAGS.utils.frames.visibility.set      = setVisibility;

end);
