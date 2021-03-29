-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license.

local RPTAGS = RPTAGS;

RPTAGS.queue:WaitUntil("UTILS_COLOR",
function(self, event, ...)

RPTAGS.utils       = RPTAGS.utils or {};
RPTAGS.utils.color = RPTAGS.utils.color or {};

local LibColor = LibStub("LibColorManipulation-1.0");

local Utils = RPTAGS.utils;
local Color = Utils.color;

local Config   = Utils.config;
local isnum    = Utils.text.isnum;

local function hsvToRgb(h, s, v) return LibColor.convert("rgb", "hsv", h, s, v, 1) end;
local function hslToRgb(h, s, L) return LibColor.convert("rgb", "hsl", h, s, L, 1) end;
local function rgbToHsl(r, g, b) return LibColor.convert("hsl", "rgb", r, g, b, 1) end;
local function rgbToHsv(r, g, b) return LibColor.convert("hsv", "rgb", r, g, b, 1) end;

      -- returns a hue value (for HSV color) based on the values of three numbers
local function redToGreenHue(value, lowValue, highValue, optionalInvert)

     local GREEN = 120; -- degrees for the starting color of green in HSV

     -- these normalize the values so we don't get weird range errors
     if lowValue > highValue then local tempValue = highValue;
                                        highValue = lowValue;
                                        lowValue  = tempValue;
                                  end;
     if value    > highValue then       value     = highValue; end;
     if value    < lowValue  then       value     = lowValue; end; 

     local width =  highValue - lowValue;
     if    width == 0 then width = 1;end; -- because we divide by width below

     local valuePos      = value    - lowValue; -- position within width
     local valueFraction = valuePos / width;    -- fractional distance through width

     if not optionalInvert
        then return (GREEN/360) * valueFraction;
        else return (GREEN/360) - (GREEN/360) * valueFraction;
     end; -- if
end; 

      -- function to take two values and return either COLOR_LESSTHAN, COLOR_GREATERTHAN, or COLOR_EQUALISH
local function compareColor(firstValue, secondValue, isExact)
  
      if    not isnum(firstValue) 
         or not isnum(secondValue) 
         then return ""; end; -- don't change the color

      local sum      = math.abs(firstValue) + math.abs(secondValue);
      local sigma    = sum * 0.05;

      if not isExact then sigma = sigma *2; end;

      if math.abs(firstValue - secondValue) < sigma 
         then return "|cff" .. Config.get("COLOR_EQUALISH");
         elseif firstValue - secondValue > 0
                then return "|cff" .. Config.get("COLOR_LESSTHAN");
         else return "|cff" .. Config.get("COLOR_GREATERTHAN");
         end; -- if
end; 

local function integerToHex(number) return string.format("%02", math.floor(number));   end;
local function colorCode(r, g, b)   return string.format("|cff%02x%02x%02x", r, g, b); end;

local function integersToColor(r, g, b) return string.format("%02x%02x%02x", r, g, b); end;

local function decimalsToColor(r, g, b)
      return string.format("%02x%02x%02x", 
                math.min(255, math.floor(r * 255)),
                math.min(255, math.floor(g * 255)),
                math.min(255, math.floor(b * 255)));
end;

local function rgbToIntegers(rgb) if rgb:len() == 0 then return nil end;
  rgb = rgb:gsub("^|cff",""):gsub("^#",""); -- just in case
  if not rgb:match("^%x%x%x%x%x%x$") then return nil end;
  return tonumber(rgb:sub(1, 2), 16), tonumber(rgb:sub(3, 4), 16), tonumber(rgb:sub(5, 6), 16); -- 16 = base 16 (hexadecimal)
end; -- function

local function colorToDecimals(rgb)
      local r, g, b = rgbToIntegers(rgb);
      if not r then return nil; else return r/255, g/255, b/255, 1; end;
end;

-- Utilities available via RPTAGS.utils.color
--
Color.colorCode       = colorCode;      -- replace
Color.compare         = compareColor;
Color.numberToHexa    = integerToHex;
Color.redToGreenHue   = redToGreenHue;
Color.hexaToNumber    = rgbToIntegers;
Color.integersToColor = integersToColor;
Color.decimalsToColor = decimalsToColor;
Color.colorToDecimals = colorToDecimals;

Color.hsvToRgb        = hsvToRgb;
Color.hslToRgb        = hslToRgb;
Color.rgbToHsl        = rgbToHsl;
Color.rgbToHsv        = rgbToHsv;

end);
