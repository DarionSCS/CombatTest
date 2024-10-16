
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local UIS = game:GetService("UserInputService")
local plr = game.Players.LocalPlayer
Mouse = plr:GetMouse()
local Debounce = 1





local char = plr.CharacterAdded:Wait()


local isA = char:FindFirstChild("IsAttacking")
UIS.InputBegan:Connect(function(Input,isTyping)
	if Input.KeyCode == Enum.KeyCode.T and Debounce == 1  then
		if isTyping then return end
		if isA == true then return end
		if Player.Character:FindFirstChild("isBlocking").Value == true then return end
		if Player.Character:FindFirstChild("IsAttacking").Value == true then return end
		if Player.Character:FindFirstChild("IsJumping").Value == true then return end
if Player.Character:FindFirstChild("Ragdoll") then return end
		if Player.Character:FindFirstChild("PBSTUN") then return end	
		if Player.Character:FindFirstChild("noJump") then return end

		
		Debounce = 2

		local mousepos = Mouse.Hit
		
		
		local Track2 = plr.Character.Humanoid:LoadAnimation(script.PunchA)
		Track2:Play()	
		script.RemoteEvent:FireServer(mousepos,Mouse.Hit.p)
		wait(7) -- COOLDOWN
		Debounce = 1
		end
end)
