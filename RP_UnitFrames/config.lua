-- ------------------------------------------------------------------------------
-- RP Tags 
-- by Oraibi, Moon Guard (US) server
--
-- Ora's twitter: http://twitter.com/oraibimoonguard
-- Download site: http://tinyurl.com/rptags-tukui
-- Documentation: http://tinyurl.com/rptags-wiki
--
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. To view a copy of the license, visit
--
--     https://creativecommons.org/licenses/by/4.0/
--
-- This license is acceptable for Free Cultural Works.
--
-- You are free to:
--
-- Share -- copy and redistribute the material in any medium or format
-- Adapt -- remix, transform, and build upon the material
--         for any purpose, even commercially.
-- 
-- The licensor cannot revoke these freedoms as long as you follow the 
-- license terms.
-- 
-- Under the following terms:
-- Attribution -- You must give appropriate credit, provide a link to the
--         license, and indicate if changes were made. You may do
--         so in any reasonable manner, but not in any way that
--         suggests the licensor endorses you or your use.
--
-- No additional restrictions -- You may not apply legal terms or
--         technological measures that legally restrict others from doing
--         anything the license permits.
--
-- Notices:
--
-- You do not have to comply with the license for elements of the material
-- in the public domain or where your use is permitted by an applicable
-- exception or limitation.
--
-- No warranties are given. The license may not give you all of the
-- permissions necessary for your intended use. For example, other rights
-- such as publicity, privacy, or moral rights may limit how you use the
-- material.
-- ------------------------------------------------------------------------------

-- Utils-Config: Utilities for reading and registering configuration values

local RPTAGS        = RPTAGS;

RPTAGS.queue:WaitUntil("LOAD_UTILS_CONFIG",
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
