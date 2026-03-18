-- Idle Animation script
-- This script creates a smooth rainbow pulse effect across the LED bar
-- by btastic_fpv

-- Global variables for animations
local animTime = 0

-- Configuration
local LED_START = 0    -- First LED in the bar
local LED_END = 5      -- Last LED in the bar
local INDICATOR_LED = -1  -- Separate indicator LED (set to -1 to disable)

local function init()
end

local function idleRainbowPulse()
  animTime = animTime + 0.02
  
  for i = LED_START, LED_END, 1 do
    local hue = (animTime + (i * 0.3)) % 6  -- Offset each LED for wave effect
    local pulse = (math.sin(animTime * 2) + 1) / 2  -- Pulse between 0 and 1
    local brightness = 50 + (pulse * 100)  -- Pulse between 50 and 150
    
    local r, g, b = 0, 0, 0
    
    -- Convert hue to RGB (rainbow colors)
    if hue < 1 then
      r, g, b = brightness, brightness * hue, 0
    elseif hue < 2 then
      r, g, b = brightness * (2 - hue), brightness, 0
    elseif hue < 3 then
      r, g, b = 0, brightness, brightness * (hue - 2)
    elseif hue < 4 then
      r, g, b = 0, brightness * (4 - hue), brightness
    elseif hue < 5 then
      r, g, b = brightness * (hue - 4), 0, brightness
    else
      r, g, b = brightness, 0, brightness * (6 - hue)
    end
    
    setRGBLedColor(i, math.floor(r), math.floor(g), math.floor(b))
  end
end

local function run()
  idleRainbowPulse()
  
  -- Optional indicator LED
  if INDICATOR_LED >= 0 then
    setRGBLedColor(INDICATOR_LED, 0, 50, 0)
  end
  
  applyRGBLedColors()
end

local function background()
end

return { run=run, background=background, init=init }
