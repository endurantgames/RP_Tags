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

local RPQ_EVENTS = 
{ "ADDON_INIT", 

      "INIT_DATA",
          "INIT_CACHE",
          "INIT_LOCALE",

      "CORE_STATE",
          "DATA_CONST",

      "INIT_UTILS",

          "UTILS_LOCALE",
          "DATA_LOCALE",

          "UTILS_MODULES",
          "UTILS_CONFIG",
          "UTILS_TEXT",
          "UTILS_COLOR",
          "UTILS_FORMATS",
          "UTILS_PARSE",
          "UTILS_GET",
          "UTILS_FRAMES",

      "UTILS_TAGS",
          "DATA_TAGS",

      "INIT_OPTIONS",

          "UTILS_OPTIONS",
          "DATA_OPTIONS",

          "UTILS_HELP",
          "CORE_HELP",

          "CORE_OPTIONS",

          "CORE_SLASH",
          "CORE_KEYBIND",

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

local StartupFrame = CreateFrame("Frame");
StartupFrame:RegisterEvent("PLAYER_LOGIN");
StartupFrame:SetScript("OnEvent", function(self, event, ...) RPTAGS.queue:FireAll(); end);
RPTAGS.StartupFrame = StartupFrame;

_G["RPTAGS"] = RPTAGS;

