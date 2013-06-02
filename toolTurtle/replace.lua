if not os.loadAPI("fox") then error("fox api") end

function lookAround()
	turtle.select(1)
	if turtle.compareDown() then
		turtle.digDown()
		slot = 2
		while turtle.getItemCount(slot) == 0 do
			slot = slot + 1
		end
		turtle.select(slot)
		turtle.placeDown()

		for i=1,3 do
			fox.forward(1)
			lookAround()
			fox.back()
			fox.turnLeft()
		end
		
		-- the last one is where we come from
		fox.turnLeft()
	end
end

lookAround()
