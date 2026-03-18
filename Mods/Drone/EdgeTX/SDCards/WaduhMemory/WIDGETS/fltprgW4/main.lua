---------------------------------------------------------------------------
-- FlightProgress Maneuver Progress
---------------------------------------------------------------------------

local name = "fltprgW4"

---------------------------------------------------------------------------
-- OPTIONS
---------------------------------------------------------------------------

local options = {
  { "Year", STRING, "" }
}

---------------------------------------------------------------------------
-- MANEUVER NAMES
---------------------------------------------------------------------------

local maneuverNames = {
[1] = "Tail In Hover",
[2] = "Nose In Hover",
[3] = "Side Hover (Left)",
[4] = "Side Hover (Right)",
[5] = "Fast Piro Hover",
[6] = "Slow Piro Hover",
[7] = "Orientation Drills",
[8] = "Forward Flight",
[9] = "Figure Eight",
[10] = "Sideways Flight (Left)",
[11] = "Sideways Flight (Right)",
[12] = "Backward Flight",
[13] = "Inverted Flight",
[14] = "Inverted Tail In Hover",
[15] = "Inverted Nose In Hover",
[16] = "Inverted Side Hover",
[17] = "Inverted Fast Piro",
[18] = "Inverted Slow Piro",
[19] = "Inverted Orientation Drills",
[20] = "Inverted Sideways Flight",
[21] = "Inverted Backward Flight",
[22] = "Loop",
[23] = "Outside Loop",
[24] = "Roll",
[25] = "Continuous Rolls",
[26] = "Rolling Circles",
[27] = "Backward Rolls",
[28] = "Backward Rolling Circles",
[29] = "Stall Turn",
[30] = "Controlled Front Flip",
[31] = "Controlled Backflips",
[32] = "Rainbow",
[33] = "Rainbow Nose Down",
[34] = "Wall",
[35] = "Upright Funnel",
[36] = "Upright Tail Funnel",
[37] = "Inverted Funnel",
[38] = "Inverted Nose Funnel",
[39] = "Hurricane",
[40] = "Inverted Hurricane",
[41] = "TicToc (Elevator)",
[42] = "TicToc (Aileron)",
[43] = "Big Air TicToc",
[44] = "Piro Circle",
[45] = "Piro Funnel",
[46] = "Piro Flip",
[47] = "Piro Loop",
[48] = "Piro Rainbow",
[49] = "Piro Hurricane",
[50] = "Piro Tic Toc",
[51] = "Chaos",
[52] = "Snake",
[53] = "Tail Slide",
[54] = "Smack Flip",
[55] = "Grass Skim",
[56] = "Speed Run",
[57] = "Autorotation",
[58] = "Inverted Auto",
[59] = "Roll Auto",
[60] = "Loop Auto",
[61] = "Touch & Go",
[62] = "Flip to Funnel",
[63] = "Funnel to Piro",
[64] = "Traveling TicToc",
[65] = "Piro TicToc",
[66] = "Four Point TicToc",
[67] = "Eight Point TicToc",
[68] = "Pitch Pump",
[69] = "Inverted TicToc",
[70] = "Flipping Loop",
[71] = "Square Loop",
[72] = "Backwards Loop",
[73] = "Backwards Square Loop",
[74] = "Full Heli Routine",
[75] = "BMFA Heli A Cert",
[76] = "BMFA Heli B Cert",
[77] = "Sideways Loop Nose-In (L)",
[78] = "Sideways Loop Nose-In (R)",
[79] = "Sideways Loop Tail-In (L)",
[80] = "Sideways Loop Tail-In (R)",
[300] = "Straight & Level",
[301] = "Left Turn",
[302] = "Right Turn",
[303] = "Rectangular Circuit",
[304] = "Figure Eight",
[305] = "Low Pass",
[306] = "Stall Turn",
[307] = "Taking Off",
[308] = "Landing",
[309] = "Touch & Go",
[310] = "Crosswind Landing",
[311] = "Slow Flight",
[312] = "Taxi Practice",
[313] = "Loop",
[314] = "Half Loop",
[315] = "Outside Loop",
[316] = "Aileron Roll",
[317] = "Slow Aileron Roll (Left)",
[318] = "Slow Aileron Roll (Right)",
[319] = "Barrel Roll",
[320] = "Cuban Eight",
[321] = "Reverse Cuban Eight",
[322] = "Immelmann",
[323] = "Split S",
[324] = "Vertical Upline",
[325] = "Vertical Downline",
[326] = "Hammerhead",
[327] = "Four Point Roll",
[328] = "Eight Point Roll",
[329] = "Hesitation Roll",
[330] = "Knife Edge Pass",
[331] = "Knife Edge Circle",
[332] = "Knife Edge Figure Eight",
[333] = "Inverted Flight",
[334] = "Inverted Loop",
[335] = "Rolling Circle (Left)",
[336] = "Rolling Circle (Right)",
[337] = "Rolling Figure Eight",
[338] = "Rolling Loop",
[339] = "Positive Snap Roll",
[340] = "Negative Snap Roll",
[341] = "Upright Flat Spin",
[342] = "Inverted Flat Spin",
[343] = "Spiral Dive",
[344] = "Square Loop",
[345] = "Triangle Loop",
[346] = "Avalanche",
[347] = "Continues Roll (Left)",
[348] = "Continues Roll (Right)",
[349] = "Knife Loop",
[350] = "Inverted Climb",
[351] = "Inverted Descent",
[352] = "Harrier",
[353] = "Parachute",
[354] = "Hover",
[355] = "Inverted Hover",
[356] = "Torque Roll",
[357] = "Waterfall",
[358] = "Pop Top",
[359] = "Wall",
[360] = "Blender",
[361] = "Inverted Harrier",
[362] = "Rolling Harrier (Left)",
[363] = "Rolling Harrier (Right)",
[364] = "Inverted Harrier to Hover",
[365] = "Fast Torque Roll",
[366] = "Slow Torque Roll",
[367] = "High Alpha Knife Edge",
[368] = "Knife Edge Spin",
[369] = "Blender",
[370] = "Snap to Hover",
[371] = "Snap to Knife Edge",
[372] = "Harrier Landing",
[373] = "Full Routine Practice",
[374] = "BMFA Fixed Wing A Cert",
[375] = "BMFA Fixed Wing B Cert",
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

    maneuvers = {},   
    list = {},        
    totalManeuverFlights = 0,
    totalFlights = 0,


    file = nil,
    buffer = "",
    done = false
  }

  rebuild(w)

  return w
