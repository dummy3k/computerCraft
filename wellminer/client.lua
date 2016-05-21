PROTOCOLL = "mine"

--client_ids = {22, 23, 24, 25, 27}
client_ids = {}

function update()
	local f = fs.open("99_mine_daemon.lua", "r")
	content = f:readAll()
	f:close()
	msg = {cmd="update", payload=content}
	exec_cmd(msg)
	-- msg = textutils.serialize(msg)
	-- rednet.broadcast(msg, PROTOCOLL)

	-- -- rednet.send(10, msg, PROTOCOLL)
	-- while true do
		-- sender, msg = rednet.receive("mine", 3)
		-- -- print(tostring(sender)..": "..tostring(msg))
		-- if not sender then break end
		-- if not msg then break end
		-- msg = textutils.unserialize(msg)
		-- -- print(textutils.serialize(msg))
		-- print(sender..": v="..tostring(msg.version))
	-- end
end

function exec_cmd(msg, verbose)
	if not verbose then verbose = 0 end
	results = {}
	msg = textutils.serialize(msg)
	for _, id in ipairs(client_ids) do
		-- print(id)
		rednet.send(id, msg, PROTOCOLL)
	end

	count = 0
	while true do
		sender, msg = rednet.receive(PROTOCOLL, 60)
		if verbose > 0 then
			print(tostring(sender))
		end
		if verbose > 1 then
			print(tostring(sender)..": "..tostring(msg))
		end
		if not sender then break end
		count = count + 1
		table.insert(results, {sender=sender, msg=msg})
		if count >= #client_ids then break end
	end
	return results
end

function ping()
	msg = {cmd="echo_request"}
	exec_cmd(msg)
	-- -- rednet.send(10, msg, PROTOCOLL)
end

-- function dig()
	-- msg = {cmd="dig"}
	-- rednet.send(10, "dig", PROTOCOLL)
	-- rednet.send(12, "dig", PROTOCOLL)
-- end

function drop()
	while true do
		local retval = exec_cmd({cmd="drop"})
		local count = 0
		for _, v in ipairs(retval) do
			msg = textutils.unserialize(v.msg)
			-- print(v.sender..": "..tostring(msg.count))
			count = count + msg.count
		end
		print("dropped: "..tostring(count))
		if count == 0 then break end
	end
end

function scan()
	msg = {cmd="echo_request"}
	msg = textutils.serialize(msg)
	rednet.broadcast(msg, PROTOCOLL)
	
	local retval = {}
	local count = 0
	while true do
		sender, msg = rednet.receive("mine", 1)
		print(tostring(sender)..": "..tostring(msg))
		if not sender then break end
		count = count + 1
		table.insert(retval, sender)
	end
	print("count: "..tostring(count))
	return retval
end

-- update()

--dig()
-- ping()

function main(tArgs)
	cmd = tArgs[1]
	if cmd == "scan" then
		print(tostring(scan()))
	else
		client_ids = scan()
		-- client_ids = {31, 32}
		if cmd == "update" then
			update()
		elseif cmd == "ping" then
			ping()
		elseif cmd == "drop" then
		elseif cmd == "cmd" then
			exec_cmd({cmd=tArgs[2]}, tonumber(tArgs[3]))
		elseif cmd == "refuel" then
			exec_cmd({cmd="shell", args = {"refuel", "all"}})
		elseif cmd == "cycle" then
			local count = 1
			if tArgs[2] then
				count = tonumber(tArgs[2])
			end
			for n=1,count do
				exec_cmd({cmd="cycle"})
				print("cycle: "..tostring(n))
			end
		end
	end
end

local tArgs = {...}
main(tArgs)