-- Class LogFiles
local LogFile = loadfile("/SCRIPTS/TOOLS/LogManager/logfile.lua")()

local LOG_DIR = "/LOGS"
local LOGFILE_PATTERN = "(.*)%-(%d%d%d%d%-%d%d%-%d%d)%-(%d%d%d%d%d%d)%.csv$"

local function append(table, entry)
    table[#table + 1] = entry
end


local LogFiles = {}
LogFiles.__index = LogFiles

function LogFiles.new()
    local self = setmetatable({}, LogFiles)
    return self
end

function LogFiles:read()
    self.logFiles = {}
    self.models = {}
    self.modelCount = 0
    for f in dir(LOG_DIR) do
        if LogFile.isLogFile(f) then
            local info = fstat(LOG_DIR .. "/" .. f)
            local logFile = LogFile.new(LOG_DIR, f, info)
            local modelName = logFile:getModelName()
            append(self.logFiles, logFile)
            if not self.models[modelName] then
                self.models[modelName] = 1
                self.modelCount = self.modelCount + 1
            else
                self.models[modelName] = self.models[modelName] + 1
            end
        end
    end
end

function LogFiles:getModels()
    local models = {}
    for k, _ in pairs(self.models) do
        append(models, k)
    end
    return models
end

function LogFiles:getModelCount()
    return self.modelCount
end

-- returns the file count for all models (model == nil) or specific model
function LogFiles:getFileCount( --[[opt]] model)
    if model then
        return self.models[model]
    else
        return #self.logFiles
    end
end

function LogFiles:getLastFlights()
    local map = {}
    for _, log in pairs(self.logFiles) do
        local modelName = log:getModelName()
        if not map[modelName] or log:getModelName() > map[modelName]:getFileName() then
            map[modelName] = log
        end
    end
    return map
end

function LogFiles:filter(filterSpec)
    local lastFlights
    if filterSpec.keepLastFlight or filterSpec.keepLastDay then
        lastFlights = self:getLastFlights()
    end

    local now = getDateTime()
    local today = string.format("%04d-%02d-%02d", now.year, now.mon, now.day)


    local result = {}
    for _, log in pairs(self.logFiles) do
        local fileName = log:getFileName()
        local modelName, date, time = string.match(fileName, LOGFILE_PATTERN)
        if (not filterSpec.modelName or modelName == filterSpec.modelName) and
            (not filterSpec.keepToday or date ~= today) and
            (not filterSpec.size or filterSpec.size == log:getSize()) and
            (not filterSpec.keepLastFlight or fileName ~= lastFlights[modelName]:getFileName()) and
            (not filterSpec.maxSize or log:getSize() <= filterSpec.maxSize) and
            (not filterSpec.keepLastDay or date ~= lastFlights[modelName]:getDate()) then
            append(result, log)
        end
    end
    return result
end

return LogFiles
