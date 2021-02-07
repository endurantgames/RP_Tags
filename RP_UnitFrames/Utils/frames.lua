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

  local RPTAGS = RPTAGS;
  local fontFrame = CreateFrame('frame');
  local font = fontFrame:CreateFontString(nil, 'OVERLAY', 'GameFontNormal');
  local FONTFILE, FONTSIZE, _ = font:GetFont();

  RPTAGS.utils = RPTAGS.utils or {};
  RPTAGS.utils.rpuf = RPTAGS.utils.rpuf or {};
  
  local CONST       = RPTAGS.CONST;
  local Utils       = RPTAGS.utils; 
  local notify      = RPTAGS.utils.text.notify;

  local Config      = RPTAGS.utils.config;
  local PANELS      = { "NamePanel", "InfoPanel", "PortraitPanel", "DetailsPanel", 
                        "StatusBarPanel", "Icon_1Panel", "Icon_2Panel", "Icon_3Panel", 
                        "Icon_4Panel", "Icon_5Panel", "Icon_6Panel", };
  local FRAME_LIST  = { "RPUF_Player", "RPUF_Target", "RPUF_Focus", "RPUF_Mouseover", };
  -- "RPUF_TargetTarget", 

  local function FRAMES() 
    local frames = {}; 
    for _, f in ipairs(FRAME_LIST) 
    do  table.insert(frames, _G[f]) 
    end; 
    return frames; 
  end; -- function

  -- tag functions --------------------------------------------------------------------------------------------------------------------------------------------

  local function setAllFrameScales() 
    RPUF_Player:SetScale(Config.get("PLAYERFRAME_SCALE"));
    RPUF_Target:SetScale(Config.get("TARGETFRAME_SCALE"));
    RPUF_Focus:SetScale(Config.get("FOCUSFRAME_SCALE"));
    -- RPUF_TargetTarget:SetScale(Config.get("TARGETTARGETFRAME_SCALE"));
  end;

  local function tagAll(element, value, field) for _, frame in ipairs(FRAMES()) do setTag(frame, element, value, field) end; end;

  local function resizePanel(frame, panel, layout)
    local w    = elementWidth( panel, layout); -- calculate the width
    local h    = elementHeight(panel, layout); -- calculate the height
    local top  = elementTop(   panel, layout); -- calculate the point
    local left = elementLeft(  panel, layout);
    if panel:match("^Icon_") then h = h + 3; w = w * 2; frame[panel].text:SetFont(FONTFILE, h - 1); end;
    if top == 5000 then frame[panel]:Hide() return end;
    frame[panel]:SetSize(w, h);
    frame[panel]:SetPoint('TOPLEFT', frame, 'TOPLEFT', left, top);
    frame[panel]:Show()
    if   frame[panel].text 
    then frame[panel].text:SetHeight(h); 
         frame[panel].text:SetWidth(w); 
         frame[panel].text:SetJustifyH(elementAlignH(panel, layout))
    end;
    frame:UpdateAllElements('now');
  end; -- function

  local function resizeFrame(frame)
    local layout = frameLayout(frame);
    for _, panel in ipairs(PANELS) do resizePanel(frame, panel, layout); end;
    frame.StatusBarPanel.text:SetWidth(elementWidth("StatusBarPanel", layout) - GAP(2));
    frame.StatusBarPanel.text:SetPoint("TOPLEFT", frame.StatusBarPanel, "TOPLEFT", GAP(1), NGAP(0.5));
    frame.StatusBarPanel.text:SetHeight(elementHeight("StatusBarPanel", layout) - GAP(1)); 
    local w, h = frameDimensions(layout);
    frame:SetWidth(w);
    frame:SetHeight(h);
  end; -- function

  local function resizeAllFrames() for _, frame in ipairs(FRAMES()) do resizeFrame(frame) end; end;

  local function setStatusBarTexture(frame)
    if not frame.StatusBarPanel then return nil end;
    frame.StatusBarPanel:SetBackdrop(RPTAGS.CONST.STATUSBAR_TEXTURE[Config.get("STATUS_TEXTURE")]);
    local bgRed, bgGreen, bgBlue = RPTAGS.utils.color.hexaToNumber(Config.get("COLOR_RPUF"));
    local alpha = RPTAGS.CONST.STATUSBAR_ALPHA[Config.get("STATUS_TEXTURE")];
    frame.StatusBarPanel:SetBackdropColor(bgRed / 382.5, bgGreen / 382.5, bgBlue / 382.5, alpha); -- 382.5 == 255 * 1.5
  end; -- function

  local function setAllStatusBarTextures() for _, frame in ipairs(FRAMES()) do setStatusBarTexture(frame) end; end;

  local function setStatusBarAlignment(frame) 
    if not frame.StatusBarPanel then return nil end; 
    frame.StatusBarPanel.text:SetJustifyH(RPTAGS.CONST.ALIGN[Config.get("STATUS_ALIGN")].H); 
    frame.StatusBarPanel.text:SetJustifyV(RPTAGS.CONST.ALIGN[Config.get("STATUS_ALIGN")].V); 
  end;
  local function setAllStatusBarAlignments() for _, frame in ipairs(FRAMES()) do setStatusBarAlignment(frame) end; end;

  local function setAllBackground()
    local alpha, color, backdrop = Config.get("RPUFALPHA"), Config.get("COLOR_RPUF"), Config.get("RPUF_BACKDROP")
    local bgRed, bgGreen, bgBlue = RPTAGS.utils.color.hexaToNumber(color);
    for _, frame in ipairs(FRAMES())
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

  local function lockFrames(init) 
    for _, frame in ipairs(FRAMES())
    do  if Config.get("LOCK_FRAMES") then frame.DragFrame:Hide() else frame.DragFrame:Show() end;
    end; -- do
    if  not init and Config.get("LOCK_FRAMES") then notify("LOCKING_FRAMES") elseif not init then notify("UNLOCKING_FRAMES") end; -- if
  end; -- function

  local function resetAllLocations()
    local function lookup(unit) return _G[unit] end;
    for _, frame in ipairs(FRAMES())
    do local layout = frameLayout(frame);
       local w, h   = frameDimensions(layout);
       local IP = CONST.RPUF.INITIAL_POSITION[frame.unit];
       frame:SetSize(w, h);
       frame:ClearAllPoints();
       frame:SetPoint(IP.pt, lookup(IP.relto), IP.relpt, IP.x, IP.y);
       RP_TagsDB[frame.unit .. "UFlocation"] = nil;
    end; -- do
  end; -- function

  local function hideString(unit)
    local conditions = {};

    if Config.get("DISABLE_RPUF"       ) then return "hide"                                   end;
    if Config.get("RPUF_HIDE_DEAD"     ) then table.insert(conditions, "[dead] hide"       ); end;
    if Config.get("RPUF_HIDE_PETBATTLE") then table.insert(conditions, "[petbattle] hide"  ); end;
    if Config.get("RPUF_HIDE_VEHICLE"  ) then table.insert(conditions, "[vehicleui] hide"  ); end;
    if Config.get("RPUF_HIDE_PARTY"    ) then table.insert(conditions, "[group:party] hide"); end;
    if Config.get("RPUF_HIDE_RAID"     ) then table.insert(conditions, "[group:raid] hide" ); end;
    if Config.get("RPUF_HIDE_COMBAT"   ) then table.insert(conditions, "[combat] hide"     ); end;

    table.insert(conditions, "[@" .. unit .. ",exists] show");
    table.insert(conditions, "hide");

    if unit == 'mouseover' then return "show" else return table.concat(conditions, ";"); end;
  end;
     
  local function setHide(init)
    for _, frame in ipairs(FRAMES())
    do UnregisterStateDriver(frame, 'visibility');
         RegisterStateDriver(frame, 'visibility', hideString(frame.unit));
    end; -- for
  end;

  local function textColors(frame, request)
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

  local function allTextColors(request) for _, frame in ipairs(FRAMES()) do textColors(frame, request) end; end;

  local function refreshFrame(frame) 
    for _, fs in next, frame.content.fontStrings 
    do frame:Tag(fs, Config.get(fs.setting)); end;
    for _, tt in next, frame.content.tooltips    
    do frame:Tag(tt, Config.get(tt.setting));    end;
    frame:UpdateAllElements('now')
  end; 

  local function refreshAllFrames() 
    for _, frame in ipairs(FRAMES()) 
    do  refreshFrame(frame) 
    end; 
  end;

  RPTAGS.utils.frame.layout         = frameLayout;
  RPTAGS.utils.frame.refresh        = refreshFrame;
  RPTAGS.utils.frame.resize         = resizeFrame;
  RPTAGS.utils.frame.size           = frameDimensions;
  RPTAGS.utils.frame.tag            = setTag;
  RPTAGS.utils.frame.textcolor      = textColors;
  RPTAGS.utils.frame.statusTexture  = setStatusBarTexture;
  RPTAGS.utils.frame.statusAlign    = setStatusBarAlignment;

  -- allFrames functions
  RPTAGS.utils.frame.all.backdrop   = setAllBackground;
  RPTAGS.utils.frame.all.lock       = lockFrames;
  RPTAGS.utils.frame.all.move       = setAllMovable;
  RPTAGS.utils.frame.all.refresh    = refreshAllFrames;
  RPTAGS.utils.frame.all.resetloc   = resetAllLocations;
  RPTAGS.utils.frame.all.resize     = resizeAllFrames;
  RPTAGS.utils.frame.all.setbg      = setAllBackground;
  RPTAGS.utils.frame.all.tag        = tagAll;
  RPTAGS.utils.frame.all.visibility = setHide;
  RPTAGS.utils.frame.all.disable    = setHide;
  RPTAGS.utils.frame.all.textcolor  = allTextColors;
  RPTAGS.utils.frame.all.statusTexture = setAllStatusBarTextures;
  RPTAGS.utils.frame.all.statusAlign = setAllStatusBarAlignments;
  RPTAGS.utils.frame.all.scale       = setAllFrameScales;

  -- element functions (affect all frames)
  RPTAGS.utils.frame.element = RPTAGS.utils.rpuf.element or {};
  RPTAGS.utils.frame.element.height       = elementHeight;
  RPTAGS.utils.frame.element.left         = elementLeft;
  RPTAGS.utils.frame.element.resize       = resizePanel;
  RPTAGS.utils.frame.element.top          = elementTop;
  RPTAGS.utils.frame.element.topleft      = elementLeftTop;
  RPTAGS.utils.frame.element.width        = elementWidth;
  RPTAGS.utils.frame.element.align        = elementAlignH;

end);
