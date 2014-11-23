function waitGrowth()
	while true do
		local success, data = turtle.inspectDown()

		if not success then
			print("no success")
		else
			print("Block name: ", data.name)
			print("Block metadata: ", data.metadata)
			if data.metadata >= 3 then
				return
			end
		end
		os.pullEvent("redstone")
	end	
end

function freeSpace()
	for i=1,16,1 do
		if turtle.getItemSpace(i) > 0 then
			return true
		end
	end
	return false
end

function serve()
	while freeSpace() do
		waitGrowth()
		turtle.digDown()
		turtle.placeDown()
	end
	print("no more space")
end

-- print(freeSpace())
serve()
