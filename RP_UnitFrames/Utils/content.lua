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

  local CONST   = RPTAGS.CONST;
  local Utils   = RPTAGS.utils;
  local Config  = Utils.config;

  local function setPanelContentOnFrame(frame, element, value, field)
    frame:Tag(frame[element][field or "text"], fixTagErrors(value)); 
    frame:UpdateTags();
  end; -- function

  local function setPanelContentOnAllFrames(element, value, field) 
    for  frameName, frame in pairs(RPTAGS.cache.UnitFrames)
    do   setElementTagString(frameName, element, value, field) 
    end; 
  end;

  local function setAllPanelContenOnFrame(frame) 
    for _, fontString in next, frame.content.fontStrings 
    do  frame:Tag(fontString, Config.get(fontString.setting)); 
    end;
    for _, toolTip in next, frame.content.tooltips    
    do  frame:Tag(toolTip, Config.get(toolTip.setting));    
    end;

    frame:UpdateAllElements('now')
  end; 

  local function setAllPanelContentOnAllFrames()
    for frameName, frame in pairs(RPTAGS.cache.UnitFrames)
    do  refreshFrame(frameName) 
    end; 
  end;

  RPTAGS.utils.frames.all.panels.all.content.set = setAllPanelContentOnAllFrames;
  RPTAGS.utils.frames.all.panels.content.set     = setPanelContentOnAllFrames;
  RPTAGS.utils.frames.panels.all.content.set     = setAllPanelContentOnFrame;
  RPTAGS.utils.frames.panels.content.set         = setPanelContentOnFrame;

end);
