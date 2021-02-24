-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- ------------------------------------------------------------------------------
-- This work is licensed under the Creative Commons Attribution 4.0 International (CC BY 4.0) license. 

local addOnName, addOn = ...;
local RPTAGS = RPTAGS;
local Module = RPTAGS.queue:GetModule(addOnName);

Module:WaitUntil("MODULE_G", 
function(self, event, ...)

  local layout = RPTAGS.utils.frames.RPUF_NewLayout("thumbnail", "large");

  local function get_name_top(self)
    return 
      math.min( 
        self:GetPanelHeight("name") - self:GetPanelHeight("portrait"),
        -1 * self:GetPanelHeight("icon1")
      ); 
  end;

  function get_name_width(self) 
    return 
      math.max( 
        self:ConfGet("PORTWIDTH") * 2/3 - self:HGap(2/3),
        self:ConfGet("ICONWIDTH") - self:HGap(2/3)
      ); 
  end;

  function get_Frame_dimensions(self)
    return 
      math.max( self:GetPanel("portrait"):GetPanelWidth(), 
                self:GetPanel("icon1"   ):GetPanelWidth()  ),

      math.max( self:GetPanel("icon1"   ):GetPanelHeight() 
                  + self:GetPanel("name"):GetPanelHeight(),
                self:GetPanel("portrait"):GetPanelHeight() )
  end

  layout:Register_Panel_Method_Hash( "GetPanelLeft",
    { [ "portrait" ] = 0,
      [ "icon1"    ] = 0,
      [ "name"     ] = function() return self:HGap(1/3) end,
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
      [ "name"     ] = get_name_width,
    });
  
  layout:Register_Panel_Method_Hash( "GetPanelAlignH",
    { [ "portrait" ] = function() return nil      end,
      [ "name"     ] = function() return "CENTER" end,
      [ "info"     ] = function() return "CENTER" end,
    });

  layout:Register_Panel_Method( "GetPanelAlignV", function() return "TOP" end);

  layout:Register_Panel_Method_Hash( "GetPanelVis", 
    { [ "portrait" ] = true, 
      [ "icon1"    ] = true, 
      [ "name"     ] = true, 
    });
       
  layout:Register_Frame_Method( "GetFrameDimensions", get_frame-dimensions);
  
  layout:RegisterLayout();
  
  end);
