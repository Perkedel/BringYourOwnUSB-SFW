---------------------------------------------------------------------------
-- FlightProgress Maintenance Widget
---------------------------------------------------------------------------

local name = "fltprgW5"

---------------------------------------------------------------------------
-- OPTIONS
---------------------------------------------------------------------------

local options = {

  { "Year", STRING, "" },
  { "Mode", VALUE, 0, 0, 1 },   
  { "Interval", VALUE, 100, 1, 500 },
  { "Warning", VALUE, 10, 0, 50 },
  { "Write", VALUE, 0, 0, 1 }

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

    serviceDates = {},
    lastServiceFlights = 0,
    serviceBaseFlight = 0,
    thisYearServices = 0,
    lastYearServices = 0,

    totalFlights = 0,
    totalFlightsAll = 0,
    historyFlights = 0,

    remaining = nil,

    fileO = nil,
    bufferO = "",
    doneO = false,

    fileS = nil,
    bufferS = "",
    doneS = false

  }

  rebuild(w)

  return w

end

---------------------------------------------------------------------------
-- REBUILD
---------------------------------------------------------------------------

rebuild = function(widget)

  widget.serviceDates = {}

  widget.lastServiceFlights = 0
  widget.thisYearServices = 0  
  widget.lastYearServices = 0  
  widget.serviceBaseFlight = 0
  widget.totalFlights = 0
  widget.totalFlightsAll = 0
  widget.historyFlights = 0
  widget.remaining = nil
  widget.buffer = ""
  widget.done = false

  if widget.file then

    io.close(widget.file)

    widget.file = nil

  end

  local raw = widget.options["Year"]

  widget.filterYear = nil

  if raw and raw ~= "" then
    widget.filterYear = tonumber(string.match(raw,"%d%d%d%d"))
  end

  local info = model.getInfo()

  if info then

  local base = "/SCRIPTS/TOOLS/FlightProgress/" .. info.name

  widget.fileO = io.open(base .. "_O.txt","r")
  widget.bufferO = ""
  widget.doneO = false

  widget.fileS = io.open(base .. "_S.txt","r")
  widget.bufferS = ""
  widget.doneS = false

  end

end

---------------------------------------------------------------------------
-- UPDATE
---------------------------------------------------------------------------

local function update(widget, opts)

  widget.options = opts

  rebuild(widget)
end

---------------------------------------------------------------------------
-- DATE HELPERS
---------------------------------------------------------------------------

local daysInMonth = {31,28,31,30,31,30,31,31,30,31,30,31}

local function isLeapYear(y)
  return (y%4==0 and y%100~=0) or (y%400==0)
end

local function addDays(date, days)

  local d = date.day
  local m = date.month
  local y = date.year

  while days > 0 do

    local dim = daysInMonth[m]

    if m==2 and isLeapYear(y) then
      dim = 29
    end

    if d + days <= dim then

      d = d + days
      days = 0

    else

      days = days - (dim - d + 1)

      d = 1
      m = m + 1

      if m > 12 then
        m = 1
        y = y + 1
      end

    end
  end

  return {
    day=d,
    month=m,
    year=y
  }

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

local function getToday()

  local t = getDateTime()

  return {
    year = t.year,
    month = t.mon,
    day = t.day
  }

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
-- PROCESS FILE
---------------------------------------------------------------------------

local function process(widget)

-------------------------------------------------
-- READ SUMMARY FILE (_S)
-------------------------------------------------

