function log(s)
	if not fs.exists("var") then
		print("creating 'var'")
		fs.makeDir("var")
	end

	--msg = os.computerID() .. ": " .. s .. "\n"
	msg = s
	f = io.open("var/log", "a")
	if not f then
		error("could not open file 'var/log'")
	end
	f:write(msg .. "\n")
	f:close()
	
	print(msg)
end

function toInt(x)
	return (x + 1) - 1
end

locationAwareTurtle = {
	x,
	y,
	z,
	
	forward = function()
	end
}

