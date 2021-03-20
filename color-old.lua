-- RP Tags
-- by Oraibi, Moon Guard (US) server
-- This work is licensed under the Creative Commons Attribution 4.0 International
-- (CC BY 4.0) license.

local RPTAGS = RPTAGS;

RPTAGS.queue:WaitUntil("UTILS_COLOR",
function(self, event, ...)

RPTAGS.utils       = RPTAGS.utils or {};
RPTAGS.utils.color = RPTAGS.utils.color or {};

local Utils = RPTAGS.utils;
local Color = Utils.color;

local Config   = Utils.config;
local isnum    = Utils.text.isnum;

-- HSV/RGB conversion function from
-- http://axonflux.com/handy-rgb-to-hsl-and-rgb-to-hsv-color-model-c

--[[
 * Converts an RGB color value to HSL. Conversion formula
 * adapted from http://en.wikipedia.org/wiki/HSL_color_space.
 * Assumes r, g, and b are contained in the set [0, 255] and
 * returns h, s, and l in the set [0, 1].
 *
 * @param   Number  r       The red color value
 * @param   Number  g       The green color value
 * @param   Number  b       The blue color value
 * @return  Array           The HSL representation
function rgbToHsl(r, g, b, a)
  r, g, b = r / 255, g / 255, b / 255

  local max, min = math.max(r, g, b), math.min(r, g, b)
  local h, s, l

  l = (max + min) / 2

  if max == min then
    h, s = 0, 0 -- achromatic
  else
    local d = max - min
    local s
    if l > 0.5 then s = d / (2 - max - min) else s = d / (max + min) end
    if max == r then
      h = (g - b) / d
      if g < b then h = h + 6 end
    elseif max == g then h = (b - r) / d + 2
    elseif max == b then h = (r - g) / d + 4
    end
    h = h / 6
  end

  return h, s, l, a or 255
end

]]
--[[
 * Converts an HSL color value to RGB. Conversion formula
 * adapted from http://en.wikipedia.org/wiki/HSL_color_space.
 * Assumes h, s, and l are contained in the set [0, 1] and
 * returns r, g, and b in the set [0, 255].
 *
 * @param   Number  h       The hue
 * @param   Number  s       The saturation
 * @param   Number  l       The lightness
 * @return  Array           The RGB representation
function hslToRgb(h, s, l, a)
  local r, g, b

  if s == 0 then
    r, g, b = l, l, l -- achromatic
  else
    function hue2rgb(p, q, t)
      if t < 0   then t = t + 1 end
      if t > 1   then t = t - 1 end
      if t < 1/6 then return p + (q - p) * 6 * t end
      if t < 1/2 then return q end
      if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
      return p
    end

    local q
    if l < 0.5 then q = l * (1 + s) else q = l + s - l * s end
    local p = 2 * l - q

    r = hue2rgb(p, q, h + 1/3)
    g = hue2rgb(p, q, h)
    b = hue2rgb(p, q, h - 1/3)
  end

  return r * 255, g * 255, b * 255, a * 255
end
]]

--[[
 * Converts an RGB color value to HSV. Conversion formula
 * adapted from http://en.wikipedia.org/wiki/HSV_color_space.
 * Assumes r, g, and b are contained in the set [0, 255] and
 * returns h, s, and v in the set [0, 1].
 *
 * @param   Number  r       The red color value
 * @param   Number  g       The green color value
 * @param   Number  b       The blue color value
 * @return  Array           The HSV representation
]]
function rgbToHsv(r, g, b, a)
  r, g, b, a = r / 255, g / 255, b / 255, a / 255
  local max, min = math.max(r, g, b), math.min(r, g, b)
  local h, s, v
  v = max

  local d = max - min
  if max == 0 then s = 0 else s = d / max end

  if max == min then
    h = 0 -- achromatic
  else
    if max == r then
    h = (g - b) / d
    if g < b then h = h + 6 end
    elseif max == g then h = (b - r) / d + 2
    elseif max == b then h = (r - g) / d + 4
    end
    h = h / 6
  end

  return h, s, v, a
end

--[[
 * Converts an HSV color value to RGB. Conversion formula
 * adapted from http://en.wikipedia.org/wiki/HSV_color_space.
 * Assumes h, s, and v are contained in the set [0, 1] and
 * returns r, g, and b in the set [0, 255].
 *
 * @param   Number  h       The hue
 * @param   Number  s       The saturation
 * @param   Number  v       The value
 * @return  Array           The RGB representation
]]
function hsvToRgb(h, s, v, a)
  local r, g, b

  local i = math.floor(h * 6);
  local f = h * 6 - i;
  local p = v * (1 - s);
  local q = v * (1 - f * s);
  local t = v * (1 - (1 - f) * s);

  i = i % 6

  if i == 0 then r, g, b = v, t, p
  elseif i == 1 then r, g, b = q, v, p
  elseif i == 2 then r, g, b = p, v, t
  elseif i == 3 then r, g, b = p, q, v
  elseif i == 4 then r, g, b = t, p, v
  elseif i == 5 then r, g, b = v, p, q
  end

  return r * 255, g * 255, b * 255, a * 255
end

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
                           math.floor(r * 255),
                           math.floor(g * 255),
                           math.floor(b * 255));
