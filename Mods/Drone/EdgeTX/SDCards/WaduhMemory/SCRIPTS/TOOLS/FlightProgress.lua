local toolName = "TNS|Flight Progress|TNE" 

-------------------------------------------------
-- CONSTANTS
-------------------------------------------------

local switches = {"SA","SB","SC","SD","SE","SF","SG","SH"}

local GV_INDEX = 5

-- GV6 layout
local FM_MANEUVER2 = 2
local FM_YTARGET  = 3
local FM_MANEUVER = 4
local FM_ARM_IDX   = 5
local FM_ARM_VAL   = 6
local FM_MOTOR_IDX = 7
local FM_MOTOR_VAL = 8

-------------------------------------------------
-- PATH
-------------------------------------------------

local basePath = "/SCRIPTS/TOOLS/FlightProgress/"

-------------------------------------------------
-- SPLASH
-------------------------------------------------

local splashStart = getTime()
local splashBmp   = bitmap.open(basePath .. "fp1.png")
local SPLASH_TIME = 400

-------------------------------------------------
-- STATE
-------------------------------------------------

local page = 1           
local cursor  = 1
local hCursor = 1       
local planeScroll = 0

local message = ""
local loaded  = false

local motorIdx = 1
local motorVal = 1024
local armIdx   = 0
local armVal   = 1024

-- maneuver 1 digits 
local d1, d2, d3 = 0,0,0

-- maneuver 2 digits
local m21, m22, m23 = 0,0,0   

-- yearly target digits
local y1, y2, y3 = 0,0,0

-------------------------------------------------
-- HISTORY DIGITS
-------------------------------------------------

local hd = {0,0,0,0,0,0} -- date YYYYMM
local hf = {0,0,0,0}     -- flights
local ht = {0,0,0,0,0,0} -- duration
local hc = {0,0,0}       -- crashes
local hy = {0,0,0}       -- ytarget

-------------------------------------------------
-- MAINTENANCE TYPE
-------------------------------------------------

local serviceTypes = {
  {code="F", name="Full Service"},
  {code="P", name="Part Service"},
  {code="I", name="Inspection Only"},
  {code="C", name="Crash Repair"}
}

local serviceTypeIndex = 1   -- default Full Service

-------------------------------------------------
-- HELPERS
-------------------------------------------------

local function digitsToNumber(t)
  local v = 0
  for i=1,#t do v = v*10 + t[i] end
  return v
end

local function getManeuver()
  return d1*100 + d2*10 + d3
end

local function getYTarget()
  return y1*100 + y2*10 + y3
end

local function setDigitsFromValue(v)
  d1 = math.floor(v/100)
  d2 = math.floor((v%100)/10)
  d3 = v%10
end

local function setYDigitsFromValue(v)
  y1 = math.floor(v/100)
  y2 = math.floor((v%100)/10)
  y3 = v%10
end

-------------------------------------------------
-- GLOBAL STORAGE
-------------------------------------------------

local function saveGV()

  model.setGlobalVariable(GV_INDEX, FM_YTARGET, getYTarget())
  model.setGlobalVariable(GV_INDEX, FM_MANEUVER, getManeuver())
  model.setGlobalVariable(GV_INDEX, FM_MANEUVER2, m21*100 + m22*10 + m23) 

  model.setGlobalVariable(GV_INDEX, FM_MOTOR_IDX, motorIdx)
  model.setGlobalVariable(GV_INDEX, FM_MOTOR_VAL, motorVal)

  if armIdx > 0 then
    model.setGlobalVariable(GV_INDEX, FM_ARM_IDX, armIdx)
    model.setGlobalVariable(GV_INDEX, FM_ARM_VAL, armVal)
  else
    model.setGlobalVariable(GV_INDEX, FM_ARM_IDX, 0)
    model.setGlobalVariable(GV_INDEX, FM_ARM_VAL, 0)
  end

  message = "Saved"
end


