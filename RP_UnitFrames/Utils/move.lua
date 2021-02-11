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

Module:WaitUntil("after MODULE_E",
function(self, event, ...)

  local CONST       = RPTAGS.CONST;
  local Utils       = RPTAGS.utils; 
  local notify      = Utils.text.notify;
  local Config      = Utils.config;
  local PANELS      = RPTAGS.CONST.FRAMES.PANELS;

  local function lockAllFrames(init) 
    for frameName, frame in pairs(RPTAGS.cache.UnitFrames)
    do  if Config.get("LOCK_FRAMES") then frame.DragFrame:Hide() else frame.DragFrame:Show() end;
    end; -- do
    if     not init and Config.get("LOCK_FRAMES") 
    then   notify("LOCKING_FRAMES") 
    elseif not init 
    then   notify("UNLOCKING_FRAMES") 
    end; -- if
  end; -- function

  local function resetAllLocations()
    local function lookup(unit) return _G[unit] end;
    for frameName, frame in pairs(RPTAGS.cache.UnitFrames)
    do local layout = frameLayout(frame);
       local w, h   = frameDimensions(layout);
       local IP = CONST.RPUF.INITIAL_POSITION[frame.unit];
       frame:SetSize(w, h);
       frame:ClearAllPoints();
       frame:SetPoint(IP.pt, lookup(IP.relto), IP.relpt, IP.x, IP.y);
       RP_TagsDB[frame.unit .. "UFlocation"] = nil;
    end; -- do
  end; -- function


  RPTAGS.utils.frames.move.reset     = resetLocation;
  RPTAGS.utils.frames.move.set       = setMovable;
  RPTAGS.utils.frames.all.move.reset = resetAllLocations;
  RPTAGS.utils.frames.all.move.lock  = lockAllFrames;
  RPTAGS.utils.frames.all.move.set   = setAllMovable;
end);
