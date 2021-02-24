local addOnName, ns = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("MODULE_F",
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
      [ "icon4"    ] = function(self) return self:GetConf("PORTWIDTH") - self:Gap(1) - self:GetConf("ICONWIDTH") end,
      [ "icon5"    ] = "icon4",
      [ "icon6"    ] = "icon4",
  });

  layout:Register_Panel_Method_Hash(
    "GetPanelTop",
    { [ "name"     ] = function(self) return self:Gap(1);                                                       end,
      [ "info"     ] = function(self) return self:Gap(2) + self:PanelGet("Height", "name")    end,
      [ "portrait" ] = function(self) return self:PanelGet("Top", "info") + self:PanelGet("Height", "info") + self:Gap(1) end,
      [ "icon1"    ] = function(self) return self:PanelGet("Top", "portrait") + self:Gap(1);                             end,
      [ "icon2"    ] = function(self) return self:PanelGet("Top", "icon1") + self:ConfGet("ICONWIDTH") + self:Gap(2); end,
      [ "icon3"    ] = function(self) return self:PanelGet("Top", "icon2") + self:ConfGet("ICONWIDTH") + self:Gap(2)  end.
      [ "icon4"    ] = "icon1",
      [ "icon5"    ] = "icon3",
      [ "icon6"    ] = "icon3",
    });

  layout:Register_Panel_Method_Hash( "GetPanelHeight",
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


  layout:Register_Panel_Method_Hash( "GetPanelWidth",
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
  
  layout:Register_Panel_Method_Hash( "GetPanelJustifyH",
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
      return self:Gap(3) + self:ConfGet("ICONWIDTH") * 2
             + self:ConfGet("PORTWIDTH") * 1.5,

           math.max(
             self:ConfGet("PORTWIDTH") * 2,
             self:Gap(5) + self:ConfGet("ICONWIDTH") * 3

           );
    end
  );

  layout:RegisterLayout();

end);
