-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 

local RPTAGS          = RPTAGS;

RPTAGS.queue:WaitUntil("before UTILS_OPTIONS",
function(self, event, ...)
-- RPQ -----------------------------------------------------------------------------------------------------------------------------------------------
  
  local AceConfigDialog    = LibStub("AceConfigDialog-3.0");

  local Utils              = RPTAGS.utils;
  local notify             = Utils.text.notify;
  local loc                = Utils.locale.loc;
  local split              = Utils.text.split;
  local urlDB              = RPTAGS.CONST.URLS;
  local APP_NAME           = loc("APP_NAME");
  local getAddOn           = Utils.modules.getAddOn;
  local runFunction        = Utils.modules.runFunction;

  local function linkHandler(dest, link, text, amdwProtocol)
    local Cache              = RPTAGS.cache;
    local panelCache         = Cache.panels;
    local taghelpCache       = Cache.help.tagIndex;

    link = link or dest;
    local  protocol, path = link:match("^(%a+)://(.+)$");
    path = split(path, "/");
    local  path1 = path[1];
    if     (protocol == "opt"
        or protocol == "setting")
       and panelCache[path1]
    then   InterfaceOptionsFrame:Show()
           InterfaceOptionsFrame_OpenToCategory(panelCache[path1])
           AceConfigDialog:SelectGroup(loc("APP_NAME"), unpack(path));
    elseif protocol == "help"
    then   InterfaceOptionsFrame:Show()
           InterfaceOptionsFrame_OpenToCategory("help");
           AceConfigDialog:SelectGroup(loc("APP_NAME"), unpack(path));
    elseif protocol == "tag" and taghelpCache[path1]
    then   linkHandler(taghelpCache[path1])
    elseif protocol == "urldb" and urlDB[path1] and amdwProtocol
    then   link = loc(urlDB[path1].url);
           text = loc(urlDB[path1].name);
           amdwProtocol:ShowPopup(dest, link, text);
    elseif protocol == "addon"
    then   local addOn, func = link:match("//(.-)%?(.+)$");
           if   not runFunction(getAddOn(addOn), func)
           then notify("Unable to open this link: " .. link);
           end;
    else   notify("Unable to open this link: " .. link);
    end;
  end;
  
  local function linkHandlerCustomClick(amdwProtocol, dest, link, text) 
    return linkHandler(dest, link, text, amdwProtocol) 
  end;

  RPTAGS.utils.links                    = RPTAGS.utils.links or {};
  RPTAGS.utils.links.handler            = linkHandler;
  RPTAGS.utils.links.handlerCustomClick = linkHandlerCustomClick;
  
-- RPQ -----------------------------------------------------------------------------------------------------------------------------------------------
end);
