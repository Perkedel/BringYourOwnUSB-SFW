-- RGB LED Index Finder
-- This script cycles through LED indices to help you identify which LED is which
-- Use this to find the correct LED numbers for your radio
-- by btastic_fpv

local currentLED = 0
local previousLED = -1
local maxLED = LED_STRIP_LENGTH - 1
local lastTime = 0
local interval = 1000  -- Change LED every 1000ms (1 second)

local function init_func()
  currentLED = 0
  previousLED = -1
  lastTime = getTime()
  
  for i = 0, maxLED do
    setRGBLedColor(i, 0, 0, 0)
  end
  
  setRGBLedColor(0, 255, 255, 255)
  
  applyRGBLedColors()
end

local function run_func()
  local currentTime = getTime()
  
  if currentTime - lastTime > interval / 10 then  -- getTime() is in 10ms units
    lastTime = currentTime
    
    previousLED = currentLED
    currentLED = currentLED + 1
    if currentLED > maxLED then
      currentLED = 0
    end
    
    if previousLED >= 0 then
      setRGBLedColor(previousLED, 0, 0, 0)
    end
    
    setRGBLedColor(currentLED, 255, 255, 255)
    
    applyRGBLedColors()
  end
  
  lcd.clear()
  
  -- Determine text size and layout based on screen height
  if LCD_H > 100 then
    local leftMargin = 20
    lcd.drawText(leftMargin, LCD_H * 0.1, "LED Index Finder", MIDSIZE)
    lcd.drawText(leftMargin, LCD_H * 0.35, "Current LED:", 0)
    lcd.drawText(leftMargin, LCD_H * 0.5, tostring(currentLED), XXLSIZE or DBLSIZE)
    lcd.drawText(leftMargin, LCD_H * 0.85, "Max: " .. maxLED, 0)
  else
    -- Smaller monochrome screens (like GX12 @ 128x64)
    lcd.drawText(10, 5, "LED Index Finder", 0)
    lcd.drawText(10, 20, "Current LED:", 0)
    lcd.drawText(50, 35, tostring(currentLED), DBLSIZE)
    lcd.drawText(30, 52, "Max: " .. maxLED, 0)
  end
  
  return 0
end

local function bg_func()
end

return { run=run_func, background=bg_func, init=init_func }