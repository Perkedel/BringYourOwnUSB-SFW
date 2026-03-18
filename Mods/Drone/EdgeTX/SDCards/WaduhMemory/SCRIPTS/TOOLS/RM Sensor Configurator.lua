--[[ Instruction Set Definition ]]
-- V1.0 Version - Enhanced UI
-- type 1 is button, type 2 requires input data, type 3 is toggle button, type 4 is option, type 5 is read-only text display, type 6 is firmware update with confirmation dialog
local CMD = {   
    PING                = {num=0,  type=3},    -- Normal button       PING = 0,           -- Broadcast ping
    LED_ONOFF           = {num=1,  type=3},    -- Switch light, toggle button
    SENSOR_POWER        = {num=2,  type=3},    -- Switch device (does not send data, but can be remotely turned on) 3
    REBOOT              = {num=3,  type=1},    -- Reboot device
    CALIBRATE           = {num=4,  type=1},    -- Recalibrate
    CALIBRATE_END       = {num=5,  type=1},    -- End calibration
    PID_CONFIG          = {num=6,  type=2},    -- Requires input -- Configure PID
    RESET_CONFIG        = {num=7,  type=1},    -- Restore configuration
    UNIT_CHANGE         = {num=8,  type=3},    -- Unit switch
    HEART_BEAT          = {num=9,  type=1},    -- Heartbeat
    Moto_poles          = {num=10, type=2},    -- Motor poles -- requires input
    CMD_OVER            = {num=11, type=1},    -- Command operation completed, reply frame
    CMD_DATA            = {num=12, type=1},    -- Command data
    SET_RATE_OFFSET     = {num=13, type=1},    -- Set rate offset of rpm sensor
    Set_CELL_ID         = {num=14, type=1},    -- Set voltage sensor ID count    Don't worry because device type is also sent, so ID count won't conflict
    Set_RPM_ID          = {num=14, type=1},    -- Set RPM sensor ID count
    Set_GPS_Mode        = {num=15, type=4, options={
        {value=1, name="Speed Mode"},
        {value=2, name="Global Mode"},
    }},    -- Set GPS mode (1=Speed, 2=Global)
    SET_CELL_COMBINE    = {num=16, type=3},      -- Multiple cell combination requires input  Purpose is to toggle combination function
    SET_CAPACITY        = {num=17, type=2},      -- Set capacity
    FIRMWARE_VERSION    = {num=18, type=5},      -- Firmware version (read-only text display)
    FIRMWARE_UPDATE     = {num=19, type=6},      -- Firmware update (with confirmation dialog)
}

-- Reverse lookup table: CMD number -> name
local CMD_NUM_TO_NAME = {}
for name, def in pairs(CMD) do
    CMD_NUM_TO_NAME[def.num] = name
end

--[[ Frame Type Definition ]]
CRSF_FRAMETYPE_GPS              = 0x02
CRSF_FRAMETYPE_BATTERY_SENSOR   = 0x08
CRSF_FRAMETYPE_BARO_ALTITUDE    = 0x09
CRSF_FRAMETYPE_ATTITUDE         = 0x1E
CRSF_FRAMETYPE_ARDUPILOT_RESP   = 0x80   -- Ardupilot frames
CRSF_FRAMETYPE_AIR_SPEED        = 0x0A

-- --[[ Sensor Type Definition ]]
local SENSOR_TYPE_BARO      = 0x01   -- This design is to avoid conflict between sensor and crsf types. Sensors in crsf protocol have specific struct types.
local SENSOR_TYPE_CELL      = 0x02   -- Likely does not fit sensor, maybe one sensor has multiple attributes and functions.
local SENSOR_TYPE_GPS       = 0x03
local SENSOR_TYPE_CURRENT   = 0x04
local SENSOR_TYPE_AIR_SPEED = 0x05
local SENSOR_TYPE_ATTITUDE  = 0x06
local SENSOR_TYPE_VARIO     = 0x07
local SENSOR_TYPE_RPM       = 0x08
local SENSOR_TYPE_TEMP      = 0x09


--[[ Sensor Function Definition ]]
local SENSOR_CAPABILITY = {
    [SENSOR_TYPE_BARO] =     {"LED_ONOFF", "SENSOR_POWER", "REBOOT", "CALIBRATE", "RESET_CONFIG", "FIRMWARE_VERSION", "FIRMWARE_UPDATE"},
    [SENSOR_TYPE_CELL] =     {"LED_ONOFF", "SENSOR_POWER", "REBOOT", "Set_CELL_ID", "SET_CELL_COMBINE","CALIBRATE", "UNIT_CHANGE", "RESET_CONFIG", "FIRMWARE_VERSION", "FIRMWARE_UPDATE"},
    [SENSOR_TYPE_CURRENT] =  {"LED_ONOFF", "SENSOR_POWER", "REBOOT", "SET_CAPACITY","RESET_CONFIG", "FIRMWARE_VERSION", "FIRMWARE_UPDATE"},
    [SENSOR_TYPE_AIR_SPEED] ={"LED_ONOFF", "SENSOR_POWER", "REBOOT", "PID_CONFIG", "RESET_CONFIG", "FIRMWARE_VERSION", "FIRMWARE_UPDATE"},
    [SENSOR_TYPE_ATTITUDE] = {"LED_ONOFF", "SENSOR_POWER", "REBOOT", "RESET_CONFIG", "FIRMWARE_VERSION", "FIRMWARE_UPDATE"},
    [SENSOR_TYPE_RPM] =      {"LED_ONOFF", "SENSOR_POWER", "REBOOT", "Set_RPM_ID","Moto_poles","SET_RATE_OFFSET","RESET_CONFIG", "FIRMWARE_VERSION", "FIRMWARE_UPDATE"},
    [SENSOR_TYPE_TEMP] =     {"LED_ONOFF", "SENSOR_POWER", "REBOOT", "RESET_CONFIG", "FIRMWARE_VERSION", "FIRMWARE_UPDATE"},
    [SENSOR_TYPE_GPS] =      {"LED_ONOFF", "SENSOR_POWER", "REBOOT", "Set_GPS_Mode", "RESET_CONFIG", "FIRMWARE_VERSION", "FIRMWARE_UPDATE"},
}
-- Helper function to format function names for display (replace underscores with spaces)
local function formatFunctionName(name)
    if name then
        return string.gsub(name, "_", " ")
    end
    return name
end



--[[ Address Definition ]]
local CRSF_ADDRESS_BETAFLIGHT           = 0xC8  
local CRSF_ADDRESS_RADIO_TRANSMITTER    = 0xEA  


--[[ Frame Type Definition ]]
CRSF_FRAMETYPE_MSP_REQ      = 0x7A  
CRSF_FRAMETYPE_MSP_RESP     = 0x7B  
CRSF_FRAMETYPE_MSP_WRITE    = 0x7C 
CRSF_FRAME_CUSTOM_TELEM     = 0x88



-- Helper function to get text height for a given font flag
local function getTextHeight(fontFlag)
    if fontFlag == SMLSIZE then
        return 8
    elseif fontFlag == MIDSIZE or fontFlag == MED then
        return 16
    else
        -- Standard font with FIXEDWIDTH
        return 12
    end
end

-- Sensor type mapping table (for log display)
local SENSOR_TYPE_NAMES = {
    [SENSOR_TYPE_BARO] = "BARO",
    [SENSOR_TYPE_CELL] = "CELL", 
    [SENSOR_TYPE_CURRENT] = "CURRENT",
    [SENSOR_TYPE_AIR_SPEED] = "AIR_SPEED",
    [SENSOR_TYPE_RPM] = "RPM",
    [SENSOR_TYPE_TEMP] = "TEMP",
    [SENSOR_TYPE_ATTITUDE] = "ATTITUDE",
    [SENSOR_TYPE_VARIO] = "VARIO",
    [SENSOR_TYPE_GPS] = "GPS",
}

--[[ Variable Definition ]]
-- Reception variables
local receivedCount     = 0  -- Receive count
local lastReceivedData  = nil -- Last received data
local receivedTime      = 0  -- Last receive time

--[[ Script Program Data ]]
local selected = 1         -- Currently selected item (global variable to prevent loss on reload)
local scroll = scroll or 0 -- Current scroll line number
local sensors = {}         -- Sensor management table  key:id  value:{type, id, lastSeen, name, missedHeartbeats}
local logLines = {}        -- Log
local totalRows = 0        -- Total rows

-- Submenu related variables
local submenuActive = false
local submenuIndex = 1
local submenuOptions = {}
local submenuDevice = nil
local submenuStates = {} -- Structure: submenuStates[dev.id][func]
local submenuScroll = 0  -- Submenu scroll offset (only applies to function list)
local inputActive = false
local inputValue = 0
local inputMin = 0
local inputMax = 255
local inputType = 0 -- 0: none, 2: numeric, 4: mode selection
-- Numeric input accelerator
local inputAccel = { lastTime = 0, repeatCount = 0 }
-- Operation confirmation modal and pending confirmation queue
local ACK_TIMEOUT_SEC = 1.5
local pendingOps = {}   -- key: "type-id-cmd", value: {sentAt, valueSent, deviceType, deviceId, cmdNum, funcName}
local successModal = { visible = false, title = "", lines = {}, createdAt = 0 }
local modalQueue = {}
-- Confirmation dialog for firmware update (type=6)
local confirmModal = { visible = false, selected = 0, deviceType = nil, deviceId = nil, funcName = nil }
-- selected: 0 = Cancel (default), 1 = Confirm
-- Restore focus to the previous device when returning to the main list
local pendingFocusDeviceId = nil
-- Trigger a ping rebuild once after returning to the main list
local triggerPingOnReturn = false

local function makePendingKey(devType, devId, cmdNum)
    return string.format("%d-%d-%d", devType or -1, devId or -1, cmdNum or -1)
end

-- Compatibility handling: some EdgeTX black-and-white screen environments may not expose the standard table library
if table == nil then table = {} end
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

-- Compatible implementation of table.concat (not provided by some firmware)
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

local function enqueueModal(title, lines)
    table.insert(modalQueue, { title = title, lines = lines })
    -- Limit the length of the modal queue to avoid excessive memory usage
    if #modalQueue > 3 then
        table.remove(modalQueue, 1)
    end
end

local function showNextModal()
    if #modalQueue > 0 then
        local m = table.remove(modalQueue, 1)
        successModal.visible = true
        successModal.title = m.title or "Operation Successful"
        successModal.lines = m.lines or {}
        successModal.createdAt = getTime() / 100
    else
        successModal.visible = false
        successModal.title = ""
        successModal.lines = {}
        successModal.createdAt = 0
    end
end

local function closeModal()
    successModal.visible = false
    showNextModal()
end

-- Predeclare UI configuration (for subsequent functions to capture as upvalues)
local UI_CONFIG

