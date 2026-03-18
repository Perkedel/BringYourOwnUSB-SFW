-- ReactionTrainer.lua — PRO/SPT tree (SB toggles), NHRA Sportsman timings
-- SC pressed/down => (getValue('sc') > 0)
-- SB (momentary): each press toggles mode PRO <-> SPT

-- ---------- State ----------
local state, seeded = 0, false
local holdStart, goTime, delay = 0, 0, 0
local lastMS, bestMS, foulUntil = nil, nil, 0

-- Mode (SB toggles)
local mode = "PRO"
local lastSBPressed = false
local modeMsgUntil = 0

-- Timings
local AMBER_FLASH = 0.18         -- PRO: all ambers flash this long

-- SPT: real NHRA sportsman timings
local A_STEP  = 0.50             -- gap between ambers (s)
local A_DUR   = 0.50             -- each amber lit for (s)
local G_DELAY = 3 * A_STEP       -- green at 1.50 s after first amber

-- ---------- Helpers ----------
local function now() return getTime()/100.0 end
local function ms(x) return math.floor((x or 0)*1000 + 0.5) end
local function scPressed() return (getValue("sc") or 0) > 0 end
local function sbPressed() local v=getValue("sb") or 0; return v>200 end
local function speakMs(val) if playNumber and val then playNumber(val,0) end end
local function beepGo()   if playTone then playTone(2000,200,50) elseif playFile then playFile("/SOUNDS/en/ready.wav") end end
local function beepFoul() if playTone then playTone( 400,200,50) elseif playFile then playFile("/SOUNDS/en/disarm.wav") end end

-- UI helpers
local function txtw(t) if lcd.getTextWidth then return lcd.getTextWidth(0,t or "") end return (t and #t or 0)*6 end
local function rtext(x,y,t) lcd.drawText(x - txtw(t), y, t or "", 0) end

-- Tiny bulb (8x6) column at far right; no labels (avoids overlap)
local function bulb(x,y,on) local w,h=8,6; lcd.drawRectangle(x,y,w,h,0); if on then lcd.drawFilledRectangle(x+1,y+1,w-2,h-2,0) end end
local function drawTree(state_, staged, mode_, go_at, tnow)
  -- Keep tree confined to the last ~16 px
  local tx = LCD_W - 11      -- center column for bulbs
  local top = 10

  -- PRE / STG (two small bulbs on same row)
  bulb(tx-8, top, staged)    -- PRE
  bulb(tx,   top, staged)    -- STG

  -- Stack: A1, A2, A3, GO
  local a1y = top + 10
  local a2y = a1y + 8
  local a3y = a2y + 8
  local gy  = a3y + 10

  local a1,a2,a3,g = false,false,false,false
  if state_ == 2 then
    local dt = tnow - go_at
    if mode_ == "PRO" then
      local on = (dt >= 0 and dt <= AMBER_FLASH)
      a1,a2,a3,g = on,on,on,true
    else
      a1 = (dt >= 0        and dt <= A_DUR)
      a2 = (dt >= A_STEP   and dt <= A_STEP + A_DUR)
      a3 = (dt >= 2*A_STEP and dt <= 2*A_STEP + A_DUR)
      g  = (dt >= G_DELAY)
    end
  end

  bulb(tx, a1y, a1)
  bulb(tx, a2y, a2)
  bulb(tx, a3y, a3)
  bulb(tx, gy,  g)
end

-- ---------- Main ----------
local function run(event)
  lcd.clear()
  lcd.drawText(2,0,"Reaction Trainer",0)
  rtext(LCD_W-2,0,mode)                 -- PRO / SPT at top-right
  lcd.drawLine(0,9,LCD_W,9,SOLID,0)

  if not seeded then math.randomseed(getTime()); math.random(); seeded=true end
  local tnow = now()

  -- SB toggle (edge)
  local sbP = sbPressed()
  if sbP and not lastSBPressed then
    if mode == "PRO" then mode = "SPT" else mode = "PRO" end
    modeMsgUntil = tnow + 0.8
    if playTone then playTone(1400,100,50) end
  end
  lastSBPressed = sbP

  -- Temporary banner for mode change (stays left; no overlap)
  if tnow < modeMsgUntil then
    lcd.drawText(2,56,"MODE: "..mode, INVERS)
  end

  if state == 0 then
    lcd.drawText(2,14,"Hold SC to STAGE",0)
    lcd.drawText(2,24,"Release after tree",0)
    lcd.drawText(2,38,"Best:",0); lcd.drawText(38,38, bestMS and (tostring(bestMS).." ms") or "--",0)
    if scPressed() then delay = 1.5 + math.random()*2.0; holdStart=tnow; state=1 end

  elseif state == 1 then
    lcd.drawText(2,14,"STAGING...", INVERS)
    if not scPressed() then
      beepFoul(); foulUntil=tnow+1.0; state=4
    elseif (tnow - holdStart) >= delay then
      if mode == "PRO" then beepGo() end   -- PRO beeps immediately
      goTime = tnow
      state  = 2
    end

  elseif state == 2 then
    lcd.drawText(2,14,"GO SEQUENCE", INVERS+BLINK)
    -- SPT: beep when green lights
    if mode ~= "PRO" then
      local dt = tnow - goTime
      if dt >= G_DELAY and dt < G_DELAY + 0.05 then beepGo() end
    end
    if not scPressed() then
      local rt = (mode == "PRO") and (tnow - goTime) or math.max(0, tnow - (goTime + G_DELAY))
      lastMS = ms(rt); bestMS = (bestMS and math.min(bestMS,lastMS)) or lastMS
      speakMs(lastMS); state = 3
    end

  elseif state == 3 then
    lcd.drawText(2,14,"Last:",0); lcd.drawText(38,14, tostring(lastMS or "--").." ms",0)
    lcd.drawText(2,24,"Best:",0); lcd.drawText(38,24, tostring(bestMS or "--").." ms",0)
    lcd.drawText(2,38,"Hold SC for next run",0)
    if scPressed() then delay = 1.5 + math.random()*2.0; holdStart=tnow; state=1 end

  elseif state == 4 then
    lcd.drawText(2,14,"FOUL - Released early",0)
    if tnow >= foulUntil then state = 0 end
  end

  -- Draw the compact tree on the far right
  local staged = (state == 1) and scPressed()
  drawTree(state, staged, mode, goTime, tnow)

  -- Footer hint stays left
  lcd.drawText(2,56,"(SB toggles PRO/SPT | Hold SC -> release)",0)
end

return { run=run }
