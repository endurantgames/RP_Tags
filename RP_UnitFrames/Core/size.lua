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

Module:WaitUntil("MODULE_E",
function(self, event, ...)

  local CONST               = RPTAGS.CONST;
  local Utils               = RPTAGS.utils;
  local Config              = Utils.config;
  local PANEL_LIST          = CONST.FRAMES.PANELS;
  local PLAYER_FRAMENAME    = CONST.FRAMES.NAMES.PLAYER;
  local TARGET_FRAMENAME    = CONST.FRAMES.NAMES.PLAYER;
  local FOCUS_FRAMENAME     = CONST.FRAMES.NAMES.FOCUS;

  -- frame layout functions ---------------------------------------------------------------------------------------------------------------------------------
  local function hgap(n)    return Config.get("GAPSIZE") * (n or 1);                 end ;
  local function vgap(n)    return Config.get("GAPSIZE") * (n or 1) * -1;            end ;
  local function fontSize() local _, size, _ = GameFontNormal:GetFont(); return size end ;

  local function getPanelHeight(panel, layout)
    local height;

    if     not panel                                          then height = 0
    elseif layout  == "HIDDEN" then height = 10
    elseif panel == 'name'                                    then height = fontSize() + 4;

    elseif panel == 'info'                                    then height = fontSize() + 2;

    elseif panel == 'portrait'  and layout  == "PAPERDOLL"    then height = Config.get("PORTWIDTH") * 2;
    elseif panel == 'portrait'  and layout  == "THUMBNAIL"    then height = Config.get("PORTWIDTH");
    elseif panel == 'portrait'                                then height = Config.get("PORTWIDTH") * 1.5;

    elseif panel == 'details'                                 then height = Config.get("DETAILHEIGHT");

    elseif panel == 'statusBar'                                then height = Config.get("STATUSHEIGHT");

    elseif panel == 'icon1'     and layout  == "THUMBNAIL"    then height = Config.get("ICONWIDTH");
    elseif panel == 'icon1'     and layout  == "PAPERDOLL"    then height = Config.get("ICONWIDTH");
    elseif panel == 'icon1'                                   then height = Config.get("ICONWIDTH");
    elseif panel == 'icon2'     and layout  == "PAPERDOLL"    then height = Config.get("ICONWIDTH");
    elseif panel == 'icon2'                                   then height = Config.get("ICONWIDTH");
    elseif panel == 'icon3'     and layout  == "PAPERDOLL"    then height = Config.get("ICONWIDTH");
    elseif panel == 'icon3'                                   then height = Config.get("ICONWIDTH");
    elseif panel == 'icon4'     and layout  == "PAPERDOLL"    then height = Config.get("ICONWIDTH");
    elseif panel == 'icon4'                                   then height = Config.get("ICONWIDTH");
    elseif panel == 'icon5'     and layout  == "PAPERDOLL"    then height = Config.get("ICONWIDTH");
    elseif panel == 'icon5'                                   then height = Config.get("ICONWIDTH");
    elseif panel == 'icon6'     and layout  == "PAPERDOLL"    then height = Config.get("ICONWIDTH");
    elseif panel == 'icon6'                                   then height = Config.get("ICONWIDTH");
                                                                else height = 0;
    end;
    return height;
  end;

  local function getPanelWidth(panel, layout)
    local width;

    if not panel then width = 0
    elseif layout == "HIDDEN" then width = 10
    elseif panel == 'name'       and layout  == "THUMBNAIL"  then width = math.max(
                                                                                  -- formula #1
                                                                                  Config.get("PORTWIDTH") * 2/3 - hgap(2/3),
                                                                                  -- formula #2
                                                                                  Config.get("ICONWIDTH") - hgap(2/3)
                                                                                  );
    -- elseif panel == 'name'       and layout  == 'PAPERDOLL'  then width = Config.get("ICONWIDTH") + hgap(1) + Config.get("PORTWIDTH") + hgap(1) + Config.get("ICONWIDTH");
    elseif panel == 'name'          and layout == "PAPERDOLL" then width = Config.get("PORTWIDTH") * 1.5 - hgap(2) ;
    elseif panel == 'name'                                   then width = Config.get("INFOWIDTH");
    
    -- elseif panel == 'info'       and layout  == 'PAPERDOLL'  then width = Config.get("ICONWIDTH") + hgap(1) + Config.get("PORTWIDTH") + hgap(1) + Config.get("ICONWIDTH");
    elseif panel == 'info'          and layout == "PAPERDOLL" then width = Config.get("PORTWIDTH") * 1.5 - hgap(2);
    elseif panel == 'info'                                   then width = Config.get("INFOWIDTH");

    elseif panel == 'portrait'   and layout  == "PAPERDOLL"  then width = Config.get("PORTWIDTH") * 1.5;
    elseif panel == 'portrait'   and layout  == "THUMBNAIL"  then width = Config.get("PORTWIDTH") * 2/3;
    elseif panel == 'portrait'                               then width = Config.get("PORTWIDTH");

    elseif panel == 'details'                                then width = Config.get("INFOWIDTH");
    elseif panel == 'statusBar'  and layout  == "FULL"       then width = Config.get("PORTWIDTH")
                                                                            + hgap(1) + Config.get("INFOWIDTH")
                                                                            + hgap(1) + Config.get("ICONWIDTH")
                                                                            + hgap(2); -- internal padding
    elseif panel == 'statusBar'  and layout  == "ABRIDGED"   then width = math.max(
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
    elseif panel == 'statusBar'  and layout  == "COMPACT"    then width = 0;

    elseif panel == 'icon1'      and layout  == "THUMBNAIL"  then width = Config.get("ICONWIDTH");
    elseif panel == 'icon1'      and layout  == "PAPERDOLL"  then width = Config.get("ICONWIDTH");
    elseif panel == 'icon2'      and layout  == "PAPERDOLL"  then width = Config.get("ICONWIDTH");
    elseif panel == 'icon3'      and layout  == "PAPERDOLL"  then width = Config.get("ICONWIDTH");
    elseif panel == 'icon4'      and layout  == "PAPERDOLL"  then width = Config.get("ICONWIDTH");
    elseif panel == 'icon5'      and layout  == "PAPERDOLL"  then width = Config.get("ICONWIDTH");
    elseif panel == 'icon6'      and layout  == "PAPERDOLL"  then width = Config.get("ICONWIDTH");
    elseif panel == 'icon1'                                  then width = Config.get("ICONWIDTH");
    elseif panel == 'icon2'                                  then width = Config.get("ICONWIDTH");
    elseif panel == 'icon3'                                  then width = Config.get("ICONWIDTH");
    elseif panel == 'icon4'                                  then width = Config.get("ICONWIDTH");
    elseif panel == 'icon5'                                  then width = Config.get("ICONWIDTH");
    elseif panel == 'icon6'                                  then width = Config.get("ICONWIDTH");
    
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
             + hgap(1) + getPanelWidth('icon1', layout)
             + hgap(1) + getPanelWidth('info', layout)
             + hgap(1) + getPanelWidth('portrait', layout)
             + hgap(1) + border;

           height = math.max(
             -- formula #1
             border
               + hgap(1) + getPanelHeight('icon1', layout)
               + hgap(1) + getPanelHeight('icon2', layout)
               + hgap(1) + getPanelHeight('icon3', layout)
               + hgap(1) + getPanelHeight('icon4', layout)
               + hgap(1) + getPanelHeight('icon5', layout)
               + hgap(1) + getPanelHeight('icon6', layout)
               + hgap(1) + getPanelHeight('statusBar', "FULL")
               + border, 
            -- formula #2
             border
               + hgap(1) + getPanelHeight('name', layout)
               + hgap(1) + getPanelHeight('details', layout)
               + getPanelHeight('statusBar', "FULL") 
               + hgap(1) + getPanelHeight('info', layout)
               + hgap(1) + border,
             -- formula #3
             border
               + hgap(1) + getPanelHeight('portrait', layout)
               + getPanelHeight('statusBar', "FULL")
               + border -- ditto
             );

    elseif layout == "THUMBNAIL" -- -------------------------------------------------------------------------------------------------------------
    then   width  =  math.max(
                     -- formula #1
                     border + getPanelWidth('portrait', layout)  + border,
                     -- formula #2
                     border + getPanelWidth('icon1', layout) + border)
           height =  math.max( -- formula #1
                     border + getPanelHeight('icon1', layout) + getPanelHeight('name', layout) + border,
                     -- Formula #2
                     border + getPanelHeight('portrait', layout) + border);

    elseif layout == "PAPERDOLL" -- -------------------------------------------------------------------------------------------------------------
    then   width  =  border
                     -- + hgap(1) + getPanelWidth('icon1', layout)
                     + getPanelWidth('portrait', layout)
                     -- + hgap(1) + getPanelWidth('icon4', layout)
                     + border;
           height =  math.max(
                     -- formula #1
                     border
                     + hgap(1) + getPanelHeight('name', layout)
                     + hgap(1) + getPanelHeight('info', layout)
                     + hgap(1) + getPanelHeight('portrait', layout)
                     + border, -- no gap needed here
                     -- formula #2
                     border
                     + hgap(1) + getPanelHeight('name', layout)
                     + hgap(1) + getPanelHeight('info', layout)
                     + hgap(2) + getPanelHeight('icon1', layout)
                     + hgap(2) + getPanelHeight('icon2', layout)
                     + hgap(2) + getPanelHeight('icon3', layout)
                     + hgap(1) + border
                    );

    elseif layout == "ABRIDGED" -- -----------------------------------------------------------------------------------------------------------
    then   width = math.max(
                     -- formula #1
                     border
                     + hgap(1) + getPanelWidth('icon1', layout)
                     + hgap(1) + getPanelWidth('name', layout)
                     + hgap(1) + border,
                     -- formula #2
                     border
                     + hgap(1) + getPanelWidth('icon1', layout)
                     + hgap(1) + getPanelWidth('info', layout)
                     + hgap(1) + border,
                     -- formula #3
                     border 
                     + getPanelWidth('statusBar', "ABRIDGED")
                     + border,
                     -- formula #4
                     border
                     + hgap(1) + getPanelWidth('icon2', layout)
                     + hgap(1) + getPanelWidth('icon3', layout)
                     + hgap(1) + getPanelWidth('icon4', layout)
                     + hgap(1) + getPanelWidth('icon5', layout)
                     + hgap(1) + getPanelWidth('icon6', layout)
                     + hgap(1) + border
                     );
            height = math.max(
                       -- formula #1
                       border
                       + hgap(1) + getPanelHeight('icon1', layout)
                       + hgap(1) + getPanelHeight('statusBar', "ABRIDGED") 
                       + hgap(1) + getPanelHeight('icon2', layout)
                       + hgap(1) + border,
                       -- formula #2
                       border
                       + hgap(1) + getPanelHeight('name' , layout)
                       + hgap(1) + getPanelHeight('info', layout)
                       + hgap(1) + getPanelHeight('statusBar', "ABRIDGED")
                       + hgap(1) + getPanelHeight('icon2', layout)
                       + hgap(1) + border
                       ); --

    elseif layout == "COMPACT" -- -----------------------------------------------------------------------------------------------------------
    then   width = border
                   + hgap(0.5) + getPanelWidth('icon1', layout)
                   + hgap(0.5) + getPanelWidth('name', layout)
                   + hgap(0.5) + border;
           height = math.max(
                      -- formula #1
                      border
                      + hgap(0.5) + getPanelHeight('name', layout)
                      + hgap(0.5) + getPanelHeight('info', layout)
                      + hgap(0.5) + border,
                      -- formula #2
                      border
                      + hgap(0.5) + getPanelHeight('icon1', layout)
                      + hgap(0.5) + border
                    );

    elseif layout == "HIDDEN" -- ----------------------------------------------------------------------------------------------------------
    then   width, height = 10, 10;
    end; -- if layout ---------------------------------------------------------------------------------------------------------------------

    return width, height;
  end;

  local function setAllFrameScales() 
    for frameName, frame in pairs(RPTAGS.cache.UnitFrames)
    do  frame:SetScale();
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
    frame.statusBar.text:SetWidth(elementWidth("statusBar", layout) - hgap(2));
    frame.statusBar.text:SetPoint("TOPLEFT", frame.statusBar, "TOPLEFT", hgap(1), vgap(0.5));
    frame.statusBar.text:SetHeight(elementHeight("statusBar", layout) - hgap(1)); 
    local w, h = frameDimensions(layout);
    frame:SetWidth(w);
    frame:SetHeight(h);
  end; -- function

  local function scaleFrame(frame)
    print(frame, type(frame));
    if   type(frame) == "string"
    then frame = RPTAGS.cache.UnitFrames[frame:lower()];
    end;
    print(Config.get(frame:GetUnit():upper() .. "FRAME_SCALE"));
    if   frame 
    then frame:SetScale(Config.get(frame:GetUnit():upper() .. "FRAME_SCALE"));
    end
  end;

  local function scaleAllFrames()
    for frameName, frame in pairs(RPTAGS.cache.UnitFrames)
    do  frame:SetScale(Config.get(frameName:upper() .. "FRAME_SCALE"))
    end;
  end;

  RPTAGS.utils.frames.all.size.scale.set    = setAllFrameScales;
  RPTAGS.utils.frames.all.size.set          = setAllFrameSizes;
  RPTAGS.utils.frames.panels.size.getHeight = getPanelHeight;
  RPTAGS.utils.frames.panels.size.getWidth  = getPanelWidth;
  RPTAGS.utils.frames.panels.size.set       = setPanelSize;
  RPTAGS.utils.frames.size.get              = getFrameSize;
  RPTAGS.utils.frames.scaleAll              = scaleAllFrames;
  RPTAGS.utils.frames.scale                 = scaleFrame;
end);
