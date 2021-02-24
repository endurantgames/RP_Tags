local addOnName, ns = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("MODULE_F", 
function(self, event, ...)
  
  local layout = RPTAGS.utils.frames.RPUF_NewLayout("full", "large");

  local function get_statusBar_top(self)
    return
      math.max(
        self:Gap(7) + self:ConfGet("ICONWIDTH") * 6,
        self:Gap(1) + self:ConfGet("PORTWIDTH") * 1.5,
        self:Gap(4) * self:PanelGet("Height", "name") + self:PanelGet("Height", "info") + self:ConfGet("DETAILHEIGHT")
      )
  end;

  local function get_frame_dimensions(self)
    return
      self:Gap(4) + self:ConfGet("ICONWIDTH") + self:ConfGet("INFOWIDTH") + self:ConfGet("PORTWIDTH"),
      math.max(
        self:Gap(7) + self:ConfGet("ICONWIDTH") * 6 + self:ConfGet("STATUSHEIGHT"),
        self:Gap(4) + self:PanelGet("Height", "name") + self:ConfGet("DETAILHEIGHT") + self:ConfGet("STATUSHEIGHT") + self:PanelGet("Height", "info"),
        self:Gap(1) + self:ConfGet("PORTWIDTH") * 1.5 + self:ConfGet("STATUSHEIGHT")
      )
  end;

  layout:Register_Panel_Method_Hash("GetPanelLeft",
    { [ "portrait"  ] = function(self) return self:Gap(2) + self:PanelGet("Width", "icon") end,
      [ "icon1"     ] = function(self) return self:Gap(1) end,
      [ "icon2"     ] = "icon1",
      [ "icon3"     ] = "icon1",
      [ "icon4"     ] = "icon1",
      [ "icon5"     ] = "icon1",
      [ "icon6"     ] = "icon1",
      [ "name"      ] = function(self) return self:Gap(3) + self:PanelGet("Width", "portrait") + self:PanelGet("Width", "icon1") end,
      [ "info"      ] = "name",
      [ "details"   ] = "name",
      [ "statusBar" ] = 0,
    });

  layout:Register_Panel_Method_Hash("GetPanelTop",
    { [ "portrait"  ] = function(self) return self:Gap(1) end,
      [ "icon1"     ] = function(self) return self:Gap(1) end,
      [ "icon2"     ] = function(self) return self:Gap(2) + self:ConfGet("ICONWIDTH") * 1, end,
      [ "icon3"     ] = function(self) return self:Gap(3) + self:ConfGet("ICONWIDTH") * 2, end,
      [ "icon4"     ] = function(self) return self:Gap(4) + self:ConfGet("ICONWIDTH") * 3, end,
      [ "icon5"     ] = function(self) return self:Gap(5) + self:ConfGet("ICONWIDTH") * 4, end,
      [ "icon6"     ] = function(self) return self:Gap(6) + self:ConfGet("ICONWIDTH") * 5, end,
      [ "name"      ] =  "portrait",
      [ "info"      ] = function(self) return self:Gap(2) + self:PanelGet("Height", "name") end,
      [ "details"   ] = function(self) return self:PanelGet("Top", "info") + Gap(1) + self:PanelGet("Height", "info") end,
      [ "statusBar" ] = get_statusBar_top,
    });

  layout:Register_Panel_Method_Hash("GetPanelHeight",
    { [ "portrait"  ] = function(self) return self:ConfGet("PORTWIDTH") * 1.5 end,
      [ "icon1"     ] = function(self) return self:ConfGet("ICONWIDTH") end,
      [ "icon2"     ] = "icon1",
      [ "icon3"     ] = "icon1",
      [ "icon4"     ] = "icon1",
      [ "icon5"     ] = "icon1",
      [ "icon6"     ] = "icon1",
      [ "name"      ] = function(self) return self:GetActualFontSize() + 4 end,
      [ "info"      ] = function(self) return self:GetActualFontSize() + 2 end,
      [ "details"   ] = function(self) return self:ConfGet("DETAILHEIGHT") end,
      [ "statusBar" ] = function(self) return self:ConfGet("STATUSHEIGHT") end,
    });

  layout:Register_Panel_Method_Hash("GetPanelWidth",
    { [ "portrait"  ] = function(self) return self:ConfGet("PORTWIDTH") end,
      [ "icon1"     ] = function(self) return self:ConfGet("ICONWIDTH") end,
      [ "icon2"     ] = "icon1",
      [ "icon3"     ] = "icon1",
      [ "icon4"     ] = "icon1",
      [ "icon5"     ] = "icon1",
      [ "icon6"     ] = "icon1",
      [ "name"      ] = "info",
      [ "info"      ] = function(self) return self:ConfGet("INFOWIDTH") end,
      [ "details"   ] = "info",
      [ "statusBar" ] = function(self) return self:ConfGet("PORTWIDTH") + self:Gap(4) + self:ConfGet("ICONWIDTH") end,
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
