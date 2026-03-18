-- vu: little image viewer widget for edgetx horus
-- share your images!
-- CyBarFlEye https://www.schleth.com/category/fpv
-- Date: 20220401
-- ver: 0.1

local name = "vu"
local path = "/WIDGETS/vu/"
local names = {}
local images
local vuImgNr
local vuImgNext
local vuImgBefore
local image
local bm
local wr
local w, h
local hr
local scl
local taps = 0
local swipesLeft = 0
local swipesRight = 0
local yd
local xd
local isWritten = 0


local function getNextImg(nr)
    if not (nr == nil) then
        if (nr >= 1024 or nr >=images) then
            nr = 0
        else
            nr = nr + 1
        end
    end
    return nr
end

local function getBeforeImg(nr)
    if (nr == 0) then
        nr = images
    else
        nr = nr - 1
    end
    return nr
end

local function getImage(nr)
    image = names[nr]
    bm = nil
    bm = Bitmap.open(path .. "images/" .. image)
    w, h = Bitmap.getSize(bm)
    -- screenwidth / imagewidth ratio
    wr = LCD_W / w 
    -- screenheight / imageheight ratio
    hr = LCD_H / h
    xd = 0
    yd = 0
    scl = 100
    if (wr < hr)
    then
        scl = math.ceil(wr * 100)
        -- y offset to center image
        yd = math.ceil((LCD_H - h * wr) / 2)
    else 
        scl = math.ceil(hr * 100)
        -- x offset to center image
        xd = math.ceil((LCD_W - w * hr) / 2)
    end
    collectgarbage("collect")
end

-- Create a table with default options
-- Options can be changed by the user from the Widget Settings menu
-- Notice that each line is a table inside { }
local options = {
  -- { "Source", SOURCE, 1 },
  -- BOOL is actually not a boolean, but toggles between 0 and 1
  -- { "Boolean", BOOL, 1 },
  -- { "Value", VALUE, 1, 0, 10},
  -- { "Color", COLOR, ORANGE },
  -- { "image", STRING, "Max8chrs" }
  { "GV_FM", VALUE, 0, 0, 8},
  { "GV_IDX", VALUE, 9, 1, 9}
}

local function create(zone, options)
  -- Runs one time when the widget instance is registered
  -- Store zone and options in the widget table for later use
  
  vuImgNr = model.getGlobalVariable( options.GV_IDX-1, options.GV_FM)
  
  local fname
  local i = -1
  for fname in dir(path .. "images") do
      i = i + 1
      names[i] = fname
  end
  images = i
  vuImgNext = getNextImg(vuImgNr)
  vuImgBefore = getBeforeImg(vuImgNr)
  getImage(vuImgNr)
  
  local widget = {
    zone = zone,
    options = options
  }
  
  -- Add local variables to the widget table,
  -- unless you want to share with other instances!
  widget.someVariable = 3
  -- Return widget table to EdgeTX
  return widget
end

local function update(widget, options)
  -- Runs if options are changed from the Widget Settings menu
  widget.options = options
end

local function background(widget)
  -- Runs periodically only when widget instance is not visible
end

local function refresh(widget, event, touchState)
  -- Runs periodically only when widget instance is visible
  -- If full screen, then event is 0 or event value, otherwise nil
    if event == nil then -- Widget mode
    -- Draw in widget mode. The size equals zone.w by zone.h
    else -- Full screen mode
      -- Draw in full screen mode. The size equals LCD_W by LCD_H
      if event ~= 0 then -- Do we have an event?
        if touchState then -- Only touch events come with a touchState
          if event == EVT_TOUCH_FIRST then
            -- When the finger first hits the screen
          elseif event == EVT_TOUCH_BREAK then
            -- When the finger leaves the screen and did not slide on it
          elseif event == EVT_TOUCH_TAP then
            -- A short tap gives TAP instead of BREAK
            -- touchState.tapCount shows number of taps
            taps = taps + 1
            if (taps == 2) then
              lcd.exitFullScreen()
              taps = 0
            end
          elseif event == EVT_TOUCH_SLIDE then
            -- Sliding the finger gives a SLIDE instead of BREAK or TAP
            if touchState.swipeRight then
              -- Is true if user swiped right
              swipesRight = swipesRight + 1
              if (swipesRight >= 1) then
                vuImgNr = vuImgBefore
                vuImgNext = getNextImg(vuImgNr)
                vuImgBefore = getBeforeImg(vuImgNr)
                getImage(vuImgNr)
                swipesRight = 0
              end
            elseif touchState.swipeLeft then
              -- Is true if user swiped left
              swipesLeft = swipesLeft + 1
              if (swipesLeft >= 1) then
                vuImgNr = vuImgNext
                vuImgNext = getNextImg(vuImgNr)
                vuImgBefore = getBeforeImg(vuImgNr)
                getImage(vuImgNr)
                swipesLeft = 0
              end
            elseif touchState.swipeUp then
            elseif touchState.swipeDown then
              -- etc.
            else
              -- Sliding but not swiping
            end
          end
        else -- event ~= 0 and touchState == nil: key event
          if event == EVT_VIRTUAL_ENTER then
            -- User hit ENTER
          elseif event == EVT_VIRTUAL_EXIT then
            -- etc.
          elseif event == EVT_VIRTUAL_PREV_PAGE then
                vuImgNr = vuImgBefore
                vuImgNext = getNextImg(vuImgNr)
                vuImgBefore = getBeforeImg(vuImgNr)
                getImage(vuImgNr)
          elseif event == EVT_VIRTUAL_NEXT_PAGE then
                vuImgNr = vuImgNext
                vuImgNext = getNextImg(vuImgNr)
                vuImgBefore = getBeforeImg(vuImgNr)
                getImage(vuImgNr)
          end
        end
    end    
  end
  lcd.drawBitmap(bm, 0+xd,0+yd,scl)
  
  -- this is for debugging
  -- lcd.drawText(100, 40, "vuImgNr: " .. vuImgNr .. " img: " .. image .. " T: " .. taps .. " SL: " .. swipesLeft .. " SR: " .. swipesRight, VCENTER + CENTER + ORANGE)
  -- lcd.drawText(200, 40, "LCD_W: " .. LCD_W .. " LCD_H: " .. LCD_H .. "xd: " .. xd .. " yd: " .. yd .. " w: " .. w .. " h: " .. h, VCENTER + CENTER + ORANGE)
  -- lcd.drawText(200, 60, "wr: " .. wr .. " hr: " .. hr .. " scl: " .. scl, VCENTER + CENTER + ORANGE)
  -- for i = 0,8,1 
  -- do
  --   if (model.getGlobalVariable( i, 0) ~= nil) then
  --     t1 = model.getGlobalVariable( i, 0)
  --      lcd.drawText(50, 80+20*i, "i: " .. i .. "t1:" .. t1, VCENTER + CENTER + ORANGE)      
  --   end
  -- end
  model.setGlobalVariable( widget.options.GV_IDX-1, widget.options.GV_FM, vuImgNr)
end

return {
  name = name,
  options = options,
  create = create,
  update = update,
  refresh = refresh,
  background = background
}