local function loadGV()

  setYDigitsFromValue(model.getGlobalVariable(GV_INDEX, FM_YTARGET) or 0)
  setDigitsFromValue(model.getGlobalVariable(GV_INDEX, FM_MANEUVER) or 0)
  
  local m2 = model.getGlobalVariable(GV_INDEX, FM_MANEUVER2) or 0
  m21 = math.floor(m2/100)
  m22 = math.floor((m2%100)/10)
  m23 = m2%10

  motorIdx = model.getGlobalVariable(GV_INDEX, FM_MOTOR_IDX) or motorIdx
  motorVal = model.getGlobalVariable(GV_INDEX, FM_MOTOR_VAL) or motorVal
  armIdx   = model.getGlobalVariable(GV_INDEX, FM_ARM_IDX) or 0
  armVal   = model.getGlobalVariable(GV_INDEX, FM_ARM_VAL) or 1024
end

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

-------------------------------------------------
-- MODEL FILES
-------------------------------------------------

local function createModelFile()

  local info = model.getInfo()
  if not info or not info.name then
    message = "No Model"
    return
  end

  local base = basePath .. info.name

  -------------------------------------------------
  -- SAME HEADER ALL FILES
  -------------------------------------------------

  local header =
  "ModelName,Date,StartTime,EndTime,Flight,TimeSeconds,Maneuver,Crash,YTarget,LineType,SrvType,SrvFltNbr\n"

  -------------------------------------------------
  -- File suffix list
  -------------------------------------------------

  local suffixes = {

    ".txt",
    "_S.txt",
    "_O.txt",
    "_M.txt"

  }

  -------------------------------------------------
  -- Create files if missing
  -------------------------------------------------
local created = 0

for _, suffix in ipairs(suffixes) do

  if suffix then

    local path = base .. suffix

    local fileCheck = io.open(path, "r")

    if fileCheck then

      io.close(fileCheck)

    else

      local fileCreate = io.open(path, "w")

      if fileCreate then
        io.write(fileCreate, header)
        io.close(fileCreate)
        created = created + 1
      end
    end
  end
end
-------------------------------------------------
-- Status message
-------------------------------------------------

if created > 0 then
  message = created .. " Files Created"
else
  message = "Files Already Exist"
end

end

-------------------------------------------------
-- APPEND HISTORY
-------------------------------------------------

local function appendHistory()

  local info = model.getInfo()
  if not info then return end

  local path = basePath .. info.name .. "_O.txt"

  local dateNum = digitsToNumber(hd)
  local year  = math.floor(dateNum/100)
  local month = dateNum%100

  local flights  = digitsToNumber(hf)
  local duration = digitsToNumber(ht)
  local crashes  = digitsToNumber(hc)
  local ytarget  = digitsToNumber(hy)

  local line = string.format(
    "%s,%04d-%02d-01,00:00:00,00:00:00,%d,%d,0,%d,%d,H,Z,0",
    info.name, year, month, flights, duration, crashes, ytarget
  )

  local fileHistory = io.open(path,"a")

  if fileHistory then
    io.write(fileHistory, line.."\n")
    io.close(fileHistory)
    message="History Saved"
  end

end

-------------------------------------------------
-- APPEND CRASH 
-------------------------------------------------

local function appendCrash()

  local info = model.getInfo()
  if not info then return end

  local path = basePath .. info.name .. "_O.txt"
  local t = nowTime()

  -- Read Maneuver globals
  local maneuver1 = tonumber(model.getGlobalVariable(GV_INDEX, FM_MANEUVER)) or 0
  local maneuver2 = tonumber(model.getGlobalVariable(GV_INDEX, FM_MANEUVER2)) or 0
  local yTarget   = tonumber(model.getGlobalVariable(GV_INDEX, FM_YTARGET)) or 0

  -- RS slider override 
  local slider = getValue("rs") or 0
  local maneuver

  if slider < 0 then
    maneuver = 0
  elseif slider < 50 then
    maneuver = maneuver2
  else
    maneuver = maneuver1
  end

