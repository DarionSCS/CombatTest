local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local ReplicaController = require(ReplicatedStorage:WaitForChild("Replica"):WaitForChild("ReplicaController"))

ReplicaController.ReplicaOfClassCreated("PlayerData", function(Replica)
	if Replica.Tags.Player == Players.LocalPlayer then
		
		
		local pStats = Players.LocalPlayer:WaitForChild("Stats")
		
	end
end)


ReplicaController.RequestData()