-- Define positions
local xLeft = 10
local yStart = 5
local lineHeight = 18
local textStyle = WHITE + LEFT + SHADOWED

  
local mod = {} -- module info

local function create(zone, options)
  
  local widget = {
    zone = zone,
    cfg = options,
  }

  return widget
end

local function update(widget, options)
  -- Runs if options are changed from the Widget Settings menu
  widget.cfg = options
end

-- Convert timer value to mm:ss format
local function formatTime(seconds)
  local minutes = math.floor(seconds / 60)
  local remainingSeconds = seconds % 60
  return string.format("%02d:%02d", minutes, remainingSeconds)
end

-- Helper for RSSI display
local function drawRSSI(r1, r2)
  if r1 == 0 and r2 == 0 then
    lcd.drawText(xLeft, yStart + 5 * lineHeight, "RSSI: 0dBm", textStyle)
  elseif r1 ~= 0 and r2 == 0 then
    lcd.drawText(xLeft, yStart + 5 * lineHeight, "RSSI1: " .. r1 .. "dBm", textStyle)
  elseif r2 ~= 0 and r1 == 0 then
    lcd.drawText(xLeft, yStart + 5 * lineHeight, "RSSI2: " .. r2 .. "dBm", textStyle)
  else
    lcd.drawText(xLeft, yStart + 5 * lineHeight, "RSSI1: " .. r1 .. "dBm", textStyle)
    lcd.drawText(xLeft, yStart + 6 * lineHeight, "RSSI2: " .. r2 .. "dBm", textStyle)
  end
end

local function drawRfTelemetryText(widget, tlm)
  
  local tlm = { tpwr = getValue("TPWR") or 0 }
  
  if tlm.tpwr == nil or tlm.tpwr == 0 then
    lcd.drawText(xLeft, yStart + lineHeight, "No RX Connected", textStyle)
    widget.ctx = nil
  else

    tlm.rfmd = getValue("RFMD")
    tlm.rssi1 = tonumber(getValue("1RSS")) 
    tlm.rssi2 = tonumber(getValue("2RSS"))
    tlm.rqly = getValue("RQly") 
    tlm.ant = getValue("ANT")

    local modestr = (mod.RFMOD and mod.RFMOD[tlm.rfmd+1]) or ("RFMD" .. tostring(tlm.rfmd)) 

    tlm.fmode = getValue("FM") or 0

    local rfmd = getValue ("RFMD") 

    --lcd.drawText(xLeft, yStart + lineHeight, "RX Connected", textStyle)
    lcd.drawText(xLeft, yStart + lineHeight, "Power: " .. tostring(tlm.tpwr) .. "mW", textStyle)
    lcd.drawText(xLeft, yStart + 2 * lineHeight, "RFMD: " .. tostring(modestr), textStyle)
    lcd.drawText(xLeft, yStart + 3 * lineHeight, "FMODE: " .. tostring(tlm.fmode), textStyle)
    lcd.drawText(xLeft, yStart + 4 * lineHeight, "LQ: " .. tostring(tlm.rqly) .. "%", textStyle)

    drawRSSI(tlm.rssi1, tlm.rssi2)

  end

end

local function fieldGetString(data, off)
  local startOff = off
  while data[off] ~= 0 do
    data[off] = string.char(data[off])
    off = off + 1
  end

  return table.concat(data, nil, startOff, off - 1), off + 1
end

local function parseDeviceInfo(data)
  if data[2] ~= 0xEE then return end -- only interested in TX info
  local name, off = fieldGetString(data, 3)
  mod.name = name
  -- off = serNo ('ELRS') off+4 = hwVer off+8 = swVer
  mod.vMaj = data[off+9]
  mod.vMin = data[off+10]
  mod.vRev = data[off+11]
  mod.vStr = string.format("%s (%d.%d.%d)",
    mod.name, mod.vMaj, mod.vMin, mod.vRev)
  if mod.vMaj == 3 then
    mod.RFMOD = {"", "25Hz", "50Hz", "100Hz", "100HzFull", "150Hz", "200Hz", "250Hz", "333HzFull", "500Hz", "D250", "D500", "F500", "F1000" }
   -- Note: Always use 2.4 limits
    mod.RFRSSI = {-128, -123, -115, -117, -112, -112, -112, -108, -105, -105, -104, -104, -104, -104}
  else
    mod.RFMOD = {"", "25Hz", "50Hz", "100Hz", "150Hz", "200Hz", "250Hz", "500Hz"}
    mod.RFRSSI = {-128, -123, -115, -117, -112, -112, -108, -105}
  end
  return true
end

local function updateElrsVer()
  local command, data = crossfireTelemetryPop()
  if command == 0x29 then
    if parseDeviceInfo(data) then
      -- Get rid of all the functions, only update once
      parseDeviceInfo = nil
      fieldGetString = nil
      updateElrsVer = nil
      mod.lastUpd = nil
    end
    return
  end

  local now = getTime()
  -- Poll the module every second
  if (mod.lastUpd or 0) + 100 < now then
    crossfireTelemetryPush(0x28, {0x00, 0xEA})
    mod.lastUpd = now
  end
end

local function refresh(widget, event, touchState)

  -- Runs periodically only when widget instance is visible
  -- If full screen, then event is 0 or event value, otherwise nil
  if updateElrsVer then updateElrsVer() end
  --updateWidgetSize(widget, event)

  if widget.ctx == nil then
    widget.ctx = {}
  end

  drawRfTelemetryText(widget, tlm)

end

return {
  name = "RXWidget",
  create = create,
  update = update,
  refresh = refresh,
  options = {}
}
