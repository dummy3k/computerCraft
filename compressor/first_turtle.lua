CRAFTY_POS = "front"

function compress()
	for i=16,1,-1 do
		if turtle.getItemCount(i) > 0 then
			turtle.select(i)
			-- print(i)
			for j=1, i - 1, 1 do
				if turtle.getItemSpace(j) == 0 then
					-- full
					-- print("full"..j)
				elseif turtle.getItemCount(j) == 0 then
					-- print(i.."-->"..j)
					turtle.transferTo(j)
					break
				elseif turtle.compareTo(j) then
					turtle.transferTo(j)
					break
				end
			end
		end
	end
end

function scan()
	local slot = -1
	
	for i=16,1,-1 do
		-- turtle.select(i)
		local cnt = turtle.getItemCount(i)
		if cnt >= 9 and (slot < 0 or cnt > turtle.getItemCount(slot)) then
			slot = i
		end
	end
	-- print(slot)
	if slot > 0 then
		turtle.select(slot)
		waitFree()
		local cnt = turtle.getItemCount(slot)
		turtle.drop(math.floor(cnt / 9) * 9 )
		return true
	end
	
	return false
end

function serve()
	while true do
		compress()
		if not scan() then
			print("waiting...")
			event, p1 = os.pullEvent("turtle_inventory")
		end
	end
end

function debugEvents()
	while true do
		event, p1 = os.pullEvent()
		print(event)
		print(p1)
	end
end

function waitFree()
	while not rs.getInput(CRAFTY_POS) do
		print("waiting for crafty...")
		os.pullEvent("redstone")
	end
end

-- print(rs.getInput(CRAFTY_POS))
-- debugEvents()
-- waitFree()
serve()
-- compress()