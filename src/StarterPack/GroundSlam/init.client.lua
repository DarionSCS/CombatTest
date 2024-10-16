
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local UIS = game:GetService("UserInputService")
local plr = game.Players.LocalPlayer
Mouse = plr:GetMouse()
local Debounce = 1

local char = plr.CharacterAdded:Wait()


local isA = char:FindFirstChild("IsAttacking")
UIS.InputBegan:Connect(function(Input,isTyping)
	if Input.KeyCode == Enum.KeyCode.E and Debounce == 1 then
		if isTyping then return end
		if isA == true then return end
		if Player.Character:FindFirstChild("isBlocking").Value == true then return end
		if Player.Character:FindFirstChild("IsAttacking").Value == true then return end
		if Player.Character:FindFirstChild("IsJumping").Value == true then return end
if Player.Character:FindFirstChild("Ragdoll") then return end
		if Player.Character:FindFirstChild("PBSTUN") then return end	
		if Player.Character:FindFirstChild("noJump") then return end
		Debounce = 2
		local Track2 = plr.Character.Humanoid:LoadAnimation(script.PunchA)
		Track2:Play()
		wait(0.1)
		script.RemoteEvent.Script.Flips:Play()
	plr.Character.Humanoid.WalkSpeed = 8
		plr.Character.HumanoidRootPart.Anchored = false
		local BodyVelocity = Instance.new("BodyVelocity")
		BodyVelocity.MaxForce = Vector3.new(0,1e8,0)
		BodyVelocity.Velocity = plr.Character:FindFirstChild("HumanoidRootPart").CFrame.UpVector*35
		BodyVelocity.Parent = plr.Character:FindFirstChild("HumanoidRootPart")
		game.Debris:AddItem(BodyVelocity,0.3)
		local mousepos = Mouse.Hit
		
			plr.Character.HumanoidRootPart.Anchored = false
	
		wait(0.934)
		plr.Character.Humanoid.WalkSpeed = 16
		script.RemoteEvent.Script.Thrust:Play()
		script.RemoteEvent:FireServer(mousepos,Mouse.Hit.p)
		wait(6) --COOLDOWN
		Debounce = 1
		end
end)
