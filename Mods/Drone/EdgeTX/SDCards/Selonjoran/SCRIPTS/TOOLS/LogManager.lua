local LogFiles = loadfile("/SCRIPTS/TOOLS/LogManager/logfiles.lua")()
local logFiles = LogFiles.new()

local UiModel = loadfile("/SCRIPTS/TOOLS/LogManager/uimodel.lua")()
local uiModel = UiModel.new()

if lcd.RGB then
    local ColorUi = loadfile("/SCRIPTS/TOOLS/LogManager/colorui.lua")()
    local colorUi = ColorUi.new(uiModel, logFiles)

    return {init = function() colorUi:init() end, run = function(event, touchState) return colorUi:run(event, touchState) end, useLvgl = true}
else
    local BwUi = loadfile("/SCRIPTS/TOOLS/LogManager/bwui.lua")()
    local bwUi = BwUi.new(uiModel, logFiles)

    return {init = function() bwUi:init() end, run = function(event) return bwUi:run(event) end}
end
