---------------------------------------------------------------------------
-- MODEL COUNT COMPARISON (STREAMING VERSION)
---------------------------------------------------------------------------

local name = "fltprgW2"

---------------------------------------------------------------------------
-- OPTIONS
---------------------------------------------------------------------------

local options = {
  { "Year", STRING, "" },
  { "M1", STRING, "" },
  { "M2", STRING, "" },
  { "M3", STRING, "" },
  { "M4", STRING, "" },
  { "M5", STRING, "" },
  { "M6", STRING, "" },
  { "M7", STRING, "" },
  { "M8", STRING, "" },
  { "M9", STRING, "" }
}

---------------------------------------------------------------------------
-- FIXED COLOURS
---------------------------------------------------------------------------

local slotColors = {
  DARKGREEN,
  ORANGE,
  DARKRED,
  YELLOW,
  BLUE,
  GREY,
  DARKDOWN,
  WHITE,
  RED
}

local rebuild

---------------------------------------------------------------------------
-- CREATE
---------------------------------------------------------------------------

local function create(zone, opts)

  local w = {
    zone = zone,
    options = opts or {},
    models = {},         -- finished model results
    queue = {},          -- models to parse
    active = nil,        -- currently parsing model
    fileS = nil,
    bufferS = "",
    fileO = nil,
    bufferO = "",
    filterYear = nil
  }

  rebuild(w)
  return w
end

---------------------------------------------------------------------------
-- BUILD QUEUE (when options change)
---------------------------------------------------------------------------

  rebuild = function(widget)

  widget.models = {}
  widget.queue = {}
  widget.active = nil
  widget.fileS = nil
  widget.bufferS = ""
  widget.fileO = nil
  widget.bufferO = ""

  local rawYear = widget.options["Year"]
  widget.filterYear = nil

  if rawYear and rawYear ~= "" then
    widget.filterYear = tonumber(string.match(rawYear, "%d%d%d%d"))
  end

  for i = 1,9 do
    local key = "M"..i
    local modelName = widget.options[key]

    if modelName and modelName ~= "" then
      widget.queue[#widget.queue+1] = {
        name = modelName,
        color = slotColors[i],
        value = 0
      }
    end
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
-- STREAM PARSER (runs gradually)
---------------------------------------------------------------------------

local function process(widget)

  -- If no active file, open next in queue
  if not widget.active then

    if #widget.queue == 0 then
      return
    end

    widget.active = table.remove(widget.queue, 1)

    local base = "/SCRIPTS/TOOLS/FlightProgress/" .. widget.active.name

    widget.fileS = io.open(base .. "_S.txt", "r")
    widget.bufferS = ""

    widget.fileO = io.open(base .. "_O.txt", "r")
    widget.bufferO = ""

    if not widget.fileS and not widget.fileO then
      widget.active = nil
    end

    return
  end

--------------------------------------------------
-- READ SUMMARY FILE (_S)
--------------------------------------------------

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
      local year = tonumber(string.match(cols[2] or "", "%d%d%d%d")) or 0

      if widget.filterYear == nil or year == widget.filterYear then
        widget.active.value = widget.active.value + flights
      end

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

      if lineType == "H" then

        local flights = tonumber(cols[5]) or 0

        if widget.filterYear == nil or year == widget.filterYear then
          widget.active.value = widget.active.value + flights
        end

      end

    end
  end
end


--------------------------------------------------
-- FINISHED MODEL
--------------------------------------------------

if not widget.fileS and not widget.fileO then

  widget.models[#widget.models+1] = widget.active
  widget.active = nil

end

end

---------------------------------------------------------------------------
-- REFRESH
---------------------------------------------------------------------------

local function refresh(widget)

  local z = widget.zone

  lcd.drawFilledRectangle(z.x, z.y, z.w, z.h, BLACK)

  lcd.drawText(z.x + z.w/2, z.y + 8, "MODEL COMPARISON", CENTER + DBLSIZE + WHITE)
  
  local subtitle
  if widget.filterYear == nil then
    subtitle = "Lifetime Total"
  else
    subtitle = tostring(widget.filterYear)
  end

  lcd.drawText(z.x + z.w/2, z.y + 40, subtitle, CENTER + SMLSIZE + BOLD + WHITE)


  -- process small chunk each frame
  process(widget)

  if #widget.models == 0 then
    return
  end

  ----------------------------------------------------------
  -- SCALE
  ----------------------------------------------------------

  local maxVal = 0
  for i=1,#widget.models do
    if widget.models[i].value > maxVal then
      maxVal = widget.models[i].value
    end
  end
  if maxVal == 0 then maxVal = 1 end

  ----------------------------------------------------------
  -- DRAW BARS
  ----------------------------------------------------------

  local count = #widget.models
  local maxH = 120
  local bottomY = z.y + z.h - 40

  local totalWidth = z.w - 40
  local barW = math.floor(totalWidth / count)
  local startX = z.x + 20

  for i=1,count do

    local model = widget.models[i]
    local height = math.floor((model.value / maxVal) * maxH)

    local x = startX + (i-1)*barW
    local yTop = bottomY - height

    lcd.drawFilledRectangle(x, yTop, barW-4, height, model.color)
    lcd.drawText(x + (barW-4)/2, yTop - 22, tostring(model.value), SMLSIZE + CENTER + model.color) -- flight count above bar
    
  -- alternate vertical positioning model names
  local nameY

  if i % 2 == 0 then
    nameY = bottomY + 18   -- lower line
  else
    nameY = bottomY + 6    -- upper line
  end

  lcd.drawText(x + (barW-4)/2, nameY, model.name,SMLSIZE + CENTER + model.color)

  end
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
