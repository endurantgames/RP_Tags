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

  local CONST       = RPTAGS.CONST;
  local Utils       = RPTAGS.utils; 
  local notify      = Utils.text.notify;
  local Config      = Utils.config;
  local PANELS      = RPTAGS.CONST.FRAMES.PANELS;

  local function getFontFile(frame)
    return "Interface\\RP_UnitFrames\\Media\\Fonts\\Source_Code_Pro\\SourceCodePro-Regular.ttf"
  end; -- function

  local function getFontSize(frame)
    return 10;
  end;

  RPTAGS.utils.frames.font.getFile   = getFontFile;
  RPTAGS.utils.frames.font.getSize   = getFontSize;
end);
