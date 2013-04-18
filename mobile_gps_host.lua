if not os.loadAPI("util") then	error("could not load util") end

if turtle.getFuelLevel() < 1000 then
	error("low fuel: " .. turtle.getFuelLevel())
end


function wait4orders()
	util.log("waiting for orders...")
	while true do
		sender, message, distance = rednet.receive()
		util.log("got message: " .. message)
		if message == "forward" or message == "back" then
			util.log("turtle_z: " .. turtle_z)
			for i = 1, 16, 1 do
				if message == "forward" then
					turtle.forward()
					turtle_z = turtle_z + 1
				elseif message == "back" then
					turtle.back()
					turtle_z = turtle_z - 1
				else
					error("wtf")
				end
			end
			util.log("turtle_z: " .. turtle_z)

			f = io.open("var/location", "w")
			f:write(turtle_x .. "\n")
			f:write(turtle_y .. "\n")
			f:write(turtle_z .. "\n")
			f:close()
			
			os.run({}, "rom/programs/reboot")

		elseif message == "reboot" then
			util.log("rebooting now")
			os.run({}, "rom/programs/reboot")
			
		elseif message == "up" then
			turtle.up()
			turtle.up()
			turtle.up()
		end
	end
end

function serveGPS()
	util.log("serving gps..")
		
	os.run({}, "rom/programs/gps", "host", turtle_x, turtle_y, turtle_z)
end


print("this is computer #" .. os.computerID())

if not fs.exists("var") then
	fs.makeDir("var")
end

rednet.open("right")

f = io.open("var/location", "r")
turtle_x = f:read()
turtle_y = f:read()
turtle_z = f:read()
f:close()
util.log("location: " .. turtle_x .. " " .. turtle_y .. " " .. turtle_z)

rednet.broadcast("STARTUP")
parallel.waitForAny (wait4orders, serveGPS)
