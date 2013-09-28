if not os.loadAPI("fox") then error("fox api") end

local tArgs = {...}
width = tArgs[1]
height = tArgs[2]

local current_slot = 1
fox.select(current_slot)

for w=1,width do
	for h=1,height do
		while fox.getItemCount(current_slot) == 0 and current_slot <= 16 do
			fox.select(current_slot)
		end
		fox.placeDown("false")
		fox.forward()
	end
	if w % 2 == 0 then
		fox.turnRight()
		fox.forward()
		fox.turnRight()
	else
		fox.turnLeft()
		fox.forward()
		fox.turnLeft()
	end
	fox.forward()
end

