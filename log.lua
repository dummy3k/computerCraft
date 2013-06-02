local level = "DEBUG"

function debug(s1, s2, s3, s4, s5, s6, s7, s8, s9, s10)
	if level == "INFO" then return end
    print(os.day(),":",os.time()," ",s1, s2, s3, s4, s5, s6, s7, s8, s9, s10)
end

function info(s1, s2, s3, s4, s5, s6, s7, s8, s9, s10)
    print(os.day(),":",os.time()," ",s1, s2, s3, s4, s5, s6, s7, s8, s9, s10)
end

function warn(s1, s2, s3, s4, s5, s6, s7, s8, s9, s10)
    print(os.day(),":",os.time()," ",s1, s2, s3, s4, s5, s6, s7, s8, s9, s10)
end

function setLevel(value)
	level = value
end
