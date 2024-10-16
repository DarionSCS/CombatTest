-- SERVICES --
local RS = game:GetService("ReplicatedStorage")
local TS = game:GetService("TweenService")

-- FOLDERS --
local Modules = RS.Modules
local CS = game:GetService("CollectionService")
-- MODULES --
local rocksModule = require(Modules.RocksModule)
local debrisModule = require(Modules.Debris)

-- FUNCTIONS --
local function RoundNumber(num)
	return(math.floor(num+0.5))
end
local AirImmunityTag = "AirDown"
local Misc = require(Modules.Misc)
return function(Action, Variable2, Variable3)
	
		
if Action == "HitFX" then
		local Target = Variable2
		local Type = Variable3
		
		if Target ~= nil then
	
			if Type == "Basic Hit" then
				local hitFX = script.FX["Basic Hit"].Attachment:Clone()
				hitFX.Parent = Target

				local sfx = script.Sounds.BasicHit:Clone()
				sfx.Parent = hitFX
				sfx:Play()
				game.Debris:AddItem(sfx,3)
				for i, v in pairs(hitFX:GetChildren()) do
					if v:IsA("ParticleEmitter") then
						v:Emit(v:GetAttribute("EmitCount"))
					elseif v:IsA("PointLight") then
						v.Brightness = 0
						v.Range = 0
						TS:Create(v, TweenInfo.new(0.1), {Brightness = 1, Range = 10}):Play()
						task.delay(0.15, function()
							TS:Create(v, TweenInfo.new(0.1), {Brightness = 0, Range = 0}):Play()
						end)
					end
				end

				game.Debris:AddItem(hitFX, 2)

			
			elseif Type == "Block Break" then
				local fx = script.FX["Block Break"].Attachment:Clone()
				fx.Parent = Target
				
				local sfx = script.Sounds.BlockBreak:Clone()
				sfx.Parent = fx
				sfx:Play()
				local bh = script.FX["Block Break"].BillboardGui:Clone()
				
			
				bh.Parent = Target
				local hum = Target.Parent:FindFirstChild("Humanoid")
				local a = script.FX.BreakBlock:Clone()
				local track =	hum:LoadAnimation(a)
				track:Play()
				spawn(function()
					wait(1.7)
					track:Stop()
				end)
				game.Debris:AddItem(a,2)
				game.Debris:AddItem(track,2)
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
				for i, v in pairs(fx:GetChildren()) do
					if v:IsA("ParticleEmitter") then
						v:Emit(v:GetAttribute("EmitCount"))
					elseif v:IsA("PointLight") then
						v.Brightness = 0
						v.Range = 0
						TS:Create(v, TweenInfo.new(0.1), {Brightness = 1, Range = 10}):Play()
						task.delay(0.15, function()
							TS:Create(v, TweenInfo.new(0.1), {Brightness = 0, Range = 0}):Play()
						end)
					end
				end
			elseif Type == "HeavyHit" then
				local fx = script.FX["HeavyHit"].Attachment:Clone()
				fx.Parent = Target

			


				
				local hum = Target.Parent:FindFirstChild("Humanoid")
		

				local TweenService = game:GetService("TweenService")
		
				for i, v in pairs(fx:GetChildren()) do
					if v:IsA("ParticleEmitter") then
						v:Emit(v:GetAttribute("EmitCount"))
					elseif v:IsA("PointLight") then
						v.Brightness = 0
						v.Range = 0
						TS:Create(v, TweenInfo.new(0.1), {Brightness = 1, Range = 10}):Play()
						task.delay(0.15, function()
							TS:Create(v, TweenInfo.new(0.1), {Brightness = 0, Range = 0}):Play()
						end)
					end
				end
			elseif Type == "Perfect Block" then
				local fx = script.FX["Perfect Block"].Attachment:Clone()
				fx.Parent = Target
				local fx2 = script.FX["Perfect Block"].Attachment2:Clone()
				fx2.Parent = Target
			
				local pbt = script.FX["Perfect Block"].BillboardGui:Clone()
				pbt.Parent = Target
				local TweenService = game:GetService("TweenService")
				local hum = Target.Parent:FindFirstChild("Humanoid")
				local a = script.FX.Deflect:Clone()
				local track =	hum:LoadAnimation(a)
				track:Play()
				game.Debris:AddItem(a,1)
				spawn(function()
					local willTween = pbt.PB:TweenSize(
						UDim2.new(0, 500, 0, 55),  -- endSize (required)
						Enum.EasingDirection.Out,    -- easingDirection (default Out)
						Enum.EasingStyle.Back,      -- easingStyle (default Quad)
						0.6,                          -- time (default: 1)
						false,                       -- should this tween override ones in-progress? (default: false)
						nil                    -- a function to call when the tween completes (default: nil)
					)
					wait(0.8)
					local willTween2 = pbt.PB:TweenSize(
						UDim2.new(0, 500, 0, 0),  -- endSize (required)
						Enum.EasingDirection.In,    -- easingDirection (default Out)
						Enum.EasingStyle.Sine,      -- easingStyle (default Quad)
						0.5,                          -- time (default: 1)
						false,                       -- should this tween override ones in-progress? (default: false)
						nil                    -- a function to call when the tween completes (default: nil)
					)

				end)
				
				game.Debris:AddItem(fx,5)
				game.Debris:AddItem(fx2,5)
			
			game.Debris:AddItem(pbt,5)
			
				local sfx = script.Sounds.PerfectBlock1:Clone()
				sfx.Parent = fx
				sfx:Play()
				
				local sfx2 = script.Sounds.PerfectBlock2:Clone()
				sfx2.Parent = fx
				sfx2:Play()
				game.Debris:AddItem(sfx,5)
				game.Debris:AddItem(sfx2,5)
				for i, v in pairs(fx:GetChildren()) do
					if v:IsA("ParticleEmitter") then
						v:Emit(v:GetAttribute("EmitCount"))
					elseif v:IsA("PointLight") then
						v.Brightness = 0
						v.Range = 0
						TS:Create(v, TweenInfo.new(0.1), {Brightness = 1, Range = 10}):Play()
						task.delay(0.15, function()
							TS:Create(v, TweenInfo.new(0.1), {Brightness = 0, Range = 0}):Play()
						end)
					end
				end
				for i, v in pairs(fx2:GetChildren()) do
					if v:IsA("ParticleEmitter") then
						v:Emit(v:GetAttribute("EmitCount"))
					elseif v:IsA("PointLight") then
						v.Brightness = 0
						v.Range = 0
						TS:Create(v, TweenInfo.new(0.1), {Brightness = 1, Range = 10}):Play()
						task.delay(0.15, function()
							TS:Create(v, TweenInfo.new(0.1), {Brightness = 0, Range = 0}):Play()
						end)
					end
				end
				
			elseif Type == "Block Hit" then
				local fx = script.FX["Block Hit"].Attachment:Clone()
				fx.Parent = Target
				
				local sfx = script.Sounds.BlockHit:Clone()
				sfx.Parent = fx
				sfx:Play()
				local bh = script.FX["Block Hit"].BillboardGui:Clone()
				
				bh.Parent = Target
				local TweenService = game:GetService("TweenService")
				spawn(function()
					local willTween = bh.PB:TweenSize(
						UDim2.new(0, 500, 0, 25),  -- endSize (required)
						Enum.EasingDirection.Out,    -- easingDirection (default Out)
						Enum.EasingStyle.Back,      -- easingStyle (default Quad)
						0.35,                          -- time (default: 1)
						false,                       -- should this tween override ones in-progress? (default: false)
						nil                    -- a function to call when the tween completes (default: nil)
					)
					wait(0.4)
					local willTween2 = bh.PB:TweenSize(
						UDim2.new(0, 500, 0, 0),  -- endSize (required)
						Enum.EasingDirection.In,    -- easingDirection (default Out)
						Enum.EasingStyle.Sine,      -- easingStyle (default Quad)
						0.3,                          -- time (default: 1)
						false,                       -- should this tween override ones in-progress? (default: false)
						nil                    -- a function to call when the tween completes (default: nil)
					)

				end)


				game.Debris:AddItem(bh,5)
				for i, v in pairs(fx:GetChildren()) do
					if v:IsA("ParticleEmitter") then
						v:Emit(v:GetAttribute("EmitCount"))
					elseif v:IsA("PointLight") then
						v.Brightness = 0
						v.Range = 0
						TS:Create(v, TweenInfo.new(0.1), {Brightness = 1, Range = 10}):Play()
						task.delay(0.15, function()
							TS:Create(v, TweenInfo.new(0.1), {Brightness = 0, Range = 0}):Play()
						end)
					end
				end
			end
		end
	
	end
end