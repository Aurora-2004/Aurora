repeat task.wait() 

until game:IsLoaded() and game:GetService"Players".LocalPlayer and game:GetService"Players".LocalPlayer.Character

local JoinedServers, Place = {}, nil

local Data = game:GetService("HttpService"):JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'))

if isfile("AuroraServerHop.txt") then
    
    JoinedServers = game:GetService"HttpService":JSONDecode(readfile("AuroraServerHop.txt"))

    if #JoinedServers >= 200 then
        
        JoinedServers = {}

    end

end

function FindServer()

    for i, v in next, Data.data do

        if v.playing < v.maxPlayers and v.id ~= game.JobId and not table.find(JoinedServers, v.id) then

            return v
            
        end

    end

end 

Place = FindServer()

JoinedServers[#JoinedServers + 1] = Place.id

writefile("AuroraServerHop.txt", game:GetService"HttpService":JSONEncode(JoinedServers))

while task.wait(1) do

    local Success, Error = pcall(function()
    
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, Place.id, game:GetService"Players".LocalPlayer)

    end)

    if not Success then

        warn(Error)
            
        Place = FindServer()

        JoinedServers[#JoinedServers + 1] = Place.id

        writefile("AuroraServerHop.txt", game:GetService"HttpService":JSONEncode(JoinedServers))

    end

end
