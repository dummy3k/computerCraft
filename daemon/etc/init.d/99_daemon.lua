local FileList = fs.list("/etc/daemon.d") --Table with all the files and directories available


workers = {}
for _, file in ipairs(FileList) do --Loop. Underscore because we don't use the key, ipairs so it's in order
	if file ~= "readme.txt" then
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

parallel.waitForAll(unpack(workers))
