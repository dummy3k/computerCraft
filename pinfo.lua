f = io.open("out.txt", "w")

for k, v in ipairs(peripheral.getMethods("front")) do
	f:write(v .. "\n")
end

f:close()
