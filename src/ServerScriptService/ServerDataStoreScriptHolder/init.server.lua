local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Remotes = RS:WaitForChild("Remotes")

local statsEvent = Remotes.statsEvent
local replicate = Remotes.Replicate
local uiReplicator = Remotes.UIReplicator

local questModule = require(script:WaitForChild("Quests"))

local PlayerDataManager = require(game:GetService("ServerScriptService").PlayerDataManager)

Players.PlayerAdded:Connect(function(Player)
	local pStats = Instance.new("Folder")
	pStats.Name = "Stats"
	pStats.Parent = Player

	local pStatus = Instance.new("Folder")
	pStatus.Name = "Status"
	pStatus.Parent = Player

	local pQuests = Instance.new("Folder")
	pQuests.Name = "Quests"
	pQuests.Parent = Player
	
	local goldValue = Instance.new("IntValue")
	goldValue.Name = "Gold"
	goldValue.Parent = pStats

	local levelValue = Instance.new("IntValue")
	levelValue.Name = "Level"
	levelValue.Parent = pStats

	local expVal = Instance.new("IntValue")
	expVal.Name = "EXP"
	expVal.Parent = pStats

	local maxExpVal = Instance.new("IntValue")
	maxExpVal.Name = "MaxEXP"
	maxExpVal.Parent = pStats

	local maxStaminaVal = Instance.new("IntValue")
	maxStaminaVal.Name = "MaxStamina"
	maxStaminaVal.Parent = pStats

	local staminaVal = Instance.new("IntValue")
	staminaVal.Name = "Stamina"
	staminaVal.Parent = Player

	local staminaStatVal = Instance.new("IntValue")
	staminaStatVal.Name = "Stamina"
	staminaStatVal.Parent = pStatus

	local strengthVal = Instance.new("IntValue")
	strengthVal.Name = "Strength"
	strengthVal.Parent = pStatus

	local defenseVal = Instance.new("IntValue")
	defenseVal.Name = "Defense"
	defenseVal.Parent = pStatus



	local statPointsVal = Instance.new("IntValue")
	statPointsVal.Name = "StatPoints"
	statPointsVal.Parent = pStats

	local currentQuest = Instance.new("StringValue")
	currentQuest.Name = "CurrentQuest"
	currentQuest.Parent = pQuests

	local questProgress = Instance.new("IntValue")
	questProgress.Name = "QuestProgress"
	questProgress.Parent = pQuests

	--Listening for changes
	PlayerDataManager:GetPlayerDataReplica(Player):andThen(function(Replica)
		Replica:ListenToChange("Gold", function(NewValue, OldValue)
			goldValue.Value = NewValue
		end)

		Replica:ListenToChange("Level", function(NewValue, OldValue)
			levelValue.Value = NewValue
		end)

		Replica:ListenToChange("CurrentQuest", function(NewValue, OldValue)
			currentQuest.Value = NewValue
			local quest = questModule.Quests[NewValue]
			if quest and NewValue ~= OldValue then
				Replica:SetValue("QuestProgress", 0)
				uiReplicator:FireClient(Player, "Quest", Replica.Data.QuestProgress, Replica.Data.CurrentQuest, quest.Target, quest.Rewards, quest.Amount)
			end
		end)

		Replica:ListenToChange("QuestProgress", function(NewValue, OldValue)
			questProgress.Value = NewValue
			local quest = questModule.Quests[Replica.Data.CurrentQuest]
			if quest then
				if NewValue >= quest.Amount then
					Replica:SetValue("QuestProgress", 0)
					Replica:SetValue("Gold", Replica.Data.Gold + quest.Gold)
					Replica:SetValue("EXP", Replica.Data.EXP + quest.EXP)
					Replica:SetValue("CurrentQuest", "None") 
					uiReplicator:FireClient(Player, "Quest", Replica.Data.QuestProgress, Replica.Data.CurrentQuest, quest.Target, quest.Rewards, quest.Amount)

				elseif NewValue < quest.Amount then
					uiReplicator:FireClient(Player, "Quest", Replica.Data.QuestProgress, Replica.Data.CurrentQuest, quest.Target, quest.Rewards, quest.Amount)
				end
			end
		end)
		
		if not Player.Character then
			Player.CharacterAdded:Connect(function()
				local quest = questModule.Quests[Replica.Data.CurrentQuest]
				if quest then
					uiReplicator:FireClient(Player, "Quest", Replica.Data.QuestProgress, Replica.Data.CurrentQuest, quest.Target, quest.Rewards, quest.Amount)
				end
				
				uiReplicator:FireClient(Player, "EXP", Replica.Data.EXP, Replica.Data.MaxEXP, Replica.Data.Level)
			end)
		else
			local quest = questModule.Quests[Replica.Data.CurrentQuest]
			if quest then
				uiReplicator:FireClient(Player, "Quest", Replica.Data.QuestProgress, Replica.Data.CurrentQuest, quest.Target, quest.Rewards, quest.Amount)
			end
			
			uiReplicator:FireClient(Player, "EXP", Replica.Data.EXP, Replica.Data.MaxEXP, Replica.Data.Level)
		end
		
		
		Replica:ListenToChange("EXP", function(NewValue, OldValue)
			expVal.Value = NewValue

			if NewValue == Replica.Data.MaxEXP then
				Replica:SetValue("EXP", 0)
				Replica:SetValue("MaxEXP", Replica.Data.MaxEXP + (Replica.Data.MaxEXP * 0.1))
				Replica:SetValue("Level", Replica.Data.Level + 1)
				Replica:SetValue("StatPoints", Replica.Data.StatPoints + 3)
				
				uiReplicator:FireClient(Player, "EXP", Replica.Data.EXP, Replica.Data.MaxEXP, Replica.Data.Level)
				
				maxExpVal.Value = Replica.Data.MaxEXP
				expVal.Value = Replica.Data.EXP
				levelValue.Value = Replica.Data.Level
				statPointsVal.Value = Replica.Data.StatPoints
				replicate:FireAllClients("LevelUp", Player.Character)
			elseif NewValue > Replica.Data.MaxEXP then
				Replica:SetValue("EXP", Replica.Data.EXP - Replica.Data.MaxEXP)
				Replica:SetValue("MaxEXP", Replica.Data.MaxEXP + (Replica.Data.MaxEXP * 0.1))
				Replica:SetValue("Level", Replica.Data.Level + 1)
				Replica:SetValue("StatPoints", Replica.Data.StatPoints + 3)
				
				uiReplicator:FireClient(Player, "EXP", Replica.Data.EXP, Replica.Data.MaxEXP, Replica.Data.Level)
				
				maxExpVal.Value = Replica.Data.MaxEXP
				expVal.Value = Replica.Data.EXP
				levelValue.Value = Replica.Data.Level
				statPointsVal.Value = Replica.Data.StatPoints
				replicate:FireAllClients("LevelUp", Player.Character)
			end
		end)

		Replica:ListenToChange("MaxStamina", function(NewValue, OldValue)
			maxStaminaVal.Value = NewValue
		end)

		Replica:ListenToChange("MaxEXP", function(NewValue, OldValue)
			maxExpVal.Value = NewValue
		end)

		Replica:ListenToChange("Strength", function(NewValue, OldValue)
			print(Player.Name .. "'s Strength has been changed on the server: " .. tostring(NewValue))
			strengthVal.Value = NewValue
		end)

		Replica:ListenToChange("Defense", function(NewValue, OldValue)
			print(Player.Name .. "'s Defense has been changed on the server: " .. tostring(NewValue))
			defenseVal.Value = NewValue
		end)

		Replica:ListenToChange("Stamina", function(NewValue, OldValue)
			print(Player.Name .. "'s Stamina has been changed on the server: " .. tostring(NewValue))
			staminaStatVal.Value = NewValue
		end)

	

		Replica:ListenToChange("StatPoints", function(NewValue, OldValue)
			print(Player.Name .. "'s Stat Points has been changed on the server: " .. tostring(NewValue))
			statPointsVal.Value = NewValue
		end)
	end)

	task.delay(.15, function()
		PlayerDataManager:GetPlayerProfile(Player):andThen(function(Profile)
			warn(Profile.Data)
			expVal.Value = Profile.Data.EXP
			levelValue.Value = Profile.Data.Level
			maxStaminaVal.Value = Profile.Data.MaxStamina
			maxExpVal.Value = Profile.Data.MaxEXP
			goldValue.Value = Profile.Data.Gold
			staminaVal.Value = Profile.Data.MaxStamina
			strengthVal.Value = Profile.Data.Strength
			staminaStatVal.Value = Profile.Data.Stamina
			defenseVal.Value = Profile.Data.Defense
			
			statPointsVal.Value = Profile.Data.StatPoints
			currentQuest.Value = Profile.Data.CurrentQuest
			questProgress.Value = Profile.Data.QuestProgress
		end)
	end)

end)