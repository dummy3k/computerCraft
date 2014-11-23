function setRs(value)
	print("setRs: "..tostring(value))
	rs.setOutput("back", value)
	-- if value then
		-- rs.setBundledOutput("right", colors.orange)
	-- else
		-- rs.setBundledOutput("right", 0)
	-- end
end


function wait(value)
	-- while colors.test(rs.getBundledInput("right"), colors.white) ~= value do
	while rs.getInput("back") ~= value do
		print("waiting for "..tostring(value))
		os.pullEvent("redstone")
	end
end


-- local crafting_slots = {[1]=1, [2]=2, [3]=3,
						-- [5]=5, [6]=6, [7]=7,
						-- [9]=9, [10]=10, [11]=11}
local crafting_slots = {1, 2, 3,
						5, 6, 7,
						9, 10, 11}

-- function needsTransfer(i)
	-- if crafting_slots[i] then return true end
	-- return turtle.getItemCount(i) > 0
-- end

function transferAway(v, next_slot, cnt_per_slot)
	-- local next_slot = k + 1
	while turtle.getItemCount(v) > cnt_per_slot do
		if turtle.getItemCount(crafting_slots[next_slot]) < cnt_per_slot then
			local cnt = math.min(turtle.getItemCount(v) - cnt_per_slot, cnt_per_slot - turtle.getItemCount(crafting_slots[next_slot]))
			turtle.select(v)
			turtle.transferTo(crafting_slots[next_slot], cnt)
		end
		next_slot = next_slot + 1
	end
end

function craft()
	print("craft()")
	local cnt = 0 --= turtle.getItemCount(1)
	for i=1,16,1 do
		cnt = cnt + turtle.getItemCount(i)
	end
	
	local cnt_per_slot = cnt / 9
	print("cnt_per_slot: "..cnt_per_slot)
	for k, v in pairs(crafting_slots) do
		-- print(v)
		-- transferAway(v, k + 1, cnt_per_slot)
		local next_slot = k + 1
		while turtle.getItemCount(v) > cnt_per_slot do
			if turtle.getItemCount(crafting_slots[next_slot]) < cnt_per_slot then
				local cnt = math.min(turtle.getItemCount(v) - cnt_per_slot, cnt_per_slot - turtle.getItemCount(crafting_slots[next_slot]))
				turtle.select(v)
				if not turtle.transferTo(crafting_slots[next_slot], cnt) then error("transferTo failed") end
			end
			next_slot = next_slot + 1
			if next_slot > 10 then error("next_slot > 9") end
		end
	end
	
	for k, v in pairs({4, 8, 12}) do
		local next_slot = k + 1
		while turtle.getItemCount(v) > 0 do
			if turtle.getItemCount(crafting_slots[next_slot]) < cnt_per_slot then
				local cnt = cnt_per_slot - turtle.getItemCount(crafting_slots[next_slot])
				turtle.select(v)
				if not turtle.transferTo(crafting_slots[next_slot], cnt) then error("transferTo failed") end
			end
			next_slot = next_slot + 1
		end
	end
	
	turtle.select(1)
	if not turtle.craft() then error("craft failed") end
	if not turtle.dropUp() then error("dropUp failed") end
	
	-- for i=1,16,1 do
		-- if turtle.getItemCount(i) > cnt_per_slot then
			-- for k, v in pairs(crafting_slots) do
				-- if turtle.getItemCount(v) < cnt_per_slot then
					-- turtle.select(i)
					-- turtle.transferTo(v, cnt_per_slot-turtle.getItemCount(v))
				-- end
			-- end
		-- end
	-- end
	
	-- print(cnt / 9)
	-- 1, 2, 3, 5, 6, 7
	-- for k, v in pairs(crafting_slots) do
		-- print(v)
	-- end
	
	-- if cnt == 0 then
		-- -- print("waiting")
		-- -- os.sleep(0.5)
		-- -- rs.setOutput("back", true)
		-- return 
	-- end
	-- setRs(false)
	
	-- for i = 2, 3, 1 do
		-- turtle.transferTo(i, cnt / 9)
	-- end
	-- for i = 5, 7, 1 do
		-- turtle.transferTo(i, cnt / 9)
	-- end
	-- for i = 9, 11, 1 do
		-- turtle.transferTo(i, cnt / 9)
	-- end
	-- if not turtle.craft() then error("craft failed") end
	-- turtle.dropUp()
	-- -- event, p1 = os.pullEvent("turtle_inventory")
	-- os.sleep(0.5)
	-- setRs(true)
end

-- craft()
-- foo()

function emptyAll()
	-- setRs(false)
	for i=1,16,1 do
		if turtle.getItemCount(i) > 0 then
			turtle.select(i)
			turtle.dropUp()
		end
	end
	-- setRs(true)
end


function serve()
	setRs(true)
	while true do
		wait(true)
		setRs(false)
		wait(false)
		craft()
		setRs(true)
		
		-- setRs(true)
		-- event, p1 = os.pullEvent("turtle_inventory")
		-- setRs(false)
		-- print(event)
		-- craft()
		-- setRs(true)
	end
end

setRs(false)
emptyAll()
serve()


-- setRs(true)