-- TARANIJUKE File: SCRIPTS\MODELnn\telem5_BgMusDisp.lua Rev:20150321_1100
-- OpenTX 2.0.12+ LUA telemetry display script.
-- (c) 2015 Jeffrey Michael Roberson.
-- MIT License: http://www.opensource.org/licenses/mit-license.php

-- Display currently playing TaraniJuke playlist info (if any).
local function run_BgMusDisp()                  -- Main "run" function of telemetry LUA script.
    local tmr                                   -- Table used by: model.getTimer() and setTimer().
    local ipl                                   -- Index to current/next playlist table entry.
    if tjg then                                 -- Check if TJuke LUA model mix script loaded.
        if tjggo() then                         -- Check if all special functions setup correctly.
            ipl = tjg.npl                       -- Local copy of global next-up playlist index.
            tmr = model.getTimer(tjg.itimer)    -- Fetch data for our timer from OTX.
            if tjg.title then lcd.drawScreenTitle(tjg.title, ipl, #(tjg.pl)) end
            if tjg.pl[ipl].year then lcd.drawText(158, 0, tjg.pl[ipl].year, 0) end
            if tjg.ipl == tjg.npl then
                if tjg.playlistname then lcd.drawText(1, 10, tjg.playlistname, MIDSIZE) end
                if tmr then
                    lcd.drawGauge(0, 24, 211, 4, tjg.pl[ipl].tbase + (tjg.pl[ipl].len - tmr.value), tjg.duration)
                    lcd.drawGauge(0, 60, 211, 4, tmr.start - tmr.value, tmr.start)
                end
            else
                lcd.drawText(1, 10, "Next up:", MIDSIZE)
                if tmr then lcd.drawGauge(0, 24, 211, 4, tjg.pl[ipl].tbase, tjg.duration) end
            end
            if tjg.durationf and tjg.pl[ipl].lenf then
                lcd.drawText(95, 10, tjg.durationf.." "..tjg.pl[ipl].lenf, MIDSIZE)
            end
            if tmr then lcd.drawText(188, 10, ""..tmr.value, MIDSIZE) end
            if tjg.pl[ipl].artist then lcd.drawText(10, 31, tjg.pl[ipl].artist, MIDSIZE) end
            if tjg.pl[ipl].title then lcd.drawText(10, 45, tjg.pl[ipl].title, MIDSIZE) end
        else
            if tjg.title then lcd.drawScreenTitle(tjg.title,0, #(tjg.pl)) end
            lcd.drawText(10, 20, "Taranijuke setup problem", MIDSIZE)
            if tjg.msg then lcd.drawText(5, 40, tjg.msg, 0) end
        end
    else -- There is no active playlist, (tjg.pl is not defined). Display message.
        lcd.drawScreenTitle("TaraniJuke Rev:20150321_1100",0,0)
        lcd.drawText(10, 20, "Taranijuke setup problem", MIDSIZE)
        lcd.drawText(5, 40, "Load a TJuke LUA model CUSTOM SCRIPT", 0)
    end
end
return { run=run_BgMusDisp }                    -- End SCRIPTS\MODELnn\telem5_BgMusDisp.lua.