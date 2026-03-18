-- Switch: shows all switches with different icons for every switch position
-- Frank Zeroch
-- Date: 2022
-- ver: 0.3 EdgeTX (2.8) support:  
--       - fix: color and widget placement.
--       - add: full screen support, icons for turtle and pit mode
--       

local swCoords
local sixPosCoords
local idSA
local idSixPos
local checktime
local path = "/WIDGETS/Switch2/"

local function loadBMap (img)
  local bm;
  if img < 1 or img == "" or img == nil  then 
    bm=nil 
  else 
    bm = Bitmap.open(path .. "img/" .. img .. ".png")
    if Bitmap.getSize(bm) == 0 then
      bm = nil
    end  
  end
  return bm
end

local function buildSwitchesFromCfg ()

  local switches = {  -- empty array template. Gets overwritten by model config file
    sw = {
      -- switch A
      { u = {nil, nil}, m = {nil, nil}, d = {nil, nil}},
      -- switch B
      { u = {nil, nil}, m = {nil, nil}, d = {nil, nil}},
      -- switch C
      { u = {nil, nil}, m = {nil, nil}, d = {nil, nil}},
      -- switch D
      { u = {nil, nil}, m = {nil, nil}, d = {nil, nil}},
      -- switch E
      { u = {nil, nil}, m = {nil, nil}, d = {nil, nil}},
      -- switch F
      { u = {nil, nil}, d = {nil, nil}},
      -- switch G
      { u = {nil, nil}, m = {nil, nil}, d = {nil, nil}},
      -- switch H
      { u = {nil, nil}, d = {nil, nil}},
    },
    -- 6pos
    sixPos = {{nil, nil}, {nil, nil}, {nil, nil}, {nil, nil}, {nil, nil}, {nil, nil} },
    -- GV for 6pos
    sixPosGV = {nil, nil, nil, nil, nil, nil }
  }
  
  local switchesCfg = {  -- empty array template. Gets overwritten by model config file
    sw = {
      -- switch A
      { u = { nil,  nil}, m = { nil,  nil}, d = { nil,  nil}},
      -- switch B
      { u = { nil,  nil}, m = { nil,  nil}, d = { nil,  nil}},
      -- switch C
      { u = { nil,  nil}, m = { nil,  nil}, d = { nil,  nil}},
      -- switch D
      { u = { nil,  nil}, m = { nil,  nil}, d = { nil,  nil}},
      -- switch E
      { u = { nil,  nil}, m = { nil,  nil}, d = { nil,  nil}},
      -- switch F
      { u = { nil,  nil}, d = { nil,  nil}},
      -- switch G
      { u = { nil,  nil}, m = { nil,  nil}, d = { nil,  nil}},
      -- switch H
      { u = { nil,  nil}, d = { nil,  nil}}
    },
    -- 6pos
    sixPos = {{nil, nil}, {nil, nil}, {nil, nil}, {nil, nil}, {nil, nil}, {nil, nil} },
    -- GV for 6pos
    sixPosGV = { nil, nil, nil, nil, nil, nil}
  }
  
  local chunk = loadfile(path .. model.getInfo().name .. ".lua")
  if chunk ~= nil then --get switches from config file
    switchesCfg = chunk()
  end
  
  for s = 1,8,1 do
    for _,pos  in pairs ( {"u", "m", "d"}) do
      if  switchesCfg.sw[s][pos] ~= nil then
        for i = 1,2,1 do
          if switchesCfg.sw[s][pos][i] ~= nil then
            switches.sw[s][pos][i] = loadBMap(switchesCfg.sw[s][pos][i])
          end
        end
      end
    end
  end  
  
  for pos = 1,6,1 do
    for i = 1,2,1 do
      if switchesCfg.sixPos[pos][i] ~= nil then
        switches.sixPos[pos][i] = loadBMap(switchesCfg.sixPos[pos][i])
      end
    end
  end
  
  for pos = 1,6,1 do
    switches.sixPosGV[pos] = switchesCfg.sixPosGV[pos]
  end
  return switches
end  

  
local options = {
    { "on", COLOR, lcd.RGB(49, 161, 230) }, -- BLUE on openTX
    { "off", COLOR, LIGHTGREY },
    { "SixPos", BOOL, 1},
    { "SixPosGV", BOOL, 1},
 }


local function create(zone, options)
  
  idSA = getFieldInfo('sa').id
  idSixPos = getFieldInfo('6pos').id 
  swCoords = {{x=41,y=26}, {x=61, y=26}, {x=104,y=26}, {x=124,y=26}, {x=19,y=15}, {x=0,y=0}, {x=146, y=15}, {x=165, y=0}}
  sixPosCoords = {x=40,y=5}
  
  local switches = buildSwitchesFromCfg()
  
  return  { zone=zone, options=options, switches=switches}
end

local function update(wgt, options)
  wgt.options = options
end

local function background(wgt)
end

