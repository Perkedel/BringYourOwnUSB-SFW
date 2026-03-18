local ail, ele, rud, thr

-- =============================================================
--    IKKI GENERATOR - FROZEN EDITION (HARDCODED PRESETS)
-- =============================================================

local SRC_MENU_TRIGGER = "sf" 
local SRC_POT_1        = "s1" 
local SRC_POT_2        = "s2" 
local SRC_EFFECT_CH    = "ch14" -- Serve solo qui per scegliere cosa configurare

local BASE_FOLDER      = "/SCRIPTS/RGBLED/"
local BASE_NAME        = "IKKI_"

-- CONFIGURAZIONE HARDWARE
local SCAMBIA_ANELLI = true
local INV_GAS     = true 
local INV_PICCHIA = false   
local INV_ALETTONI= true
local INV_TIMONE  = false

-- FISICA
local DEAD_ZONE_HIGH, DEAD_ZONE_LOW, AXIS_LOCK, MAX_VELOCITA = 0.18, 0.08, 0.05, 1.6   

-- DEFAULTS
local DEF_HEART_BRIGHT, DEF_PTR_BRIGHT = 1.00, 1.00
local DEF_S1_VAL, DEF_S2_VAL = 100, 0.5

-- =============================================================
--            FINE CONFIGURAZIONE
-- =============================================================

local phase_left, phase_right, last_time = 0, 0, 0
local is_active_left, is_active_right = false, false
local menu_level = 0 
local current_effect = 1 
local settings = {}

-- Inizializza memoria
local function reset_slot_to_default(i)
    settings[i] = {
        th_hue = (i-1)*0.16, th_sat = 1.0, th_val = 1.0,
        ptr_hue = 0.0, ptr_sat = 0.0, ptr_val = 1.0, 
        th_bright = DEF_HEART_BRIGHT, ptr_bright = DEF_PTR_BRIGHT,
        s1_val = DEF_S1_VAL, s2_val = DEF_S2_VAL 
    }
    -- Preset di partenza
    if i == 1 then settings[i].s1_val = 120; settings[i].s2_val = 0.3 -- Comet
    elseif i == 2 then settings[i].s1_val = 40;  settings[i].s2_val = 0.0 -- Rainbow
    elseif i == 3 then settings[i].s1_val = 180; settings[i].s2_val = 0.7 -- Strobe
    elseif i == 4 then settings[i].s1_val = 60;  settings[i].s2_val = 0.4 -- Scanner
    elseif i == 5 then settings[i].s1_val = 80;  settings[i].s2_val = 0.0 -- Blink
    elseif i == 6 then settings[i].s1_val = 150; settings[i].s2_val = 0.5 end -- Sparkles
end
for i = 1, 6 do reset_slot_to_default(i) end

local last_sw_val, last_click_time, click_count = 0, 0, 0
local last_ch14_index = 0
local flash_active, flash_next_toggle, flash_state_on, flash_pattern_count = false, 0, false, 0
local flash_r, flash_g, flash_b = 0,0,0
local s1_locked, s2_locked, s1_lock_pos, s2_lock_pos = false, false, 0, 0
local LOCK_TOLERANCE = 60 
local rgb_th_r, rgb_th_g, rgb_th_b
local rgb_pt_r, rgb_pt_g, rgb_pt_b

-- ==========================================
-- UTILS
-- ==========================================
local function triggerFlash(count, r, g, b, now)
    flash_active = true; flash_pattern_count = count * 2
    flash_r = r; flash_g = g; flash_b = b
    flash_next_toggle = now; flash_state_on = false
end

local function hsvToRgb(h, s, v)
  h = h - math.floor(h)
  local r, g, b
  local i = math.floor(h * 6); local f = h * 6 - i
  local p = v * (1 - s); local q = v * (1 - f * s); local t = v * (1 - (1 - f) * s)
  i = i % 6
  if i == 0 then r, g, b = v, t, p elseif i == 1 then r, g, b = q, v, p
  elseif i == 2 then r, g, b = p, v, t elseif i == 3 then r, g, b = p, q, v
  elseif i == 4 then r, g, b = t, p, v elseif i == 5 then r, g, b = v, p, q end
  return math.floor(r * 255), math.floor(g * 255), math.floor(b * 255)
end

local function getSmartColor(val)
    if val < 0.05 then return 0, 0, 0 
    elseif val > 0.95 then return 0, 0, 1 
    else local normalized = (val - 0.05) / 0.90; return normalized, 1, 1 end
end

