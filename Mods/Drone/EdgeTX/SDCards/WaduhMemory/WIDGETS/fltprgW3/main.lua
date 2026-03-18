---------------------------------------------------------------------------
-- FlightProgress Model Crash Details
---------------------------------------------------------------------------

local name = "fltprgW3"

---------------------------------------------------------------------------
-- OPTIONS
---------------------------------------------------------------------------

local options = {
  { "Year", STRING, "" }
}

local rebuild

---------------------------------------------------------------------------
-- CREATE
---------------------------------------------------------------------------

local function create(zone, opts)

  local w = {
    zone = zone,
    options = opts or {},

    filterYear = nil,

    totalFlights = 0,
    totalCrashes = 0,
    crashList = {},
    thisYearCrashes = 0,
    lastYearCrashes = 0,
    lastCrashDate = "",

    fileS = nil,
    bufferS = "",
    fileO = nil,
    bufferO = "",
    doneS = false,
    doneO = false

  }

  rebuild(w)
  return w
end

---------------------------------------------------------------------------
-- REBUILD (reset + reopen file)
---------------------------------------------------------------------------

rebuild = function(widget)

  widget.totalFlights = 0
  widget.totalCrashes = 0
  widget.crashList = {}
  widget.buffer = ""
  widget.done = false
  widget.streakSinceLastCrash = 0
  widget.currentYearStreak = 0
  widget.bestYearStreak = 0
  widget.thisYearCrashes = 0
  widget.lastYearCrashes = 0

  if widget.file then
    io.close(widget.file)
    widget.file = nil
  end

  local raw = widget.options["Year"]
  widget.filterYear = nil

  if raw and raw ~= "" then
    widget.filterYear = tonumber(string.match(raw, "%d%d%d%d"))
  end

  local info = model.getInfo()
  if info then
    local base = "/SCRIPTS/TOOLS/FlightProgress/" .. info.name

    widget.fileS = io.open(base .. "_S.txt", "r")
    widget.bufferS = ""

    widget.fileO = io.open(base .. "_O.txt", "r")
    widget.bufferO = ""

    widget.doneS = false
    widget.doneO = false
  end
end

---------------------------------------------------------------------------
-- UPDATE
---------------------------------------------------------------------------

local function update(widget, opts)

  local oldYear = widget.filterYear

  widget.options = opts

  local raw = opts["Year"]
  widget.filterYear = nil

  if raw and raw ~= "" then
    widget.filterYear = tonumber(string.match(raw, "%d%d%d%d"))
  end

  if oldYear ~= widget.filterYear then
    rebuild(widget)
  end
end

---------------------------------------------------------------------------
-- STREAM PROCESS
---------------------------------------------------------------------------

local function process(widget)

--------------------------------------------------
-- READ SUMMARY FILE (_S)
--------------------------------------------------

