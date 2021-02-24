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

  local layout = RPTAGS.utils.frames.RPUF_NewLayout("paperdoll", "large");
    
  layout:Register_Panel_Method_Hash(
    "GetPanelLeft",
    { [ "name"     ] = function(self) return self:Gap(1); end,
      [ "info"     ] = "name",
      [ "portrait" ] = 0,
      [ "icon1"    ] = "name",
      [ "icon2"    ] = "name",
      [ "icon3"    ] = "name",
      [ "icon4"    ] = function(self) return self:GetPanelWidth("portrait") - self:Gap(1) - self:GetPanelWidth("icon1") end,
      [ "icon5"    ] = "icon4",
      [ "icon6"    ] = "icon4",
  });

  layout:Register_Panel_Method_Hash(
    "GetPanelTop",
    { [ "name"     ] = function(self) return -1 * self:Gap(1);                                                       end,
      [ "info"     ] = function(self) return -1 * self:Gap(1) - self:GetPanelHeight("name") - self:Gap(1);           end,
      [ "portrait" ] = function(self) return self:GetPanelTop("info") - self:GetPanelHeight("info") - self:Gap(1)    end,
      [ "icon1"    ] = function(self) return self:GetPanelTop("portrait") - self:Gap(1);                             end,
      [ "icon2"    ] = function(self) return self:GetPanelTop("icon1") - self:GetPanelHeight("icon1") - self:Gap(2); end,
      [ "icon3"    ] = function(self) return self:GetPanelTop("icon2") - self:GetPanelHeight("icon2") - self:Gap(2)  end.
      [ "icon4"    ] = "icon1",
      [ "icon5"    ] = "icon3",
      [ "icon6"    ] = "icon3",
    });

  layout:Register_Panel_Method_Hash(
    "GetPanelHeight",
    { [ "name"     ] = function(self) return self:GetActualFontSize() + 4 end,
      [ "info"     ] = function(self) return self:GetActualFontSize() + 2 end,
      [ "portrait" ] = function(self) return self:ConfGet("PORTWIDTH") * 2 end,
      [ "icon1"    ] = function(self) return self:ConfGet("ICONWIDTH") end,
      [ "icon2"    ] = "icon1",
      [ "icon3"    ] = "icon1",
      [ "icon4"    ] = "icon1",
      [ "icon5"    ] = "icon1",
      [ "icon6"    ] = "icon1",
    });


  layout:Register_Panel_Method_Hash(
    "GetPanelWidth",
    { [ "name"     ] = function(self) return self:ConfGet("PORTWIDTH") * 1.5 - self:Gap(2) end,
      [ "info"     ] = "name",
      [ "portrait" ] = function(self) return self:ConfGet("PORTWIDTH") * 1.5 end,
      [ "icon1"    ] = function(self) return self:ConfGet("ICONWIDTH") end,
      [ "icon2"    ] = "icon1",
      [ "icon3"    ] = "icon1",
      [ "icon4"    ] = "icon1",
      [ "icon5"    ] = "icon1",
      [ "icon6"    ] = "icon1",
    });
  
  layout:Register_Panel_Method_Hash(
    "GetPanelJustifyH",
    { [ "name"     ] = function() return "CENTER" end,
      [ "info"     ] = "name",
      [ "portrait" ] = function() return nil end,
      [ "icon1"    ] = function() return "LEFT" end,
      [ "icon2"    ] = "icon1",
      [ "icon3"    ] = "icon1",
      [ "icon4"    ] = "icon1",
      [ "icon5"    ] = "icon1",
      [ "icon6"    ] = "icon1",
    });

  layout:Register_Panel_Method("GetPanelJustifyV", function() return "TOP" end);

  layout:Register_Panel_Method_Hash(
  "GetPanelVis",
    { [ "name"     ] = true,
      [ "info"     ] = true,
      [ "portrait" ] = true,
      [ "icon1"    ] = true,
      [ "icon2"    ] = true,
      [ "icon3"    ] = true,
      [ "icon4"    ] = true,
      [ "icon5"    ] = true,
      [ "icon6"    ] = true,
    });

  layout:Register_Frame_Method(
  "GetFrameDimensions",

    function(self)
      return self:Gap(1) + self:PanelGet("Width", "icon1") 
           + self:Gap(1) + self:PanelGet("Width", "portrait")
           + Self:Gap(1) + self:PanelGet("Width", "icon2"),

           math.max(
             self:Gap(1) + self:PanelGet("Height", "name")
           + self:Gap(1) + self:PanelGet("Height", "info")
           + self:Gap(1) + self:PanelGet("Height", "portrait"),

             self:Gap(1) + self:PanelGet("Height", "name")
           + self:Gap(1) + self:PanelGet("Height", "info")
           + self:Gap(2) + self:PanelGet("Height", "icon1")
           + self:Gap(2) + self:PanelGet("Height", "icon2")
           + self:Gap(2) + self:PanelGet("Height", "icon3")
           );
    end
  );

  layout:RegisterLayout();

end);
