-- TARANIJUKE File: SCRIPTS\FUNCTIONS\BgMusNxt.lua Rev:20150321_1100
-- OpenTX 2.0.12+ LUA special function script.
-- (c) 2015 Jeffrey Michael Roberson.
-- MIT License: http://www.opensource.org/licenses/mit-license.php

-- Play next TaraniJuke song in playlist.
local t_next = 0                                    -- Earliest time allowed for next run.
local function run_BgMusicNxt()                     -- Main "run" function of special function LUA script.
    local tmr                                       -- Structure used by getTimer() & setTimer().
    local t                                         -- Value returned by system getTime().
    if tjg then                                     -- Only proceed if model mix script running.
        t = getTime()                               -- Current time (integer 1/100 sec per count).
        if t > t_next then                          -- If time window open...
            t_next = t + 100                        -- Next run time (wait at least one second).
            if tjggo() then                         -- If all special funcs good...
                if tjg.ipl == tjg.npl then          -- Auto-increment when current song plays all the way out.
                    tjg.npl = tjg.npl + 1           -- Increment to next file in playlist.
                    if tjg.npl > #(tjg.pl) then tjg.npl = 1 end   -- Wrap around as needed.
                end
                tjg.sfBGMUSIC.name = tjg.pl[tjg.npl].name   -- Load OTX SF table entry with next song.
                model.setCustomFunction(tjg.isfBGMUSIC, tjg.sfBGMUSIC)  -- Load next BGMUSIC special function song file name.
                tmr = model.getTimer(tjg.itimer)    -- Fetch timer data table.
                tmr.start = tjg.pl[tjg.npl].len     -- Load new timer duration.
                tmr.value = tjg.pl[tjg.npl].len     -- Load new timer current pointer.
                model.setTimer(tjg.itimer, tmr)     -- Load new TImer 1 duration to match song length.
                tjg.ipl = tjg.npl                   -- Set ipl == "currently playing" playlist index.
            end
        end
    end
end
return { run=run_BgMusicNxt }                       -- End SCRIPTS\FUNCTIONS\BgMusNxt.lua