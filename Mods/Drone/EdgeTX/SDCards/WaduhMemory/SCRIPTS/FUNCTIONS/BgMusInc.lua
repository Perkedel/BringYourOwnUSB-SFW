-- TARANIJUKE File: SCRIPTS\FUNCTIONS\BgMusInc.lua Rev:20150321_1100
-- OpenTX 2.0.12+ LUA special function script.
-- (c) 2015 Jeffrey Michael Roberson.
-- MIT License: http://www.opensource.org/licenses/mit-license.php

-- Incremet through TaraniJuke playlist via special function LUA script.
local t_next = 0                                    -- Earliest time allowed for next run.
local function run_BgMusicInc()                     -- Main "run" function of special function LUA script.
    local t                                         -- Value returned by system getTime().
    if tjg then                                     -- Only proceed if model mix script running.
        t = getTime()                               -- Current time (integer 1/100 sec per count).
        if t > t_next then                          -- If time window open...
            t_next = t + 33                         -- Limit run time frequency (Scroll at about 3 Hz).
            if tjggo() then                         -- If all special funcs good...
                tjg.npl = tjg.npl + 1               -- Increment to next file in playlist.
                if tjg.npl > #(tjg.pl) then tjg.npl = 1 end -- Wrap around as needed.
            end
        end
    end
end
return { run=run_BgMusicInc }                       -- End SCRIPTS\FUNCTIONS\BgMusInc.lua.