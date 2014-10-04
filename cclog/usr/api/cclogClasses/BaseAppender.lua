BaseAppender = BaseClass:inherit("BaseAppender")

function BaseAppender:renderMsg(msg)
	return self.format:renderMsg(msg)
	-- return msg.msg
	--[[
	if type(msg)=="table" then
		return textutils.serialize(msg)
	else
		return msg
	end
	]]--
end
