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

function multi_pull(events)
	while true do
		local p1, p2, p3 = os.pullEvent()
		--print("p1: "..tostring(p1)..", p2: "..tostring(p2))
		for k, v in pairs(events) do
			--print("k: "..k..", v: "..v) 
			if p1 == v then
				return p1, p2, p3
			end
		end
	end
end
