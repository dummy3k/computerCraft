local items = {["minecraft:stone"] = "front"}

local VAR_DIRECTORY = "/var"
if not fs.exists(VAR_DIRECTORY) then
	print("creating ", VAR_DIRECTORY)
	fs.makeDir(VAR_DIRECTORY)
end

local STATE_FILE = "/var/state.lua"
if fs.exists(STATE_FILE) then
	print("loading ", STATE_FILE)
	local h = fs.open(STATE_FILE, "r")
	items = textutils.unserialize(h.readAll())
	h.close()
end

function sort_items()
	print("sorting...")
	local loop_again = true
	while loop_again do
		loop_again = false
		for slot=1,16 do
			local detail = turtle.getItemDetail(slot)
			if detail then
				if not items[detail.name] then
					print("unkown item '"..tostring(detail.name).."'")
				else
					print(tostring(detail.name).." "..items[detail.name])
					turtle.select(slot)
					loop_again = true
					if items[detail.name] == "front" then
						turtle.drop()
					elseif items[detail.name] == "top" then
						turtle.dropUp()
					elseif items[detail.name] == "bottom" then
						turtle.dropUp()
					end
				end
			end
		end
		turtle.select(1)
		-- os.sleep(1)
	end
end

function startup()
	sort_items()
	while true do
		p1, p2 = os.pullEvent("turtle_inventory")
		-- print(p1, tostring(p2))
		sort_items()
	end
end

function train()
	for slot=1,16 do
		local detail = turtle.getItemDetail(slot)
		if detail then
			if not items[detail.name] then
				print("unkown item '"..tostring(detail.name).."'")
				turtle.select(slot)
				local response = read()
				print(reponse)
				if response == "front" or response == "top" or response == "bottom" then
					items[detail.name] = response
				else
					print("bad response")
				end
			end
		end
	end
	local h = fs.open(STATE_FILE, "w")
	h.write(textutils.serialize(items))
	h.close()
end

local tArgs = {...}
if tArgs[1] == "startup" then
	startup()
elseif tArgs[1] == "train" then
	train()
end
