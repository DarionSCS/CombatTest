
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local UIS = game:GetService("UserInputService")
local plr = game.Players.LocalPlayer
Mouse = plr:GetMouse()
local Debounce = 1

local char = plr.CharacterAdded:Wait()


local isA = char:FindFirstChild("IsAttacking")
UIS.InputBegan:Connect(function(Input,isTyping)
	if Input.KeyCode == Enum.KeyCode.R and Debounce == 1 then
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
	
		
		local slide = Instance.new("BodyVelocity")
		slide.MaxForce = Vector3.new(1,0,1) *30000	
		slide.Name = "Sld"
		slide.Parent = char.HumanoidRootPart
		slide.Velocity = char.HumanoidRootPart.CFrame.lookVector * 65
		game.Debris:AddItem(slide,0.35)
		local mousepos = Mouse.Hit
		
			plr.Character.HumanoidRootPart.Anchored = false
	
		
		script.RemoteEvent.Script.Thrust:Play()
		script.RemoteEvent:FireServer(mousepos,Mouse.Hit.p)
		wait(5) --COOLDOWN
		Debounce = 1
		end
end)
