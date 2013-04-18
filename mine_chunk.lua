if not os.loadAPI("fox") then error("could not load 'fox'") end
if not os.loadAPI("util") then error("could not load 'util'") end
-- 96	<= x < 112
-- -926 < z <= -912
-- -928 < z <= -912
--box = {{96, 112}, 72, {-928, -912}}
--box = {{96, 112}, 72, {-928, -912}}

slot_fuel = 1
slot_torch = 2
slot_torch_chest = 3
slot_drop_chest = 4
slot_max = 5
 
function beginTransaction(source)
	if not source then error("bad argument: source") end
	
	f = io.open("var/transaction", "w")
	turtle_x = f:write(source)
	f:close()
end

function endTransaction()
	fs.delete("var/transaction")
end

function calcBox()
	x, y, z = gps.locate(1, false)
	box = {{ math.floor(x / 16) * 16,
			(math.floor(x / 16) + 1) * 16},
			50,
		   { math.floor(z / 16) * 16,
			(math.floor(z / 16) + 1) * 16}}
	print("box_x: " .. box[1][1] .. " " .. box[1][2])
	print("box_z: " .. box[3][1] .. " " .. box[3][2])
end

function step()
	x, y, z = gps.locate(1, false)
	print(x .. " " .. y .. " " .. z)
	
	if box[2] < y then
		print("on top")
		start_x = math.floor(x / 16) * 16
		start_z = math.floor(z / 16) * 16
		if (x ~= start_x) or (z ~= start_z) then
			print("goto bottom right")
			fox.goto(start_x, y, start_z)
			fox.turnTo(fox.directions.east)
			return
		end
		fox.down(1, "dig")
		return
	end
	
	fox.digUp()
	fox.digDown()
	
	if x % 4 == 0 and z % 4 == 0 then
		if fox.getItemCount(slot_torch) < 2 then
			fox.select(slot_torch_chest)
			fox.placeDown()
			turtle.select(slot_torch)
			while turtle.getItemSpace(slot_torch) > 0 and fox.suckDown() do
				print("refilling torches")
			end
			fox.select(slot_torch_chest)
			fox.dropDown()
			fox.digDown()
		end
		
		turtle.select(slot_torch)
		turtle.placeDown()
	end
	
	if z % 2 == 0 then
		if box[1][1] <= x + 1 and x + 1 < box[1][2] then
			fox.forward(1, "dig")
		elseif not (box[3][1] < z + 1 and z + 1 < box[3][2]) then
			error("out of box")
		else
			beginTransaction("turnRight")
			fox.turnRight()
			fox.forward(1, "dig")
			fox.turnRight()
			endTransaction()
		end
	else
		if box[1][1] <= x - 1 and x - 1 < box[1][2] then
			fox.forward(1, "dig")
		elseif not (box[3][1] < z + 1 and z + 1 < box[3][2]) then
			--error("out of box")
			beginTransaction("next chunk")

			fox.turnLeft()
			fox.forward(1, "dig")
			fox.turnLeft()

			moveGpsGrid("forward")
			endTransaction()

			calcBox()
			
		else
			beginTransaction("turnLeft")
			fox.turnLeft()
			fox.forward(1, "dig")
			fox.turnLeft()
			endTransaction()
		end
	end
end

function msgGpsHosts(msg)
	for idx, host in pairs(gps_hosts) do
		print(host .. ": " .. msg)
		rednet.send(host, msg)
	end
end

function ping(host, ttl)
	retval = false
	function sendPing()
		rednet.send(host, "PING")
	end
	function receivePing()
		while true do
			sender, message, distance = rednet.receive(ttl)
			--util.log("got message: " .. message)
			if not sender then
				break
			elseif sender == host then
				print("pong")
				retval = true
				break
			end
		end
	end
	parallel.waitForAll(receivePing, sendPing)
	return retval
end

