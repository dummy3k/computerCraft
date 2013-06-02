-- http://pastebin.com/VNAPTwzc

local level = "DEBUG"
local LOG_SERVER = 183

function debug(s1, s2, s3, s4, s5, s6, s7, s8, s9, s10)
	rednetSend("DEBUG", {s1, s2, s3, s4, s5, s6, s7, s8, s9, s10})
	if level == "INFO" then return end
	print(os.day(),":",os.time()," ",s1, s2, s3, s4, s5, s6, s7, s8, s9, s10)
end

function info(s1, s2, s3, s4, s5, s6, s7, s8, s9, s10)
	rednetSend("INFO", {s1, s2, s3, s4, s5, s6, s7, s8, s9, s10})
	print(os.day(),":",os.time()," ",s1, s2, s3, s4, s5, s6, s7, s8, s9, s10)
end

function warn(s1, s2, s3, s4, s5, s6, s7, s8, s9, s10)
	rednetSend("WARN", {s1, s2, s3, s4, s5, s6, s7, s8, s9, s10})
	print(os.day(),":",os.time()," ",s1, s2, s3, s4, s5, s6, s7, s8, s9, s10)
end

function error(s1, s2, s3, s4, s5, s6, s7, s8, s9, s10)
	rednetSend("ERROR", {s1, s2, s3, s4, s5, s6, s7, s8, s9, s10})
	print(os.day(),":",os.time()," ",s1, s2, s3, s4, s5, s6, s7, s8, s9, s10)
end

function setLevel(value)
	level = value
end

function rednetSend(msg_level, params)
	local text = ""
	for k, v in pairs(params) do
		text = text..tostring(v)
	end
	
	msg = {level = msg_level, msg=text, host=os.getComputerLabel()}
	msg = textutils.serialize(msg)
	--print(msg)
	rednet.send(LOG_SERVER, msg)
end
