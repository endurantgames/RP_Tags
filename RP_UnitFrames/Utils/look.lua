-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 

local addOnName, addOn = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

-- local oUF    = RPTAGS.oUF;

Module:WaitUntil("UTILS_FRAMES",
function(self, event, ...)

  local CONST = RPTAGS.CONST;
  local PANEL_LIST = CONST.FRAMES.PANELS;
  local Frames     = RPTAGS.cache.UnitFrames;

  local function setStatusTexture(frame)
    if not frame.StatusBarPanel then return nil end;
    frame.StatusBarPanel:SetBackdrop(RPTAGS.CONST.STATUSBAR_TEXTURE[Config.get("STATUS_TEXTURE")]);
    local bgRed, bgGreen, bgBlue = RPTAGS.utils.color.hexaToNumber(Config.get("COLOR_RPUF"));
    local alpha = RPTAGS.CONST.STATUSBAR_ALPHA[Config.get("STATUS_TEXTURE")];
    frame.StatusBarPanel:SetBackdropColor(bgRed / 382.5, bgGreen / 382.5, bgBlue / 382.5, alpha); -- 382.5 == 255 * 1.5
  end; -- function

  local function setAllStatusTextures() 
    for frameName, frame in pairs(Frames)
    do  setStatusBarTexture(frame) 
    end; 
  end;

  local function setStatusAlign(frame) 
    if not frame.StatusBarPanel then return nil end; 
    frame.StatusBarPanel.text:SetJustifyH(RPTAGS.CONST.ALIGN[Config.get("STATUS_ALIGN")].H); 
    frame.StatusBarPanel.text:SetJustifyV(RPTAGS.CONST.ALIGN[Config.get("STATUS_ALIGN")].V); 
  end;

  local function setAllStatusBarAligns() 
    for frameName, frame in pairs(Frames) 
    do  setStatusBarAlignment(frame) 
    end; 
  end;

  local function setAllBackdrops()
    local alpha, color, backdrop = Config.get("RPUFALPHA"), Config.get("COLOR_RPUF"), Config.get("RPUF_BACKDROP")
    local bgRed, bgGreen, bgBlue = RPTAGS.utils.color.hexaToNumber(color);
    for frameName, frame in ipairs(Frames)
    do frame:SetBackdrop(CONST.BACKDROP[backdrop])
       frame:SetBackdropColor(bgRed / 255, bgGreen / 255, bgBlue / 255, alpha/100);
       frame.PortraitBackground:SetVertexColor(bgRed / 255, bgGreen / 255, bgBlue / 255, alpha / 100);
    if   backdrop:match("_LINE$")
    then frame.PortraitPanel:SetBackdropBorderColor(1/2 + bgRed / 510, 1/2 + bgGreen / 510, 1/2 + bgBlue / 1/2, 1);
    end;
    end; -- for
    RPUF_Tooltip:UpdateColors();
    setAllStatusBarTextures()
  end; -- function

  local function setTextColors(frame, request)
    local fontStringList, r, g, b;
    if    request == "tt" 
    then  fontStringList = frame.tooltips;    
          r, g, b = RPTAGS.utils.color.hexaToNumber(Config.get("COLOR_RPUF_TOOLTIP")); 
          r, g, b = r/255, g/255, b/255;
    else  fontStringList = frame.fontStrings; 
          r, g, b = RPTAGS.utils.color.hexaToNumber(Config.get("COLOR_RPUF_TEXT"));    
          r, g, b = r/255, g/255, b/255; end; 
    if not fontStringList then return nil end;
    for _, fs in ipairs(fontStringList) do fs:SetTextColor(r, g, b) end;
    return true;
  end;

  local function setAllTextColors(request) 
    for frameName, frame in pairs(Frames)
    do  setTextColors(frame, request) end; 
  end;

  local function getPanelHorizontalAlignment(panelName, layout);
    return 
        (   panelName == "StatusBarPanel" 
        and RPTAGS.CONST.ALIGN[Config.get("STATUS_ALIGN"].H )
      or ( ( panelName == "NamePanel" or panel == "InfoPanel")
           and
           ( layout == "PAPERDOLL" or layout == "THUMBNAIL" )
           and
           "CENTER" )
         )
      or "LEFT";
  end

  RPTAGS.utils.frames.panels.align.getH           = getPanelHorizontalAlignment;
  RPTAGS.utils.frames.all.look.backdrop.set       = setAllBackdrops;
  RPTAGS.utils.frames.all.look.colors.set         = setAllTextColors;
  RPTAGS.utils.frames.all.look.status.align.set   = setAllStatusAlign;
  RPTAGS.utils.frames.all.look.status.texture.set = setAllStatusTextures;
  RPTAGS.utils.frames.look.colors.set             = setTextColors;
  RPTAGS.utils.frames.look.status.align.set       = setStatusAlign;
  RPTAGS.utils.frames.look.status.texture.set     = setStatusTexture;
end);
