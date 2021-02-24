-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International (CC BY 4.0) license. 

local addOnName, ns = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("MODULE_G", 
function(self, event, ...)

  local layout = RPTAGS.utils.frames.RPUF_NewLayout("thumbnail", "large");

  local function get_name_top(self)
    return 
      math.max( 
        self:GetPanelHeight("name") + self:ConfGet("PORTHEIGHT") * 1.5,
        self:ConfGet("ICONWIDTH"),
      ); 
  end;

  function get_Frame_dimensions(self)
    return 
      math.max(self:ConfGet("PORTWIDTH") * 2/3, self:ConfGet("ICONWIDTH")),

      math.max(self:ConfGet("ICONWIDTH") + self:PanelGet("Height", "name"),
               self:ConfGet("PORTWIDTH") * 1.5)
  end

  layout:Register_Panel_Method_Hash( "GetPanelLeft",
    { [ "portrait" ] = 0,
      [ "icon1"    ] = 0,
      [ "name"     ] = function() return self:Gap(1/3) end,
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
       
  layout:Register_Frame_Method( "GetFrameDimensions", get_frame-dimensions);
  
  layout:RegisterLayout();
  
  end);
