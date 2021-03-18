local addOnName, ns = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("MODULE_F", 
function(self, event, ...)
  
  local layout = RPTAGS.utils.frames.RPUF_NewLayout("blizzlike", "large");

  --[[
        +-------------------------------------+
        |            | Name                   |
        |            |------------------------|
        |            | Info                   |
        |            |------------------------|
        |            | Status                 |
        +----+-------+------------------------+
        | i1 |       | i2 | i3 | i4 | i5 | i6 |
        +----+       +------------------------+
  --]]

  local function get_frame_dimensions(self)
    return 
      self:Public("ConfGet", "RPUF_BORDER_INSETS") * 2
      + self:Public("ConfGet", "PORTWIDTH") * 2/3
      + self:Public("Gap", 1)
      + self:Public("ConfGet", "INFOWIDTH"),
      self:Public("ConfGet", "RPUF_BORDER_INSETS") * 2
      + math.max(
          self:Public("ConfGet", "PORTWIDTH") * 2/3,
          self:Public("Gap", 2)
          + self:Public("PanelGet", "Height", "name")
          + self:Public("PanelGet", "Height", "info")
          + self:Public("PanelGet", "Height", "statusBar")
      )
  end;

  layout:Register_Panel_Method_Hash("GetPanelLeft",
    { [ "portrait"  ] = function(self) return self:ConfGet("RPUF_BORDER_INSETS") end,
      [ "name"      ] = function(self)
                          return self:ConfGet("RPUF_BORDER_INSETS")
                                 + self:ConfGet("PORTWIDTH") * 2/3
                                 + self:Gap(0.5)
                                 + self:ConfGet("RPUF_BORDER_WIDTH") / 4
                        end,
      [ "info"      ] = "name",
      [ "statusBar" ] = function(self) 
                          return self:ConfGet("RPUF_BORDER_INSETS")
                                 + self:ConfGet("PORTWIDTH") * 2/3
                                 + self:ConfGet("RPUF_BORDER_WIDTH") / 4
                        end,
    });

  layout:Register_Panel_Method_Hash("GetPanelTop",
    { [ "portrait"  ] = function(self) 
                          return 
                            self:ConfGet("RPUF_BORDER_INSETS") 
                            - self:GetPanelHeight()
                            + math.max(
                                self:GetPanelHeight(),
                                self:PanelGet("Height", "name")
                                + self:PanelGet("Height", "info")
                                + self:PanelGet("Height", "statusBar")
                                + self:Gap(2)
                              )
                        end,
      [ "name"      ] = function(self) 
                          return self:ConfGet("RPUF_BORDER_INSETS") 
                                 + self:ConfGet("RPUF_BORDER_WIDTH") / 4
                                 + self:Gap(1) 
                        end,
      [ "info"      ] = function(self) 
                          return self:ConfGet("RPUF_BORDER_INSETS")
                                 + self:Gap(1.5)
                                 + self:ConfGet("RPUF_BORDER_WIDTH") / 4
                                 + self:PanelGet("Height", "name")
                        end,
      [ "statusBar" ] = function(self) 
                          return self:ConfGet("RPUF_BORDER_INSETS")
                                 + math.max(
                                     self:ConfGet("PORTWIDTH") * 2/3
                                     - self:GetPanelHeight(),
                                     self:PanelGet("Height", "name")
                                     + self:PanelGet("Height", "info")
                                     + self:ConfGet("RPUF_BORDER_WIDTH") / 4
                                     + self:Gap(2)
                                  )
                        end,
    });

  layout:Register_Panel_Method_Hash("GetPanelHeight",
    { [ "portrait"  ] = function(self) return self:ConfGet("PORTWIDTH") * 2/3 end,
      [ "name"      ] = function(self) return self:CalculateFontSize() end,
      [ "info"      ] = function(self) return self:CalculateFontSize() end,
      [ "statusBar" ] = function(self) 
                          return math.max(self:ConfGet("STATUSHEIGHT") * 2/3, 
                                          self:CalculateFontSize() + 2)
                        end,
    });

  layout:Register_Panel_Method_Hash("GetPanelWidth",
    { [ "portrait"  ] = function(self) return self:ConfGet("PORTWIDTH") * 2/3 end,
      [ "info"      ] = function(self) return self:ConfGet("INFOWIDTH") end,
      [ "name"      ] = "info",
      [ "statusBar" ] = function(self) 
                          return self:Gap(1) 
                                 + self:ConfGet("INFOWIDTH") 
                                 + self:ConfGet("RPUF_BORDER_INSETS")
                                 - self:ConfGet("RPUF_BORDER_WIDTH") / 4

                        end,
    });

  layout:Register_Panel_Method_Hash("GetPanelVis",
    { [ "portrait"  ] = true,
      [ "name"      ] = true,
      [ "info"      ] = true,
      [ "statusBar" ] = true,
    });

  layout:Register_Panel_Method("GetPanelJustifyH", function() return "CENTER" end);
  layout:Register_Panel_Method("GetPanelJustifyV", function() return "CENTER" end);
  layout:Register_Frame_Method("GetFrameDimensions", get_frame_dimensions);

  layout:RegisterLayout();
  
end);
