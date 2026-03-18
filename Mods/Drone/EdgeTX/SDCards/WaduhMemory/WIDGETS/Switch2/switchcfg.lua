local toolName = "TNS|Switch config|TNE"

-- SwitchCfg: config tool for switch2 widget (shows all switches with different icons for every switch position)
-- Frank Zeroch
-- Date: 2021
-- ver: 0.2
-- ver: 0.3 support for EdgeTX 2.8:  fix color and up/down arrows


local swCoords
local sixPosCoords
local idSA
local idSixPos
local switchesCfg
local selSwitch = 1
local selPosChr = "u"
local selPos = 1
local selMode = "switch"
local imageMode = "image"
local maxImgNumber = 9999
local imgNumber = 1
local imgNumber1 = 0
local imgNumber2 = 0
local switchPos = ''
local path = "/WIDGETS/Switch2/"
local bitmaps = {}
local oldSwitchPos = {}
local oldImgNumber = 0
local rollerDirection = 1
local enterLongPressed = false
local touchPoint = {}

-- image loading and caching
local function loadBMap (img)
  local bm;
  if img == nil or img == "" or img <= 0 or  img > maxImgNumber then 
    bm=nil 
  else 
    if bitmaps[img] ~= nil then 
      bm = bitmaps[img]
    else       
      bm = Bitmap.open(path .. "img/" .. img .. ".png")
      if Bitmap.getSize(bm) == 0 then
        bm = nil
        if img > 0 then maxImgNumber = img-1 end
      else  
        bitmaps[img] = bm
      end  
    end
  end
  
  return bm
end

-- get image numbers for selected switch position
local function getAktImgNumber ()
  -- u = ↑, d = ↓, EdgeTX has CHAR_* defined, but not char(192,193)
  local swSymbol = {u = CHAR_UP == nil and string.char(192) or CHAR_UP, 
                    m = '-' , 
                    d = CHAR_DOWN == nil and string.char(193) or CHAR_DOWN} 

  if selSwitch <= 8 then
    imgNumber = switchesCfg.sw[selSwitch][selPosChr][selMode == "image2" and 2 or 1]
    imgNumber1 = switchesCfg.sw[selSwitch][selPosChr][1]
    imgNumber2 = switchesCfg.sw[selSwitch][selPosChr][2]
    switchPos = "Switch: " .. string.char(64+selSwitch) .. ",  Position: " .. swSymbol[selPosChr] 
  elseif selSwitch == 9 then
    imgNumber =  switchesCfg.sixPos[selPos][selMode == "image2" and 2 or 1]
    imgNumber1 = switchesCfg.sixPos[selPos][1]
    imgNumber2 = switchesCfg.sixPos[selPos][2]
    switchPos = "Switch: 6Pos" .. ",  Position: " .. selPos 
  else 
    imgNumber = switchesCfg.sixPosGV[selPos]
    imgNumber1 = 0
    imgNumber2 = 0
    switchPos = "Switch: GV" .. ",  Position: " .. selPos
  end
  imgNumber = imgNumber == nil and 0 or imgNumber;
  imgNumber1 = imgNumber1 == nil and 0 or imgNumber1;
  imgNumber2 = imgNumber2 == nil and 0 or imgNumber2;
 end

-- set image numbers for selected switch position
local function setAktImgNumber ()
  if selSwitch <= 8 then
    switchesCfg.sw[selSwitch][selPosChr][selMode == "image2" and 2 or 1] = imgNumber
  elseif selSwitch == 9 then
    switchesCfg.sixPos[selPos][selMode == "image2" and 2 or 1] = imgNumber
  else 
    switchesCfg.sixPosGV[selPos] = imgNumber
  end
end

-- check on image number range
local function checkImgNumber ()
  local bm
  if imgNumber < 0 then imgNumber = 0 end
  bm = loadBMap(imgNumber)
  if imgNumber > 0 and bm == nil then -- last img reached 
    imgNumber = imgNumber -1 
  end
end

