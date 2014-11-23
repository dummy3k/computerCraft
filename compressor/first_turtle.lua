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

function setRs(value)
	print("setRs: "..tostring(value))
	rs.setOutput("front", value)
	
	-- if value then
		-- rs.setBundledOutput("right", colors.white)
	-- else
		-- rs.setBundledOutput("right", 0)
	-- end
end

function wait(value)
	-- print("waiting for "..tostring(value))
	while rs.getInput("front") ~= value do
	-- while colors.test(rs.getBundledInput("right"), colors.orange) ~= value do
		print("waiting for "..tostring(value))
		os.pullEvent("redstone")
	end
end


function scan()
	wait(true)

	local slot = -1
	local item_types = {}
	
	for i=16,1,-1 do
		local cnt = turtle.getItemCount(i)
		if cnt > 0 then
			local data = turtle.getItemDetail(i)
			local item_id = data.name.."#"..data.damage
			if not item_types[item_id] then
				item_types[item_id] = cnt
			else
				item_types[item_id] = item_types[item_id] + cnt
			end
		end
	end
	
	local max_id
	local max_cnt = 0
	
	for k, v in pairs(item_types) do
		-- print(k..":"..v)
		if v > max_cnt then
			max_id = k
			max_cnt = v
		end
	end
	
	if max_cnt < 9 then return false end
	print(max_id)
	setRs(true)
	wait(false)
	
	max_cnt = math.min(max_cnt, 64*9)
	max_cnt = math.floor(max_cnt / 9) * 9
	for i=16,1,-1 do
		local cnt = turtle.getItemCount(i)
		if cnt > 0 then
			local data = turtle.getItemDetail(i)
			local item_id = data.name.."#"..data.damage
			if item_id == max_id then
				local to_drop_cnt = math.min(cnt, max_cnt)
				max_cnt = max_cnt - to_drop_cnt
				turtle.select(i)
				if not turtle.drop(to_drop_cnt) then error("drop failed") end
			end
		end
		if max_cnt <= 0 then break end
	end
	setRs(false)
	
	-- for i=16,1,-1 do
		-- -- turtle.select(i)
		-- local cnt = turtle.getItemCount(i)
		-- if cnt >= 9 and (slot < 0 or cnt > turtle.getItemCount(slot)) then
			-- slot = i
			-- -- if turtle.getItemSpace(slot) == 0 then
				-- -- break
			-- -- end
		-- end
	-- end
	-- -- print(slot)
	-- if slot > 0 then
		-- turtle.select(slot)
		-- wait(true)
		-- local cnt = turtle.getItemCount(slot)
		-- turtle.drop(math.floor(cnt / 9) * 9 )
		-- wait(false)
		-- return true
	-- end
	
	return true
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


-- print(rs.getInput(CRAFTY_POS))
-- debugEvents()
-- wait()
serve()
-- compress()
-- scan()
-- setRs(true)
-- os.sleep(1)
-- setRs(true)