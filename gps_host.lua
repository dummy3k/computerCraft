if not os.loadAPI("fox") then	error("could not load fox") end

function setLocation(value)
	f = io.open("var/location", "w")
	f:write(value.x .. "\n")
	f:write(value.y .. "\n")
	f:write(value.z .. "\n")
	f:close()
end

local tArgs = {...}
cmd = tArgs[1]

f = io.open("var/location", "r")
if not f then
	current = nil
else
	current = vector.new(f:read(), f:read(), f:read())
	f:close()
	--print(current)
end

--local current = readLocation()
if not cmd then
	if not current then error("no location set") end
	os.run({}, "rom/programs/gps", "host", current.x, current.y, current.z)
	--os.run({}, "rom/programs/gps", "host", turtle_x, turtle_y, turtle_z)
	
	
elseif cmd == "up" or cmd == "down" then
	if not current then error("no location set") end
	target_y = tArgs[2]
	fox.setFuelSlot(1)
	
	if cmd == "up" then
		cnt = target_y - current.y
	else
		cnt = current.y - target_y
	end
	fox.refuel(cnt)
	print("remove fuel if you wish")
	for i=5,0,-1 do 
		print(i)
		os.sleep(1)
	end
	
	fox.move(cmd, cnt)
	current.y = target_y
	setLocation(current)
	os.run({}, "rom/programs/gps", "host", current.x, current.y, current.z)
	
elseif cmd == "set" then
	if not fs.exists("var") then
		print("creating 'var'")
		fs.makeDir("var")
	end

	f = io.open("var/location", "w")
	setLocation(vector.new(tArgs[2], tArgs[3], tArgs[4]))
	f:close()
end

--[[
current = vector.new(tArgs[1], tArgs[2], tArgs[3])
target = vector.new(tArgs[1], tArgs[4], tArgs[3])

print(current)
print(target)

fox.setFuelSlot(1)
fox.up(target.y - current.y)


--rednet.open("right")

]]--
