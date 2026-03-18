local Selector = loadfile("/SCRIPTS/TOOLS/LogManager/selector.lua")()

local VERSION_STRING = "v0.5.0"

local LOG_DIR = "/LOGS"

local DISPLAY_DELAY = 30 -- 300 ms

local STATE = {
    IDLE = 0,
    CHOICE_MODEL_SELECTED = 1,
    CHOICE_ACTION_SELECTED = 2,
    CHOICE_MODEL_EDITING = 3,
    CHOICE_ACTION_EDITING = 4,
    EXECUTING = 5,
    REPORT = 6,
    DONE = 7
}

local textWidth
local textHeight

local BwUi = {}
BwUi.__index = BwUi

function BwUi.new(uiModel, logFiles)
    local self = setmetatable({}, BwUi)
    self.uiModel = uiModel
    self.logFiles = logFiles
    self.state = STATE.IDLE
    self.deletedFiles = 0
    self.deletedBytes = 0
    self.modelSelector = Selector.new()
    self.modelSelector:setOnChange(function(index) uiModel:setModelOption(index) end)
    self.actionSelector = Selector.new(uiModel.deleteOptions, 1)
    self.actionSelector:setOnChange(function(index) uiModel:setDeleteOption(index) end)
    self.timer = nil
    self.deletePos = 0
    self.deleteQueue = nil
    if lcd.RGB ~= nil then
        local w
        w, textHeight = lcd.sizeText("Hg")
        textWidth = w / 2
    else
        textWidth = 6
        textHeight = 8
    end

    return self
end

local function newLine(y, n)
    local lines = n or 1
    return y + lines * (textHeight + 1)
end

local function s(number)
    if number == 1 then
        return ""
    else
        return "s"
    end
end

