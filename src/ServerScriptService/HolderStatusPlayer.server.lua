-- SERVICES --
local CS = game:GetService("CollectionService")
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- FOLDERS --
local Modules = RS:WaitForChild("Modules")
local Remotes = RS:WaitForChild("Remotes")

-- MODULES --
local miscModule = require(Modules:WaitForChild("Misc"))

-- EVENTS --
local Replicate = Remotes:WaitForChild("Replicate")

-- FUNCTIONS --



Players.PlayerAdded:Connect(function(Player)
	if not Player:FindFirstChild("isBlocking") then
		local val = Instance.new("BoolValue")
		val.Name = "isBlocking"
		val.Parent = Player
	end
	
	if not Player:FindFirstChild("canBlock") then
		local val = Instance.new("BoolValue")
		val.Name = "canBlock"
		val.Parent = Player
	end
	
	if not Player:FindFirstChild("canRun") then
		local val = Instance.new("BoolValue")
		val.Name = "canRun"
		val.Parent = Player
	end
	
	if not Player:FindFirstChild("canDash") then
		local val = Instance.new("BoolValue")
		val.Name = "canDash"
		val.Parent = Player
	end
end)