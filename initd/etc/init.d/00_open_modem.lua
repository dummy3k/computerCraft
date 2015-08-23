sides = {"left", "right", "front", "back", "top", "bottom"}

for _, side in ipairs(sides) do
	if peripheral.getType(side) == "modem" then
		rednet.open(side)
		print("modem open ("..side..")")
	end
end

-- if peripheral.getType("right") == "modem" then
	-- rednet.open("right")
	-- print("modem open (right)")
-- if peripheral.getType("right") == "modem" then
	-- rednet.open("right")
	-- print("modem open (right)")
-- else
	-- print("no modem found")
-- end