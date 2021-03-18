local addOnName, ns = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("MODULE_F", 
function(self, event, ...)
  
  local layout = RPTAGS.utils.frames.RPUF_NewLayout("full", "large");

  local function get_statusBar_top(self)
    return self:Gap(1)
           + self:ConfGet("RPUF_BORDER_WIDTH") / 4
           + math.max(
               self:Gap(5) + self:ConfGet("ICONWIDTH") * 6,
               self:ConfGet("PORTWIDTH") * 1.5,
               self:Gap(3) 
               + self:Public("PanelGet", "Height", "name") 
               + self:Public("PanelGet", "Height", "info") 
               + self:ConfGet("DETAILHEIGHT")
           )
  end;

  local function get_frame_dimensions(self)
    return 
      self:Public("Gap", 4) 
      + self:Public("ConfGet", "RPUF_BORDER_WIDTH") / 2
      + self:Public("ConfGet", "ICONWIDTH") 
      + self:Public("ConfGet", "INFOWIDTH") 
      + self:Public("ConfGet", "PORTWIDTH"),
      self:Public("ConfGet", "RPUF_BORDER_WIDTH") / 2 
      -- + self:Public("Gap", 1)
      + math.max(
          self:Public("Gap", 6) 
          + self:Public("ConfGet", "ICONWIDTH") * 6 
          + self:Public("ConfGet", "STATUSHEIGHT"),
          self:Public("Gap", 3) 
          + self:Public("PanelGet", "Height", "name") 
          + self:Public("ConfGet", "DETAILHEIGHT") 
          + self:Public("ConfGet", "STATUSHEIGHT") 
          + self:Public("PanelGet", "Height", "info"),
          self:Public("ConfGet", "PORTWIDTH") * 1.5 
          + self:Public("ConfGet", "STATUSHEIGHT")
        )
  end;

  layout:Register_Panel_Method_Hash("GetPanelLeft",
    { [ "portrait"  ] = function(self) 
                          return self:Gap(2) 
                               + self:ConfGet("RPUF_BORDER_WIDTH") / 4
                               + self:ConfGet("ICONWIDTH") 
                        end,
      [ "icon1"     ] = function(self) 
                          return self:Gap(1) 
                               + self:ConfGet("RPUF_BORDER_WIDTH") / 4
                        end,
      [ "icon2"     ] = "icon1",
      [ "icon3"     ] = "icon1",
      [ "icon4"     ] = "icon1",
      [ "icon5"     ] = "icon1",
      [ "icon6"     ] = "icon1",
      [ "name"      ] = function(self) 
                          return self:Gap(3) 
                               + self:ConfGet("PORTWIDTH") 
                               + self:ConfGet("ICONWIDTH")
                               + self:ConfGet("RPUF_BORDER_WIDTH") / 4
                        end,
      [ "info"      ] = "name",
      [ "details"   ] = "name",
      [ "statusBar" ] = function(self) 
                          return self:ConfGet("RPUF_BORDER_INSETS")
                        end,
    });

  layout:Register_Panel_Method_Hash("GetPanelTop",
    { [ "portrait"  ] = function(self) 
                          return self:Gap(1) 
                                 + self:ConfGet("RPUF_BORDER_WIDTH") / 4
                        end,
      [ "icon1"     ] = "portrait",
      [ "icon2"     ] = function(self) 
                          return self:Gap(2) 
                                 + self:ConfGet("ICONWIDTH") * 1 
                                 + self:ConfGet("RPUF_BORDER_WIDTH") / 4
                        end,
      [ "icon3"     ] = function(self) 
                          return self:Gap(3) 
                                 + self:ConfGet("ICONWIDTH") * 2 
                                 + self:ConfGet("RPUF_BORDER_WIDTH") / 4
                        end,
      [ "icon4"     ] = function(self) 
                          return self:Gap(4) 
                                 + self:ConfGet("ICONWIDTH") * 3 
                                 + self:ConfGet("RPUF_BORDER_WIDTH") / 4
                        end,
      [ "icon5"     ] = function(self) 
                          return self:Gap(5) 
                                 + self:ConfGet("ICONWIDTH") * 4 
                                 + self:ConfGet("RPUF_BORDER_WIDTH") / 4
                        end,
      [ "icon6"     ] = function(self) 
                          return self:Gap(6) 
                                 + self:ConfGet("ICONWIDTH") * 5 
                                 + self:ConfGet("RPUF_BORDER_WIDTH") / 4
                        end,
      [ "name"      ] = "portrait",
      [ "info"      ] = function(self) 
                          return self:Gap(2) 
                                 + self:PanelGet("Height", "name") 
                                 + self:ConfGet("RPUF_BORDER_WIDTH") / 4
                        end,
      [ "details"   ] = function(self) 
                          return self:Gap(3)
                                 + self:PanelGet("Height", "name")
                                 + self:PanelGet("Height", "info") 
                                 + self:ConfGet("RPUF_BORDER_WIDTH") / 4
                        end,
      [ "statusBar" ] = function(self) return get_statusBar_top(self) end,
    });

  layout:Register_Panel_Method_Hash("GetPanelHeight",
    { [ "portrait"  ] = function(self) return self:ConfGet("PORTWIDTH") * 1.5 end,
      [ "icon1"     ] = function(self) return self:ConfGet("ICONWIDTH") end,
      [ "icon2"     ] = "icon1",
      [ "icon3"     ] = "icon1",
      [ "icon4"     ] = "icon1",
      [ "icon5"     ] = "icon1",
      [ "icon6"     ] = "icon1",
      [ "name"      ] = function(self) return self:CalculateFontSize() end,
      [ "info"      ] = function(self) return self:CalculateFontSize() end,
      [ "details"   ] = function(self) return self:ConfGet("DETAILHEIGHT") end,
      [ "statusBar" ] = function(self) return self:ConfGet("STATUSHEIGHT") end,
    });

  layout:Register_Panel_Method_Hash("GetPanelWidth",
    { [ "portrait"  ] = function(self) return self:ConfGet("PORTWIDTH") end,
      [ "icon1"     ] = function(self) return self:ConfGet("ICONWIDTH") + 0.5 end,
      [ "icon2"     ] = "icon1",
      [ "icon3"     ] = "icon1",
      [ "icon4"     ] = "icon1",
      [ "icon5"     ] = "icon1",
      [ "icon6"     ] = "icon1",
      [ "name"      ] = "info",
      [ "info"      ] = function(self) return self:ConfGet("INFOWIDTH") end,
      [ "details"   ] = "info",
      [ "statusBar" ] = function(self) 
                          return self:Public("ConfGet", "PORTWIDTH") 
                                 + self:Public("Gap", 4) 
                                 + self:Public("ConfGet", "ICONWIDTH") 
                                 + self:Public("ConfGet", "INFOWIDTH") 
                                 + self:Public("ConfGet", "RPUF_BORDER_WIDTH") / 2
                                 - self:Public("ConfGet", "RPUF_BORDER_INSETS") * 2
                        end,
    });

  layout:Register_Panel_Method_Hash("GetPanelVis",
    { [ "portrait"  ] = true,
      [ "icon1"     ] = true,
      [ "icon2"     ] = true,
      [ "icon3"     ] = true,
      [ "icon4"     ] = true,
      [ "icon5"     ] = true,
      [ "icon6"     ] = true,
      [ "name"      ] = true,
      [ "info"      ] = true,
      [ "details"   ] = true,
      [ "statusBar" ] = true,
    });

  layout:Register_Panel_Method("GetPanelJustifyH", function() return "LEFT" end);
  layout:Register_Panel_Method("GetPanelJustifyV", function() return "TOP"  end);

  layout:Register_Frame_Method("GetFrameDimensions", get_frame_dimensions);

  layout:RegisterLayout();
  
end);
