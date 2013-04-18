function get(name, save_as)
	local url = "https://raw.github.com/dummy3k/computerCraft/master/"..name..".lua"
	local content = http.get(url)
	if not content then error("download failed: "..url) end

	if not save_as then save_as = name end
	f = io.open(save_as, "w")
	f:write(content.readAll())
	f:close()
end

local tArgs = {...}
get(tArgs[1], tArgs[2])
