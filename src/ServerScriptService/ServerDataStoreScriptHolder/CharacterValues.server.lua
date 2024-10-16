-- SERVICES --
local RS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")

-- FOLDERS --
local Remotes = RS:WaitForChild("Remotes")
local Modules = RS:WaitForChild("Modules")

-- MAIN --
local PlayerDataManager = require(SSS.PlayerDataManager)

game.Players.PlayerAdded:Connect(function(Player)

	if not Player:FindFirstChild("canRegenStamina") then
		local canRegenStamina = Instance.new("BoolValue")
		canRegenStamina.Name = "canRegenStamina"
		canRegenStamina.Value = true
		canRegenStamina.Parent = Player
	end
	
	if not Player:FindFirstChild("isBlocking") then
		local value = Instance.new("BoolValue")
		value.Name = "isBlocking"
		value.Parent = Player
	end
	
	if not Player:FindFirstChild("canRun") then
		local value = Instance.new("BoolValue")
		value.Name = "canRun"
		value.Value = true
		value.Parent = Player
	end
	
	if not Player:FindFirstChild("canDash") then
		local value = Instance.new("BoolValue")
		value.Name = "canDash"
		value.Value = true
		value.Parent = Player
	end

	local crs = Player:WaitForChild("canRegenStamina")
	local sta = Player:WaitForChild("Stamina")
	local pStats = Player:WaitForChild("Stats")
	local pMaxStamina = pStats:WaitForChild("MaxStamina")

	if not Player.Character then
		Player.CharacterAdded:Connect(function(Character)
			local cd = 1

			local function regenStamina()
				if crs.Value then
					sta.Value = sta.Value + (pMaxStamina.Value * 0.02)
				end
			end

			coroutine.wrap(function()
				while task.wait(cd) do
					if sta.Value < pMaxStamina.Value then
						regenStamina()
					elseif sta.Value >= pMaxStamina.Value then
						sta.Value = pMaxStamina.Value
					end
				end
			end)()

		end)
	else
		local cd = 1

		local function regenStamina()
			if crs.Value then
				sta.Value = sta.Value + (pMaxStamina.Value * 0.02)
			end
		end

		coroutine.wrap(function()
			while task.wait(cd) do
				if sta.Value < pMaxStamina.Value then
					regenStamina()
				elseif sta.Value >= pMaxStamina.Value then
					sta.Value = pMaxStamina.Value
				end
			end
		end)()

	end
end)