end

---------------------------------------------------------------------------
-- REBUILD
---------------------------------------------------------------------------

rebuild = function(widget)

  widget.maneuvers = {}
  widget.list = {}
  widget.totalManeuverFlights = 0
  widget.totalFlights = 0

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

    local path =
      "/SCRIPTS/TOOLS/FlightProgress/"
      .. info.name ..
      ".txt"

    widget.file = io.open(path,"r")
  end
end

---------------------------------------------------------------------------
-- UPDATE
---------------------------------------------------------------------------

local function update(widget,opts)

  local old = widget.filterYear

  widget.options = opts

  local raw = opts["Year"]

  widget.filterYear = nil

  if raw and raw ~= "" then
    widget.filterYear =
      tonumber(string.match(raw,"%d%d%d%d"))
  end

  if old ~= widget.filterYear then
    rebuild(widget)
  end
end

---------------------------------------------------------------------------
-- PROCESS STREAM
---------------------------------------------------------------------------
local function process(widget)

if widget.done then return end

local info = model.getInfo()
if not info then return end

local base = "/SCRIPTS/TOOLS/FlightProgress/" .. info.name

local pathM = base .. "_M.txt"
local pathS = base .. "_S.txt"
local pathO = base .. "_O.txt"

local function readFile(path, handler)

  local f = io.open(path,"r")
  if not f then return end

  local data = io.read(f,1024*1024)
  io.close(f)

  if not data then return end

  for line in string.gmatch(data,"([^\n]+)") do

    if not string.find(line,"ModelName",1,true) then

      local cols={}

      for v in string.gmatch(line..",","([^,]*),") do
        cols[#cols+1]=v
      end

      handler(cols)

    end
  end
end

---------------------------------------------------
-- READ _M
---------------------------------------------------

readFile(pathM,function(cols)

  local flights = tonumber(cols[5]) or 0
  local secs = tonumber(cols[6]) or 0
  local maneuver = tonumber(cols[7]) or 0
  local date = cols[2]
  local year = tonumber(string.sub(date,1,4))

  if maneuver>0 and
  (widget.filterYear==nil or year==widget.filterYear)
  then

    local m = widget.maneuvers[maneuver]

    if not m then

      m={
      id=maneuver,
      name=maneuver.." - "..(maneuverNames[maneuver] or ""),
      count=0,
      secs=0,
      crashes=0,
      lastDate=date
      }

      widget.maneuvers[maneuver]=m

    end

    m.count = m.count + flights
    m.secs = m.secs + secs

    if date > m.lastDate then
      m.lastDate=date
    end

    widget.totalManeuverFlights =
    widget.totalManeuverFlights + flights

  end

end)

---------------------------------------------------
-- READ _S
---------------------------------------------------

readFile(pathS,function(cols)

  local flights = tonumber(cols[5]) or 0
  local secs = tonumber(cols[6]) or 0
  local maneuver = tonumber(cols[7]) or 0
  local date = cols[2]
  local year = tonumber(string.sub(date,1,4))

  if widget.filterYear==nil or year==widget.filterYear then
    widget.totalFlights =
    widget.totalFlights + flights
  end

  if maneuver>0 and
  (widget.filterYear==nil or year==widget.filterYear)
  then

    local m = widget.maneuvers[maneuver]

    if not m then

      m={
      id=maneuver,
      name=maneuver.." - "..(maneuverNames[maneuver] or ""),
      count=0,
      secs=0,
      crashes=0,
      lastDate=date
      }

      widget.maneuvers[maneuver]=m

    end

    m.count = m.count + flights
    m.secs = m.secs + secs

    if date > m.lastDate then
      m.lastDate=date
    end

    widget.totalManeuverFlights =
    widget.totalManeuverFlights + flights

  end

end)

---------------------------------------------------
-- READ _O  (CRASHES + HISTORY FLIGHTS)
---------------------------------------------------

readFile(pathO,function(cols)

  local flights = tonumber(cols[5]) or 0
  local maneuver = tonumber(cols[7]) or 0
  local crash = cols[10]
  local date = cols[2]
  local year = tonumber(string.sub(date,1,4))

  -------------------------------------------------
  -- HISTORY FLIGHTS
  -------------------------------------------------

  if cols[10]=="H" then

    if widget.filterYear==nil or year==widget.filterYear then

      widget.totalFlights =
      widget.totalFlights + flights

    end

  end

  -------------------------------------------------
  -- CRASHES
  -------------------------------------------------

  if cols[10]=="C" and maneuver>0 and
  (widget.filterYear==nil or year==widget.filterYear)
  then

    local m = widget.maneuvers[maneuver]

    if not m then

      m={
      id=maneuver,
      name=maneuver.." - "..(maneuverNames[maneuver] or ""),
      count=0,
      secs=0,
      crashes=0,
      lastDate=date
      }

      widget.maneuvers[maneuver]=m

    end

    m.crashes = m.crashes + 1

  end

end)

---------------------------------------------------
-- BUILD SORTED LIST
---------------------------------------------------

for id,data in pairs(widget.maneuvers) do

  widget.list[#widget.list+1]=data

end

table.sort(widget.list,function(a,b)
return a.lastDate > b.lastDate
end)

widget.done=true

end

---------------------------------------------------------------------------
-- REFRESH
---------------------------------------------------------------------------

local function refresh(widget)

  local z=widget.zone

  lcd.drawFilledRectangle(z.x,z.y,z.w,z.h,BLACK)

  --lcd.drawText(z.x+z.w/2,z.y+8,(model.getInfo().name or "MODEL").." MANEUVERS",CENTER + DBLSIZE + WHITE)
  lcd.drawText(z.x+z.w/2,z.y+8,"MANEUVERS TRACKER",CENTER + DBLSIZE + WHITE)

  local subtitle

  if widget.filterYear==nil then
    subtitle="Lifetime Total"
  else
    subtitle=tostring(widget.filterYear)
  end

  lcd.drawText(z.x+z.w/2, z.y+40, subtitle, CENTER + SMLSIZE + BOLD + WHITE)

  process(widget)

  ---------------------------------------------------
  -- TABLE
  ---------------------------------------------------

  local left=z.x+10

  local colName=left
  local colCount=left+220
  local colHours=left+270
  local colCrash=left+320
  local colDate=left+380

  local y=z.y+70

  local step=18

  lcd.drawText(colName,y,"Maneuver",SMLSIZE+YELLOW)
  lcd.drawText(colCount,y,"Count",SMLSIZE+YELLOW)
  lcd.drawText(colHours,y,"Hours",SMLSIZE+YELLOW)
  lcd.drawText(colCrash,y,"Crashes",SMLSIZE+YELLOW)
  lcd.drawText(colDate,y,"Last Date",SMLSIZE+YELLOW)

  y=y+step

  local max=8

  for i=1,
    math.min(max,#widget.list)
  do

    local m=widget.list[i]

    lcd.drawText(colName, y, m.name, SMLSIZE+WHITE)
    lcd.drawText(colCount, y, m.count, SMLSIZE+WHITE)
    lcd.drawText(colHours, y, string.format("%.1f", m.secs/3600), SMLSIZE+WHITE)
    lcd.drawText(colCrash, y, m.crashes, SMLSIZE+WHITE)
    lcd.drawText(colDate, y, string.sub(m.lastDate,1,10), SMLSIZE+WHITE)

    y=y+step
  end

  ---------------------------------------------------
  -- PRACTICE %
  ---------------------------------------------------

  local percent = 0

  if widget.totalFlights > 0 then
    percent =
      (widget.totalManeuverFlights / widget.totalFlights) * 100
  end

  local text =
    "Total Maneuvers: "..widget.totalManeuverFlights..
    "   Total Flights: "..widget.totalFlights..
    "   Practice %: "..string.format("%.1f%%", percent)

  lcd.drawText(z.x + z.w/2, z.y + z.h - 18, text, CENTER + SMLSIZE + YELLOW)

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
