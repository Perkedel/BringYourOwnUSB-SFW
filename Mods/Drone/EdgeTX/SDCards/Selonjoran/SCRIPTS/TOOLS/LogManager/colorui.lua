-- Class ColorUi
local ColorUi = {}
ColorUi.__index = ColorUi

local VERSION = "v0.5.0"
local HORIZONTAL_PAD = 10

local STATE = {
    IDLE = 0,
    INIT = 1,
    OPTION_CHANGED = 2,
    FILES_CHANGED = 3,
    DELETING = 4
}

function ColorUi.new(uiModel, logFiles)
    local self = setmetatable({}, ColorUi)
    self.uiModel = uiModel
    self.logFiles = logFiles
    self.deletePos = 1
    self.deletedFiles = 0
    self.deletedBytes = 0
    self.deleteQueue = {}
    self.exitCode = 0
    self.state = STATE.INIT
    return self
end

function ColorUi:getFilesToDelete()
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
    elseif deleteOption == self.uiModel.DELETE_OPTION.KEEP_LATEST_DATE then
        filesToDelete = self.logFiles:filter({ modelName = selectedModel, keepLastDay = true })
    elseif deleteOption == self.uiModel.DELETE_OPTION.DELETE_LT_10K then
        filesToDelete = self.logFiles:filter({ modelName = selectedModel, maxSize = 10000 })
    elseif deleteOption == self.uiModel.DELETE_OPTION.DELETE_LT_20K then
        filesToDelete = self.logFiles:filter({ modelName = selectedModel, maxSize = 20000 })
    elseif deleteOption == self.uiModel.DELETE_OPTION.DELETE_LT_50K then
        filesToDelete = self.logFiles:filter({ modelName = selectedModel, maxSize = 50000 })
    elseif deleteOption == self.uiModel.DELETE_OPTION.DELETE_LT_100K then
        filesToDelete = self.logFiles:filter({ modelName = selectedModel, maxSize = 100000 })
    end
    return filesToDelete
end

function ColorUi:onConfirm(filesToDelete)
    self.deleteQueue = filesToDelete
    self.deletePos = 1
    self.state = STATE.DELETING
end

function ColorUi:onDeleteLogsPressed()
    local filesToDelete = self:getFilesToDelete()

    lvgl.confirm({
        title = "Delete",
        message = "Really delete " .. #filesToDelete .. " files?",
        confirm = function() return self:onConfirm(filesToDelete) end
    })
end

