if not os.loadAPI("fox") then	error("could not load fox") end

slot_fuel = 1
slot_cargo = 2
slot_cargo_min = 2
slot_cargo_max = 16

function ts_print(s)
	print(os.clock() .. " " .. s)
end

function cargoCount()
	local cnt = 0
	for i=slot_cargo_min,slot_cargo_max,1 do
		cnt = cnt + fox.getItemCount(i)
	end
	return cnt
end

function cycle()
	while true do
		ts_print("cycle begin")
		last_input = os.clock()
		fox.goto(orders.source.x, orders.source.y, orders.source.z)
		fox.turnTo(orders.source.direction)
		
		fox.select(slot_cargo)
		while last_input + 30 > os.clock() and cargoCount() < 16 do
			if turtle.suck() then
				ts_print("got items")
				last_input = os.clock()
			end
			os.sleep(1)
		end

		while cargoCount() > 0 do
			fox.goto(orders.destination.x, orders.destination.y, orders.destination.z)
			
			ts_print("dropping items...")
			for i=slot_cargo,16,1 do
				if fox.getItemCount(i) > 0 then
					fox.select(i)
					while fox.getItemCount(i) > 0 do
						if not turtle.dropDown() then
							--ts_print("could not drop items. waiting ...")
							os.sleep(10)
						end
					end
				end
			end
		end
	end
end

fox.setFuelSlot(slot_fuel)

f = io.open("orders.txt", "r")
if not f then error("cant open file") end
orders = ""
repeat
	line = f:read()
	if line then
		orders = orders .. line
	end
until not line
f:close()

orders = textutils.unserialize(orders)

cycle()
