-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license.

local addOnName, RPTAGS = ...;
RPTAGS.addOnName = addOnName;

local RPQ = _G["RP_ADDON_QUEUE"];
if not RPQ then error(addOnName .. " requires RPQ"); end;

local Queue = RPQ:New(addOnName);
Queue:NewModuleType("rpClient");
Queue:NewModuleType("unitFrames");
Queue:NewModuleType("dataSource");

local RPQ_EVENTS = 
{ "ADDON_INIT",        
    "INIT_DATA",        "INIT_CACHE",     "INIT_LOCALE",                 -- arbitrary:
      "CORE_STATE",     "DATA_CONST",                                       "MODULE_A",      
    "INIT_UTILS",       "UTILS_LOCALE",   "DATA_LOCALE",  "UTILS_MODULES",  "MODULE_B", 
      "UTILS_CONFIG",   "UTILS_TEXT",     "UTILS_COLOR",  "UTILS_KEYBIND",  "MODULE_C",      
      "UTILS_FORMATS",  "UTILS_PARSE",    "UTILS_GET",    "UTILS_FRAMES",   "MODULE_D", 
      "UTILS_TAGS",     "DATA_TAGS",                                        "MODULE_E",     
    "INIT_OPTIONS",     "UTILS_OPTIONS",                                    "MODULE_F",
     "OPTIONS_GENERAL", "OPTIONS_COLORS", "OPTIONS_HELP", "OPTIONS_ABOUT",  "MODULE_G",      
     "CORE_OPTIONS",                                                        "MODULE_H",
    "UTILS_HELP",       "CORE_HELP",                                        "MODULE_I",      
      "CORE_SLASH",     "CORE_KEYBIND",                                     "MODULE_J",     
  "ADDON_LOAD",        
};

Queue:NewEvents(RPQ_EVENTS);
Queue:SetOrder(RPQ_EVENTS);

--- error handling

local POPUP = "RPTAGS_STARTUP_ERROR";

StaticPopupDialogs[POPUP] = 
{ button2 = "I Understand",
  showAlert = true,
  whileDead = true,
  timeout = 0,
  wide = true,
  OnShow = 
    function(self, data)
      self.text:SetJustifyH("LEFT");
      self.text:SetSpacing(3);
    end,
};

Queue:OnError(
  function(eventResult, eventName)
    if   eventResult and type(eventResult) == "table" and eventResult.error
    then local errorMessage = "|cffff3333" .. RPTAGS.metadata.Title .. " Startup Error|r\n\n" .. (eventResult.errorMessage or "Unknown error");
         if   eventResult.changeAddOns
         then StaticPopupDialogs[POPUP].button1 = "AddOn List"
              StaticPopupDialogs[POPUP].OnAccept = 
                function(self) 
                  if ACP 
                  then ACP:ToggleUI() 
                  else AddonList_Show() 
                  end 
                  self:Hide();
                end;
         end;
              
         StaticPopupDialogs[POPUP].text = errorMessage;
         StaticPopup_Show(POPUP);
    end;
  end);

RPTAGS.queue = Queue;

local EventsFrame = CreateFrame("Frame");
EventsFrame:RegisterEvent("PLAYER_LOGIN");
EventsFrame:SetScript("OnEvent", function(self, event, ...) RPTAGS.queue:FireAll(); end);
RPTAGS.EventsFrame = EventsFrame;

_G["RPTAGS"] = RPTAGS;