-- Detect if color screen is available
local function isColorScreen()
    return lcd.RGB ~= nil
end

-- Get theme colors based on screen type
local function getThemeColors()
    if isColorScreen() then
        return {
            -- Color screen theme
            PRIMARY = lcd.RGB(41, 128, 185),      -- Blue
            PRIMARY_DARK = lcd.RGB(31, 97, 141),  -- Dark blue
            SUCCESS = lcd.RGB(46, 204, 113),      -- Green
            WARNING = lcd.RGB(241, 196, 15),      -- Yellow
            DANGER = lcd.RGB(231, 76, 60),        -- Red
            BACKGROUND = lcd.RGB(236, 240, 241),  -- Light gray
            CARD_BG = lcd.RGB(255, 255, 255),     -- White
            TEXT = lcd.RGB(44, 62, 80),           -- Dark gray
            TEXT_LIGHT = lcd.RGB(149, 165, 166),  -- Light gray
            BORDER = lcd.RGB(189, 195, 199),      -- Gray
            SHADOW = lcd.RGB(127, 140, 141),      -- Shadow
            OFFLINE = lcd.RGB(149, 165, 166),     -- Gray (offline)
        }
    else
        -- Black and white screen uses patterns
        return {
            PRIMARY = SOLID,
            SUCCESS = SOLID,
            WARNING = SOLID,
            DANGER = SOLID,
            BACKGROUND = 0,
            CARD_BG = 0,
            TEXT = SOLID,
            TEXT_LIGHT = SOLID,
            BORDER = SOLID,
            SHADOW = SOLID,
            OFFLINE = GREY_DEFAULT or SOLID,
        }
    end
end

local COLORS = getThemeColors()

-- 16-bit value helpers (little-endian)
local function splitUint16LE(value)
    local v = math.floor(value or 0) % 65536
    local lo = v % 256
    local hi = math.floor(v / 256)
    return lo, hi
end

local function combineUint16LE(lo, hi)
    if hi == nil then return lo or 0 end
    return (lo or 0) + (hi or 0) * 256
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

-- LCD API compatibility adaptation: provide safe degradation for missing drawing functions to avoid nil calls
local function safeFillRect(x, y, w, h, style)
    if lcd and lcd.drawFilledRectangle then
        lcd.drawFilledRectangle(x, y, w, h, style)
    elseif lcd and lcd.drawRectangle then
        lcd.drawRectangle(x, y, w, h, style)
    end
end

local function safeDrawCircle(x, y, r, style)
    if lcd and lcd.drawCircle then
        lcd.drawCircle(x, y, r, style)
    elseif lcd and lcd.drawLine then
        lcd.drawLine(x - r, y, x + r, y, style, 0)
        lcd.drawLine(x, y - r, x, y + r, style, 0)
    end
end

local function ensureLCDCompat()
    -- The compatibility layer is already provided through safe* wrappers
end

