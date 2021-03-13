local addOnName, ns = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("MODULE_F",
function(self, event, ...)

  local layout = RPTAGS.utils.frames.RPUF_NewLayout("abridged", "large");

  local function get_statusBar_top(self)
    return
      math.min(
        self:Gap(2) + self:ConfGet("ICONWIDTH"),
        self:Gap(3) + self:PanelGet("Height", "name") + self:PanelGet("Height", "info")
      )
  end;

  local function get_icon_top(self)
    return
      self:Gap(3) + 
        self:PanelGet("Height", "statusBar") +
      math.max( 
        self:ConfGet("ICONWIDTH"),
        self:PanelGet("Height", "name") + self:PanelGet("Height", "info") + self:Gap(1)
      )
  end;

  local function get_statusBar_width(self)
    return
      self:Public("ConfGet", "ICONWIDTH") + self:Public("Gap", 3.5) +
      math.max(self:Public("ConfGet", "INFOWIDTH"), self:Public("ConfGet", "ICONWIDTH") * 5 + self:Public("Gap", 2.5))
      - 2 * self:Public("ConfGet", "RPUF_BORDER_INSETS")
  end;

  local function get_frame_dimensions(self)
    return
      math.max(
        self:Public("Gap", 3) + self:Public("ConfGet", "ICONWIDTH") + self:Public("PanelGet", "Width", "name"),
        self:Public("Gap", 3) + self:Public("ConfGet", "ICONWIDTH") + self:Public("PanelGet", "Width", "info"),
        get_statusBar_width(self) + 2 * self:Public("ConfGet", "RPUF_BORDER_INSETS"),
        self:Public("Gap", 6) + self:Public("ConfGet", "ICONWIDTH") * 5
      ),

      self:Public("ConfGet", "ICONWIDTH") + self:Public("Gap", 4) + self:Public("ConfGet", "STATUSHEIGHT") +
      math.max(
        self:Public("ConfGet", "ICONWIDTH"),
        self:Public("Gap", 1) + self:Public("PanelGet", "Height", "name") + self:Public("PanelGet", "Height", "info")
      );
  end;

  layout:Register_Panel_Method_Hash("GetPanelLeft",
    { [ "name"      ] = function(self) return self:Gap(2) + self:ConfGet("ICONWIDTH") end,
      [ "info"      ] = "name",
      [ "icon1"     ] = function(self) return self:Gap(1) end,
      [ "statusBar" ] = function(self) return self:Public("ConfGet", "RPUF_BORDER_INSETS") end,
      [ "icon2"     ] = "icon1",
      [ "icon3"     ] = "name",
      [ "icon4"     ] = function(self) return self:Gap(3) + self:ConfGet("ICONWIDTH") * 2 end,
      [ "icon5"     ] = function(self) return self:Gap(4) + self:ConfGet("ICONWIDTH") * 3 end,
      [ "icon6"     ] = function(self) return self:Gap(5) + self:ConfGet("ICONWIDTH") * 4 end,

    });

  layout:Register_Panel_Method_Hash("GetPanelTop",
    { [ "name"      ] = function(self) return self:Gap(1) end,
      [ "info"      ] = function(self) return self:Gap(2) + self:PanelGet("Height", "name") end,
      [ "icon1"     ] = "name",
      [ "statusBar" ] = get_statusBar_top,
      [ "icon2"     ] = get_icon_top,
      [ "icon3"     ] = get_icon_top,
      [ "icon4"     ] = get_icon_top,
      [ "icon5"     ] = get_icon_top,
      [ "icon6"     ] = get_icon_top,
   });

  layout:Register_Panel_Method_Hash("GetPanelHeight",
    { [ "name"      ] = function(self) return self:GetActualFontSize() + 4 end,
      [ "info"      ] = function(self) return self:GetActualFontSize() + 2 end,
      [ "icon1"     ] = function(self) return self:ConfGet("ICONWIDTH") end,
      [ "statusBar" ] = function(self) return self:ConfGet("STATUSHEIGHT") end,
      [ "icon2"     ] = "icon1",
      [ "icon3"     ] = "icon1",
      [ "icon4"     ] = "icon1",
      [ "icon5"     ] = "icon1",
      [ "icon6"     ] = "icon1",
    });

  layout:Register_Panel_Method_Hash("GetPanelWidth",
    { [ "name"      ] = "info",
      [ "info"      ] = function(self) return self:ConfGet("INFOWIDTH") end,
      [ "icon1"     ] = function(self) return self:ConfGet("ICONWIDTH") end,
      [ "statusBar" ] = get_statusBar_width,
      [ "icon2"     ] = "icon1",
      [ "icon3"     ] = "icon1",
      [ "icon4"     ] = "icon1",
      [ "icon5"     ] = "icon1",
      [ "icon6"     ] = "icon1",
    });

  layout:Register_Panel_Method_Hash("GetPanelVis",
    { [ "name"      ] = true,
      [ "info"      ] = true,
      [ "icon1"     ] = true,
      [ "statusBar" ] = true,
      [ "icon2"     ] = true,
      [ "icon3"     ] = true,
      [ "icon4"     ] = true,
      [ "icon5"     ] = true,
      [ "icon6"     ] = true,
    });

  layout:Register_Panel_Method("GetPanelJustifyH", function() return "LEFT" end);
  layout:Register_Panel_Method("GetPanelJustifyV", function() return "TOP"  end);

  layout:Register_Frame_Method("GetFrameDimensions", get_frame_dimensions);

  layout:RegisterLayout();
    
end);