end;

local function rgbToIntegers(rgb) if rgb:len() == 0 then return nil, nil, nil end;
  rgb = rgb:gsub("^|cff",""):gsub("^#",""); -- just in case
  if not rgb:match("^%x%x%x%x%x%x$") then return nil, nil, nil end;
  return tonumber(rgb:sub(1, 2), 16), tonumber(rgb:sub(3, 4), 16), tonumber(rgb:sub(5, 6), 16); -- 16 = base 16 (hexadecimal)
end; -- function

local function colorToDecimals(rgb)
      local r, g, b = rgbToIntegers(rgb);
      return r/255, g/255, b/255, 1;
end;

local function hslToRgb(h, s, l)
      if s == 0 then return l, l, l end
      local function to(p, q, t)
      if t < 0 then t = t + 1 end
      if t > 1 then t = t - 1 end
      if t < .16667 then return p + (q - p) * 6 * t end
      if t < .5 then return q end
      if t < .66667 then return p + (q - p) * (.66667 - t) * 6 end
      return p
      end
      local q = l < .5 and l * (1 + s) or l + s - l * s
      local p = 2 * l - q
      return 255 * to(p, q, h + .33334), 255 * to(p, q, h), 255 * to(p, q, h - .33334)
  end

  local function rgbToHsl(r, g, b)
      r, g, b = r / 255, g / 255, b / 255;
      local max, min = math.max(r, g, b), math.min(r, g, b)
      local b = max + min
      local h = b / 2
      if max == min then return 0, 0, h end
      local s, l = h, h
      local d = max - min
      s = l > .5 and d / (2 - b) or d / b
      if max == r then h = (g - b) / d + (g < b and 6 or 0)
      elseif max == g then h = (b - r) / d + 2
      elseif max == b then h = (r - g) / d + 4
      end
      return h * .16667, s, l
  end
  
