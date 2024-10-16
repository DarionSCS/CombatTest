-- SERVICES --
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local cs = game:GetService("CollectionService")

-- FOLDERS --
local Remotes = RS:WaitForChild("Remotes")
local Modules = RS:WaitForChild("Modules")

-- EVENTS --
local Replicate = Remotes.Replicate

-- MODULES --
local Misc = require(Modules.Misc)

local char = script.Parent
local hum = char:WaitForChild("Humanoid")
local player = Players[char.Name]



local pStatus = player:WaitForChild("Status")
local pDefense = pStatus:WaitForChild("Defense")
local isBlocking = player:WaitForChild("isBlocking")
local canRun, canDash = player:WaitForChild("canRun"), player:WaitForChild("canDash")

local isBlockBroken = false

local function updateHealth()
	if hum.Health ~= hum.MaxHealth then
		hum.MaxHealth = 100 * (1 + (pDefense.Value * 0.1))
	else
		hum.MaxHealth = 100 * (1 + (pDefense.Value * 0.1))
		hum.Health = 100 * (1 + (pDefense.Value * 0.1))
	end
end

-- FUNCTIONS --
updateHealth()

pDefense:GetPropertyChangedSignal("Value"):Connect(function()
	updateHealth()
end)

hum.Died:Connect(function()
	Replicate:FireAllClients("Death", char)
	Replicate:FireClient(game.Players[char.Name], "DeathScreen", game.Players[char.Name])
end)

char.ChildAdded:Connect(function(Object)
	if Object.Name == "Disabled" then
		hum.WalkSpeed = 4
		hum.JumpPower = 6
		canDash.Value = false
		canRun.Value = false
	elseif Object.Name == "Ragdoll" then	
		if not cs:HasTag(char, "Ragdoll") then
			cs:AddTag(char, "Ragdoll")
		end
	elseif Object.Name == "OnFire" then	
		if not cs:HasTag(char, "OnFire") then
			cs:AddTag(char, "OnFire")
		end
	end
end)

char.ChildRemoved:Connect(function(Object)
	if Object.Name == "Disabled" then
		if not char:FindFirstChild("Disabled") then
			hum.WalkSpeed = 16
			hum.JumpPower = 50
			canDash.Value = true
			canRun.Value = true
		end
	elseif Object.Name == "Ragdoll" then
		if not char:FindFirstChild("Ragdoll") then
			if cs:HasTag(char, "Ragdoll") then
				cs:RemoveTag(char, "Ragdoll")
			end
		end
	elseif Object.Name == "OnFire" then
		if not char:FindFirstChild("OnFire") then
			if cs:HasTag(char, "OnFire") then
				cs:RemoveTag(char, "OnFire")
			end
		end
	end
end)

-- BLOCKING HANDLER --
local blockingIdle


isBlocking.Changed:Connect(function()
	if isBlocking.Value then
		blockingIdle = hum:LoadAnimation(script.BlockingIdle)
		if not isBlockBroken and not char:FindFirstChild("Disabled") then
			blockingIdle:Play()

			local blockBar = Instance.new("IntValue")
			blockBar.Name = "BlockBar"
			blockBar.Value = hum.MaxHealth
			blockBar.Parent = char
		
			
			canDash.Value = false
			canRun.Value = false
			
			hum.WalkSpeed = 8
			hum.JumpPower = 20
			
			cs:AddTag(char, "Perfect Block")
			task.delay(0.2, function()
				cs:RemoveTag(char, "Perfect Block")
			end)
			
			blockBar.Changed:Connect(function(newValue)
				if newValue <= 0 and not isBlockBroken then
					isBlockBroken = true
					Replicate:FireAllClients("Combat", "HitFX", char.HumanoidRootPart, "Block Break")
					Misc.InsertDisabled(char, 2.7)
					blockBar:Destroy()
					blockingIdle:Stop()
					task.delay(1.5, function()
						isBlockBroken = false
						canDash.Value = true
						canRun.Value = true
						hum.WalkSpeed = 16
						hum.JumpPower = 50
					end)
				elseif newValue > 0 and not isBlockBroken then
				
				end
			end)
		end
	else
		blockingIdle:Stop()
	
		local blockBar = char:FindFirstChild("BlockBar")
		if blockBar then
			blockBar:Destroy()
		end
		if not isBlockBroken then
			canDash.Value = true
			canRun.Value = true
			hum.WalkSpeed = 16
			hum.JumpPower = 50
		end
	end
end)