local function mapRange(val, min_out, max_out)
    local norm = (val + 1024) / 2048 
    if norm < 0 then norm = 0 end; if norm > 1 then norm = 1 end
    return min_out + (norm * (max_out - min_out))
end

local function getEffectFromChannel()
    local val = getValue(SRC_EFFECT_CH)
    if val < -700 then return 1 elseif val < -350 then return 2 elseif val < -50 then return 3    
    elseif val < 350 then return 4 elseif val < 700 then return 5 else return 6 end
end

-- ==========================================
-- FROZEN FILE GENERATOR
-- ==========================================
local function get_next_filename()
    local i = 1
    while true do
        local fname = BASE_FOLDER .. BASE_NAME .. i .. ".lua"
        local f = io.open(fname, "r")
        if f then io.close(f); i = i + 1 else return fname end
        if i > 99 then return BASE_FOLDER .. BASE_NAME .. "MAX.lua" end
    end
end

-- Questa funzione restituisce SOLO il blocco di codice necessario per il tema scelto
local function get_specific_logic(id)
    if id == 1 then -- COMET
        return [[
    -- COMET (Frozen)
    local bpm = 20 + (FIXED_P2 * 100)
    local dim_bg = 0.1 + (getHeartbeat(now, bpm)*0.3)
    local r,g,b = math.floor(TH_R*dim_bg), math.floor(TH_G*dim_bg), math.floor(TH_B*dim_bg)
    if act then
        local ang = (math.deg(math.atan(v, h)) + 360) % 360
        local c_idx = math.floor(ang / 36 + 0.5) % 10
        for i = 0, 9 do
            local dist = math.abs(c_idx - i); if dist > 5 then dist = 10 - dist end
            local wave = ((math.sin(ph + (dist / 1.5)) + 1) / 2) ^ 4
            local len = 0.5 + (FIXED_P1 / 40.0)
            local ptr_int = 0
            if dist <= len then ptr_int = mag * (1.0 - (dist/len)^1.5) end
            
            local larsen_val = wave * (0.2 + (0.8 * (1.0 - mag)))
            local mask = math.max(0, 1.0 - (ptr_int * 2.0))
            local fr = (TH_R * larsen_val * mask) + (PTR_R * ptr_int)
            local fg = (TH_G * larsen_val * mask) + (PTR_G * ptr_int)
            local fb = (TH_B * larsen_val * mask) + (PTR_B * ptr_int)
            local br = (ptr_int > larsen_val) and PTR_BR or TH_BR
            setRGBLedColor(i + (ridx * 10), math.min(255, math.floor(fr*br)), math.min(255, math.floor(fg*br)), math.min(255, math.floor(fb*br)))
        end
    else
        for i=0,9 do setRGBLedColor(i+(ridx*10), r, g, b) end
    end
        ]]
    elseif id == 2 then -- RAINBOW
        return [[
    -- RAINBOW (Frozen)
    local spd = 0.05 + (FIXED_P1 / 500.0)
    local hue = (now * spd) % 1.0
    local r,g,b = hsvToRgb(hue, 1, 1)
    local dim_bg = 0.25
    if FIXED_P2 > 0.02 then dim_bg = 0.25 + (getHeartbeat(now, 45) * FIXED_P2 * 0.3) end
    r,g,b = math.floor(r*dim_bg*TH_BR), math.floor(g*dim_bg*TH_BR), math.floor(b*dim_bg*TH_BR)

    if act then
        local ang = (math.deg(math.atan(v, h)) + 360) % 360
        local c_idx = math.floor(ang / 36 + 0.5) % 10
        for i = 0, 9 do
            local dist = math.abs(c_idx - i); if dist > 5 then dist = 10 - dist end
            local wave = ((math.sin(ph + (dist / 1.5)) + 1) / 2) ^ 4
            local lr, lg, lb = hsvToRgb((now*spd) + (i*0.1), 1, 1) 
            local ptr_int = 0
            if dist < 1.0 then ptr_int = mag end
            
            local larsen_val = wave * (0.2 + (0.8 * (1.0 - mag)))
            local mask = math.max(0, 1.0 - (ptr_int * 2.0))
            local fr = (lr * larsen_val * mask) + (PTR_R * ptr_int)
            local fg = (lg * larsen_val * mask) + (PTR_G * ptr_int)
            local fb = (lb * larsen_val * mask) + (PTR_B * ptr_int)
            local br = (ptr_int > larsen_val) and PTR_BR or TH_BR
            setRGBLedColor(i + (ridx * 10), math.min(255, math.floor(fr*br)), math.min(255, math.floor(fg*br)), math.min(255, math.floor(fb*br)))
        end
    else
        for i=0,9 do setRGBLedColor(i+(ridx*10), r, g, b) end
    end
        ]]
    elseif id == 3 then -- STROBE
        return [[
    -- STROBE (Frozen)
    local freq = 10 + (FIXED_P1 * 0.2)
    local s = (math.sin(now * freq) + 1) * 0.5 
    local dim = 0.05 + (s * 0.3 * TH_BR)
    local r,g,b = math.floor(TH_R*dim), math.floor(TH_G*dim), math.floor(TH_B*dim)
    if act then
        local ang = (math.deg(math.atan(v, h)) + 360) % 360
        local c_idx = math.floor(ang / 36 + 0.5) % 10
        for i = 0, 9 do
            local dist = math.abs(c_idx - i); if dist > 5 then dist = 10 - dist end
            local wave = ((math.sin(ph + (dist / 1.5)) + 1) / 2) ^ 4
            local thr_in = 0.1 + (FIXED_P2 * 0.8)
            local ptr_int = 0
            if mag > thr_in and dist <= 1.5 then
               local flk = (math.sin(now * (10 + FIXED_P1)) + 1) / 2 
               ptr_int = mag * (1.0 - dist/1.5) * (0.4 + 0.6 * flk)
            end
            local larsen_val = wave * (0.2 + (0.8 * (1.0 - mag)))
            local mask = math.max(0, 1.0 - (ptr_int * 2.0))
            local fr = (TH_R * larsen_val * mask) + (PTR_R * ptr_int)
            local fg = (TH_G * larsen_val * mask) + (PTR_G * ptr_int)
            local fb = (TH_B * larsen_val * mask) + (PTR_B * ptr_int)
            local br = (ptr_int > larsen_val) and PTR_BR or TH_BR
            setRGBLedColor(i + (ridx * 10), math.min(255, math.floor(fr*br)), math.min(255, math.floor(fg*br)), math.min(255, math.floor(fb*br)))
        end
    else
         for i=0,9 do setRGBLedColor(i+(ridx*10), r, g, b) end
    end
        ]]
    elseif id == 4 then -- SCANNER
        return [[
    -- SCANNER (Frozen)
    local bpm = math.max(10, FIXED_P1)
    if not act then
        local pos = (math.sin(now * (bpm/60) * 5.0) + 1) * 4.5
        local gap = 0.5 + (FIXED_P2 * 2.5) 
        for i=0,9 do
            local d = math.abs(i-pos); local val = 0
            if d > gap then val = math.max(0, 1 - (d - gap)) end
            setRGBLedColor(i+(ridx*10), math.floor(TH_R*val*TH_BR), math.floor(TH_G*val*TH_BR), math.floor(TH_B*val*TH_BR))
        end
    else
        local ang = (math.deg(math.atan(v, h)) + 360) % 360
        local c_idx = math.floor(ang / 36 + 0.5) % 10
        for i = 0, 9 do
            local dist = math.abs(c_idx - i); if dist > 5 then dist = 10 - dist end
            local wave = ((math.sin(ph + (dist / 1.5)) + 1) / 2) ^ 4
            local gap = 0.5 + (FIXED_P2 * 2.5)
            local ptr_int = 0
            if dist > gap and dist < (gap + 1.5) then ptr_int = mag * (1.0 - (dist - gap)/1.5) end
            
            local larsen_val = wave * (0.2 + (0.8 * (1.0 - mag)))
            local mask = math.max(0, 1.0 - (ptr_int * 2.0))
            local fr = (TH_R * larsen_val * mask) + (PTR_R * ptr_int)
            local fg = (TH_G * larsen_val * mask) + (PTR_G * ptr_int)
            local fb = (TH_B * larsen_val * mask) + (PTR_B * ptr_int)
            local br = (ptr_int > larsen_val) and PTR_BR or TH_BR
            setRGBLedColor(i + (ridx * 10), math.min(255, math.floor(fr*br)), math.min(255, math.floor(fg*br)), math.min(255, math.floor(fb*br)))
        end
    end
        ]]
    elseif id == 5 then -- BLINK
        return [[
    -- BLINK (Frozen)
    local bpm = math.max(10, FIXED_P1)
    if not act then
        local step = 60.0/bpm; local state = math.floor(now/step) % 2
        for i=0,9 do
            if (i%2) == state then setRGBLedColor(i+(ridx*10), math.floor(TH_R*TH_BR), math.floor(TH_G*TH_BR), math.floor(TH_B*TH_BR))
            else setRGBLedColor(i+(ridx*10), 0,0,0) end
        end
    else
        local ang = (math.deg(math.atan(v, h)) + 360) % 360
        local c_idx = math.floor(ang / 36 + 0.5) % 10
        local state = math.floor(now/(60.0/bpm)) % 2
        for i = 0, 9 do
            local dist = math.abs(c_idx - i); if dist > 5 then dist = 10 - dist end
            local wave = ((math.sin(ph + (dist / 1.5)) + 1) / 2) ^ 4
            local ptr_int = 0
            if dist < 1.5 and (i%2) == state then ptr_int = mag end
            
            local larsen_val = wave * (0.2 + (0.8 * (1.0 - mag)))
            local mask = math.max(0, 1.0 - (ptr_int * 2.0))
            local fr = (TH_R * larsen_val * mask) + (PTR_R * ptr_int)
            local fg = (TH_G * larsen_val * mask) + (PTR_G * ptr_int)
            local fb = (TH_B * larsen_val * mask) + (PTR_B * ptr_int)
            local br = (ptr_int > larsen_val) and PTR_BR or TH_BR
            setRGBLedColor(i + (ridx * 10), math.min(255, math.floor(fr*br)), math.min(255, math.floor(fg*br)), math.min(255, math.floor(fb*br)))
        end
    end
        ]]
    else -- SPARKLES
        return [[
    -- SPARKLES (Frozen)
    local curve = 0.5 + (FIXED_P2 * 2.5)
    local dens = 0.98 - ( (thr^curve) * 0.5 )
    if not act then
        local flicker_spd = 10 + (FIXED_P1 * 2.0)
        for i=0,9 do
            if math.random() > dens and (math.sin(now * flicker_spd + i*1.3) > -0.2) then
               local lr,lg,lb = hsvToRgb(math.random(),1,1)
               setRGBLedColor(i+(ridx*10), math.floor(lr*TH_BR), math.floor(lg*TH_BR), math.floor(lb*TH_BR))
            else setRGBLedColor(i+(ridx*10), 0,0,0) end
        end
    else
        local ang = (math.deg(math.atan(v, h)) + 360) % 360
        local c_idx = math.floor(ang / 36 + 0.5) % 10
        for i = 0, 9 do
            local dist = math.abs(c_idx - i); if dist > 5 then dist = 10 - dist end
            local wave = ((math.sin(ph + (dist / 1.5)) + 1) / 2) ^ 4
            local ptr_int = 0
            if dist <= 1.5 then ptr_int = mag * (1.0 - (dist/2.5)) * math.random() end
            
            local larsen_val = wave * (0.2 + (0.8 * (1.0 - mag)))
            local mask = math.max(0, 1.0 - (ptr_int * 2.0))
            local fr = (TH_R * larsen_val * mask) + (PTR_R * ptr_int)
            local fg = (TH_G * larsen_val * mask) + (PTR_G * ptr_int)
            local fb = (TH_B * larsen_val * mask) + (PTR_B * ptr_int)
            local br = (ptr_int > larsen_val) and PTR_BR or TH_BR
            setRGBLedColor(i + (ridx * 10), math.min(255, math.floor(fr*br)), math.min(255, math.floor(fg*br)), math.min(255, math.floor(fb*br)))
        end
    end
        ]]
    end
