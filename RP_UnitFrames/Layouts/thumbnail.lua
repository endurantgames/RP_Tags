local addOnName, ns = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("MODULE_F", 
function(self, event, ...)

  local layout = RPTAGS.utils.frames.RPUF_NewLayout("thumbnail", "large");

  function get_frame_dimensions(self)
    return 
      self:Public("ConfGet", "RPUF_BORDER_INSETS") * 2 
      + self:Public("ConfGet", "PORTWIDTH"),
      self:Public("ConfGet", "RPUF_BORDER_INSETS") * 2 
      + self:Public("ConfGet", "PORTWIDTH")
      + self:Public("PanelGet", "Height", "name") 
      + self:Public("Gap", 0.5)
  end

  layout:Register_Panel_Method_Hash( "GetPanelLeft",
    { [ "portrait" ] = function(self) return self:ConfGet("RPUF_BORDER_INSETS") end,
      [ "name"     ] = function(self) return self:ConfGet("RPUF_BORDER_INSETS") + self:Gap(0.5) end;
    });

  layout:Register_Panel_Method_Hash( "GetPanelTop",
    { [ "portrait" ] = function(self) 
                         return self:ConfGet("RPUF_BORDER_INSETS") 
                                + self:PanelGet("Height", "name")
                                + self:Gap(0.5);
                       end,
      [ "name"     ] = function(self) 
                         return self:ConfGet("RPUF_BORDER_INSETS") 
                                + self:Gap(0.5) 
                       end,
    });
  
  layout:Register_Panel_Method_Hash( "GetPanelHeight",
    { [ "portrait" ] = function(self) return self:ConfGet("PORTWIDTH") end,
      [ "name"     ] = function(self) return self:CalculateFontSize(); end,
    });

  layout:Register_Panel_Method_Hash( "GetPanelWidth",
    { [ "portrait" ] = function(self) return self:ConfGet("PORTWIDTH") end,
      [ "name"     ] = function(self) return self:ConfGet("PORTWIDTH") - self:Gap(1) end,
    });
  
  layout:Register_Panel_Method( "GetPanelJustifyH", function() return "CENTER" end);
  layout:Register_Panel_Method( "GetPanelJustifyV", function() return "BOTTOM" end);

  layout:Register_Panel_Method_Hash( "GetPanelVis", 
    { [ "portrait" ] = true, 
      [ "name"     ] = true, 
    });
       
  layout:Register_Frame_Method( "GetFrameDimensions", get_frame_dimensions);
  
  layout:RegisterLayout();
  
  end);
