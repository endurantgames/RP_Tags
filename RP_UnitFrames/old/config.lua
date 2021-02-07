-- RP Tags 
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 

local addOnName, addOn = ...;
local RPTAGS        = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("UTILS_CONFIG",
function(self, event, ...)
  local RPTAGS = RPTAGS;
  RPTAGS.utils        = RPTAGS.utils        or {};
  RPTAGS.utils.config = RPTAGS.utils.config or {};
  
  local CONST         = RPTAGS.CONST;
  local Utils         = RPTAGS.utils;
  local Config        = Utils.config;
  local Default       = CONST.CONFIG.DEFAULTS;
  
  local function tagEditBox(key) if not key then return nil; end;
    if RP_TagsDB.settings[key]
    then StaticPopup_Show("RPTAGS_TAG_EDIT_BOX", nil, nil, { setting = key, current = RP_TagsDB.settings[key].value, });
         return true;
    else return false;
    end; -- if
  end; -- function
  
  -- Functions available under RPTAGS.utils.config
  --
  Config.tagedit    = tagEditBox;
end);