function BwUi:updateUi()
    lcd.clear()
    local LEFT = 0
    local y = 0
    local totalFileCount = self.logFiles:getFileCount()
    local modelCount = self.logFiles:getModelCount()

    lcd.drawText(LEFT, y, "LogManager", INVERS)
    lcd.drawText(LCD_W - #VERSION_STRING * 4, y, VERSION_STRING, SMLSIZE)

    if self.state == STATE.EXECUTING then
        y = newLine(y, 1.5)
        lcd.drawText(LEFT, y, string.format("Deleting %d/%d", self.deletePos, #self.deleteQueue))
        y = newLine(y)
        local logFile = self.deleteQueue[self.deletePos]
        lcd.drawText(LEFT, y, logFile:getModelName())
        y = newLine(y)
        lcd.drawText(LEFT, y, string.format("%s-%s", logFile:getDate(), logFile:getTime()))
        y = newLine(y)
        lcd.drawText(LEFT, y, string.format("Size: %d Byte%s", logFile:getSize(), s(logFile:getSize())))
        y = newLine(y)
        lcd.drawGauge(1, y, LCD_W - 2, textHeight, self.deletePos, #self.deleteQueue)
    elseif self.state == STATE.REPORT then
        y = newLine(y, 1.5)
        lcd.drawText(LEFT, y, string.format("Deleted %d file%s", self.deletedFiles, s(self.deletedFiles)))
        y = newLine(y)
        lcd.drawText(LEFT, y, string.format("Freed up %d Byte%s", self.deletedBytes, s(self.deletedBytes)))
        y = newLine(y, 2)
        lcd.drawText(LEFT, y, "Press RTN")
    else
        y = newLine(y)
        lcd.drawText(LEFT, y,
            string.format("%d Log%s for %d Model%s", totalFileCount, s(totalFileCount), modelCount, s(modelCount)))
        y = newLine(y, 1.5)

        -- Model Selector
        lcd.drawText(LEFT, y, "Model:")
        lcd.drawText(6 * textWidth, y, self.modelSelector:getValue(), self.modelSelector:getFlags())
        y = newLine(y)

        -- Action Selector
        lcd.drawText(LEFT, y, "Actn:")
        lcd.drawText(6 * textWidth, y, self.actionSelector:getValue(), self.actionSelector:getFlags())

        local modelFileCount = self.logFiles:getFileCount(self.uiModel:getSelectedModel())
        local deleteCount = #self:getFilesToDelete()
        y = newLine(y) + 2

        lcd.drawText(LEFT, y, string.format("Selected: %d/%d file%s", deleteCount, modelFileCount, s(modelFileCount)))

        local statusLine
        if self.state == STATE.CHOICE_MODEL_EDITING then
            statusLine = "Select model"
        elseif self.state == STATE.CHOICE_ACTION_EDITING then
            statusLine = "Select action"
        elseif self.state == STATE.EXECUTING then
            statusLine = "Executing..."
        elseif deleteCount == 0 then
            statusLine = "No files to delete"
        elseif deleteCount > 0 then
            statusLine = "Long press Enter to delete"
        else
            statusLine = ""
        end
        y = newLine(y) + 2
        lcd.drawText(LEFT, y, statusLine, SMLSIZE)
    end
end

function BwUi:prepareDelete()
    self.deleteQueue = self:getFilesToDelete()
    self.deletePos = 1
    self.deletedFiles = 0
    self.deletedBytes = 0
    self.timer = getTime()
    return #self.deleteQueue > 0
end

function BwUi:handleIdle(event)
    if event == EVT_VIRTUAL_NEXT then
        self.modelSelector:setState(Selector.STATE.SELECTED)
        self.state = STATE.CHOICE_MODEL_SELECTED
    elseif event == EVT_VIRTUAL_ENTER_LONG and self:prepareDelete() then
        self.state = STATE.EXECUTING
    end
    self:updateUi()
    return 0
end

function BwUi:handleChoiceModelSelected(event)
    if event == EVT_VIRTUAL_ENTER then
        self.modelSelector:setState(Selector.STATE.EDITING)
        self.state = STATE.CHOICE_MODEL_EDITING
    elseif event == EVT_VIRTUAL_NEXT or event == EVT_VIRTUAL_PREV then
        self.modelSelector:setState(Selector.STATE.IDLE)
        self.actionSelector:setState(Selector.STATE.SELECTED)
        self.state = STATE.CHOICE_ACTION_SELECTED
    elseif event == EVT_VIRTUAL_ENTER_LONG and self:prepareDelete() then
        self.modelSelector:setState(Selector.STATE.IDLE)
        self.state = STATE.EXECUTING
    elseif event == EVT_VIRTUAL_NEXT_PAGE then
        self:updateBrowser()
    end
    self:updateUi()
    return 0
end

function BwUi:handleChoiceModelEditing(event)
    if event == EVT_VIRTUAL_NEXT then
        self.modelSelector:incValue()
    elseif event == EVT_VIRTUAL_PREV then
        self.modelSelector:decValue()
    elseif event == EVT_VIRTUAL_ENTER then
        self.modelSelector:setState(Selector.STATE.SELECTED)
        self.state = STATE.CHOICE_MODEL_SELECTED
    end
    self:updateUi()
    return 0
end

function BwUi:handleChoiceActionSelected(event)
    if event == EVT_VIRTUAL_ENTER then
        self.actionSelector:setState(Selector.STATE.EDITING)
        self.state = STATE.CHOICE_ACTION_EDITING
    elseif event == EVT_VIRTUAL_NEXT or event == EVT_VIRTUAL_PREV then
        self.actionSelector:setState(Selector.STATE.IDLE)
        self.modelSelector:setState(Selector.STATE.SELECTED)
        self.state = STATE.CHOICE_MODEL_SELECTED
    elseif event == EVT_VIRTUAL_ENTER_LONG and self:prepareDelete() then
        self.actionSelector:setState(Selector.STATE.IDLE)
        self.state = STATE.EXECUTING
    end
    self:updateUi()
    return 0
end

function BwUi:handleChoiceActionEditing(event)
    if event == EVT_VIRTUAL_NEXT then
        self.actionSelector:incValue()
    elseif event == EVT_VIRTUAL_PREV then
        self.actionSelector:decValue()
    elseif event == EVT_VIRTUAL_ENTER then
        self.actionSelector:setState(Selector.STATE.IDLE)
        self.state = STATE.CHOICE_ACTION_SELECTED
    end
    self:updateUi()
    return 0
end

function BwUi:handleReport(event)
    if event == EVT_EXIT_BREAK then
        self.state = STATE.DONE
    else
        self:updateUi()
    end
    return 0
end

function BwUi:handleDone(event)
    self:init()
    self:updateUi()
    self.state = STATE.IDLE
    return 0
end

function BwUi:getFilesToDelete()
    local filesToDelete = {}
    local selectedModel = self.uiModel:getSelectedModel()
    local deleteOption = self.uiModel:getDeleteOption()
    if deleteOption == self.uiModel.DELETE_OPTION.DELETE_EMPTY_LOGS then
        filesToDelete = self.logFiles:filter({ modelName = selectedModel, size = 0 })
    elseif deleteOption == self.uiModel.DELETE_OPTION.DELETE_ALL then
        filesToDelete = self.logFiles:filter({ modelName = selectedModel })
    elseif deleteOption == self.uiModel.DELETE_OPTION.KEEP_LAST_FLIGHT then
        filesToDelete = self.logFiles:filter({ modelName = selectedModel, keepLastFlight = true })
    elseif deleteOption == self.uiModel.DELETE_OPTION.KEEP_TODAY then
        filesToDelete = self.logFiles:filter({ modelName = selectedModel, keepToday = true })
    elseif deleteOption == self.uiModel.DELETE_OPTION.DELETE_LT_10K then
        filesToDelete = self.logFiles:filter({ modelName = selectedModel, maxSize = 10000 })
    elseif deleteOption == self.uiModel.DELETE_OPTION.DELETE_LT_20K then
        filesToDelete = self.logFiles:filter({ modelName = selectedModel, maxSize = 20000 })
    elseif deleteOption == self.uiModel.DELETE_OPTION.DELETE_LT_50K then
        filesToDelete = self.logFiles:filter({ modelName = selectedModel, maxSize = 50000 })
    elseif deleteOption == self.uiModel.DELETE_OPTION.DELETE_LT_100K then
        filesToDelete = self.logFiles:filter({ modelName = selectedModel, maxSize = 100000 })
    elseif deleteOption == self.uiModel.DELETE_OPTION.KEEP_LATEST_DATE then
        filesToDelete = self.logFiles:filter({ modelName = selectedModel, keepLastDay = true })
    end
    return filesToDelete
end

function BwUi:handleExecuting(event)
    if self.deletePos <= #self.deleteQueue then
        self:updateUi()
        local currentTime = getTime()
        if currentTime - self.timer > DISPLAY_DELAY then
            local logFile = self.deleteQueue[self.deletePos]
            logFile:delete()
            self.timer = currentTime
            self.deletedFiles = self.deletedFiles + 1
            self.deletedBytes = self.deletedBytes + logFile:getSize()
            self.deletePos = self.deletePos + 1
        end
    else -- all requested files deleted
        self.logFiles:read()
        self.uiModel:update(self.logFiles)
        self.state = STATE.REPORT
    end
    return 0
end

function BwUi:init()
    self.logFiles:read()
    self.uiModel:update(self.logFiles)
    self.modelSelector:setValues(self.uiModel:getModelOptions())
    self.modelSelector:setIndex(1)
    self.modelSelector:setState(Selector.STATE.IDLE)

    self.actionSelector:setIndex(1)
    self.actionSelector:setState(Selector.STATE.IDLE)
end

function BwUi:run(event)
    local result = 0
    if self.state == STATE.IDLE then
        result = self:handleIdle(event)
    elseif self.state == STATE.CHOICE_MODEL_SELECTED then
        result = self:handleChoiceModelSelected(event)
    elseif self.state == STATE.CHOICE_MODEL_EDITING then
        result = self:handleChoiceModelEditing(event)
    elseif self.state == STATE.CHOICE_ACTION_SELECTED then
        result = self:handleChoiceActionSelected(event)
    elseif self.state == STATE.CHOICE_ACTION_EDITING then
        result = self:handleChoiceActionEditing(event)
    elseif self.state == STATE.EXECUTING then
        result = self:handleExecuting(event)
    elseif self.state == STATE.REPORT then
        result = self:handleReport(event)
    elseif self.state == STATE.DONE then
        result = self:handleDone()
    end
    return result
end

return BwUi
