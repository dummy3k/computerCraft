-- if not os.loadAPI("fox") then	error("could not load fox") end

slot_fuel = 1
slot_sapling = 2
slot_wood = 3

function lookAround(depth)

	if turtle.detectUp() then
		turtle.select(slot_wood)
		follow = turtle.compareUp()
		turtle.select(slot_sapling)
		turtle.digUp()
		if follow then
			turtle.up()
			lookAround(depth + 1)
			turtle.down()
		end
	end
	for i=1,4,1 do
		turtle.select(slot_wood)
		follow = turtle.compare()
		if turtle.detect() then
			turtle.select(slot_sapling)
			turtle.dig()
			if follow then
				turtle.forward()
				lookAround(depth + 1)
				turtle.back()
			end
		end
		turtle.turnLeft()
	end
end

function lookAround_old()
	if turtle.detectUp() then
		turtle.digUp()
		turtle.up()
		lookAround()
		turtle.down()
	end
	for i=1,4,1 do
		if turtle.detect() then
			turtle.dig()
			turtle.forward()
			lookAround()
			turtle.back()
		end
		turtle.turnLeft()
	end
end

function dropOff()
end

function placeSapling()
	turtle.select(slot_sapling)
	if turtle.compare() then return true end
	if turtle.getItemCount(slot_sapling) < 2 then error("not enough saplings") end
	turtle.select(slot_sapling)
	turtle.place()
end

function wait4grow()
	local success, detail = turtle.inspect()
	if not success then
		placeSapling()
	else
		if detail.name ~= "minecraft:log" then
			print(tostring(detail.name), " in front of me!")
			return
		end
	end
	while true do
		turtle.select(slot_wood)
		--if turtle.detect() and not turtle.compare() then
		if turtle.compare() then
		
			--[[
			turtle.select(slot_sapling)
			turtle.dig()
			turtle.forward()
			lookAround(0)
			turtle.back()
			]]--
			second_version()
			
			--refuel(100)
			placeSapling()
		else
			os.sleep(1)
		end
	end
end

function refuel(value)
	turtle.select(slot_wood)
	if turtle.getFuelLevel() > value then return true end
	turtle.select(slot_wood)
	while turtle.getFuelLevel() < value and turtle.refuel(1) do
		print("fuel: " .. turtle.getFuelLevel())
	end
	
end

function second_version()
	fox.forward(1, "dig")

	cnt_up = 0
	while fox.detectUp() do
		fox.up(1, "dig")
		cnt_up = cnt_up + 1

		for i=1,4,1 do
			cnt = 0
			while fox.detect() do
				cnt = cnt + 1
				fox.forward(1, "dig")
				
				fox.turnLeft()
				fox.dig("false")
				
				fox.turnRight(2)
				fox.dig("false")
				fox.turnLeft()
			end
			fox.back(cnt)
			fox.turnLeft()
		end
	end
	fox.down(cnt_up)
	fox.back()
	
	--[[
	fox.forward(1, "dig")
	fox.up(2, "dig")




	for i=1,4,1 do
		while fox.detect()
			fox.forward(1, "dig")
			
			fox.turnLeft()
			fox.dig()
			
			fox.turnRight(2)
			fox.dig()
		end
	end
	]]--
	
end

print("fuel: " .. turtle.getFuelLevel())
fox.setFuelSlot(slot_fuel)
--refuel(100)
--if turtle.getFuelLevel() < 100 then error("not enough fuel: " .. turtle.getFuelLevel()) end
wait4grow()
--lookAround()

--second_version()