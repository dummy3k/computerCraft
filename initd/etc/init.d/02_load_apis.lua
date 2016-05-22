local API_DIRECTORY = "/etc/api.d"

if not fs.exists(API_DIRECTORY) then
	print("creating ", API_DIRECTORY)
	fs.makeDir(API_DIRECTORY)
end

for k, v in pairs(fs.list(API_DIRECTORY)) do
	-- print(k..": "..tostring(v))
	os.loadAPI(API_DIRECTORY.."/"..v)
	-- api_name = string.gsub(v, ".lua$", "")
	-- api_name = v
	-- _G[api_name].serve()
	-- call_by_string(_G[api_name], "serve")
end

local BIN_DIRECTORY = "/bin"
if fs.exists(BIN_DIRECTORY) then
	print("path +", BIN_DIRECTORY)
	shell.setPath(shell.path()..":"..BIN_DIRECTORY)
end

