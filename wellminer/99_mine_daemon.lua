if not os.loadAPI("/usr/api/fox") then error("could not load fox") end

SLOT_WELL = 1
SLOT_ENERGY = 2
SLOT_DUMP = 3
SLOT_MAX = 3	-- << --

PROTOCOLL = "mine"

function place_well_and_wait()
	fox.select(SLOT_WELL)
	fox.place()
	local p = peripheral.wrap("front")
	-- print("1")
	os.sleep(1)
	
	while p.hasWork() do
		-- print("2")
		os.sleep(1)
	end
	-- print("3")

	if fox.getItemCount(1) > 0 then
		--[[
		for i=2,16 do
			if fox.getItemCount(i) == 0 then
				turtle.transferTo(i)
				break
			end
		end
		if fox.getItemCount(1) > 0 then error("no space") end
		]]--
		fox.dropDown()
	end

	
	fox.dig()

	for i=2,16 do
		if fox.getItemCount(i) > 0 then
			turtle.select(i)
			fox.dropDown()
		end
	end
	
	--fox.forward()
end

function moveEnergy()
	if turtle.getItemCount(SLOT_ENERGY) > 0 then error("slot full") end
	turtle.select(SLOT_ENERGY)
	if not turtle.digUp() then error("digUp failed") end
	fox.up()
	fox.place()
	fox.down()
end

function moveDump()
	if turtle.getItemCount(SLOT_DUMP) > 0 then error("slot full") end
	turtle.select(SLOT_DUMP)
	if not turtle.digDown() then error("digDown failed") end
	fox.forward()
	fox.placeDown()
end

function cycle()
	moveEnergy()
	place_well_and_wait()
	moveDump()
end

-- for i=1,10 do
	-- cycle()
	-- os.sleep(0.1)
-- end

if turtle.getFuelLevel() < 100 then
	error("low fuel: "..tostring(turtle.getFuelLevel()))
end

--cycle()

function daemon()
	print("mining client "..os.getComputerID().." running...")
	while true do
		sender, msg = rednet.receive(PROTOCOLL)
		-- print(msg)
		
		-- local fn = function(sender, msg)
			-- end
			
		local status, err = pcall(handle_request, sender, msg)
		-- print(status)
		if not status then
			print(tostring(msg).."->"..tostring(err))
			answer = {cmd="error_response", err=err}
			answer = textutils.serialize(answer)
			rednet.send(sender, answer, PROTOCOLL)
		end
		
		--if not status
	end

end

function handle_request(sender, msg)
	-- print("hi")
	msg = textutils.unserialize(msg)
	print("cmd: "..tostring(msg.cmd))
	
	if msg.cmd == "echo_request" then
		rednet.send(sender, "echo_response", PROTOCOLL)
		
	elseif msg.cmd == "dig" then
		turtle.select(1)
		answer = {cmd="dig_response"}
		answer.detect = turtle.detect()
		answer.dig = turtle.dig()
		
		success, data = turtle.inspectUp()
		
		if success then
			boring_ids = {ID_TURTLE, ID_STONE} 
			interesting = true
			for _, id in ipairs(boring_ids) do
				if  data.name == id then
					interesting = false
					break
				end
			end
			if interesting then
				turtle.digUp()
				turtle.select(SLOT_COBBLE)
				turtle.placeUp()
			end
		end
		
		answer = textutils.serialize(answer)
		rednet.send(sender, answer, PROTOCOLL)
		
	elseif msg.cmd == "forward" then
		success , data = turtle.inspectDown()
		if success and data.name == ID_CHEST then
			turtle.select(SLOT_CHEST)
			turtle.digDown()
		end
	
		turtle.select(1)
		
		answer = {cmd="forward_response"}
		answer.detect = turtle.detect()
		answer.forward = turtle.forward()
		answer.fuel = turtle.getFuelLevel()
		answer = textutils.serialize(answer)

		if success and data.name ~= ID_TURTLE then
			turtle.digDown()
			turtle.select(SLOT_CHEST)
			turtle.placeDown()
		end
			
		rednet.send(sender, answer, PROTOCOLL)
		
	elseif msg.cmd == "drop" then
		answer = {cmd="drop_response"}
		answer.count = 0
		for i=2,16 do
			if turtle.getItemCount(i) > 0 then
				turtle.select(i)
				while turtle.getFuelLevel() < 5000 do
					if not turtle.refuel(1) then break end
				end
				answer.count = answer.count + turtle.getItemCount(i)
				turtle.dropDown()
			end
		end
		answer = textutils.serialize(answer)
		rednet.send(sender, answer, PROTOCOLL)
		
	elseif msg.cmd == "getFuelLevel" then
		answer = {cmd="getFuelLevel_response"}
		answer.getFuelLevel = turtle.getFuelLevel()
		answer = textutils.serialize(answer)
		rednet.send(sender, answer, PROTOCOLL)
		
	elseif msg.cmd == "shell" then
		answer = {cmd="shell_response"}
		-- print("**********")
		-- -- print(unpack(msg.args)[1])
		-- print(msg.args[1])
		-- print("**********")
		answer.retval = shell.run(unpack(msg.args))
		-- answer.retval = foo(unpack(msg.args))
		answer = textutils.serialize(answer)
		rednet.send(sender, answer, PROTOCOLL)
		
	elseif msg.cmd == "removeLava" then
		turtle.select(SLOT_COBBLE)
		removeLava(turtle.inspectUp, turtle.placeUp)
		removeLava(turtle.inspect, turtle.place)
		turtle.turnLeft()
		removeLava(turtle.inspect, turtle.place)
		turtle.turnLeft()
		turtle.turnLeft()
		removeLava(turtle.inspect, turtle.place)
		turtle.turnLeft()

		answer = {cmd="removeLava_response"}
		answer = textutils.serialize(answer)
		rednet.send(sender, answer, PROTOCOLL)
		
	elseif msg.cmd == "cycle" then
		cycle()
		answer = {cmd="cycle_response"}
		answer = textutils.serialize(answer)
		print("to "..tostring(sender)..": "..answer)
		rednet.send(sender, answer, PROTOCOLL)
		
	elseif msg.cmd == "update" then
		--turtle.dig()
		print("update")
		local f = io.open("/etc/init.d/99_mine_daemon.lua", "w")
		content = f:write(msg.payload)
		f:close()
		os.reboot()
	end
end


daemon()
-- turtle.select(1)
-- turtle.dig()
-- cycle()