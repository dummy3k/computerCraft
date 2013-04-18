fuel_slot = nil

-- X<--------+
--     S     |
--     |     |
--   E-+-W   |
--     |     |
--     N     |
--           v [Z]

--directions = {north=0, east=1, south=2, west=3, up=4, down=5}
directions = {north=2, east=3, south=0, west=1, up=4, down=5}
current_direction = nil

function select(value)
	return turtle.select(value)
end

function compare()
	return turtle.compare()
end

function compareUp()
	return turtle.compareUp()
end

function compareDown()
	return turtle.compareDown()
end

function compareTo(value)
	return turtle.compareTo(value)
end

function detect()
	return turtle.detect()
end

function detectUp()
	return turtle.detectUp()
end

function detectDown()
	return turtle.detectDown()
end

function getItemCount(value)
	return turtle.getItemCount(value)
end

function craft()
	if not turtle.craft() then error("crafting failed") end
end

function suck()
	return turtle.suck()
end

function suckDown()
	return turtle.suckDown()
end

function dropDown()
	return turtle.dropDown()
end

function placeDown()
	if not turtle.placeDown() then
		error("placeDown failed")
	end
end

function place(place_direction)
	if not place_direction then place_direction = "forward" end
	if place_direction == "up" then
		return turtle.placeUp()
	elseif place_direction == "down" then
		return turtle.placeDown()
	elseif place_direction == "forward" then
		return turtle.place()
	else
		error("bad argument: " .. place_direction)
	end
end

function dig(dig_direction, action)
	if not dig_direction then dig_direction = "forward" end
	
	if dig_direction == "false" then
		dig_direction = "forward"
		action = "false"
	end

	turtle.select(1)
	if dig_direction == "up" then
		retval = turtle.digUp()
	elseif dig_direction == "down" then
		retval = turtle.digDown()
	elseif dig_direction == "forward" then
		retval = turtle.dig()
	else
		error("bad argument: " .. dig_direction)
	end
	
	if retval then return true end
	if action == "false" then return false end
	error("dig failed: " .. dig_direction)
end

