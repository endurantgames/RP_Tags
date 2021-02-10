-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 
--

local addOnName, addOn = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("UTILS_FRAMES",
function(self, event, ...)

  local CONST               = RPTAGS.CONST;
  local Utils               = RPTAGS.utils;
  local Config              = Utils.config;
  local PANEL_LIST          = CONST.FRAMES.PANELS;
  local PLAYER_FRAMENAME    = CONST.FRAMES.NAMES.PLAYER;
  local TARGET_FRAMENAME    = CONST.FRAMES.NAMES.PLAYER;
  local FOCUS_FRAMENAME     = CONST.FRAMES.NAMES.FOCUS;
  local MOUSEOVER_FRAMENAME = CONST.FRAMES.NAMES.MOUSEOVER;
  local Frames              = RPTAGS.cache.UnitFrames;

  -- frame layout functions ---------------------------------------------------------------------------------------------------------------------------------
  local function hgap(n)    return Config.get("GAPSIZE") * (n or 1);                 end ;
  local function vgap(n)    return Config.get("GAPSIZE") * (n or 1) * -1;            end ;
  local function fontSize() local _, size, _ = GameFontNormal:GetFont(); return size end ;

  local function getPanelHeight(panel, layout)
    local height;

    if     not panel                                          then height = 0
    elseif layout  == "HIDDEN" then height = 10
    elseif panel == 'NamePanel'                                    then height = fontSize() + 4;

    elseif panel == 'InfoPanel'                                    then height = fontSize() + 2;

    elseif panel == 'PortraitPanel'  and layout  == "PAPERDOLL"    then height = Config.get("PORTWIDTH") * 2;
    elseif panel == 'PortraitPanel'  and layout  == "THUMBNAIL"    then height = Config.get("PORTWIDTH");
    elseif panel == 'PortraitPanel'                                then height = Config.get("PORTWIDTH") * 1.5;

    elseif panel == 'DetailsPanel'                                 then height = Config.get("DETAILHEIGHT");

    elseif panel == 'StatusBarPanel'                                then height = Config.get("STATUSHEIGHT");

    elseif panel == 'Icon_1Panel'     and layout  == "THUMBNAIL"    then height = Config.get("ICONWIDTH");
    elseif panel == 'Icon_1Panel'     and layout  == "PAPERDOLL"    then height = Config.get("ICONWIDTH");
    elseif panel == 'Icon_1Panel'                                   then height = Config.get("ICONWIDTH");
    elseif panel == 'Icon_2Panel'     and layout  == "PAPERDOLL"    then height = Config.get("ICONWIDTH");
    elseif panel == 'Icon_2Panel'                                   then height = Config.get("ICONWIDTH");
    elseif panel == 'Icon_3Panel'     and layout  == "PAPERDOLL"    then height = Config.get("ICONWIDTH");
    elseif panel == 'Icon_3Panel'                                   then height = Config.get("ICONWIDTH");
    elseif panel == 'Icon_4Panel'     and layout  == "PAPERDOLL"    then height = Config.get("ICONWIDTH");
    elseif panel == 'Icon_4Panel'                                   then height = Config.get("ICONWIDTH");
    elseif panel == 'Icon_5Panel'     and layout  == "PAPERDOLL"    then height = Config.get("ICONWIDTH");
    elseif panel == 'Icon_5Panel'                                   then height = Config.get("ICONWIDTH");
    elseif panel == 'Icon_6Panel'     and layout  == "PAPERDOLL"    then height = Config.get("ICONWIDTH");
    elseif panel == 'Icon_6Panel'                                   then height = Config.get("ICONWIDTH");
                                                                else height = 0;
    end;
    return height;
  end;

  local function getPanelWidth(panel, layout)
    local width;

    if not panel then width = 0
    elseif layout == "HIDDEN" then width = 10
    elseif panel == 'NamePanel'       and layout  == "THUMBNAIL"  then width = math.max(
                                                                                  -- formula #1
                                                                                  Config.get("PORTWIDTH") * 2/3 - hgap(2/3),
                                                                                  -- formula #2
                                                                                  Config.get("ICONWIDTH") - hgap(2/3)
                                                                                  );
    -- elseif panel == 'NamePanel'       and layout  == 'PAPERDOLL'  then width = Config.get("ICONWIDTH") + hgap(1) + Config.get("PORTWIDTH") + hgap(1) + Config.get("ICONWIDTH");
    elseif panel == 'NamePanel'          and layout == "PAPERDOLL" then width = Config.get("PORTWIDTH") * 1.5 - hgap(2) ;
    elseif panel == 'NamePanel'                                   then width = Config.get("INFOWIDTH");
    
    -- elseif panel == 'InfoPanel'       and layout  == 'PAPERDOLL'  then width = Config.get("ICONWIDTH") + hgap(1) + Config.get("PORTWIDTH") + hgap(1) + Config.get("ICONWIDTH");
    elseif panel == 'InfoPanel'          and layout == "PAPERDOLL" then width = Config.get("PORTWIDTH") * 1.5 - hgap(2);
    elseif panel == 'InfoPanel'                                   then width = Config.get("INFOWIDTH");

    elseif panel == 'PortraitPanel'   and layout  == "PAPERDOLL"  then width = Config.get("PORTWIDTH") * 1.5;
    elseif panel == 'PortraitPanel'   and layout  == "THUMBNAIL"  then width = Config.get("PORTWIDTH") * 2/3;
    elseif panel == 'PortraitPanel'                               then width = Config.get("PORTWIDTH");

    elseif panel == 'DetailsPanel'                                then width = Config.get("INFOWIDTH");
    elseif panel == 'StatusBarPanel'  and layout  == "FULL"       then width = Config.get("PORTWIDTH")
                                                                            + hgap(1) + Config.get("INFOWIDTH")
                                                                            + hgap(1) + Config.get("ICONWIDTH")
                                                                            + hgap(2); -- internal padding
    elseif panel == 'StatusBarPanel'  and layout  == "ABRIDGED"   then width = math.max(
                                                                            -- formula #1
                                                                            Config.get("ICONWIDTH")
                                                                            + hgap(0.75) + Config.get("INFOWIDTH")
                                                                            + hgap(2.75), -- internal padding
                                                                            -- formula #2
                                                                            Config.get("ICONWIDTH")
                                                                            + hgap(0.75) + Config.get("ICONWIDTH")
                                                                            + hgap(0.75) + Config.get("ICONWIDTH")
                                                                            + hgap(0.75) + Config.get("ICONWIDTH")
                                                                            + hgap(0.75) + Config.get("ICONWIDTH")
                                                                            + hgap(3) -- internal padding
                                                                           )
    elseif panel == 'StatusBarPanel'  and layout  == "COMPACT"    then width = 0;

    elseif panel == 'Icon_1Panel'      and layout  == "THUMBNAIL"  then width = Config.get("ICONWIDTH");
    elseif panel == 'Icon_1Panel'      and layout  == "PAPERDOLL"  then width = Config.get("ICONWIDTH");
    elseif panel == 'Icon_2Panel'      and layout  == "PAPERDOLL"  then width = Config.get("ICONWIDTH");
    elseif panel == 'Icon_3Panel'      and layout  == "PAPERDOLL"  then width = Config.get("ICONWIDTH");
    elseif panel == 'Icon_4Panel'      and layout  == "PAPERDOLL"  then width = Config.get("ICONWIDTH");
    elseif panel == 'Icon_5Panel'      and layout  == "PAPERDOLL"  then width = Config.get("ICONWIDTH");
    elseif panel == 'Icon_6Panel'      and layout  == "PAPERDOLL"  then width = Config.get("ICONWIDTH");
    elseif panel == 'Icon_1Panel'                                  then width = Config.get("ICONWIDTH");
    elseif panel == 'Icon_2Panel'                                  then width = Config.get("ICONWIDTH");
    elseif panel == 'Icon_3Panel'                                  then width = Config.get("ICONWIDTH");
    elseif panel == 'Icon_4Panel'                                  then width = Config.get("ICONWIDTH");
    elseif panel == 'Icon_5Panel'                                  then width = Config.get("ICONWIDTH");
    elseif panel == 'Icon_6Panel'                                  then width = Config.get("ICONWIDTH");
    
                                                               else width = 0;
    end;

    return width;
    end;

  local function getFrameSize(layout)
    local border, width, height;

    if layout == "HIDDEN" then return 0, 0 end;

    if   Config.get("RPUF_BACKDROP") == "BLIZZTOOLTIP"
    then border = 5
    else border = 0 end;

    if     layout == "FULL" -- -----------------------------------------------------------------------------------------------------------
    then   width  = 
             border
             + hgap(1) + getPanelWidth('Icon_1Panel', layout)
             + hgap(1) + getPanelWidth('InfoPanel', layout)
             + hgap(1) + getPanelWidth('PortraitPanel', layout)
             + hgap(1) + border;

           height = math.max(
             -- formula #1
             border
               + hgap(1) + getPanelHeight('Icon_1Panel', layout)
               + hgap(1) + getPanelHeight('Icon_2Panel', layout)
               + hgap(1) + getPanelHeight('Icon_3Panel', layout)
               + hgap(1) + getPanelHeight('Icon_4Panel', layout)
               + hgap(1) + getPanelHeight('Icon_5Panel', layout)
               + hgap(1) + getPanelHeight('Icon_6Panel', layout)
               + hgap(1) + getPanelHeight('StatusBarPanel', "FULL")
               + border, 
            -- formula #2
             border
               + hgap(1) + getPanelHeight('NamePanel', layout)
               + hgap(1) + getPanelHeight('DetailsPanel', layout)
               + getPanelHeight('StatusBarPanel', "FULL") 
               + hgap(1) + getPanelHeight('InfoPanel', layout)
               + hgap(1) + border,
             -- formula #3
             border
               + hgap(1) + getPanelHeight('PortraitPanel', layout)
               + getPanelHeight('StatusBarPanel', "FULL")
               + border -- ditto
             );

    elseif layout == "THUMBNAIL" -- -------------------------------------------------------------------------------------------------------------
    then   width  =  math.max(
                     -- formula #1
                     border + getPanelWidth('PortraitPanel', layout)  + border,
                     -- formula #2
                     border + getPanelWidth('Icon_1Panel', layout) + border)
           height =  math.max( -- formula #1
                     border + getPanelHeight('Icon_1Panel', layout) + getPanelHeight('NamePanel', layout) + border,
                     -- Formula #2
                     border + getPanelHeight('PortraitPanel', layout) + border);

    elseif layout == "PAPERDOLL" -- -------------------------------------------------------------------------------------------------------------
    then   width  =  border
                     -- + hgap(1) + getPanelWidth('Icon_1Panel', layout)
                     + getPanelWidth('PortraitPanel', layout)
                     -- + hgap(1) + getPanelWidth('Icon_4Panel', layout)
                     + border;
           height =  math.max(
                     -- formula #1
                     border
                     + hgap(1) + getPanelHeight('NamePanel', layout)
                     + hgap(1) + getPanelHeight('InfoPanel', layout)
                     + hgap(1) + getPanelHeight('PortraitPanel', layout)
                     + border, -- no gap needed here
                     -- formula #2
                     border
                     + hgap(1) + getPanelHeight('NamePanel', layout)
                     + hgap(1) + getPanelHeight('InfoPanel', layout)
                     + hgap(2) + getPanelHeight('Icon_1Panel', layout)
                     + hgap(2) + getPanelHeight('Icon_2Panel', layout)
                     + hgap(2) + getPanelHeight('Icon_3Panel', layout)
                     + hgap(1) + border
                    );

    elseif layout == "ABRIDGED" -- -----------------------------------------------------------------------------------------------------------
    then   width = math.max(
                     -- formula #1
                     border
                     + hgap(1) + getPanelWidth('Icon_1Panel', layout)
                     + hgap(1) + getPanelWidth('NamePanel', layout)
                     + hgap(1) + border,
                     -- formula #2
                     border
                     + hgap(1) + getPanelWidth('Icon_1Panel', layout)
                     + hgap(1) + getPanelWidth('InfoPanel', layout)
                     + hgap(1) + border,
                     -- formula #3
                     border 
                     + getPanelWidth('StatusBarPanel', "ABRIDGED")
                     + border,
                     -- formula #4
                     border
                     + hgap(1) + getPanelWidth('Icon_2Panel', layout)
                     + hgap(1) + getPanelWidth('Icon_3Panel', layout)
                     + hgap(1) + getPanelWidth('Icon_4Panel', layout)
                     + hgap(1) + getPanelWidth('Icon_5Panel', layout)
                     + hgap(1) + getPanelWidth('Icon_6Panel', layout)
                     + hgap(1) + border
                     );
            height = math.max(
                       -- formula #1
                       border
                       + hgap(1) + getPanelHeight('Icon_1Panel', layout)
                       + hgap(1) + getPanelHeight('StatusBarPanel', "ABRIDGED") 
                       + hgap(1) + getPanelHeight('Icon_2Panel', layout)
                       + hgap(1) + border,
                       -- formula #2
                       border
                       + hgap(1) + getPanelHeight('NamePanel' , layout)
                       + hgap(1) + getPanelHeight('InfoPanel', layout)
                       + hgap(1) + getPanelHeight('StatusBarPanel', "ABRIDGED")
                       + hgap(1) + getPanelHeight('Icon_2Panel', layout)
                       + hgap(1) + border
                       ); --

    elseif layout == "COMPACT" -- -----------------------------------------------------------------------------------------------------------
    then   width = border
                   + hgap(0.5) + getPanelWidth('Icon_1Panel', layout)
                   + hgap(0.5) + getPanelWidth('NamePanel', layout)
                   + hgap(0.5) + border;
           height = math.max(
                      -- formula #1
                      border
                      + hgap(0.5) + getPanelHeight('NamePanel', layout)
                      + hgap(0.5) + getPanelHeight('InfoPanel', layout)
                      + hgap(0.5) + border,
                      -- formula #2
                      border
                      + hgap(0.5) + getPanelHeight('Icon_1Panel', layout)
                      + hgap(0.5) + border
                    );

    elseif layout == "HIDDEN" -- ----------------------------------------------------------------------------------------------------------
    then   width, height = 10, 10;
    end; -- if layout ---------------------------------------------------------------------------------------------------------------------

    return width, height;
  end;


  local function setFrameScale(frame)
    local  frameName = frame:GetName();
    _G[frame]:SetScale(
         (frameName == PLAYER_FRAMENAME) and Config.get("PLAYERFRAME_SCALE")
      or (frameName == TARGET_FRAMENAME) and Config.get("TARGETFRAME_SCALE")
      or (frameName == FOCUS_FRAMENAME)  and Config.get("FOCUSFRAME_SCALE")
      or 1
      );
  end;

  local function setAllFrameScales() 
    for frameName, frame in pairs(Frames)
    do  setFrameScale(frame)
    end;
  end;

  local function setPanelSize(frame, panel, layout)
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

  local function setFrameSize(frame)
    local layout = frameLayout(frame);
    for _, panel in ipairs(PANEL_LIST) do resizePanel(frame, panel, layout); end;
    frame.StatusBarPanel.text:SetWidth(elementWidth("StatusBarPanel", layout) - hgap(2));
    frame.StatusBarPanel.text:SetPoint("TOPLEFT", frame.StatusBarPanel, "TOPLEFT", hgap(1), vgap(0.5));
    frame.StatusBarPanel.text:SetHeight(elementHeight("StatusBarPanel", layout) - hgap(1)); 
    local w, h = frameDimensions(layout);
    frame:SetWidth(w);
    frame:SetHeight(h);
  end; -- function

  local function setAllFrameSizes()
    for frameName, frame in pairs(Frames)
    do setFrameSize(frame) 
    end; 
  end;

  RPTAGS.utils.frames.all.size.scale.set    = setAllFrameScales;
  RPTAGS.utils.frames.all.size.set          = setAllFrameSizes;
  RPTAGS.utils.frames.panels.size.getHeight = getPanelHeight;
  RPTAGS.utils.frames.panels.size.getWidth  = getPanelWidth;
  RPTAGS.utils.frames.panels.size.set       = setPanelSize;
  RPTAGS.utils.frames.size.get              = getFrameSize;
  RPTAGS.utils.frames.size.scale.set        = setFrameScale;
  RPTAGS.utils.frames.size.set              = setFrameSize;
end);
