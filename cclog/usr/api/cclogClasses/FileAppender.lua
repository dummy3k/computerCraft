FileAppender = BaseAppender:inherit("FileAppender")

function FileAppender:append(msg)
	local mode
	if fs.exists(self.filename) then
		mode = "a"
	else
		mode = "w"
	end
	
	f = io.open(self.filename, mode)
	f:write(self:renderMsg(msg).."\n")
	f:close()
end