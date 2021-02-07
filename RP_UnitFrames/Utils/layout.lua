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

  local CONST       = RPTAGS.CONST;
  local Utils       = RPTAGS.utils; 

  local Config      = RPTAGS.utils.config;
  local PANELS      = { "NamePanel", "InfoPanel", "PortraitPanel", "DetailsPanel", 
                        "StatusBarPanel", "Icon_1Panel", "Icon_2Panel", "Icon_3Panel", 
                        "Icon_4Panel", "Icon_5Panel", "Icon_6Panel", };
  local FRAME_LIST  = { "RPUF_Player", "RPUF_Target", "RPUF_Focus" }; -- , "RPUF_Mouseover", };
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
    local map = 
    { ["RPUF_Player"], = Config.get("PLAYERLAYOUT"),
      ["RPUF_Target"], = Config.get("TARGETLAYOUT"),
      ["RPUF_Focus"], = Config.get("FOCUSLAYOUT"),
      -- ["RPUF_Mouseover"], = Config.get("MOUSEOVERLAYOUT"),
      -- ["RPUF_Party"], = Config.get("PARTYLAYOUT"),
      -- ["RPUF_Raid"], = Config.get("RAIDLAYOUT"),
    };
    return map[frame:GetName()] or "COMPACT"
  end; -- function

  local function panelHeight(panel, layout)
    local height;

    if     not panel                                          then height = 0
    elseif layout  == "HIDDEN" then height = 10
    elseif panel == 'NamePanel'                                    then height = FONTSIZE + 4;

    elseif panel == 'InfoPanel'                                    then height = FONTSIZE + 2;

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

  local function panelWidth(panel, layout)
    local width;

    if not panel then width = 0
    elseif layout == "HIDDEN" then width = 10
    elseif panel == 'NamePanel'       and layout  == "THUMBNAIL"  then width = math.max(
                                                                                  -- formula #1
                                                                                  Config.get("PORTWIDTH") * 2/3 - GAP(2/3),
                                                                                  -- formula #2
                                                                                  Config.get("ICONWIDTH") - GAP(2/3)
                                                                                  );
    -- elseif panel == 'NamePanel'       and layout  == 'PAPERDOLL'  then width = Config.get("ICONWIDTH") + GAP(1) + Config.get("PORTWIDTH") + GAP(1) + Config.get("ICONWIDTH");
    elseif panel == 'NamePanel'          and layout == "PAPERDOLL" then width = Config.get("PORTWIDTH") * 1.5 - GAP(2) ;
    elseif panel == 'NamePanel'                                   then width = Config.get("INFOWIDTH");
    
    -- elseif panel == 'InfoPanel'       and layout  == 'PAPERDOLL'  then width = Config.get("ICONWIDTH") + GAP(1) + Config.get("PORTWIDTH") + GAP(1) + Config.get("ICONWIDTH");
    elseif panel == 'InfoPanel'          and layout == "PAPERDOLL" then width = Config.get("PORTWIDTH") * 1.5 - GAP(2);
    elseif panel == 'InfoPanel'                                   then width = Config.get("INFOWIDTH");

    elseif panel == 'PortraitPanel'   and layout  == "PAPERDOLL"  then width = Config.get("PORTWIDTH") * 1.5;
    elseif panel == 'PortraitPanel'   and layout  == "THUMBNAIL"  then width = Config.get("PORTWIDTH") * 2/3;
    elseif panel == 'PortraitPanel'                               then width = Config.get("PORTWIDTH");

    elseif panel == 'DetailsPanel'                                then width = Config.get("INFOWIDTH");
    elseif panel == 'StatusBarPanel'  and layout  == "FULL"       then width = Config.get("PORTWIDTH")
                                                                            + GAP(1) + Config.get("INFOWIDTH")
                                                                            + GAP(1) + Config.get("ICONWIDTH")
                                                                            + GAP(2); -- internal padding
    elseif panel == 'StatusBarPanel'  and layout  == "ABRIDGED"   then width = math.max(
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

  local function frameDimensions(layout)
    local border, width, height;

    if layout == "HIDDEN" then return 0, 0 end;

    if   Config.get("RPUF_BACKDROP") == "BLIZZTOOLTIP"
    then border = 5
    else border = 0 end;

    if     layout == "FULL" -- -----------------------------------------------------------------------------------------------------------
    then   width  = 
             border
             + GAP(1) + panelWidth('Icon_1Panel', layout)
             + GAP(1) + panelWidth('InfoPanel', layout)
             + GAP(1) + panelWidth('PortraitPanel', layout)
             + GAP(1) + border;

           height = math.max(
             -- formula #1
             border
               + GAP(1) + panelHeight('Icon_1Panel', layout)
               + GAP(1) + panelHeight('Icon_2Panel', layout)
               + GAP(1) + panelHeight('Icon_3Panel', layout)
               + GAP(1) + panelHeight('Icon_4Panel', layout)
               + GAP(1) + panelHeight('Icon_5Panel', layout)
               + GAP(1) + panelHeight('Icon_6Panel', layout)
               + GAP(1) + panelHeight('StatusBarPanel', "FULL")
               + border, 
            -- formula #2
             border
               + GAP(1) + panelHeight('NamePanel', layout)
               + GAP(1) + panelHeight('DetailsPanel', layout)
               + panelHeight('StatusBarPanel', "FULL") 
               + GAP(1) + panelHeight('InfoPanel', layout)
               + GAP(1) + border,
             -- formula #3
             border
               + GAP(1) + panelHeight('PortraitPanel', layout)
               + panelHeight('StatusBarPanel', "FULL")
               + border -- ditto
             );

    elseif layout == "THUMBNAIL" -- -------------------------------------------------------------------------------------------------------------
    then   width  =  math.max(
                     -- formula #1
                     border + panelWidth('PortraitPanel', layout)  + border,
                     -- formula #2
                     border + panelWidth('Icon_1Panel', layout) + border)
           height =  math.max( -- formula #1
                     border + panelHeight('Icon_1Panel', layout) + panelHeight('NamePanel', layout) + border,
                     -- Formula #2
                     border + panelHeight('PortraitPanel', layout) + border);

    elseif layout == "PAPERDOLL" -- -------------------------------------------------------------------------------------------------------------
    then   width  =  border
                     -- + GAP(1) + panelWidth('Icon_1Panel', layout)
                     + panelWidth('PortraitPanel', layout)
                     -- + GAP(1) + panelWidth('Icon_4Panel', layout)
                     + border;
           height =  math.max(
                     -- formula #1
                     border
                     + GAP(1) + panelHeight('NamePanel', layout)
                     + GAP(1) + panelHeight('InfoPanel', layout)
                     + GAP(1) + panelHeight('PortraitPanel', layout)
                     + border, -- no gap needed here
                     -- formula #2
                     border
                     + GAP(1) + panelHeight('NamePanel', layout)
                     + GAP(1) + panelHeight('InfoPanel', layout)
                     + GAP(2) + panelHeight('Icon_1Panel', layout)
                     + GAP(2) + panelHeight('Icon_2Panel', layout)
                     + GAP(2) + panelHeight('Icon_3Panel', layout)
                     + GAP(1) + border
                    );

    elseif layout == "ABRIDGED" -- -----------------------------------------------------------------------------------------------------------
    then   width = math.max(
                     -- formula #1
                     border
                     + GAP(1) + panelWidth('Icon_1Panel', layout)
                     + GAP(1) + panelWidth('NamePanel', layout)
                     + GAP(1) + border,
                     -- formula #2
                     border
                     + GAP(1) + panelWidth('Icon_1Panel', layout)
                     + GAP(1) + panelWidth('InfoPanel', layout)
                     + GAP(1) + border,
                     -- formula #3
                     border 
                     + panelWidth('StatusBarPanel', "ABRIDGED")
                     + border,
                     -- formula #4
                     border
                     + GAP(1) + panelWidth('Icon_2Panel', layout)
                     + GAP(1) + panelWidth('Icon_3Panel', layout)
                     + GAP(1) + panelWidth('Icon_4Panel', layout)
                     + GAP(1) + panelWidth('Icon_5Panel', layout)
                     + GAP(1) + panelWidth('Icon_6Panel', layout)
                     + GAP(1) + border
                     );
            height = math.max(
                       -- formula #1
                       border
                       + GAP(1) + panelHeight('Icon_1Panel', layout)
                       + GAP(1) + panelHeight('StatusBarPanel', "ABRIDGED") 
                       + GAP(1) + panelHeight('Icon_2Panel', layout)
                       + GAP(1) + border,
                       -- formula #2
                       border
                       + GAP(1) + panelHeight('NamePanel' , layout)
                       + GAP(1) + panelHeight('InfoPanel', layout)
                       + GAP(1) + panelHeight('StatusBarPanel', "ABRIDGED")
                       + GAP(1) + panelHeight('Icon_2Panel', layout)
                       + GAP(1) + border
                       ); --

    elseif layout == "COMPACT" -- -----------------------------------------------------------------------------------------------------------
    then   width = border
                   + GAP(0.5) + panelWidth('Icon_1Panel', layout)
                   + GAP(0.5) + panelWidth('NamePanel', layout)
                   + GAP(0.5) + border;
           height = math.max(
                      -- formula #1
                      border
                      + GAP(0.5) + panelHeight('NamePanel', layout)
                      + GAP(0.5) + panelHeight('InfoPanel', layout)
                      + GAP(0.5) + border,
                      -- formula #2
                      border
                      + GAP(0.5) + panelHeight('Icon_1Panel', layout)
                      + GAP(0.5) + border
                    );

    elseif layout == "HIDDEN" -- ----------------------------------------------------------------------------------------------------------
    then   width, height = 10, 10;
    end; -- if layout ---------------------------------------------------------------------------------------------------------------------

    return width, height;
  end;

  local function panelLeftTop(panel, layout)
    local left, top, border, nborder;

    if   layout == "HIDDEN" then return 0, 0 end;

    if   Config.get("RPUF_BACKDROP") == "BLIZZTOOLTIP" then border = 5; nborder = -5;
    else                                                    border = 0; nborder =  0; 
    end; --if

    if   layout == "FULL"  -- -----------------------------------------------------------------------------------------------------------
    then local iconLeft = border + GAP(1);
         if not panel
         then   left    =  border + GAP(1);
                top     =  nborder + NGAP(1);
         elseif panel == 'PortraitPanel'
         then   left    =  border
                           + GAP(1) + panelWidth('Icon_1Panel', layout)
                           + GAP(1);
                top     =  nborder + NGAP(1);
         elseif panel == 'Icon_1Panel'
         then   left    =  iconLeft;
                top     =  nborder + NGAP(1);
         elseif panel == 'Icon_2Panel'
         then   left    =  iconLeft;
                top     =  nborder
                           + NGAP(1) - panelHeight('Icon_1Panel', layout)
                           + NGAP(1);
         elseif panel == 'Icon_3Panel'
         then   left    =  iconLeft;
                top     =  nborder
                           + NGAP(1) - panelHeight('Icon_1Panel', layout)
                           + NGAP(1) - panelHeight('Icon_2Panel', layout)
                           + NGAP(1);
         elseif panel == 'Icon_4Panel'
         then   left    =  iconLeft;
                top     =  nborder
                           + NGAP(1) - panelHeight('Icon_1Panel', layout)
                           + NGAP(1) - panelHeight('Icon_2Panel', layout)
                           + NGAP(1) - panelHeight('Icon_3Panel', layout)
                           + NGAP(1);
         elseif panel == 'Icon_5Panel'
         then   left    =  iconLeft;
                top     =  nborder
                           + NGAP(1) - panelHeight('Icon_1Panel', layout)
                           + NGAP(1) - panelHeight('Icon_2Panel', layout)
                           + NGAP(1) - panelHeight('Icon_3Panel', layout)
                           + NGAP(1) - panelHeight('Icon_4Panel', layout)
                           + NGAP(1);
         elseif panel == 'Icon_6Panel'
         then   left    =  iconLeft;
                top     =  nborder
                           + NGAP(1) - panelHeight('Icon_1Panel', layout)
                           + NGAP(1) - panelHeight('Icon_2Panel', layout)
                           + NGAP(1) - panelHeight('Icon_3Panel', layout)
                           + NGAP(1) - panelHeight('Icon_4Panel', layout)
                           + NGAP(1) - panelHeight('Icon_5Panel', layout)
                           + NGAP(1);
         elseif panel == 'NamePanel'
         then   left    =  border
                           + GAP(1) + panelWidth('PortraitPanel', layout)
                           + GAP(1) + panelWidth('Icon_1Panel', layout)
                           + GAP(1);
                top     =  nborder
                           + NGAP(1);
         elseif panel == 'InfoPanel'
         then   left    =  border
                           + GAP(1) + panelWidth('PortraitPanel', layout)
                           + GAP(1) + panelWidth('Icon_1Panel', layout)
                           + GAP(1);
                top     =  nborder
                           + NGAP(1) - panelHeight('NamePanel', layout)
                           + NGAP(1);
         elseif panel == 'DetailsPanel'
         then   left    =  border
                           + GAP(1) + panelWidth('Icon_1Panel', layout)
                           + GAP(1) + panelWidth('PortraitPanel', layout)
                           + GAP(1);
                top     =  nborder
                           + NGAP(1) - panelHeight('NamePanel', layout)
                           + NGAP(1) - panelHeight('InfoPanel', layout)
                           + NGAP(1);
         elseif panel == 'StatusBarPanel'
         then   left    =  border;
                top     =  math.min(
                             -- formula #1
                             nborder
                             + NGAP(1) - panelHeight('Icon_1Panel', layout)
                             + NGAP(1) - panelHeight('Icon_2Panel', layout)
                             + NGAP(1) - panelHeight('Icon_3Panel', layout)
                             + NGAP(1) - panelHeight('Icon_4Panel', layout)
                             + NGAP(1) - panelHeight('Icon_5Panel', layout)
                             + NGAP(1) - panelHeight('Icon_6Panel', layout)
                             + NGAP(1),
                             -- formula #2
                             nborder
                             + NGAP(1) - panelHeight('PortraitPanel', layout),
                             -- formula #3
                             nborder
                             + NGAP(1) - panelHeight('NamePanel', layout)
                             + NGAP(1) - panelHeight('InfoPanel', layout)
                             + NGAP(1) - panelHeight('DetailsPanel', layout)
                             + NGAP(1));
         else   left  = border + GAP(1);
                top   = nborder + NGAP(1);
         end; -- if panel

       elseif layout == "THUMBNAIL" -- ----------------------------------------------------------------------------------------------------------
       then if not panel               then left = border;            top = nborder;
            elseif panel == 'PortraitPanel' then left = border;            top = nborder
            elseif panel == 'NamePanel'     then left = border + GAP(1/3); 
                                                   top  = math.min(
                                                            -- formula #1
                                                            nborder - panelHeight('PortraitPanel', layout) + panelHeight('NamePanel', layout),
                                                            -- formula #2
                                                            nborder - panelHeight('Icon_1Panel', layout)
                                                            );
            elseif panel == 'Icon_1Panel'   then left = border; top = nborder;
            else                              left = 5000;              top = 5000;
            end -- if panel

       elseif layout == "PAPERDOLL" -- ----------------------------------------------------------------------------------------------------------
       then local leftIconLeft  = border + GAP(1);
            local rightIconLeft = -- border
                                  border + panelWidth('PortraitPanel', layout)
                                  - GAP(1)
                                  - panelWidth('Icon_1Panel', layout);
            if not panel
            then   left    = border + GAP(1);
                   top     = nborder + NGAP(1);
            elseif panel == 'NamePanel'
            then   left    = border
                             + GAP(1);
                   top     = nborder + NGAP(1);
            elseif panel == 'InfoPanel'
            then   left    = border
                             + GAP(1)
                   top     = nborder
                             + NGAP(1) - panelHeight('NamePanel', layout)
                             + NGAP(1);
            elseif panel == 'PortraitPanel'
            then   left    = border
                             -- + GAP(1) + panelWidth('Icon_1Panel', layout)
                             -- + GAP(1);
                   top     = nborder
                             + NGAP(1) - panelHeight('NamePanel', layout)
                             + NGAP(1) - panelHeight('InfoPanel', layout)
                             + NGAP(1);
            elseif panel == 'Icon_1Panel'
            then   left    = leftIconLeft;
                   top     = nborder
                             + NGAP(1) - panelHeight('NamePanel', layout)
                             + NGAP(1) - panelHeight('InfoPanel', layout)
                             + NGAP(2);
            elseif panel == 'Icon_2Panel'
            then   left    = leftIconLeft;
                   top     = nborder
                             + NGAP(1) - panelHeight('NamePanel', layout)
                             + NGAP(1) - panelHeight('InfoPanel', layout)
                             + NGAP(2) - panelHeight('Icon_1Panel', layout)
                             + NGAP(2);
            elseif panel == 'Icon_3Panel'
            then   left    = leftIconLeft;
                   top     = nborder
                             + NGAP(1) - panelHeight('NamePanel', layout)
                             + NGAP(1) - panelHeight('InfoPanel', layout)
                             + NGAP(2) - panelHeight('Icon_1Panel', layout)
                             + NGAP(2) - panelHeight('Icon_2Panel', layout)
                             + NGAP(2);
             elseif panel == 'Icon_4Panel'
             then   left    = rightIconLeft;
                    top     = nborder
                              + NGAP(1) - panelHeight('NamePanel', layout)
                              + NGAP(1) - panelHeight('InfoPanel', layout)
                              + NGAP(2);
             elseif panel == 'Icon_5Panel'
             then   left    = rightIconLeft;
                    top     = nborder
                              + NGAP(1) - panelHeight('NamePanel', layout)
                              + NGAP(1) - panelHeight('InfoPanel', layout)
                              + NGAP(2) - panelHeight('Icon_4Panel', layout)
                              + NGAP(2);
             elseif panel == 'Icon_6Panel'
             then   left    = rightIconLeft;
                    top     = nborder
                              + NGAP(1) - panelHeight('NamePanel', layout)
                              + NGAP(1) - panelHeight('InfoPanel', layout)
                              + NGAP(2) - panelHeight('Icon_4Panel', layout)
                              + NGAP(2) - panelHeight('Icon_5Panel', layout)
                              + NGAP(2);
             else   left, top = 5000, 5000;
             end; -- if panel
       elseif layout == "ABRIDGED" -- -----------------------------------------------------------------------------------------------------------
       then local iconTop = math.min(
                              -- formula #1
                              nborder
                              + NGAP(1) - panelHeight('Icon_1Panel', layout)
                              + NGAP(1) - panelHeight('StatusBarPanel', "ABRIDGED")
                              + NGAP(1),
                              -- formula #2
                              nborder
                              + NGAP(1) - panelHeight('NamePanel', layout)
                              + NGAP(1) - panelHeight('InfoPanel', layout)
                              + NGAP(1) - panelHeight('StatusBarPanel', "ABRIDGED")
                              + NGAP(1)
                            );

            if not panel
            then   left    =  border + GAP(1)
                   top     =  nborder + NGAP(1);
            elseif panel == 'NamePanel'
            then   left    =  border
                              + GAP(1) + panelWidth('Icon_1Panel', layout)
                              + GAP(1)
                   top     =  nborder
                              + NGAP(1);
            elseif panel == 'InfoPanel'
            then   left    =  border
                              + GAP(1) + panelWidth('Icon_1Panel', layout)
                              + GAP(1);
                   top     =  nborder
                              + NGAP(1) - panelHeight('NamePanel', layout)
                              + NGAP(1);
            elseif panel == 'Icon_1Panel'
            then   left    =  border + GAP(1);
                   top     =  nborder + NGAP(1);
            elseif panel == 'StatusBarPanel'
            then   left    =  border;
                   top     =  math.min(
                                -- formula #1
                                nborder
                                + NGAP(1) - panelHeight('Icon_1Panel', layout)
                                + NGAP(1),
                                -- formula #2
                                nborder
                                + NGAP(1) - panelHeight('NamePanel' , layout)
                                + NGAP(1) - panelHeight('InfoPanel', layout)
                                + NGAP(1)
                              );
            elseif panel == 'Icon_2Panel'
            then   left    =  border + GAP(1)
                   top     =  iconTop;
            elseif panel == 'Icon_3Panel'
            then   left    =  border
                              + GAP(1) + panelHeight('Icon_2Panel', layout)
                              + GAP(1);
                   top     =  iconTop;
            elseif panel == 'Icon_4Panel'
            then   left    =  border
                              + GAP(1) + panelHeight('Icon_2Panel', layout)
                              + GAP(1) + panelHeight('Icon_3Panel', layout)
                              + GAP(1);
                   top     =  iconTop;
            elseif panel == 'Icon_5Panel'
            then   left    =  border
                              + GAP(1) + panelHeight('Icon_2Panel', layout)
                              + GAP(1) + panelHeight('Icon_3Panel', layout)
                              + GAP(1) + panelHeight('Icon_4Panel', layout)
                              + GAP(1);
                   top     =  iconTop;
            elseif panel == 'Icon_6Panel'
            then   left    =  border
                              + GAP(1) + panelHeight('Icon_2Panel', layout)
                              + GAP(1) + panelHeight('Icon_3Panel', layout)
                              + GAP(1) + panelHeight('Icon_4Panel', layout)
                              + GAP(1) + panelHeight('Icon_5Panel', layout)
                              + GAP(1);
                   top     =  iconTop;
            else   left, top = 5000, 5000;
            end; -- if panel

       elseif layout == "COMPACT" -- -----------------------------------------------------------------------------------------------------------
       then
            if not panel
            then   left    =  border  + GAP(0.5);
                   top     =  nborder + NGAP(0.5);
            elseif panel == 'Icon_1Panel'
            then   left    =  border  + GAP(0.5);
                   top     =  nborder + NGAP(0.5);
            elseif panel == 'NamePanel'
            then   left    =  border
                              + GAP(0.5) + panelWidth('Icon_1Panel', layout)
                              + GAP(0.5);
                   top     =  nborder
                              + NGAP(0.5);
            elseif panel == 'InfoPanel'
            then   left    =  border
                              + GAP(0.5) + panelWidth('Icon_1Panel', layout)
                              + GAP(0.5);
                   top     =  nborder
                              + NGAP(1) - panelHeight('NamePanel', layout);
            else   left, top = 5000, 5000
            end; -- if panel
       else left, top = 5000, 5000
       end; -- if layout

    return left, top;
  end;

  local function panelTop(panel, layout)  local _,   top = panelLeftTop(panel, layout) return top;  end;
  local function panelLeft(panel, layout) local left, _  = panelLeftTop(panel, layout) return left; end;

  RPTAGS.utils.layout = RPTAGS.utils.layout or {};
  RPTAGS.utils.layout.GetFrameLayout       = frameLayout;
  RPTAGS.utils.layout.frame.resize         = resizeFrame;
  RPTAGS.utils.layout.GetFrameDimensions   = frameDimensions;

  RPTAGS.utils.layout.GetPanelHeight  = panelHeight;
  RPTAGS.utils.layout.GetPanelLeft    = panelLeft;
  RPTAGS.utils.layout.GetPanelTop     = panelTop;
  RPTAGS.utils.layout.GetPanelTopLeft = panelLeftTop;
  RPTAGS.utils.layout.GetPanelWidth   = panelWidth;

end);