if not widget.doneS and widget.fileS then

  local chunk = io.read(widget.fileS,128)

  if not chunk or chunk == "" then

    io.close(widget.fileS)
    widget.fileS=nil
    widget.doneS=true

  else

    widget.bufferS = widget.bufferS .. chunk

  end

  while true do

    local s = string.find(widget.bufferS,"\n",1,true)

    if not s then break end

    local line = string.sub(widget.bufferS,1,s-1)

    widget.bufferS = string.sub(widget.bufferS,s+1)

    line = string.gsub(line,"\r","")

    if line ~= "" and not string.find(line,"ModelName",1,true) then

      local cols={}

      for v in string.gmatch(line,"([^,]*)") do
        cols[#cols+1]=v
      end

      local flights = tonumber(cols[5]) or 0
      local date = cols[2] or ""
      local year = tonumber(string.match(date,"%d%d%d%d")) or 0

      -------------------------------------------------
      -- TOTAL FLIGHTS FROM SUMMARY
      -------------------------------------------------

        widget.totalFlightsAll = widget.totalFlightsAll + flights
    end
  end
end


-------------------------------------------------
-- READ OPERATIONS FILE (_O)
-------------------------------------------------

if not widget.doneO and widget.fileO then

  local chunk = io.read(widget.fileO,128)

  if not chunk or chunk == "" then

    io.close(widget.fileO)
    widget.fileO=nil
    widget.doneO=true

  else

    widget.bufferO =
    widget.bufferO .. chunk

  end

  while true do

    local s =
    string.find(widget.bufferO,"\n",1,true)

    if not s then break end


    local line = string.sub(widget.bufferO,1,s-1)

    widget.bufferO = string.sub(widget.bufferO,s+1)

    line = string.gsub(line,"\r","")

    if line ~= ""
    and not string.find(line,"ModelName",1,true)
    then

      local cols={}

      for v in string.gmatch(line,"([^,]*)") do
        cols[#cols+1]=v
      end


      local flights = tonumber(cols[5]) or 0
      local date = cols[2] or ""
      local year = tonumber(string.match(date,"%d%d%d%d")) or 0
      local lineType = cols[10]

      -------------------------------------------------
      -- HISTORY
      -------------------------------------------------

      if lineType == "H" then
         widget.historyFlights = widget.historyFlights + flights
      end

      -------------------------------------------------
      -- SERVICE → STORE LAST ONLY
      -------------------------------------------------

      if lineType == "S" then

         local srvType =cols[11] or "?"
         local srvFlight =tonumber(cols[12]) or 0

         widget.serviceBaseFlight =
         srvFlight


         -------------------------------------------------
         -- FILTERED DISPLAY ONLY
         -------------------------------------------------

         if widget.filterYear==nil
         or year==widget.filterYear then

            widget.serviceDates[#widget.serviceDates+1] =
            {
              date = date,
              type = srvType
            }


            local now =getDateTime()
            local thisYear = widget.filterYear or now.year
            local lastYear = thisYear - 1

            if year == thisYear then
               widget.thisYearServices =widget.thisYearServices + 1
            end

            if year == lastYear then
               widget.lastYearServices = widget.lastYearServices + 1
            end

         end
      end
    end
  end
end

-------------------------------------------------
-- DONE FLAG
-------------------------------------------------
if widget.doneS and widget.doneO then

   widget.lastServiceFlights = widget.serviceBaseFlight + widget.historyFlights

   widget.done = true

end


end

---------------------------------------------------------------------------
-- CALCULATE REMAINING
---------------------------------------------------------------------------

local function calculate(widget)

  local mode =
    widget.options["Mode"] or 0

  local interval =
    widget.options["Interval"] or 100

  if #widget.serviceDates == 0 then return end

  if mode == 0 then
    local lastDate = parseDate(widget.serviceDates[#widget.serviceDates].date)
    local today = getToday()
    local dueDate = addDays(lastDate, interval)
    widget.remaining = dateToDays(dueDate) - dateToDays(today)

  else

    local due = widget.serviceBaseFlight + interval
    widget.remaining = due - widget.totalFlightsAll

  end

end

---------------------------------------------------------------------------
-- REFRESH
---------------------------------------------------------------------------

local function refresh(widget)

  local z = widget.zone

  lcd.drawFilledRectangle(z.x,z.y,z.w,z.h,BLACK)

  -------------------------------------------------
  -- FLASHING TITLE
  -------------------------------------------------

  local flashOn = (getTime() % 100) < 50

  local titleX = z.x + z.w/2
  local titleY = z.y

  if widget.remaining and widget.remaining <= 0 then

    if flashOn then
      lcd.drawText(titleX,titleY+8,"SERVICE DUE",CENTER + DBLSIZE + RED)
    end

  else
    lcd.drawText(titleX,titleY+8,"MAINTENANCE TRACKER",CENTER + DBLSIZE + WHITE)
  end

  -------------------------------------------------
  -- SUBTITLE (YEAR OR LIFETIME)
  -------------------------------------------------
  if not (widget.remaining and widget.remaining <= 0) then  

  local subtitle

  if widget.filterYear then
    subtitle = tostring(widget.filterYear)
  else
    subtitle = "Lifetime Total"
  end

  lcd.drawText(z.x + z.w/2, titleY+40, subtitle, CENTER + SMLSIZE + BOLD + WHITE)
  end 

  process(widget)

  if widget.done then
    calculate(widget)
  end


  -------------------------------------------------
  -- LAST 3 SERVICE DATES
  -------------------------------------------------

  local y = z.y + 60

  lcd.drawText(z.x+10,y,"Last 3 Services", YELLOW)

  y=y+20

  for i=
    #widget.serviceDates,
    math.max(1,#widget.serviceDates-2),
    -1
  do

    local s = widget.serviceDates[i]

    lcd.drawText(z.x+10,y,s.date .. " / " .. s.type, WHITE)

    y=y+18

  end

  -------------------------------------------------
  -- SERVICE TYPES SUMMARY
  -------------------------------------------------

  y = y + 10

  lcd.drawText(z.x+10, y, "Service Types", YELLOW)

  y = y + 18

  local countF = 0
  local countP = 0
  local countI = 0
  local countC = 0

  for i = 1, #widget.serviceDates do

  local t = widget.serviceDates[i].type

  if t == "F" then countF = countF + 1 end
  if t == "P" then countP = countP + 1 end
  if t == "I" then countI = countI + 1 end
  if t == "C" then countC = countC + 1 end

  end

  lcd.drawText(z.x+10, y,     "Full Service: " .. countF, WHITE)
  lcd.drawText(z.x+10, y+18,  "Part Service: " .. countP, WHITE)
  lcd.drawText(z.x+10, y+36,  "Inspection Only: " .. countI, WHITE)
  lcd.drawText(z.x+10, y+54,  "Crash Repair: " .. countC, WHITE)

  -------------------------------------------------
  -- FLIGHTS SINCE LAST SERVICE BOX
  -------------------------------------------------
  local now = getDateTime()

  local thisYear = widget.filterYear or now.year
  local lastYear = thisYear - 1

  local boxW = 160
  local boxH = 40

  local boxX = z.x + z.w - boxW - 165
  local boxY = z.y + 85   

  lcd.drawFilledRectangle(boxX, boxY, boxW, boxH, ORANGE)
  lcd.drawRectangle(boxX, boxY, boxW, boxH, WHITE)

  local colorThis = RED
  local colorLast = RED

  if widget.thisYearServices > widget.lastYearServices then
    colorThis = GREEN
  elseif widget.lastYearServices > widget.thisYearServices then
    colorLast = GREEN
  end

  lcd.drawText(boxX + boxW*0.25,boxY + 5,widget.thisYearServices,CENTER + colorThis)
  lcd.drawText(boxX + boxW*0.75,boxY + 5,widget.lastYearServices,CENTER + colorLast)

  lcd.drawText(boxX + boxW*0.25,boxY + 22,thisYear,CENTER + SMLSIZE + BLACK)
  lcd.drawText(boxX + boxW*0.75,boxY + 22,lastYear,CENTER + SMLSIZE + BLACK)

  -------------------------------------------------
  -- TOTAL SERVICES PERFORMED BOX
  -------------------------------------------------

  local totalServices = #widget.serviceDates or 0

  local boxW = 160
  local boxH = 40

  local boxX = z.x + z.w - boxW - 165
  local boxY = z.y + 135   

  lcd.drawFilledRectangle(boxX, boxY, boxW, boxH, ORANGE)
  lcd.drawRectangle(boxX, boxY, boxW, boxH, WHITE)

  lcd.drawText(boxX + boxW/2, boxY + 5, totalServices, CENTER + GREEN)
  lcd.drawText(boxX + boxW/2, boxY + 20, "Total Services Performed", CENTER + SMLSIZE + BLACK)

  -------------------------------------------------
  -- DAYS SINCE LAST SERVICE BOX
  -------------------------------------------------

  local daysSince = 0

  if #widget.serviceDates >= 1 then

  local lastDate =
  parseDate(widget.serviceDates[#widget.serviceDates].date)

  if lastDate then

    local now = getDateTime()

    local today = {
      day = now.day,
      month = now.mon,
      year = now.year
    }

    daysSince =
    dateToDays(today) - dateToDays(lastDate)

  end

  end

  local boxW = 160
  local boxH = 40

  local boxX = z.x + z.w - boxW - 165
  local boxY = z.y + 185   

  lcd.drawFilledRectangle(boxX, boxY, boxW, boxH, ORANGE)
  lcd.drawRectangle(boxX, boxY, boxW, boxH, WHITE)

  lcd.drawText(boxX + boxW/2,boxY + 5,daysSince .. " Days",CENTER + GREEN)
  lcd.drawText(boxX + boxW/2,boxY + 20,"Days Since Service",CENTER + SMLSIZE + BLACK)

  -------------------------------------------------
  -- TEXT AT THE BOTTOM
  -------------------------------------------------

  local serviceY = z.y + z.h - 30

  local mode = widget.options["Mode"] or 0
  local interval = widget.options["Interval"] or 100

  if widget.remaining then

  local overdue = widget.remaining <= 0

  -------------------------------------------------
  -- DATE MODE
  -------------------------------------------------

  if mode == 0 then

    local lastDateStr = widget.serviceDates[#widget.serviceDates].date
    local lastDate = parseDate(lastDateStr)
    local dueDate = addDays(lastDate, interval)

    lcd.drawText(z.x + 10,serviceY,string.format("Last Service: %02d/%02d/%04d",lastDate.day,lastDate.month,lastDate.year),overdue and RED or GREEN)
    lcd.drawText(z.x + z.w - 10,serviceY,string.format("Service Due: %02d/%02d/%04d",dueDate.day,dueDate.month,dueDate.year),RIGHT + (overdue and RED or GREEN))

  -------------------------------------------------
  -- FLIGHT COUNT MODE
  -------------------------------------------------

  else

    local lastFlight =
      widget.lastServiceFlights

    local dueFlight =
      lastFlight + interval

    lcd.drawText(z.x + 10, serviceY, string.format("Last Service Flight: %d",lastFlight), overdue and RED or GREEN)
    lcd.drawText(z.x + z.w - 10, serviceY, string.format("Service Due: Flight #%d", dueFlight), RIGHT + (overdue and RED or GREEN))

  end

else

  lcd.drawText(z.x + z.w / 2, serviceY,(mode == 0) and "NO SERVICE DATA" or  "NO SERVICE DATA",CENTER + YELLOW)

end

-------------------------------------------------
-- STATUS CIRCLE
-------------------------------------------------

local remaining = widget.remaining or 0

  local cx = z.x+z.w-80
  local cy = z.y+155
  local r = 70

  local warn = widget.options["Warning"] or 10

  local fill

  if remaining <= 0 then
    fill=RED
  elseif remaining <= warn then
    fill=YELLOW
  else
    fill=GREEN
  end

  lcd.drawFilledCircle(cx,cy,r,fill)
  lcd.drawCircle(cx,cy,r,WHITE)

  lcd.drawText(cx,cy-33,remaining,CENTER + DBLSIZE + BOLD + BLACK)

  local labelText
  if remaining < 0 then
    labelText =
      (widget.options["Mode"] == 0)
      and "Days overdue"
      or "Flights overdue"
  else
    labelText =
      (widget.options["Mode"] == 0)
      and "Days till service"
      or "Flights till service"
  end

  lcd.drawText(cx,cy + r/2 - 5,labelText,CENTER + SMLSIZE + BLACK)

  -------------------------------------------------
  -- GV OUTPUT
  -------------------------------------------------

  if widget.options["Write"] == 1 then 
  if widget.remaining then

    local warn = widget.options["Warning"] or 10

    local gv=0
    if widget.remaining <= 0 then
      gv=1
    elseif widget.remaining <= warn then
      gv=2
    end

    model.setGlobalVariable(5,0,gv)

  end
 end
end

---------------------------------------------------------------------------
-- RETURN
---------------------------------------------------------------------------

return {

  name=name,
  create=create,
  update=update,
  refresh=refresh,
  options=options

}
