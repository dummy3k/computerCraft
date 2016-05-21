daemons = {}

for k, v in pairs(_G) do
	if type(v) == "table" then
		-- print(k..": "..tostring(v))
		for k2, v2 in pairs(v) do
			-- print(k.."."..k2..": "..tostring(v))
			if k2 == "daemon" then
				-- print(k..": "..tostring(v))
				daemons[#daemons + 1] = v2
				-- v2()
			end
		end
	end
end

if #daemons > 0 then
	parallel.waitForAll(unpack(daemons))
end
-- shell.setPath(shell.path()..":/bin")