if not widget.doneS and widget.fileS then

  local chunk = io.read(widget.fileS, 128)

  if not chunk or chunk == "" then
    io.close(widget.fileS)
    widget.fileS = nil
    widget.bufferS = widget.bufferS .. "\n" 
    widget.doneS = true
  else
    widget.bufferS = widget.bufferS .. chunk
  end

  while true do

    local s = string.find(widget.bufferS, "\n", 1, true)
    if not s then break end

    local line = string.sub(widget.bufferS, 1, s-1)
    widget.bufferS = string.sub(widget.bufferS, s+1)

    line = string.gsub(line, "\r", "")

    if line ~= "" and not string.find(line,"ModelName",1,true) then

      local cols = {}

      for v in string.gmatch(line,"([^,]*)") do
        cols[#cols+1] = v
      end

      local flights = tonumber(cols[5]) or 0
      local year = tonumber(string.match(cols[2] or "","%d%d%d%d")) or 0

     if widget.filterYear == nil or year == widget.filterYear then

     widget.totalFlights = widget.totalFlights + flights
     widget.streakSinceLastCrash = widget.streakSinceLastCrash + flights

     if widget.filterYear and year == widget.filterYear then
      widget.currentYearStreak =
      widget.currentYearStreak + flights
     end

     end

    end
  end
end

--------------------------------------------------
-- READ OPERATIONS FILE (_O)
--------------------------------------------------

if not widget.doneO and widget.fileO then

  local chunk = io.read(widget.fileO, 128)

  if not chunk or chunk == "" then
    io.close(widget.fileO)
    widget.fileO = nil
    widget.bufferO = widget.bufferO .. "\n"
    widget.doneO = true
  else
    widget.bufferO = widget.bufferO .. chunk
  end

  while true do

    local s = string.find(widget.bufferO,"\n",1,true)
    if not s then break end

    local line = string.sub(widget.bufferO,1,s-1)
    widget.bufferO = string.sub(widget.bufferO,s+1)

    line = string.gsub(line,"\r","")

    if line ~= "" and not string.find(line,"ModelName",1,true) then

      local cols = {}

      for v in string.gmatch(line,"([^,]*)") do
        cols[#cols+1] = v
      end

      local year =
      tonumber(string.match(cols[2] or "","%d%d%d%d")) or 0

      local lineType = cols[10] or ""

      --------------------------------------------------
      -- HISTORY
      --------------------------------------------------
      if lineType == "H" then

      local flights =
      tonumber(cols[5]) or 0

      local crashes =
      tonumber(cols[8]) or 0

  -- TOTALS (FILTERED)

  if widget.filterYear == nil or year == widget.filterYear then

    widget.totalFlights =
    widget.totalFlights + flights

    widget.totalCrashes =
    widget.totalCrashes + crashes

  end

  -- YEAR COMPARISON (NOT FILTERED)
 
  local thisYear
  local lastYear

  if widget.filterYear then
    thisYear = widget.filterYear
    lastYear = widget.filterYear - 1
  else
    local now = getDateTime()
    thisYear = now.year
    lastYear = now.year - 1
  end

  if year == thisYear then
    widget.thisYearCrashes =
    widget.thisYearCrashes + crashes
  end

  if year == lastYear then
    widget.lastYearCrashes =
    widget.lastYearCrashes + crashes
  end


end

  --------------------------------------------------
  -- CRASH EVENTS
  --------------------------------------------------

  if lineType == "C" then

  if widget.filterYear == nil or year == widget.filterYear then
    
    widget.lastCrashDate = cols[2]
    widget.totalCrashes = widget.totalCrashes + 1

  local thisYear
  local lastYear

  if widget.filterYear then
    thisYear = widget.filterYear
    lastYear = widget.filterYear - 1
  else
    local now = getDateTime()
    thisYear = now.year
    lastYear = now.year - 1
  end

  if year == thisYear then
    widget.thisYearCrashes = widget.thisYearCrashes + 1
  end

  if year == lastYear then
    widget.lastYearCrashes = widget.lastYearCrashes + 1
  end

    --------------------------------------------------
    -- RESET STREAK
    --------------------------------------------------
    widget.streakSinceLastCrash = 0

    if widget.filterYear and year == widget.filterYear then

      if widget.currentYearStreak > widget.bestYearStreak then
        widget.bestYearStreak = widget.currentYearStreak
      end

      widget.currentYearStreak = 0

    end

    local date = cols[2] or ""
    local time = cols[3] or ""

    widget.crashList[#widget.crashList+1] =
    date .. " " .. time

  end

end


    end
  end
end

--------------------------------------------------
-- DONE FLAG
--------------------------------------------------

if widget.doneS and widget.doneO then
  widget.done = true
end

end

--------------------------------------------------
-- DATE HELPERS
--------------------------------------------------

local daysInMonth = {31,28,31,30,31,30,31,31,30,31,30,31}

local function isLeapYear(y)
  return (y%4==0 and y%100~=0) or (y%400==0)
end

local function dateToDays(d)

  local days = d.year*365 + math.floor((d.year+3)/4)

  for i=1,d.month-1 do

    days = days + daysInMonth[i]

    if i==2 and isLeapYear(d.year) then
      days = days + 1
    end

  end

  return days + d.day

end


local function parseDate(str)

  if not str then return nil end

  local y,m,d =
    string.match(str,"(%d%d%d%d)%-(%d%d)%-(%d%d)")

  if not y then return nil end

  return {
    year = tonumber(y),
    month = tonumber(m),
    day = tonumber(d)
  }

end

---------------------------------------------------------------------------
-- REFRESH
---------------------------------------------------------------------------

local function refresh(widget)

  local z = widget.zone

  lcd.drawFilledRectangle(z.x, z.y, z.w, z.h, BLACK)

  --lcd.drawText(z.x + z.w/2,z.y + 8,(model.getInfo().name or "MODEL") .. " CRASHES",CENTER + DBLSIZE + WHITE)
  lcd.drawText(z.x + z.w/2,z.y + 8,"CRASH TRACKER",CENTER + DBLSIZE + WHITE)

  -- Subtitle
  local subtitle
  if widget.filterYear == nil then
    subtitle = "Lifetime Total"
  else
    subtitle = tostring(widget.filterYear)
  end

  lcd.drawText(z.x + z.w/2, z.y + 40, subtitle, CENTER + SMLSIZE + BOLD + WHITE)

  -- process small chunk each frame
  process(widget)

  ----------------------------------------------------------
  -- LAST 5 CRASHES (Filtered)
  ----------------------------------------------------------

  local left = z.x + 10
  local y = z.y + 70
  local step = 18

  lcd.drawText(left, y, "Last 5 Crashes", SMLSIZE + YELLOW)
  y = y + step

  local total = #widget.crashList
  local startIndex = total - 4
  if startIndex < 1 then startIndex = 1 end

  for i = total, startIndex, -1 do
    lcd.drawText(left, y, widget.crashList[i], SMLSIZE + WHITE)
    y = y + step
  end

  -------------------------------------------------
  -- DAYS SINCE LAST CRASH
  -------------------------------------------------

  local yc = z.y + 180

  local now = getDateTime()
  local currentYear = now.year

if widget.filterYear == nil or widget.filterYear == currentYear then

  local daysSinceCrash = 0

  if widget.lastCrashDate and widget.lastCrashDate ~= "" then

    local lastDate = parseDate(widget.lastCrashDate)

    if lastDate then

      local today = {
        day = now.day,
        month = now.mon,
        year = now.year
      }

      daysSinceCrash = dateToDays(today) - dateToDays(lastDate)

    end
  end

  lcd.drawText(left, yc, "Days Since Last Crash", SMLSIZE + YELLOW)
  lcd.drawText(left, yc + 15, daysSinceCrash .. " Days", SMLSIZE + BOLD + WHITE)

else

  lcd.drawText(left, yc, "Days Since Last Crash", SMLSIZE + YELLOW)
  lcd.drawText(left, yc + 15, "No Data", SMLSIZE + BOLD + RED)
  lcd.drawText(left, yc + 45, "Available", SMLSIZE + BOLD + RED)

end
   
  ----------------------------------------------------------
  -- TOTAL FLIGHTS CIRCLE
  ----------------------------------------------------------

  local startX = z.x + z.w - 115
  local cBaseY = z.y + 210
  local r = 53
  local cx = startX + r

  lcd.drawFilledCircle(cx, cBaseY, r, ORANGE)
  lcd.drawCircle(cx, cBaseY, r, WHITE)
  lcd.drawText(cx, cBaseY+15, "Flights", SMLSIZE + BLACK + CENTER)
  lcd.drawText(cx, cBaseY-25, widget.totalFlights, DBLSIZE + WHITE + CENTER)

  ----------------------------------------------------------
  -- TOTAL CRASHES CIRCLE
  ----------------------------------------------------------

  startX = z.x + z.w - 215
  cx = startX + r

  lcd.drawFilledCircle(cx, cBaseY, r, ORANGE)
  lcd.drawCircle(cx, cBaseY, r, WHITE)
  lcd.drawText(cx, cBaseY+15, "Crashes", SMLSIZE + BLACK + CENTER)
  lcd.drawText(cx, cBaseY-25, widget.totalCrashes, DBLSIZE + WHITE + CENTER)

  ----------------------------------------------------------
  -- CRASH PERCENT CIRCLE
  ----------------------------------------------------------

  startX = z.x + z.w - 315
  cx = startX + r

  local percent = 0
  if widget.totalFlights > 0 then
    percent = (widget.totalCrashes / widget.totalFlights) * 100
  end

  lcd.drawFilledCircle(cx, cBaseY, r, ORANGE)
  lcd.drawCircle(cx, cBaseY, r, WHITE)
  lcd.drawText(cx, cBaseY+15, "Crash %", SMLSIZE + BLACK + CENTER)
  lcd.drawText(cx, cBaseY-25, string.format("%.1f%%", percent), DBLSIZE + WHITE + CENTER)


----------------------------------------------------------
-- CRASH COMPARISON BOX
----------------------------------------------------------

local boxW = 300
local boxH = 65

local boxX = z.x + z.w - 315
local boxY = z.y + 80

lcd.drawFilledRectangle(boxX, boxY, boxW, boxH, GREY)
lcd.drawRectangle(boxX, boxY, boxW, boxH, WHITE)

local thisYear
local lastYear

if widget.filterYear then
  thisYear = widget.filterYear
  lastYear = widget.filterYear - 1
else
  local now = getDateTime()
  thisYear = now.year
  lastYear = now.year - 1
end

local colorThis = DARKGREEN
local colorLast = DARKGREEN

if widget.thisYearCrashes > widget.lastYearCrashes then
  colorThis = RED
elseif widget.lastYearCrashes > widget.thisYearCrashes then
  colorLast = RED
end

lcd.drawText(boxX + boxW*0.25, boxY + 10, "Crashes " .. thisYear, SMLSIZE + CENTER + WHITE)

lcd.drawText(boxX + boxW*0.75, boxY + 10, "Crashes " .. lastYear, SMLSIZE + CENTER + WHITE)

lcd.drawText(boxX + boxW*0.25, boxY + 24, widget.thisYearCrashes, DBLSIZE + CENTER + colorThis)

lcd.drawText(boxX + boxW*0.75, boxY + 24, widget.lastYearCrashes, DBLSIZE + CENTER + colorLast)

lcd.drawText(boxX + boxW*0.5, boxY + 20, "Vs", SMLSIZE + CENTER + WHITE)

end

---------------------------------------------------------------------------
-- RETURN
---------------------------------------------------------------------------

return {
  name = name,
  create = create,
  update = update,
  refresh = refresh,
  options = options
}
