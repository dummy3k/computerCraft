-- http://lua-users.org/wiki/StringRecipes
function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

-- http://lua-users.org/wiki/StringRecipes
function string.ends(String,End)
   return End=='' or string.sub(String,-string.len(End))==End
end

local FileList = fs.list("/etc/daemon.d") --Table with all the files and directories available


workers = {}
for _, file in ipairs(FileList) do --Loop. Underscore because we don't use the key, ipairs so it's in order
	-- if file ~= "readme.txt" then
	if string.ends(file, ".lua") then
	  local fn = function()
					print(file) --Print the file name
					full_filename = "/etc/daemon.d/"..file
					return shell.run(full_filename)
					--return true
				end
				
		table.insert(workers, fn)
	end
end

--[[
function foo()
	print("foo")
end
foo_array = {foo, foo}
]]--

function waitKey()
	event = os.pullEvent("key")
	-- print(event)
end

function timeout()
	os.sleep(3)
end

function ask_user()
	print("press any key to skip daemon mode...")
	result = parallel.waitForAny(waitKey, timeout)
	-- print(result)
	if result == 1 then
		event = os.pullEvent("key_up")
		-- print(event)
	end
	return (result == 2)
end




-- while true do
	-- waitKey()
-- end

local tArgs = {...}
print(tArgs[1])
if tArgs[1] == "daemon" then
	if #workers == 0 then
		print("no daemons to run")
	else
		if ask_user() then
			shell.openTab("/bin/daemon.lua", "run")
		end
	end
	
elseif tArgs[1] == "run" then
	parallel.waitForAll(unpack(workers))
end