-- Write crash line
local line = string.format("%s,%s,%s,%s,0,0,%d,1,%d,C,Z,0", info.name, nowDate(), t, t, maneuver, yTarget)

local fileCrash = io.open(path,"a")

if fileCrash then
  io.write(fileCrash, line.."\n")
  io.close(fileCrash)
  message="Crash Logged"
end

end

-------------------------------------------------
-- APPEND MAINTENANCE
-------------------------------------------------

local function appendMaintenance()

  local info = model.getInfo()
  if not info then return end

  local path = basePath .. info.name .. "_O.txt"
  local sumPath = basePath .. info.name .. "_S.txt"

  local t = nowTime()

  local srvCode = serviceTypes[serviceTypeIndex].code

  
  local totalFlights = 0

  local f = io.open(sumPath,"r")

  if f then

    local data = io.read(f, 1024*1024)

    io.close(f)

    if data then

      for line in string.gmatch(data,"([^\n]+)") do

        if not string.find(line,"ModelName",1,true) then

          local cols = {}

          for v in string.gmatch(line..",","([^,]*),") do
            cols[#cols+1] = v
          end

          local flights = tonumber(cols[5]) or 0

          totalFlights = totalFlights + flights

        end

      end

    end

  end

  local line = string.format(
  "%s,%s,%s,%s,0,0,0,0,%d,S,%s,%d",
  info.name, nowDate(), t, t, getYTarget(), srvCode, totalFlights
  )


local fileMaint = io.open(path,"a")

if fileMaint then
  io.write(fileMaint, line.."\n")
  io.close(fileMaint)
  message="Maintenance Logged"
end

end

local function updateWidgetData()

  local info = model.getInfo()
  if not info or not info.name then
    message = "No Model"
    return
  end

  local mainPath = basePath .. info.name .. ".txt"
  local sumPath  = basePath .. info.name .. "_S.txt"

  local yearFlights = {}
  local yearSeconds = {}
  local yearTarget = {}

  -------------------------------------------------
  -- READ MAIN FILE
  -------------------------------------------------

  local fileMain = io.open(mainPath, "r")

  if fileMain == nil then
    message = "No Main File"
    return
  end

  local data = io.read(fileMain, 1024 * 1024)

  io.close(fileMain)

  if data == nil then
    message = "Read Failed"
    return
  end

  for line in string.gmatch(data, "([^\n]+)") do

    local cols = {}

    for v in string.gmatch(line .. ",", "([^,]*),") do
      cols[#cols+1] = v
    end

    if cols[10] == "L" and tonumber(cols[5]) == 1 then

      local year = string.sub(cols[2],1,4)
      local secs = tonumber(cols[6]) or 0

      yearFlights[year] = (yearFlights[year] or 0) + 1
      yearSeconds[year] = (yearSeconds[year] or 0) + secs
      
      local target = tonumber(cols[9]) or 0
      yearTarget[year] = target

    end

  end

  -------------------------------------------------
  -- WRITE SUMMARY FILE
  -------------------------------------------------

  local today = nowDate()
  local thisYear = string.sub(today,1,4)
  local yTarget = getYTarget()

  local fileSum = io.open(sumPath,"w")

  if fileSum == nil then
    message = "Write Failed"
    return
  end

  io.write(fileSum,
    "ModelName,Date,StartTime,EndTime,Flight,TimeSeconds,Maneuver,Crash,YTarget,LineType,SrvType,SrvFltNbr\n"
  )

  local years = {}

  for y in pairs(yearFlights) do
    years[#years+1] = y
  end

  table.sort(years)

  for i=1,#years do

    local year = years[i]
    local flights = yearFlights[year]
    local secs = yearSeconds[year] or 0

    local date

    if year == thisYear then
      date = today
    else
      date = year .. "-12-31"
    end

    local finalTarget
    if year == thisYear then
      finalTarget = yTarget
    else
     finalTarget = yearTarget[year] or 0
    end

    local outLine = string.format(
      "%s,%s,00:00:00,00:00:00,%d,%d,0,0,%d,L,Z,0\n",
      info.name,
      date,
      flights,
      secs,
      finalTarget
    )

    io.write(fileSum, outLine)

  end

  io.close(fileSum)

-------------------------------------------------
-- WRITE MANEUVER SUMMARY FILE (_M)
-------------------------------------------------

local manPath = basePath .. info.name .. "_M.txt"

local manFlights = {}
local manSeconds = {}
local manLastDate = {}
local manTarget = {}

-------------------------------------------------
-- READ MAIN FILE AGAIN
-------------------------------------------------

for line in string.gmatch(data, "([^\n]+)") do

  local cols = {}

  for v in string.gmatch(line .. ",", "([^,]*),") do
    cols[#cols+1] = v
  end

  if cols[10] == "L" then

    local date = cols[2]
    local year = string.sub(date,1,4)
    local maneuver = tonumber(cols[7]) or 0

    if maneuver > 0 then

      local key = year .. "_" .. maneuver

      local flights = tonumber(cols[5]) or 0
      local secs    = tonumber(cols[6]) or 0
      local target  = tonumber(cols[9]) or 0

      manFlights[key] = (manFlights[key] or 0) + flights
      manSeconds[key] = (manSeconds[key] or 0) + secs
      manTarget[key]  = target

      if not manLastDate[key] or date > manLastDate[key] then
        manLastDate[key] = date
      end

    end
  end
end

-------------------------------------------------
-- WRITE FILE
-------------------------------------------------

local fileMan = io.open(manPath,"w")

if fileMan == nil then
  message = "M File Write Failed"
  return
end

io.write(fileMan,
"ModelName,Date,StartTime,EndTime,Flight,TimeSeconds,Maneuver,Crash,YTarget,LineType,SrvType,SrvFltNbr\n"
)

local keys = {}

for k in pairs(manFlights) do
  keys[#keys+1] = k
end

table.sort(keys)

for i=1,#keys do

  local key = keys[i]

  local year, maneuver =
    string.match(key,"(%d+)_([^_]+)")

  local line = string.format(
  "%s,%s,00:00:00,00:00:00,%d,%d,%d,0,%d,L,Z,0\n",
  info.name,
  manLastDate[key],
  manFlights[key],
  manSeconds[key],
  tonumber(maneuver),
  manTarget[key] or 0
  )

  io.write(fileMan,line)

end

io.close(fileMan)

  message = "Summary Data Updated"

end

-------------------------------------------------
-- DRAW
-------------------------------------------------

local function drawRow(y,label,value,sel)
  lcd.drawText(40,y,label)
  lcd.drawText(320,y,tostring(value), sel and INVERS or 0)
end

local function drawDigitsRow(y,label,t,selStart)
  lcd.drawText(40,y,label)
  local x=320
  for i=1,#t do
    lcd.drawText(x+(i-1)*12,y,tostring(t[i]), hCursor==(selStart+i-1) and INVERS or 0)
  end
end

-------------------------------------------------
-- MAIN
-------------------------------------------------

local function run(event)

  if splashBmp and (getTime() - splashStart < SPLASH_TIME) then
    lcd.clear()
    lcd.drawBitmap(splashBmp,0,0)
    return 0
  end

  if not loaded then
    loadGV()
    loaded = true
  end

  lcd.clear()

  -------------------------------------------------
  -- PAGE 1 : SETUP
  -------------------------------------------------
  if page==1 then

  lcd.drawText(LCD_W/2,15,"Model Setup",DBLSIZE + CENTER)
  lcd.drawLine(10, 55, LCD_W-10, 55, SOLID, 0)

  local y=65
  local s=22

  drawRow(y+s*0,"Motor Switch", switches[motorIdx], cursor==1)
  drawRow(y+s*1,"Motor Value",  motorVal, cursor==2)

  drawRow(y+s*2,"Arm Switch", armIdx==0 and "DISABLED" or switches[armIdx], cursor==3)
  drawRow(y+s*3,"Arm Value", armVal, cursor==4)

  drawRow(y+s*4,"Create File","ENTER", cursor==5)
  drawRow(y+s*5,"Update Summary Data","ENTER", cursor==6)
  drawRow(y+s*7,"Next Page","ENTER", cursor==7)

  lcd.drawText(40,250,message,SMLSIZE)

  -- Page indicator
  lcd.drawText(LCD_W-70, 250, "Page 1/6", SMLSIZE)

  -------------------------------------------------

  if event==EVT_VIRTUAL_NEXT then cursor=cursor%7+1 end
  if event==EVT_VIRTUAL_PREV then cursor=(cursor-2)%7+1 end

  if event==EVT_VIRTUAL_ENTER then
    if cursor==5 then createModelFile()
    elseif cursor==6 then updateWidgetData()
    elseif cursor==7 then page=2; cursor=1; return 0

    elseif cursor==1 then motorIdx=motorIdx%#switches+1; saveGV()
    elseif cursor==2 then motorVal=(motorVal==1024 and -1024 or 1024); saveGV()
    elseif cursor==3 then armIdx=(armIdx+1)%(#switches+1); saveGV()
    elseif cursor==4 then armVal=(armVal==1024 and -1024 or 1024); saveGV()
    end
  end
end

-------------------------------------------------
-- PAGE 2 : FLYING SETUP
-------------------------------------------------
if page==2 then

  lcd.drawText(LCD_W/2,15,"Flying Setup",DBLSIZE + CENTER)
  lcd.drawLine(10, 55, LCD_W-10, 55, SOLID, 0)

  local y=65
  local s=22
  local x=320

  -------------------------------------------------
  -- Maneuver 1
  -------------------------------------------------
  lcd.drawText(40,y+s*0,"Maneuver 1")
  lcd.drawText(x,     y+s*0, tostring(d1), cursor==1 and INVERS or 0)
  lcd.drawText(x+12,  y+s*0, tostring(d2), cursor==2 and INVERS or 0)
  lcd.drawText(x+24,  y+s*0, tostring(d3), cursor==3 and INVERS or 0)

  -------------------------------------------------
  -- Maneuver 2
  -------------------------------------------------
  lcd.drawText(40,y+s*1,"Maneuver 2")
  lcd.drawText(x,     y+s*1, tostring(m21), cursor==4 and INVERS or 0)
  lcd.drawText(x+12,  y+s*1, tostring(m22), cursor==5 and INVERS or 0)
  lcd.drawText(x+24,  y+s*1, tostring(m23), cursor==6 and INVERS or 0)

  -------------------------------------------------
  -- Yearly Target
  -------------------------------------------------
  lcd.drawText(40,y+s*2,"Yearly Flight Target")
  lcd.drawText(x,     y+s*2, tostring(y1), cursor==7 and INVERS or 0)
  lcd.drawText(x+12,  y+s*2, tostring(y2), cursor==8 and INVERS or 0)
  lcd.drawText(x+24,  y+s*2, tostring(y3), cursor==9 and INVERS or 0)

  -------------------------------------------------
  drawRow(y+s*4,"Previous Page","ENTER", cursor==10)
  drawRow(y+s*5,"Next Page","ENTER", cursor==11)

  -- Page indicator
  lcd.drawText(40,250,message,SMLSIZE)
  lcd.drawText(LCD_W-70, 250, "Page 2/6", SMLSIZE)

  -------------------------------------------------

  if event==EVT_VIRTUAL_NEXT then cursor=cursor%11+1 end
  if event==EVT_VIRTUAL_PREV then cursor=(cursor-2)%11+1 end

  if event==EVT_VIRTUAL_ENTER then

    if cursor<=3 then
      if cursor==1 then d1=(d1+1)%10 end
      if cursor==2 then d2=(d2+1)%10 end
      if cursor==3 then d3=(d3+1)%10 end
      saveGV()

    elseif cursor<=6 then
      if cursor==4 then m21=(m21+1)%10 end
      if cursor==5 then m22=(m22+1)%10 end
      if cursor==6 then m23=(m23+1)%10 end
      saveGV()

    elseif cursor<=9 then
      if cursor==7 then y1=(y1+1)%10 end
      if cursor==8 then y2=(y2+1)%10 end
      if cursor==9 then y3=(y3+1)%10 end
      saveGV()

    elseif cursor==10 then
      page=1; cursor=1

    elseif cursor==11 then
      page=3; hCursor=1; return 0
    end
  end
end

  -------------------------------------------------
  -- PAGE 3 : LOGGING PAGE
  -------------------------------------------------
  if page==3 then

  lcd.drawText(LCD_W/2,15,"Flight Logging",DBLSIZE + CENTER)
  lcd.drawLine(10, 55, LCD_W-10, 55, SOLID, 0)

  local y=65
  local s=22

  drawRow(y+s*0,"Log Crash","ENTER", cursor==1)
  drawRow(y+s*1,"Maintenance Type", serviceTypes[serviceTypeIndex].name, cursor==2)
  drawRow(y+s*2,"Log Maintenance","ENTER", cursor==3)
  drawRow(y+s*4,"Previous Page","ENTER", cursor==4)
  drawRow(y+s*5,"Next Page","ENTER", cursor==5)

  lcd.drawText(40,250,message,SMLSIZE)
  lcd.drawText(LCD_W-70,250,"Page 3/6",SMLSIZE)

  -------------------------------------------------

  if event==EVT_VIRTUAL_NEXT then cursor=cursor%5+1 end
  if event==EVT_VIRTUAL_PREV then cursor=(cursor-2)%5+1 end
  if event==EVT_VIRTUAL_ENTER then

    if cursor==1 then
      appendCrash()
    elseif cursor==2 then
      serviceTypeIndex = serviceTypeIndex % #serviceTypes + 1
    elseif cursor==3 then
      appendMaintenance()
    
    elseif cursor==4 then
      page=2
      cursor=1
    elseif cursor==5 then
      page=4
      hCursor=1
      return 0
    end
  end
end


  -------------------------------------------------
  -- PAGE 4 : HISTORY PAGE
  -------------------------------------------------

  if page==4 then

  lcd.drawText(LCD_W/2,15,"History Entry",DBLSIZE + CENTER)
  lcd.drawLine(10, 55, LCD_W-10, 55, SOLID, 0)

  local y=65
  local s=20

  drawDigitsRow(y+s*0,"Date YYYYMM",hd,1)
  drawDigitsRow(y+s*1,"Flights",hf,7)
  drawDigitsRow(y+s*2,"Duration (Seconds)",ht,11)
  drawDigitsRow(y+s*3,"Crashes",hc,17)
  drawDigitsRow(y+s*4,"Yearly Target",hy,20)

  drawRow(y+s*5,"Save","ENTER", hCursor==23)
  drawRow(y+s*6,"Previous Page","ENTER", hCursor==24)
  drawRow(y+s*7,"Next Page","ENTER", hCursor==25)

  -- Page indicator
  lcd.drawText(40,250,message,SMLSIZE)
  lcd.drawText(LCD_W-70, 250, "Page 4/6", SMLSIZE)

  -------------------------------------------------

  if event==EVT_VIRTUAL_NEXT then hCursor=hCursor%25+1 end
  if event==EVT_VIRTUAL_PREV then hCursor=(hCursor-2)%25+1 end

  if event==EVT_VIRTUAL_ENTER then
    if hCursor<=6 then hd[hCursor]=(hd[hCursor]+1)%10
    elseif hCursor<=10 then hf[hCursor-6]=(hf[hCursor-6]+1)%10
    elseif hCursor<=16 then ht[hCursor-10]=(ht[hCursor-10]+1)%10
    elseif hCursor<=19 then hc[hCursor-16]=(hc[hCursor-16]+1)%10
    elseif hCursor<=22 then hy[hCursor-19]=(hy[hCursor-19]+1)%10

    elseif hCursor==23 then appendHistory()
    elseif hCursor==24 then page=3; cursor=1
    elseif hCursor==25 then page=5; cursor=1; hCursor=1; return 0
    end
  end
end

-------------------------------------------------
-- PAGE 5 - PLANE MANEUVER LIST
-------------------------------------------------
if page==5 then

  lcd.drawText(LCD_W/2,15,"Plane Maneuver List",DBLSIZE + CENTER)
  lcd.drawLine(10, 55, LCD_W-10, 55, SOLID, 0)

  local list = {
  "300-Straight & Level","301-Left Turn","302-Right Turn","303-Rectangular Circuit","304-Figure Eight","305-Low Pass",
  "306-Stall Turn","307-Taking Off","308-Landing","309-Touch & Go","310-Crosswind Landing","311-Slow Flight",
  "312-Taxi Practice","313-Loop","314-Half Loop","315-Outside Loop","316-Aileron Roll","317-Slow Aileron Roll (Left)",
  "318-Slow Aileron Roll (Right)","319-Barrel Roll","320-Cuban Eight","321-Reverse Cuban Eight","322-Immelmann","323-Split S",
  "324-Vertical Upline","325-Vertical Downline","326-Hammerhead","327-Four Point Roll","328-Eight Point Roll","329-Hesitation Roll",
  "330-Knife Edge Pass","331-Knife Edge Circle","332-Knife Edge Figure Eight","333-Inverted Flight","334-Inverted Loop","335-Rolling Circle (Left)",
  "336-Rolling Circle (Right)","337-Rolling Figure Eight","338-Rolling Loop","339-Positive Snap Roll","340-Negative Snap Roll","341-Upright Flat Spin",
  "342-Inverted Flat Spin","343-Spiral Dive","344-Square Loop","345-Triangle Loop","346-Avalanche","347-Continues Roll (Left)",
  "348-Continues Roll (Right)","349-Knife Loop","350-Inverted Climb","351-Inverted Descent","352-Harrier","353-Parachute",
  "354-Hover","355-Inverted Hover","356-Torque Roll","357-Waterfall","358-Pop Top","359-Wall",
  "360-Blender","361-Inverted Harrier","362-Rolling Harrier (Left)","363-Rolling Harrier (Right)","364-Inverted Harrier to Hover","365-Fast Torque Roll",
  "366-Slow Torque Roll","367-High Alpha Knife Edge","368-Knife Edge Spin","369-Blender","370-Snap to Hover","371-Snap to Knife Edge",
  "372-Harrier Landing","373-Full Routine Practice","374-BMFA Fixed Wing A Cert","375-BMFA Fixed Wing B Cert",
  }

  local rows = 10        
  local y = 70
  local s = 17

  planeScroll = planeScroll or 1

  -------------------------------------------------
  -- draw visible slice
  -------------------------------------------------
  for i=0,rows-1 do
    local idx = planeScroll + i
    if list[idx] then
      lcd.drawText(40, y + i*s, list[idx], SMLSIZE)
    end
  end

  -------------------------------------------------
  -- buttons (bottom)
  -------------------------------------------------
  drawRow(245,"Next Page","ENTER", cursor==1)

  lcd.drawText(LCD_W-70, 250, "Page 5/6", SMLSIZE)

  -------------------------------------------------
  -- navigation
  -------------------------------------------------

  if event==EVT_VIRTUAL_NEXT then
    if planeScroll < (#list - rows + 1) then
      planeScroll = planeScroll + 1
    end
  end

  if event==EVT_VIRTUAL_PREV then
    if planeScroll > 1 then
      planeScroll = planeScroll - 1
    end
  end

  if event==EVT_VIRTUAL_ENTER then
    page = 6
    cursor = 1
    return 0
  end

 end

  -------------------------------------------------
  -- PAGE 6 - HELI MANEUVER LIST
  -------------------------------------------------
  if page==6 then

  lcd.drawText(LCD_W/2,15,"Helicopter Maneuver List",DBLSIZE + CENTER)
  lcd.drawLine(10, 55, LCD_W-10, 55, SOLID, 0)

  local list = {
  "1-Tail In Hover","2-Nose In Hover","3-Side Hover (Left)","4-Side Hover (Right)","5-Fast Piro Hover","6-Slow Piro Hover",
  "7-Orientation Drills","8-Forward Flight","9-Figure Eight","10-Sideways Flight (Left)","11-Sideways Flight (Right)","12-Backward Flight",
  "13-Inverted Flight","14-Inverted Tail In Hover","15-Inverted Nose In Hover","16-Inverted Side Hover","17-Inverted Fast Piro","18-Inverted Slow Piro",
  "19-Inverted Orientation Drills","20-Inverted Sideways Flight","21-Inverted Backward Flight","22-Loop","23-Outside Loop","24-Roll",
  "25-Continuous Rolls","26-Rolling Circles","27-Backward Rolls","28-Backward Rolling Circles","29-Stall Turn","30-Controlled Front Flip",
  "31-Controlled Backflips","32-Rainbow","33-Rainbow Nose Down","34-Wall","35-Upright Funnel","36-Upright Tail Funnel",
  "37-Inverted Funnel","38-Inverted Nose Funnel","39-Hurricane","40-Inverted Hurricane","41-TicToc (Elevator)","42-TicToc (Aileron)",
  "43-Big Air TicToc","44-Piro Circle","45-Piro Funnel","46-Piro Flip","47-Piro Loop","48-Piro Rainbow",
  "49-Piro Hurricane","50-Piro Tic Toc","51-Chaos","52-Snake","53-Tail Slide","54-Smack Flip",
  "55-Grass Skim","56-Speed Run","57-Autorotation","58-Inverted Auto","59-Roll Auto","60-Loop Auto",
  "61-Touch & Go","62-Flip to Funnel","63-Funnel to Piro","64-Traveling TicToc","65-Piro TicToc","66-Four Point TicToc",
  "67-Eight Point TicToc","68-Pitch Pump","69-Inverted TicToc","70-Flipping Loop","71-Square Loop","72-Backwards Loop",
  "73-Backwards Square Loop","74-Full Heli Routine","75-BMFA Heli A Cert","76-BMFA Heli B Cert", "77-Sideways Loop Nose-In (L)",
  "78-Sideways Loop Nose-In (R)","79-Sideways Loop Tail-In (L)","80-Sideways Loop Tail-In (R)"
  } 

  local rows = 10
  local y = 70
  local s = 17

  heliScroll = heliScroll or 1

  -------------------------------------------------
  -- draw visible slice
  -------------------------------------------------
  for i=0,rows-1 do
    local idx = heliScroll + i
    if list[idx] then
      lcd.drawText(40, y + i*s, list[idx], SMLSIZE)
    end
  end

  if #list == 0 then
    lcd.drawText(40, y, "List coming soon...", SMLSIZE)
  end

  -------------------------------------------------
  -- button
  -------------------------------------------------
  drawRow(245,"Next Page","ENTER", true)

  lcd.drawText(LCD_W-70, 250, "Page 6/6", SMLSIZE)

  -------------------------------------------------
  -- scrolling (future ready)
  -------------------------------------------------
  if event==EVT_VIRTUAL_NEXT then
    if heliScroll < (#list - rows + 1) then
      heliScroll = heliScroll + 1
    end
  end

  if event==EVT_VIRTUAL_PREV then
    if heliScroll > 1 then
      heliScroll = heliScroll - 1
    end
  end

  -------------------------------------------------
  -- next page
  -------------------------------------------------
  if event==EVT_VIRTUAL_ENTER then
    page = 1
    cursor = 1
    return 0
  end

end
 
  return 0
end

return { run=run }