end

local function save_data_as_script()
    collectgarbage()
    local final_path = get_next_filename()
    local f = io.open(final_path, "w")
    if not f then triggerFlash(10, 255, 0, 0, getTime()/100); return end 

    -- RECUPERA I DATI DEL TEMA CORRENTE (SOLO QUELLO)
    local s = settings[current_effect]
    local r_th, g_th, b_th = hsvToRgb(s.th_hue, s.th_sat, s.th_val)
    local r_pt, g_pt, b_pt = hsvToRgb(s.ptr_hue, s.ptr_sat, s.ptr_val)

    -- 1. HEADER & VARIABILI STATICHE (NIENTE INPUT LIVE!)
    io.write(f, "local ail, ele, rud, thr\n")
    io.write(f, "local phase_left, phase_right, last_time = 0, 0, 0\n")
    io.write(f, "local is_active_left, is_active_right = false, false\n")
    io.write(f, string.format("local SCAMBIA_ANELLI = %s\n", tostring(SCAMBIA_ANELLI)))
    io.write(f, string.format("local INV_GAS, INV_PICCHIA = %s, %s\n", tostring(INV_GAS), tostring(INV_PICCHIA)))
    io.write(f, string.format("local INV_ALETTONI, INV_TIMONE = %s, %s\n", tostring(INV_ALETTONI), tostring(INV_TIMONE)))
    io.write(f, "local DEAD_ZONE_HIGH, DEAD_ZONE_LOW, AXIS_LOCK = 0.18, 0.08, 0.05\n")
    io.write(f, "local MAX_VELOCITA = 1.6\n")

    -- 2. "CONGELAMENTO" PARAMETRI (HARDCODED)
    io.write(f, "-- HARDCODED SETTINGS (No Inputs)\n")
    io.write(f, string.format("local TH_R, TH_G, TH_B = %d, %d, %d\n", r_th, g_th, b_th))
    io.write(f, string.format("local PTR_R, PTR_G, PTR_B = %d, %d, %d\n", r_pt, g_pt, b_pt))
    io.write(f, string.format("local TH_BR, PTR_BR = %.3f, %.3f\n", s.th_bright, s.ptr_bright))
    io.write(f, string.format("local FIXED_P1, FIXED_P2 = %d, %.3f\n", s.s1_val, s.s2_val))
    io.write(f, "\n")

    -- 3. HELPERS
    local helpers = [[
local function hsvToRgb(h,s,v) h=h-math.floor(h); local r,g,b; local i=math.floor(h*6); local f=h*6-i; local p=v*(1-s); local q=v*(1-f*s); local t=v*(1-(1-f)*s); i=i%6; if i==0 then r,g,b=v,t,p elseif i==1 then r,g,b=q,v,p elseif i==2 then r,g,b=p,v,t elseif i==3 then r,g,b=p,q,v elseif i==4 then r,g,b=t,p,v elseif i==5 then r,g,b=v,p,q end; return math.floor(r*255), math.floor(g*255), math.floor(b*255) end
local function getHeartbeat(t, bpm) local b=math.max(10,bpm); local d=60/b; local ph=(t%d)/d; if ph<0.15 then return math.sin((ph/0.15)*3.141) elseif ph>=0.2 then local t2=ph-0.2; if t2<0.075 then return math.sin((t2/0.075)*1.57) elseif t2<0.3 then return math.cos(((t2-0.075)/0.225)*1.57) end end return 0 end
local function applyAxisLock(h,v) if math.abs(v)>0.5 and math.abs(h)<0.05 then h=0 end; if math.abs(h)>0.5 and math.abs(v)<0.05 then v=0 end; return h,v end
]]
    io.write(f, helpers)

    -- 4. SCRIVE SOLO LA LOGICA DEL TEMA CORRENTE
    io.write(f, "local function drawRing(ridx, h, v, ph, now, act, thr)\n")
    io.write(f, "  local mag = math.sqrt(h^2 + v^2); if mag > 1.0 then mag = 1.0 end\n")
    io.write(f, get_specific_logic(current_effect)) -- <--- Solo il blocco del tema scelto
    io.write(f, "end\n\n")

    -- 5. RUN FUNCTION PULITA (NIENTE INPUT EXTRA)
    local runCode = [[
local function run(event)
  local now = getTime() / 100
  local dt = now - last_time
  last_time = now
  
  -- Inputs: SOLO gli stick di volo, niente potenziometri
  local ra, re, rt, rr = getValue("ail")/1024, getValue("ele")/1024, getValue("thr")/1024, getValue("rud")/1024
  if INV_ALETTONI then ra=-ra end; if INV_PICCHIA then re=-re end; if INV_GAS then rt=-rt end; if INV_TIMONE then rr=-rr end
  local th_val = (rt+1)/2; if th_val<0 then th_val=0 end; if th_val>1 then th_val=1 end
  local pl_h, pl_v = applyAxisLock(rr, rt); local pr_h, pr_v = applyAxisLock(ra, re)
  local mL, mR = math.sqrt(pl_h^2+pl_v^2), math.sqrt(pr_h^2+pr_v^2)
  if mL>1 then mL=1 end; if mR>1 then mR=1 end
  is_active_left = (mL > (is_active_left and DEAD_ZONE_LOW or DEAD_ZONE_HIGH))
  is_active_right = (mR > (is_active_right and DEAD_ZONE_LOW or DEAD_ZONE_HIGH))
  local spd = MAX_VELOCITA * 6.28
  phase_left = phase_left + (is_active_left and mL*spd or 0) * dt
  phase_right = phase_right + (is_active_right and mR*spd or 0) * dt
  if phase_left > 1000 then phase_left = phase_left - 628 end
  if phase_right > 1000 then phase_right = phase_right - 628 end
  local iL, iR = SCAMBIA_ANELLI and 1 or 0, SCAMBIA_ANELLI and 0 or 1
  drawRing(iL, pl_h, pl_v, phase_left, now, is_active_left, th_val)
  drawRing(iR, pr_h, pr_v, phase_right, now, is_active_right, th_val)
  applyRGBLedColors()
end
return { run=run }
]]
    io.write(f, runCode)
    io.close(f)
    triggerFlash(1, 0, 255, 0, getTime()/100) 
