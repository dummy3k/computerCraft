-- http://beta.etherpad.org/p/Dmw3wsX4tH/export/txt
function get(name, save_as)
	local url = "http://beta.etherpad.org/p/"..name.."/export/txt"
	local content = http.get(url)
	if not content then error("download failed: "..url) end
	print(content)

	if not save_as then save_as = name end
	f = io.open(save_as, "w")
	f:write(content.readAll())
	f:close()

end

local tArgs = {...}
get(tArgs[1], tArgs[2])