function ColorUi:updateUi()
    local selectedModel = self.uiModel:getSelectedModel()
    local logFileCount = self.logFiles:getFileCount(selectedModel)
    self.labelLogCount:set({ text = logFileCount .. " Logfiles" })

    local filesToDelete = self:getFilesToDelete()
    self.labelDeleteCount:set({ text = "Delete " .. #filesToDelete .. "/" .. logFileCount })

    if self.state == STATE.NORMAL then
        self.progressInfo:set({
            text = string.format("Deleted: %d Files, Freed up %d Bytes", self.deletedFiles,
                self.deletedBytes)
        })
    elseif self.state == STATE.DELETING then
        local width = 0
        self.progressInfo:set({
            text = string.format("File: %d/%d Bytes: %d", self.deletePos, #self.deleteQueue,
                self.deletedBytes)
        })
        width = (LCD_W - 2 * HORIZONTAL_PAD) * self.deletePos / #self.deleteQueue
        self.progressBar:set({ w = width })
    end
end

function ColorUi:onModelOptionChange(index)
    self.uiModel:setModelOption(index)
    self.state = STATE.OPTION_CHANGED
end

function ColorUi:onDeleteOptionChange(index)
    self.uiModel:setDeleteOption(index)
    self.state = STATE.OPTION_CHANGED
end

function ColorUi:redraw()
    local ROW = { 10, 35, 75, 115, 155, 190 }

    lvgl.clear();

    local page = lvgl.page({ title = string.format("Log Manager %s", VERSION) })

    local fileCount = self.logFiles:getFileCount()
    local modelCount = self.logFiles:getModelCount()

    page:label({
        x = HORIZONTAL_PAD,
        y = ROW[1],
        text = "Found " .. fileCount .. " logfiles for " .. modelCount .. " models"
    })

    local modelBox = page:box({ x = HORIZONTAL_PAD, y = ROW[2], flexFlow = lvgl.FLOW_ROW, flexPad = lvgl.PAD_LARGE })
    modelBox:label({ text = "Select Model(s):" })
    modelBox:choice({
        title = "Model",
        get = function() return self.uiModel:getModelOption() end,
        set = function(index) return self:onModelOptionChange(index) end,
        values = self.uiModel:getModelOptions()
    })
    self.labelLogCount = modelBox:label({})

    local logFilesBox = page:box({ x = HORIZONTAL_PAD, y = ROW[3], flexFlow = lvgl.FLOW_ROW, flexPad = lvgl.PAD_LARGE })
    logFilesBox:label({ text = "Select Logfiles:" })
    logFilesBox:choice({
        title = "Action",
        get = function() return self.uiModel:getDeleteOption() end,
        set = function(index) return self:onDeleteOptionChange(index) end,
        values = self.uiModel.deleteOptions
    })
    self.labelDeleteCount = logFilesBox:label({})

    local progressBox = page:box({ x = HORIZONTAL_PAD, y = ROW[4], flexFlow = lvgl.FLOW_ROW, flexPad = lvgl.PAD_LARGE })
    progressBox:label({ text = "Progress:" })
    self.progressInfo = progressBox:label({ text = "" })

    self.progressBar = page:rectangle({ x = HORIZONTAL_PAD, y = ROW[5], w = 0, h = 20, filled = true })

    local buttonBox = page:box({ x = HORIZONTAL_PAD, y = ROW[6], flexFlow = lvgl.FLOW_ROW, flexPad = lvgl.PAD_LARGE })
    buttonBox:button({ w = 100, text = "Exit", press = function() self.exitCode = 1 end })
    buttonBox:button({
        w = 100,
        text = "Delete Logs",
        press = function() self:onDeleteLogsPressed() end,
        active = function() return #self:getFilesToDelete() > 0 end
    })

    self:updateUi()
end

function ColorUi:handleInit()
    self:redraw()
    self.state = STATE.IDLE
end

function ColorUi:handleOptionChanged()
    self:updateUi()
    self.state = STATE.IDLE
end

function ColorUi:handleFilesChanged()
    self.logFiles:read()
    self.uiModel:update(self.logFiles)
    self:updateUi()
    self.state = STATE.IDLE
end

function ColorUi:handleDeleting()
    if self.deletePos <= #self.deleteQueue then
        local logFile = self.deleteQueue[self.deletePos]
        logFile:delete()
        self.deletedBytes = self.deletedBytes + logFile:getSize()
        self.deletedFiles = self.deletedFiles + 1
        self.deletePos = self.deletePos + 1
        self:updateUi()
    else -- finished deleting
        self.deletePos = 0
        self.deleteQueue = nil
        self.state = STATE.FILES_CHANGED
    end
end

function ColorUi:init()
    self.logFiles:read()
    self.uiModel:update(self.logFiles)
end

function ColorUi:run(event, touchState)
    if lvgl then
        if self.state == STATE.INIT then
            self:handleInit()
        elseif self.state == STATE.OPTION_CHANGED then
            self:handleOptionChanged()
        elseif self.state == STATE.FILES_CHANGED then
            self:handleFilesChanged()
        elseif self.state == STATE.DELETING then
            self:handleDeleting()
        end
    else
        lcd.clear()
        lcd.drawText(10, 10, "LVGL support required")
    end
    return self.exitCode
end

return ColorUi