local function colorTransforms(rgb, transform, value)
  local r, g, b = rgbToIntegers(rgb);
  local h, s, v = rgbToHsv(r, g, b, 1);
  local H, S, L = rgbToHsl(r, g, b, 1);

  local hash =
  { "brighten" = function() return hsvToRgb(h, s, v + (1 - value), 1) end,
    "dim"      = function() return hsvToRgb(h, s, v * (1 - value), 1) end,
    "lighten"  = function() return hslToRgb(h, s, l + ( 1 - l ) * value, 1) end,
    "darken"   = function() return hslToRgb(h, s, l * (1 - amount), 1) end,
    "adjustH"  = function() return hsvToRgb(math.max(math.min(h + amount, 1), 0), s, v, 1) end,

local function brightenColor(rgb, amount)
  local r, g, b = rgbToIntegers(rgb);
  if amount > 1 or amount < 0 then return r, g, b, rgb end;
  local h, s, v = rgbToHsv(r, g, b, 1);
  r, g, b = hsvToRgb(h, s, v + (1 - v ) * amount, 1);
  return r, g, b, integersToColor(r, g, b, 1);
end;

local function dimColor(rgb, amount) 
  local r, g, b = rgbToIntegers(rgb);
  if amount > 1 or amount < 0 then return r, g, b, rgb end;
  local h, s, v = rgbToHsv(r, g, b, 1);
  r, g, b = hsvToRgb(h, s, v * (1 - amount), 1);
  return r, g, b, integersToColor(r, g, b, 1);
end;

local function lightenColor(rgb, amount)
  local r, g, b = rgbToIntegers(rgb);
  if amount > 1 or amount < 0 then return r, g, b, rgb end;
  local h, s, l = rgbToHsl(r, g, b, 1);
  r, g, b = hslToRgb(h, s, l + (1 - l ) * amount, 1);
  r, g, b = r * 255, g * 255, b * 255;
  return r, g, b, integersToColor(r, g, b, 1);
end;

local function darkenColor(rgb, amount)
  local r, g, b = rgbToIntegers(rgb);
  if amount > 1 or amount < 0 then return r, g, b, rgb end;
  local h, s, l = rgbToHsl(r, g, b, 1);
  r, g, b = hslToRgb(h, s, l * (1 - amount), 1);
  return r, g, b, integersToColor(r, g, b, 1);
end;

local function unchangedColor(rgb, amount)
  local r, g, b = rgbToIntegers(rgb);
  if amount > 1 or amount < 0 then return r, g, b, rgb end;
  local h, s, l = rgbToHsl(r, g, b, 1);
  r, g, b = hslToRgb(h, s, l);
  return r, g, b, integersToColor(r, g, b, 1);
end;

local function changeHue(rgb, amount)
  local r, g, b = rgbToIntegers(rgb);
  local h, s, v = rgbToHsv(r, g, b, 1);
  r, g, b = hsvToRgb(math.max(math.min(h + amount, 1), 0), s, v, 1);
  return r, g, b, integersToColor(r, g, b, 1);
end;

local function setHue(rgb, value)
  local r, g, b = rgbToIntegers(rgb);
  local h, s, v = rgbToHsv(r, g, b, 1);
  r, g, b = hsvToRgb(math.max(math.min(value), 0), s, v, 1);
  return r, g, b, integersToColor(r, g, b, 1);
end;

local function changeLightness(rgb, amount)
  local r, g, b = rgbToIntegers(rgb);
  local h, s, l = rgbToHsl(r, g, b, 1);
  r, g, b = hslToRgb(h, s, math.max(math.min(l + amount), 0), 1);
  return r, g, b, integersToColor(r, g, b, 1);
end;

local function setHue(rgb, value)
  local r, g, b = rgbToIntegers(rgb);
  local h, s, v = rgbToHsv(r, g, b, 1);
  r, g, b = hsvToRgb(math.max(math.min(value), 0), s, v, 1);
  return r, g, b, integersToColor(r, g, b, 1);
end;

-- Utilities available via RPTAGS.utils.color
--
Color.colorCode       = colorCode;      -- replace
Color.compare         = compareColor;
Color.numberToHexa    = integerToHex;
Color.hsvToRgb        = hsvToRgb;
Color.hslToRgb        = hslToRgb;
Color.rgbToHsl        = rgbToHsl;
Color.rgbToHsv        = rgbToHsv;
Color.redToGreenHue   = redToGreenHue;
Color.hexaToNumber    = rgbToIntegers;
Color.integersToColor = integersToColor;
Color.decimalsToColor = decimalsToColor;
Color.colorToDecimals = colorToDecimals;
Color.lighten         = lightenColor;
Color.darken          = darkenColor;
Color.brighten        = brightenColor;
Color.dim             = dimColor;
Color.unchanged       = unchangedColor;

end);
