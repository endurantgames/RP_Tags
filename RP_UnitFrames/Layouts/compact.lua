-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license. 

local addOnName, ns = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("after MODULE_E", -- depends on size functions
function(self, event, ...)

  local layout = RPTAGS.utils.frames.RPUF_NewLayout("compact", "small");

  local function get_frame_dimensions(self)
    return 
      self:Gap(1.5) + self:ConfGet("ICONWIDTH") + self:ConfGet("INFOWIDTH"),

      self:Gap(1) +
      math.max( 
        self:Gap(0.5) + self:PanelGet("Height", "name") + self:PanelGet("Height", "info"),
        self:ConfGet("ICONWIDTH")
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
      [ "name"  ] = function(self) return self:GetActualFontSize() + 4 end,
      [ "info"  ] = function(self) return self:GetActualFontSize() + 2 end,
    });

  layout:Register_Panel_Method_Hash("GetPanelWidth",
    { [ "icon1" ] = function(self) return self:ConfGet("ICONWIDTH") end,
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

end);
