-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 

local addOnName, ns = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:NewModule(addOnName, "rpClient");

RPTAGS.oUF = RPTAGS.oUF or _G[GetAddOnMetadata(addOnName, "X-oUF")]; -- let RP_Tags use our oUF for previews

_G["RP_UnitFramesDB"] = RP_UnitFramesDB or {};

Module:WaitUntil("MODULE_C",
function(self, event, ...)
  local registerFunction = RPTAGS.utils.modules.registerFunction;
  
  local function openUIPanel(panel)
    return
      function() 
        RPTAGS.utils.links.handler(RPTAGS.CONST.UIPANELS[panel])
      end;
  end;

  registerFunction(addOnName, "options", openUIPanel("frames"  ));
  registerFunction(addOnName, "version", openUIPanel("version" ));
  registerFunction(addOnName, "about",   openUIPanel("about"   ));
  registerFunction(addOnName, "help",    openUIPanel("help"    ));
  registerFunction(addOnName, "on", 
    function() 
      RPTAGS.utils.config.set("DISABLE_RPUF", false) 
    end);
  registerFunction(addOnName, "off", 
    function() 
      RPTAGS.utils.config.set("DISABLE_RPUF", true) 
    end);
  registerFunction(addOnName, "on_off",
    function() 
      RPTAGS.utils.config.set("DISABLE_RPUF",
        not RPTAGS.utils.config.get("DISABLE_RPUF")) 
    end);
  registerFunction(addOnName, "hide_combat",
    function() 
      RPTAGS.utils.config.set("HIDE_COMBAT",
        not RPTAGS.utils.config.get("HIDE_COMBAT")) 
    end);
  registerFunction(addOnName, "moveframes",
    function()
      RPTAGS.utils.config.set("LOCK_FRAMES",
        not RPTAGS.utils.config.get("LOCK_FRAMES"))
    end);
  registerFunction(addOnName, "editor",
    function() 
      RPTAGS.cache.Editor:Show() 
    end);

end);

