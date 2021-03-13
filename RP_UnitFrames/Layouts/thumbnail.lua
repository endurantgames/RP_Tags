local addOnName, ns = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("MODULE_F", 
function(self, event, ...)

  local layout = RPTAGS.utils.frames.RPUF_NewLayout("thumbnail", "large");

  local function get_name_top(self)
    return 
      math.max( 
        self:PanelGet("Height", "name") + self:ConfGet("PORTWIDTH") * 1.5,
        self:ConfGet("ICONWIDTH")
      ); 
  end;

  function get_frame_dimensions(self)
    return 
      math.max(self:Public("ConfGet", "PORTWIDTH") * 2/3, self:Public("ConfGet", "ICONWIDTH")),

      math.max(self:Public("ConfGet", "ICONWIDTH") + self:Public("PanelGet", "Height", "name"),
               self:Public("ConfGet", "PORTWIDTH") * 1.5)
  end

  layout:Register_Panel_Method_Hash( "GetPanelLeft",
    { [ "portrait" ] = 0,
      [ "icon1"    ] = 0,
      [ "name"     ] = function(self) return self:Gap(1/3) end,
    });

  layout:Register_Panel_Method_Hash( "GetPanelTop",
    { [ "portrait" ] = 0,
      [ "icon1"    ] = 0,
      [ "name"     ] = get_name_top,
    });
  
  layout:Register_Panel_Method_Hash( "GetPanelHeight",
    { [ "portrait" ] = function(self) return self:ConfGet("PORTWIDTH") * 1.5 end,
      [ "icon1"    ] = function(self) return self:ConfGet("ICONWIDTH") end, 
      [ "name"     ] = function(self) return self:GetActualFontSize() + 4; end,
    });

  layout:Register_Panel_Method_Hash( "GetPanelWidth",
    { [ "portrait" ] = function(self) return self:ConfGet("PORTWIDTH") * 2/3 end,
      [ "icon1"    ] = function(self) return self:ConfGet("ICONWIDTH") end, 
      [ "name"     ] = function(self) return math.max(self:ConfGet("PORTWIDTH"), 
                                                      self:ConfGet("ICONWIDTH")) - self:Gap(2/3); end,
    });
  
  layout:Register_Panel_Method_Hash( "GetPanelJustifyH",
    { [ "portrait" ] = function() return "LEFT"   end,
      [ "name"     ] = function() return "CENTER" end,
      [ "info"     ] = function() return "CENTER" end,
    });

  layout:Register_Panel_Method( "GetPanelJustifyV", function() return "TOP" end);

  layout:Register_Panel_Method_Hash( "GetPanelVis", 
    { [ "portrait" ] = true, 
      [ "icon1"    ] = true, 
      [ "name"     ] = true, 
    });
       
  layout:Register_Frame_Method( "GetFrameDimensions", get_frame_dimensions);
  
  layout:RegisterLayout();
  
  end);
