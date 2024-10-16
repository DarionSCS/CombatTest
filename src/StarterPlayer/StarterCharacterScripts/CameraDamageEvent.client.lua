task.wait()

local RS = game:GetService("ReplicatedStorage")

local Modules = RS.Modules

local plr = game.Players.LocalPlayer
local char = plr.Character
local humanoid = char.Humanoid
local healthhumanoid = humanoid.Health

local camera = workspace.CurrentCamera

local CameraShaker = require(Modules.CameraShaker)

local camShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCFrame)
	camera.CFrame = camera.CFrame * shakeCFrame
end)

camShake:Start()

humanoid.HealthChanged:Connect(function(health)
	if healthhumanoid > health then
		camShake:Shake(CameraShaker.Presets.Bump)
	end
	healthhumanoid = health
end)