function drop(cnt, drop_direction)
	--if not cnt then cnt = turtle.getItemCount(turtle. end
	if not drop_direction then drop_direction = "forward" end
	if drop_direction == "up" then
		return turtle.dropUp(cnt)
	elseif drop_direction == "down" then
		return turtle.dropDown(cnt)
	elseif drop_direction == "forward" then
		return turtle.drop(cnt)
	else
		error("bad argument: " .. drop_direction)
	end
end

function dropAll(drop_direction)
	if not drop_direction then drop_direction = "forward" end
	if drop_direction == "up" then
		return turtle.dropUp()
	elseif drop_direction == "down" then
		return turtle.dropDown()
	elseif drop_direction == "forward" then
		return turtle.drop()
	else
		error("bad argument: " .. drop_direction)
	end
end

function digUp()
	turtle.select(1)
	while turtle.detectUp() and turtle.digUp() do
		if afterDigFn then afterDigFn("up") end
		os.sleep(1)
	end
end

function digDown()
	turtle.select(1)
	if not turtle.detectDown() then return false end
	if not turtle.digDown() then return false end
	if afterDigFn then afterDigFn("down") end
	return true
end

function turnRight(count)
	if not count then count = 1 end
	for i=1, count, 1 do
		turtle.turnRight()
		if current_direction then
			current_direction = (current_direction + 1) % 4
		end
	end

end

function turnLeft(count)
	if not count then count = 1 end
	for i=1, count, 1 do
		turtle.turnLeft()
		if current_direction then
			current_direction = (current_direction + 3) % 4
		end
	end
end

function turnNorth()
	turnTo(directions.north)
end

function turnEast()
	turnTo(directions.east)
end

function turnSouth()
	turnTo(directions.south)
end

function turnWest()
	turnTo(directions.west)
end

function forward(count, action, action2)
	--[[
	while turtle.detect() do
		if not turtle.dig() then
			error("forward failed, something is in the way!")
		end
		os.sleep(1)
	end
	refuel()
	if not turtle.forward() then
		error("cant go forward!")
	end
	]]--
	return move("forward", count, action, action2)
end

function up(count, action, action2)
	return move("up", count, action, action2)
end

function down(count, action, action2)
	return move("down", count, action, action2)
end

function back(count, action)
	move("back", count, action)
end

--[[
function back(n, action)
	refuel()
	if not turtle.back() then
		error("cant go back!")
	end
end

function down(n, action)
	if not n then n = 1 end
	print("n: " .. n)
	for i=1,n,1 do
		if action == "dig" then
			if turtle.detectDown() then
				turtle.select(1)
				if not turtle.digDown() then
					error("cant dig down")
				end
			end
		end
		if not turtle.down() then
			error("cant dig down")
		end
	end
end
]]--

-- to_direction: forward, up, down
function move(to_direction, count, action, action2)
	all_fn = {forward={move=turtle.forward, dig=turtle.dig, detect=turtle.detect},
		      back={move=turtle.back},
		      up={move=turtle.up, dig=turtle.digUp, detect=turtle.detectUp},
			  down={move=turtle.down, dig=turtle.digDown, detect=turtle.detectDown}}
	fn = all_fn[to_direction]
	if not fn then error("bad direction") end
	if not fn.move then error("wtf") end
	
	if to_direction == "back" and action == "dig" then error("cant dig backwards") end
	
	if not count then count = 1 end
	for i=1, count, 1 do
		if action == "dig" then
			turtle.select(1)
			while fn.detect() and fn.dig() do
				if afterDigFn then afterDigFn("forward") end
				os.sleep(1)
			end
			--[[
			if fn.detect() then
				turtle.select(1)
				if not fn.dig() then
					error("cant dig down")
				end
			end
			]]--
		end
		refuel()
		if not fn.move() then
			if action == "false" or action2 == "false" then return false end
			error("cant move: " .. to_direction)
		end
	end
	return true
end

function setFuelSlot(value)
	fuel_slot = value
end

fuel_ender = nil
function setFuelEnder(value)
	fuel_ender = value
end

afterDigFn = nil

function setAfterDig(fn)
	afterDigFn = fn
end

function refuel(fuel_min)
	if not fuel_min then fuel_min = 1 end

	if turtle.getFuelLevel() > fuel_min then
		return true
	end
	
	if not fuel_slot then
		error("no fuel slot selected")
	end
	
	--[[
	if turtle.getItemCount(fuel_slot) < 2 then
		if not fuel_ender then error("not enough fuel") end
		
		turtle.select(fuel_ender)
		if not turtle.placeUp() then error("cant place chest") end
		turtle.select(fuel_slot)
		turtle.suck()
		turtle.digUp()
			
	end
	]]--
	
	turtle.select(fuel_slot)
	while turtle.getFuelLevel() < fuel_min and turtle.getItemCount(fuel_slot) > 1 and turtle.refuel(1) do
		print("refuel: ".. turtle.getFuelLevel())
	end
	if turtle.getFuelLevel() < fuel_min then error("not enough fuel") end
end

function getDirection()
	if current_direction then
		return current_direction
	end
	
	local up_cnt = 0
	repeat
		for i=1, 4, 1 do
			if not turtle.detect() then
				break
			end
			turtle.turnLeft()
		end
		if turtle.detect() then
			up()
			up_cnt = up_cnt + 1
		end
	until not turtle.detect()
	
	--x1, y1, z1 = gps.locate(1, false)
	pos1 = getLocation()
	forward()
	--x2, y2, z2 = gps.locate(1, false)
	pos2 = getLocation()
	back()
	down(up_cnt)
	
	--if not x1 then error("could not get x1") end
	--if not x2 then error("could not get x2") end
	
	if pos1.x > pos2.x then
		current_direction = directions.west
	elseif pos1.x < pos2.x then
		current_direction = directions.east
	elseif pos1.z > pos2.z then
		current_direction = directions.north
	elseif pos1.z < pos2.z then
		current_direction = directions.south
	else
		error("wtf")
	end
	
	return current_direction
end

function turnTo(to_direction)
	--[[
			 N 2
	          |
	          |
		W 1 --+-- E 3
	          |
	          |
	         S 0
	]]--
	while getDirection() ~= to_direction do
		turnLeft()
	end
end

function getLocation()
	local x, y, z = gps.locate(1, false)
	if not x or not y or not z then 
		print("could not get position. try opening modem")
		rednet.open("right")
		x, y, z = gps.locate(1, false)
	end
	if not x or not y or not z then 
		x, y, z = gps.locate(1, true)
	end
	if not x or not y or not z then error("cant get location") end
	return vector.new(x, y, z)
end

function upForward(cnt)
	
	for i=1,cnt,1 do
		local fail_cnt = 0
		while not turtle.forward() do
			up()
			fail_cnt = fail_cnt + 1
			if fail_cnt > 10 then
				--down(10)
				error("cant go forward, even up to 10")
			end
		end
	end
end

function goto(x, y, z)
	if not y and not z then
		y = x.y
		z = x.z
		x = x.x
	end
	local loc = getLocation()
	local x1, y1, z1 = gps.locate(1, false)
	
	if x > x1 then
		turnTo(directions.east)
		upForward(x - x1)
		
	elseif x < x1 then
		turnTo(directions.west)
		upForward(x1 - x)
	end

	if z > z1 then
		turnTo(directions.south)
		upForward(z - z1)
		
	elseif z < z1 then
		turnTo(directions.north)
		upForward(z1 - z)
	end
	
	local loc = getLocation()
	if loc.y > y then
		down(loc.y - y)
	elseif loc.y < y then
		up(y - loc.y)
	end
end

function goto3(x, y, z, action)
	local loc = getLocation()
	local x1, y1, z1 = gps.locate(1, false)
	
	if x > x1 then
		turnTo(directions.east)
		forward(x - x1, action)
		
	elseif x < x1 then
		turnTo(directions.west)
		forward(x1 - x, action)
	end

	if z > z1 then
		turnTo(directions.south)
		forward(z - z1, action)
		
	elseif z < z1 then
		turnTo(directions.north)
		forward(z1 - z, action)
	end
end

function goto2(x, y, z)
	x1, y1, z1 = gps.locate(1, false)
	forward(1, "dig")
	x2, y2, z2 = gps.locate(1, false)
	
	direction = -1
	if x < x2 then
		if x1 < x2 then
			turtle.turnLeft()
			turtle.turnLeft()
		elseif x1 == x2 then
			if z1 < z2 then
				turtle.turnRight()
			else
				turtle.turnLeft()
			end
		end
		while x2 > x do
			forward(1, "dig")
			x2, y2, z2 = gps.locate(1, false)
		end
		direction = 3
	elseif x > x2 then
		if x1 > x2 then
			turtle.turnLeft()
			turtle.turnLeft()
		elseif x1 == x2 then
			if z1 < z2 then
				turtle.turnLeft()
			else
				turtle.turnRight()
			end
		end
		while x2 < x do
			forward(1, "dig")
			x2, y2, z2 = gps.locate(1, false)
		end
		direction = 1
	elseif z1 < z2 then
		direction = 2
	elseif z1 > z2 then
		direction = 0
	else
		error("wtf")
	end

	if z2 > z then
		if direction == 1 then
			turtle.turnLeft()
		elseif direction == 3 then
			turtle.turnRight()
		elseif direction == 2 then
			turtle.turnRight()
			turtle.turnRight()
		end
		while z2 > z do
			forward(1, "dig")
			x2, y2, z2 = gps.locate(1, false)
		end
	else
		if direction == 1 then
			turtle.turnRight()
		elseif direction == 3 then
			turtle.turnLeft()
		elseif direction == 0 then
			turtle.turnRight()
			turtle.turnRight()
		end
		while z2 < z do
			forward(1, "dig")
			x2, y2, z2 = gps.locate(1, false)
		end
	end
	
	-- orient to north
	print("direction: " .. direction)
	if direction == 0 then
	elseif direction == 1 then
		--turtle.turnLeft()
	elseif direction == 2 then
		turtle.turnLeft()
		turtle.turnLeft()
	elseif direction == 3 then
		--turtle.turnRight()
	end
	
	x2, y2, z2 = gps.locate(1, false)
	if y2 < y then
		while y2 < y do
			digUp()
			x2, y2, z2 = gps.locate(1, false)
		end
	else
		while y2 > y do
			digDown()
			x2, y2, z2 = gps.locate(1, false)
		end
	end
	
end


local tArgs = {...}
cmd = tArgs[1]
if cmd == "goto" then
	goto(tonumber(tArgs[2]), tonumber(tArgs[3]), tonumber(tArgs[4]))
	
	if tArgs[5] == "N" then
		turnNorth()
	elseif tArgs[5] == "E" then
		turnEast()
	elseif tArgs[5] == "S" then
		turnSouth()
	elseif tArgs[5] == "W" then
		turnWest()
	end
end
