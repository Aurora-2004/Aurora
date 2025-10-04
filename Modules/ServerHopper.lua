
--// Thanks chat gpt bc I am lazy \\--

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Player = Players.LocalPlayer
local Cache = {}

-- Load cached server IDs from file
if isfile("CachedServers.txt") then
	local success, result = pcall(function()
		return HttpService:JSONDecode(readfile("CachedServers.txt"))
	end)
	if success and typeof(result) == "table" then
		Cache = result
	end
end

-- Reset cache if it gets too large
if #Cache >= 200 then
	Cache = {}
end

-- Function to find a new server
local function FindNewServer()
	local success, response = pcall(function()
		return game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
	end)

	if not success then
		warn("HTTP request failed:", response)
		return false
	end

	local parsedSuccess, data = pcall(function()
		return HttpService:JSONDecode(response)
	end)

	if not parsedSuccess then
		warn("Failed to parse JSON:", data)
		return false
	end

	for _, server in ipairs(data.data or {}) do
		if server.playing < server.maxPlayers - 1 and server.id ~= game.JobId and not table.find(Cache, server.id) then
			return server
		end
	end

	return false
end

-- Main loop to try teleporting to a new server
while task.wait(1) do
	local success, err = pcall(function()
		local newServer = FindNewServer()
		if newServer then
			table.insert(Cache, newServer.id)
			writefile("CachedServers.txt", HttpService:JSONEncode(Cache))
			TeleportService:TeleportToPlaceInstance(game.PlaceId, newServer.id, Player)
		else
			warn("No suitable server found.")
		end
	end)

	if not success then
		warn("Teleport attempt failed:", err)
	end
end
