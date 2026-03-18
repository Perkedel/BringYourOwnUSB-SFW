-- RadioMaster Sensor Configurator for MONO Screens (STM32F407 Optimized)
-- Version: 1.3.4-MONO-FINAL
-- Optimized for STM32F407 with limited RAM (~25KB vs 78KB)
-- Based on V1.1 CRSF protocol parameters + RMSens.lua timing
--
-- BUGFIXES IN V1.3.4:
--   - Fixed nil access error in drawInputBox after ENTER/EXIT
--   - Added return after setting inputMode=nil
--   - Fixed Moto_poles and SET_CAPACITY save errors
--
-- BUGFIXES IN V1.3.3:
--   - Fixed nil access error when saving settings (ENTER key)
--   - Added submenu nil check in inputMode ENTER handlers
--
-- BUGFIXES IN V1.3.2:
--   - Fixed nil access error when returning from submenu
--   - Fixed nil access error in sensor operations
--   - Added 11 nil checks for robustness
--
-- CRITICAL FIXES IN V1.3.1:
--   - PING: sendCmdData(0xFF, 0x01, "PING", 0xFF) [V1.1 params]
--   - HEART_BEAT: sendCmdData(0xFF, 0xFF, "HEART_BEAT", 0xFF) [V1.1 broadcast]
--   - CMD_DATA: data=0xFF [V1.1 params]
--
-- CRITICAL OPTIMIZATIONS FOR LOW MEMORY:
--   - File size: 25KB (vs 78KB in V1.1)
--   - No color screen code
--   - No log system
--   - No modal/popup system
--   - Simplified UI (text only, no cards/borders)
--   - Correct CRSF timing (checkReceivedData at start of run)
--   - 500ms auto-search interval
--   - 2 second heartbeat interval

--[[ Table Library Compatibility ]]
if not table then
    table = {}
end

