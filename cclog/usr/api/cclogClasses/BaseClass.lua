BaseClass = {types = {}}

function BaseClass:inherit(typeName, o)
	o = o or {}
	-- o = {}
	setmetatable(o, self)
	self.__index = self
	self.types[typeName] = o
	return o
end
	
function BaseClass:load(config)
	--[[
	print("---load()----")
	for k, v in pairs(self.types) do
		print("***"..k..": "..tostring(v))
	end
	]]--

	--o = o or {}
	local o = {}
	setmetatable(o, self)
	self.__index = self
  
	local config = config or {}
	for k, v in pairs(config) do
		-- print(k..": "..tostring(v))
		--print(k..": "..type(v))
		if type(v)=="table" then
			if v.type then
				o[k] = self.types[v.type]:load(v)
			else
				o[k] = BaseClass:load(v)
			end
		else
			o[k] = v
		end
	end
	-- print("-------------")
	return o
end
	