-- new touch screen interface for EdgeTX
local function checkTouchedPos (touchState)
  local swpos = 0
  local switchnr = 0
  
  if selMode ~= "switch" then  -- change between image selection for active / inactive switch position
    if touchPoint.x > 224 and touchPoint.x < 224 + 32 and touchPoint.y > 174 and touchPoint.y < 174+32 then
      selMode = selMode == "image" and "image2" or "image"
      return
    end
  end
 
  -- tap on switch pos to activate image selection (double tap removes image fom switch pos)
  for i, p in ipairs (swCoords) do  -- swichtes A..H. switch number 6 and 8 have only two positions
    if touchPoint.x  > p.x and touchPoint.x < p.x + 32 then
      if touchPoint.y > p.y and touchPoint.y < p.y + 32 then
        swpos = 1
        switchnr = i
      elseif touchPoint.y  > p.y + 34 and touchPoint.y  < p.y + 32 + 34 then
        swpos = 2
        switchnr = i
      elseif  i ~= 6 and i ~= 8 and touchPoint.y  > p.y + 2*34 and touchPoint.y  < p.y + 32 + 2*34 then
        swpos = 3
        switchnr = i
      end
    end   
  end
  
  -- no switch touched so far, check 6-pos. switch
  if switchnr == 0 and touchPoint.y   > sixPosCoords.y - 20 and touchPoint.y  < sixPosCoords.y + 32 then
    for i = 0, 5, 1 do
      if touchPoint.x  > sixPosCoords.x + i*34 and touchPoint.x  < sixPosCoords.x + 32 + i*34 then
        swpos = i+1
        switchnr = touchPoint.y  < sixPosCoords.y and 10 or 9
      end
    end
  end  
  
  if switchnr ~= 0 then  -- switch pos touched
    selMode =  selMode == "switch" and "image" or selMode -- switch to image selection mode (if mode is not already active)
    if switchnr < 9 then -- normal switches
      if swpos == 1 then
        selSwitch = switchnr
        selPos = 1
        selPosChr = "u"
      elseif swpos == 2 then
        selSwitch = switchnr
        selPos = 2
        selPosChr = (switchnr == 6 or switchnr == 8) and "d" or "m" -- switch 6 and 8 have only two positions
      elseif swpos == 3 and switchnr ~= 6 and switchnr ~= 8 then
        selSwitch = switchnr
        selPos = 3
        selPosChr = "d"
      end 
    else -- 6-pos. switch
      selSwitch = switchnr
      selPos = swpos
    end
    if touchState.tapCount > 1 then --  double tap: delete image
      imgNumber = 0
      setAktImgNumber()
    end
    
  else -- tap on free space changes mode back to switch selection 
    selMode = "switch"
  end  
end

-- create configuration for widget
local function outputConfig ()
  local res= "{\n" 
  res = res .. "  -- Switches in order from idSA..idSH\n"
  res = res .. "  -- u, m, d: switch positions: up, middle, down\n"
  res = res .. "  sw = {\n"
  
  for s = 1,8,1 do
    res = res .. "   -- Switch " .. string.char(64+s) .. "\n"
    res = res .. "   {\n"
    for _,pos  in pairs ( {"u", "m", "d"}) do
      if  switchesCfg.sw[s][pos] ~= nil then
        res = res .. "    " .. pos .. " = { "
        for i = 1,2,1 do
          if switchesCfg.sw[s][pos][i] == nil then
            res = res ..  " nil, "
          else
            res = res ..  switchesCfg.sw[s][pos][i] .. ", "
          end
        end
        res = res .. "},\n"
      end
    end
    res = res .. "   }, \n"
  end  
  res = res .. " },\n\n"
  
  res = res .. "  -- 6Pos switch \n"
  res = res .. "  sixPos = {\n"
  for pos = 1,6,1 do
    res = res .. "    -- Pos" .. pos .. "\n"
    res = res .. "    {"
    for i = 1,2,1 do
      if switchesCfg.sixPos[pos][i] == nil then
        res = res ..  " nil, "
      else
        res = res ..  switchesCfg.sixPos[pos][i] .. ", "
      end
    end    
    res = res .. "},\n"
  end
  res = res .. "    }, \n\n"
  
  res = res .. "  -- GV for 6Pos \n"
  res = res .. "  sixPosGV = { "
  for pos = 1,6,1 do
      if switchesCfg.sixPosGV[pos] == nil then
        res = res ..  " nil, "
      else
        res = res ..  switchesCfg.sixPosGV[pos] .. ", "
      end
  end
  res = res .. "}\n"
  res = res .. "}\n"
  
  return res
