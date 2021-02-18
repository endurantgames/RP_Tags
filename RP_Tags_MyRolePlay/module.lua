-- ------------------------------------------------------------------------------
-- RP Tags 
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. To view a copy of the license, visit
--
--     https://creativecommons.org/licenses/by/4.0/

local addOnName, ns = ...;
local RPTAGS        = RPTAGS;
local Module        = RPTAGS.queue:NewModule(addOnName, "rpClient");

Module:WaitUntil("ADDON_LOAD",
function(self, event, ...)
    local getUnitID = RPTAGS.utils.get.core.unitID;
    local refreshFrame = RPTAGS.utils.tags.refreshFrame;
      table.insert(msp.callback.received, 
        function(unitID)
          RPTAGS.utils.frames.refreshAll();
        end);
   end
);

Module:WaitUntil("MODULE_C",
function(self, event, ...)
  local registerFunction = RPTAGS.utils.modules.registerFunction;

  local function mapMrpSlash(mrpParam)
    return function(a) SlashCmdList["MYROLEPLAY"](mrpParam .. " " .. (a or "")); end;
  end;

  registerFunction("MyRolePlay", "open",       mapMrpSlash(""          ));
  registerFunction("MyRolePlay", "options",    mapMrpSlash("options"   ));
  registerFunction("MyRolePlay", "version",    mapMrpSlash("version"   ));
  registerFunction("MyRolePlay", "help",       mapMrpSlash("help"      ));
  registerFunction("MyRolePlay", "on",         mapMrpSlash("enable"    ));
  registerFunction("MyRolePlay", "off",        mapMrpSlash("disable"   ));
  registerFunction("MyRolePlay", "showplayer", mapMrpSlash("show"      ));
  registerFunction("MyRolePlay", "setcurr",    mapMrpSlash("currently" ));
  registerFunction("MyRolePlay", "setic",      mapMrpSlash("ic"        ));
  registerFunction("MyRolePlay", "setooc",     mapMrpSlash("ooc"       ));
  registerFunction("MyRolePlay", "about",      mapMrpSlash("version"   ));

end);

