local tArgs = {...}
rednet.open("right")

destination = tonumber(tArgs[1])
msg = "echo_request"

rednet.send(destination, msg, "ping")

timeout = 1
msg = ""
while msg ~= "echo_response" do
	sender, msg = rednet.receive("ping", timeout)
	if not sender then
		print("timeout")
		break
	end
	print("response: "..tostring(msg))
end
