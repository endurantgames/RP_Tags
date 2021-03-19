local addOnName, ns = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("MODULE_F", 
function(self, event, ...)
  
  local layout = RPTAGS.utils.frames.RPUF_NewLayout("blizzlike", "small");

  --[[
        +-------------------------------------+
        |            | Name                   |
        |            |------------------------|
        |            | Info                   |
        |            |------------------------|
        |            | Status                 |
        +-------------------------------------+
  --]]

  local function stackHeight(self)
    return 
      math.max(
        self:Public("ConfGet", "PORTWIDTH") * 1/2,
        self:Public("Gap", 1.5)
        + self:Public("PanelGet", "Height", "name")
        + self:Public("PanelGet", "Height", "info")
        + self:Public("PanelGet", "Height", "statusBar")
      )
  end;

  local function get_frame_dimensions(self)
    return 
      stackHeight(self) + self:Public("ConfGet", "INFOWIDTH") * 2/3 + self:Public("ConfGet", "RPUF_BORDER_WIDTH") / 4,
      stackHeight(self) + self:Public("ConfGet", "RPUF_BORDER_WIDTH") / 2
  end; 

  layout:Register_Panel_Method_Hash("GetPanelLeft",
    { [ "portrait"  ] = function(self) return self:Gap(-6)  end,
      [ "name"      ] = function(self) 
                          return 
                            stackHeight(self) 
                            + self:ConfGet("RPUF_BORDER_WIDTH") / 4 
                            + self:Gap(1)
                        end,
      [ "info"      ] = "name",
      [ "statusBar" ] = function(self) return stackHeight(self) + self:ConfGet("RPUF_BORDER_WIDTH") / 4 end,
    });

  layout:Register_Panel_Method_Hash("GetPanelTop",
    { [ "portrait"  ] = function(self) return self:Gap(-3) end, -- + self:ConfGet("RPUF_BORDER_WIDTH") / 4 end,
      [ "name"      ] = function(self) 
                          return self:ConfGet("RPUF_BORDER_WIDTH") / 4
                                 + self:Gap(0.5) 
                        end,
      [ "info"      ] = function(self) 
                          return self:Gap(1.0)
                                 + self:ConfGet("RPUF_BORDER_WIDTH") / 4
                                 + self:PanelGet("Height", "name")
                        end,
      [ "statusBar" ] = function(self) 
                          return 
                                 self:PanelGet("Height", "name")
                               + self:PanelGet("Height", "info")
                               + self:Gap(1.5)
                               + self:ConfGet("RPUF_BORDER_WIDTH") / 4
                        end,
    });

  layout:Register_Panel_Method_Hash("GetPanelHeight",
    { [ "portrait"  ] = function(self) return stackHeight(self) + self:Gap(6) + self:ConfGet("RPUF_BORDER_WIDTH") / 2 end,
      [ "name"      ] = function(self) return self:CalculateFontSize() end,
      [ "info"      ] = function(self) return self:CalculateFontSize() end,
      [ "statusBar" ] = function(self) return math.max(self:ConfGet("STATUSHEIGHT") * 2/3, self:CalculateFontSize()) end,
    });

  layout:Register_Panel_Method_Hash("GetPanelWidth",
    { [ "portrait"  ] = function(self) return stackHeight(self) + self:Gap(6) + self:ConfGet("RPUF_BORDER_WIDTH") / 2 end,
      [ "info"      ] = function(self) 
                          return self:ConfGet("INFOWIDTH") * 2/3 
                                 - self:ConfGet("RPUF_BORDER_WIDTH") / 4 
                                 - self:Gap(1.5)
                        end,
      [ "name"      ] = "info",
      [ "statusBar" ] = function(self) return self:ConfGet("INFOWIDTH") * 2/3 - self:ConfGet("RPUF_BORDER_WIDTH") / 4 end,
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

  layout:SetMoverOffset("mover", function(self) return stackHeight(self) + self:Public("Gap", 4), 0 end);

  layout:RegisterLayout();
  
end);