-- Enhanced modal dialog with better visual design
local function drawSuccessModal()
    if not successModal.visible then return end
    
    local screenW = LCD_W or 212
    local screenH = LCD_H or 64
    local titleText = "Operation completed"        
    local hintText  = "'ENTER' to confirm"    
    local paddingH = isColorScreen() and 20 or 14
    local paddingV = isColorScreen() and 16 or 12
    local lineGap = math.max(6, math.min(14, math.floor(screenH * 0.08)))
    local lineH = isColorScreen() and 16 or 12

    local getWidth = (lcd.getTextWidth and function(txt)
        return lcd.getTextWidth(0, txt)
    end) or function(txt)
        return (#txt) * 6
    end

    local titleW = getWidth(titleText)
    local hintW = getWidth(hintText)
    local contentW = math.max(titleW, hintW)

    local targetW = math.floor(screenW * (isColorScreen() and 0.6 or 0.48))
    local minW = contentW + paddingH * 2
    local boxW = math.max(targetW, minW)
    if boxW > screenW - 10 then boxW = screenW - 10 end

    local targetH = math.floor(screenH * (isColorScreen() and 0.5 or 0.45))
    local minH = paddingV * 2 + lineH * 2 + lineGap + 10
    local boxH = math.max(targetH, minH)
    if boxH > screenH - 8 then boxH = screenH - 8 end

    local x = math.floor((screenW - boxW) / 2)
    local y = math.floor((screenH - boxH) / 2)

    if isColorScreen() then
        -- Draw shadow for color screens
        safeFillRect(x + 3, y + 3, boxW, boxH, COLORS.SHADOW)
        -- Draw white background
        safeFillRect(x, y, boxW, boxH, COLORS.CARD_BG)
        -- Draw border
        lcd.drawRectangle(x, y, boxW, boxH, COLORS.PRIMARY)
        lcd.drawRectangle(x + 1, y + 1, boxW - 2, boxH - 2, COLORS.PRIMARY)
        
        -- Draw title with background
        local titleBgH = lineH + paddingV
        safeFillRect(x, y, boxW, titleBgH, COLORS.PRIMARY)
        local titleX = x + math.floor((boxW - titleW) / 2)
        lcd.drawText(titleX, y + math.floor(paddingV / 2), titleText, (FIXEDWIDTH or 0) + COLORS.CARD_BG)
        
        -- Draw hint text
        local hintX = x + math.floor((boxW - hintW) / 2)
        local hintY = y + boxH - lineH - math.floor(paddingV / 2)
        lcd.drawText(hintX, hintY, hintText, (FIXEDWIDTH or 0) + COLORS.TEXT_LIGHT)
    else
        -- Black and white screen - simple design
        safeFillRect(x, y, boxW, boxH, ERASE)
        lcd.drawRectangle(x, y, boxW, boxH, SOLID)
        
        local titleX = x + math.floor((boxW - titleW) / 2)
        local hintX = x + math.floor((boxW - hintW) / 2)
        local contentH = lineH * 2 + lineGap
        local contentTop = y + math.floor((boxH - contentH) / 2)
        lcd.drawText(titleX, contentTop, titleText, (FIXEDWIDTH or 0) + INVERS)
        lcd.drawText(hintX, contentTop + lineH + 2 + lineGap, hintText, (FIXEDWIDTH or 0) + INVERS)
    end
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
    local paddingH = isColorScreen() and 20 or 14
    local paddingV = isColorScreen() and 16 or 12
    local lineGap = math.max(6, math.min(14, math.floor(screenH * 0.08)))
    local lineH = isColorScreen() and 16 or 12
    local buttonH = isColorScreen() and 20 or 16

    local getWidth = (lcd.getTextWidth and function(txt)
        return lcd.getTextWidth(0, txt)
    end) or function(txt)
        return (#txt) * 6
    end

    local titleW = getWidth(titleText)
    local messageW = getWidth(messageText)
    local cancelW = getWidth(cancelText)
    local confirmW = getWidth(confirmText)
    local contentW = math.max(titleW, messageW, cancelW + confirmW + 20)
    
    local targetW = math.floor(screenW * (isColorScreen() and 0.7 or 0.6))
    local minW = contentW + paddingH * 2
    local boxW = math.max(targetW, minW)
    if boxW > screenW - 10 then boxW = screenW - 10 end

    local targetH = math.floor(screenH * (isColorScreen() and 0.6 or 0.55))
    local minH = paddingV * 2 + lineH * 2 + buttonH + lineGap * 2 + 10
    local boxH = math.max(targetH, minH)
    if boxH > screenH - 8 then boxH = screenH - 8 end

    local x = math.floor((screenW - boxW) / 2)
    local y = math.floor((screenH - boxH) / 2)

    if isColorScreen() then
        -- Draw shadow
        safeFillRect(x + 3, y + 3, boxW, boxH, COLORS.SHADOW)
        -- Draw white background
        safeFillRect(x, y, boxW, boxH, COLORS.CARD_BG)
        -- Draw border
        lcd.drawRectangle(x, y, boxW, boxH, COLORS.PRIMARY)
        lcd.drawRectangle(x + 1, y + 1, boxW - 2, boxH - 2, COLORS.PRIMARY)
        
        -- Draw title with background
        local titleBgH = lineH + paddingV
        safeFillRect(x, y, boxW, titleBgH, COLORS.PRIMARY)
        local titleX = x + math.floor((boxW - titleW) / 2)
        lcd.drawText(titleX, y + math.floor(paddingV / 2), titleText, (FIXEDWIDTH or 0) + COLORS.CARD_BG)
        
        -- Draw message
        local messageX = x + math.floor((boxW - messageW) / 2)
        local messageY = y + titleBgH + lineGap
        lcd.drawText(messageX, messageY, messageText, (FIXEDWIDTH or 0) + COLORS.TEXT)
        
        -- Draw buttons
        local buttonY = y + boxH - buttonH - paddingV
        local buttonSpacing = 10
        local buttonW = math.floor((boxW - paddingH * 2 - buttonSpacing) / 2)
        
        -- Cancel button (selected = 0)
        local cancelX = x + paddingH
        if confirmModal.selected == 0 then
            safeFillRect(cancelX, buttonY, buttonW, buttonH, COLORS.PRIMARY)
            lcd.drawRectangle(cancelX, buttonY, buttonW, buttonH, COLORS.PRIMARY_DARK)
            local cancelTextX = cancelX + math.floor((buttonW - cancelW) / 2)
            local cancelTextY = buttonY + math.floor((buttonH - lineH) / 2)
            lcd.drawText(cancelTextX, cancelTextY, cancelText, (FIXEDWIDTH or 0) + COLORS.CARD_BG)
        else
            safeFillRect(cancelX, buttonY, buttonW, buttonH, COLORS.CARD_BG)
            lcd.drawRectangle(cancelX, buttonY, buttonW, buttonH, COLORS.BORDER)
            local cancelTextX = cancelX + math.floor((buttonW - cancelW) / 2)
            local cancelTextY = buttonY + math.floor((buttonH - lineH) / 2)
            lcd.drawText(cancelTextX, cancelTextY, cancelText, (FIXEDWIDTH or 0) + COLORS.TEXT)
        end
        
        -- Confirm button (selected = 1)
        local confirmX = cancelX + buttonW + buttonSpacing
        if confirmModal.selected == 1 then
            safeFillRect(confirmX, buttonY, buttonW, buttonH, COLORS.SUCCESS)
            lcd.drawRectangle(confirmX, buttonY, buttonW, buttonH, COLORS.PRIMARY_DARK)
            local confirmTextX = confirmX + math.floor((buttonW - confirmW) / 2)
            local confirmTextY = buttonY + math.floor((buttonH - lineH) / 2)
            lcd.drawText(confirmTextX, confirmTextY, confirmText, (FIXEDWIDTH or 0) + COLORS.CARD_BG)
        else
            safeFillRect(confirmX, buttonY, buttonW, buttonH, COLORS.CARD_BG)
            lcd.drawRectangle(confirmX, buttonY, buttonW, buttonH, COLORS.BORDER)
            local confirmTextX = confirmX + math.floor((buttonW - confirmW) / 2)
            local confirmTextY = buttonY + math.floor((buttonH - lineH) / 2)
            lcd.drawText(confirmTextX, confirmTextY, confirmText, (FIXEDWIDTH or 0) + COLORS.TEXT)
        end
    else
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
end

local submenuLoading = false
local submenuLoadTime = 0
local submenuLoadTimeout = 3 -- seconds
local submenuLastRequestDev = nil

--[[ ========== UI Configuration ========== ]]
UI_CONFIG = {
    -- Colors and styles
    HEADER_HEIGHT = 20,
    HEADER_BG = SOLID,
    HEADER_TEXT_FLAG = FIXEDWIDTH or 0,  -- Use fixed-width font for header
    
    -- Spacing
    MARGIN_LEFT = isColorScreen() and 8 or 4,
    MARGIN_TOP = 24,
    ROW_HEIGHT = 34,  -- Default row height (dynamically adjusted on small screens)
    TEXT_FLAG = FIXEDWIDTH or 0,  -- Use fixed-width font for all text
    TEXT_VERTICAL_OFFSET = 1,  -- Fine-tune vertical centering for FIXEDWIDTH font
    CARD_PADDING = isColorScreen() and 6 or 2,
    CARD_RADIUS = isColorScreen() and 4 or 0,
    
    -- Separator lines
    SEPARATOR_Y = 21,
    
    -- Icons
    ICON_ONLINE = "\x7E",    -- ~ symbol represents online
    ICON_OFFLINE = "\x78",   -- x symbol represents offline
    ICON_ARROW = "\x3E",     -- > symbol
    
    -- Log area (disabled)
    LOG_ENABLED = false,
    LOG_START_Y = nil,
    LOG_HEIGHT = 10,
    LOG_MAX_LINES = 6,
}

-- Adaptive: adjust layout based on screen size
local function applyResponsiveLayout()
    local sw = LCD_W or 212
    local sh = LCD_H or 64

    -- Height ratio: title and each row about 10% of screen height
    local unit = math.max(10, math.floor(sh * 0.10))
    UI_CONFIG.HEADER_HEIGHT = unit
    UI_CONFIG.ROW_HEIGHT = unit
    UI_CONFIG.MARGIN_TOP = UI_CONFIG.HEADER_HEIGHT + math.max(2, math.floor(unit * 0.25))

    -- Font size varies with row height
    local SMALL = (SMLSIZE or 0)
    local MED = (MIDSIZE or 0)
    local textFlag
    if UI_CONFIG.ROW_HEIGHT < 14 then
        textFlag = SMALL
    elseif UI_CONFIG.ROW_HEIGHT < 22 then
        textFlag = 0
    else
        textFlag = MED
    end
    UI_CONFIG.TEXT_FLAG = textFlag
    UI_CONFIG.HEADER_TEXT_FLAG = textFlag
    
    -- Adjust padding for different screen sizes
    if isColorScreen() then
        UI_CONFIG.MARGIN_LEFT = sw > 400 and 12 or 8
        UI_CONFIG.CARD_PADDING = sw > 400 and 8 or 6
    end
end

--[[ ========== Enhanced UI Drawing Functions ========== ]]

-- Draw enhanced title bar with gradient (color screens) or pattern (B&W)
local function drawHeader(title)
    -- Use actual LCD dimensions
    local w = LCD_W or 212
    local h = LCD_H or 64

    local headerFlag = (UI_CONFIG and UI_CONFIG.HEADER_TEXT_FLAG) or 0
    local SMALL = (SMLSIZE or 0)
    local MED = (MIDSIZE or 0)
    local textHeight = (headerFlag == SMALL) and 8 or ((headerFlag == MED) and 16 or 12)
    local headerHeight = UI_CONFIG and UI_CONFIG.HEADER_HEIGHT or (textHeight + 4)

    -- Calculate accurate text width with FIXEDWIDTH flag
    local fontFlags = (headerFlag or 0) + (FIXEDWIDTH or 0)
    local textWidth
    if lcd.getTextWidth then
        textWidth = lcd.getTextWidth(fontFlags, title)
    else
        -- Fallback: estimate based on character count (FIXEDWIDTH typically 6px per char)
        local charWidth = 6  -- Fixed width for monospace font
        textWidth = #title * charWidth
    end

    if isColorScreen() then
        -- Draw gradient background for color screens
        for i = 0, headerHeight - 1 do
            local alpha = i / headerHeight
            local color = lcd.RGB(
                math.floor(31 + (41 - 31) * alpha),
                math.floor(97 + (128 - 97) * alpha),
                math.floor(141 + (185 - 141) * alpha)
            )
            lcd.drawLine(0, i, w, i, SOLID, color)
        end
        
        -- Draw title text centered both horizontally and vertically
        local textX = 20--math.floor((w - textWidth) / 2) - 15
        local textY = math.floor((headerHeight - textHeight) / 2) + (UI_CONFIG.TEXT_VERTICAL_OFFSET or 0) - 5
        lcd.drawText(textX, textY, title, fontFlags + COLORS.CARD_BG)
    else
        -- Black and white screen - simple filled rectangle
        safeFillRect(0, 0, w, headerHeight, SOLID)
        local textX = 10--math.floor((w - textWidth) / 2)
        local textY = math.floor((headerHeight - textHeight) / 2) + (UI_CONFIG.TEXT_VERTICAL_OFFSET or 0)
        lcd.drawText(textX, textY, title, fontFlags + INVERS)
    end

    return headerHeight
end

-- Draw enhanced sensor icon with better visual feedback
local function drawSensorIcon(x, y, online)
    local rowH = (UI_CONFIG and UI_CONFIG.ROW_HEIGHT) or 12
    local size = math.min(rowH - 4, isColorScreen() and 24 or 12)
    
    if isColorScreen() then
        -- Draw circular icon for color screens
        local centerX = x + size / 2
        local centerY = y + size / 2
        local radius = size / 2
        
        if online then
            -- Green circle with pulse effect
            lcd.drawFilledCircle(centerX, centerY, radius, COLORS.SUCCESS)
            lcd.drawCircle(centerX, centerY, radius + 1, COLORS.SUCCESS)
        else
            -- Gray circle
            lcd.drawFilledCircle(centerX, centerY, radius, COLORS.OFFLINE)
        end
        
        -- Draw inner dot
        lcd.drawFilledCircle(centerX, centerY, radius / 3, COLORS.CARD_BG)
    else
        -- Simple signal bars for B&W screens
        local barHeight = {3, 5, 7, 9}
        local barWidth = 2
        local spacing = 1
        
        for i = 1, 4 do
            local barX = x + (i - 1) * (barWidth + spacing)
            local barY = y + size - barHeight[i]
            if online or i <= 2 then
                safeFillRect(barX, barY, barWidth, barHeight[i], SOLID)
            else
                lcd.drawRectangle(barX, barY, barWidth, barHeight[i], SOLID)
            end
        end
    end
    
    return size + 4
end

-- Draw separator line with style
local function drawSeparator(y)
    local w = LCD_W or 212
    if isColorScreen() then
        lcd.drawLine(UI_CONFIG.MARGIN_LEFT, y, w - UI_CONFIG.MARGIN_LEFT, y, SOLID, COLORS.BORDER)
    else
        lcd.drawLine(UI_CONFIG.MARGIN_LEFT, y, w - UI_CONFIG.MARGIN_LEFT, y, DOTTED, FORCE)
    end
end

-- Draw enhanced loading animation
local function drawLoadingBar(x, y, width, progress)
    local height = isColorScreen() and 6 or 4
    
    if isColorScreen() then
        -- Draw background
        safeFillRect(x, y, width, height, COLORS.BACKGROUND)
        -- Draw progress
        local fillWidth = math.floor(width * progress)
        safeFillRect(x, y, fillWidth, height, COLORS.PRIMARY)
        -- Draw border
        lcd.drawRectangle(x, y, width, height, COLORS.BORDER)
    else
        -- Simple progress bar for B&W
        lcd.drawRectangle(x, y, width, height, SOLID)
        local fillWidth = math.floor(width * progress)
        safeFillRect(x + 1, y + 1, fillWidth - 2, height - 2, SOLID)
    end
end

-- Enhanced hourglass animation
local function drawHourglass(x, y)
    local size = isColorScreen() and 12 or 8
    local frame = math.floor((getTime() / 10) % 8)
    
    if isColorScreen() then
        -- Draw hourglass shape
        lcd.drawLine(x, y, x + size, y, SOLID, COLORS.PRIMARY)
        lcd.drawLine(x, y, x + size/2, y + size, SOLID, COLORS.PRIMARY)
        lcd.drawLine(x + size, y, x + size/2, y + size, SOLID, COLORS.PRIMARY)
        lcd.drawLine(x, y + size*2, x + size, y + size*2, SOLID, COLORS.PRIMARY)
        lcd.drawLine(x, y + size*2, x + size/2, y + size, SOLID, COLORS.PRIMARY)
        lcd.drawLine(x + size, y + size*2, x + size/2, y + size, SOLID, COLORS.PRIMARY)
        
        -- Animated sand
        local sandY = y + size/2 + (frame % 4) * 2
        lcd.drawFilledCircle(x + size/2, sandY, 2, COLORS.WARNING)
    else
        -- Simple animation for B&W
        lcd.drawLine(x, y, x+size, y, SOLID, 0)
        lcd.drawLine(x, y, x+size/2, y+size, SOLID, 0)
        lcd.drawLine(x+size, y, x+size/2, y+size, SOLID, 0)
        lcd.drawLine(x, y+size*2, x+size, y+size*2, SOLID, 0)
        lcd.drawLine(x, y+size*2, x+size/2, y+size, SOLID, 0)
        lcd.drawLine(x+size, y+size*2, x+size/2, y+size, SOLID, 0)
    end
end

-- Draw enhanced menu item with card-style layout
local function drawMenuItem(y, text, isSelected, icon, online)
    local x = UI_CONFIG.MARGIN_LEFT
    local w = LCD_W - UI_CONFIG.MARGIN_LEFT * 2
    local h = UI_CONFIG.ROW_HEIGHT - 2
    
    if isColorScreen() then
        -- Draw card background
        if isSelected then
            safeFillRect(x, y, w, h, COLORS.PRIMARY)
            lcd.drawRectangle(x, y, w, h, COLORS.PRIMARY_DARK)
        else
            safeFillRect(x, y, w, h, COLORS.CARD_BG)
            lcd.drawRectangle(x, y, w, h, COLORS.BORDER)
        end
        
        -- Draw icon
        local iconX = x + UI_CONFIG.CARD_PADDING
        local iconY = y + math.floor((h - 12) / 2)
        local iconWidth = drawSensorIcon(iconX, iconY, online)
        
        -- Draw text
        local textX = iconX + iconWidth + 4
        local textY = y + math.floor((h - 12) / 2)
        local textColor = isSelected and COLORS.CARD_BG or COLORS.TEXT
        lcd.drawText(textX, textY, text, textColor)
    else
        -- Simple design for B&W
        local attr = (isSelected and INVERS or 0) + (UI_CONFIG and UI_CONFIG.TEXT_FLAG or 0)
        
        if icon then
            lcd.drawText(x, y, icon, attr)
            x = x + 10
        end
        
        lcd.drawText(x, y, text, attr)
    end
end

-- Draw right-aligned text
local function drawRightText(y, text, attr)
    local w = LCD_W
    local flags = (attr or 0) + (UI_CONFIG and UI_CONFIG.TEXT_FLAG or 0)
    local textWidth = lcd.getTextWidth and lcd.getTextWidth(flags, text) or (#text * 6)
    lcd.drawText(w - textWidth - UI_CONFIG.MARGIN_LEFT, y, text, flags)
end

-- Draw enhanced badge/label
local function drawBadge(x, y, text, filled, fixedWidth)
    local padding = isColorScreen() and 6 or 4
    local flags = (UI_CONFIG and UI_CONFIG.TEXT_FLAG or 0)
    local textWidth = lcd.getTextWidth and lcd.getTextWidth(flags, text) or (#text * 6)
    local boxWidth = fixedWidth or (textWidth + padding * 2)
    local boxHeight = isColorScreen() and 16 or 12
    
    local textX = x + math.floor((boxWidth - textWidth) / 2)
    local textY = y + math.floor((boxHeight - 12) / 2)
    
    if isColorScreen() then
        if filled then
            safeFillRect(x, y, boxWidth, boxHeight, COLORS.PRIMARY)
            lcd.drawText(textX, textY, text, COLORS.CARD_BG)
        else
            safeFillRect(x, y, boxWidth, boxHeight, COLORS.BACKGROUND)
            lcd.drawRectangle(x, y, boxWidth, boxHeight, COLORS.BORDER)
            lcd.drawText(textX, textY, text, COLORS.TEXT)
        end
    else
        if filled then
            safeFillRect(x, y, boxWidth, boxHeight, SOLID)
            lcd.drawText(textX, textY, text, flags + INVERS)
        else
            lcd.drawRectangle(x, y, boxWidth, boxHeight, SOLID)
            lcd.drawText(textX, textY, text, flags)
        end
    end
    
    return boxWidth
end

--[[ ========== Window size calculation ========== ]]
local w = LCD_W
local h = LCD_H
local maxRows = math.floor((h - UI_CONFIG.MARGIN_TOP) / UI_CONFIG.ROW_HEIGHT)

-- Estimate text height for current font
local function getApproxTextHeight(flag)
    local SMALL = (SMLSIZE or 0)
    local MED = (MIDSIZE or 0)
    if flag == SMALL then return 8 end
    if flag == MED then return 16 end
    return 12
end

-- Estimate text width
local function getApproxTextWidth(flag, text)
    if lcd and lcd.getTextWidth then
        return lcd.getTextWidth(flag, text)
    end
    local SMALL = (SMLSIZE or 0)
    local MED = (MIDSIZE or 0)
    local unit
    if flag == SMALL then
        unit = 5
    elseif flag == MED then
        unit = 9
    else
        unit = 6
    end
    return (#text) * unit
end

-- Choose appropriate font flag based on available width
local function chooseFittingFlagForWidth(text, maxWidth)
    local SMALL = (SMLSIZE or 0)
    local base = (UI_CONFIG and UI_CONFIG.TEXT_FLAG or 0)
    local candidates = { base, 0, SMALL }
    for i = 1, #candidates do
        local f = candidates[i]
        local tw = getApproxTextWidth(f, text)
        if tw <= maxWidth then return f end
    end
    return SMALL
end

-- Lower font flag by one level
local function demoteFlag(flag)
    local SMALL = (SMLSIZE or 0)
    local MED = (MIDSIZE or 0)
    if flag == MED then return 0 end
    if flag == 0 then return SMALL end
    return SMALL
end

--[[ Logging system ]]
local function getSensorTypeName(devType)
    return SENSOR_TYPE_NAMES[devType] or string.format("UNKNOWN(0x%02X)", devType)
end

local function logScreen(msg)
    if not UI_CONFIG or not UI_CONFIG.LOG_ENABLED then return end
    if #logLines >= UI_CONFIG.LOG_MAX_LINES then
        table.remove(logLines, 1)
    end
    table.insert(logLines, msg)
end

local function logf(fmt, ...)
    if not UI_CONFIG or not UI_CONFIG.LOG_ENABLED then return end
    logScreen(string.format(fmt, ...))
end

local function logFrame(frame)
    if not UI_CONFIG or not UI_CONFIG.LOG_ENABLED then return end
    if not frame or #frame == 0 then
        logScreen("Frame: None")
        return
    end
    local str = "Frame: "
    for i = 1, #frame do
        if i > 1 then str = str .. " " end
        str = str .. string.format("%02X", frame[i])
    end
    logScreen(str)
end

local function drawLog()
    if not UI_CONFIG.LOG_ENABLED then
        return
    end
    
    drawSeparator(UI_CONFIG.LOG_START_Y - 3)
    lcd.drawText(UI_CONFIG.MARGIN_LEFT, UI_CONFIG.LOG_START_Y - 2, "Log:", (FIXEDWIDTH or 0) + SMLSIZE)
    
    for i = 1, #logLines do
        local y = UI_CONFIG.LOG_START_Y + (i-1) * UI_CONFIG.LOG_HEIGHT
        lcd.drawText(UI_CONFIG.MARGIN_LEFT, y, logLines[i], (FIXEDWIDTH or 0) + SMLSIZE)
    end
end

local function checkReceivedData()
    if not crossfireTelemetryPop then
        logScreen("No crossfireTelemetryPop")
        return
    end
    
    local cmd ,frame = crossfireTelemetryPop()
    -- Only process 7A/7B/7C, 88 is idle frame and ignored directly
    if cmd ~= CRSF_FRAMETYPE_MSP_RESP and cmd ~= CRSF_FRAMETYPE_MSP_REQ and cmd ~= CRSF_FRAMETYPE_MSP_WRITE then
        return
    end
    if cmd ==nil then
        return    -- Directly gg
    end
    if frame and #frame > 0 then
        -- CMD_DATA response frame parsing
        if submenuLoading and submenuLastRequestDev and frame[3] == submenuLastRequestDev.type and frame[4] == submenuLastRequestDev.id and frame[5] == CMD.CMD_DATA.num then
            local devId = frame[4]
            submenuStates[devId] = submenuStates[devId] or {}
            local i = 7
            while i + 1 <= #frame do
                local cmdNum = frame[i]
                -- Reverse lookup function name
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
                            -- Compatible with old firmware returning only 1 byte
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
                            -- Compatible with old firmware returning only 1 byte
                            submenuStates[devId][funcName] = lo or 0
                            i = i + 2
                        end
                    else
                        local dataVal = frame[i + 1]
                        submenuStates[devId][funcName] = dataVal
                        i = i + 2
                    end
                else
                    -- Unknown command number, try to skip a pair (cmdNum, data)
                    i = i + 2
                end
            end
            submenuLoading = false
            -- Assign options immediately after data arrival
            if submenuDevice and submenuDevice.id == devId then
                submenuOptions = SENSOR_CAPABILITY[submenuDevice.type] or {}
            end
        end
        
        -- General ACK matching and processing (non CMD_DATA batch data)
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
                            -- Update status based on command type (based on reply packet)
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
                                -- Compose popup text
                                local title = "Operation Successful"
                                local devStr = string.format("Device: %s[%d]", getSensorTypeName(devType), devId)
                                local funcStr = string.format("Function: %s", formatFunctionName(funcName))
                                local resultStr = nil
                                if c.type == 3 then
                                    resultStr = string.format("Result: %s", (dataVal == 1) and "ON" or ((dataVal == 2) and "OFF" or tostring(dataVal or " ")))
                                elseif c.type == 2 then
                                    resultStr = string.format("Result: %s", tostring(dataVal or " "))
                                elseif c.type == 4 then
                                    local modeName = ""
                                    local def = CMD[funcName]
                                    if def and def.options then
                                        for _, opt in ipairs(def.options) do
                                            if opt.value == dataVal then modeName = opt.name break end
                                        end
                                        -- If no match found, use first option as default or show value
                                        if modeName == "" then
                                            if #def.options > 0 then
                                                modeName = def.options[1].name
                                            else
                                                modeName = string.format("Mode:%d", dataVal or 0)
                                            end
                                        end
                                    else
                                        modeName = string.format("Mode:%d", dataVal or 0)
                                    end
                                    resultStr = string.format("Result: %s", modeName)
                                elseif c.type == 6 then
                                    -- Firmware update success
                                    resultStr = "Result: Update command sent"
                                else
                                    resultStr = "Result: Success"
                                end
                                enqueueModal(title, { devStr, funcStr, resultStr })
                                -- Clear pending confirmations
                                pendingOps[key] = nil
                                -- If no popup is displayed, show immediately
                                if not successModal.visible then
                                    showNextModal()
                                end
                            end
                        else
                            -- Timeout, abandon this pending confirmation
                            pendingOps[key] = nil
                        end
                    end
                end
            end
        end
        
        -- Device registration/heartbeat handling
        -- Added: handle Ping reply, parse device name
        if frame[5] == CMD.PING.num and #frame >= 7 then
            local devType = frame[3]
            local devId = frame[4]
            -- Device name starts from the 7th byte
            local chars = {}
            for i = 7, #frame do
                local b = frame[i]
                if b == 0 then break end
                chars[#chars+1] = string.char(b)
            end
            local devName = table.concat(chars)
            if not sensors[devId] then
                sensors[devId] = {type = devType, id = devId, lastSeen = getTime()/100, name = devName, missedHeartbeats = 0}
                logf("login Name=%s ID=%d", devName, devId)
            else
                sensors[devId].type = devType
                -- Fill in if the name field is empty
                if not sensors[devId].name or sensors[devId].name == "" then
                    sensors[devId].name = devName
                    logf("Name=%s ID=%d", devName, devId)
                end
                sensors[devId].lastSeen = getTime()/100
                sensors[devId].missedHeartbeats = 0
                sensors[devId].offline = nil
                logf("update Name=%s ID=%d", sensors[devId].name, devId)
            end
        else
            -- Compatible with original registration/heartbeat/with device name handling
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
                    logf("login ID=%d Type=%s Name=%s", devId, getSensorTypeName(devType), devName)
                else
                    if sensors[devId].type ~= devType then
                        sensors[devId].type = devType
                        logf("update ID=%d Type=%s", devId, getSensorTypeName(devType))
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
        --logScreen("Frame" .. tostring(#frame))      -- Display result
        if cmd == CRSF_FRAMETYPE_MSP_RESP then
            --logScreen("Frame 0x7B len= " .. tostring(#frame) .. " data= " .. tostring(frame))
            logFrame(frame)
            receivedCount = receivedCount + 1
            -- Avoid saving the entire frame to reduce memory usage
            lastReceivedData = nil
            receivedTime = getTime() / 100

        elseif cmd == CRSF_FRAMETYPE_MSP_REQ then
            --logScreen("Frame 0x7A len= " .. tostring(#frame) .. " data= " .. tostring(frame))
            logFrame(frame)
            receivedCount = receivedCount + 1
            lastReceivedData = nil
            receivedTime = getTime() / 100

        elseif cmd == CRSF_FRAMETYPE_MSP_WRITE then
            --logScreen("Frame 0x7C len= " .. tostring(#frame) .. " data= " .. tostring(frame))
            logFrame(frame)
            receivedCount = receivedCount + 1
            lastReceivedData = nil
            receivedTime = getTime() / 100

        elseif cmd == CRSF_FRAME_CUSTOM_TELEM then
            --logScreen("Frame 0x88 len= " .. tostring(#frame) .. " data= " .. tostring(frame))
            --logFrame(frame)
            -- rawFrameCount = rawFrameCount + 1
            -- receivedCount = receivedCount + 1
            -- lastReceivedData = frame  -- Store the entire raw frame
            -- receivedTime = getTime() / 100
        end
    end
end

--[[ Data Sending System ]]
local function sendCmdData(devType, id, cmd, data)
    if not crossfireTelemetryPush then
        logScreen("crossfireTelemetryPush not found")
        return false
    end

    local payload = { CRSF_ADDRESS_BETAFLIGHT, CRSF_ADDRESS_RADIO_TRANSMITTER }
    payload[1 + 2] = devType
    payload[2 + 2] = id
    payload[3 + 2] = CMD[cmd].num

    -- Concatenate data: type=2 supports 16-bit (default little-endian); table passthrough
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

    --logScreen("sendTestData")
    crossfireTelemetryPush(CRSF_FRAMETYPE_MSP_WRITE, payload)
    -- Register pending confirmations (filter out those that don't require feedback popups)
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
    -- Clear data to trigger complete rebuild (preserve focus to be restored)
    sensors = {}
    submenuStates = {}
    logLines = {}
    submenuActive = false
    submenuIndex = 1
    submenuOptions = {}
    submenuDevice = nil
    inputActive = false
    inputValue = 0
    submenuLoading = false
    submenuLastRequestDev = nil
end

local function heartBeat()
    sendCmdData(0xFF, 0xFF, "HEART_BEAT", 0xFF)       -- All devices receiving this data must send an ID back, then the terminal handles all IDs
end


-- Event handler function
local function handleEvent(event)
    -- When confirmation dialog is displayed, handle its interaction
    if confirmModal.visible then
        if event == EVT_ROT_LEFT or event == 59 or event == EVT_PAGE_PREV or event == 68 then
            -- Switch to Cancel (0)
            confirmModal.selected = 0
            return nil
        elseif event == EVT_ROT_RIGHT or event == 60 or event == EVT_PAGE_NEXT or event == 67 then
            -- Switch to Confirm (1)
            confirmModal.selected = 1
            return nil
        elseif event == EVT_ENTER_BREAK or event == 32 then
            if confirmModal.selected == 0 then
                -- Cancel selected, close dialog
                confirmModal.visible = false
                confirmModal.selected = 0
                confirmModal.deviceType = nil
                confirmModal.deviceId = nil
                confirmModal.funcName = nil
                return nil
            else
                -- Confirm selected, send update command
                if confirmModal.deviceType and confirmModal.deviceId and confirmModal.funcName then
                    sendCmdData(confirmModal.deviceType, confirmModal.deviceId, confirmModal.funcName, 0xA5)
                    -- Success message will be shown when ACK is received (handled in ACK processing)
                end
                -- Close confirmation dialog
                confirmModal.visible = false
                confirmModal.selected = 0
                confirmModal.deviceType = nil
                confirmModal.deviceId = nil
                confirmModal.funcName = nil
                return nil
            end
        elseif event == EVT_EXIT_BREAK or event == 34 then
            -- Exit = Cancel
            confirmModal.visible = false
            confirmModal.selected = 0
            confirmModal.deviceType = nil
            confirmModal.deviceId = nil
            confirmModal.funcName = nil
            return nil
        else
            return nil
        end
    end
    
    -- When popup is displayed, only process confirm and exit, ignore other inputs
    if successModal.visible then
        if event == EVT_ENTER_BREAK or event == 32 then
            closeModal()
            return nil
        elseif event == EVT_EXIT_BREAK or event == 34 then
            closeModal()
            return nil
        else
            return nil
        end
    end
    if event == EVT_ENTER_BREAK or event == 32 then
        return "enter"
    elseif event == EVT_EXIT_BREAK or event == 34 then
        return "exit"
    elseif event == EVT_PAGE_BREAK or event == 67 then
        return "page_next"
    elseif event == EVT_PAGE_LONG or event == 68 then
        return "page_prev"
    elseif event == EVT_ROT_LEFT or event == 59 then
        return "rot_left"
    elseif event == EVT_ROT_RIGHT or event == 60 then
        return "rot_right"
    end
    return nil
end  

-- Remove unused: stats
local lastHeartBeatTime = 0
local lastPingTime = 0
local pinged = false
local heartbeatEnabled = false
local heartbeatInterval = 2 -- seconds
local missedThreshold = 3
local lastOfflineCheckTime = 0

-- Auto search related variables
local autoSearching = true  -- Auto search on startup
local lastAutoSearchTime = 0
local autoSearchInterval = 0.5  -- 500ms

-- Main event function
local function run(event)
    lcd.clear()
    -- LCD compatibility adaptation (ensure fallback if API is missing)
    ensureLCDCompat()
    -- Apply adaptive layout every frame and recalculate visible rows (at least 2 rows to ensure device list visibility)
    applyResponsiveLayout()
    maxRows = math.max(2, math.floor(((LCD_H or 64) - UI_CONFIG.MARGIN_TOP) / UI_CONFIG.ROW_HEIGHT))
    
    -- ========== Submenu Interface ==========
    if submenuActive then
        checkReceivedData()
        drawHeader("RadioMaster  Sensor")
        -- Draw title bar
        local headerHeight = 0 --
        
        -- Draw device information with enhanced styling
        local devInfoY = UI_CONFIG.HEADER_HEIGHT + 2
        local devInfo = string.format("ID:%d  TYPE:%s", 
            submenuDevice and submenuDevice.id or 0, 
            getSensorTypeName(submenuDevice and submenuDevice.type or 0))
        
        if isColorScreen() then
            -- Draw device info text only (no card background)
            lcd.drawText(UI_CONFIG.MARGIN_LEFT, devInfoY, devInfo, (FIXEDWIDTH or 0) + COLORS.TEXT)
        else
            lcd.drawText(UI_CONFIG.MARGIN_LEFT, devInfoY, devInfo, (FIXEDWIDTH or 0) + (UI_CONFIG and UI_CONFIG.TEXT_FLAG or 0))
        end
        
        local action = handleEvent(event)
        local w = LCD_W or 212
        local rightX = w - math.floor(w / 6)  -- Position at 1/6 from right edge (for text)
        local leftX = UI_CONFIG.MARGIN_LEFT + 2
        local baseRowHeight = UI_CONFIG.ROW_HEIGHT
        
        -- Calculate device info text height and spacing
        local devInfoTextH = 12  -- Text height
        local devInfoSpacing = isColorScreen() and 8 or 6  -- Spacing below device info text
        
        -- Calculate Back button position (below device info text with spacing + 4px offset)
        local backY = devInfoY + devInfoTextH + devInfoSpacing + 4  -- Add 4px offset to move down
        
        -- Calculate menu start position (below Back button with proper spacing)
        local backCardHeight = math.max(baseRowHeight - 2, 16)
        local menuY0 = backY + backCardHeight + 4  -- Add 4px spacing between Back and menu items
        local availableH = (LCD_H or 64) - menuY0
        if availableH < baseRowHeight then availableH = baseRowHeight end
        local baseCount = math.max(1, math.floor(availableH / baseRowHeight))
        local remainder = availableH - baseCount * baseRowHeight
        local desiredCount = baseCount
        if remainder >= math.floor(baseRowHeight * 0.35) then
            desiredCount = baseCount + 1
        end
        desiredCount = math.max(1, desiredCount)
        local listRowHeight = math.max(12, math.floor(availableH / desiredCount))
        local maxVisibleOptions = desiredCount
        local devId = submenuDevice and submenuDevice.id or 0
        
        -- Back option with enhanced styling
        if isColorScreen() then
            local cardW = LCD_W - UI_CONFIG.MARGIN_LEFT * 2
            local isBackSelected = (submenuIndex == 0)
            
            if isBackSelected then
                safeFillRect(UI_CONFIG.MARGIN_LEFT, backY, cardW, backCardHeight, COLORS.PRIMARY)
                lcd.drawRectangle(UI_CONFIG.MARGIN_LEFT, backY, cardW, backCardHeight, COLORS.PRIMARY_DARK)
                lcd.drawText(UI_CONFIG.MARGIN_LEFT + UI_CONFIG.CARD_PADDING, backY + math.floor((backCardHeight - 12) / 2) + (UI_CONFIG.TEXT_VERTICAL_OFFSET or 0), "< Back", (FIXEDWIDTH or 0) + COLORS.CARD_BG)
            else
                safeFillRect(UI_CONFIG.MARGIN_LEFT, backY, cardW, backCardHeight, COLORS.CARD_BG)
                lcd.drawRectangle(UI_CONFIG.MARGIN_LEFT, backY, cardW, backCardHeight, COLORS.BORDER)
                lcd.drawText(UI_CONFIG.MARGIN_LEFT + UI_CONFIG.CARD_PADDING, backY + math.floor((backCardHeight - 12) / 2) + (UI_CONFIG.TEXT_VERTICAL_OFFSET or 0), "< Back", (FIXEDWIDTH or 0) + COLORS.TEXT)
            end
        else
            drawMenuItem(backY, "< Back", submenuIndex == 0, nil)
        end
        
        -- Check if data has arrived, show loading animation
        if submenuLoading then
            local centerX = math.floor(w / 2) - 5
            local centerY = math.floor(h / 2) - 10
            drawHourglass(centerX, centerY)
            lcd.drawText(centerX + 15, centerY + 5, "Loading...", (FIXEDWIDTH or 0) + (UI_CONFIG and UI_CONFIG.TEXT_FLAG or 0))
            
            local elapsed = getTime()/100 - submenuLoadTime
            -- Retry after timeout, up to 3 times
            if elapsed > submenuLoadTimeout then
                submenuLoading = false
                -- If still no data, try requesting again
                if not submenuStates[devId] and submenuLastRequestDev then
                    local retryCount = submenuLastRequestDev.retryCount or 0
                    if retryCount < 3 then
                        submenuLastRequestDev.retryCount = retryCount + 1
                        sendCmdData(submenuLastRequestDev.type, submenuLastRequestDev.id, "CMD_DATA", 0xFF)
                        submenuLoading = true
                        submenuLoadTime = getTime() / 100
                        logf("Retry %d/3", retryCount + 1)
                    else
                        logScreen("Load failed after 3 retries")
                    end
                end
            end
        end
        
        if not submenuStates[devId] then
            if not submenuLoading then
                local screenW = LCD_W or w or 212
                local maxW = screenW - 2 * (UI_CONFIG and UI_CONFIG.MARGIN_LEFT or 4)
                local SMALL = (SMLSIZE or 0)

                local s1 = "NO DATA"
                local f1 = SMALL
                local w1 = getApproxTextWidth(f1, s1)
                if w1 > maxW then f1 = SMALL end -- Force minimum font size
                w1 = getApproxTextWidth(f1, s1)
                local x1 = math.floor((screenW - w1) / 2)
                lcd.drawText(x1, menuY0 + 20, s1, f1)

                local s2 = "'ENTER' to retry"
                local f2 = SMALL
                local w2 = getApproxTextWidth(f2, s2)
                if w2 > maxW then f2 = SMALL end -- Force minimum font size
                w2 = getApproxTextWidth(f2, s2)
                local x2 = math.floor((screenW - w2) / 2)
                lcd.drawText(x2, menuY0 + 35, s2, f2)
            end
            -- Back option handling
            if action == "exit" or (action == "enter" and submenuIndex == 0) then
                submenuActive = false
                submenuIndex = 1
                -- Trigger a refresh immediately when returning to main list
                triggerPingOnReturn = true
                -- Record the device to focus after returning
                pendingFocusDeviceId = devId
            elseif action == "enter" then
                -- Manually retry loading data
                if submenuDevice then
                    submenuDevice.retryCount = 0  -- Reset retry count
                    sendCmdData(submenuDevice.type, submenuDevice.id, "CMD_DATA", 0xFF)
                    submenuLoading = true
                    submenuLoadTime = getTime() / 100
                    submenuLastRequestDev = submenuDevice
                    logf("Manual retry")
                end
            elseif action == "rot_left" or action == "page_prev" then
                submenuIndex = 0
            elseif action == "rot_right" or action == "page_next" then
                submenuIndex = 0
            end
            drawLog()
            return 0
        end
        
        -- Assign options after data arrives
        if #submenuOptions == 0 then
            submenuOptions = SENSOR_CAPABILITY[submenuDevice.type] or {}
            if submenuIndex == 0 then submenuIndex = 1 end
        end
        local totalRows = #submenuOptions + 1  -- +1 for Back option
        -- Ensure selected item is within visible window (Back=0 does not participate in scrolling)
        if submenuIndex >= 1 then
            if submenuIndex < submenuScroll + 1 then
                submenuScroll = submenuIndex - 1
            end
            if submenuIndex > submenuScroll + maxVisibleOptions then
                submenuScroll = submenuIndex - maxVisibleOptions
            end
            if submenuScroll < 0 then submenuScroll = 0 end
            local maxStart = math.max(0, #submenuOptions - maxVisibleOptions)
            if submenuScroll > maxStart then submenuScroll = maxStart end
        end
        
        -- Display function options (with scroll window)
        local startIdx = submenuScroll + 1
        local endIdx = math.min(#submenuOptions, submenuScroll + maxVisibleOptions)
        for i = startIdx, endIdx do
            local visualRow = i - submenuScroll
            local y = menuY0 + (visualRow-1) * listRowHeight
            local isSelected = (submenuIndex == i and not inputActive)
            local opt = submenuOptions[i]
            
            local cmd = CMD[opt]
            local text, attr
            
            if isColorScreen() then
                -- Draw function option card
                local cardW = LCD_W - UI_CONFIG.MARGIN_LEFT * 2
                local cardH = listRowHeight - 2
                
                if isSelected then
                    safeFillRect(UI_CONFIG.MARGIN_LEFT, y, cardW, cardH, COLORS.PRIMARY)
                    lcd.drawRectangle(UI_CONFIG.MARGIN_LEFT, y, cardW, cardH, COLORS.PRIMARY_DARK)
                else
                    safeFillRect(UI_CONFIG.MARGIN_LEFT, y, cardW, cardH, COLORS.CARD_BG)
                    lcd.drawRectangle(UI_CONFIG.MARGIN_LEFT, y, cardW, cardH, COLORS.BORDER)
                end
                
                local textColor = isSelected and COLORS.CARD_BG or COLORS.TEXT
                local textY = y + math.floor((cardH - 12) / 2) + (UI_CONFIG.TEXT_VERTICAL_OFFSET or 0)
                lcd.drawText(UI_CONFIG.MARGIN_LEFT + UI_CONFIG.CARD_PADDING, textY, formatFunctionName(opt), (FIXEDWIDTH or 0) + textColor)
                
                -- Draw value/status on the right, positioned at 1/6 from right edge
                -- Note: Card position remains unchanged, only operations are moved
                if cmd then
                    if cmd.type == 2 then
                        submenuStates[devId] = submenuStates[devId] or {}
                        if inputActive and i == submenuIndex then
                            text = string.format("%d", inputValue)
                        else
                            local val = submenuStates[devId][opt] or 0
                            text = string.format("%d", val)
                        end
                        local textW = lcd.getTextWidth and lcd.getTextWidth((FIXEDWIDTH or 0), text) or (#text * 6)
                        -- Position number OUTSIDE the card, at 1/6 from right edge
                        local valueX = LCD_W - math.floor(LCD_W / 6) - textW  -- Position at 1/6 from right edge, outside card
                        lcd.drawText(valueX, textY, text, (FIXEDWIDTH or 0) + textColor)
                    elseif cmd.type == 3 then
                        submenuStates[devId] = submenuStates[devId] or {}
                        local state = submenuStates[devId][opt] or 0
                        text = state == 1 and "ON" or "OFF"
                        
                        -- Draw ON/OFF text at 1/6 from right edge (no box)
                        local textW = lcd.getTextWidth and lcd.getTextWidth((FIXEDWIDTH or 0), text) or (#text * 6)
                        local textX = LCD_W - math.floor(LCD_W / 6) - textW  -- Text at 1/6 from right edge
                        local textY = y + math.floor((cardH - 12) / 2)
                        
                        if state == 1 then
                            lcd.drawText(textX, textY, text, (FIXEDWIDTH or 0) + COLORS.SUCCESS)
                        else
                            lcd.drawText(textX, textY, text, (FIXEDWIDTH or 0) + COLORS.TEXT_LIGHT)
                        end
                    elseif cmd.type == 4 then
                        -- Mode selection control for color screens
                        submenuStates[devId] = submenuStates[devId] or {}
                        local currentMode = submenuStates[devId][opt] or 0
                        local showMode = currentMode
                        if inputActive and i == submenuIndex and inputType == 4 then
                            showMode = inputValue
                        end
                        local modeName = ""
                        if cmd.options then
                            for _, option in ipairs(cmd.options) do
                                if option.value == showMode then
                                    modeName = option.name
                                    break
                                end
                            end
                            -- If no match found, use first option as default or show value
                            if modeName == "" then
                                if #cmd.options > 0 then
                                    modeName = cmd.options[1].name
                                else
                                    modeName = string.format("Mode:%d", showMode)
                                end
                            end
                        else
                            modeName = string.format("Mode:%d", showMode)
                        end
                        
                        -- Draw mode text at 1/6 from right edge (no box)
                        local textW = lcd.getTextWidth and lcd.getTextWidth((FIXEDWIDTH or 0), modeName) or (#modeName * 6)
                        local textX = LCD_W - math.floor(LCD_W / 6) - textW  -- Text at 1/6 from right edge
                        local textY = y + math.floor((cardH - 12) / 2)
                        
                        lcd.drawText(textX, textY, modeName, (FIXEDWIDTH or 0) + COLORS.WARNING)
                    elseif cmd.type == 1 then
                        -- Button type - show RUN text at 1/6 from right edge (no box)
                        local runText = "RUN"
                        local textW = lcd.getTextWidth and lcd.getTextWidth((FIXEDWIDTH or 0), runText) or (#runText * 6)
                        local textX = LCD_W - math.floor(LCD_W / 6) - textW  -- Text at 1/6 from right edge
                        local textY = y + math.floor((cardH - 12) / 2)
                        
                        lcd.drawText(textX, textY, runText, (FIXEDWIDTH or 0) + COLORS.PRIMARY)
                    elseif cmd.type == 5 then
                        -- Read-only text display type
                        submenuStates[devId] = submenuStates[devId] or {}
                        local displayText = "N/A"
                        if opt == "FIRMWARE_VERSION" then
                            local fwVersion = submenuStates[devId][opt] or 0
                            displayText = formatFirmwareVersion(fwVersion)
                        else
                            local val = submenuStates[devId][opt] or 0
                            displayText = tostring(val)
                        end
                        
                        -- Draw read-only text at 1/6 from right edge
                        local textW = lcd.getTextWidth and lcd.getTextWidth((FIXEDWIDTH or 0), displayText) or (#displayText * 6)
                        local textX = LCD_W - math.floor(LCD_W / 6) - textW
                        local textY = y + math.floor((cardH - 12) / 2)
                        
                        lcd.drawText(textX, textY, displayText, (FIXEDWIDTH or 0) + COLORS.TEXT_LIGHT)
                    elseif cmd.type == 6 then
                        -- Firmware update type - show UPDATE text at 1/6 from right edge
                        local updateText = "UPDATE"
                        local textW = lcd.getTextWidth and lcd.getTextWidth((FIXEDWIDTH or 0), updateText) or (#updateText * 6)
                        local textX = LCD_W - math.floor(LCD_W / 6) - textW
                        local textY = y + math.floor((cardH - 12) / 2)
                        
                        lcd.drawText(textX, textY, updateText, (FIXEDWIDTH or 0) + COLORS.WARNING)
                    end
                end
            else
                -- Black and white screen - simple layout
                local textY = y + math.floor((listRowHeight - 8) / 2)  -- Center text vertically
                lcd.drawText(leftX, textY, formatFunctionName(opt), (isSelected and INVERS or 0) + (UI_CONFIG and UI_CONFIG.TEXT_FLAG or 0))
                
                if cmd then
                    if cmd.type == 2 then
                        submenuStates[devId] = submenuStates[devId] or {}
                        if inputActive and i == submenuIndex then
                            text = string.format("%d", inputValue)
                            attr = INVERS
                        else
                            local val = submenuStates[devId][opt] or 0
                            text = string.format("%d", val)
                            attr = isSelected and INVERS or 0
                        end
                        local textW = lcd.getTextWidth and lcd.getTextWidth((UI_CONFIG and UI_CONFIG.TEXT_FLAG or 0), text) or (#text * 6)
                        local textX = rightX - textW  -- Right align text to rightX position
                        lcd.drawText(textX, textY, text, (attr or 0) + (UI_CONFIG and UI_CONFIG.TEXT_FLAG or 0))
                    elseif cmd.type == 3 then
                        submenuStates[devId] = submenuStates[devId] or {}
                        local state = submenuStates[devId][opt] or 0
                        text = state == 1 and "ON" or "OFF"
                        attr = isSelected and INVERS or 0
                        local textW = lcd.getTextWidth and lcd.getTextWidth((UI_CONFIG and UI_CONFIG.TEXT_FLAG or 0), text) or (#text * 6)
                        local textX = rightX - textW  -- Right align text to rightX position
                        lcd.drawText(textX, textY, text, (attr or 0) + (UI_CONFIG and UI_CONFIG.TEXT_FLAG or 0))
                    end
                end
            end
            
            -- Black and white screen - handle type 4 (mode) and type 1 (button)
            if not isColorScreen() and cmd and cmd.type == 4 then
                -- Mode selection control
                submenuStates[devId] = submenuStates[devId] or {}
                local currentMode = submenuStates[devId][opt] or 0
                local showMode = currentMode
                if inputActive and i == submenuIndex and inputType == 4 then
                    showMode = inputValue
                    attr = INVERS
                else
                    attr = isSelected and INVERS or 0
                end
                local modeName = ""
                -- Find display mode name (based on showMode)
                if cmd.options then
                    for _, option in ipairs(cmd.options) do
                        if option.value == showMode then
                            modeName = option.name
                            break
                        end
                    end
                    -- If no match found, use first option as default or show value
                    if modeName == "" then
                        if #cmd.options > 0 then
                            modeName = cmd.options[1].name
                        else
                            modeName = string.format("Mode:%d", showMode)
                        end
                    end
                else
                    modeName = string.format("Mode:%d", showMode)
                end
                text = modeName
                -- Draw mode name - vertically centered
                local textY = y + math.floor((listRowHeight - 8) / 2)
                local textW = lcd.getTextWidth and lcd.getTextWidth((UI_CONFIG and UI_CONFIG.TEXT_FLAG or 0), text) or (#text * 6)
                local textX = rightX - textW  -- Right align text to rightX position
                lcd.drawText(textX, textY, text, (attr or 0) + (UI_CONFIG and UI_CONFIG.TEXT_FLAG or 0))
            elseif not isColorScreen() and cmd and cmd.type == 1 then
                -- Button type - show RUN - vertically centered
                text = "RUN"
                attr = isSelected and INVERS or 0
                local textY = y + math.floor((listRowHeight - 8) / 2)
                local textW = lcd.getTextWidth and lcd.getTextWidth((UI_CONFIG and UI_CONFIG.TEXT_FLAG or 0), text) or (#text * 6)
                local textX = rightX - textW  -- Right align text to rightX position
                lcd.drawText(textX, textY, text, (attr or 0) + (UI_CONFIG and UI_CONFIG.TEXT_FLAG or 0))
            end
        end
        
        -- Interaction logic
        if inputActive then
            -- Dynamic acceleration: continuous rotation in a short time, step increment (1 → 10 → 100 → 1000)
            local function step(delta)
                local nowt = getTime() / 100
                if inputAccel.lastTime == 0 or (nowt - inputAccel.lastTime) > 0.5 then
                    inputAccel.repeatCount = 0
                else
                    inputAccel.repeatCount = inputAccel.repeatCount + 1
                end
                inputAccel.lastTime = nowt
                local base = 1
                local mul = 1
                if inputAccel.repeatCount >= 16 then
                    mul = 1000
                elseif inputAccel.repeatCount >= 8 then
                    mul = 100
                elseif inputAccel.repeatCount >= 4 then
                    mul = 10
                else
                    mul = 1
                end
                local inc = base * mul
                local newVal = inputValue + delta * inc
                if newVal < inputMin then newVal = inputMin end
                if newVal > inputMax then newVal = inputMax end
                inputValue = newVal
            end
            if action == "rot_left" or action == "page_prev" then
                step(-1)
            elseif action == "rot_right" or action == "page_next" then
                step(1)
            elseif action == "enter" then
                local func = submenuOptions[submenuIndex]
                local dev = submenuDevice
                if func and dev then
                    local cmd = CMD[func]
                    if not cmd then
                        logScreen("undefined function: " .. tostring(func))
                    else
                        submenuStates[dev.id] = submenuStates[dev.id] or {}
                        submenuStates[dev.id][func] = inputValue
                        sendCmdData(dev.type, dev.id, func, inputValue)
                        if inputType == 4 and cmd and cmd.options then
                            local modeName = ""
                            for _, option in ipairs(cmd.options) do
                                if option.value == inputValue then
                                    modeName = option.name
                                    break
                                end
                            end
                            -- If no match found, use first option as default or show value
                            if modeName == "" then
                                if #cmd.options > 0 then
                                    modeName = cmd.options[1].name
                                else
                                    modeName = string.format("Mode:%d", inputValue)
                                end
                            end
                            logf("%s %s SET %s", func, dev.id, modeName)
                        else
                            logf("%s %s SET %d", func, dev.id, inputValue)
                        end
                    end
                end
                inputActive = false
                inputType = 0
                inputAccel.lastTime = 0
                inputAccel.repeatCount = 0
            elseif action == "exit" then
                inputActive = false
                inputType = 0
                inputAccel.lastTime = 0
                inputAccel.repeatCount = 0
            end
        else
            if action == "exit" or (action == "enter" and submenuIndex == 0) then
				submenuActive = false
				submenuIndex = 1
				-- When pressing EXIT to directly return to the main list, also trigger a ping once to refresh the device list
				if submenuDevice and submenuDevice.id then
					pendingFocusDeviceId = submenuDevice.id
				end
				triggerPingOnReturn = true
				return 0
            elseif action == "rot_left" or action == "page_prev" then
                -- Normal menu item switch (do not enter edit mode, do not change value)
                if submenuIndex > 0 then 
                    submenuIndex = submenuIndex - 1 
                else 
                    submenuIndex = #submenuOptions
                end
                if submenuIndex == #submenuOptions then
                    -- When jumping from Back to the last item, ensure the last full screen is fully visible
                    submenuScroll = math.max(0, #submenuOptions - maxVisibleOptions)
                elseif submenuIndex >= 1 and submenuIndex < submenuScroll + 1 then
                    submenuScroll = submenuIndex - 1
                    if submenuScroll < 0 then submenuScroll = 0 end
                elseif submenuIndex >= 1 and submenuIndex > submenuScroll + maxVisibleOptions then
                    -- When scrolling up, also cover the scenario where overflow at the bottom is not fully visible
                    submenuScroll = submenuIndex - maxVisibleOptions
                    local maxStart = math.max(0, #submenuOptions - maxVisibleOptions)
                    if submenuScroll > maxStart then submenuScroll = maxStart end
                end
            elseif action == "rot_right" or action == "page_next" then
                -- Normal menu item switch (do not enter edit mode, do not change value)
                if submenuIndex < #submenuOptions then 
                    submenuIndex = submenuIndex + 1 
                else 
                    submenuIndex = 0
                end
                if submenuIndex >= 1 and submenuIndex > submenuScroll + maxVisibleOptions then
                    submenuScroll = submenuIndex - maxVisibleOptions
                    local maxStart = math.max(0, #submenuOptions - maxVisibleOptions)
                    if submenuScroll > maxStart then submenuScroll = maxStart end
                end
            elseif action == "enter" then
                if submenuIndex == 0 then
                    submenuActive = false
                    submenuIndex = 1
                    -- Record the device to focus on after returning
                    pendingFocusDeviceId = dev.id
                    triggerPingOnReturn = true
                    return 0
                end
                local func = submenuOptions[submenuIndex]
                local dev = submenuDevice
                local cmd = CMD[func]
                if not cmd then
                    logScreen("undefined function: " .. tostring(func))
                elseif cmd.type == 5 then
                    -- type=5 is read-only, do nothing
                    return 0
                elseif cmd.type == 6 then
                    -- type=6 is firmware update, show confirmation dialog
                    confirmModal.visible = true
                    confirmModal.selected = 0  -- Default to Cancel
                    confirmModal.deviceType = dev.type
                    confirmModal.deviceId = dev.id
                    confirmModal.funcName = func
                    return 0
                elseif cmd.type == 2 then
                    submenuStates[dev.id] = submenuStates[dev.id] or {}
                    inputActive = true
                    inputType = 2
                    inputValue = submenuStates[dev.id][func] or 0
                    inputMin = 0
                    inputMax = 65535
                elseif cmd.type == 4 then
                    -- Enter mode selection edit
                    submenuStates[dev.id] = submenuStates[dev.id] or {}
                    inputActive = true
                    inputType = 4
                    local currentMode = submenuStates[dev.id][func] or 0
                    inputValue = currentMode
                    -- Calculate range based on options (assumed continuous from 0 to max value)
                    local maxMode = 0
                    if cmd.options then
                        for _, option in ipairs(cmd.options) do
                            if option.value > maxMode then maxMode = option.value end
                        end
                    end
                    inputMin = 0
                    inputMax = maxMode
                elseif cmd.type == 3 then
                    submenuStates[dev.id] = submenuStates[dev.id] or {}
                    local state = submenuStates[dev.id][func] or 0
                    local newState = (state == 1) and 2 or 1
                    submenuStates[dev.id][func] = newState
                    sendCmdData(dev.type, dev.id, func, newState)
                    logf("%s %s TOGGLE %s", func, dev.id, newState == 1 and "ON" or "OFF")
                else
                    sendCmdData(dev.type, dev.id, func,1) 
                    logf("%s %s", func, dev.id)
                end
            end
        end
        
        -- Heartbeat packet
        local now = getTime() / 100
        if heartbeatEnabled and (now - lastHeartBeatTime >= heartbeatInterval) then
            heartBeat()
            lastHeartBeatTime = now
        end
        
        -- Popup (overlay)
        drawConfirmModal()
        drawSuccessModal()
        drawLog()
        return 0
    end

    -- ========== Main menu interface ==========
    
    -- Draw title bar
    drawHeader("RadioMaster  Sensor")
    
    -- If marked to trigger a ping when returning to the main list, execute here
    if triggerPingOnReturn then
        local nowt = getTime() / 100
        ping()
        lastPingTime = nowt
        pinged = true
        heartbeatEnabled = false
        autoSearching = true
        lastAutoSearchTime = nowt
        triggerPingOnReturn = false
    end
    
    -- Device list for menu (reuse table to reduce allocations)
    deviceList = deviceList or {}
    for i = #deviceList, 1, -1 do deviceList[i] = nil end
    for id, dev in pairs(sensors) do table.insert(deviceList, dev) end
    table.sort(deviceList, function(a, b) return a.id < b.id end)
    totalRows = #deviceList + 1

    -- If there is a device to restore focus on, set selection to its row
    if pendingFocusDeviceId then
        local targetIndex = nil
        for i = 1, #deviceList do
            if deviceList[i].id == pendingFocusDeviceId then
                targetIndex = i
                break
            end
        end
        if targetIndex then
            selected = targetIndex
            if selected < scroll then scroll = selected end
            if selected >= scroll + maxRows then scroll = selected - maxRows + 1 end
            pendingFocusDeviceId = nil
        end
    end

    -- Ensure selected and scroll are valid
    if selected < 0 then selected = 0 end
    if selected > totalRows - 1 then selected = totalRows - 1 end
    if scroll < 0 then scroll = 0 end
    if selected < scroll then scroll = selected end
    if selected >= scroll + maxRows then scroll = selected - maxRows + 1 end

    -- Draw Searching sensor as first row with enhanced styling
    local textH0 = getApproxTextHeight(UI_CONFIG and UI_CONFIG.TEXT_FLAG or 0)
    local y = UI_CONFIG.MARGIN_TOP + math.floor((UI_CONFIG.ROW_HEIGHT - textH0) / 2)
    local searchText = "Searching sensor..."
    
    -- Draw hourglass animation (center of screen) when searching
    if autoSearching then
        local centerX = math.floor(w / 2) - 5
        local centerY = math.floor(h / 2) - 10
        drawHourglass(centerX, centerY)
    end
    
    -- Draw search text with card style
    if isColorScreen() then
        local cardY = UI_CONFIG.MARGIN_TOP
        local cardW = LCD_W - UI_CONFIG.MARGIN_LEFT * 2
        local cardH = UI_CONFIG.ROW_HEIGHT - 2
        
        if selected == 0 then
            safeFillRect(UI_CONFIG.MARGIN_LEFT, cardY, cardW, cardH, COLORS.PRIMARY)
            lcd.drawRectangle(UI_CONFIG.MARGIN_LEFT, cardY, cardW, cardH, COLORS.PRIMARY_DARK)
            lcd.drawText(UI_CONFIG.MARGIN_LEFT + UI_CONFIG.CARD_PADDING, y, searchText, COLORS.CARD_BG)
        else
            safeFillRect(UI_CONFIG.MARGIN_LEFT, cardY, cardW, cardH, COLORS.CARD_BG)
            lcd.drawRectangle(UI_CONFIG.MARGIN_LEFT, cardY, cardW, cardH, COLORS.BORDER)
            lcd.drawText(UI_CONFIG.MARGIN_LEFT + UI_CONFIG.CARD_PADDING, y, searchText, COLORS.TEXT)
        end
    else
        local attr = (selected == 0) and INVERS or 0
        lcd.drawText(UI_CONFIG.MARGIN_LEFT + 2, y, searchText, attr + (UI_CONFIG and UI_CONFIG.TEXT_FLAG or 0))
    end
    
    -- Draw device list with enhanced card-style layout
    for i = 1, math.min(maxRows-1, #deviceList) do
        local dev = deviceList[i + scroll]
        if dev then
            local isSelected = ((i+scroll) == selected)
            local name = (dev.name and dev.name ~= "" and dev.name or "noName")
            local isOnline = not dev.offline
            
            y = UI_CONFIG.MARGIN_TOP + i * UI_CONFIG.ROW_HEIGHT
            
            if isColorScreen() then
                -- Draw card background
                local cardW = LCD_W - UI_CONFIG.MARGIN_LEFT * 2
                local cardH = UI_CONFIG.ROW_HEIGHT - 2
                
                if isSelected then
                    safeFillRect(UI_CONFIG.MARGIN_LEFT, y, cardW, cardH, COLORS.PRIMARY)
                    lcd.drawRectangle(UI_CONFIG.MARGIN_LEFT, y, cardW, cardH, COLORS.PRIMARY_DARK)
                else
                    safeFillRect(UI_CONFIG.MARGIN_LEFT, y, cardW, cardH, COLORS.CARD_BG)
                    lcd.drawRectangle(UI_CONFIG.MARGIN_LEFT, y, cardW, cardH, COLORS.BORDER)
                end
                
                -- Draw sensor icon (vertically centered in card)
                local iconX = UI_CONFIG.MARGIN_LEFT + UI_CONFIG.CARD_PADDING
                local iconSize = math.min(cardH - 4, isColorScreen() and 24 or 12)
                local iconY = y + math.floor((cardH - iconSize) / 2)
                local iconWidth = drawSensorIcon(iconX, iconY, isOnline)
                
                -- Draw device name and info
                local textX = iconX + iconWidth + 4
                local textY = y + math.floor((cardH - 12) / 2) + (UI_CONFIG.TEXT_VERTICAL_OFFSET or 0)
                local textColor = isSelected and COLORS.CARD_BG or COLORS.TEXT
                local deviceText = string.format("%s [%d]", name, dev.id)
                
                -- Calculate maximum text width (leave space for badge outside card)
                local maxTextWidth = cardW - (textX - UI_CONFIG.MARGIN_LEFT) - UI_CONFIG.CARD_PADDING - 60
                local actualTextWidth = lcd.getTextWidth and lcd.getTextWidth((FIXEDWIDTH or 0), deviceText) or (#deviceText * 6)
                
                -- Truncate text if too long
                if actualTextWidth > maxTextWidth then
                    local charWidth = 6
                    local maxChars = math.floor(maxTextWidth / charWidth) - 3
                    if maxChars > 0 then
                        deviceText = string.sub(deviceText, 1, maxChars) .. "..."
                    end
                end
                
                lcd.drawText(textX, textY, deviceText, (FIXEDWIDTH or 0) + textColor)
                
                -- Draw type text (no box) on the right, positioned at 1/6 from right edge
                local typeText = getSensorTypeName(dev.type)
                local typeTextW = lcd.getTextWidth and lcd.getTextWidth((FIXEDWIDTH or 0), typeText) or (#typeText * 6)
                local typeTextX = LCD_W - math.floor(LCD_W / 6) - typeTextW  -- Position at 1/6 from right edge
                local typeTextY = y + math.floor((cardH - 12) / 2) + (UI_CONFIG.TEXT_VERTICAL_OFFSET or 0)
                local typeTextColor = isOnline and COLORS.SUCCESS or COLORS.OFFLINE
                lcd.drawText(typeTextX, typeTextY, typeText, (FIXEDWIDTH or 0) + typeTextColor)
            else
                -- Black and white screen - simple layout
                local attr = isSelected and INVERS or 0
                local rowH = UI_CONFIG.ROW_HEIGHT
                
                -- Draw sensor icon
                drawSensorIcon(UI_CONFIG.MARGIN_LEFT, y, isOnline)
                
                -- Draw device information (name and ID only) - vertically centered
                local deviceText = string.format("%s [%d]", name, dev.id)
                local textY = y + math.floor((rowH - 8) / 2)  -- Center text in row (8px is typical text height for B&W)
                lcd.drawText(UI_CONFIG.MARGIN_LEFT + 12, textY, deviceText, (attr or 0) + (UI_CONFIG and UI_CONFIG.TEXT_FLAG or 0))
                
                -- Draw type text on the right, positioned at 1/6 from right edge - vertically centered
                local typeText = getSensorTypeName(dev.type)
                local typeTextW = lcd.getTextWidth and lcd.getTextWidth((UI_CONFIG and UI_CONFIG.TEXT_FLAG or 0), typeText) or (#typeText * 6)
                local typeTextX = LCD_W - math.floor(LCD_W / 6) - typeTextW
                lcd.drawText(typeTextX, textY, typeText, (attr or 0) + (UI_CONFIG and UI_CONFIG.TEXT_FLAG or 0))
            end
        end
    end
    
    -- Popup (overlay)
    drawConfirmModal()
    drawSuccessModal()
    drawLog()

    -- Handle menu events
    local action = handleEvent(event)
    if action == "exit" then
        return 2
    elseif action == "page_next" or action == "rot_right" then
        if selected < totalRows - 1 then
            selected = selected + 1
            if selected >= scroll + maxRows then
                scroll = selected - maxRows + 1
            end
        end
    elseif action == "page_prev" or action == "rot_left" then
        if selected > 0 then
            selected = selected - 1
            if selected < scroll then
                scroll = selected
            end
        end
    elseif action == "enter" then
        if selected == 0 then
            -- Searching sensor - manual trigger
            ping()
            lastPingTime = getTime() / 100
            pinged = true
            heartbeatEnabled = false
            autoSearching = true  -- Restart automatic search
            lastAutoSearchTime = getTime() / 100
            logScreen("Manual search triggered")
        else
            -- Enter submenu for device
            local dev = deviceList[selected]
            if dev then
                submenuDevice = dev
                submenuOptions = {}
                submenuIndex = 1
                submenuScroll = 0
                submenuActive = true
                
                if submenuStates[dev.id] then
                    submenuLoading = false
                    submenuOptions = SENSOR_CAPABILITY[dev.type] or {}
                else
                    sendCmdData(dev.type, dev.id, "CMD_DATA", 0xFF)
                    submenuLoading = true
                    submenuLoadTime = getTime() / 100
                    submenuLastRequestDev = dev
                end
            end
        end
        -- Unused: stats count
    end


    -- Always check for received data
    checkReceivedData()

    local now = getTime() / 100
    -- After ping, wait 2 seconds, then enable heartbeat
    if pinged and not heartbeatEnabled and (now - lastPingTime >= 2) then
        heartbeatEnabled = true
        lastHeartBeatTime = now
        logf("Heartbeat enabled")
    end
    -- Send heartBeat every 2 seconds if enabled
    if heartbeatEnabled and (now - lastHeartBeatTime >= heartbeatInterval) then
        heartBeat()
        lastHeartBeatTime = now
    end
    -- Heartbeat device offline logic
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
        -- Periodically trigger garbage collection to alleviate fragmentation
        if collectgarbage then collectgarbage("step", 200) end
    end
    
    -- Automatic search logic - send a ping every 500ms until a sensor is found
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
                logf("Found %d sensor(s)", sensorCount)
            else
                -- Continue searching
                ping()
                lastAutoSearchTime = now
            end
        end
    end
    
    return 0
end

return { run=run }

