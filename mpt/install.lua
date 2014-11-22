BASE_URL = "https://raw.githubusercontent.com/dummy3k/computerCraft/master/mpt/"

function get(name, save_as)
	local url = BASE_URL"..name..".lua"
	local content = http.get(url)
	if not content then error("download failed: "..url) end

	if not save_as then save_as = name end
	f = io.open(save_as, "w")
	f:write(content.readAll())
	f:close()
end

shell.run("rm","ccpt")
shell.run("rm","mpt")

-- shell.run("pastebin","get","4LSRnmJ8","mpt")
get("mpt")

term.clear()
term.setCursorPos(1,1)
shell.run("mpt","init", BASE_URL)