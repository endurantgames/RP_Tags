-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license.
--
-- State: program initalization
--
local RPTAGS = RPTAGS;
RPTAGS.queue:WaitUntil("CORE_STATE",
function(self, event, ...)

  local addOns = { other = {} };
  local rpqRequired = math.floor(tonumber(RPTAGS.metadata["X-RPQVersion"] or 1));
  local targets = {};
  for i = 1, GetNumAddOns() 
  do  local a = {};
      a.name, _, _, a.enabled = GetAddOnInfo(i); 
      a.title      = GetAddOnMetadata(a.name, "Title");
      a.rpqId      = GetAddOnMetadata(a.name, "X-RPQModuleId");
      a.rpqType    = GetAddOnMetadata(a.name, "X-RPQModuleType");
      a.rpqTarget  = GetAddOnMetadata(a.name, "X-RPQModuleTarget");
      a.rpq        = GetAddOnMetadata(a.name, "X-RPQVersion");
      a.version    = GetAddOnMetadata(a.name, "Version");
      a.desc       = GetAddOnMetadata(a.name, "Notes");

      if     a.name == RPTAGS.addOnName
      then   addOns.core = addOns.core or {};
             addOns.core[a.name] = a;
      elseif not a.rpqType or not a.rpqId
      then   addOns.other[a.name] = a;
      else   addOns[a.rpqType] = addOns[a.rpqType]                 or {};
             addOns[a.rpqType .. "_0"] = addOns[a.rpqType .. "_0"] or {};

             -- if not a.rpqTarget
             -- then   a.reason = "unknown-target"
             --        addOns[a.rpqType .. "_0"][a.name] = a;
             -- elseif not a.enabled
             if not a.enabled
             then   a.reason = "disabled";
                    addOns[a.rpqType .. "_0"][a.name] = a;
                    -- targets[a.rpqTarget] = a.name;
             elseif tonumber(a.rpq) < rpqRequired
             then   a.reason = "rpq-version";
                    addOns[a.rpqType .. "_0"][a.name] = a;
                    -- targets[a.rpqTarget] = a.name;
             elseif not RPTAGS.queue:GetModule(a.name)
             then   a.reason = "no-module"
                    addOns[a.rpqType .. "_0"][a.name] = a;
                    -- targets[a.rpqTarget] = a.name;
             else   addOns[a.rpqType][a.name] = a;
                    -- targets[a.rpqTarget] = a.name;
             end;
             if a.rpqTarget then targets[a.rpqTarget] = a.name; end;
      end;
  end;

  local function check_targets(addOns, rpqType)
        local count = 0;
        local count_0 = 0;
        local rpqType_0 = rpqType .. "_0";

        if   addOns[rpqType_0]
        then for name, values in pairs(addOns[rpqType_0])
             do  local target = values.rpqTarget;
                 if    addOns.other[target]
                 then  addOns.targets[target] = addOns.other[target];
                       addOns.targets[target].TargetOf = name;
                       addOns.other[target] = nil;
                 end;
              end;
              count_0 = count_0 + 1;
        else addOns[rpqType_0] = {};
        end;

        if addOns[rpqType]
        then for name, values in pairs(addOns[rpqType])
             do  local  target = values.rpqTarget;
                 if     not target
                 then   count = count + 1;

                 elseif not addOns.other[target]
                 then   addOns[rpqType_0][name]         = values;
                        addOns[rpqType_0][name].reason  = "missing-target";
                        addOns[rpqType][name]           = nil;
                        count_0                         = count_0 + 1;

                 elseif not addOns.other[target].enabled
                 then   addOns[rpqType_0][name]         = values;
                        addOns[rpqType_0][name].reason  = "disabled-target";
                        addOns[rpqType][name]           = nil;
                        count_0                         = count_0 + 1;

                        addOns.targets[target]          = addOns.other[target];
                        addOns.other[target]            = nil;
                        addOns.targets[target].TargetOf = name;
                        addOns.targets[target].rpqType  = "targetOf" .. values.rpqType;

                 else   addOns.targets[target]          = addOns.other[target];
                        addOns.other[target]            = nil;
                        addOns.targets[target].TargetOf = name;
                        addOns.targets[target].rpqType  = "targetOf" .. values.rpqType;
                        count                           = count + 1;
                 end;
             end;
        else addOns[rpqType] = {};
        end;

        return count, count_0;

  end;

  addOns.targets = {};

  local count = {};

  for rpqType, _ in pairs(addOns)
  do if rpqType ~= "other" and rpqType ~= "targets" and not rpqType:match("_0$")
     then count[rpqType], count[rpqType .. "_0"] = check_targets(addOns, rpqType);
     end;
  end;

  RPTAGS.cache.addOns = addOns

  if     count.rpClient == 0 and count.rpClient_0 == 0
  then   return { error = true, errorMessage = "You don't have any RP addon modules that work with " .. RPTAGS.metadata.Title .. "." };
  elseif count.rpClient == 0 and count.rpClient_0 > 1
  then   local reasons = {};
         for name, a in pairs(addOns.rpClient_0)
         do  local changeAddOns;
             if     a.reason == "disabled"
             then   table.insert(reasons, "You have " .. a.title .. " but it's currently disabled. Please re-enable it and reload your UI.")
                    changeAddOns = true;
             elseif a.reason == "missing-target"
             then   table.insert(reasons, "You have " .. a.title .. " but you don't have " .. a.rpqTarget .. " installed.")
             elseif a.reason == "disabled-target"
             then   table.insert(reasons, "You have " .. a.title .. " but " .. a.rpqTarget .. " is currently disabled. Please re-enable it and reload your UI.")
                    changeAddOns = true;
             elseif a.reason == "rpq-version"
             then   table.insert(reasons, "You have " .. a.title .. " but it isn't compatible with this verison of " .. RPTAGS.metadata.Title .. ".");
             else   table.insert(reasons, "You have " .. a.title .. " but the TOC file is invalid.")
             end;
             return { error = true, changeAddons = changeAddOns,
                      errorMessage = RPTAGS.metadata.Title .. " needs a compatible RP addon module to work.\n\n" .. table.concat(reasons, "\n") } 
         end;
  elseif count.unitFrames == 0 and count.unitFrames_0 == 0
  then   return { error = true, errorMessage = "You don't have any unit frame addon modules that work with " .. RPTAGS.metadata.Title .. "." };
  elseif count.unitFrames == 0 and count.unitFrames_0 > 1
  then   local reasons = {};
         for name, a in pairs(addOns.unitFrames_0)
         do  local changeAddOns;
             if     a.reason == "disabled"
             then   table.insert(reasons, "You have " .. a.title .. " but it's currently disabled. Please re-enable it and reload your UI.")
                    changeAddOns = true;
             elseif a.reason == "missing-target"
             then   table.insert(reasons, "You have " .. a.title .. " but you don't have " .. a.rpqTarget .. " installed.")
             elseif a.reason == "disabled-target"
             then   table.insert(reasons, "You have " .. a.title .. " but " .. a.rpqTarget .. " is currently disabled. Please re-enable it and reload your UI.")
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