end

-- ==========================================
-- ANTEPRIMA (Preview per Configurazione)
-- ==========================================
local function getHeartbeat(t, bpm) 
    local b=math.max(10,bpm); local d=60/b; local ph=(t%d)/d
    if ph<0.15 then return math.sin((ph/0.15)*3.141) 
    elseif ph>=0.2 then local t2=ph-0.2
        if t2<0.075 then return math.sin((t2/0.075)*1.57) 
        elseif t2<0.3 then return math.cos(((t2-0.075)/0.225)*1.57) end 
    end return 0 
end

local function drawRingPreview(ridx, h, v, ph, now, act, thr)
  if flash_active then 
      if flash_state_on then for i=0,9 do setRGBLedColor(i+(ridx*10),flash_r,flash_g,flash_b) end 
      else for i=0,9 do setRGBLedColor(i+(ridx*10),0,0,0) end end; return
  end
  local mag = math.sqrt(h^2 + v^2); if mag > 1.0 then mag = 1.0 end
  local cfg = settings[current_effect]
  local p1, p2 = cfg.s1_val, cfg.s2_val 

  if not act then
    -- PREVIEW BACKGROUNDS
    local r,g,b = 0,0,0
    if current_effect == 1 then -- COMET BG
        local bpm = 20 + (p2 * 100) 
        local dim = 0.1 + (getHeartbeat(now, bpm)*0.3)
        r,g,b = math.floor(rgb_th_r*dim), math.floor(rgb_th_g*dim), math.floor(rgb_th_b*dim)

    elseif current_effect == 2 then -- RAINBOW BG
        local spd = 0.05 + (p1 / 500.0)
        local hue = (now * spd) % 1.0
        r,g,b = hsvToRgb(hue, 1, 1)
        
        -- S2 Logic for Preview
        local dim = 0.25
        if p2 > 0.02 then 
            dim = 0.25 + (getHeartbeat(now, 45) * p2 * 0.3)
        end
        r,g,b = math.floor(r*dim*cfg.th_bright), math.floor(g*dim*cfg.th_bright), math.floor(b*dim*cfg.th_bright)

    elseif current_effect == 3 then -- STROBE BG
        local freq = 10 + (p1 * 0.2)
        local s = (math.sin(now * freq) + 1) * 0.5 
        local dim = 0.05 + (s * 0.3 * cfg.th_bright)
        r,g,b = math.floor(rgb_th_r*dim), math.floor(rgb_th_g*dim), math.floor(rgb_th_b*dim)

    elseif current_effect == 4 then -- SCANNER BG
        local bpm = math.max(10, p1)
        local pos = (math.sin(now * (bpm/60) * 5.0) + 1) * 4.5
        local gap = 0.5 + (p2 * 2.5) 
        for i=0,9 do
            local d = math.abs(i-pos)
            local val = 0
            if d > gap then val = math.max(0, 1 - (d - gap)) end
            setRGBLedColor(i+(ridx*10), math.floor(rgb_th_r*val*cfg.th_bright), math.floor(rgb_th_g*val*cfg.th_bright), math.floor(rgb_th_b*val*cfg.th_bright))
        end return

    elseif current_effect == 5 then -- BLINK BG
        local bpm = math.max(10, p1)
        local step = 60.0/bpm
        local state = math.floor(now/step) % 2
        for i=0,9 do
            if (i%2) == state then
                r,g,b = math.floor(rgb_th_r*cfg.th_bright), math.floor(rgb_th_g*cfg.th_bright), math.floor(rgb_th_b*cfg.th_bright)
            else r,g,b=0,0,0 end
            setRGBLedColor(i+(ridx*10), r, g, b)
        end return

    elseif current_effect == 6 then -- SPARKLES BG
        local curve = 0.5 + (p2 * 2.5)
        local dens = 0.98 - ( (thr^curve) * 0.5 )
        local flicker_spd = 10 + (p1 * 2.0)
        for i=0,9 do
            if math.random() > dens and (math.sin(now * flicker_spd + i*1.3) > -0.2) then
               local lr,lg,lb = hsvToRgb(math.random(),1,1)
               setRGBLedColor(i+(ridx*10), math.floor(lr*cfg.th_bright), math.floor(lg*cfg.th_bright), math.floor(lb*cfg.th_bright))
            else setRGBLedColor(i+(ridx*10), 0,0,0) end
        end return
    end
    for i=0,9 do setRGBLedColor(i+(ridx*10), r, g, b) end
  else
    -- PREVIEW POINTERS
    local ang = (math.deg(math.atan(v, h)) + 360) % 360
    local c_idx = math.floor(ang / 36 + 0.5) % 10
    
    for i = 0, 9 do
      local dist = math.abs(c_idx - i); if dist > 5 then dist = 10 - dist end
      local wave = ((math.sin(ph + (dist / 1.5)) + 1) / 2) ^ 4
      
      local lr, lg, lb = rgb_th_r, rgb_th_g, rgb_th_b
      if current_effect == 2 then 
          local spd = 0.05 + (p1 / 500.0)
          lr, lg, lb = hsvToRgb((now*spd) + (i*0.1), 1, 1) 
      end

      local ptr_int = 0
      if current_effect == 1 then -- COMETA
          local len = 0.5 + (p1 / 40.0) 
          local crv = 1.5 
          if dist <= len then ptr_int = mag * (1.0 - (dist/len)^crv) end
      elseif current_effect == 2 then -- RAINBOW
           if dist < 1.0 then ptr_int = mag else ptr_int = 0 end
      elseif current_effect == 3 then -- STROBE
          local thr_in = 0.1 + (p2 * 0.8) 
          if mag > thr_in and dist <= 1.5 then
             local flk = (math.sin(now * (10 + p1)) + 1) / 2 
             ptr_int = mag * (1.0 - dist/1.5) * (0.4 + 0.6 * flk)
          end
      elseif current_effect == 4 then -- SCANNER
          local gap = 0.5 + (p2 * 2.5) 
          if dist > gap and dist < (gap + 1.5) then
              ptr_int = mag * (1.0 - (dist - gap)/1.5)
          end
      elseif current_effect == 5 then -- BLINK
          local bpm = math.max(10, p1)
          local state = math.floor(now/(60.0/bpm)) % 2
          if dist < 1.5 and (i%2) == state then ptr_int = mag end
      else -- SPARKLES
          if dist <= 1.5 then ptr_int = mag * (1.0 - (dist/2.5)) * math.random() end
      end

      if ptr_int < 0 then ptr_int = 0 end

      local larsen_val = wave * (0.2 + (0.8 * (1.0 - mag)))
      local mask = math.max(0, 1.0 - (ptr_int * 2.0))
      
      local fr, fg, fb
      fr = (lr * larsen_val * mask) + (rgb_pt_r * ptr_int)
      fg = (lg * larsen_val * mask) + (rgb_pt_g * ptr_int)
      fb = (lb * larsen_val * mask) + (rgb_pt_b * ptr_int)
      
      local br = (ptr_int > larsen_val) and cfg.ptr_bright or cfg.th_bright
      setRGBLedColor(i + (ridx * 10), math.min(255, math.floor(fr*br)), math.min(255, math.floor(fg*br)), math.min(255, math.floor(fb*br)))
    end
  end
