local module = {}
local Players = game:GetService("Players")

local PhysicsService = game:GetService("PhysicsService")

function module:Setup(char: Model)
	assert(
		Players:GetPlayerFromCharacter(char) == nil,
		"Setting up ragdoll on player characters is already done automatically"
	)

	local humanoid = char:FindFirstChild("Humanoid")
	assert(humanoid, "Can only set-up ragdoll on R6 humanoid rigs")
	assert(humanoid.RigType == Enum.HumanoidRigType.R6, "Can only set-up ragdoll on R6 humanoid rigs")
	assert(humanoid.RootPart ~= nil, "No RootPart was found in the provided rig")
	assert(char:FindFirstChild("HumanoidRootPart"), "No HumanoidRootPart was found in the provided rig")

	for _, v: BasePart in ipairs(char:GetDescendants()) do
		if v:IsA("BasePart") then
			v:SetNetworkOwner(nil)
		end
	end

	-- Setup ragdoll
	local clones = {}
	for i, v in pairs(script.Parent.RagdollParts:GetChildren()) do
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

	-- Ragdoll trigger
	local trigger = Instance.new("BoolValue")
	trigger.Name = "RagdollTrigger"
	trigger.Parent = char

	trigger.Changed:Connect(function(bool)
		if bool then
			module:Ragdoll(char)
		else
			module:Unragdoll(char)
		end
	end)
end

function module:Ragdoll(char: Model)
	local hrp = char.HumanoidRootPart
	local humanoid = char.Humanoid
	local weld = hrp:FindFirstChild("RagdollWeld")
	if not weld then
		weld = Instance.new("WeldConstraint")
		weld.Name = "RagdollWeld"
		weld.Part0 = hrp
		weld.Part1 = char.Torso
		weld.Parent = hrp
	end

	weld.Enabled = true
	hrp.CanCollide = false
	humanoid.AutoRotate = false
	humanoid:ChangeState(Enum.HumanoidStateType.Physics)
	for i, v in pairs(char:GetDescendants()) do
		if v:IsA("BasePart") then
			PhysicsService:SetPartCollisionGroup(v, "Ragdoll")
		elseif v:IsA("Motor6D") then
			v.Enabled = false
		elseif v:IsA("BallSocketConstraint") then
			v.Enabled = true
		end
	end

	hrp:ApplyAngularImpulse(Vector3.new(90, 0, 0))
end

function module:Unragdoll(char: Model)
	local hrp = char.HumanoidRootPart
	local humanoid = char.Humanoid
	local weld = hrp:FindFirstChild("RagdollWeld")
	if not weld then
		weld = Instance.new("WeldConstraint")
		weld.Name = "RagdollWeld"
		weld.Part0 = hrp
		weld.Part1 = char.Torso
		weld.Parent = hrp
	end

	weld.Enabled = false
	hrp.CanCollide = true
	humanoid.AutoRotate = true
	humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	for i, v in pairs(char:GetDescendants()) do
		if v:IsA("BasePart") then
			PhysicsService:SetPartCollisionGroup(v, "Default")
		elseif v:IsA("Motor6D") then
			v.Enabled = true
		elseif v:IsA("BallSocketConstraint") then
			v.Enabled = false
		end
	end
end

return module
