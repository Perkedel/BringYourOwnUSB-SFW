---------------------------------------------------------------------------
-- FlightProgress YEAR STATS WIDGET
---------------------------------------------------------------------------

local name = "fltprgW1"

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


local options = {
  { "Additional Year", STRING, "" }
}

---------------------------------------------------------------------------
-- CREATE
---------------------------------------------------------------------------

local function create(zone, opts)
  local now = getDateTime()
  local info = model.getInfo()

  local w = {
    zone = zone,
    options = opts or {},

    thisYear = now.year,
    lastYear = now.year - 1,
    extraYear = nil,
    maneuverSet = {},
    maneuverCount = 0,

    -- Totals
    tFlights = 0, tSeconds = 0, tCrashes = 0, tServices = 0,
    yFlights = 0, ySeconds = 0, yCrashes = 0, yTarget = 0, yServices = 0,
    pFlights = 0, pSeconds = 0, pCrashes = 0, pTarget = 0, pServices = 0,
    

    -- per year table
    yearStats = {},

    fileS = nil,
    fileO = nil,
    bufferS = "",
    bufferO = "",

    fileMain = nil,
    bufferMain = "",
    lastFlightDate = "",
    doneMain = false

  }

  if info then
    local base = "/SCRIPTS/TOOLS/FlightProgress/" .. info.name

    w.fileS = io.open(base .. "_S.txt", "r")
    w.fileO = io.open(base .. "_O.txt", "r")
    w.fileMain = io.open(base .. ".txt", "r")
  end

  return w
end

---------------------------------------------------------------------------
-- UPDATE
---------------------------------------------------------------------------

local function update(widget, opts)
  widget.options = opts

  local raw = opts["Additional Year"]

  if raw and raw ~= "" then
    widget.extraYear = tonumber(string.match(raw, "%d%d%d%d"))
  else
    widget.extraYear = nil
  end
end

---------------------------------------------------------------------------
-- REFRESH
---------------------------------------------------------------------------

