

if not game:IsLoaded() then
    game.IsLoaded:Wait()
end

--[[ Services ]]--

local Services = setmetatable({}, {
    __index = function(self, index)
        return game:GetService(index)
    end
})

local Players           = Services.Players
local ReplicatedStorage = Services.ReplicatedStorage
local RunService        = Services.RunService
local HttpService       = Services.HttpService

--[[ Dependencies ]]--

local Player           = Players.LocalPlayer
local ClientIsDragging = ReplicatedStorage.Interaction.ClientIsDragging
local SendUserNotice   = ReplicatedStorage.Notices.SendUserNotice

--[[ Tables ]]--

local Utility     = {}
local TreeRegions = {}

--[[ Utility ]]--

function Utility:IsClientAlive()
    if not Player.Character then
        return
    end
    local Humanoid = Player.Character:FindFirstChild("Humanoid")
    return ((Humanoid and Humanoid.Health > 0) and Humanoid)
end

function Utility:Teleport(Position)
    local Humanoid = self:IsClientAlive()
    if not Humanoid then
        return
    end
    ((Humanoid.SeatPart ~= nil and Humanoid.SeatPart.Parent) or Player.Character):PivotTo(Position)
end

function Utility:SendNotice(Message, Duriation)
    local Message   = Message or ""
    pcall(function()
        SendUserNotice:Fire(Message, Duriation)
    end)
end

function Utility:SendDiscordMessage(Tree, WebhookUrl)
    local TreeClass    = Tree:FindFirstChild("TreeClass").Value
    local TreePosition = CFrame.new(Tree:FindFirstChild("WoodSection").CFrame.p)
    local Request      = http_request or request or HttpPost

    --// 100% stolen from Ivanos spook finder in 2022 \\--
    local url = WebhookUrl
    local data = {["content"] = "",["embeds"] = {{["title"] = "Tree Found: "..TreeClass, ["type"] = "rich", ["color"] = 0xD3FFFF, ["fields"] = {{["name"] = "Game Link:", ["value"] = '```game:GetService("TeleportService"):TeleportToPlaceInstance(' ..game.PlaceId .. ', "' .. game.JobId .. '", game.Players.LocalPlayer)```', ["inline"] = true},{["name"] = "Teleport Script:", ["value"] = "```game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new("..tostring(TreePosition)..")```",["inline"] = false},{["name"] = "Console Script:", ["value"] = '```Roblox.GameLauncher.joinGameInstance(' ..game.PlaceId .. ', "' .. game.JobId .. '")```',["inline"] = false},},}}}
    local headers = {["content-type"] = "application/json"}
    local spookyfinder = {Url = url, Body = game:GetService("HttpService"):JSONEncode(data), Method = "POST", Headers = headers}

    local Response = Request(spookyfinder)
    print(Response or "invalid response")
end

function Utility:Drag(Object)
    for i = 1, 3 do
        ClientIsDragging:FireServer(Object)
    end
end

function Utility:CollectTreeRegions()
    for _, Region in next, workspace:GetChildren() do
        if Region.Name == "TreeRegion" then
            table.insert(TreeRegions, Region)
        end
    end
end; Utility:CollectTreeRegions()

function Utility:GetTreeOfClass(TreeClasses)
    for _, Region in next, TreeRegions do
        for _, Tree in next, Region:GetChildren() do
            local Owner, TreeClass = Tree:FindFirstChild("Owner"), Tree:FindFirstChild("TreeClass")
            if Owner and Owner.Value == nil and TreeClass and table.find(TreeClasses, TreeClass.Value) then
                return Tree
            end
        end
    end
    return false
end

queue_on_teleport([[
    repeat task.wait() until game:IsLoaded()
    task.wait(10)
    loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Aurora-2004/Aurora/refs/heads/main/Games/LumberTycoon2/TreeFinder.lua"))()
]])

local SpookyTree = Utility:GetTreeOfClass({"Spooky", "SpookyNeon"})
if SpookyTree then
    local Message = string.format("%s Tree Found", SpookyTree.TreeClass.Value)
    Utility:Teleport(CFrame.new(SpookyTree:GetPivot().p) + Vector3.new(5, 5, 0))
    repeat task.wait() Utility:Drag(SpookyTree) until SpookyTree.Owner.Value == Player
    Utility:SendNotice(Message)
    print(getgenv().WebHook)
    if getgenv().WebHook then
        Utility:SendDiscordMessage(SpookyTree, getgenv().WebHook)
        task.wait(1)
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Aurora-2004/Aurora/refs/heads/main/Modules/ServerHopper.lua"))()
    end
    return
end

Utility:SendNotice("No Trees Found !")
loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Aurora-2004/Aurora/refs/heads/main/Modules/ServerHopper.lua"))()

print("TehSilent was here :)")
