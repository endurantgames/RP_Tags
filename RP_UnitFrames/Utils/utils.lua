-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
--
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 

local addOnName, addOn = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);
local oUF    = RPTAGS.oUF;

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

  -- frame layout functions ---------------------------------------------------------------------------------------------------------------------------------
  local function GAP(n)  if not n then n = 1 end; return Config.get("GAPSIZE") * n;      end;
  local function NGAP(n) if not n then n = 1 end; return Config.get("GAPSIZE") * n * -1; end;

  local function frameLayout(frame)
    local  frameName = frame:GetName();
    if     frameName == "RPUF_Player"       then return Config.get("PLAYERLAYOUT")
    elseif frameName == "RPUF_Target"       then return Config.get("TARGETLAYOUT")
    elseif frameName == "RPUF_Focus"        then return Config.get("FOCUSLAYOUT")
    elseif frameName == "RPUF_Mouseover"    then return Config.get("MOUSEOVERLAYOUT")
--    elseif frameName == "RPUF_TargetTarget" then return Config.get("TARGETTARGETLAYOUT")
    elseif frameName:match("RPUF_Party")    then return Config.get("PARTYLAYOUT")
    elseif frameName:match("RPUF_Raid")     then return Config.get("RAIDLAYOUT")
    else   return "COMPACT"
    end;
  end; -- function

  local function elementHeight(element, layout)
    local height;

    if     not element                                          then height = 0
    elseif layout  == "HIDDEN" then height = 10
    elseif element == 'NamePanel'                                    then height = FONTSIZE + 4;

    elseif element == 'InfoPanel'                                    then height = FONTSIZE + 2;

    elseif element == 'PortraitPanel'  and layout  == "PAPERDOLL"    then height = Config.get("PORTWIDTH") * 2;
    elseif element == 'PortraitPanel'  and layout  == "THUMBNAIL"    then height = Config.get("PORTWIDTH");
    elseif element == 'PortraitPanel'                                then height = Config.get("PORTWIDTH") * 1.5;

    elseif element == 'DetailsPanel'                                 then height = Config.get("DETAILHEIGHT");

    elseif element == 'StatusBarPanel'                                then height = Config.get("STATUSHEIGHT");

    elseif element == 'Icon_1Panel'     and layout  == "THUMBNAIL"    then height = Config.get("ICONWIDTH");
    elseif element == 'Icon_1Panel'     and layout  == "PAPERDOLL"    then height = Config.get("ICONWIDTH");
    elseif element == 'Icon_1Panel'                                   then height = Config.get("ICONWIDTH");
    elseif element == 'Icon_2Panel'     and layout  == "PAPERDOLL"    then height = Config.get("ICONWIDTH");
    elseif element == 'Icon_2Panel'                                   then height = Config.get("ICONWIDTH");
    elseif element == 'Icon_3Panel'     and layout  == "PAPERDOLL"    then height = Config.get("ICONWIDTH");
    elseif element == 'Icon_3Panel'                                   then height = Config.get("ICONWIDTH");
    elseif element == 'Icon_4Panel'     and layout  == "PAPERDOLL"    then height = Config.get("ICONWIDTH");
    elseif element == 'Icon_4Panel'                                   then height = Config.get("ICONWIDTH");
    elseif element == 'Icon_5Panel'     and layout  == "PAPERDOLL"    then height = Config.get("ICONWIDTH");
    elseif element == 'Icon_5Panel'                                   then height = Config.get("ICONWIDTH");
    elseif element == 'Icon_6Panel'     and layout  == "PAPERDOLL"    then height = Config.get("ICONWIDTH");
    elseif element == 'Icon_6Panel'                                   then height = Config.get("ICONWIDTH");
                                                                else height = 0;
    end;
    return height;
  end;

  local function elementWidth(element, layout)
    local width;

    if not element then width = 0
    elseif layout == "HIDDEN" then width = 10
    elseif element == 'NamePanel'       and layout  == "THUMBNAIL"  then width = math.max(
                                                                                  -- formula #1
                                                                                  Config.get("PORTWIDTH") * 2/3 - GAP(2/3),
                                                                                  -- formula #2
                                                                                  Config.get("ICONWIDTH") - GAP(2/3)
                                                                                  );
    -- elseif element == 'NamePanel'       and layout  == 'PAPERDOLL'  then width = Config.get("ICONWIDTH") + GAP(1) + Config.get("PORTWIDTH") + GAP(1) + Config.get("ICONWIDTH");
    elseif element == 'NamePanel'          and layout == "PAPERDOLL" then width = Config.get("PORTWIDTH") * 1.5 - GAP(2) ;
    elseif element == 'NamePanel'                                   then width = Config.get("INFOWIDTH");
    
    -- elseif element == 'InfoPanel'       and layout  == 'PAPERDOLL'  then width = Config.get("ICONWIDTH") + GAP(1) + Config.get("PORTWIDTH") + GAP(1) + Config.get("ICONWIDTH");
    elseif element == 'InfoPanel'          and layout == "PAPERDOLL" then width = Config.get("PORTWIDTH") * 1.5 - GAP(2);
    elseif element == 'InfoPanel'                                   then width = Config.get("INFOWIDTH");

    elseif element == 'PortraitPanel'   and layout  == "PAPERDOLL"  then width = Config.get("PORTWIDTH") * 1.5;
    elseif element == 'PortraitPanel'   and layout  == "THUMBNAIL"  then width = Config.get("PORTWIDTH") * 2/3;
    elseif element == 'PortraitPanel'                               then width = Config.get("PORTWIDTH");

    elseif element == 'DetailsPanel'                                then width = Config.get("INFOWIDTH");
    elseif element == 'StatusBarPanel'  and layout  == "FULL"       then width = Config.get("PORTWIDTH")
                                                                            + GAP(1) + Config.get("INFOWIDTH")
                                                                            + GAP(1) + Config.get("ICONWIDTH")
                                                                            + GAP(2); -- internal padding
    elseif element == 'StatusBarPanel'  and layout  == "ABRIDGED"   then width = math.max(
                                                                            -- formula #1
                                                                            Config.get("ICONWIDTH")
                                                                            + GAP(0.75) + Config.get("INFOWIDTH")
                                                                            + GAP(2.75), -- internal padding
                                                                            -- formula #2
                                                                            Config.get("ICONWIDTH")
                                                                            + GAP(0.75) + Config.get("ICONWIDTH")
                                                                            + GAP(0.75) + Config.get("ICONWIDTH")
                                                                            + GAP(0.75) + Config.get("ICONWIDTH")
                                                                            + GAP(0.75) + Config.get("ICONWIDTH")
                                                                            + GAP(3) -- internal padding
                                                                           )
    elseif element == 'StatusBarPanel'  and layout  == "COMPACT"    then width = 0;

    elseif element == 'Icon_1Panel'      and layout  == "THUMBNAIL"  then width = Config.get("ICONWIDTH");
    elseif element == 'Icon_1Panel'      and layout  == "PAPERDOLL"  then width = Config.get("ICONWIDTH");
    elseif element == 'Icon_2Panel'      and layout  == "PAPERDOLL"  then width = Config.get("ICONWIDTH");
    elseif element == 'Icon_3Panel'      and layout  == "PAPERDOLL"  then width = Config.get("ICONWIDTH");
    elseif element == 'Icon_4Panel'      and layout  == "PAPERDOLL"  then width = Config.get("ICONWIDTH");
    elseif element == 'Icon_5Panel'      and layout  == "PAPERDOLL"  then width = Config.get("ICONWIDTH");
    elseif element == 'Icon_6Panel'      and layout  == "PAPERDOLL"  then width = Config.get("ICONWIDTH");
    elseif element == 'Icon_1Panel'                                  then width = Config.get("ICONWIDTH");
    elseif element == 'Icon_2Panel'                                  then width = Config.get("ICONWIDTH");
    elseif element == 'Icon_3Panel'                                  then width = Config.get("ICONWIDTH");
    elseif element == 'Icon_4Panel'                                  then width = Config.get("ICONWIDTH");
    elseif element == 'Icon_5Panel'                                  then width = Config.get("ICONWIDTH");
    elseif element == 'Icon_6Panel'                                  then width = Config.get("ICONWIDTH");
    
                                                               else width = 0;
    end;

    return width;
    end;

  local function frameDimensions(layout)
    local border, width, height;

    if layout == "HIDDEN" then return 0, 0 end;

    if   Config.get("RPUF_BACKDROP") == "BLIZZTOOLTIP"
    then border = 5
    else border = 0 end;

    if     layout == "FULL" -- -----------------------------------------------------------------------------------------------------------
    then   width  = border
                    + GAP(1) + elementWidth('Icon_1Panel', layout)
                    + GAP(1) + elementWidth('InfoPanel', layout)
                    + GAP(1) + elementWidth('PortraitPanel', layout)
                    + GAP(1) + border;

           height = math.max(
                       -- formula #1
                       border
                       + GAP(1) + elementHeight('Icon_1Panel', layout)
                       + GAP(1) + elementHeight('Icon_2Panel', layout)
                       + GAP(1) + elementHeight('Icon_3Panel', layout)
                       + GAP(1) + elementHeight('Icon_4Panel', layout)
                       + GAP(1) + elementHeight('Icon_5Panel', layout)
                       + GAP(1) + elementHeight('Icon_6Panel', layout)
                       + GAP(1) + elementHeight('StatusBarPanel', "FULL")
                       + border, 
                       -- formula #2
                       border
                       + GAP(1) + elementHeight('NamePanel', layout)
                       + GAP(1) + elementHeight('DetailsPanel', layout)
                       + elementHeight('StatusBarPanel', "FULL") 
                       + GAP(1) + elementHeight('InfoPanel', layout)
                       + GAP(1) + border,
                       -- formula #3
                       border
                       + GAP(1) + elementHeight('PortraitPanel', layout)
                       + elementHeight('StatusBarPanel', "FULL")
                       + border -- ditto
                       );

    elseif layout == "THUMBNAIL" -- -------------------------------------------------------------------------------------------------------------
    then   width  =  math.max(
                     -- formula #1
                     border + elementWidth('PortraitPanel', layout)  + border,
                     -- formula #2
                     border + elementWidth('Icon_1Panel', layout) + border)
           height =  math.max( -- formula #1
                     border + elementHeight('Icon_1Panel', layout) + elementHeight('NamePanel', layout) + border,
                     -- Formula #2
                     border + elementHeight('PortraitPanel', layout) + border);

    elseif layout == "PAPERDOLL" -- -------------------------------------------------------------------------------------------------------------
    then   width  =  border
                     -- + GAP(1) + elementWidth('Icon_1Panel', layout)
                     + elementWidth('PortraitPanel', layout)
                     -- + GAP(1) + elementWidth('Icon_4Panel', layout)
                     + border;
           height =  math.max(
                     -- formula #1
                     border
                     + GAP(1) + elementHeight('NamePanel', layout)
                     + GAP(1) + elementHeight('InfoPanel', layout)
                     + GAP(1) + elementHeight('PortraitPanel', layout)
                     + border, -- no gap needed here
                     -- formula #2
                     border
                     + GAP(1) + elementHeight('NamePanel', layout)
                     + GAP(1) + elementHeight('InfoPanel', layout)
                     + GAP(2) + elementHeight('Icon_1Panel', layout)
                     + GAP(2) + elementHeight('Icon_2Panel', layout)
                     + GAP(2) + elementHeight('Icon_3Panel', layout)
                     + GAP(1) + border
                    );

    elseif layout == "ABRIDGED" -- -----------------------------------------------------------------------------------------------------------
    then   width = math.max(
                     -- formula #1
                     border
                     + GAP(1) + elementWidth('Icon_1Panel', layout)
                     + GAP(1) + elementWidth('NamePanel', layout)
                     + GAP(1) + border,
                     -- formula #2
                     border
                     + GAP(1) + elementWidth('Icon_1Panel', layout)
                     + GAP(1) + elementWidth('InfoPanel', layout)
                     + GAP(1) + border,
                     -- formula #3
                     border 
                     + elementWidth('StatusBarPanel', "ABRIDGED")
                     + border,
                     -- formula #4
                     border
                     + GAP(1) + elementWidth('Icon_2Panel', layout)
                     + GAP(1) + elementWidth('Icon_3Panel', layout)
                     + GAP(1) + elementWidth('Icon_4Panel', layout)
                     + GAP(1) + elementWidth('Icon_5Panel', layout)
                     + GAP(1) + elementWidth('Icon_6Panel', layout)
                     + GAP(1) + border
                     );
            height = math.max(
                       -- formula #1
                       border
                       + GAP(1) + elementHeight('Icon_1Panel', layout)
                       + GAP(1) + elementHeight('StatusBarPanel', "ABRIDGED") 
                       + GAP(1) + elementHeight('Icon_2Panel', layout)
                       + GAP(1) + border,
                       -- formula #2
                       border
                       + GAP(1) + elementHeight('NamePanel' , layout)
                       + GAP(1) + elementHeight('InfoPanel', layout)
                       + GAP(1) + elementHeight('StatusBarPanel', "ABRIDGED")
                       + GAP(1) + elementHeight('Icon_2Panel', layout)
                       + GAP(1) + border
                       ); --

    elseif layout == "COMPACT" -- -----------------------------------------------------------------------------------------------------------
    then   width = border
                   + GAP(0.5) + elementWidth('Icon_1Panel', layout)
                   + GAP(0.5) + elementWidth('NamePanel', layout)
                   + GAP(0.5) + border;
           height = math.max(
                      -- formula #1
                      border
                      + GAP(0.5) + elementHeight('NamePanel', layout)
                      + GAP(0.5) + elementHeight('InfoPanel', layout)
                      + GAP(0.5) + border,
                      -- formula #2
                      border
                      + GAP(0.5) + elementHeight('Icon_1Panel', layout)
                      + GAP(0.5) + border
                    );

    elseif layout == "HIDDEN" -- ----------------------------------------------------------------------------------------------------------
    then   width, height = 10, 10;
    end; -- if layout ---------------------------------------------------------------------------------------------------------------------

    return width, height;
  end;

  local function elementLeftTop(element, layout)
    local left, top, border, nborder;

    if   layout == "HIDDEN" then return 0, 0 end;

    if   Config.get("RPUF_BACKDROP") == "BLIZZTOOLTIP" then border = 5; nborder = -5;
    else                                                    border = 0; nborder =  0; 
    end; --if

    if   layout == "FULL"  -- -----------------------------------------------------------------------------------------------------------
    then local iconLeft = border + GAP(1);
         if not element
         then   left    =  border + GAP(1);
                top     =  nborder + NGAP(1);
         elseif element == 'PortraitPanel'
         then   left    =  border
                           + GAP(1) + elementWidth('Icon_1Panel', layout)
                           + GAP(1);
                top     =  nborder + NGAP(1);
         elseif element == 'Icon_1Panel'
         then   left    =  iconLeft;
                top     =  nborder + NGAP(1);
         elseif element == 'Icon_2Panel'
         then   left    =  iconLeft;
                top     =  nborder
                           + NGAP(1) - elementHeight('Icon_1Panel', layout)
                           + NGAP(1);
         elseif element == 'Icon_3Panel'
         then   left    =  iconLeft;
                top     =  nborder
                           + NGAP(1) - elementHeight('Icon_1Panel', layout)
                           + NGAP(1) - elementHeight('Icon_2Panel', layout)
                           + NGAP(1);
         elseif element == 'Icon_4Panel'
         then   left    =  iconLeft;
                top     =  nborder
                           + NGAP(1) - elementHeight('Icon_1Panel', layout)
                           + NGAP(1) - elementHeight('Icon_2Panel', layout)
                           + NGAP(1) - elementHeight('Icon_3Panel', layout)
                           + NGAP(1);
         elseif element == 'Icon_5Panel'
         then   left    =  iconLeft;
                top     =  nborder
                           + NGAP(1) - elementHeight('Icon_1Panel', layout)
                           + NGAP(1) - elementHeight('Icon_2Panel', layout)
                           + NGAP(1) - elementHeight('Icon_3Panel', layout)
                           + NGAP(1) - elementHeight('Icon_4Panel', layout)
                           + NGAP(1);
         elseif element == 'Icon_6Panel'
         then   left    =  iconLeft;
                top     =  nborder
                           + NGAP(1) - elementHeight('Icon_1Panel', layout)
                           + NGAP(1) - elementHeight('Icon_2Panel', layout)
                           + NGAP(1) - elementHeight('Icon_3Panel', layout)
                           + NGAP(1) - elementHeight('Icon_4Panel', layout)
                           + NGAP(1) - elementHeight('Icon_5Panel', layout)
                           + NGAP(1);
         elseif element == 'NamePanel'
         then   left    =  border
                           + GAP(1) + elementWidth('PortraitPanel', layout)
                           + GAP(1) + elementWidth('Icon_1Panel', layout)
                           + GAP(1);
                top     =  nborder
                           + NGAP(1);
         elseif element == 'InfoPanel'
         then   left    =  border
                           + GAP(1) + elementWidth('PortraitPanel', layout)
                           + GAP(1) + elementWidth('Icon_1Panel', layout)
                           + GAP(1);
                top     =  nborder
                           + NGAP(1) - elementHeight('NamePanel', layout)
                           + NGAP(1);
         elseif element == 'DetailsPanel'
         then   left    =  border
                           + GAP(1) + elementWidth('Icon_1Panel', layout)
                           + GAP(1) + elementWidth('PortraitPanel', layout)
                           + GAP(1);
                top     =  nborder
                           + NGAP(1) - elementHeight('NamePanel', layout)
                           + NGAP(1) - elementHeight('InfoPanel', layout)
                           + NGAP(1);
         elseif element == 'StatusBarPanel'
         then   left    =  border;
                top     =  math.min(
                             -- formula #1
                             nborder
                             + NGAP(1) - elementHeight('Icon_1Panel', layout)
                             + NGAP(1) - elementHeight('Icon_2Panel', layout)
                             + NGAP(1) - elementHeight('Icon_3Panel', layout)
                             + NGAP(1) - elementHeight('Icon_4Panel', layout)
                             + NGAP(1) - elementHeight('Icon_5Panel', layout)
                             + NGAP(1) - elementHeight('Icon_6Panel', layout)
                             + NGAP(1),
                             -- formula #2
                             nborder
                             + NGAP(1) - elementHeight('PortraitPanel', layout),
                             -- formula #3
                             nborder
                             + NGAP(1) - elementHeight('NamePanel', layout)
                             + NGAP(1) - elementHeight('InfoPanel', layout)
                             + NGAP(1) - elementHeight('DetailsPanel', layout)
                             + NGAP(1));
         else   left  = border + GAP(1);
                top   = nborder + NGAP(1);
         end; -- if element

       elseif layout == "THUMBNAIL" -- ----------------------------------------------------------------------------------------------------------
       then if not element               then left = border;            top = nborder;
            elseif element == 'PortraitPanel' then left = border;            top = nborder
            elseif element == 'NamePanel'     then left = border + GAP(1/3); 
                                                   top  = math.min(
                                                            -- formula #1
                                                            nborder - elementHeight('PortraitPanel', layout) + elementHeight('NamePanel', layout),
                                                            -- formula #2
                                                            nborder - elementHeight('Icon_1Panel', layout)
                                                            );
            elseif element == 'Icon_1Panel'   then left = border; top = nborder;
            else                              left = 5000;              top = 5000;
            end -- if element

       elseif layout == "PAPERDOLL" -- ----------------------------------------------------------------------------------------------------------
       then local leftIconLeft  = border + GAP(1);
            local rightIconLeft = -- border
                                  border + elementWidth('PortraitPanel', layout)
                                  - GAP(1)
                                  - elementWidth('Icon_1Panel', layout);
            if not element
            then   left    = border + GAP(1);
                   top     = nborder + NGAP(1);
            elseif element == 'NamePanel'
            then   left    = border
                             + GAP(1);
                   top     = nborder + NGAP(1);
            elseif element == 'InfoPanel'
            then   left    = border
                             + GAP(1)
                   top     = nborder
                             + NGAP(1) - elementHeight('NamePanel', layout)
                             + NGAP(1);
            elseif element == 'PortraitPanel'
            then   left    = border
                             -- + GAP(1) + elementWidth('Icon_1Panel', layout)
                             -- + GAP(1);
                   top     = nborder
                             + NGAP(1) - elementHeight('NamePanel', layout)
                             + NGAP(1) - elementHeight('InfoPanel', layout)
                             + NGAP(1);
            elseif element == 'Icon_1Panel'
            then   left    = leftIconLeft;
                   top     = nborder
                             + NGAP(1) - elementHeight('NamePanel', layout)
                             + NGAP(1) - elementHeight('InfoPanel', layout)
                             + NGAP(2);
            elseif element == 'Icon_2Panel'
            then   left    = leftIconLeft;
                   top     = nborder
                             + NGAP(1) - elementHeight('NamePanel', layout)
                             + NGAP(1) - elementHeight('InfoPanel', layout)
                             + NGAP(2) - elementHeight('Icon_1Panel', layout)
                             + NGAP(2);
            elseif element == 'Icon_3Panel'
            then   left    = leftIconLeft;
                   top     = nborder
                             + NGAP(1) - elementHeight('NamePanel', layout)
                             + NGAP(1) - elementHeight('InfoPanel', layout)
                             + NGAP(2) - elementHeight('Icon_1Panel', layout)
                             + NGAP(2) - elementHeight('Icon_2Panel', layout)
                             + NGAP(2);
             elseif element == 'Icon_4Panel'
             then   left    = rightIconLeft;
                    top     = nborder
                              + NGAP(1) - elementHeight('NamePanel', layout)
                              + NGAP(1) - elementHeight('InfoPanel', layout)
                              + NGAP(2);
             elseif element == 'Icon_5Panel'
             then   left    = rightIconLeft;
                    top     = nborder
                              + NGAP(1) - elementHeight('NamePanel', layout)
                              + NGAP(1) - elementHeight('InfoPanel', layout)
                              + NGAP(2) - elementHeight('Icon_4Panel', layout)
                              + NGAP(2);
             elseif element == 'Icon_6Panel'
             then   left    = rightIconLeft;
                    top     = nborder
                              + NGAP(1) - elementHeight('NamePanel', layout)
                              + NGAP(1) - elementHeight('InfoPanel', layout)
                              + NGAP(2) - elementHeight('Icon_4Panel', layout)
                              + NGAP(2) - elementHeight('Icon_5Panel', layout)
                              + NGAP(2);
             else   left, top = 5000, 5000;
             end; -- if element
       elseif layout == "ABRIDGED" -- -----------------------------------------------------------------------------------------------------------
       then local iconTop = math.min(
                              -- formula #1
                              nborder
                              + NGAP(1) - elementHeight('Icon_1Panel', layout)
                              + NGAP(1) - elementHeight('StatusBarPanel', "ABRIDGED")
                              + NGAP(1),
                              -- formula #2
                              nborder
                              + NGAP(1) - elementHeight('NamePanel', layout)
                              + NGAP(1) - elementHeight('InfoPanel', layout)
                              + NGAP(1) - elementHeight('StatusBarPanel', "ABRIDGED")
                              + NGAP(1)
                            );

            if not element
            then   left    =  border + GAP(1)
                   top     =  nborder + NGAP(1);
            elseif element == 'NamePanel'
            then   left    =  border
                              + GAP(1) + elementWidth('Icon_1Panel', layout)
                              + GAP(1)
                   top     =  nborder
                              + NGAP(1);
            elseif element == 'InfoPanel'
            then   left    =  border
                              + GAP(1) + elementWidth('Icon_1Panel', layout)
                              + GAP(1);
                   top     =  nborder
                              + NGAP(1) - elementHeight('NamePanel', layout)
                              + NGAP(1);
            elseif element == 'Icon_1Panel'
            then   left    =  border + GAP(1);
                   top     =  nborder + NGAP(1);
            elseif element == 'StatusBarPanel'
            then   left    =  border;
                   top     =  math.min(
                                -- formula #1
                                nborder
                                + NGAP(1) - elementHeight('Icon_1Panel', layout)
                                + NGAP(1),
                                -- formula #2
                                nborder
                                + NGAP(1) - elementHeight('NamePanel' , layout)
                                + NGAP(1) - elementHeight('InfoPanel', layout)
                                + NGAP(1)
                              );
            elseif element == 'Icon_2Panel'
            then   left    =  border + GAP(1)
                   top     =  iconTop;
            elseif element == 'Icon_3Panel'
            then   left    =  border
                              + GAP(1) + elementHeight('Icon_2Panel', layout)
                              + GAP(1);
                   top     =  iconTop;
            elseif element == 'Icon_4Panel'
            then   left    =  border
                              + GAP(1) + elementHeight('Icon_2Panel', layout)
                              + GAP(1) + elementHeight('Icon_3Panel', layout)
                              + GAP(1);
                   top     =  iconTop;
            elseif element == 'Icon_5Panel'
            then   left    =  border
                              + GAP(1) + elementHeight('Icon_2Panel', layout)
                              + GAP(1) + elementHeight('Icon_3Panel', layout)
                              + GAP(1) + elementHeight('Icon_4Panel', layout)
                              + GAP(1);
                   top     =  iconTop;
            elseif element == 'Icon_6Panel'
            then   left    =  border
                              + GAP(1) + elementHeight('Icon_2Panel', layout)
                              + GAP(1) + elementHeight('Icon_3Panel', layout)
                              + GAP(1) + elementHeight('Icon_4Panel', layout)
                              + GAP(1) + elementHeight('Icon_5Panel', layout)
                              + GAP(1);
                   top     =  iconTop;
            else   left, top = 5000, 5000;
            end; -- if element

       elseif layout == "COMPACT" -- -----------------------------------------------------------------------------------------------------------
       then
            if not element
            then   left    =  border  + GAP(0.5);
                   top     =  nborder + NGAP(0.5);
            elseif element == 'Icon_1Panel'
            then   left    =  border  + GAP(0.5);
                   top     =  nborder + NGAP(0.5);
            elseif element == 'NamePanel'
            then   left    =  border
                              + GAP(0.5) + elementWidth('Icon_1Panel', layout)
                              + GAP(0.5);
                   top     =  nborder
                              + NGAP(0.5);
            elseif element == 'InfoPanel'
            then   left    =  border
                              + GAP(0.5) + elementWidth('Icon_1Panel', layout)
                              + GAP(0.5);
                   top     =  nborder
                              + NGAP(1) - elementHeight('NamePanel', layout);
            else   left, top = 5000, 5000
            end; -- if element
       else left, top = 5000, 5000
       end; -- if layout

    return left, top;
  end;

  local function elementTop(element, layout)  local _,   top = elementLeftTop(element, layout) return top;  end;
  local function elementLeft(element, layout) local left, _  = elementLeftTop(element, layout) return left; end;

  local function elementAlignH(element, layout)
    if     element == 'StatusBarPanel' then return RPTAGS.CONST.ALIGN[Config.get("STATUS_ALIGN")].H; 
    elseif element == 'NamePanel' and layout == 'PAPERDOLL' then return "CENTER"
    elseif element == 'InfoPanel' and layout == 'PAPERDOLL' then return "CENTER"
    elseif element == 'NamePanel' and layout == 'THUMBNAIL' then return "CENTER"
    elseif element == 'InfoPanel' and layout == 'THUMBNAIL' then return "CENTER"
    else return "LEFT";
    end;
  end;

  -- tag functions --------------------------------------------------------------------------------------------------------------------------------------------

  local function setAllFrameScales() 
    RPUF_Player:SetScale(Config.get("PLAYERFRAME_SCALE"));
    RPUF_Target:SetScale(Config.get("TARGETFRAME_SCALE"));
    RPUF_Focus:SetScale(Config.get("FOCUSFRAME_SCALE"));
    -- RPUF_TargetTarget:SetScale(Config.get("TARGETTARGETFRAME_SCALE"));
  end;

  local function testTags(s)
    local err, good, bad = false, {}, {};
    for tag in string.gmatch(s, "%[([^%]]+)%]")
    do  if   RPTAGS.utils.tags.exists(tag)
        then table.insert(good, tag)
        else table.insert(bad, tag); err = true;
        end; --if
    end; -- do
    return err, good, bad;
  end; -- function

  local function fixTagErrors(s)
    local err, good, bad = testTags(s);
    if not err then return s end;
    for _, badTag in ipairs(bad) do s = s:gsub("%[" .. badTag .. "%]", "%[err%]" .. badTag .. "%[/err%]"); end;
    return s;
  end -- function
  
  local function setTag(frame, element, value, field)
    frame:Tag(frame[element][field or "text"], fixTagErrors(value)); 
    frame:UpdateTags();
  end; -- function

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

  RPTAGS.cache.tagcache = RPTAGS.cache.tagcache or {};

  local function makeCache(tag)
    RPTAGS.cache.tagcache[tag] = RPTAGS.cache.tagcache[tag] or {};
    return RPTAGS.cache.tagcache[tag];
  end; -- function
  
        -- registers one tag, an event to wait for, and a method to invoke when found --------------------------
  local function registerTag(tag)
    local TagData = RPTAGS.cache.tagcache[tag];
  
    if     TagData.external -- this means it's a tag from outside of our program so we don't need to add it
    then   return false
    else   local events = RPTAGS.CONST.MAIN_EVENT;
           if TagData.extraEvents then events = events .. " " .. TagData.extraEvents; end;
           oUF.Tags.Events[tag]  = events;
           oUF.Tags.Methods[tag] = TagData.method; 
    end;  -- if 
  end; -- function
  
  local function registerAllTags()
    for tag, _ in pairs(RPTAGS.cache.tagcache) 
    do  registerTag(tag); 
    end;

    -- make sure that we have all the ElvUI tags available to rp:UF
    -- if   state.elvui 
    -- then for tag, event in pairs(_G["ElvUF"].Tags.Events)
    --      do if   not oUF.Tags.Events[tag]
    --         then     oUF.Tags.Events[tag] = event;
    --                  oUF.Tags.Methods[tag] = _G["ElvUF"].Tags.Methods[tag]
    --         end; -- if
    --     end; -- for
    -- end; -- if
  end; -- function

  -- frame functions ----------------------------------------------------------------------------------------------------------------------------------------
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

  -- allFrames functions ------------------------------------------------------------------------------------------------------------------------------------
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

  local function refreshAllFrames() for _, frame in ipairs(FRAMES()) do refreshFrame(frame) end; end;

  RPTAGS.utils      = RPTAGS.utils      or {};
  RPTAGS.utils.rpuf = RPTAGS.utils.rpuf or {};
  -- frame functions
  RPTAGS.utils.rpuf.frame = RPTAGS.utils.rpuf.frame or {};
  RPTAGS.utils.rpuf.frame.layout         = frameLayout;
  RPTAGS.utils.rpuf.frame.refresh        = refreshFrame;
  RPTAGS.utils.rpuf.frame.resize         = resizeFrame;
  RPTAGS.utils.rpuf.frame.size           = frameDimensions;
  RPTAGS.utils.rpuf.frame.tag            = setTag;
  RPTAGS.utils.rpuf.frame.textcolor      = textColors;
  RPTAGS.utils.rpuf.frame.statusTexture  = setStatusBarTexture;
  RPTAGS.utils.rpuf.frame.statusAlign    = setStatusBarAlignment;

  -- allFrames functions
  RPTAGS.utils.rpuf.allFrames  = RPTAGS.utils.rpuf.allFrames  or {};
  RPTAGS.utils.rpuf.allFrames.backdrop   = setAllBackground;
  RPTAGS.utils.rpuf.allFrames.lock       = lockFrames;
  RPTAGS.utils.rpuf.allFrames.move       = setAllMovable;
  RPTAGS.utils.rpuf.allFrames.refresh    = refreshAllFrames;
  RPTAGS.utils.rpuf.allFrames.resetloc   = resetAllLocations;
  RPTAGS.utils.rpuf.allFrames.resize     = resizeAllFrames;
  RPTAGS.utils.rpuf.allFrames.setbg      = setAllBackground;
  RPTAGS.utils.rpuf.allFrames.tag        = tagAll;
  RPTAGS.utils.rpuf.allFrames.visibility = setHide;
  RPTAGS.utils.rpuf.allFrames.disable    = setHide;
  RPTAGS.utils.rpuf.allFrames.textcolor  = allTextColors;
  RPTAGS.utils.rpuf.allFrames.statusTexture = setAllStatusBarTextures;
  RPTAGS.utils.rpuf.allFrames.statusAlign = setAllStatusBarAlignments;
  RPTAGS.utils.rpuf.allFrames.scale       = setAllFrameScales;

  -- element functions (affect all frames)
  RPTAGS.utils.rpuf.element = RPTAGS.utils.rpuf.element or {};
  RPTAGS.utils.rpuf.element.height       = elementHeight;
  RPTAGS.utils.rpuf.element.left         = elementLeft;
  RPTAGS.utils.rpuf.element.resize       = resizePanel;
  RPTAGS.utils.rpuf.element.top          = elementTop;
  RPTAGS.utils.rpuf.element.topleft      = elementLeftTop;
  RPTAGS.utils.rpuf.element.width        = elementWidth;
  RPTAGS.utils.rpuf.element.align        = elementAlignH;

  -- tag functions
  RPTAGS.utils.rpuf.tags = RPTAGS.utils.rpuf.tags or {};
  RPTAGS.utils.rpuf.tags.register        = registerTag; 
  RPTAGS.utils.rpuf.tags.registerall     = registerAllTags;
  RPTAGS.utils.rpuf.tags.fix             = fixTagErrors;
  RPTAGS.utils.rpuf.tags.test            = testTags;

end);
