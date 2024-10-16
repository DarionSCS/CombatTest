-- SERVICES --
local CS = game:GetService("CollectionService")

-- OTHER VARIABLES --
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

-- FUNCTIONS --
humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)

local head = char:WaitForChild("Head")
head.Shape = Enum.PartType.Ball
head.Size = Vector3.new(1,1,1)

CS:GetInstanceAddedSignal("Ragdoll"):Connect(function(v)
	if v == char then
		humanoid:ChangeState(Enum.HumanoidStateType.Physics)
		hrp:ApplyAngularImpulse(Vector3.new(90, 0, 0))
	end
end)

CS:GetInstanceRemovedSignal("Ragdoll"):Connect(function(v)
	if v == char then
		humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	end
end)