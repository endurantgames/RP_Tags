local addOnName, ns = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("MODULE_F",
function(self, event, ...)

  local layout = RPTAGS.utils.frames.RPUF_NewLayout("compact", "small");

  local function get_frame_dimensions(self)
    local a = self:Public("Gap", 0.5) + 0;
    local b = self:Public("PanelGet", "Height", "name") + 0;
    local c = self:Public("PanelGet", "Height", "info") + 0;
    local d = self:Public("ConfGet", "ICONWIDTH") + 0;
    return 
      self:Public("Gap", 1.5) + self:Public("ConfGet", "ICONWIDTH") + self:Public("ConfGet", "INFOWIDTH"),

      self:Public("Gap", 1) +
      math.max( 
        self:Public("Gap", 0.5) + self:Public("PanelGet", "Height", "name") + self:Public("PanelGet", "Height", "info"),
        self:Public("ConfGet", "ICONWIDTH")
      )
  end;

  layout:Register_Panel_Method_Hash("GetPanelLeft",
    { [ "icon1" ] = function(self) return self:Gap(0.5) end,
      [ "name"  ] = function(self) return self:Gap(1) + self:ConfGet("ICONWIDTH") end,
      [ "info"  ] = "name",
    });

  layout:Register_Panel_Method_Hash("GetPanelTop",
    { [ "icon1" ] = function(self) return self:Gap(0.5) end,
      [ "name"  ] = "icon1",
      [ "info"  ] = function(self) return self:Gap(0.5) + self:GetPanelHeight("name") end,
    });

  layout:Register_Panel_Method_Hash("GetPanelHeight",
    { [ "icon1" ] = function(self) return self:ConfGet("ICONWIDTH") end,
      [ "name"  ] = function(self) return self:CalculateFontSize() + 4 end,
      [ "info"  ] = function(self) return self:CalculateFontSize() + 2 end,
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
