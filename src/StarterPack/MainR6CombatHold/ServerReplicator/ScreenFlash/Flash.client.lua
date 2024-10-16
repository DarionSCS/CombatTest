script.Parent.OnClientEvent:Connect(function(plr)
	local lighting = game.Lighting
	local cc = lighting.ColorCorrection
	local TweenService = game:GetService("TweenService")

	local tweenInfo = TweenInfo.new(
		0.3, -- Time
		Enum.EasingStyle.Linear, -- EasingStyle
		Enum.EasingDirection.Out, -- EasingDirection
		0, -- RepeatCount (when less than zero the tween will loop indefinitely)
		true, -- Reverses (tween will reverse once reaching it's goal)
		0 -- DelayTime
	)

	local tween = TweenService:Create(cc, tweenInfo, { Brightness = -0.8 })

	tween:Play()
	wait(0.4)
	tween:Play()
end)