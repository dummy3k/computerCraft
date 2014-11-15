Logger = BaseClass:inherit("Logger")

function Logger:getParent()
	if self.name == "root" then
		return nil
	else
		return getLogger("root")
	end
end

function Logger:getAppenders()
	local retVal = {}
	for k, v in ipairs(config.loggers.root.appenders) do
		retVal[v] = config.appenders[v]
	end
	if self.appenders then
		for k, v in ipairs(self.appenders) do
			retVal[v] = config.appenders[v]
		end
	end
	return retVal
end

function Logger:getLevel()
	if self.level then
		return self.level
	else
		return config.root.level
	end
end

function Logger:log(level, s)
	-- for k, v in pairs(config.appenders) do
	-- for k, v in ipairs(self.appenders) do
	if getLevelValue(level) >= getLevelValue(self:getLevel()) then
		for k, appender in pairs(self:getAppenders()) do
			-- local appender = config.appenders[v]
			appender:append({msg=s, level=level, loggerName=self.name, day=os.day(), time=os.time()})
		end
	end
end

function Logger:debug(s)
	self:log("DEBUG", s)
end

function Logger:info(s)
	self:log("INFO", s)
end