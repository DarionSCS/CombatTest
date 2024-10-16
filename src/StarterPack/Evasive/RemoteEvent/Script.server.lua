script.Parent.OnServerEvent:Connect(function(plr,direction,mouseaim)

	local hrp = plr.Character:WaitForChild("HumanoidRootPart")
	local RS = game:GetService("ReplicatedStorage")
	
	-- FOLDERS --
	local Remotes = RS.Remotes
	local Tween = game:GetService("TweenService")
	local Replicate = Remotes.Replicate

	local Hits = {}
	local Modules = game.ReplicatedStorage.Modules
	local misc = require(Modules.Misc)
	local CS = game:GetService("CollectionService")
	local tag = "Ragdoll"
	local M1Damage = 15
	local AirImmunityTag = "AirDown"

	local bh = RS.FX.BillboardGui:Clone()


	bh.Parent = hrp
	local hum = hrp.Parent:FindFirstChild("Humanoid")

	local TweenService = game:GetService("TweenService")
	spawn(function()
		local willTween = bh.PB:TweenSize(
			UDim2.new(0, 500, 0, 55),  -- endSize (required)
			Enum.EasingDirection.Out,    -- easingDirection (default Out)
			Enum.EasingStyle.Back,      -- easingStyle (default Quad)
			0.6,                          -- time (default: 1)
			false,                       -- should this tween override ones in-progress? (default: false)
			nil                    -- a function to call when the tween completes (default: nil)
		)
		wait(0.8)
		local willTween2 = bh.PB:TweenSize(
			UDim2.new(0, 500, 0, 0),  -- endSize (required)
			Enum.EasingDirection.In,    -- easingDirection (default Out)
			Enum.EasingStyle.Sine,      -- easingStyle (default Quad)
			0.5,                          -- time (default: 1)
			false,                       -- should this tween override ones in-progress? (default: false)
			nil                    -- a function to call when the tween completes (default: nil)
		)

	end)


	game.Debris:AddItem(bh,5)
	local ia =	plr.Character:FindFirstChild("iFrames")
	spawn(function()
		ia.Value = true
		wait(1)
		ia.Value = false
	end)
	spawn(function()
		local FSS = RS.FX.Evasive.Flashstep:Clone()
		FSS.Parent = hrp
		FSS:Emit(FSS:GetAttribute("EmitCount"))
		game.Debris:AddItem(FSS,3.5)
	end)

	local SMK = RS.FX.Evasive.Smoke:Clone()
	SMK.Parent = hrp
	SMK.Smoke:Emit(SMK.Smoke:GetAttribute("EmitCount"))
	game.Debris:AddItem(SMK,3.5)
end)

