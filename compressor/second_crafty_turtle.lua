function craft()
	rs.setOutput("back", false)
	local cnt = turtle.getItemCount(1)
	if cnt == 0 then 
		rs.setOutput("top", false)
		rs.setOutput("back", false)
		return 
	end
	for i = 2, 3, 1 do
		turtle.transferTo(i, cnt / 9)
	end
	for i = 5, 7, 1 do
		turtle.transferTo(i, cnt / 9)
	end
	for i = 9, 11, 1 do
		turtle.transferTo(i, cnt / 9)
	end
	if not turtle.craft() then error("craft failed") end
	turtle.drop()
	event, p1 = os.pullEvent("turtle_inventory")
	rs.setOutput("back", true)
end

-- craft()
-- foo()

function emptyAll()
	rs.setOutput("back", true)
	for i=1,16,1 do
		if turtle.getItemCount(i) > 0 then
			turtle.select(i)
			turtle.drop()
		end
	end
	rs.setOutput("back", false)
end

emptyAll()
turtle.select(1)
rs.setOutput("back", true)

while true do
	event, p1 = os.pullEvent("turtle_inventory")
	
	print(event)
	craft()
end
