local addOnName, ns = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("MODULE_F",
function(self, event, ...)

  local layout = RPTAGS.utils.frames.RPUF_NewLayout("compact", "small");

  local function get_frame_dimensions(self)
    return 

      self:Public("Gap", 3) 
      + self:Public("ConfGet", "ICONWIDTH") 
      + self:Public("ConfGet", "RPUF_BORDER_WIDTH") / 2
      + self:Public("ConfGet", "INFOWIDTH"),

      self:Public("Gap", 2) 
      + self:Public("ConfGet", "RPUF_BORDER_WIDTH") / 2
      + math.max( 
        self:Public("Gap", 1) 
        + self:Public("PanelGet", "Height", "name") 
        + self:Public("PanelGet", "Height", "info"),
        self:Public("ConfGet", "ICONWIDTH")
      )
  end;

  layout:Register_Panel_Method_Hash("GetPanelLeft",
    { [ "icon1" ] = function(self) 
                      return self:Gap(1) 
                             + self:Public("ConfGet", "RPUF_BORDER_WIDTH") / 4
                    end,
      [ "name"  ] = function(self) 
                      return self:Gap(2) 
                             + self:ConfGet("ICONWIDTH") 
                             + self:Public("ConfGet", "RPUF_BORDER_WIDTH") / 4
                    end,
      [ "info"  ] = "name",
    });

  layout:Register_Panel_Method_Hash("GetPanelTop",
    { [ "icon1" ] = function(self) 
                      return self:Gap(1) 
                             + self:Public("ConfGet", "RPUF_BORDER_WIDTH") / 4
                    end,
      [ "name"  ] = "icon1",
      [ "info"  ] = function(self) 
                      return self:Gap(2) 
                             + self:Public("ConfGet", "RPUF_BORDER_WIDTH") / 4
                             + self:PanelGet("Height", "name")
                    end,
    });

  layout:Register_Panel_Method_Hash("GetPanelHeight",
    { [ "icon1" ] = function(self) return self:ConfGet("ICONWIDTH") end,
      [ "name"  ] = function(self) return self:CalculateFontSize()  end,
      [ "info"  ] = function(self) return self:CalculateFontSize()  end,
    });

  layout:Register_Panel_Method_Hash("GetPanelWidth",
    { [ "icon1" ] = function(self) return self:ConfGet("ICONWIDTH") + 0.5 end,
      [ "name"  ] = "info",
      [ "info"  ] = function(self) return self:ConfGet("INFOWIDTH") end,
    });
 
  layout:Register_Panel_Method_Hash("GetPanelVis",
    { [ "icon1" ] = true,
      [ "name"  ] = true,
      [ "info"  ] = true,
    });

  layout:Register_Panel_Method("GetPanelJustifyH", function() return "LEFT" end);
  layout:Register_Panel_Method("GetPanelJustifyV", function() return "TOP"  end);
  
  layout:Register_Frame_Method("GetFrameDimensions", get_frame_dimensions)

  layout:RegisterLayout();

  layout:RegisterAsDefault();


end);