local function refresh(wgt, event)
  local ss
  local bitmap
  local gv, gvVal, fm
  local scale
  local wgtX, wgtY, edgeTxCorr
  local ver, radio, maj, minor, rev, osname = getVersion()
   
  -- runs only on large enough zone
  if osname == "EdgeTX" and event ~= nil then -- fullscreen mode 
    scale = 2
    wgtX = 40 -- wgt.zone.x
    wgtY = 20 -- wgt.zone.y
  elseif wgt.zone.w  < 170 or wgt.zone.h < 70 then 
    return
  elseif wgt.zone.w > 300 and wgt.zone.h > 150 then  
    scale = 2
    wgtX = wgt.zone.x
    wgtY = wgt.zone.y
  else 
    scale = 1
    if osname == "EdgeTX" then -- edgeTX
      edgeTxCorr = 7 -- widget is not in the same place as on openTX
    else
      edgeTxCorr = 0
    end
    wgtX = wgt.zone.x + edgeTxCorr
    wgtY = wgt.zone.y + edgeTxCorr
  end
  
  local upd
  local t1 = getGlobalTimer()
  if t1.total % 2 == 0 and t1.total ~= checktime then
    checktime = t1.total
    local chunk = loadfile(path .. model.getInfo().name .. ".upd")
    if chunk ~= nil  then --get switches from config file
      upd = chunk()
    end
    if upd == 'update' then
      local f = io.open(path .. model.getInfo().name .. ".upd", "w")
      io.write(f,"return  nil")
      io.close(f)
      f=nil
      wgt.switches = buildSwitchesFromCfg()
      upd = nil
    end 
  end 
  
  for i, p in ipairs (swCoords) do 
    ss = getValue (idSA-1+i)
    if ss == 0 then 
      ss = "m"
    elseif ss > 0 then
      ss = "d"
    else
      ss = "u"
    end
    local s = 0
    for _,pos  in pairs ( {"u", "m", "d"}) do
      if  wgt.switches.sw[i][pos] ~= nil then
        lcd.setColor(CUSTOM_COLOR, ss == pos and wgt.options.on or wgt.options.off)
        lcd.drawFilledRectangle( wgtX + 15*(scale-1) + p.x * scale , wgtY + 15*(scale-1) + p.y * scale + s*16*scale, 16*scale, 16*scale, CUSTOM_COLOR)
        bitmap = wgt.switches.sw[i][pos][ss == pos and 2 or 1]
        if bitmap == nil then bitmap = wgt.switches.sw[i][pos][1] end -- use first image, in case only one is given
        if  bitmap ~= nil then
          lcd.drawBitmap(bitmap, wgtX + 15*(scale-1) + p.x*scale, wgtY + 15*(scale-1) + p.y*scale + s*16*scale, scale*100)
        end
        s = s+1
      end
    end
  end
  
  if wgt.options.SixPos > 0 and wgt.switches.sixPos ~= nil then 
    ss = getValue(idSixPos) + 1025
    local step = 400
    for s=0,5,1 do
  --    print (ss .. ", " .. s*step .. "\r\n")
      lcd.setColor(CUSTOM_COLOR, (ss < (s+1)*step and ss >(s)*step) and wgt.options.on or wgt.options.off)
      lcd.drawFilledRectangle( wgtX + 15*(scale-1) + sixPosCoords.x * scale + s*17*scale, wgtY + 15*(scale-1) + sixPosCoords.y*scale , 16*scale, 16*scale, CUSTOM_COLOR)
      bitmap = wgt.switches.sixPos[s+1][ (ss < (s+1)*step and ss >(s)*step) and 2 or 1]
      if bitmap == nil then bitmap = wgt.switches.sixPos[s+1][1] end
      if  bitmap ~= nil then
        lcd.drawBitmap(bitmap, wgtX + 15*(scale-1) + sixPosCoords.x * scale + s*17 * scale, wgtY + 15*(scale-1) + sixPosCoords.y * scale, 100 * scale)
      end
      
      -- GV values over 6pos images
      if  wgt.options.SixPosGV > 0 and wgt.switches.sixPosGV ~= nil then
        gv = wgt.switches.sixPosGV[s+1]
        if gv ~= nil then
          fm = getFlightMode()
          gvVal =  model.getGlobalVariable(gv - 1, fm)
          -- print (fm .. ", " .. gv .. ", ".. gvVal .. "\r\n")
          while gvVal ~= nil and gvVal >= 1025 do
            if fm <= gvVal - 1025 then
              fm = gvVal - 1024
            else 
              fm = gvVal - 1025
            end
            gvVal = model.getGlobalVariable(gv-1, fm)
            -- print (fm .. ", " .. gv .. ", " .. gvVal .. "\r\n")
          end 
          if gvVal ~= nil then
            lcd.setColor(CUSTOM_COLOR, (gvVal < 0) and RED or BLACK)
            gvVal = math.abs(gvVal)
            if gvVal > 950 then 
              gvVal = string.format( "%1dt", gvVal/1000)
            elseif gvVal > 99 then
              gvVal = string.format("%1dh", gvVal/100)
            else
              gvVal = string.format("%2d", gvVal)
            end
            lcd.drawText(wgtX + 15*(scale-1) + sixPosCoords.x  * scale + s*17 * scale, wgtY +9*(scale-1) + sixPosCoords.y  * scale - 14, gvVal, CUSTOM_COLOR + (scale == 1 and SMLSIZE or 0))
          end
        end
      end
    end
  end
end

return { name="Switch2", options=options, create=create, update=update, refresh=refresh, background=background }
