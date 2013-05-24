print("version: 6")
function get(name, save_as)
	-- http://beta.etherpad.org/p/Dmw3wsX4tH/export/txt
    local url = "http://beta.etherpad.org/p/"..name.."/export/txt"
    print(url)
    local content = http.get(url)
    if not content then error("download failed: "..url) end
    if not save_as then save_as = name end
    f = io.open(save_as, "w")
    f:write(content.readAll())
    f:close()
end
local tArgs = {...}
get(tArgs[1], tArgs[2])
os.run({}, tArgs[2])