if not table.insert then
    function table.insert(t, v)
        t[#t + 1] = v
    end
end

if not table.remove then
    function table.remove(t, idx)
        local n = #t
        idx = idx or n
        if idx < 1 or idx > n then return nil end
        local v = t[idx]
        for i = idx, n - 1 do
            t[i] = t[i + 1]
        end
        t[n] = nil
        return v
    end
end

if not table.sort then
    function table.sort(t, comp)
        local n = #t
        for i = 1, n - 1 do
            local min = i
            for j = i + 1, n do
                local swap
                if comp then
                    swap = comp(t[j], t[min])
                else
                    swap = t[j] < t[min]
                end
                if swap then min = j end
            end
            if min ~= i then
                t[i], t[min] = t[min], t[i]
            end
        end
    end
end

if not table.concat then
    function table.concat(list, sep, i, j)
        sep = sep or ""
        i = i or 1
        j = j or #list
        local result = ""
        for idx = i, j do
            if idx > i then result = result .. sep end
            local v = list[idx]
            if v ~= nil then result = result .. tostring(v) end
        end
        return result
    end
end

--[[ Command Definitions ]]
local CMD = {   
    PING                = {num=0,  type=3},
    LED_ONOFF           = {num=1,  type=3},
    SENSOR_POWER        = {num=2,  type=3},
    REBOOT              = {num=3,  type=1},
    CALIBRATE           = {num=4,  type=1},
    CALIBRATE_END       = {num=5,  type=1},
    PID_CONFIG          = {num=6,  type=2},
    RESET_CONFIG        = {num=7,  type=1},
    UNIT_CHANGE         = {num=8,  type=3},
    HEART_BEAT          = {num=9,  type=1},
    Moto_poles          = {num=10, type=2},
    CMD_OVER            = {num=11, type=1},
    CMD_DATA            = {num=12, type=1},
    SET_RATE_OFFSET     = {num=13, type=1},
    Set_CELL_ID         = {num=14, type=1},
    Set_RPM_ID          = {num=14, type=1},
    Set_GPS_Mode        = {num=15, type=4, options={
        {value=1, name="Speed"},
        {value=2, name="Global"},
    }},    -- Set GPS mode (1=Speed, 2=Global)
    SET_CELL_COMBINE    = {num=16, type=3},
    SET_CAPACITY        = {num=17, type=2},
    FIRMWARE_VERSION    = {num=18, type=5},      -- Firmware version (read-only text display)
    FIRMWARE_UPDATE     = {num=19, type=6},      -- Firmware update (with confirmation dialog)
}

local CMD_NUM_TO_NAME = {}
for name, def in pairs(CMD) do
    CMD_NUM_TO_NAME[def.num] = name
end

--[[ Frame Types ]]
-- Helper function to format function names for display (replace underscores with spaces)
local function formatFunctionName(name)
    if name then
        return string.gsub(name, "_", " ")
    end
    return name
end

local CRSF_FRAMETYPE_MSP_REQ = 0x7A  
local CRSF_FRAMETYPE_MSP_RESP = 0x7B  
local CRSF_FRAMETYPE_MSP_WRITE = 0x7C 

--[[ Addresses ]]
local CRSF_ADDRESS_BETAFLIGHT = 0xC8  
local CRSF_ADDRESS_RADIO_TRANSMITTER = 0xEA  

--[[ Sensor Types ]]
local SENSOR_TYPE_BARO = 0x01
local SENSOR_TYPE_CELL = 0x02
local SENSOR_TYPE_GPS = 0x03
local SENSOR_TYPE_CURRENT = 0x04
local SENSOR_TYPE_AIR_SPEED = 0x05
local SENSOR_TYPE_ATTITUDE = 0x06
local SENSOR_TYPE_VARIO = 0x07
local SENSOR_TYPE_RPM = 0x08
local SENSOR_TYPE_TEMP = 0x09

local SENSOR_TYPE_NAMES = {
    [SENSOR_TYPE_BARO] = "BARO",
    [SENSOR_TYPE_CELL] = "CELL", 
    [SENSOR_TYPE_CURRENT] = "CURRENT",
    [SENSOR_TYPE_AIR_SPEED] = "AIR_SPD",
    [SENSOR_TYPE_RPM] = "RPM",
    [SENSOR_TYPE_TEMP] = "TEMP",
    [SENSOR_TYPE_GPS] = "GPS",
    [SENSOR_TYPE_ATTITUDE] = "ATTITUD",
    [SENSOR_TYPE_VARIO] = "VARIO",
}

--[[ Sensor Capabilities ]]
local SENSOR_CAPABILITY = {
    [SENSOR_TYPE_BARO] =     {"LED ONOFF", "SENSOR POWER", "REBOOT", "CALIBRATE", "RESET ONFIG", "FIRMWARE VERSION", "FIRMWARE UPDATE"},
    [SENSOR_TYPE_CELL] =     {"LED ONOFF", "SENSOR POWER", "REBOOT", "Set CELL ID", "SET CELL COMBINE","CALIBRATE", "UNIT CHANGE", "RESET CONFIG", "FIRMWARE VERSION", "FIRMWARE UPDATE"},
    [SENSOR_TYPE_CURRENT] =  {"LED ONOFF", "SENSOR POWER", "REBOOT", "SET CAPACITY","RESET CONFIG", "FIRMWARE VERSION", "FIRMWARE UPDATE"},
    [SENSOR_TYPE_AIR_SPEED] ={"LED ONOFF", "SENSOR POWER", "REBOOT", "PID CONFIG", "RESET CONFIG", "FIRMWARE VERSION", "FIRMWARE UPDATE"},
    [SENSOR_TYPE_ATTITUDE] = {"LED ONOFF", "SENSOR POWER", "REBOOT", "RESET CONFIG", "FIRMWARE VERSION", "FIRMWARE UPDATE"},
    [SENSOR_TYPE_RPM] =      {"LED ONOFF", "SENSOR POWER", "REBOOT", "Set RPM ID","Moto poles","SET RATE OFFSET","RESET CONFIG", "FIRMWARE VERSION", "FIRMWARE UPDATE"},
    [SENSOR_TYPE_TEMP] =     {"LED ONOFF", "SENSOR POWER", "REBOOT", "RESET CONFIG", "FIRMWARE VERSION", "FIRMWARE UPDATE"},
    [SENSOR_TYPE_GPS] =      {"LED ONOFF", "SENSOR POWER", "REBOOT", "Set GPS Mode", "RESET CONFIG", "FIRMWARE VERSION", "FIRMWARE UPDATE"},
}


--[[ Screen Configuration ]]
local LCD_W = LCD_W or 212
local LCD_H = LCD_H or 64
local ROW_H = (LCD_H <= 64) and 10 or 12
local MAX_ROWS = math.floor((LCD_H - 12) / ROW_H)
local SMALL_SCREEN = (LCD_W <= 128)

--[[ Global State ]]
local sensors = {}
local selected = 1
local scroll = 0
local deviceList = {}
local submenu = nil
local inputMode = nil
local submenuStates = {}
local submenuLoading = false
local submenuLastRequestDev = nil
local submenuDevice = nil
local submenuOptions = {}
local pendingOps = {}
local ACK_TIMEOUT_SEC = 1.5
-- Confirmation dialog for firmware update (type=6)
local confirmModal = { visible = false, selected = 0, deviceType = nil, deviceId = nil, funcName = nil }
-- selected: 0 = Cancel (default), 1 = Confirm

-- CRITICAL: Use original timing values
local lastPingTime = 0
local lastHeartBeatTime = 0
local heartbeatInterval = 2  -- 2 seconds (original value)
local heartbeatEnabled = false  -- Start disabled
local pinged = false
local lastOfflineCheckTime = 0
local missedThreshold = 3  -- Original value

-- CRITICAL: Auto search with correct timing
local autoSearching = true  -- Auto search on startup
local lastAutoSearchTime = 0
local autoSearchInterval = 0.5  -- 500ms (original value, NOT 2 seconds!)

--[[ Helper Functions ]]
local function clamp(x, a, b)
    if x < a then return a elseif x > b then return b else return x end
end

local function makePendingKey(devType, devId, cmdNum)
    return (devType or 0) * 10000 + (devId or 0) * 100 + (cmdNum or 0)
end

local function getSensorTypeName(sensorType)
    return SENSOR_TYPE_NAMES[sensorType] or "UNKN"
end

local function splitUint16LE(val)
    val = val or 0
    local lo = val % 256
    local hi = math.floor(val / 256) % 256
    return lo, hi
end

local function combineUint16LE(lo, hi)
    lo = lo or 0
    hi = hi or 0
    return lo + hi * 256
end

-- Format firmware version: uint16_t -> vX.X format
-- Example: 10 -> v1.0, 112 -> v11.2
local function formatFirmwareVersion(version)
    if not version or version == 0 then
        return "N/A"
    end
    local major = math.floor(version / 10)
    local minor = version % 10
    return string.format("v%d.%d", major, minor)
end

-- Format firmware version: uint16_t -> vX.X format
-- Example: 10 -> v1.0, 112 -> v11.2
local function formatFirmwareVersion(version)
    if not version or version == 0 then
        return "N/A"
    end
    local major = math.floor(version / 10)
    local minor = version % 10
    return string.format("v%d.%d", major, minor)
end

--[[ Communication Functions ]]
local function sendCmdData(devType, id, cmd, data)
    if not crossfireTelemetryPush then
        return false
    end

    local payload = { CRSF_ADDRESS_BETAFLIGHT, CRSF_ADDRESS_RADIO_TRANSMITTER }
    payload[1 + 2] = devType
    payload[2 + 2] = id
    payload[3 + 2] = CMD[cmd].num

    local cmdDef = CMD[cmd]
    if type(data) == "table" then
        for i = 1, #data do
            payload[5 + i] = data[i]
        end
    elseif data ~= nil then
        if cmdDef and cmdDef.type == 2 then
            local lo, hi = splitUint16LE(data)
            payload[6] = lo
            payload[7] = hi
        else
            payload[6] = data
        end
    end

    crossfireTelemetryPush(CRSF_FRAMETYPE_MSP_WRITE, payload)
    
    if CMD[cmd] and cmd ~= "CMD_DATA" and cmd ~= "HEART_BEAT" and cmd ~= "PING" then
        local key = makePendingKey(devType, id, CMD[cmd].num)
        pendingOps[key] = {
            sentAt = getTime() / 100,
            valueSent = (type(data) == "table" and data[1]) or data,
            deviceType = devType,
            deviceId = id,
            cmdNum = CMD[cmd].num,
            funcName = cmd,
        }
    end
    return true
end

local function ping()
    sendCmdData(0xFF, 0x01, "PING", 0xFF)
end

local function heartBeat()
    sendCmdData(0xFF, 0xFF, "HEART_BEAT", 0xFF)
end

local function checkReceivedData()
    if not crossfireTelemetryPop then
        return
    end
    
    local cmd, frame = crossfireTelemetryPop()
    
    if cmd ~= CRSF_FRAMETYPE_MSP_RESP and cmd ~= CRSF_FRAMETYPE_MSP_REQ and cmd ~= CRSF_FRAMETYPE_MSP_WRITE then
        return
    end
    
    if cmd == nil then
        return
    end
    
    if frame and #frame > 0 then
        -- CMD_DATA response parsing
        if submenuLoading and submenuLastRequestDev and frame[3] == submenuLastRequestDev.type and frame[4] == submenuLastRequestDev.id and frame[5] == CMD.CMD_DATA.num then
            local devId = frame[4]
            submenuStates[devId] = submenuStates[devId] or {}
            local i = 7
            while i + 1 <= #frame do
                local cmdNum = frame[i]
                local funcName = nil
                for k, v in pairs(CMD) do
                    if v.num == cmdNum then funcName = k break end
                end
                if funcName then
                    local def = CMD[funcName]
                    if def and def.type == 2 then
                        local lo = frame[i + 1]
                        local hi = frame[i + 2]
                        if hi ~= nil then
                            submenuStates[devId][funcName] = combineUint16LE(lo, hi)
                            i = i + 3
                        else
                            submenuStates[devId][funcName] = lo or 0
                            i = i + 2
                        end
                    elseif def and def.type == 5 then
                        -- type=5 is read-only text display (uint16_t, 2 bytes)
                        local lo = frame[i + 1]
                        local hi = frame[i + 2]
                        if hi ~= nil then
                            submenuStates[devId][funcName] = combineUint16LE(lo, hi)
                            i = i + 3
                        else
                            submenuStates[devId][funcName] = lo or 0
                            i = i + 2
                        end
                    else
                        local dataVal = frame[i + 1]
                        submenuStates[devId][funcName] = dataVal
                        i = i + 2
                    end
                else
                    i = i + 2
                end
            end
            submenuLoading = false
            if submenuDevice and submenuDevice.id == devId then
                submenuOptions = SENSOR_CAPABILITY[submenuDevice.type] or {}
            end
        end
        
        -- ACK processing
        do
            local devType = frame[3]
            local devId   = frame[4]
            local cmdNum  = frame[5]
            if devType and devId and cmdNum then
                local funcName = CMD_NUM_TO_NAME[cmdNum]
                if funcName and funcName ~= "CMD_DATA" then
                    local key = makePendingKey(devType, devId, cmdNum)
                    local pending = pendingOps[key]
                    if pending then
                        local now = getTime() / 100
                        if (now - pending.sentAt) <= ACK_TIMEOUT_SEC then
                            local c = CMD[funcName]
                            if c then
                                -- Parse ACK data value: type=2 and type=5 support two bytes
                                local dataVal
                                if c.type == 2 or c.type == 5 then
                                    local lo = frame[6]
                                    local hi = frame[7]
                                    if hi ~= nil then
                                        dataVal = combineUint16LE(lo, hi)
                                    else
                                        dataVal = lo
                                    end
                                else
                                    dataVal = frame[6]
                                end
                                
                                submenuStates[devId] = submenuStates[devId] or {}
                                if c.type == 2 or c.type == 3 or c.type == 4 or c.type == 5 or c.type == 6 then
                                    if dataVal ~= nil then
                                        submenuStates[devId][funcName] = dataVal
                                    end
                                end
                            end
                            pendingOps[key] = nil
                        else
                            pendingOps[key] = nil
                        end
                    end
                end
            end
        end
        
        -- Device registration
        if frame[5] == CMD.PING.num and #frame >= 7 then
            local devType = frame[3]
            local devId = frame[4]
            local chars = {}
            for i = 7, #frame do
                local b = frame[i]
                if b == 0 then break end
                chars[#chars+1] = string.char(b)
            end
            local devName = table.concat(chars)
            if not sensors[devId] then
                sensors[devId] = {type = devType, id = devId, lastSeen = getTime()/100, name = devName, missedHeartbeats = 0}
            else
                sensors[devId].type = devType
                if not sensors[devId].name or sensors[devId].name == "" then
                    sensors[devId].name = devName
                end
                sensors[devId].lastSeen = getTime()/100
                sensors[devId].missedHeartbeats = 0
                sensors[devId].offline = nil
            end
        else
            local devType = frame[3]
            local devId = frame[4]
            local devName = ""
            if #frame >= 7 then
                local chars = {}
                for i = 7, #frame do
                    local b = frame[i]
                    if b == 0 then break end
                    chars[#chars+1] = string.char(b)
                end
                devName = table.concat(chars)
            end
            if devType and devId and devId > 0 then
                if not sensors[devId] then
                    sensors[devId] = {type = devType, id = devId, lastSeen = getTime()/100, name = devName, missedHeartbeats = 0}
                else
                    if sensors[devId].type ~= devType then
                        sensors[devId].type = devType
                    end
                    if devName ~= "" then
                        sensors[devId].name = devName
                    end
                    sensors[devId].lastSeen = getTime()/100
                    sensors[devId].missedHeartbeats = 0
                    sensors[devId].offline = nil
                end
            end
        end
    end
end

local function cleanupPendingOps()
    local now = getTime() / 100
    for key, pending in pairs(pendingOps) do
        if now - pending.sentAt > ACK_TIMEOUT_SEC then
            pendingOps[key] = nil
        end
    end
end

--[[ UI Drawing ]]
local function drawHeader(title)
    lcd.drawText(1, 1, title, INVERS)
    lcd.drawLine(0, 11, LCD_W, 11, SOLID, 0)
end

-- Confirmation dialog for firmware update (type=6)
local function drawConfirmModal()
    if not confirmModal.visible then return end
    
    local screenW = LCD_W or 212
    local screenH = LCD_H or 64
    local titleText = "Firmware Update"
    local messageText = "Are you sure?"
    local cancelText = "Cancel"
    local confirmText = "Confirm"
    local paddingH = 14
    local paddingV = 12
    local lineGap = 6
    local lineH = 12
    local buttonH = 16

    local getWidth = function(txt)
        return (#txt) * 6
    end

    local titleW = getWidth(titleText)
    local messageW = getWidth(messageText)
    local cancelW = getWidth(cancelText)
    local confirmW = getWidth(confirmText)
    local contentW = math.max(titleW, messageW, cancelW + confirmW + 20)
    
    local targetW = math.floor(screenW * 0.6)
    local minW = contentW + paddingH * 2
    local boxW = math.max(targetW, minW)
    if boxW > screenW - 10 then boxW = screenW - 10 end

    local targetH = math.floor(screenH * 0.55)
    local minH = paddingV * 2 + lineH * 2 + buttonH + lineGap * 2 + 10
    local boxH = math.max(targetH, minH)
    if boxH > screenH - 8 then boxH = screenH - 8 end

    local x = math.floor((screenW - boxW) / 2)
    local y = math.floor((screenH - boxH) / 2)

    -- Black and white screen - simple design
    safeFillRect(x, y, boxW, boxH, ERASE)
    lcd.drawRectangle(x, y, boxW, boxH, SOLID)
    
    -- Draw title
    local titleX = x + math.floor((boxW - titleW) / 2)
    lcd.drawText(titleX, y + paddingV, titleText, (FIXEDWIDTH or 0) + INVERS)
    
    -- Draw message
    local messageX = x + math.floor((boxW - messageW) / 2)
    local messageY = y + paddingV + lineH + lineGap
    lcd.drawText(messageX, messageY, messageText, (FIXEDWIDTH or 0))
    
    -- Draw buttons
    local buttonY = y + boxH - buttonH - paddingV
    local buttonSpacing = 10
    local buttonW = math.floor((boxW - paddingH * 2 - buttonSpacing) / 2)
    
    -- Cancel button
    local cancelX = x + paddingH
    if confirmModal.selected == 0 then
        safeFillRect(cancelX, buttonY, buttonW, buttonH, SOLID)
        local cancelTextX = cancelX + math.floor((buttonW - cancelW) / 2)
        local cancelTextY = buttonY + math.floor((buttonH - lineH) / 2)
        lcd.drawText(cancelTextX, cancelTextY, cancelText, (FIXEDWIDTH or 0) + INVERS)
    else
        lcd.drawRectangle(cancelX, buttonY, buttonW, buttonH, SOLID)
        local cancelTextX = cancelX + math.floor((buttonW - cancelW) / 2)
        local cancelTextY = buttonY + math.floor((buttonH - lineH) / 2)
        lcd.drawText(cancelTextX, cancelTextY, cancelText, (FIXEDWIDTH or 0))
    end
    
    -- Confirm button
    local confirmX = cancelX + buttonW + buttonSpacing
    if confirmModal.selected == 1 then
        safeFillRect(confirmX, buttonY, buttonW, buttonH, SOLID)
        local confirmTextX = confirmX + math.floor((buttonW - confirmW) / 2)
        local confirmTextY = buttonY + math.floor((buttonH - lineH) / 2)
        lcd.drawText(confirmTextX, confirmTextY, confirmText, (FIXEDWIDTH or 0) + INVERS)
    else
        lcd.drawRectangle(confirmX, buttonY, buttonW, buttonH, SOLID)
        local confirmTextX = confirmX + math.floor((buttonW - confirmW) / 2)
        local confirmTextY = buttonY + math.floor((buttonH - lineH) / 2)
        lcd.drawText(confirmTextX, confirmTextY, confirmText, (FIXEDWIDTH or 0))
    end
end

local function drawMenuItem(y, text, isSelected, online)
    local attr = isSelected and INVERS or 0
    local icon = online and "+" or "x"
    lcd.drawText(2, y, icon, attr)
    lcd.drawText(12, y, text, attr)
end

local function drawInputBox(y, label, value, isEditing)
    lcd.drawText(2, y, label, 0)
    local valStr = tostring(value)
    local attr = isEditing and (INVERS + BLINK) or INVERS
    lcd.drawText(LCD_W - #valStr * 6 - 4, y, valStr, attr)
end

--[[ Main Menu ]]
local function drawMainMenu(event)
    drawHeader("RM Sensor")
    
    -- Update device list
    deviceList = {}
    for id, dev in pairs(sensors) do
        table.insert(deviceList, dev)
    end
    table.sort(deviceList, function(a, b) return a.id < b.id end)
    
    local totalRows = #deviceList + 1
    
    -- Handle input
    if event == EVT_VIRTUAL_NEXT or event == EVT_VIRTUAL_NEXT_REPT then
        selected = selected + 1
        if selected >= totalRows then selected = 0 end
    elseif event == EVT_VIRTUAL_PREV or event == EVT_VIRTUAL_PREV_REPT then
        selected = selected - 1
        if selected < 0 then selected = totalRows - 1 end
    elseif event == EVT_VIRTUAL_ENTER then
        if selected == 0 then
            -- Manual search trigger
            ping()
            lastPingTime = getTime() / 100
            pinged = true
            heartbeatEnabled = false
            autoSearching = true
            lastAutoSearchTime = getTime() / 100
        elseif selected > 0 and selected <= #deviceList then
            local dev = deviceList[selected]
            submenuDevice = dev
            submenuOptions = SENSOR_CAPABILITY[dev.type] or {}
            submenu = {
                devId = dev.id,
                devType = dev.type,
                idx = 1,
                scroll = 0
            }
            submenuLoading = true
            submenuLastRequestDev = dev
            sendCmdData(dev.type, dev.id, "CMD_DATA", 0xFF)
        end
    end
    
    -- Adjust scroll
    if selected < scroll then scroll = selected end
    if selected >= scroll + MAX_ROWS then scroll = selected - MAX_ROWS + 1 end
    
    -- Draw items
    local y = 14
    if scroll == 0 then
        drawMenuItem(y, "Search Sensors", selected == 0, true)
        y = y + ROW_H
    end
    
    for i = math.max(1, scroll), math.min(#deviceList, scroll + MAX_ROWS - 1) do
        local dev = deviceList[i]
        local online = not dev.offline
        local label = getSensorTypeName(dev.type) .. " [" .. dev.id .. "]"
        if dev.name and dev.name ~= "" then
            label = label .. " " .. dev.name
        end
        drawMenuItem(y, label, selected == i, online)
        y = y + ROW_H
    end
end

--[[ Submenu ]]
local function drawSubmenu(event)
    if not submenu or not submenuDevice then
        submenu = nil
        return
    end
    
    -- Handle confirmation dialog if visible (must be first)
    if confirmModal.visible then
        if event == EVT_VIRTUAL_NEXT or event == EVT_VIRTUAL_NEXT_REPT then
            -- Switch to Confirm (1)
            confirmModal.selected = 1
            drawConfirmModal()
            return
        elseif event == EVT_VIRTUAL_PREV or event == EVT_VIRTUAL_PREV_REPT then
            -- Switch to Cancel (0)
            confirmModal.selected = 0
            drawConfirmModal()
            return
        elseif event == EVT_VIRTUAL_ENTER then
            if confirmModal.selected == 0 then
                -- Cancel selected, close dialog
                confirmModal.visible = false
                confirmModal.selected = 0
                confirmModal.deviceType = nil
                confirmModal.deviceId = nil
                confirmModal.funcName = nil
                return
            else
                -- Confirm selected, send update command
                if confirmModal.deviceType and confirmModal.deviceId and confirmModal.funcName then
                    sendCmdData(confirmModal.deviceType, confirmModal.deviceId, confirmModal.funcName, 0xA5)
                end
                -- Close confirmation dialog
                confirmModal.visible = false
                confirmModal.selected = 0
                confirmModal.deviceType = nil
                confirmModal.deviceId = nil
                confirmModal.funcName = nil
                return
            end
        elseif event == EVT_VIRTUAL_EXIT then
            -- Exit = Cancel
            confirmModal.visible = false
            confirmModal.selected = 0
            confirmModal.deviceType = nil
            confirmModal.deviceId = nil
            confirmModal.funcName = nil
            return
        end
        drawConfirmModal()
        return
    end
    
    drawHeader("ID:" .. submenu.devId .. " " .. getSensorTypeName(submenu.devType))
    
    -- Draw firmware version if available (moved to avoid overlap with Back button)
    if submenuStates[submenu.devId] and submenuStates[submenu.devId]["FIRMWARE_VERSION"] then
        local fwVersion = submenuStates[submenu.devId]["FIRMWARE_VERSION"]
        --local fwText = "FW: " .. formatFirmwareVersion(fwVersion)
        --lcd.drawText(2, 12, fwText, 0)
    end
    
    if submenuLoading then
        lcd.drawText(LCD_W / 2 - 20, LCD_H / 2, "Loading...", 0)
        return
    end
    
    if inputMode then
        -- Input mode
        local func = inputMode.func
        if not func then
            inputMode = nil
            return
        end
        local cmdDef = CMD[func]
        if not cmdDef then
            inputMode = nil
            return
        end
        
        if cmdDef.type == 4 then
            -- Option selection
            local opts = cmdDef.options
            if event == EVT_VIRTUAL_NEXT or event == EVT_VIRTUAL_NEXT_REPT then
                inputMode.value = inputMode.value + 1
                if inputMode.value > #opts then inputMode.value = 1 end
            elseif event == EVT_VIRTUAL_PREV or event == EVT_VIRTUAL_PREV_REPT then
                inputMode.value = inputMode.value - 1
                if inputMode.value < 1 then inputMode.value = #opts end
            elseif event == EVT_VIRTUAL_ENTER then
                if submenu and opts and opts[inputMode.value] then
                    sendCmdData(submenu.devType, submenu.devId, func, opts[inputMode.value].value)
                end
                inputMode = nil
                return
            elseif event == EVT_VIRTUAL_EXIT then
                inputMode = nil
                return
            end
            
            if inputMode and opts then
                local y = 14
                for i = 1, #opts do
                    local attr = (i == inputMode.value) and INVERS or 0
                    lcd.drawText(2, y, opts[i].name, attr)
                    y = y + ROW_H
                end
            end
        else
            -- Numeric input with acceleration (time-based like Color version)
            if event == EVT_VIRTUAL_NEXT or event == EVT_VIRTUAL_NEXT_REPT then
                -- Initialize acceleration tracking
                if not inputMode.lastTime then
                    inputMode.lastTime = 0
                    inputMode.repeatCount = 0
                end
                
                -- Time-based acceleration (same as Color version)
                local nowt = getTime() / 100
                if inputMode.lastTime == 0 or (nowt - inputMode.lastTime) > 0.5 then
                    inputMode.repeatCount = 0
                else
                    inputMode.repeatCount = inputMode.repeatCount + 1
                end
                inputMode.lastTime = nowt
                
                -- Calculate step with acceleration
                local func = inputMode.func
                local base = 1
                if func == "SET_CAPACITY" then
                    base = 10  -- SET_CAPACITY minimum step is 10
                end
                
                local mul = 1
                if inputMode.repeatCount >= 40 then
                    mul = 500
                elseif inputMode.repeatCount >= 30 then
                    mul = 100
                elseif inputMode.repeatCount >= 20 then
                    mul = 50
                elseif inputMode.repeatCount >= 10 then
                    mul = 10
                end
                
                local step = base * mul
                inputMode.value = clamp(inputMode.value + step, inputMode.min, inputMode.max)
                
                -- Round to step for SET_CAPACITY
                if func == "SET_CAPACITY" then
                    inputMode.value = math.floor(inputMode.value / 10) * 10
                end
            elseif event == EVT_VIRTUAL_PREV or event == EVT_VIRTUAL_PREV_REPT then
                -- Initialize acceleration tracking
                if not inputMode.lastTime then
                    inputMode.lastTime = 0
                    inputMode.repeatCount = 0
                end
                
                -- Time-based acceleration (same as Color version)
                local nowt = getTime() / 100
                if inputMode.lastTime == 0 or (nowt - inputMode.lastTime) > 0.5 then
                    inputMode.repeatCount = 0
                else
                    inputMode.repeatCount = inputMode.repeatCount + 1
                end
                inputMode.lastTime = nowt
                
                -- Calculate step with acceleration
                local func = inputMode.func
                local base = 1
                if func == "SET_CAPACITY" then
                    base = 10  -- SET_CAPACITY minimum step is 10
                end
                
                local mul = 1
                if inputMode.repeatCount >= 40 then
                    mul = 500
                elseif inputMode.repeatCount >= 30 then
                    mul = 100
                elseif inputMode.repeatCount >= 20 then
                    mul = 50
                elseif inputMode.repeatCount >= 10 then
                    mul = 10
                end
                
                local step = base * mul
                inputMode.value = clamp(inputMode.value - step, inputMode.min, inputMode.max)
                
                -- Round to step for SET_CAPACITY
                if func == "SET_CAPACITY" then
                    inputMode.value = math.floor(inputMode.value / 10) * 10
                end
            elseif event == EVT_VIRTUAL_ENTER then
                if submenu then
                    sendCmdData(submenu.devType, submenu.devId, func, inputMode.value)
                end
                inputMode = nil
                return
            elseif event == EVT_VIRTUAL_EXIT then
                inputMode = nil
                return
            end
            
            if inputMode then
                drawInputBox(20, func, inputMode.value, true)
            end
        end
        return
    end
    
    -- Submenu list
    local totalRows = #submenuOptions + 1
    
    if event == EVT_VIRTUAL_NEXT or event == EVT_VIRTUAL_NEXT_REPT then
        submenu.idx = submenu.idx + 1
        if submenu.idx >= totalRows then submenu.idx = 0 end
    elseif event == EVT_VIRTUAL_PREV or event == EVT_VIRTUAL_PREV_REPT then
        submenu.idx = submenu.idx - 1
        if submenu.idx < 0 then submenu.idx = totalRows - 1 end
    elseif event == EVT_VIRTUAL_ENTER then
        if submenu.idx == 0 then
            submenu = nil
            submenuDevice = nil
            submenuOptions = {}
            return
        else
            local func = submenuOptions[submenu.idx]
            if not func then return end
            local cmdDef = CMD[func]
            if not cmdDef then return end
            if cmdDef.type == 5 then
                -- type=5 is read-only, do nothing
                return
            elseif cmdDef.type == 6 then
                -- type=6 is firmware update, show confirmation dialog
                confirmModal.visible = true
                confirmModal.selected = 0  -- Default to Cancel
                confirmModal.deviceType = submenu.devType
                confirmModal.deviceId = submenu.devId
                confirmModal.funcName = func
                return
            elseif cmdDef.type == 1 then
                sendCmdData(submenu.devType, submenu.devId, func, 1)
            elseif cmdDef.type == 2 then
                local currentVal = (submenuStates[submenu.devId] and submenuStates[submenu.devId][func]) or 0
                inputMode = {
                    func = func,
                    value = currentVal,
                    min = 0,
                    max = 65535
                }
            elseif cmdDef.type == 3 then
                local currentVal = (submenuStates[submenu.devId] and submenuStates[submenu.devId][func]) or 0
                local newVal = (currentVal == 1) and 2 or 1
                sendCmdData(submenu.devType, submenu.devId, func, newVal)
            elseif cmdDef.type == 4 then
                local currentVal = (submenuStates[submenu.devId] and submenuStates[submenu.devId][func]) or 0
                local opts = cmdDef.options
                local currentIdx = 1
                for i = 1, #opts do
                    if opts[i].value == currentVal then
                        currentIdx = i
                        break
                    end
                end
                inputMode = {
                    func = func,
                    value = currentIdx
                }
            end
        end
    elseif event == EVT_VIRTUAL_EXIT then
        submenu = nil
        submenuDevice = nil
        submenuOptions = {}
        return
    end
    
    -- Adjust scroll
    if submenu and submenu.idx < submenu.scroll then submenu.scroll = submenu.idx end
    if submenu and submenu.idx >= submenu.scroll + MAX_ROWS then submenu.scroll = submenu.idx - MAX_ROWS + 1 end
    
    -- Draw items
    local y = 14
    if submenu.scroll == 0 then
        drawMenuItem(y, "< Back", submenu.idx == 0, true)
        y = y + ROW_H
    end
    
    for i = math.max(1, submenu.scroll), math.min(#submenuOptions, submenu.scroll + MAX_ROWS - 1) do
        local func = submenuOptions[i]
        if func then
            local cmdDef = CMD[func]
            local label = formatFunctionName(func)
            
            if cmdDef and cmdDef.type == 3 then
                local val = (submenuStates[submenu.devId] and submenuStates[submenu.devId][func]) or 0
                label = label .. ": " .. ((val == 1) and "ON" or "OFF")
            elseif cmdDef and cmdDef.type == 2 then
                local val = (submenuStates[submenu.devId] and submenuStates[submenu.devId][func]) or 0
                label = label .. ": " .. val
            elseif cmdDef and cmdDef.type == 4 then
                local val = (submenuStates[submenu.devId] and submenuStates[submenu.devId][func]) or 0
                local opts = cmdDef.options
                if opts then
                    for j = 1, #opts do
                        if opts[j].value == val then
                            label = label .. ": " .. opts[j].name
                            break
                        end
                    end
                end
            elseif cmdDef and cmdDef.type == 5 then
                -- Read-only text display type
                local val = (submenuStates[submenu.devId] and submenuStates[submenu.devId][func]) or 0
                if func == "FIRMWARE_VERSION" then
                    label = label .. ": " .. formatFirmwareVersion(val)
                else
                    label = label .. ": " .. val
                end
            elseif cmdDef and cmdDef.type == 6 then
                -- Firmware update type
                label = label .. ": UPDATE"
            end
            
            drawMenuItem(y, label, submenu.idx == i, true)
            y = y + ROW_H
        end
    end
end

--[[ Main Loop ]]
local function run(event)
    lcd.clear()
    local now = getTime() / 100
    
    -- CRITICAL: Process CRSF data FIRST
    checkReceivedData()
    
    -- Enable heartbeat after ping
    if pinged and not heartbeatEnabled and (now - lastPingTime >= 2) then
        heartbeatEnabled = true
        lastHeartBeatTime = now
    end
    
    -- Send heartbeat
    if heartbeatEnabled and (now - lastHeartBeatTime >= heartbeatInterval) then
        heartBeat()
        lastHeartBeatTime = now
    end
    
    -- Offline detection with missed heartbeats counter
    if heartbeatEnabled and (now - lastOfflineCheckTime >= heartbeatInterval) then
        lastOfflineCheckTime = now
        for id, dev in pairs(sensors) do
            local timeout = heartbeatInterval * 1.5
            if now - dev.lastSeen > timeout then
                dev.missedHeartbeats = (dev.missedHeartbeats or 0) + 1
                if dev.missedHeartbeats >= missedThreshold then
                    dev.offline = true
                end
            else
                dev.missedHeartbeats = 0
                dev.offline = nil
            end
        end
    end
    
    -- CRITICAL: Auto search with 500ms interval (NOT 2 seconds!)
    if autoSearching then
        if (now - lastAutoSearchTime) >= autoSearchInterval then
            -- Check if sensor has been found
            local sensorCount = 0
            for _ in pairs(sensors) do
                sensorCount = sensorCount + 1
            end
            
            if sensorCount > 0 then
                -- Sensor found, stop automatic search
                autoSearching = false
            else
                -- Continue searching
                ping()
                lastAutoSearchTime = now
            end
        end
    end
    
    cleanupPendingOps()
    
    -- Draw confirmation dialog if visible (overlay)
    if confirmModal.visible then
        drawConfirmModal()
    end
    
    if submenu then
        drawSubmenu(event)
    else
        drawMainMenu(event)
    end
    
    return 0
end

local function init()
    selected = 1
    scroll = 0
    lastPingTime = 0
    lastHeartBeatTime = 0
    lastAutoSearchTime = 0
    lastOfflineCheckTime = 0
    autoSearching = true
    heartbeatEnabled = false
    pinged = false
end

return {init = init, run = run}
