
repeat task.wait() until game:IsLoaded()

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
    return SendUserNotice:Fire(Message, Duriation)
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
    task.wait(5)
    loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Aurora-2004/Aurora/refs/heads/main/Games/LumberTycoon2/TreeFinder.lua"))()
]])

local SpookyTree = Utility:GetTreeOfClass({"Spooky", "SpookyNeon"})
if SpookyTree then
    local Message = string.format("%s found", SpookyTree.TreeClass.Value)
    Utility:Teleport(CFrame.new(SpookyTree:GetPivot().p) + Vector3.new(5, 5, 0))
    Utility:SendNotice(Message)
    return
end

loadstring(game:HttpGet"https://raw.githubusercontent.com/LeoKholYt/roblox/main/lk_serverhop.lua")():Teleport(game.PlaceId)
