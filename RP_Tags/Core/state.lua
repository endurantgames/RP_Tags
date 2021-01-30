-- ------------------------------------------------------------------------------
-- RP Tags
-- by Oraibi, Moon Guard (US) server
--
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. To view a copy of the license, visit
--
--     https://creativecommons.org/licenses/by/4.0/
--
-- State: program initalization
--
local RPTAGS = RPTAGS;
RPTAGS.queue:WaitUntil("CORE_STATE",
function(self, event, ...)

  local addOns = { other = {} };
  local rpqRequired = math.floor(tonumber(RPTAGS.metadata["X-RPQVersion"] or 1));
  for i = 1, GetNumAddOns() 
  do  local a = {};
      a.name, _, _, a.enabled = GetAddOnInfo(i); 
      a.title      = GetAddOnMetadata(a.name, "Title");
      a.modId      = GetAddOnMetadata(a.name, "X-RPQModuleId");
      a.modType    = GetAddOnMetadata(a.name, "X-RPQModuleType");
      a.modTarget  = GetAddOnMetadata(a.name, "X-RPQModuleTarget");
      a.rpq        = GetAddOnMetadata(a.name, "X-RPQVersion");
      a.version    = GetAddOnMetadata(a.name, "Version");
      a.desc       = GetAddOnMetadata(a.name, "Notes");

      if     a.name == RPTAGS.addOnName
      then   addOns.core = addOns.core or {};
             addOns.core[a.name] = a;
      elseif not a.modType or not a.modId
      then   addOns.other[a.name] = a;
      else   addOns[a.modType] = addOns[a.modType]                 or {};
             addOns[a.modType .. "_0"] = addOns[a.modType .. "_0"] or {};
             if     not a.enabled
             then   a.reason = "disabled";
                    addOns[a.modType .. "_0"][a.name] = a;
             elseif tonumber(a.rpq) < rpqRequired
             then   a.reason = "rpq-version";
                    addOns[a.modType .. "_0"][a.name] = a;
             elseif not a.modTarget
             then   a.reason = "unknown-target"
                    addOns[a.modType .. "_0"][a.name] = a;
             elseif not RPTAGS.queue:GetModule(a.name)
             then   a.reason = "no-module"
                    addOns[a.modType .. "_0"][a.name] = a;
             else   addOns[a.modType][a.name] = a;
             end;
      end;
  end;
       
  local countRpClient = 0;
  local countRpClient_0 = 0;

  for name, values in pairs(addOns.rpClient)
  do  if   not addOns.other[values.modTarget] 
      then addOns.rpClient_0[name] = values;
           addOns.rpClient_0[name].reason = "missing-target"
           addOns.rpClient.name = nil;
      else countRpClient = countRpClient + 1;
      end;
  end;

  for n, v in pairs(addOns.rpClient_0) do countRpClient_0 = countRpClient_0 + 1; end;

  local countUnitFrames = 0;
  local countUnitFrames_0 = 0;
  for name, values in pairs(addOns.unitFrames)
  do  if     not addOns.other[values.modTarget] 
      then   addOns.rpClient_0[name] = values;
             addOns.rpClient_0[name].reason = "missing-target"
             addOns.rpClient.name = nil;
      elseif not addOns.other[values.modTarget].enabled
      then   addOns.rpClient_0[name] = values;
             addOns.rpClient_0[name].reason = "disabled-target"
             addOns.rpClient.name = nil;

      else   countUnitFrames = countUnitFrames + 1;
      end;
  end;

  for n, v in pairs(addOns.unitFrames_0) do countUnitFrames_0 = countRpClient_0 + 1; end;

  RPTAGS.cache.addOns = addOns

  if     countRpClient == 0 and countRpClient_0 == 0
  then   return { error = true, errorMessage = "You don't have any RP addon modules that work with " .. RPTAGS.metadata.Title .. "." };
  elseif countRpClient == 0 and countRpClient_0 > 1
  then   local reasons = {};
         for name, a in pairs(addOns.rpClient_0)
         do  local changeAddOns;
             if     a.reason == "disabled"
             then   table.insert(reasons, "You have " .. a.title .. " but it's currently disabled. Please re-enable it and reload your UI.")
                    changeAddOns = true;
             elseif a.reason == "missing-target"
             then   table.insert(reasons, "You have " .. a.title .. " but you don't have " .. a.modTarget .. " installed.")
             elseif a.reason == "disabled-target"
             then   table.insert(reasons, "You have " .. a.title .. " but " .. a.modTarget .. " is currently disabled. Please re-enable it and reload your UI.")
                    changeAddOns = true;
             elseif a.reason == "rpq-version"
             then   table.insert(reasons, "You have " .. a.title .. " but it isn't compatible with this verison of " .. RPTAGS.metadata.Title .. ".");
             else   table.insert(reasons, "You have " .. a.title .. " but the TOC file is invalid.")
             end;
             return { error = true, changeAddons = changeAddOns,
                      errorMessage = RPTAGS.metadata.Title .. " needs a compatible RP addon module to work.\n\n" .. table.concat(reasons, "\n") } 
         end;
  elseif countUnitFrames == 0 and countUnitFrames_0 == 0
  then   return { error = true, errorMessage = "You don't have any unit frame addon modules that work with " .. RPTAGS.metadata.Title .. "." };
  elseif countUnitFrames == 0 and countUnitFrames_0 > 1
  then   local reasons = {};
         for name, a in pairs(addOns.unitFrames_0)
         do  local changeAddOns;
             if     a.reason == "disabled"
             then   table.insert(reasons, "You have " .. a.title .. " but it's currently disabled. Please re-enable it and reload your UI.")
                    changeAddOns = true;
             elseif a.reason == "missing-target"
             then   table.insert(reasons, "You have " .. a.title .. " but you don't have " .. a.modTarget .. " installed.")
             elseif a.reason == "disabled-target"
             then   table.insert(reasons, "You have " .. a.title .. " but " .. a.modTarget .. " is currently disabled. Please re-enable it and reload your UI.")
                    changeAddOns = true;
             elseif a.reason == "rpq-version"
             then   table.insert(reasons, "You have " .. a.title .. " but it isn't compatible with this verison of " .. RPTAGS.metadata.Title .. ".");
             else   table.insert(reasons, "You have " .. a.title .. " but the TOC file is invalid.")
             end;
             return { error = true, changeAddOns = changeAddOns,
                      errorMessage = RPTAGS.metadata.Title .. " needs a compatible unit frame addon module to work.\n\n" .. table.concat(reasons, "\n") } 
         end;
  else   return nil;
  end;

end);
