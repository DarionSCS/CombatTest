local UIS = game:GetService("UserInputService")
local DefaultFOV = 70
 
local lastTime = tick()
local player = game.Players.LocalPlayer

local char = game:GetService("Players").LocalPlayer.Character
local hum = char:WaitForChild("Humanoid")
local run = false
local Track1 
local Track2
	
local isAttacking = char:WaitForChild("IsAttacking")


UIS.InputBegan:Connect(function(input,gameprocessed)
	if input.KeyCode == Enum.KeyCode.W and isAttacking.Value == false then
		if char:FindFirstChild("IsAttacking").Value == true then return end
		if char:FindFirstChild("PBSTUN") then return end
		if char:FindFirstChild("isBlocking").Value == true then return end
		if char:FindFirstChild("noJump") then return end
		local now = tick()
		local difference = (now - lastTime)
		
		if difference <= 0.5 then
			
			
			run = true
				
				Track1 = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(script.Animation)
				
			Track1:Play()
			
									
				hum.WalkSpeed = 27.5

				local properties = {FieldOfView = DefaultFOV + 17}
				local Info = TweenInfo.new(0.5,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,0.1)
				local T = game:GetService("TweenService"):Create(game.Workspace.CurrentCamera,Info,properties)
				T:Play()
			
	
		
		end
		lastTime = tick()
	end
end)
 
UIS.InputEnded:Connect(function(input,gameprocessed)
	if input.KeyCode == Enum.KeyCode.W then
		run = false
	if Track1 then
			Track1:Stop()
	end
		hum.WalkSpeed = 16
		local properties = {FieldOfView = DefaultFOV}
		local Info = TweenInfo.new(0.5,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,0.1)
		local T = game:GetService("TweenService"):Create(game.Workspace.CurrentCamera,Info,properties)
		T:Play()
 
	end
 
end)
 
