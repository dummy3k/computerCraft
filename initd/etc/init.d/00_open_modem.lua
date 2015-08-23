if peripheral.getType("right") == "modem" then
	rednet.open("right")
	print("modem open")
else
	print("no modem found")
end