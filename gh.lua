-- http://pastebin.com/YAzeh9Ag

function get(name)
	local content = http.get("https://raw.github.com/dummy3k/computerCraft/blob/master/"..name..".lua")

	f = io.open(name, "w")
	f:write(content.readAll())
	f:close()
end

local tArgs = {...}
get(tArgs[1])