end



-- Init
local function init()
  
  idSA = getFieldInfo('sa').id
  idSixPos = getFieldInfo('6pos').id 
--  swCoords = {{x=41*2,y=26*2}, {x=61*2, y=26*2}, {x=104*2,y=26*2}, {x=124*2,y=26*2}, {x=19*2,y=15*2}, {x=0,y=0}, {x=146*2, y=15*2}, {x=165*2, y=0}}
  swCoords = {{x=142,y=87}, {x=182, y=87}, {x=268,y=87}, {x=308,y=87}, {x=98,y=65}, {x=60,y=35}, {x=352, y=65}, {x=390, y=35}}
--  sixPosCoords = {x=40*2,y=5*2}
  sixPosCoords = {x=140,y=45}
  touchPoint = {x=nil, y=nil}
  
 switchesCfg = {  -- empty array template. Gets overwritten by model config file
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
      { u = { nil,  nil}, d = { nil,  nil}},
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
  
  return 0 
end

-- Run
local function cfgswitch(event, touchState)
  
  local ss
  local bitmap
  local gv, gvVal
 
  local openTxBLUE = lcd.RGB(49, 161, 230) -- constant BLUE in edgeTX is to dark
  -- if event >0 then print (string.format("event: %0x\n", event)) end
  lcd.clear()
  
  -- handle events
  if event == nil then
    error("Cannot run as a model script!")
    return 2
  elseif event == EVT_VIRTUAL_EXIT then
    if selMode == "switch" then 
        -- save config
        local f = io.open(path .. model.getInfo().name .. ".lua", "w")
        io.write(f,"return " .. outputConfig())
        io.close(f)
        
        -- create and save update trigger for running widget
        f = io.open(path .. model.getInfo().name .. ".upd", "w")
        io.write(f,"return 'update'\n")
        io.close(f)
        f=nil
        
        -- exit
        return 1
    else 
      selMode = "switch"
    end
    
  elseif event == EVT_VIRTUAL_ENTER then
    if enterLongPressed then
      enterLongPressed = false
    else  
      selMode = selMode == "switch" and "image" or "switch"
    end
    
  elseif (event == 0x605) and selMode ~= "switch" then  -- Telemetry key: change image selection for active/inactive switch position
    imageMode = selMode == "image" and "image2" or "image"
    selMode = imageMode
    
  elseif event == EVT_VIRTUAL_ENTER_LONG and selMode ~= "switch" then -- long Enter deletes image for selected switch pos
    imgNumber = 0
    setAktImgNumber()
    enterLongPressed = true  -- killEvents(event) does not work on ENTER ?!
  
  elseif event == EVT_VIRTUAL_NEXT_PAGE and selMode ~= "switch"  then  -- jump to last known image
    imgNumber = #bitmaps --maxImgNumber
    oldImgNumber = imgNumber
    setAktImgNumber()
      
  elseif event == EVT_VIRTUAL_PREV_PAGE and selMode ~= "switch" then  -- jump to image 0
    imgNumber = 0
    oldImgNumber = 0
    setAktImgNumber()
    
  -- select previous next position or image (swipe in lower touch screen area selects image)
  elseif event == EVT_VIRTUAL_NEXT or event == EVT_VIRTUAL_NEXT_REPT  or (event ==  EVT_TOUCH_SLIDE and selMode ~= "switch" and touchState.y > 200 and touchState.x > touchPoint.x + 10) then
    if event == EVT_TOUCH_SLIDE then
      touchPoint.x = touchState.x
      touchPoint.y = touchState.y
    end
    
    if selMode == "switch" then -- select switch
      if selSwitch <= 8 then -- Switches
        if selPosChr == "d" then 
          selSwitch = selSwitch + 1
          selPos = 1
          selPosChr = "u"
        elseif selSwitch == 6 or selSwitch == 8 then -- 2 Pos
          selPosChr = "d"
          selPos = 2 
        else -- 3Pos
          selPosChr = selPosChr == "u" and "m" or "d"
          selPos = selPos+1 
        end
      else -- 6Pos
        if selSwitch == 9 then
          if selPos == 6 then 
            selSwitch = 10
            selPos = 1
          else 
            selPos = selPos + 1
          end
        else   
          if selPos == 6 then 
            selSwitch = 1
            selPos = 1
            selPosChr = "u"
          else 
            selPos = selPos + 1
          end
        end
      end
    else --select image
      getAktImgNumber()
      if selSwitch == 10 then -- GVs: no real images
        imgNumber = imgNumber < 9 and imgNumber+1 or 0
        setAktImgNumber()
      else 
        if imgNumber == 0 and oldImgNumber ~= nil then
          imgNumber = oldImgNumber
        end
        repeat
          -- find next real image. small images are placeholder for future icon additions, so old image numbers can stay the same
          imgNumber = imgNumber+1
          checkImgNumber()
          setAktImgNumber()
        until bitmaps[imgNumber] == nil or Bitmap.getSize(bitmaps[imgNumber]) > 10
        oldImgNumber = imgNumber
      end
    end
   
   -- select previous switch position or image (swipe in lower touch screen area selects image)
  elseif event == EVT_VIRTUAL_PREV or event == EVT_VIRTUAL_PREV_REPT or (event ==  EVT_TOUCH_SLIDE and selMode ~= "switch" and touchState.y > 200 and touchState.x < touchPoint.x - 10) then
    if event == EVT_TOUCH_SLIDE then
      touchPoint.x = touchState.x
      touchPoint.y = touchState.y
    end
    
    if selMode == "switch" then --select switch
      if selPos == 1 then
        selSwitch = (selSwitch > 1) and (selSwitch-1) or 10
      end
      
      if selSwitch <= 8 then -- Switches
        if selSwitch == 6 or selSwitch == 8 then -- 2 Pos
          selPosChr = selPosChr == "u" and "d" or "u"
          selPos = selPos == 1 and 2 or 1
        else -- 3Pos
          selPosChr = selPosChr == "u" and "d" or (selPosChr == "d" and "m" or "u")
          selPos = selPos > 1 and selPos-1 or 3
        end
      else -- 6Pos
        selPos = selPos > 1 and selPos-1 or 6
        selPosChr = selPos
      end
    else -- select image
      getAktImgNumber()
      if selSwitch == 10 then -- GVs: no real images
        imgNumber = imgNumber > 0 and imgNumber-1 or 9
        setAktImgNumber()
      else 
        if imgNumber == 0 and oldImgNumber ~= nil then
          imgNumber = oldImgNumber
        end
        -- find previous real image 
        repeat
          imgNumber = imgNumber-1
          checkImgNumber()
          setAktImgNumber()
        until bitmaps[imgNumber] == nil or  imgNumber <  1 or Bitmap.getSize(bitmaps[imgNumber]) > 10 
        oldImgNumber = imgNumber
      end
    end
  
  -- selection via touch screen in EdgeTX
  elseif  event == EVT_TOUCH_FIRST then
    touchPoint.x = touchState.x
    touchPoint.y = touchState.y
  elseif event == EVT_TOUCH_TAP and touchPoint.x ~= nil then
    checkTouchedPos(touchState)
    
  -- selection via switch flip
  else
    for i = 1, 9, 1 do
      if i == 9 then
        ss = getValue (idSixPos)
        ss = math.floor((ss+1025)/400)+1
      else  
        ss = getValue (idSA-1 + i)
      end
      if oldSwitchPos[i] ~= nil and ss ~= oldSwitchPos[i] then -- switch toggeled
        selSwitch = i
        if selSwitch <= 8 then -- Switches
          if ss < -10 then 
            selPos = 1
            selPosChr = "u"
          elseif selSwitch == 6 or selSwitch == 8 then -- 2 Pos
            selPosChr = "d"
            selPos = 2 
          else -- 3Pos
            selPosChr = ss > 10 and "d" or "m"
            selPos = ss > 10 and 3 or 2 
          end
        elseif selSwitch == 9 then
          selPos = ss
        end
      end
      oldSwitchPos[i]=ss
    end
  end
    
  getAktImgNumber()
  
  -- status line
  lcd.drawText(1,1,switchPos)
  if selSwitch < 10 then lcd.drawText(350,1,"Image: ".. (imgNumber > 0 and imgNumber .. ".png" or "-") ) end
  
  -- draw images for selected switch pos
  local indBM = {a={}, d={}}
  if selMode == 'image' then
    indBM.d.x = 216
    indBM.d.y = 210
    indBM.d.s = 3
    indBM.d.c = LIGHTGREY
    indBM.a.x = 224
    indBM.a.y = 174
    indBM.a.s = 2
    indBM.a.c = openTxBLUE
  elseif selMode == 'image2' then
    indBM.a.x = 216
    indBM.a.y = 210
    indBM.a.s = 3
    indBM.a.c = openTxBLUE
    indBM.d.x = 224
    indBM.d.y = 174
    indBM.d.s = 2
    indBM.d.c = LIGHTGREY
  else
    indBM.d.x = 189
    indBM.d.y = 212
    indBM.d.s = 3
    indBM.d.c = LIGHTGREY
    indBM.a.x = 242
    indBM.a.y = 212
    indBM.a.s = 3
    indBM.a.c = openTxBLUE
  end
  
  lcd.setColor(CUSTOM_COLOR, indBM.a.c)
  lcd.drawFilledRectangle(indBM.a.x, indBM.a.y, indBM.a.s*16, indBM.a.s*16, CUSTOM_COLOR)
  lcd.setColor(CUSTOM_COLOR, indBM.d.c)
  lcd.drawFilledRectangle(indBM.d.x, indBM.d.y, indBM.d.s*16, indBM.d.s*16, CUSTOM_COLOR)
  
  if selSwitch < 9 then
    bitmap =  loadBMap(switchesCfg.sw[selSwitch][selPosChr][1])
    if bitmap ~= nil then lcd.drawBitmap(bitmap, indBM.d.x, indBM.d.y, indBM.d.s * 100) end
    bitmap =  loadBMap(switchesCfg.sw[selSwitch][selPosChr][2])
    if bitmap ~= nil then lcd.drawBitmap(bitmap, indBM.a.x, indBM.a.y, indBM.a.s * 100) end
  elseif selSwitch == 9 then
    bitmap =  loadBMap(switchesCfg.sixPos[selPos][1])
    if bitmap ~= nil then lcd.drawBitmap(bitmap, indBM.d.x, indBM.d.y, indBM.d.s * 100) end
    bitmap = loadBMap(switchesCfg.sixPos[selPos][2])
    if bitmap ~= nil then lcd.drawBitmap(bitmap, indBM.a.x, indBM.a.y, indBM.a.s * 100) end
  end
      
  -- draw carousel images
  if selMode ~= 'switch' and selSwitch < 10 then
    local x = 240-26-2.5*16
    local im = 1
    local scales = {2.5,2.4,2.2,2,1.7,1.3,1,1}
    local imNr = imgNumber == 0 and oldImgNumber  or imgNumber
    for i = 1, 6, 1 do
      repeat
        bitmap = loadBMap(imNr-im*rollerDirection)
        im = im + 1
      until bitmap == nil or Bitmap.getSize(bitmap) > 10
      if bitmap ~= nil then 
        lcd.drawBitmap(bitmap, x,  238 - 8*(scales[i]) - 3*i^1.7 , scales[i] * 100) 
      end
      x = x - 16*scales[i+1] - 3 
    end
  
    x = 240+27
    im = 1
      
    for i = 1, 6, 1 do
      repeat
        bitmap = loadBMap(imNr+im*rollerDirection)
        im = im + 1
      until bitmap == nil or Bitmap.getSize(bitmap) > 10
      if bitmap ~= nil then 
        lcd.drawBitmap(bitmap, x,  238 - 8*(scales[i]) - 3*i^1.7, scales[i] * 100)
      end
      x = x + 16*scales[i] + 3
    end
    
    lcd.drawText(224, 160, string.format("% 3d", indBM.d.s == 2 and imgNumber1 or imgNumber2), SMLSIZE)
    lcd.drawText(224, 257, string.format("% 3d", indBM.a.s == 2 and imgNumber1 or imgNumber2), SMLSIZE)
  end
  
  -- draw switch layout preview
  for i, p in ipairs (swCoords) do  -- swichtes A..H
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
      if  switchesCfg.sw[i][pos] ~= nil then
        local imgSel
        if selMode == "switch" then
          imgSel = ss == pos  and 2 or 1
        else
          imgSel = selMode == "image2" and 2 or 1
        end
        lcd.setColor(CUSTOM_COLOR, imgSel == 2 and openTxBLUE or LIGHTGREY)
        lcd.drawFilledRectangle(p.x, p.y + s*34, 32, 32, CUSTOM_COLOR)
        bitmap =   loadBMap(switchesCfg.sw[i][pos][imgSel])
        if bitmap == nil and selMode == "switch" then bitmap = loadBMap(switchesCfg.sw[i][pos][1]) end -- use first image, in case only one is given
        if  bitmap ~= nil then
          lcd.drawBitmap(bitmap, p.x, p.y + s*34,200)
        end
        s = s+1
      end
    end
  end
  
  -- 6Pos 
  ss = getValue(idSixPos) + 1025
  local step = 400    
  for s=0,5,1 do
    local imgSel
    if selMode == 'switch' then
      imgSel = (ss < (s+1)*step and ss >(s)*step) and 2 or 1
    else
      imgSel = (selMode == "image2") and 2 or 1
    end
    lcd.setColor(CUSTOM_COLOR, imgSel == 2 and  openTxBLUE or  LIGHTGREY)
    lcd.drawFilledRectangle(sixPosCoords.x + s*34, sixPosCoords.y , 32, 32, CUSTOM_COLOR)
    bitmap = loadBMap(switchesCfg.sixPos[s+1][imgSel])
    if bitmap == nil and selMode == "switch" then bitmap = loadBMap(switchesCfg.sixPos[s+1][1]) end
    if  bitmap ~= nil then
      lcd.drawBitmap(bitmap, sixPosCoords.x + s*34, sixPosCoords.y,200)
    end
      
    -- GV values over 6pos images
    gv = switchesCfg.sixPosGV[s+1]
    if gv ~= nil then
      gvVal = string.format("GV%1d", gv)
      if gv == 0 then gvVal = "" end
      lcd.drawText(sixPosCoords.x + s*34 +2, sixPosCoords.y - 20, gvVal, BLACK+SMLSIZE)
    end
  end

  -- draw frame around selected switch position
  lcd.setColor(CUSTOM_COLOR, RED)
  if (selSwitch <= 8) then
    lcd.drawRectangle(swCoords[selSwitch].x -4, swCoords[selSwitch].y -4 + 34*(selPos-1), 40, 40,     CUSTOM_COLOR,3)
  elseif (selSwitch == 9) then -- 6pos
    lcd.drawRectangle(sixPosCoords.x -4 + (selPos-1)*34, sixPosCoords.y -4, 40,     40, CUSTOM_COLOR,3)
  else -- GV
    lcd.drawRectangle(sixPosCoords.x -4 + (selPos-1)*34, sixPosCoords.y -22, 40,     20, CUSTOM_COLOR,3)
  end  
--  lcd.drawRectangle(212, 206, 56, 56, CUSTOM_COLOR,3)
 
   return 0
end

return { init=init, run=cfgswitch }
