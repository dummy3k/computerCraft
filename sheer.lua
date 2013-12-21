if not os.loadAPI("log") then	error("could not load log API") end

log.debug("start")
while true do
	if turtle.attack() then
		log.debug("sheer!")
	end
	os.sleep(5)
end
