-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 

local addOnName, addOn = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("after MODULE_E", -- depends on size functions
function(self, event, ...)

  local RPTAGS = RPTAGS;
  
  local CONST               = RPTAGS.CONST;
  local Utils               = RPTAGS.utils;
  local Config              = Utils.config;
  local PLAYER_FRAMENAME    = CONST.FRAMES.NAMES.PLAYER;
  local TARGET_FRAMENAME    = CONST.FRAMES.NAMES.PLAYER;
  local FOCUS_FRAMENAME     = CONST.FRAMES.NAMES.FOCUS;
  local MOUSEOVER_FRAMENAME = CONST.FRAMES.NAMES.MOUSEOVER;
  local panelWidth          = RPTAGS.utils.frames.panels.size.getWidth;
  local panelHeight         = RPTAGS.utils.frames.panels.size.getHeight;

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
         elseif panel == 'portrait'
         then   left    =  border
                           + hgap(1) + panelWidth('icon1', layout)
                           + hgap(1);
                top     =  nborder + vgap(1);
         elseif panel == 'icon1'
         then   left    =  iconLeft;
                top     =  nborder + vgap(1);
         elseif panel == 'icon2'
         then   left    =  iconLeft;
                top     =  nborder
                           + vgap(1) - panelHeight('icon1', layout)
                           + vgap(1);
         elseif panel == 'icon3'
         then   left    =  iconLeft;
                top     =  nborder
                           + vgap(1) - panelHeight('icon1', layout)
                           + vgap(1) - panelHeight('icon2', layout)
                           + vgap(1);
         elseif panel == 'icon4'
         then   left    =  iconLeft;
                top     =  nborder
                           + vgap(1) - panelHeight('icon1', layout)
                           + vgap(1) - panelHeight('icon2', layout)
                           + vgap(1) - panelHeight('icon3', layout)
                           + vgap(1);
         elseif panel == 'icon5'
         then   left    =  iconLeft;
                top     =  nborder
                           + vgap(1) - panelHeight('icon1', layout)
                           + vgap(1) - panelHeight('icon2', layout)
                           + vgap(1) - panelHeight('icon3', layout)
                           + vgap(1) - panelHeight('icon4', layout)
                           + vgap(1);
         elseif panel == 'icon6'
         then   left    =  iconLeft;
                top     =  nborder
                           + vgap(1) - panelHeight('icon1', layout)
                           + vgap(1) - panelHeight('icon2', layout)
                           + vgap(1) - panelHeight('icon3', layout)
                           + vgap(1) - panelHeight('icon4', layout)
                           + vgap(1) - panelHeight('icon5', layout)
                           + vgap(1);
         elseif panel == 'name'
         then   left    =  border
                           + hgap(1) + panelWidth('portrait', layout)
                           + hgap(1) + panelWidth('icon1', layout)
                           + hgap(1);
                top     =  nborder
                           + vgap(1);
         elseif panel == 'info'
         then   left    =  border
                           + hgap(1) + panelWidth('portrait', layout)
                           + hgap(1) + panelWidth('icon1', layout)
                           + hgap(1);
                top     =  nborder
                           + vgap(1) - panelHeight('name', layout)
                           + vgap(1);
         elseif panel == 'details'
         then   left    =  border
                           + hgap(1) + panelWidth('icon1', layout)
                           + hgap(1) + panelWidth('portrait', layout)
                           + hgap(1);
                top     =  nborder
                           + vgap(1) - panelHeight('name', layout)
                           + vgap(1) - panelHeight('info', layout)
                           + vgap(1);
         elseif panel == 'statusBar'
         then   left    =  border;
                top     =  math.min(
                             -- formula #1
                             nborder
                             + vgap(1) - panelHeight('icon1', layout)
                             + vgap(1) - panelHeight('icon2', layout)
                             + vgap(1) - panelHeight('icon3', layout)
                             + vgap(1) - panelHeight('icon4', layout)
                             + vgap(1) - panelHeight('icon5', layout)
                             + vgap(1) - panelHeight('icon6', layout)
                             + vgap(1),
                             -- formula #2
                             nborder
                             + vgap(1) - panelHeight('portrait', layout),
                             -- formula #3
                             nborder
                             + vgap(1) - panelHeight('name', layout)
                             + vgap(1) - panelHeight('info', layout)
                             + vgap(1) - panelHeight('details', layout)
                             + vgap(1));
         else   left  = border + hgap(1);
                top   = nborder + vgap(1);
         end; -- if panel

       elseif layout == "THUMBNAIL" -- ----------------------------------------------------------------------------------------------------------
       then if not panel               then left = border;            top = nborder;
            elseif panel == 'portait' then left = border;            top = nborder
            elseif panel == 'name'     then left = border + hgap(1/3); 
                                                   top  = math.min(
                                                            -- formula #1
                                                            nborder - panelHeight('portrait', layout) + panelHeight('name', layout),
                                                            -- formula #2
                                                            nborder - panelHeight('icon1', layout)
                                                            );
            elseif panel == 'icon1'   then left = border; top = nborder;
            else                              left = 5000;              top = 5000;
            end -- if panel

       elseif layout == "PAPERDOLL" -- ----------------------------------------------------------------------------------------------------------
       then local leftIconLeft  = border + hgap(1);
            local rightIconLeft = -- border
                                  border + panelWidth('portrait', layout)
                                  - hgap(1)
                                  - panelWidth('icon1', layout);
            if not panel
            then   left    = border + hgap(1);
                   top     = nborder + vgap(1);
            elseif panel == 'name'
            then   left    = border
                             + hgap(1);
                   top     = nborder + vgap(1);
            elseif panel == 'info'
            then   left    = border
                             + hgap(1)
                   top     = nborder
                             + vgap(1) - panelHeight('name', layout)
                             + vgap(1);
            elseif panel == 'portrait'
            then   left    = border
                             -- + hgap(1) + panelWidth('icon1', layout)
                             -- + hgap(1);
                   top     = nborder
                             + vgap(1) - panelHeight('name', layout)
                             + vgap(1) - panelHeight('info', layout)
                             + vgap(1);
            elseif panel == 'icon1'
            then   left    = leftIconLeft;
                   top     = nborder
                             + vgap(1) - panelHeight('name', layout)
                             + vgap(1) - panelHeight('info', layout)
                             + vgap(2);
            elseif panel == 'icon2'
            then   left    = leftIconLeft;
                   top     = nborder
                             + vgap(1) - panelHeight('name', layout)
                             + vgap(1) - panelHeight('info', layout)
                             + vgap(2) - panelHeight('icon1', layout)
                             + vgap(2);
            elseif panel == 'icon3'
            then   left    = leftIconLeft;
                   top     = nborder
                             + vgap(1) - panelHeight('name', layout)
                             + vgap(1) - panelHeight('info', layout)
                             + vgap(2) - panelHeight('icon1', layout)
                             + vgap(2) - panelHeight('icon2', layout)
                             + vgap(2);
             elseif panel == 'icon4'
             then   left    = rightIconLeft;
                    top     = nborder
                              + vgap(1) - panelHeight('name', layout)
                              + vgap(1) - panelHeight('info', layout)
                              + vgap(2);
             elseif panel == 'icon5'
             then   left    = rightIconLeft;
                    top     = nborder
                              + vgap(1) - panelHeight('name', layout)
                              + vgap(1) - panelHeight('info', layout)
                              + vgap(2) - panelHeight('icon4', layout)
                              + vgap(2);
             elseif panel == 'icon6'
             then   left    = rightIconLeft;
                    top     = nborder
                              + vgap(1) - panelHeight('name', layout)
                              + vgap(1) - panelHeight('info', layout)
                              + vgap(2) - panelHeight('icon4', layout)
                              + vgap(2) - panelHeight('icon5', layout)
                              + vgap(2);
             else   left, top = 5000, 5000;
             end; -- if panel
       elseif layout == "ABRIDGED" -- -----------------------------------------------------------------------------------------------------------
       then local iconTop = math.min(
                              -- formula #1
                              nborder
                              + vgap(1) - panelHeight('icon1', layout)
                              + vgap(1) - panelHeight('statusBar', "ABRIDGED")
                              + vgap(1),
                              -- formula #2
                              nborder
                              + vgap(1) - panelHeight('name', layout)
                              + vgap(1) - panelHeight('info', layout)
                              + vgap(1) - panelHeight('statusBar', "ABRIDGED")
                              + vgap(1)
                            );

            if not panel
            then   left    =  border + hgap(1)
                   top     =  nborder + vgap(1);
            elseif panel == 'name'
            then   left    =  border
                              + hgap(1) + panelWidth('icon1', layout)
                              + hgap(1)
                   top     =  nborder
                              + vgap(1);
            elseif panel == 'info'
            then   left    =  border
                              + hgap(1) + panelWidth('icon1', layout)
                              + hgap(1);
                   top     =  nborder
                              + vgap(1) - panelHeight('name', layout)
                              + vgap(1);
            elseif panel == 'icon1'
            then   left    =  border + hgap(1);
                   top     =  nborder + vgap(1);
            elseif panel == 'statusBar'
            then   left    =  border;
                   top     =  math.min(
                                -- formula #1
                                nborder
                                + vgap(1) - panelHeight('icon1', layout)
                                + vgap(1),
                                -- formula #2
                                nborder
                                + vgap(1) - panelHeight('name' , layout)
                                + vgap(1) - panelHeight('info', layout)
                                + vgap(1)
                              );
            elseif panel == 'icon2'
            then   left    =  border + hgap(1)
                   top     =  iconTop;
            elseif panel == 'icon3'
            then   left    =  border
                              + hgap(1) + panelHeight('icon2', layout)
                              + hgap(1);
                   top     =  iconTop;
            elseif panel == 'icon4'
            then   left    =  border
                              + hgap(1) + panelHeight('icon2', layout)
                              + hgap(1) + panelHeight('icon3', layout)
                              + hgap(1);
                   top     =  iconTop;
            elseif panel == 'icon5'
            then   left    =  border
                              + hgap(1) + panelHeight('icon2', layout)
                              + hgap(1) + panelHeight('icon3', layout)
                              + hgap(1) + panelHeight('icon4', layout)
                              + hgap(1);
                   top     =  iconTop;
            elseif panel == 'icon6'
            then   left    =  border
                              + hgap(1) + panelHeight('icon2', layout)
                              + hgap(1) + panelHeight('icon3', layout)
                              + hgap(1) + panelHeight('icon4', layout)
                              + hgap(1) + panelHeight('icon5', layout)
                              + hgap(1);
                   top     =  iconTop;
            end; -- if panel

       elseif layout == "COMPACT" -- -----------------------------------------------------------------------------------------------------------
       then
            if not panel
            then   left    =  border  + hgap(0.5);
                   top     =  nborder + vgap(0.5);
            elseif panel == 'icon1'
            then   left    =  border  + hgap(0.5);
                   top     =  nborder + vgap(0.5);
            elseif panel == 'name'
            then   left    =  border
                              + hgap(0.5) + panelWidth('icon1', layout)
                              + hgap(0.5);
                   top     =  nborder
                              + vgap(0.5);
            elseif panel == 'info'
            then   left    =  border
                              + hgap(0.5) + panelWidth('icon1', layout)
                              + hgap(0.5);
                   top     =  nborder
                              + vgap(1) - panelHeight('name', layout);
            end; -- if panel
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

end);