-- direction: forward, back
function moveGpsGrid(direction)
	local x1, y1, z1 = gps.locate(1, false)
	print(x1 .. " " .. y1 .. " " .. z1)

	for idx, host in pairs(gps_hosts) do
		--print("> " .. host .. ": " .. direction)
		rednet.send(host, direction)
	end
	
	startup_msgs = {}
	while true do
		sender, message, distance = rednet.receive(ttl)
		print("< " .. sender .. ": " .. message)
		--util.log("got message: " .. message)
		if message == "STARTUP" then
			startup_msgs[sender] = true
			
			all_ok = true
			for idx, host in pairs(gps_hosts) do
				if not startup_msgs[host] then
					all_ok = false
				end
			end
			if all_ok then
				break
			end
		end
	end
	
	local x2, y2, z2 = gps.locate(2, false)
	print(x2 .. " " .. y2 .. " " .. z2)
	
	if (x1 ~= x2) or (y1 ~= y2) or (z1 ~= z2) then
		error("something with gps went wrong!")
	end
end

function afterDig(dig_direction)
	if fox.getItemCount(16) == 0 then return end
	
	print("afterDig(" .. dig_direction .. ")")
	turtle.select(slot_drop_chest)
	fox.place(dig_direction)
	for i=slot_max,16,1 do
		if fox.getItemCount(i) > 0 then
			fox.select(i)
			fox.drop(dig_direction)
		end
	end
	turtle.select(slot_drop_chest)
	fox.dig(dig_direction)
end

--[[
if not rednet.open("right") then
	error("cant open modem")
end
]]--

rednet.open("right")

local tArgs = { ... }
cmd = tArgs[1]
calcBox()
fox.setFuelSlot(slot_fuel)
fox.setAfterDig(afterDig)

-- 43: Chunk Loader
gps_hosts = {32, 33, 34, 35, 41, 43}

if not fs.exists("var") then
	fs.makeDir("var")
end

if fs.exists("var/transaction") then
	error("transaction running")
end




if cmd == "forward" then
	fox.forward()
	
elseif cmd == "test" then
	rednet.send(43, "forward")
	--[[
	--moveGpsGrid(tArgs[2])
	x, y, z = gps.locate(1, false)
	print(x .. " " .. y .. " " .. z)
	box = {{ math.floor(x / 16) * 16,
		    (math.floor(x / 16) + 1) * 16},
		    72,
		   { math.floor(z / 16) * 16,
		    (math.floor(z / 16) + 1) * 16}}
	--math.floor(x / 16) * 16
	--print(textutils.serialize(box))
	print("x: " .. box[1][1] .. " " .. box[1][2])
	print("z: " .. box[3][1] .. " " .. box[3][2])
	]]--
	
elseif cmd == "gpsmsg" then
	local msg = tArgs[2]
	msgGpsHosts(msg)
	
	--[[
	for i = 1, 4, 1 do
		print(gps_hosts[i])
		rednet.send(gps_hosts[i], "forward")
	end
	]]--
	
elseif cmd == "step" then
	step()
	
elseif cmd == "goto" then
	local x, y, z = util.toInt(tArgs[2]), util.toInt(tArgs[3]), util.toInt(tArgs[4])
	print(x .. " " .. y .. " " .. z)
	fox.goto(x, y, z)
	 
elseif cmd == "test3" then
	x, y, z = gps.locate(1, false)
	print(x .. " " .. y .. " " .. z)
	step()
	
elseif cmd == "test2" then
	rednet.open("right")
	x, y, z = gps.locate(1, false)
	print(x .. " " .. y .. " " .. z)

	start_x = math.floor(x / 16) * 16
	start_z = math.floor(z / 16) * 16
	
	--because we like to cut off the decimals
	
	print("start_x: " .. start_x .. ", start_z: " .. start_z)
	fox.goto(start_x, y, start_z)
	
elseif cmd == "refuel" then
	fox.refuel()

elseif cmd == "startupX" then
	rednet.open("right")
	
	-- wait for gps hosts
	x, y, z = gps.locate(1, false)
	while not x do
		print("wait for gps host...")
		x, y, z = gps.locate(1, false)
	end
	--
	--for i=1,100,1 do
	while true do
		step()
	end
end
