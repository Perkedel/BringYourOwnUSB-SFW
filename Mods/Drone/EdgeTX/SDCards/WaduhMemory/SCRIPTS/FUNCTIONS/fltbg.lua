-------------------------------------------------
-- CONSTANTS
-------------------------------------------------

local switches = {"SA","SB","SC","SD","SE","SF","SG","SH"}

-- GV6 layout
-- FM2 = maneuver2
-- FM3 = yearly target
-- FM4 = maneuver1
-- FM5 = armIdx
-- FM6 = armVal
-- FM7 = motorIdx
-- FM8 = motorVal

local GV_INDEX = 5

local FM_MANEUVER2 = 2
local FM_YTARGET  = 3
local FM_MANEUVER = 4
local FM_ARM_IDX  = 5
local FM_ARM_VAL  = 6
local FM_MOTOR_IDX= 7
local FM_MOTOR_VAL= 8

local basePath = "/SCRIPTS/TOOLS/FlightProgress/"

-------------------------------------------------
-- STATE
-------------------------------------------------

local lastOn    = nil
local startSec  = 0
local startTime = ""

-------------------------------------------------
-- TIME HELPERS
-------------------------------------------------

local function nowTime()
  local t = getDateTime()
  return string.format("%02d:%02d:%02d", t.hour, t.min, t.sec)
end

local function nowDate()
  local t = getDateTime()
  return string.format("%04d-%02d-%02d", t.year, t.mon, t.day)
end

local function nowSeconds()
  local t = getDateTime()
  return t.hour*3600 + t.min*60 + t.sec
end

-------------------------------------------------
-- READ GLOBALS (EVERY LOOP)
-------------------------------------------------

local function readGV()

  local yTarget = tonumber(model.getGlobalVariable(GV_INDEX, FM_YTARGET)) or 0 

  local maneuver1 = tonumber(model.getGlobalVariable(GV_INDEX, FM_MANEUVER)) or 0
  local maneuver2 = tonumber(model.getGlobalVariable(GV_INDEX, FM_MANEUVER2)) or 0

  local motorIdx = tonumber(model.getGlobalVariable(GV_INDEX, FM_MOTOR_IDX)) or 1
  local motorVal = tonumber(model.getGlobalVariable(GV_INDEX, FM_MOTOR_VAL)) or 1024

  local armIdx   = tonumber(model.getGlobalVariable(GV_INDEX, FM_ARM_IDX)) or 0
  local armVal   = tonumber(model.getGlobalVariable(GV_INDEX, FM_ARM_VAL)) or 1024

  return yTarget, maneuver1, maneuver2, motorIdx, motorVal, armIdx, armVal
end

-------------------------------------------------
-- WRITE LOG LINE
-------------------------------------------------

local function appendFlight(seconds, maneuver, yTarget)

  local info = model.getInfo()
  if not info then return end

  local path = basePath .. info.name .. ".txt"
  local sumPath = basePath .. info.name .. "_S.txt"


  local flag = (seconds >= 60) and 1 or 0

  local line = string.format(
    "%s,%s,%s,%s,%d,%d,%d,0,%d,L,Z,0\n",
    info.name,
    nowDate(),
    startTime,
    nowTime(),
    flag,
    seconds,
    maneuver,
    yTarget
  )

  local f = io.open(path,"a")
  if f then
    io.write(f,line)
    io.close(f)
  end
  
  local fs = io.open(sumPath,"a")
  if fs then
    io.write(fs,line)
    io.close(fs)
  end

end

-------------------------------------------------
-- MAIN LOOP
-------------------------------------------------

local function run()

  -------------------------------------------------
  -- If 6POS5 is enabled do not write to model file
  -------------------------------------------------

  local POS5Id = getSwitchIndex("6POS5") 
  if POS5Id then
    local is6Pos5On = getSwitchValue(POS5Id)
  if is6Pos5On then
    return
  end
  end

  -------------------------------------------------
  -- Always read live values
  -------------------------------------------------

  local yTarget, maneuver1, maneuver2, motorIdx, motorVal, armIdx, armVal = readGV()

  -------------------------------------------------
  -- RS Slider Controls Maneuver Selection
  -------------------------------------------------

  local MANEUVER_OVERRIDE_SRC = "rs"
  local slider = getValue(MANEUVER_OVERRIDE_SRC) or 0

  local maneuver

  if slider < 0 then
    maneuver = 0                -- down
  elseif slider < 50 then
    maneuver = maneuver2        -- middle
  else
    maneuver = maneuver1        -- up
  end

  -------------------------------------------------
  -- motor
  -------------------------------------------------

  local motorRaw = getValue(switches[motorIdx]) or 0

  local motorOn =
      (motorVal > 0 and motorRaw > 0) or
      (motorVal < 0 and motorRaw < 0)

  -------------------------------------------------
  -- optional arm
  -------------------------------------------------

  local on

  if armIdx >= 1 then
    local armRaw = getValue(switches[armIdx]) or 0

    local armOn =
        (armVal > 0 and armRaw > 0) or
        (armVal < 0 and armRaw < 0)

    on = motorOn and armOn
  else
    on = motorOn
  end

  -------------------------------------------------
  -- first sync
  -------------------------------------------------

  if lastOn == nil then
    lastOn = on
    return
  end

  -------------------------------------------------
  -- start
  -------------------------------------------------

  if on and not lastOn then
    startSec  = nowSeconds()
    startTime = nowTime()
  end

  -------------------------------------------------
  -- stop
  -------------------------------------------------

  if not on and lastOn then
    appendFlight(nowSeconds() - startSec, maneuver, yTarget) -- NEW
  end

  lastOn = on
end

-------------------------------------------------

return { run = run }
