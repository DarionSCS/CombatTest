
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CS = game:GetService("CollectionService")


local Remotes = RS.Remotes
local Modules = RS.Modules

local Hitboxes = RS.Hitboxes


local zonePlus = require(Modules.Zone)
local Misc = require(Modules.Misc)


local attackRemote = script.Parent:WaitForChild("Attack")
local Replicate = Remotes.Replicate
local Remotes2 = RS:WaitForChild("Events"):WaitForChild("Remotes")
local HitCounterRemotes = Remotes2:WaitForChild("HitCounter")

local M1Debounce = false
local Equipped = script.Parent:WaitForChild("Equipped")
local Air = false
local Combo = 1
local doingCombo = 0

local hit = {}
local canHit = true
local currHitbox
local M1ImmunityTag = "Immunity"
local AirImmunityTag = "AirDown"

-- FUNCTIONS --
attackRemote.OnServerEvent:Connect(function(Player, Action, isHoldingSpace)

	local Character = Player.Character
	local Humanoid = Character.Humanoid
	
	local HRP = Character.HumanoidRootPart
	
	local pStrength = 2
	local isBlocking = Player:WaitForChild("isBlocking")
	local b2 = Player.Character:WaitForChild("BlockTime")
	local PBT = Player.Character:WaitForChild("PBTime")

	local M1Damage = 7.1 * (1 + (pStrength * 0.015))
	local M1StunDuration = 1

	local Disabled = Character:FindFirstChild("Disabled")
	
	if Action == "Attack" and Humanoid.Health > 0 and Equipped.Value == true then
		if not M1Debounce and not isBlocking.Value and not Disabled then
			M1Debounce = true

			 local Animations = {
				[1] = Humanoid:LoadAnimation(script.Parent.Animations.P1),
				[2] = Humanoid:LoadAnimation(script.Parent.Animations.P2),
				[3] = Humanoid:LoadAnimation(script.Parent.Animations.P3),
				[4] = Humanoid:LoadAnimation(script.Parent.Animations.P4),
				[5] = Humanoid:LoadAnimation(script.Parent.Animations.P5),
				["AirUp"] = Humanoid:LoadAnimation(script.Parent.Animations.UpTilt),
				["AirDown"] = Humanoid:LoadAnimation(script.Parent.Animations.Slam),
			}



			local function createHitbox()
				coroutine.wrap(function()
					local Direction = 0
					local Length = 0.2
					local DashSpeed = 10

					local BV = Instance.new("BodyVelocity")
					BV.MaxForce, BV.Velocity = Vector3.new(5e4, 5e2, 5e4), (Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(Direction), 0)).lookVector * DashSpeed
					BV.Parent = HRP
					game.Debris:AddItem(BV, Length)
				end)()

				local hitboxTemp = Hitboxes.Combat.M1:Clone()
				hitboxTemp.CFrame = HRP.CFrame
				hitboxTemp.Parent = HRP

				local weld = Instance.new("Weld")
				weld.Part0 = HRP
				weld.Part1 = hitboxTemp
				weld.C1 = require(hitboxTemp.weldCF)
				weld.Parent = hitboxTemp

				local hitboxZone = zonePlus.new(hitboxTemp)
				hitboxZone:setAccuracy("Precise")

				for i, v in pairs(hitboxZone:getParts()) do
					if v.Parent ~= Character then
						if v.Parent:FindFirstChild("Humanoid") and not hit[v.Parent.Name] then
							if not v.Parent:FindFirstChild("Immune") and not Character:FindFirstChild("Disabled") and not Character:FindFirstChild("Immune") and not CS:HasTag(v.Parent, M1ImmunityTag) and not CS:HasTag(v.Parent, AirImmunityTag) then
								if canHit then
									canHit = false
									CS:AddTag(v.Parent, M1ImmunityTag)
									table.insert(hit, v.Parent.Name)
									local isPlayer = Players:FindFirstChild(v.Parent.Name)
									local isBlocking
									spawn(function()
										if v.Parent:FindFirstChild("IsAttacking") then 
											v.Parent.IsAttacking.Value = true
											wait(1)
											v.Parent.IsAttacking.Value = false
										end
											
									end)
										
									if isPlayer then
										isBlocking = isPlayer.isBlocking
									else
										isBlocking = v.Parent.isBlocking
										v.Parent.Target.Value = Player.Name
										v.Parent.Idle.Value = false
									end
									if v.Parent:FindFirstChild("PBTime").Value == true then
										warn(Player.Name .. " has been perfect blocked!")
										Replicate:FireAllClients("Combat", "HitFX", v.Parent.HumanoidRootPart, "Perfect Block")
										Misc.InsertDisabled(Character, 1.75)
										local a = Character.Humanoid:LoadAnimation(script.PlayerDeflected)
										a:Play()
										script.ScreenFlash:FireClient(Player)
										game.Debris:AddItem(a,1.1)
										Replicate:FireClient(Player, "CamShake", HRP.Position, 3, 300)
										spawn(function()
											Character.HumanoidRootPart.Anchored = true
											local pbstun = Instance.new("BoolValue")
											pbstun.Name = "PBSTUN"
											Character.Humanoid.WalkSpeed = 0
											pbstun.Parent = Character
											wait(1)
											pbstun:Destroy()
											Character.Humanoid.WalkSpeed = 15
											Character.HumanoidRootPart.Anchored = false
										end)
									 end
									if not CS:HasTag(v.Parent, "Perfect Block") then
										if isBlocking.Value and HRP.CFrame.lookVector:Dot(v.Parent.HumanoidRootPart.CFrame.lookVector) < 0.7 then
											--print(HRP.CFrame.lookVector:Dot(v.Parent.HumanoidRootPart.CFrame.lookVector))
											--print("Blocking")
											local blockBar = v.Parent:FindFirstChild("BlockBar")
											if blockBar then
												Replicate:FireAllClients("Combat", "HitFX", v.Parent.HumanoidRootPart, "Block Hit")
												blockBar.Value -= M1Damage
												
												coroutine.wrap(function()
													local BV = Instance.new("BodyVelocity")
													BV.MaxForce, BV.Velocity = Vector3.new(5e4, 5e2, 5e4), Character.HumanoidRootPart.CFrame.lookVector * 10
													BV.Parent = v.Parent.HumanoidRootPart
													game.Debris:AddItem(BV, 0.16)
												end)()
											end
											
										else
											
											local eHum = v.Parent.Humanoid

										
										if v.Parent:FindFirstChild("iFrames").Value == false then
												eHum:TakeDamage(M1Damage)
												HitCounterRemotes:FireClient(Player)

												Replicate:FireAllClients("Combat", "HitFX", v.Parent.HumanoidRootPart, "Basic Hit")
												Replicate:FireClient(Player, "CamShake", HRP.Position, 3, 100)
										
					
											end
											if isPlayer then
												Replicate:FireClient(isPlayer, "CamShake", v.Parent.HumanoidRootPart.Position, 3, 100)
											else
												local killers = v.Parent:FindFirstChild("Killers")
												if killers then
													local pVal = killers:FindFirstChild(Player.Name)
													if pVal then
														pVal.Value += M1Damage
													else
														pVal = Instance.new("NumberValue")
														pVal.Name =  Player.Name
														pVal.Value = M1Damage
														pVal.Parent = killers
													end
												else
													killers = Instance.new("Folder")
													killers.Name = "Killers"
													killers.Parent = v.Parent
													
													local pVal = Instance.new("NumberValue")
													pVal.Name =  Player.Name
													pVal.Value = M1Damage
													pVal.Parent = killers
												end
											end

											if doingCombo < 4 then
												coroutine.wrap(function()
													local BV = Instance.new("BodyVelocity")
													BV.MaxForce, BV.Velocity = Vector3.new(5e4, 5e2, 5e4), Character.HumanoidRootPart.CFrame.lookVector * 10
													BV.Parent = eHum.Parent.HumanoidRootPart
													game.Debris:AddItem(BV, 0.1)
												end)()

												Misc.InsertDisabled(v.Parent, M1StunDuration)
												
											elseif doingCombo == 4 then
												if not isHoldingSpace then
													coroutine.wrap(function()
														local BV = Instance.new("BodyVelocity")
														BV.MaxForce, BV.Velocity = Vector3.new(5e4, 5e2, 5e4), Character.HumanoidRootPart.CFrame.lookVector * 10
														BV.Parent = eHum.Parent.HumanoidRootPart
														game.Debris:AddItem(BV, 0.1)
													end)()

													Misc.InsertDisabled(v.Parent, M1StunDuration)
													
												else
													local AirPos = (HRP.CFrame * CFrame.new(0, 14, 0)).Position
													local enemyAirPos = (HRP.CFrame * CFrame.new(0, 14, -4)).Position

													local BP = Instance.new("BodyPosition")
													BP.Name = "AirUp"
													BP.MaxForce = Vector3.new(4e4,4e4,4e4)
													BP.Position = AirPos
													BP.P = 4e4
													BP.Parent = HRP
													game.Debris:AddItem(BP, 1)

													local EnemyBP = Instance.new("BodyPosition")
													EnemyBP.Name = "AirUp"
													EnemyBP.MaxForce = Vector3.new(4e4,4e4,4e4)
													EnemyBP.Position = enemyAirPos
													EnemyBP.P = 4e4
													EnemyBP.Parent = v.Parent.HumanoidRootPart
													game.Debris:AddItem(EnemyBP, 1)

													Misc.InsertDisabled(v.Parent, M1StunDuration)

													Air = true
													task.delay(1.8, function()
														Air = false
													end)
												end
											elseif doingCombo == 5 then
												if not Air then
													Misc.Ragdoll(v.Parent, M1StunDuration + 0.5)
													coroutine.wrap(function()
														local BV = Instance.new("BodyVelocity")
														BV.MaxForce, BV.Velocity = Vector3.new(5e4, 5e2, 5e4), Character.HumanoidRootPart.CFrame.lookVector * 65
														BV.Parent = eHum.Parent.HumanoidRootPart
														game.Debris:AddItem(BV, 0.15)
													end)()

													CS:AddTag(v.Parent, AirImmunityTag)

													task.delay(2.3, function()
														CS:RemoveTag(v.Parent, AirImmunityTag)
													end)
												else
													Misc.Ragdoll(v.Parent, M1StunDuration + 0.5)
													coroutine.wrap(function()
														local BV = Instance.new("BodyVelocity")
														BV.MaxForce, BV.Velocity = Vector3.new(5e4, 5e2, 5e4), Character.HumanoidRootPart.CFrame.lookVector * 65
														BV.Parent = eHum.Parent.HumanoidRootPart
														game.Debris:AddItem(BV, 0.15)
													end)()

													CS:AddTag(v.Parent, AirImmunityTag)

													task.delay(2.3, function()
														CS:RemoveTag(v.Parent, AirImmunityTag)
													end)
													

												end
											end
										end
									else
										warn(Player.Name .. " has been perfect blocked!")
										Replicate:FireAllClients("Combat", "HitFX", v.Parent.HumanoidRootPart, "Perfect Block")
										Misc.InsertDisabled(Character, 1.75)
										local a = Character.Humanoid:LoadAnimation(script.PlayerDeflected)
										a:Play()
										game.Debris:AddItem(a,1.1)
										script.ScreenFlash:FireClient(Player)
										Replicate:FireClient(Player, "CamShake", HRP.Position, 3, 300)
										spawn(function()
											Character.HumanoidRootPart.Anchored = true
											local pbstun = Instance.new("BoolValue")
											pbstun.Name = "PBSTUN"
											Character.Humanoid.WalkSpeed = 0
											pbstun.Parent = Character
											wait(1)
											pbstun:Destroy()
											Character.Humanoid.WalkSpeed = 15
											Character.HumanoidRootPart.Anchored = false
										end)
									end
									
									
									task.delay(0.2, function()
										canHit = true
										CS:RemoveTag(v.Parent, M1ImmunityTag)
									end)
								end

							end
						end
					end
				end

				game.Debris:AddItem(hitboxTemp, .3)

			end

			if Combo == 1 then
				Combo = 2
				doingCombo = 1
				Animations[doingCombo]:Play(.05, 0.8, 1.4)
				
				local sfx = RS.Sounds3.Swing:Clone()
				sfx.Parent = Character
				sfx:Play()
	
				game.Debris:AddItem(sfx,3)
				Animations[doingCombo]:GetMarkerReachedSignal("Hit"):Connect(function()
				
						createHitbox()
				
				end)

				Animations[doingCombo]:GetMarkerReachedSignal("DBReset"):Connect(function()
					M1Debounce = false
				end)

				task.delay(1.5, function()
					if Combo == 2 then
						Combo = 1
						doingCombo = 0
					end
				end)
			elseif Combo == 2 then
				Combo = 3
				local sfx2 = RS.Sounds3.Swing:Clone()
				sfx2.Parent = Character
				sfx2:Play()
				game.Debris:AddItem(sfx2,3)
				doingCombo = 2
				Animations[doingCombo]:Play(.05, 0.8, 1.4)

				Animations[doingCombo]:GetMarkerReachedSignal("Hit"):Connect(function()
				
						createHitbox()
			
				end)

				Animations[doingCombo]:GetMarkerReachedSignal("DBReset"):Connect(function()
					M1Debounce = false
				end)

				task.delay(1.5, function()
					if Combo == 3 then
						Combo = 1
						doingCombo = 0
					end
				end)
			elseif Combo == 3 then
				local sfx3 = RS.Sounds3.Swing:Clone()
				sfx3.Parent = Character
				sfx3:Play()
				game.Debris:AddItem(sfx3,3)
				Combo = 4
				doingCombo = 3
				Animations[doingCombo]:Play(.05, 0.8, 1.4)

				Animations[doingCombo]:GetMarkerReachedSignal("Hit"):Connect(function()
					
						createHitbox()
				
				end)

				Animations[doingCombo]:GetMarkerReachedSignal("DBReset"):Connect(function()
					M1Debounce = false
				end)

				task.delay(1.5, function()
					if Combo == 4 then
						Combo = 1
						doingCombo = 0
					end
				end)
			elseif Combo == 4 then
				Combo = 5
				doingCombo = 4
				local sfx4 = RS.Sounds3.Swing:Clone()
				sfx4.Parent = Character
				sfx4:Play()
				game.Debris:AddItem(sfx4,3)
				if not isHoldingSpace then
					Animations[doingCombo]:Play(.05, 0.8, 1.4)

					Animations[doingCombo]:GetMarkerReachedSignal("Hit"):Connect(function()
						
							createHitbox()
					
					end)

					Animations[doingCombo]:GetMarkerReachedSignal("DBReset"):Connect(function()
						M1Debounce = false
					end)
				else
					Animations["AirUp"]:Play(.05, 0.8, 1)

					Animations["AirUp"]:GetMarkerReachedSignal("Hit"):Connect(function()
						
							createHitbox()
		
					end)

					Animations["AirUp"]:GetMarkerReachedSignal("DBReset"):Connect(function()
						task.delay(0.25, function()
							M1Debounce = false
						end)
					end)
				end


				task.delay(1.5, function()
					if Combo == 5 then
						Combo = 1
						doingCombo = 0
					end
				end)
			elseif Combo == 5 then
				Combo = 1
				doingCombo = 5
				local sfx5 = RS.Sounds3.Swing:Clone()
				sfx5.Parent = Character
				sfx5:Play()
				game.Debris:AddItem(sfx5,3)
				if not Air then
					Animations[doingCombo]:Play(.05, 0.8, 1.4)

					Animations[doingCombo]:GetMarkerReachedSignal("Hit"):Connect(function()
						
							createHitbox()
					
					end)

					Animations[doingCombo]:GetMarkerReachedSignal("End"):Connect(function()
						task.delay(1.5, function()
							Combo = 1
							doingCombo = 0
							M1Debounce = false
						end)
					end)
				else

					Animations["AirDown"]:Play(.05, 0.8, 1.4)

					Animations["AirDown"]:GetMarkerReachedSignal("Hit"):Connect(function()
						
							createHitbox()
				
					end)

					Animations["AirDown"]:GetMarkerReachedSignal("End"):Connect(function()
						task.delay(1.5, function()
							Combo = 1
							doingCombo = 0
							M1Debounce = false
						end)
					end)
				end

			end
		end
	
	elseif Action == "Equip" and Humanoid.Health > 0 then
		Equipped.Value = true
	elseif Action == "Unequip" then
		Equipped.Value = false
	elseif Action == "Block" and Humanoid.Health > 0 then
		if not M1Debounce and not Disabled and Equipped.Value == true then
		b2.Value = true
			isBlocking.Value = true
		
			spawn(function()
				PBT.Value = true
				wait(0.1)
				PBT.Value = false
			end)
		end
	elseif Action == "Unblock" then
		isBlocking.Value = false
		b2.Value = false
		
	end
	
end)
