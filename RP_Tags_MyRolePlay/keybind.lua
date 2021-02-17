-- ------------------------------------------------------------------------------
-- RP Tags 
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. To view a copy of the license, visit
--
--     https://creativecommons.org/licenses/by/4.0/

local addOnName, ns = ...
local RPTAGS        = RPTAGS;
local Module        = RPTAGS.queue:GetModule(addOnName);
local Target = GetAddOnMetadata(addOnName, "X-RPQModuleTarget");

Module:WaitUntil("MODULE_G",
function(self, event, ...)
  local build_keybind = RPTAGS.utils.options.keybind;
  local addOptions    = RPTAGS.utils.modules.addOptions;

  addOptions(addOnName, "general.keybind",
    { ic_ooc = build_keybind("ic_ooc"),
      mouseover_open = build_keybind("mouseover_open") }
    );
end);

Module:WaitUntil("CORE_KEYBIND",
function(self, event, ...)
  local registerKeybind = RPTAGS.utils.keybind.register;
  local linkHandler = RPTAGS.utils.links.handler;
  local run = RPTAGS.utils.modules.runFunction;
  
  registerKeybind("IC_OOC", 
    function()
      if msp.my.FC == "1" -- ooc
         then linkHandler("addon://MyRolePlay?setic")
         else linkHandler("addon://MyRolePlay?setooc")
      end;
    end
  );
  
  registerKeybind("MOUSEOVER_OPEN",
    function()
      if   not UnitExists('mouseover') 
        or not UnitIsPlayer('mouseover') 
      then return nil 
      end;
      local unitID = RPTAGS.utils.get.core.unitID('mouseover');
      if not unitID then return nil end;
      run(Target, "showplayer", unitID);
    end
  );
           
end);
