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

  local layout = RPTAGS.utils.frames.RPUF_NewLayout("abridged", "large");

  local function get_statusBar_top(self)
    return
      math.min(
        self:Gap(-2) - self:GetPanelHeight("icon1"),
        self:Gap(-3) - self:GetPanelHeight("name") + self:GetPanelHeight("info")
      )
  end;

  local function get_icon_top(self)
    return
      self:Gap(-3) - self:GetPanelHeight("statusBar") -
      math.max( 
        self:GetPanelHeight("icon1"),
        self:GetPanelHeight("name") + self:GetPanelHeight("info") + self:Gap(1)
      )
  end;

  local function get_statusBar_width(self)
    return
      self:ConfGet("ICONWIDTH") + self:Gap(3.5) +
      math.max(self:ConfGet("INFOWIDTH"), self:ConfGet("ICONWIDTH") * 5 + self:Gap(2.5))
  end;

  local function get_frame_dimensions(self)
    return
      math.max(
        self:Gap(3) + self:PanelGet("Width", "icon1") + self:PanelGet("Width", "name"),
        self:Gap(3) + self:PanelGet("Width", "icon1") + self:PanelGet("Width", "info"),
        self:PanelGet("Width", "statusBar"),
        self:Gap(6) + self:PanelGet("Width", "icon2") * 5,
      ),

      math.max(
        self:Gap(4) + self:PanelGet("Height", "icon1") * 2 + self:PanelGet("Height", "statusBar"),
        self:Gap(5) + self:PanelGet("Height", "name") + self:PanelGet("info")
        + self:PanelGet("statusBar") + self:PanelGet("icon2")
      );
  end;

  layout:Register_Panel_Method_Hash("GetPanelLeft",
    { [ "name"      ] = function(self) return self:Gap(2) + self:GetPanelWidth("icon1") end,
      [ "info"      ] = "name",
      [ "icon1"     ] = function(self) return self:Gap(1) end,
      [ "statusBar" ] =  0,
      [ "icon2"     ] = "icon1",
      [ "icon3"     ] = "name",
      [ "icon4"     ] = function(self) return self:Gap(3) + self:GetPanelWidth("icon2") * 2 end,
      [ "icon5"     ] = function(self) return self:Gap(4) + self:GetPanelWidth("icon2") * 3 end,
      [ "icon6"     ] = function(self) return self:Gap(5) + self:GetPanelWidth("icon2") * 4 end,

    });

  layout:Register_Panel_Method_Hash("GetPanelTop",
    { [ "name"      ] = function(self) return self:Gap(-1) end,
      [ "info"      ] = function(self) return self:Gap(-2) + self:GetPanelHeight("name") end,
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
      [ "icon1"     ] = function(self) return self:ConfGet("ICONHEIGHT") end,
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
      [ "icon1"     ] = function(self) return self:ConfGet("ICONHEIGHT") end,
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

  layout:Register_Panel_Method_Hash("GetPanelJustifyH", function() return "LEFT" end);
  layout:Register_Panel_Method_Hash("GetPanelJustifyV", function() return "TOP"  end);

  layout:Register_Frame_Method("GetFrameDimensions", get_frame_dimensions);

  layout:RegisterLayout();
    
end);
