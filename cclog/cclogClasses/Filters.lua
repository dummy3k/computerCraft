BaseFilter = BaseClass:inherit("BaseFilter")

function BaseFilter:allow(msg)
	return true
end
function BaseFilter:deny(msg)
	return false
end

LevelFilter = BaseFilter:inherit("LevelFilter")

function LevelFilter:allow(msg)
	return (getLevelValue(msg.level) >= getLevelValue(self.min))
end
