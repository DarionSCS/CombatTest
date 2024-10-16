-- SERVICES --
local TS = game:GetService("TweenService")
local CS = game:GetService("CollectionService")
local RS = game:GetService("ReplicatedStorage")
local PS = game:GetService("PhysicsService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Modules = RS:WaitForChild("Modules")
local Remotes = RS:WaitForChild("Remotes")
local Hitboxes = RS:WaitForChild("Hitboxes")

local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Character
local Humanoid
local HRP
local attackRemote = script:WaitForChild("Attack")
local Equipped = script:WaitForChild("Equipped")
local equippedIdle
local val = Player.Character:WaitForChild("isBlocking")
local Humanoid = Player.Character.Humanoid
local debs = false
local equiped = false
local Character = Player.Character

attackRemote:FireServer("Equip")


UIS.InputBegan:Connect(function(Input, isTyping)
	if isTyping then return end

	if Player.Character:FindFirstChild("PBSTUN") then return end

	if Input.UserInputType == Enum.UserInputType.MouseButton1 then
		if not Humanoid then return end
		if Humanoid.Health > 0 then
			local Disabled = Character:FindFirstChild("Disabled")
			if not Disabled then
				
				if UIS:IsKeyDown(Enum.KeyCode.Space) then
					attackRemote:FireServer("Attack", true)
				else
					attackRemote:FireServer("Attack", false)
				end
		
				coroutine.wrap(function()
					local noJumpValue = Instance.new("BoolValue")
					noJumpValue.Name = "noJump"
					noJumpValue.Parent = Character
					game.Debris:AddItem(noJumpValue, 1.4)
				end)()
			end
		end
	
	elseif Input.KeyCode == Enum.KeyCode.F then
		if not Humanoid then return end
		if Humanoid.Health > 0 then
			local Disabled = Character:FindFirstChild("Disabled")
			if not Disabled then
				val.Value = true
			
				attackRemote:FireServer("Block")
			end
		end

	end
end)

UIS.InputEnded:Connect(function(Input, isTyping)
	if isTyping then return end

	if Input.KeyCode == Enum.KeyCode.F then
		attackRemote:FireServer("Unblock")
		val.Value = false
	
	end
end)