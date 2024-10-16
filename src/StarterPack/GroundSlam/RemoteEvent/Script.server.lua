script.Parent.OnServerEvent:Connect(function(plr,direction,mouseaim)
	local OnHit = false
	local Alive = true
	local Damage = 20
	local hrp = plr.Character:WaitForChild("HumanoidRootPart")
	local RS = game:GetService("ReplicatedStorage")
	
	-- FOLDERS --
	local Remotes = RS.Remotes
	local Tween = game:GetService("TweenService")
	local Replicate = Remotes.Replicate
	local Remotes2 = RS:WaitForChild("Events"):WaitForChild("Remotes")
	local HitCounterRemotes = Remotes2:WaitForChild("HitCounter")
	local Hits = {}
	local Modules = game.ReplicatedStorage.Modules
	local misc = require(Modules.Misc)
	local CS = game:GetService("CollectionService")
	local tag = "Ragdoll"
	local M1Damage = 15  
	local AirImmunityTag = "AirDown"
	local flh = game.ReplicatedStorage.Hitboxes.hbox3:Clone()
	flh.Parent = workspace.Debris
	flh.CFrame = hrp.CFrame *CFrame.new(0,-2,0)
	local Sound2 = script:WaitForChild("Hit")
	local ia =	plr.Character:FindFirstChild("IsAttacking")
	spawn(function()
		ia.Value = true
		wait(1)
		ia.Value = false
	end)
	local TS = game:GetService("TweenService")
	Replicate:FireAllClients("Shock", flh, flh.Position)
	spawn(function()
		for i, v in pairs(flh.Attachment:GetChildren()) do
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
	end)
	Replicate:FireClient(plr, "CamShake", hrp.Position, 3, 500 )
	flh.Touched:Connect(function(hit, Player)
		if hit.Parent:FindFirstChild("Humanoid") and hit.Parent.Name ~= plr.Name then
			if not hit.Parent.Humanoid:FindFirstChild(plr.Name) then
				if Hits[hit.Parent.Name] then
					return
				end
				local charh = hit.Parent
				local isBlocking = hit.Parent:FindFirstChild("isBlocking")
			
				local bt=	hit.Parent:WaitForChild("BlockTime")


				if hit.Parent:FindFirstChild("PBTime") then 
					if hit.Parent:FindFirstChild("Humanoid") and hit.Parent.Name ~= plr.Name then
						if not hit.Parent.Humanoid:FindFirstChild(plr.Name) then
							if hit.Parent.PBTime.Value == true then
								warn(plr.Name .. " has been perfect blocked!")

								Replicate:FireAllClients("Combat", "HitFX", hit.Parent.HumanoidRootPart, "Perfect Block") 
								misc.InsertDisabled(plr.Character, 1.75) 
								return	 end
						end

						if isBlocking.Value == true then
							local blockBar = hit.Parent:FindFirstChild("BlockBar")
							if blockBar and bt.Value == true then

								Replicate:FireAllClients("Combat", "HitFX", hit.Parent.HumanoidRootPart, "Block Hit")
								blockBar.Value -= Damage/5

								return end
						end
					end
				end
				CS:AddTag(hit.Parent, tag)
				hit.Parent.HumanoidRootPart.CFrame = CFrame.lookAt(hit.Parent.HumanoidRootPart.Position, flh.Position) * CFrame.Angles(0, math.pi, 0)
				misc.UpKnockback(hit.Parent.HumanoidRootPart, 25, 55, .1, hit.Parent.HumanoidRootPart)
				HitCounterRemotes:FireClient(plr)
				
				misc.Ragdoll(hit.Parent, 3)
				spawn(function(c)
					wait(2)
					CS:RemoveTag(hit.Parent, tag)
				end)
				local eHum = hit.Parent.Humanoid
				Sound2:Play()

				CS:AddTag(hit.Parent, AirImmunityTag)
				Replicate:FireAllClients("Combat", "HitFX", hit.Parent.HumanoidRootPart, "Basic Hit")
				task.delay(1.8, function()
					CS:RemoveTag(hit.Parent, AirImmunityTag)
				end)
				eHum:TakeDamage(15)
				Hits[hit.Parent.Name] = true
				wait(4)
				
				Hits[hit.Parent.Name] = nil



			end
				end
			
	end)
	wait(3)
	flh:Destroy()
			
	wait(5)
	

end)

