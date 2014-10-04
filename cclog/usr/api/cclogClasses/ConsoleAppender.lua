ConsoleAppender = BaseAppender:inherit("ConsoleAppender")

function ConsoleAppender:append(msg)
	print(self:renderMsg(msg))
end