end

local function applyAxisLock(h, v)
    if math.abs(v) > 0.5 and math.abs(h) < AXIS_LOCK then h = 0 end
    if math.abs(h) > 0.5 and math.abs(v) < AXIS_LOCK then v = 0 end
    return h, v
end

-- ==========================================
-- MAIN RUN (USER INTERFACE)
-- ==========================================
local function run(event)
  local now = getTime() / 100
  local dt = now - last_time
  last_time = now

  local ch_idx = getEffectFromChannel()
  if last_ch14_index == 0 then last_ch14_index = ch_idx end

  if menu_level == 1 then
      if ch_idx ~= last_ch14_index then
          current_effect = ch_idx; last_ch14_index = ch_idx
          triggerFlash(1, 255, 255, 255, now) 
          s1_locked = true; s1_lock_pos = getValue(SRC_POT_1)
          s2_locked = true; s2_lock_pos = getValue(SRC_POT_2)
      end
  else last_ch14_index = ch_idx end

  local sw_val = getValue(SRC_MENU_TRIGGER)
  if sw_val > 0 and last_sw_val <= 0 then
      if (now - last_click_time) < 0.8 then click_count = click_count + 1 else click_count = 1 end
      last_click_time = now
  end
  last_sw_val = sw_val

  if click_count >= 2 then
      menu_level = menu_level + 1
      if menu_level > 4 then menu_level = 0 end 
      click_count = 0 
      s1_lock_pos = getValue(SRC_POT_1); s1_locked = true
      s2_lock_pos = getValue(SRC_POT_2); s2_locked = true
      
      if menu_level == 0 then save_data_as_script() 
      elseif menu_level == 1 then triggerFlash(1, 255, 255, 255, now) 
      elseif menu_level == 2 then triggerFlash(2, 255, 255, 255, now) 
      elseif menu_level == 3 then triggerFlash(3, 255, 255, 255, now) 
      elseif menu_level == 4 then triggerFlash(4, 255, 255, 255, now) end 
  end

  if flash_active then
      if now >= flash_next_toggle then
          flash_pattern_count = flash_pattern_count - 1
          if flash_pattern_count < 0 then flash_active = false 
          else flash_state_on = not flash_state_on; flash_next_toggle = now + 0.12 end
      end
  end

  local raw_s1 = getValue(SRC_POT_1)
  local raw_s2 = getValue(SRC_POT_2)
  if s1_locked and math.abs(raw_s1 - s1_lock_pos) > LOCK_TOLERANCE then s1_locked = false end
  if s2_locked and math.abs(raw_s2 - s2_lock_pos) > LOCK_TOLERANCE then s2_locked = false end
  local norm_s1 = (raw_s1 + 1024) / 2048; if norm_s1 < 0 then norm_s1=0 end; if norm_s1>1 then norm_s1=1 end
  local norm_s2 = (raw_s2 + 1024) / 2048; if norm_s2 < 0 then norm_s2=0 end; if norm_s2>1 then norm_s2=1 end

  local cfg = settings[current_effect]
  
  if menu_level == 2 then
      if not s1_locked then cfg.th_hue, cfg.th_sat, cfg.th_val = getSmartColor(norm_s1) end 
      if not s2_locked then cfg.ptr_hue, cfg.ptr_sat, cfg.ptr_val = getSmartColor(norm_s2) end 
  elseif menu_level == 3 then
      if not s1_locked then cfg.th_bright = norm_s1 end 
      if not s2_locked then cfg.ptr_bright = norm_s2 end 
  elseif menu_level == 4 then
      if not s1_locked then cfg.s1_val = mapRange(raw_s1, 10, 200) end 
      if not s2_locked then cfg.s2_val = mapRange(raw_s2, 0.0, 1.0) end 
  end

  rgb_th_r, rgb_th_g, rgb_th_b = hsvToRgb(cfg.th_hue, cfg.th_sat, cfg.th_val)
  rgb_pt_r, rgb_pt_g, rgb_pt_b = hsvToRgb(cfg.ptr_hue, cfg.ptr_sat, cfg.ptr_val)

  local raw_ail, raw_ele = getValue("ail")/1024, getValue("ele")/1024
  local raw_thr, raw_rud = getValue("thr")/1024, getValue("rud")/1024
  if INV_ALETTONI then raw_ail = -raw_ail end
  if INV_PICCHIA  then raw_ele = -raw_ele end
  if INV_GAS      then raw_thr = -raw_thr end
  if INV_TIMONE   then raw_rud = -raw_rud end

  local thr_val = (raw_thr + 1) / 2
  if thr_val < 0 then thr_val = 0 end; if thr_val > 1 then thr_val = 1 end

  local phys_left_h, phys_left_v = applyAxisLock(raw_rud, raw_thr)
  local phys_right_h, phys_right_v = applyAxisLock(raw_ail, raw_ele)
  local mag_L = math.sqrt(phys_left_h^2 + phys_left_v^2)
  local mag_R = math.sqrt(phys_right_h^2 + phys_right_v^2)
  if mag_L > 1 then mag_L = 1 end; if mag_R > 1 then mag_R = 1 end

  is_active_left = (mag_L > (is_active_left and DEAD_ZONE_LOW or DEAD_ZONE_HIGH))
  is_active_right = (mag_R > (is_active_right and DEAD_ZONE_LOW or DEAD_ZONE_HIGH))

  local speed_coeff = MAX_VELOCITA * 6.28
  phase_left = phase_left + (is_active_left and mag_L*speed_coeff or 0) * dt
  phase_right = phase_right + (is_active_right and mag_R*speed_coeff or 0) * dt
  if phase_left > 1000 then phase_left = phase_left - 628 end
  if phase_right > 1000 then phase_right = phase_right - 628 end

  local idx_L, idx_R = SCAMBIA_ANELLI and 1 or 0, SCAMBIA_ANELLI and 0 or 1
  drawRingPreview(idx_L, phys_left_h, phys_left_v, phase_left, now, is_active_left, thr_val)
  drawRingPreview(idx_R, phys_right_h, phys_right_v, phase_right, now, is_active_right, thr_val)
  
  applyRGBLedColors()
end

local function background() end
local function init()
    last_ch14_index = getEffectFromChannel()
end
return { run=run, background=background, init=init }