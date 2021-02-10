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

  print("RP_UnitFrames/Utils/layout.lua read");
Module:WaitUntil("after UTILS_FRAMES", -- depends on size functions
function(self, event, ...)

  print("RP_UnitFrames/Utils/layout.lua loading");

  local RPTAGS = RPTAGS;
  
  local CONST               = RPTAGS.CONST;
  local Utils               = RPTAGS.utils;
  local Config              = Utils.config;
  local PLAYER_FRAMENAME    = CONST.FRAMES.NAMES.PLAYER;
  local TARGET_FRAMENAME    = CONST.FRAMES.NAMES.PLAYER;
  local FOCUS_FRAMENAME     = CONST.FRAMES.NAMES.FOCUS;
  local MOUSEOVER_FRAMENAME = CONST.FRAMES.NAMES.MOUSEOVER;
  local Frames              = RPTAGS.cache.UnitFrames;
  local panelWidth          = RPTAGS.utils.frames.panels.size.getWidth;
  local panelHeight         = RPTAGS.utils.frames.panels.size.getHeight;

  local function getFrameLayout(frame)
    local frameName = frame:GetName();
    return ( frameName == PLAYER_FRAMENAME    and Config.get("PLAYERLAYOUT"    )  )
        or ( frameName == TARGET_FRAMENAME    and Config.get("TARGETLAYOUT"    )  )
        or ( frameName == FOCUS_FRAMENAME     and Config.get("FOCUSLAYOUT"     )  )
        or ( frameName == MOUSEOVER_FRAMENAME and Config.get("MOUSEOVERLAYOUT" )  )
        or "COMPACT";
  end; -- function

  local function hgap(n) return Config.get("GAPSIZE") * (n or 1);      end;
  local function vgap(n) return Config.get("GAPSIZE") * (n or 1) * -1; end;

  local function getPanelTopLeftPoint(panel, layout)
    local top, left, border, nborder;

    if   layout == "HIDDEN" then return 0, 0 end;

    if   Config.get("RPUF_BACKDROP") == "BLIZZTOOLTIP" then border = 5; nborder = -5;
    else                                                    border = 0; nborder =  0; 
    end; --if

    if   layout == "FULL"  -- -----------------------------------------------------------------------------------------------------------
    then local iconLeft = border + hgap(1);
         if not panel
         then   left    =  border + hgap(1);
                top     =  nborder + vgap(1);
         elseif panel == 'PortraitPanel'
         then   left    =  border
                           + hgap(1) + panelWidth('Icon_1Panel', layout)
                           + hgap(1);
                top     =  nborder + vgap(1);
         elseif panel == 'Icon_1Panel'
         then   left    =  iconLeft;
                top     =  nborder + vgap(1);
         elseif panel == 'Icon_2Panel'
         then   left    =  iconLeft;
                top     =  nborder
                           + vgap(1) - panelHeight('Icon_1Panel', layout)
                           + vgap(1);
         elseif panel == 'Icon_3Panel'
         then   left    =  iconLeft;
                top     =  nborder
                           + vgap(1) - panelHeight('Icon_1Panel', layout)
                           + vgap(1) - panelHeight('Icon_2Panel', layout)
                           + vgap(1);
         elseif panel == 'Icon_4Panel'
         then   left    =  iconLeft;
                top     =  nborder
                           + vgap(1) - panelHeight('Icon_1Panel', layout)
                           + vgap(1) - panelHeight('Icon_2Panel', layout)
                           + vgap(1) - panelHeight('Icon_3Panel', layout)
                           + vgap(1);
         elseif panel == 'Icon_5Panel'
         then   left    =  iconLeft;
                top     =  nborder
                           + vgap(1) - panelHeight('Icon_1Panel', layout)
                           + vgap(1) - panelHeight('Icon_2Panel', layout)
                           + vgap(1) - panelHeight('Icon_3Panel', layout)
                           + vgap(1) - panelHeight('Icon_4Panel', layout)
                           + vgap(1);
         elseif panel == 'Icon_6Panel'
         then   left    =  iconLeft;
                top     =  nborder
                           + vgap(1) - panelHeight('Icon_1Panel', layout)
                           + vgap(1) - panelHeight('Icon_2Panel', layout)
                           + vgap(1) - panelHeight('Icon_3Panel', layout)
                           + vgap(1) - panelHeight('Icon_4Panel', layout)
                           + vgap(1) - panelHeight('Icon_5Panel', layout)
                           + vgap(1);
         elseif panel == 'NamePanel'
         then   left    =  border
                           + hgap(1) + panelWidth('PortraitPanel', layout)
                           + hgap(1) + panelWidth('Icon_1Panel', layout)
                           + hgap(1);
                top     =  nborder
                           + vgap(1);
         elseif panel == 'InfoPanel'
         then   left    =  border
                           + hgap(1) + panelWidth('PortraitPanel', layout)
                           + hgap(1) + panelWidth('Icon_1Panel', layout)
                           + hgap(1);
                top     =  nborder
                           + vgap(1) - panelHeight('NamePanel', layout)
                           + vgap(1);
         elseif panel == 'DetailsPanel'
         then   left    =  border
                           + hgap(1) + panelWidth('Icon_1Panel', layout)
                           + hgap(1) + panelWidth('PortraitPanel', layout)
                           + hgap(1);
                top     =  nborder
                           + vgap(1) - panelHeight('NamePanel', layout)
                           + vgap(1) - panelHeight('InfoPanel', layout)
                           + vgap(1);
         elseif panel == 'StatusBarPanel'
         then   left    =  border;
                top     =  math.min(
                             -- formula #1
                             nborder
                             + vgap(1) - panelHeight('Icon_1Panel', layout)
                             + vgap(1) - panelHeight('Icon_2Panel', layout)
                             + vgap(1) - panelHeight('Icon_3Panel', layout)
                             + vgap(1) - panelHeight('Icon_4Panel', layout)
                             + vgap(1) - panelHeight('Icon_5Panel', layout)
                             + vgap(1) - panelHeight('Icon_6Panel', layout)
                             + vgap(1),
                             -- formula #2
                             nborder
                             + vgap(1) - panelHeight('PortraitPanel', layout),
                             -- formula #3
                             nborder
                             + vgap(1) - panelHeight('NamePanel', layout)
                             + vgap(1) - panelHeight('InfoPanel', layout)
                             + vgap(1) - panelHeight('DetailsPanel', layout)
                             + vgap(1));
         else   left  = border + hgap(1);
                top   = nborder + vgap(1);
         end; -- if panel

       elseif layout == "THUMBNAIL" -- ----------------------------------------------------------------------------------------------------------
       then if not panel               then left = border;            top = nborder;
            elseif panel == 'PortraitPanel' then left = border;            top = nborder
            elseif panel == 'NamePanel'     then left = border + hgap(1/3); 
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
       then local leftIconLeft  = border + hgap(1);
            local rightIconLeft = -- border
                                  border + panelWidth('PortraitPanel', layout)
                                  - hgap(1)
                                  - panelWidth('Icon_1Panel', layout);
            if not panel
            then   left    = border + hgap(1);
                   top     = nborder + vgap(1);
            elseif panel == 'NamePanel'
            then   left    = border
                             + hgap(1);
                   top     = nborder + vgap(1);
            elseif panel == 'InfoPanel'
            then   left    = border
                             + hgap(1)
                   top     = nborder
                             + vgap(1) - panelHeight('NamePanel', layout)
                             + vgap(1);
            elseif panel == 'PortraitPanel'
            then   left    = border
                             -- + hgap(1) + panelWidth('Icon_1Panel', layout)
                             -- + hgap(1);
                   top     = nborder
                             + vgap(1) - panelHeight('NamePanel', layout)
                             + vgap(1) - panelHeight('InfoPanel', layout)
                             + vgap(1);
            elseif panel == 'Icon_1Panel'
            then   left    = leftIconLeft;
                   top     = nborder
                             + vgap(1) - panelHeight('NamePanel', layout)
                             + vgap(1) - panelHeight('InfoPanel', layout)
                             + vgap(2);
            elseif panel == 'Icon_2Panel'
            then   left    = leftIconLeft;
                   top     = nborder
                             + vgap(1) - panelHeight('NamePanel', layout)
                             + vgap(1) - panelHeight('InfoPanel', layout)
                             + vgap(2) - panelHeight('Icon_1Panel', layout)
                             + vgap(2);
            elseif panel == 'Icon_3Panel'
            then   left    = leftIconLeft;
                   top     = nborder
                             + vgap(1) - panelHeight('NamePanel', layout)
                             + vgap(1) - panelHeight('InfoPanel', layout)
                             + vgap(2) - panelHeight('Icon_1Panel', layout)
                             + vgap(2) - panelHeight('Icon_2Panel', layout)
                             + vgap(2);
             elseif panel == 'Icon_4Panel'
             then   left    = rightIconLeft;
                    top     = nborder
                              + vgap(1) - panelHeight('NamePanel', layout)
                              + vgap(1) - panelHeight('InfoPanel', layout)
                              + vgap(2);
             elseif panel == 'Icon_5Panel'
             then   left    = rightIconLeft;
                    top     = nborder
                              + vgap(1) - panelHeight('NamePanel', layout)
                              + vgap(1) - panelHeight('InfoPanel', layout)
                              + vgap(2) - panelHeight('Icon_4Panel', layout)
                              + vgap(2);
             elseif panel == 'Icon_6Panel'
             then   left    = rightIconLeft;
                    top     = nborder
                              + vgap(1) - panelHeight('NamePanel', layout)
                              + vgap(1) - panelHeight('InfoPanel', layout)
                              + vgap(2) - panelHeight('Icon_4Panel', layout)
                              + vgap(2) - panelHeight('Icon_5Panel', layout)
                              + vgap(2);
             else   left, top = 5000, 5000;
             end; -- if panel
       elseif layout == "ABRIDGED" -- -----------------------------------------------------------------------------------------------------------
       then local iconTop = math.min(
                              -- formula #1
                              nborder
                              + vgap(1) - panelHeight('Icon_1Panel', layout)
                              + vgap(1) - panelHeight('StatusBarPanel', "ABRIDGED")
                              + vgap(1),
                              -- formula #2
                              nborder
                              + vgap(1) - panelHeight('NamePanel', layout)
                              + vgap(1) - panelHeight('InfoPanel', layout)
                              + vgap(1) - panelHeight('StatusBarPanel', "ABRIDGED")
                              + vgap(1)
                            );

            if not panel
            then   left    =  border + hgap(1)
                   top     =  nborder + vgap(1);
            elseif panel == 'NamePanel'
            then   left    =  border
                              + hgap(1) + panelWidth('Icon_1Panel', layout)
                              + hgap(1)
                   top     =  nborder
                              + vgap(1);
            elseif panel == 'InfoPanel'
            then   left    =  border
                              + hgap(1) + panelWidth('Icon_1Panel', layout)
                              + hgap(1);
                   top     =  nborder
                              + vgap(1) - panelHeight('NamePanel', layout)
                              + vgap(1);
            elseif panel == 'Icon_1Panel'
            then   left    =  border + hgap(1);
                   top     =  nborder + vgap(1);
            elseif panel == 'StatusBarPanel'
            then   left    =  border;
                   top     =  math.min(
                                -- formula #1
                                nborder
                                + vgap(1) - panelHeight('Icon_1Panel', layout)
                                + vgap(1),
                                -- formula #2
                                nborder
                                + vgap(1) - panelHeight('NamePanel' , layout)
                                + vgap(1) - panelHeight('InfoPanel', layout)
                                + vgap(1)
                              );
            elseif panel == 'Icon_2Panel'
            then   left    =  border + hgap(1)
                   top     =  iconTop;
            elseif panel == 'Icon_3Panel'
            then   left    =  border
                              + hgap(1) + panelHeight('Icon_2Panel', layout)
                              + hgap(1);
                   top     =  iconTop;
            elseif panel == 'Icon_4Panel'
            then   left    =  border
                              + hgap(1) + panelHeight('Icon_2Panel', layout)
                              + hgap(1) + panelHeight('Icon_3Panel', layout)
                              + hgap(1);
                   top     =  iconTop;
            elseif panel == 'Icon_5Panel'
            then   left    =  border
                              + hgap(1) + panelHeight('Icon_2Panel', layout)
                              + hgap(1) + panelHeight('Icon_3Panel', layout)
                              + hgap(1) + panelHeight('Icon_4Panel', layout)
                              + hgap(1);
                   top     =  iconTop;
            elseif panel == 'Icon_6Panel'
            then   left    =  border
                              + hgap(1) + panelHeight('Icon_2Panel', layout)
                              + hgap(1) + panelHeight('Icon_3Panel', layout)
                              + hgap(1) + panelHeight('Icon_4Panel', layout)
                              + hgap(1) + panelHeight('Icon_5Panel', layout)
                              + hgap(1);
                   top     =  iconTop;
            else   left, top = 5000, 5000;
            end; -- if panel

       elseif layout == "COMPACT" -- -----------------------------------------------------------------------------------------------------------
       then
            if not panel
            then   left    =  border  + hgap(0.5);
                   top     =  nborder + vgap(0.5);
            elseif panel == 'Icon_1Panel'
            then   left    =  border  + hgap(0.5);
                   top     =  nborder + vgap(0.5);
            elseif panel == 'NamePanel'
            then   left    =  border
                              + hgap(0.5) + panelWidth('Icon_1Panel', layout)
                              + hgap(0.5);
                   top     =  nborder
                              + vgap(0.5);
            elseif panel == 'InfoPanel'
            then   left    =  border
                              + hgap(0.5) + panelWidth('Icon_1Panel', layout)
                              + hgap(0.5);
                   top     =  nborder
                              + vgap(1) - panelHeight('NamePanel', layout);
            else   left, top = 5000, 5000
            end; -- if panel
       else left, top = 5000, 5000
       end; -- if layout

    return top, left;
  end;

  local function getPanelTopPoint(panel, layout)  
    local top, _ = getPanelTopLeftPoint(panel, layout) 
    return top;  
  end;
  local function getPanelLeftPoint(panel, layout) 
    local _, left = getPanelTopLeftPoint(panel, layout) 
    return left; 
  end;

  RPTAGS.utils.frames.panels.layout.getLeft    = getPanelLeftPoint;
  RPTAGS.utils.frames.panels.layout.getTop     = getPanelTopPoint;
  RPTAGS.utils.frames.panels.layout.getPoint   = getPanelTopLeftPoint;
  RPTAGS.utils.frames.layout.get               = getFrameLayout;

end);
