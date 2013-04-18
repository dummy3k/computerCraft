if not os.loadAPI("util") then error("could not load 'util'") end
util.log("begin next step")

function move_forward()
	turtle.up()
	turtle.forward()
	turtle.turnLeft()
	turtle.forward()
	turtle.down()
	turtle.turnLeft()
	turtle.dig()
	turtle.turnLeft()
	turtle.turnLeft()

	for i = 1, 15, 1 do
		turtle.forward()
	end
	turtle.turnRight()
	turtle.forward()
	turtle.turnLeft()

	turtle.place()

	turtle.turnLeft()
	turtle.place()

	turtle.turnLeft()
	for i = 1, 15, 1 do
		turtle.forward()
	end

	turtle.dig()
	turtle.turnLeft()
	turtle.turnLeft()
	for i = 1, 15, 1 do
		turtle.forward()
	end

	util.log("step finished")
end


if not turtle.detect() then
	turtle.place()
end
turtle.turnLeft()
if not turtle.detect() then
	turtle.place()
end
turtle.turnRight()

rednet.open("right")

while true do
	sender, message, distance = rednet.receive()
	util.log("got message: " .. message)
	if message == "forward" then
		move_forward()
		rednet.broadcast("STARTUP")
	end
end
