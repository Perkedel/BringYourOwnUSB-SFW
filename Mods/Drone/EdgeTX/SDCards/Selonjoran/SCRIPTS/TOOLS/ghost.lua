-- Ghost game written by Fig Newton 6/4/2014
-- Hook up a trainer to your Master and see if the trainee can keep
-- up with you while flying a plane. The lua script will take the 
-- Aileron, Trainer Aileron, Elevator, and Trainer Elevator inputs and calculate
-- the distance and whether or not they are out of bounds based on the Tail value
-- set by the user.
-- The script returns a Ghst value that can be used on the Master transmitter to 
-- set up a Logical Switch based on value that can trigger a Special Function to 
-- play a beep indicating that the trainee has moved his stick past the tail value.



local inputs = { { "Aileron", SOURCE }, { "Trainr Aileron", SOURCE }, { "Elevator", SOURCE }, { "Trainr Elevator", SOURCE }, { "Ghost tail", VALUE, 0, 100, 25 } }

local outputs = { "Ghst" }

local function run_func(ail, tail, elev, telev, ghost)
	-- Set ghost to the proper value to compare to stick input
	-- Multiplying by 10.24 will let the player use 0-100
	ghost = ghost * 10.24
	-- Initialize the return value (0=false, 10= Ail true, 20= Ele True, 30=Both True)
	local ghstretval = 0

	-- This is where you compare the inputs. Subtract the absolute value of 
	-- trainer stick input from the master stick input and
	-- then see if it's greater than the ghost value
	if ( math.abs(ail - tail) >= ghost ) then
		ghstretval = ghstretval + 102.4
	end

	-- Same math, but for the elevator inputs
	if ( math.abs(elev - telev) >= ghost ) then
		ghstretval = ghstretval + 204.9
	end

	-- If ghstretval=10 then the Aileron is out of bounds. 
	-- If ghstretval=20 then the Elevator is out of bounds.
	-- If ghstretval=30 then both Aileron and Elevator are out of bounds.
	return ghstretval
end

-- Return statement
return { run=run_func, input=inputs, output=outputs }
