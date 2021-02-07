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

-- local oUF    = RPTAGS.oUF;

Module:WaitUntil("UTILS_FRAMES",
function(self, event, ...)

  local CONST       = RPTAGS.CONST;
  local Utils       = RPTAGS.utils; 

  local Config      = RPTAGS.utils.config;
  local Get         = RPTAGS.utils.config.get;
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
  local function VGAP(n) if not n then n = 1 end; return Config.get("GAPSIZE") * n * -1; end;

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

  local function panelHeight(panelName, layout)
    local funcMap =
    { ["NamePanel"] = 
        function() return FONTSIZE + 4 end,
      ["InfoPanel"] = 
        function() return FONTSIZE + 2 end,
      ["PortraitPanel"] = 
        function(layout) 
          local width = Get("PORTWIDTH");
          return (layout == "PAPERDOLL" and width * 2)
              or (layout == "THUMBNAIL" and width)
              or width * 1.5
        end,
      ["DetailsPanel"] =
        function()
          return Get("DETAILHEIGHT")
        end,
     ["StatusBarPanel"] =
       function()
         return Get("STATUSHEIGHT")
        end,
     ["Icon_Panel"] =
       function()
         return Get("ICONWIDTH")
        end,
    };

    local heightFunc = funcMap[panelName:gsub("%d","")];
    return heightFunc and heightFunc(layout) or 10;
  end;

  local function panelWidth(panel, layout)
    local funcMap =
    { ["NamePanel"] =
        function(layout)
          return (layout == "THUMBNAIL" and math.max(Get("PORTWIDTH") * 2/3 - GAP(2/3),
                                                     Get("ICONWIDTH") - GAP(2/3)))
              or (layout == "PAPERDOLL" and Get("PORTWIDTH") * 1.5 - GAP(2))
              or Get("INFOWIDTH")
        end,
       ["InfoPanel"] =
         function(layout)
           return (layout == "PAPERDOLL" and Get("PORTWIDTH") * 1.5 - GAP(2))
               or Get("INFOWIDTH")
         end,
      ["PortraitPanel"] =
        function(layout)
          return (layout == "PAPERDOLL" and Get("PORTWIDTH") * 1.5)
              or (layout == "THUMBNAIL" and Get("PORTWIDTH") * 2/3)
              or Get("PORTWIDTH")
        end,
      ["DetailsPanel"] = function() return Get("INFOWIDTH") end,
      ["StatusBarPanel"] =
        function(layout)
          local iconWidth = Get("ICONWIDTH");
          return (layout == "FULL" and Get("PORTWIDTH") + GAP(1) + iconWidth + GAP(1) + iconWidth + GAP(2))
              or (layout == "ABRIDGED" and math.max( iconWidth + GAP(0.75) + Get("INFOWIDTH") + GAP(2.75), 
                                                     iconWidth + GAP(0.75) + iconWidth + GAP(0.75) + iconWidth 
                                                      + GAP(0.75) + iconWidth + GAP(0.75) + iconWidth + GAP(3)))
              or 0
        end,
      ["Icon_Panel"] function() return Get("ICONWIDTH") end,
    };

    local widthFunc = funcMap[panelName:gsub("%d","")]
    return widthFunc and widthFunc(layout) or 10;
  end;

  local function frameDimensions(layout)
    local funcMap =
    { ["HIDDEN"] = function() return 0, 0 end,
      ["FULL"] =
        function(layout, border)
          local iconWidth = panelWidth("Icon_1Panel", layout);
          local iconHeight = panelHeight("Icon_1Panel", layout);
          return 
             border 
               + GAP(1) + iconWidth + GAP(1) + panelWidth('InfoPanel', layout)
               + GAP(1) + panelWidth('PortraitPanel', layout) + GAP(1) + border,
             math.max(
               border + GAP(1) + 6 * (iconHeight + GAP(1)) + panelHeight('StatusBarPanel', "FULL") + border, 
               border + GAP(1) + panelHeight('NamePanel', layout) + GAP(1) + panelHeight('DetailsPanel', layout)
                 + panelHeight('StatusBarPanel', "FULL") + GAP(1) + panelHeight('InfoPanel', layout) + GAP(1) + border,
               border + GAP(1) + panelHeight('PortraitPanel', layout) + panelHeight('StatusBarPanel', "FULL") + border
               )
        end,
      ["THUMBNAIL"] =
        function(layout, border)
          return 
            math.max(
              border + panelWidth('PortraitPanel', layout)  + border, 
              border + panelWidth('Icon_1Panel', layout) + border),
            math.max(
              border + panelHeight('Icon_1Panel', layout) + panelHeight('NamePanel', layout) + border,
              border + panelHeight('PortraitPanel', layout) + border)
        end,
      ["PAPERDOLL"] = 
        function(layout, border)
          local iconHeight = panelHeight("Icon_1Panel", layout);
          return 
            border + panelWidth('PortraitPanel', layout) + border,
            math.max(
              border
                + GAP(1) + panelHeight('NamePanel', layout) + GAP(1) + panelHeight('InfoPanel', layout)
                + GAP(1) + panelHeight('PortraitPanel', layout) + border,
              border
                + GAP(1) + panelHeight('NamePanel', layout) + GAP(1) + panelHeight('InfoPanel', layout)
                + GAP(2) + iconHeight + GAP(2) + iconHeight + GAP(2) + iconHeight + GAP(1) + border)
        end,
     ["ABRIDGED"] =
       function(layout, border)
         local iconWidth = panelWidth("Icon_1Panel", layout);
         local iconHeight = panelHeight("Icon_1Panel", layout);
         return
            math.max(
              border + GAP(1) + iconWidth + GAP(1) + panelWidth('NamePanel', layout) + GAP(1) + border,
              border + GAP(1) + iconWidth + GAP(1) + panelWidth('InfoPanel', layout) + GAP(1) + border,
              border + panelWidth('StatusBarPanel', layout) + border,
              border + GAP(1) + 5 * (iconWidth + GAP(1)) + border),
            math.max(
              border + GAP(1) + iconHeight + GAP(1) + panelHeight('StatusBarPanel', layout) 
                + GAP(1) + iconHeight + GAP(1) + border,
              border + GAP(1) + panelHeight('NamePanel' , layout) + GAP(1) + panelHeight('InfoPanel', layout)
                + GAP(1) + panelHeight('StatusBarPanel', "ABRIDGED") + GAP(1) + iconHeight + GAP(1) + border)
       end
     ["COMPACT"] = 
       function(layout, border)
         return
           border + GAP(0.5) + panelWidth('Icon_1Panel', layout) + GAP(0.5) + panelWidth('NamePanel', layout) + GAP(0.5) + border,
           math.max(
             border + GAP(0.5) + panelHeight('NamePanel', layout) + GAP(0.5) + panelHeight('InfoPanel', layout) + GAP(0.5) + border,
             border + GAP(0.5) + panelHeight('Icon_1Panel', layout) + GAP(0.5) + border)
      end,
    };

    local widthHeightFunc = funcMap[layout];
    if widthHeightFunc
    then local width, height = widthHeightFunc(layout, Get("RPUF_BACKDROP") == "BLIZZTOOLTIP" and 6 or 0);
         return width, height;
    else return 10, 10;
    end;
    
  end;

  local function frameLayoutData(frame)

    local left, top, border, nborder;

    if   layout == "HIDDEN" then return 0, 0 end;

    if   Config.get("RPUF_BACKDROP") == "BLIZZTOOLTIP" then border = 5; nborder = -5;
    else                                                    border = 0; nborder =  0; 
    end; --if

    local funcMap = 
    { ["FULL"] = 
        function(f, g, h, v)
          return 
            { { f.Icon_1Panel,  "TOPLEFT", f, "TOPLEFT", b, b * -1 },
              { f.PortraitPanel, "TOPLEFT", f.Icon_1Panel, "TOPRIGHT", g, 0 },
              { f.Icon_2Panel,  "TOP", f.Icon_1Panel, "BOTTOM", 0, g },
              { f.Icon_3Panel,  "TOP", f.Icon_2Panel, "BOTTOM", 0, g },
              { f.Icon_4Panel,  "TOP", f.Icon_3Panel, "BOTTOM", 0, g },
              { f.Icon_5Panel,  "TOP", f.Icon_4Panel, "BOTTOM", 0, g },
              { f.Icon_6Panel,  "TOP", f.Icon_5Panel, "BOTTOM", 0, g },
              { f.NamePanel, "TOPLEFT", f.PortraitPanel, "TOPRIGHT", g, 0 },
              { f.InfoPanel, "TOPLEFT", f.NamePanel, "BOTTOMLEFT", 0, g },
              { f.DetailsPanel, "TOPLEFT", f.InfoPanel, "BOTTOMLEFT", 0, g },
              { f.StatusBarPanel, "TOPLEFT", v.DetailsPanel, "BOTTOMLEFT", 0, g }
            }
        end,
      ["THUMBNAIL"] =
        function(f, g, b)
          return
          { { f.PortraitPanel, "TOPLEFT", f, "TOPLEFT", b, b * -1 },
            { f.Icon_1Panel, "TOPLEFT", f.PortraitPanel, "BOTTOMRIGHT", 0, g },
            { f.NamePanel, "TOPLEFT", f.Icon_1Panel, "TOPRIGHT", g, 0 },
          },
      ["PAPERDOLL"] =
       then local leftIconLeft  = h + GAP(1);
            local rightIconLeft = -- h
                                  h + panelWidth('PortraitPanel', layout)
                                  - GAP(1)
                                  - panelWidth('Icon_1Panel', layout);
            if not panel
            then   left    = h + GAP(1);
                   top     = v + VGAP(1);
            elseif panel == 'NamePanel'
            then   left    = h
                             + GAP(1);
                   top     = v + VGAP(1);
            elseif panel == 'InfoPanel'
            then   left    = h
                             + GAP(1)
                   top     = v
                             + VGAP(1) - panelHeight('NamePanel', layout)
                             + VGAP(1);
            elseif panel == 'PortraitPanel'
            then   left    = h
                             -- + GAP(1) + panelWidth('Icon_1Panel', layout)
                             -- + GAP(1);
                   top     = v
                             + VGAP(1) - panelHeight('NamePanel', layout)
                             + VGAP(1) - panelHeight('InfoPanel', layout)
                             + VGAP(1);
            elseif panel == 'Icon_1Panel'
            then   left    = leftIconLeft;
                   top     = v
                             + VGAP(1) - panelHeight('NamePanel', layout)
                             + VGAP(1) - panelHeight('InfoPanel', layout)
                             + VGAP(2);
            elseif panel == 'Icon_2Panel'
            then   left    = leftIconLeft;
                   top     = v
                             + VGAP(1) - panelHeight('NamePanel', layout)
                             + VGAP(1) - panelHeight('InfoPanel', layout)
                             + VGAP(2) - panelHeight('Icon_1Panel', layout)
                             + VGAP(2);
            elseif panel == 'Icon_3Panel'
            then   left    = leftIconLeft;
                   top     = v
                             + VGAP(1) - panelHeight('NamePanel', layout)
                             + VGAP(1) - panelHeight('InfoPanel', layout)
                             + VGAP(2) - panelHeight('Icon_1Panel', layout)
                             + VGAP(2) - panelHeight('Icon_2Panel', layout)
                             + VGAP(2);
             elseif panel == 'Icon_4Panel'
             then   left    = rightIconLeft;
                    top     = v
                              + VGAP(1) - panelHeight('NamePanel', layout)
                              + VGAP(1) - panelHeight('InfoPanel', layout)
                              + VGAP(2);
             elseif panel == 'Icon_5Panel'
             then   left    = rightIconLeft;
                    top     = v
                              + VGAP(1) - panelHeight('NamePanel', layout)
                              + VGAP(1) - panelHeight('InfoPanel', layout)
                              + VGAP(2) - panelHeight('Icon_4Panel', layout)
                              + VGAP(2);
             elseif panel == 'Icon_6Panel'
             then   left    = rightIconLeft;
                    top     = v
                              + VGAP(1) - panelHeight('NamePanel', layout)
                              + VGAP(1) - panelHeight('InfoPanel', layout)
                              + VGAP(2) - panelHeight('Icon_4Panel', layout)
                              + VGAP(2) - panelHeight('Icon_5Panel', layout)
                              + VGAP(2);
             else   left, top = 5000, 5000;
             end; -- if panel
       elseif layout == "ABRIDGED" -- -----------------------------------------------------------------------------------------------------------
       then local iconTop = math.min(
                              -- formula #1
                              v
                              + VGAP(1) - panelHeight('Icon_1Panel', layout)
                              + VGAP(1) - panelHeight('StatusBarPanel', "ABRIDGED")
                              + VGAP(1),
                              -- formula #2
                              v
                              + VGAP(1) - panelHeight('NamePanel', layout)
                              + VGAP(1) - panelHeight('InfoPanel', layout)
                              + VGAP(1) - panelHeight('StatusBarPanel', "ABRIDGED")
                              + VGAP(1)
                            );

            if not panel
            then   left    =  h + GAP(1)
                   top     =  v + VGAP(1);
            elseif panel == 'NamePanel'
            then   left    =  h
                              + GAP(1) + panelWidth('Icon_1Panel', layout)
                              + GAP(1)
                   top     =  v
                              + VGAP(1);
            elseif panel == 'InfoPanel'
            then   left    =  h
                              + GAP(1) + panelWidth('Icon_1Panel', layout)
                              + GAP(1);
                   top     =  v
                              + VGAP(1) - panelHeight('NamePanel', layout)
                              + VGAP(1);
            elseif panel == 'Icon_1Panel'
            then   left    =  h + GAP(1);
                   top     =  v + VGAP(1);
            elseif panel == 'StatusBarPanel'
            then   left    =  h;
                   top     =  math.min(
                                -- formula #1
                                v
                                + VGAP(1) - panelHeight('Icon_1Panel', layout)
                                + VGAP(1),
                                -- formula #2
                                v
                                + VGAP(1) - panelHeight('NamePanel' , layout)
                                + VGAP(1) - panelHeight('InfoPanel', layout)
                                + VGAP(1)
                              );
            elseif panel == 'Icon_2Panel'
            then   left    =  h + GAP(1)
                   top     =  iconTop;
            elseif panel == 'Icon_3Panel'
            then   left    =  h
                              + GAP(1) + panelHeight('Icon_2Panel', layout)
                              + GAP(1);
                   top     =  iconTop;
            elseif panel == 'Icon_4Panel'
            then   left    =  h
                              + GAP(1) + panelHeight('Icon_2Panel', layout)
                              + GAP(1) + panelHeight('Icon_3Panel', layout)
                              + GAP(1);
                   top     =  iconTop;
            elseif panel == 'Icon_5Panel'
            then   left    =  h
                              + GAP(1) + panelHeight('Icon_2Panel', layout)
                              + GAP(1) + panelHeight('Icon_3Panel', layout)
                              + GAP(1) + panelHeight('Icon_4Panel', layout)
                              + GAP(1);
                   top     =  iconTop;
            elseif panel == 'Icon_6Panel'
            then   left    =  h
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
            then   left    =  h  + GAP(0.5);
                   top     =  v + VGAP(0.5);
            elseif panel == 'Icon_1Panel'
            then   left    =  h  + GAP(0.5);
                   top     =  v + VGAP(0.5);
            elseif panel == 'NamePanel'
            then   left    =  h
                              + GAP(0.5) + panelWidth('Icon_1Panel', layout)
                              + GAP(0.5);
                   top     =  v
                              + VGAP(0.5);
            elseif panel == 'InfoPanel'
            then   left    =  h
                              + GAP(0.5) + panelWidth('Icon_1Panel', layout)
                              + GAP(0.5);
                   top     =  v
                              + VGAP(1) - panelHeight('NamePanel', layout);
            else   left, top = 5000, 5000
            end; -- if panel
       else left, top = 5000, 5000
       end; -- if layout
     -- beep
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