local function refresh(widget)

  local z = widget.zone
  local extraYear = widget.extraYear
  local gvIndex = 5
  local fm3 = 3

  widget.yTarget = model.getGlobalVariable(gvIndex, fm3) or 0

  lcd.drawFilledRectangle(z.x, z.y, z.w, z.h, BLACK)

  lcd.drawText(z.x + z.w/2, z.y + 8, (model.getInfo().name or "MODEL") .. " STATS", CENTER + DBLSIZE + WHITE)

  ------------------------------------------------------------------
  -- STREAM FILE (single pass)
  ------------------------------------------------------------------

  if widget.fileS then

    local chunk = io.read(widget.fileS, 128)

    if not chunk or chunk == "" then
      io.close(widget.fileS)
      widget.fileS = nil
      widget.bufferS = widget.bufferS .. "\n"
    else
      widget.bufferS = widget.bufferS .. chunk
    end

    while true do
      local s = string.find(widget.bufferS, "\n", 1, true)
      if not s then break end

      local line = string.sub(widget.bufferS, 1, s-1)
      widget.bufferS = string.sub(widget.bufferS, s+1)
      line = string.gsub(line, "\r", "")

      if line ~= "" and not string.find(line, "ModelName", 1, true) then

        local cols = {}
        for v in string.gmatch(line, "([^,]*)") do
          cols[#cols+1] = v
        end

        local flights = tonumber(cols[5]) or 0
        local secs    = tonumber(cols[6]) or 0
        local crash   = tonumber(cols[8]) or 0
        local target  = tonumber(cols[9]) or 0
        local year    = tonumber(string.match(cols[2] or "", "%d%d%d%d")) or 0
        local lineType = cols[10] or ""

        ----------------------------------------------------------
        -- TOTALS
        ----------------------------------------------------------

        widget.tFlights = widget.tFlights + flights
        widget.tSeconds = widget.tSeconds + secs
        widget.tCrashes = widget.tCrashes + crash

        ----------------------------------------------------------
        -- THIS / LAST YEAR
        ----------------------------------------------------------

        if year == widget.thisYear then
          widget.yFlights = widget.yFlights + flights
          widget.ySeconds = widget.ySeconds + secs
          widget.yCrashes = widget.yCrashes + crash
          
        end

        if year == widget.lastYear then
          widget.pFlights = widget.pFlights + flights
          widget.pSeconds = widget.pSeconds + secs
          widget.pCrashes = widget.pCrashes + crash
          widget.pTarget  = target
        end

        ----------------------------------------------------------
        -- MANEUVERS COUNT THIS YEAR
        ---------------------------------------------------------- 
        if year == widget.thisYear then

        local m = tonumber(cols[7])
        if m and m > 0 then
          widget.maneuverSet[m] = true
        end
        end
        ----------------------------------------------------------
        -- STORE PER YEAR
        ----------------------------------------------------------

        local ys = widget.yearStats[year]
        if not ys then
          ys = {f=0,s=0,c=0,t=0}
          widget.yearStats[year] = ys
        end

        ys.f = ys.f + flights
        ys.s = ys.s + secs
        ys.c = ys.c + crash
        ys.t = target
      end
    end
  end

 --------------------------------------------------
-- READ OPERATIONS FILE (_O)
--------------------------------------------------

if widget.fileO then

  local chunk = io.read(widget.fileO, 128)

  if not chunk or chunk == "" then
    io.close(widget.fileO)
    widget.fileO = nil
    widget.bufferO = widget.bufferO .. "\n"
  else
    widget.bufferO = widget.bufferO .. chunk
  end

  while true do

    local s = string.find(widget.bufferO, "\n", 1, true)
    if not s then break end

    local line = string.sub(widget.bufferO, 1, s-1)
    widget.bufferO = string.sub(widget.bufferO, s+1)

    line = string.gsub(line, "\r", "")

    if line ~= "" and not string.find(line, "ModelName", 1, true) then

      local cols = {}

      for v in string.gmatch(line, "([^,]*)") do
        cols[#cols+1] = v
      end

      local year = tonumber(string.match(cols[2] or "", "%d%d%d%d")) or 0
      local lineType = cols[10] or ""

      --------------------------------------------------
      -- HISTORY
      --------------------------------------------------

      if lineType == "H" then

        local flights = tonumber(cols[5]) or 0
        local secs    = tonumber(cols[6]) or 0
        local crash   = tonumber(cols[8]) or 0
        local target  = tonumber(cols[9]) or 0

        widget.tFlights = widget.tFlights + flights
        widget.tSeconds = widget.tSeconds + secs
        widget.tCrashes = widget.tCrashes + crash

        if year == widget.thisYear then
          widget.yFlights = widget.yFlights + flights
          widget.ySeconds = widget.ySeconds + secs
          widget.yCrashes = widget.yCrashes + crash 
          
        end

        if year == widget.lastYear then
          widget.pFlights = widget.pFlights + flights
          widget.pSeconds = widget.pSeconds + secs
          widget.pCrashes = widget.pCrashes + crash
          widget.pTarget  = target
        end

      end

      --------------------------------------------------
      -- CRASH
      --------------------------------------------------

      if lineType == "C" then

        widget.tCrashes = widget.tCrashes + 1

        if year == widget.thisYear then
          widget.yCrashes = widget.yCrashes + 1
        end

        if year == widget.lastYear then
          widget.pCrashes = widget.pCrashes + 1
        end

      end

      --------------------------------------------------
      -- SERVICE
      --------------------------------------------------

      if lineType == "S" then

        widget.tServices = widget.tServices + 1

        if year == widget.thisYear then
          widget.yServices = widget.yServices + 1
        end

        if year == widget.lastYear then
          widget.pServices = widget.pServices + 1
        end

      end

    end
  end
end

  --------------------------------------------------
  -- READ MAIN FILE (LAST FLIGHT DATE)
  --------------------------------------------------

if not widget.doneMain and widget.fileMain then

  local chunk = io.read(widget.fileMain, 128)

  if not chunk or chunk == "" then

    io.close(widget.fileMain)
    widget.fileMain = nil
    widget.doneMain = true

  else

    widget.bufferMain = widget.bufferMain .. chunk

  end

  while true do

    local s = string.find(widget.bufferMain,"\n",1,true)
    if not s then break end

    local line = string.sub(widget.bufferMain,1,s-1)
    widget.bufferMain = string.sub(widget.bufferMain,s+1)

    line = string.gsub(line,"\r","")

    if line ~= "" and not string.find(line,"ModelName",1,true) then

      local cols={}

      for v in string.gmatch(line,"([^,]*)") do
        cols[#cols+1]=v
      end

      widget.lastFlightDate = cols[2] or ""

    end
  end
end

  ------------------------------------------------------------------
  -- COUNT MANEUVERS ONCE
  ------------------------------------------------------------------
  widget.maneuverCount = 0

  for _ in pairs(widget.maneuverSet) do
    widget.maneuverCount = widget.maneuverCount + 1
  end
  ------------------------------------------------------------------
  -- LOOKUP EXTRA YEAR
  ------------------------------------------------------------------

  local e = extraYear and widget.yearStats[extraYear]

  ------------------------------------------------------------------
  -- DRAW TABLE
  ------------------------------------------------------------------

  local left  = z.x + 10
  local col1  = z.x + 130
  local col2  = z.x + 180
  local col3  = z.x + 230
  local col4  = z.x + 280

  local y = z.y + 52
  local step = 18

  lcd.drawText(col1, y, "Total", SMLSIZE + YELLOW)
  lcd.drawText(col2, y, tostring(widget.thisYear), SMLSIZE + YELLOW)
  lcd.drawText(col3, y, tostring(widget.lastYear), SMLSIZE + YELLOW)
  if extraYear then lcd.drawText(col4, y, tostring(extraYear), SMLSIZE + YELLOW) end

  y = y + step + 4
  lcd.drawText(left, y, "Flight Target:", SMLSIZE + WHITE)
  lcd.drawText(col2, y, widget.yTarget, SMLSIZE + WHITE)
  lcd.drawText(col3, y, widget.pTarget, SMLSIZE + WHITE)
  if extraYear then lcd.drawText(col4, y, e and e.t or "-", SMLSIZE + WHITE) end

  y = y + step
  lcd.drawText(left, y, "Flight Count:", SMLSIZE + WHITE)
  lcd.drawText(col1, y, widget.tFlights, SMLSIZE + WHITE)
  lcd.drawText(col2, y, widget.yFlights, SMLSIZE + WHITE)
  lcd.drawText(col3, y, widget.pFlights, SMLSIZE + WHITE)
  if extraYear then lcd.drawText(col4, y, e and e.f or "-", SMLSIZE + WHITE) end

  y = y + step
  lcd.drawText(left, y, "Flight Duration (H):", SMLSIZE + WHITE)
  lcd.drawText(col1, y, string.format("%.1f", widget.tSeconds/3600), SMLSIZE + WHITE)
  lcd.drawText(col2, y, string.format("%.1f", widget.ySeconds/3600), SMLSIZE + WHITE)
  lcd.drawText(col3, y, string.format("%.1f", widget.pSeconds/3600), SMLSIZE + WHITE)
  if extraYear then lcd.drawText(col4, y, e and string.format("%.1f", e.s/3600) or "-", SMLSIZE + WHITE) end

  y = y + step
  lcd.drawText(left, y, "Crashes:", SMLSIZE + WHITE)
  lcd.drawText(col1, y, widget.tCrashes, SMLSIZE + WHITE)
  lcd.drawText(col2, y, widget.yCrashes, SMLSIZE + WHITE)
  lcd.drawText(col3, y, widget.pCrashes, SMLSIZE + WHITE)
  if extraYear then lcd.drawText(col4, y, e and e.c or "-", SMLSIZE + WHITE) end
  
  y = y + step
  lcd.drawText(left, y, "Services:", SMLSIZE + WHITE)
  lcd.drawText(col1, y, widget.tServices, SMLSIZE + WHITE)
  lcd.drawText(col2, y, widget.yServices, SMLSIZE + WHITE)
  lcd.drawText(col3, y, widget.pServices, SMLSIZE + WHITE)
  if extraYear then lcd.drawText(col4, y, e and (e.svc or 0) or "-", SMLSIZE + WHITE) end


------------------------------------------------------------------
-- BAR CHART
------------------------------------------------------------------

local x0 = z.x + z.w - 120
local baseY = z.y + 150
local barW = 30
local gap = 0
local maxH = 90

----------------------------------------------------------
-- build bars dynamically (2 or 3)
----------------------------------------------------------

local bars = {
  {year = widget.thisYear, v = widget.yFlights},
  {year = widget.lastYear, v = widget.pFlights}
}

if extraYear then
  local extraFlights = widget.yearStats[extraYear] and widget.yearStats[extraYear].f or 0
  table.insert(bars, {year = extraYear, v = extraFlights})
end

----------------------------------------------------------
-- sort by value
----------------------------------------------------------

table.sort(bars, function(a,b) return a.v > b.v end)

local colors = { DARKGREEN, ORANGE, DARKRED }

----------------------------------------------------------
-- scale to highest
----------------------------------------------------------

local maxVal = bars[1].v
if maxVal == 0 then maxVal = 1 end

----------------------------------------------------------
-- draw bars
----------------------------------------------------------

for i=1,#bars do
  local b = bars[i]

  local height = math.floor((b.v / maxVal) * maxH)

  local x = x0 + (i-1)*(barW + gap)
  local yTop = baseY - height

  lcd.drawFilledRectangle(x, yTop, barW, height, colors[i])

  -- year label
  lcd.drawText(x + barW/2, baseY + 4, tostring(b.year), SMLSIZE + CENTER)
end

----------------------------------------------------------
-- TARGET ACHIEVED CIRCLE
----------------------------------------------------------
  local startX = z.x + z.w - 115
  local cBaseY = z.y + 210
  local rBigF, spacing = 53, 0
  local rBigCCX  = startX + rBigF
  
  local tar = (widget.yTarget > 0) and (widget.yFlights / widget.yTarget * 100) or 0

  lcd.drawFilledCircle(rBigCCX, cBaseY, rBigF, ORANGE)
  lcd.drawCircle(rBigCCX, cBaseY, rBigF, WHITE)
  lcd.drawText(rBigCCX, cBaseY+15, "Target", SMLSIZE + BLACK + CENTER)
  lcd.drawText(rBigCCX, cBaseY+28 , "Achieved", SMLSIZE + BLACK + CENTER)
  lcd.drawText(rBigCCX, cBaseY-25, string.format("%.1f%%", tar), DBLSIZE + WHITE + CENTER)

----------------------------------------------------------
-- CRASHES CIRCLE
----------------------------------------------------------
  local startX = z.x + z.w - 210
  local cBaseY = z.y + 210
  local rBigCR, spacing = 50, 0
  local rBigCRCX  = startX + rBigCR
  
  local crashes = (widget.yCrashes > 0) and (widget.yCrashes / widget.yFlights * 100) or 0

  lcd.drawFilledCircle(rBigCRCX, cBaseY, rBigCR, ORANGE)
  lcd.drawCircle(rBigCRCX, cBaseY, rBigCR, WHITE)
  lcd.drawText(rBigCRCX, cBaseY+15, "Crash %", SMLSIZE + BLACK + CENTER)
  lcd.drawText(rBigCRCX, cBaseY+28, "YTD", SMLSIZE + BLACK + CENTER)
  lcd.drawText(rBigCRCX, cBaseY-25, string.format("%.1f%%", crashes), DBLSIZE + WHITE + CENTER)
----------------------------------------------------------
-- MANEUVERS COUNT CIRCLE
----------------------------------------------------------
  local startX = z.x + z.w - 300
  local cBaseY = z.y + 210
  local rBigM, spacing = 47, 0
  local rBigMCX  = startX + rBigM
  
  local maneuvers = widget.maneuverCount or 0

  lcd.drawFilledCircle(rBigMCX, cBaseY, rBigM, ORANGE)
  lcd.drawCircle(rBigMCX, cBaseY, rBigM, WHITE)
  lcd.drawText(rBigMCX, cBaseY+15, "Maneuvers", SMLSIZE + BLACK + CENTER)
  lcd.drawText(rBigMCX, cBaseY+28 , "YTD", SMLSIZE + BLACK + CENTER)
  lcd.drawText(rBigMCX, cBaseY-25, maneuvers, DBLSIZE + WHITE + CENTER)

----------------------------------------------------------
-- LAST FLIGHT DATE
----------------------------------------------------------
  local boxX = z.x + 10
  local boxY = z.y + z.h - 70 

  local lastDateText = widget.lastFlightDate or "-"

  lcd.drawText(boxX, boxY - 20, "Last Flight Date:", SMLSIZE + YELLOW)
  lcd.drawText(boxX + 95, boxY - 20, lastDateText, SMLSIZE + WHITE)

----------------------------------------------------------
-- MANEUVERS IN PROGRESS (GV6 FM4/FM2)
---------------------------------------------------------- 

  local gvIndex = 5 
  local fm4 = 4       
  local fm2 = 2       

  local m1 = model.getGlobalVariable(gvIndex, fm4)
  local m2 = model.getGlobalVariable(gvIndex, fm2)

  local name1 = maneuverNames[m1 or 0] or "-"
  local name2 = maneuverNames[m2 or 0] or "-"

  lcd.drawText(boxX, boxY, "Maneuvers In Progress", SMLSIZE + YELLOW)

  lcd.drawText(boxX,     boxY + 16, "M1:", SMLSIZE + WHITE)
  lcd.drawText(boxX+25,  boxY + 16, name1, SMLSIZE + WHITE)

  lcd.drawText(boxX,     boxY + 32, "M2:", SMLSIZE + WHITE)
  lcd.drawText(boxX+25,  boxY + 32, name2, SMLSIZE + WHITE)

end

return {
  name = name,
  create = create,
  update = update,
  refresh = refresh,
  options = options
}
