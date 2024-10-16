-- SERVICES --
local CS = game:GetService("CollectionService")
local StarterPlayer = game:GetService("StarterPlayer")

-- MODULES --
local ragdollBuilder = require(script.RagdollBuilder)

-- MISC VARIABLES --
local ragdollParts = script.RagdollParts

script.RagdollClient.Parent = StarterPlayer.StarterPlayerScripts

game.Players.PlayerAdded:Connect(function(player)
	if not player.Character then
		player.CharacterAdded:Connect(function(char)

			local clones = {}
			for i, v in pairs(ragdollParts:GetChildren()) do
				clones[v.Name] = v:Clone()
			end

			for i, v in pairs(clones) do
				if v:IsA("Attachment") then
					v.Parent = char[v:GetAttribute("Parent")]
				elseif v:IsA("BallSocketConstraint") then
					v.Parent = char.Torso
					v.Attachment0 = clones[v:GetAttribute("0")]
					v.Attachment1 = clones[v:GetAttribute("1")]
				else
					v.Part0 = char.HumanoidRootPart
					v.Part1 = char.Torso
					v.Parent = char.HumanoidRootPart
				end
			end
		end)
	else
		local char = player.Character
		
		local clones = {}
		for i, v in pairs(ragdollParts:GetChildren()) do
			clones[v.Name] = v:Clone()
		end

		for i, v in pairs(clones) do
			if v:IsA("Attachment") then
				v.Parent = char[v:GetAttribute("Parent")]
			elseif v:IsA("BallSocketConstraint") then
				v.Parent = char.Torso
				v.Attachment0 = clones[v:GetAttribute("0")]
				v.Attachment1 = clones[v:GetAttribute("1")]
			else
				v.Part0 = char.HumanoidRootPart
				v.Part1 = char.Torso
				v.Parent = char.HumanoidRootPart
			end
		end
	end
end)

CS:GetInstanceAddedSignal("Ragdoll"):Connect(function(v)
	if v:IsA("Model") then
		ragdollBuilder:Ragdoll(v)
	end
end)

CS:GetInstanceRemovedSignal("Ragdoll"):Connect(function(v)
	if v:IsA("Model") then
		ragdollBuilder:Unragdoll(v)
	end
end)
