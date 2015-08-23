--rednet.open("right")
print("pingd running...")

while true do
	sender, msg = rednet.receive("ping")
	print(msg)
	if msg == "echo_request" then
		rednet.send(sender, "echo_response", "ping")
	end
end