-- RPQ
--
-- Example:
--
-- local queue = RPADDONQUEUE_RPQ:New("My AddOn");
--
-- local thisEvent = queue:NewEvent("This Event", "thisevent");
--
-- queue:WaitUntil("This Event", function(self, event, ...) callback end);
-- queue:Fire("This Event");
--
-- queue:SetOrder("thisevent", "thatevent")
-- queue:FireAll();
--
-- local myModule = queue:NewModule("My Module", "mymod");
-- queue:NewModuleType("unitFrames");
-- myModule:SetType("unitFrames");
-- myModule:WaitUntil("thatevent", function(self, event, ...) callback end);

local RPQ = {};
local unpack = unpack or table.unpack

RPQ["_rpq_addOnList"] = {}
RPQ.verbose           = false;
RPQ.debug             = (RPQ.debug == nil) and true or false;
RPQ.debug             = false;
RPQ["_rpq_autoFire"]  = false;

local function error(...) return RPQ.debug and print("[RPQ|r] ", ...); end;

function RPQ.Get(self, addOnName) return self["_rpq_addOnList"][addOnName] end;

function RPQ.New(self, addOnName)

    if   self:Get(addOnName)
    then return error("There is already an addOn called " .. addOnName); 
    end;

    local newAddOn                      = {};
          newAddOn["_rpq_addOnName"]    = addOnName;
          newAddOn["_rpq_eventList"]    = {};
          newAddOn["_rpq_moduleList"]   = {};
          newAddOn["_rpq_orderList"]    = {};
          newAddOn["_rpq_defaultOrder"] = {};
          newAddOn["_rpq_moduleTypeList"] = {};
          newAddOn["_rpq"]              = self;

    function newAddOn.GetModuleTypes(self)            return self["_rpq_moduleTypeList"]; end;
    function newAddOn.GetEvents(self)                 return self["_rpq_eventList"];  end;
    function newAddOn.GetModules(self)                return self["_rpq_moduleList"]; end;
    function newAddOn.GetOrder(self, default)         return default and self["_rpq_defaultOrder"] or self["_rpq_orderList"] end;
    function newAddOn.GetModuleType(self, moduleType) return self["_rpq_moduleTypeList"][moduleType] end;

    function newAddOn.GetModulesByType(self, moduleType, callback, ...)
        -- The callback is optional but lets you do things like
        --
        -- modules = addOn:GetModulesByType("rpClients", function(module) return module["_rpq_moduleName"] end);
        --
        if not self:GetModuleType(moduleType)
        then return error("The addOn" .. self["_rpq_addOnName"] .. " doesn't have a module type called " .. moduleType);
        end;

        local out = {};
        for moduleName, module in pairs(self["_rpq_moduleList"])
        do  if   module["_rpq_moduleType"] == moduleType
            and  callback
            then local result = callback(module);
                  table.insert(out, result);
            elseif module["_rpq_moduleType"] == moduleType
            then   table.insert(out, module)
            end;
        end;

        return #out > 0 and out or nil;
    end;

    function newAddOn.GetName(self) return self["_rpq_moduleName"] end;

    function newAddOn.NewModuleType(self, moduleType)
        if self:GetModuleType(moduleType)
        then return error("The addOn" .. self["_rpq_addOnName"] .. " doesn't have a module type called " .. moduleType);
        end;
        self["_rpq_moduleTypeList"][moduleType] = true;
        return self;
    end;

    function newAddOn.GetEvent(self, eventName)    
       eventName = eventName:gsub("^before[%s:]", ""):gsub("^after[%s:]", "");
       return self["_rpq_eventList"][eventName]
    end;

    function newAddOn.GetModule(self, moduleName) return self["_rpq_moduleList"][moduleName] end;

    function newAddOn.NewEvent(self, eventName) 

        local newEvent                   = {};
              newEvent["_rpq_eventName"] = eventName;
              newEvent["_rpq_addOn"]     = self;
              newEvent["_rpq_fired"]     = false;
              newEvent["_rpq_queue"]     = {};
              newEvent["_rpq_preQueue"]  = {};
              newEvent["_rpq_postQueue"] = {};

        function newEvent.OnError(self, errorCallback)
              if type(errorCallback) == "function"
              then self["_rpq_errorCallback"] = errorCallback
              elseif type(errorCallback) == "string"
              then self["_rpq_errorCallback"] = function(self) return self["_rqq_errorCallback"] end
              end;
        end;

        function newEvent.GetName(self) return self["_rpq_eventName"] end;

        function newEvent.Fire(self, ...)
            local name = self:GetName();
            local fireArgs = ...;
            local errorCallback = self["_rpq_errorCallback"] 
                                  or self["_rpq_addOn"]["_rpq_errorCallback"]
                                  or function(result, eventName) return print("Error in", eventName, "!") end;
            local errorState, result

            local function runQueue(queue)
               for c, callback in ipairs(queue)
               do  result = callback:CanFire() and callback:Fire(name, fireArgs)
                   if   result and type(result) == "table" and result.error
                   then errorState = true;
                        errorCallback(result, eventName)
                        break;
                   end;
               end;
               return true
            end;
            
            local fire = runQueue(self["_rpq_preQueue"])  and not errorState
                     and runQueue(self["_rpq_queue"])     and not errorState
                     and runQueue(self["_rpq_postQueue"]) and not errorState;
               
            self["_rpq_fired"] = fire;

            return errorState;

            -- runQueue(self["_rpq_preQueue"]);
            -- if errorState then return errorState end

            -- runQueue(self["_rpq_queue"]);
            -- if errorState then return errorState end;

            -- runQueue(self["_rpq_postQueue"]);
            -- if errorState then return errorState end;

        end;

        function newEvent.ForEachCallback(self, func, ...)
            for c, callback in ipairs(self[ "_rpq_preQueue"]) do func(callback, forEachArgs) end;
            for c, callback in ipairs(self[    "_rpq_queue"]) do func(callback, forEachArgs) end;
            for c, callback in ipairs(self["_rpq_postQueue"]) do func(callback, forEachArgs) end;
        end;
            
        function newEvent.SetDisabled(value) self["_rpq_disabled"] = value; return value; end;
        function newEvent.CanFire(self) return not self["_rpq_fired"] and not self["_rpq_disabled"] end;
    
        function newEvent.GetQueue(self)
            local queue = {};
            for _, q in ipairs({"_rpq_preQueue", "_rpq_queue", "_rpq_postQueue"})
            do  for _, callback in ipairs(self[q])
                do table.insert(queue, callback)
                end;
            end;
            return queue, #queue;
        end;

        function newEvent.WaitUntil(self, callback, when)
    
            local newQueuedCallback                  = {};
                  newQueuedCallback["_rpq_event"]    = self;
                  newQueuedCallback["_rpq_addOn"]    = self["_rpq_addOn"];
                  newQueuedCallback["_rpq_fired"]    = false;
                  newQueuedCallback["_rpq_callback"] = callback;
    
            function newQueuedCallback:GetName()
                return self["_rpq_addOn"]["_rp_addOnName"] .. ":" .. self["_rpq_event"]["_rpq_eventName"]
            end;

            function newQueuedCallback.CanFire(self) return not self ["_rpq_fired"] end;
    
            function newQueuedCallback.Fire(self, event, ...)
              if    self:CanFire() 
              then  self["_rpq_fired"] = true;
                    local callback = self["_rpq_callback"];
                    return callback(self, event, ...)
              else  return nil;
              end;
            end;

            if     when == "before" then table.insert(self["_rpq_preQueue"],  newQueuedCallback);
            elseif when == "after"  then table.insert(self["_rpq_postQueue"], newQueuedCallback);
            else                         table.insert(self["_rpq_queue"],     newQueuedCallback);
            end;

            return newQueuedCallback;
        end; 

        self["_rpq_eventList"][eventName] = newEvent;
        table.insert(self["_rpq_defaultOrder"], newEvent);
        return newEvent;
    end;
    
    function newAddOn.NewEvents(self, eventList) 
        for _, eventName in ipairs(eventList) 
        do  self:NewEvent(eventName); 
        end; 
    end;

    function newAddOn.WaitUntil(self, eventName, callback) 
        local when;
        local before, eventNameBefore = string.match(eventName, "^(before)[%s:](.+)");
        local after,  eventNameAfter  = string.match(eventName,  "^(after)[%s:](.+)");

        if     before then eventName, when = eventNameBefore, before;
        elseif after  then eventName, when = eventNameAfter,  after;
        end;
        
        local  event = self:GetEvent(eventName);
        return event and event:WaitUntil(callback, when) or nil;
    end;

    function newAddOn.Fire(self, eventNameList, ...)
        if type(eventNameList) == "string" then eventNameList = { eventNameList }; end;

        for _, eventName in ipairs(eventNameList)
        do  local event = self:GetEvent(eventName);

            if not event
            then   return error("The addOn " .. self["_rpq_addOnName"] .. " has no event " .. event)
            else   return event:CanFire() and event:Fire(...)
            end;
        end;
    end;
        
    function newAddOn.SetOrder(self, orderedList)
       for _, eventName in ipairs(orderedList)
       do  local  eventObject = self:GetEvent(eventName);
           if not eventObject                 
           then   return error("The addOn " .. self["_rpq_addOnName"] .. " has no event " .. eventName);
           else   table.insert(self["_rpq_orderList"], eventObject);
           end;
       end
    end;

    function newAddOn.FireAll(self, ...)
      local errorState

      function self.process(self, eventList, ...)
        for e, event in ipairs(eventList)
        do  errorState = event:CanFire() and event:Fire(...) 
            if errorState then break; end;
        end;
      end;

      return ( self["_rpq_orderList"] and self:process(self:GetOrder()) ) 
             and not errorState
             and self:process(self:GetOrder(true))
    end;

    function newAddOn.ForEachEvent(self, func, ...)
      if   self["_rpq_orderList"] 
      then for _, event in ipairs(self:GetOrder())     do func(event); end; 
      end;
           for _, event in ipairs(self:GetOrder(true)) do func(event); end;
    end;
    

    function newAddOn.OnError(self, errorCallback)
         if     type(errorCallback) == "string"
         then   errorCallback = function(self) return self["_rpq_errorCallback"] end
         elseif type(errorCallback) == "function"
         then   self["_rpq_errorCallback"] = errorCallback;
         end;
         return self;
    end

    function newAddOn.NewModule(self, moduleName, moduleType) 
        if   self:GetModule(moduleName)
        then return error("The addOn " .. self["_rpq_addOnName"] .. " already has a module called " .. moduleName) 
        end;
 
 
        local newModule                     = {};
              newModule["_rpq_moduleName"]  = moduleName;
              newModule["_rpq_addOn"]       = self;

        function newModule.GetModuleType(self) return self["_rpq_moduleType"] end;
        function newModule.GetName(self) return self["_rpq_moduleName"] end;
 
        function newModule.SetModuleType(self, moduleType)
            if   not self["_rpq_addOn"]["_rpq_moduleTypeList"][moduleType] 
            then return error("The addOn " .. self["_rpq_addOn"]["_rpq_addOnName"] .. " doesn't have a type called " .. moduleType) 
            end;
 
            self["_rpq_moduleType"] = moduleType;
            return self;
        end;
 
        if moduleType and newModule["_rpq_addOn"]["_rpq_moduleTypeList"][moduleType]
        then newModule["_rpq_moduleType"] = moduleType;
        end;
 
        -- pass-throught functions
        --
        function newModule.Fire(             self, ... ) return self["_rpq_addOn"]:Fire(             ... ) end;
        function newModule.FireAll(          self, ... ) return self["_rpq_addOn"]:FireAll(          ... ) end;
        function newModule.GetEvent(         self, ... ) return self["_rpq_addOn"]:GetEvent(         ... ) end;
        function newModule.GetEvents(        self, ... ) return self["_rpq_addOn"]:GetEvents(        ... ) end;
        function newModule.GetModule(        self, ... ) return self["_rpq_addOn"]:GetModule(        ... ) end;
        function newModule.GetModuleTypes(   self, ... ) return self["_rpq_addOn"]:GetModuleTypes(   ... ) end;
        function newModule.GetModules(       self, ... ) return self["_rpq_addOn"]:GetModules(       ... ) end;
        function newModule.GetModulesByType( self, ... ) return self["_rpq_addOn"]:GetModulesByType( ... ) end;
        function newModule.GetOrder(         self, ... ) return self["_rpq_addOn"]:GetOrder(         ... ) end;
        function newModule.NewEvent(         self, ... ) return self["_rpq_addOn"]:NewEvent(         ... ) end;
        function newModule.NewEvents(        self, ... ) return self["_rpq_addOn"]:NewEvents(        ... ) end;
        function newModule.NewModuleType(    self, ... ) return self["_rpq_addOn"]:NewModuleType(    ... ) end;
        function newModule.SetOrder(         self, ... ) return self["_rpq_addOn"]:SetOrder(         ... ) end;
        function newModule.WaitUntil(        self, ... ) return self["_rpq_addOn"]:WaitUntil(        ... ) end;
        function newModule.ForEachEvent(     self, ... ) return self["_rpq_addOn"]:ForEachEvent(     ... ) end;
        function newModule.OnError(          self, ... ) return self["_rpq_addOn"]:OnError(          ... ) end;

        self["_rpq_moduleList"][moduleName] = newModule; 

        return newModule;
    end; 

    function newAddOn.AutoFire(self)
        if self["_rpq_autoFire"] and self.AutoFireFunction
        then self:AutoFireFunction();
        end;
    end;

    function newAddOn.SetAutoFire(self, func)
        self["_rpq_autoFire"] = func and true or false;
        self.AutoFireFunction = func;
        return self;
    end;

    self["_rpq_addOnList"][addOnName] = newAddOn; 
    return newAddOn;

end;

_G["RP_ADDON_QUEUE"] = RPQ;

