-- Main Menu Submenus
function GetMainMenuEntries() 
	return {
		NewActionEntry("Camera Menu", true, OpenMenu, {"Camera Menu", GetCameraMenuEntries}),
		NewActionEntry("Cheat Menu", true, OpenMenu, {"Cheat Menu", GetCheatMenuEntries}),
		NewActionEntry("NPC Spawn Menu", true, OpenMenu, {"Spawn Menu", GetNPCMenuEntries}),
		NewActionEntry("Time Menu", true, OpenMenu, {"Time Menu", GetTimingMenuEntries}),
		NewActionEntry("Opinion Menu (Half-Working)", Debug.GetHeroTarget() ~= nil, OpenMenu, {"Opinion Menu", GetOpinionMenuEntries}),
		NewActionEntry("Buildings Menu", true, OpenMenu, {"Buildings Menu", GetBuildingsMenuEntries}),
		NewActionEntry("Level Select Menu", true, OpenMenu, {"Level Select", GetLevelMenuEntries}),
		NewActionEntry("Main Quest Menu", true, OpenMenu, {"Main Quest Select", GetMainQuestSkipMenuEntries}),
		NewActionEntry("Miscellaneous Menu", true, OpenMenu, {"Miscellaneous", GetMiscMenuEntries}),
		NewActionEntry("Menu Config", true, OpenMenu, {"Menu Config", GetMenuConfigEntries}),
		NewActionEntry("(DEBUG) Reload Menu", true, ReloadMenu, nil)
	}
end
function GetCheatMenuEntries()
	return {
		NewActionEntry("Item Menu", true, OpenMenu, {"Item Menu", GetInventoryMenuEntries}),
		NewActionEntry("Stats Menu", true, OpenMenu, {"Stats Menu", GetStatsMenuEntries}),
		NewActionEntry("Toggle Godmode" .. FormatBool(Health.IsInvulnerable(QuestManager.HeroEntity)), true, Health.SetAsInvulnerable, {QuestManager.HeroEntity, not Health.IsInvulnerable(QuestManager.HeroEntity)}),
		NewActionEntry("Become Unhittable", true, Hittable.SetEntityAsOnlyHittableByEntity, {QuestManager.HeroEntity, QuestManager.HeroEntity, true}),
		NewActionEntry("Become Hittable Again", true, Hittable.SetEntityAsOnlyHittableByEntity, {QuestManager.HeroEntity, QuestManager.HeroEntity, false}),
		NewActionEntry("Set Damage Multiplier", true, Functions.SetDamageMultiplier, nil),
		NewActionEntry("Set Action Speed Multiplier", true, Functions.SetActionSpeed, nil),
		NewActionEntry("Set Gold", true, Functions.ModifyGold, nil),
		NewActionEntry("Set General Experience", true, Functions.ModifyExperience, nil),
		NewActionEntry("Override Ammo in Held Gun", Functions.IsCarryingGun(), Functions.OverrideAmmo, nil)

	}
end
function GetCameraMenuEntries()
	return {
		NewActionEntry("Render Menu", true, OpenMenu, {"Render Menu", GetRenderMenuEntries}),
		NewActionEntry("Toggle Free Cam", true, Debug.ToggleFreeCam, nil),
		NewActionEntry("Hide GUI", true, Functions.HideGUI, self),
		NewActionEntry("Set FOV", true, Functions.SetFOV, nil)
	}
end
function GetRenderMenuEntries()
	return {
		NewActionEntry("Debug Draw Menu", true, OpenMenu, {"Debug Draw Menu", GetDebugDrawMenuEntries}),
		NewActionEntry("Static Entity Render Dist", true, Functions.SetStaticRendDist, nil),
		NewActionEntry("Animated Entity Render Dist", true, Functions.SetAnimatedRendDist, nil),
		NewActionEntry("Villager Render Dist", true, Functions.SetVillagerRendDist, nil),
		NewActionEntry("Creature Render Dist", true, Functions.SetCreatureRendDist, nil),
		NewActionEntry("Make Dog Invisible (Temporary)", true, Functions.FadeDog, nil)
	}
end
function GetTimingMenuEntries()
	return {
		NewActionEntry("Set Time Of Day", true, Functions.SetTimeOfDay, nil),
		NewActionEntry("Toggle Time Stopped" .. FormatBool(#TimeStopIDs > 0), true, Functions.ToggleTime, nil),
		NewActionEntry("Day Speed", true, Functions.DaySpeed, nil),
		NewActionEntry("Time Control", true, Functions.TimeControl, nil)
	}
end
function GetMainQuestSkipMenuEntries()
	return {
		NewActionEntry("Teleport To Crummi's Next Target", true, Debug.TeleportToBreadcrumbTargetPosition, nil),
		NewActionEntry("Childhood Quests", true, OpenMenu, {"Childhood Quests", GetChildhoodQuestMenuEntries}),
		NewActionEntry("Pre-Spire Quests", true, OpenMenu, {"Pre-Spire Quests", GetPreSpireQuestMenuEntries}),
		NewActionEntry("Post-Spire Quests", true, OpenMenu, {"Post-Spire Quests", GetPostSpireQuestMenuEntries})
	}
end
function GetLevelMenuEntries()
	return {
		NewActionEntry("Overworld Levels", true, OpenMenu, {"Overworld Levels", GetOverworldLevelMenuEntries}),
		NewActionEntry("DLC Levels", true, OpenMenu, {"DLC Levels", GetDLCLevelMenuEntries}),
		NewActionEntry("Cave & Tomb Levels", true, OpenMenu, {"Cave Levels", GetCaveLevelMenuEntries}),
		NewActionEntry("DemonDoor Levels", true, OpenMenu, {"DemonDoor Levels", GetDemonDoorLevelMenuEntries})
	}
end
function GetNPCMenuEntries()
	return {
		NewActionEntry("Destroy All Of Target Type", true, Functions.DestroyAllOfTarget, nil),
		NewActionEntry("Spawn Invincible Frozen Bandit", true, Functions.DumbBandit, nil),
		NewActionEntry("Friendly Creatures", true, OpenMenu, {"Friendly NPCs", GetFriendlyNPCMenuEntries}),
		NewActionEntry("Beetle Creatures", true, OpenMenu, {"Beetle NPCs", GetBeetleNPCMenuEntries}),
		NewActionEntry("Bandit Creatures", true, OpenMenu, {"Bandit NPCs", GetBanditNPCMenuEntries}),
		NewActionEntry("Hobbe Creatures", true, OpenMenu, {"Hobbe NPCs", GetHobbesNPCMenuEntries}),
		NewActionEntry("Banshee, Hollowmen Creatures", true, OpenMenu, {"Banshee, Hollowmen NPCs", GetBansheeNPCMenuEntries}),
		NewActionEntry("Balverine Creatures", true, OpenMenu, {"Balverine NPCs", GetBalverineNPCMenuEntries}),
		NewActionEntry("Ghost, Shadow, Colour Creatures", true, OpenMenu, {"Ghost NPCs", GetColourNPCMenuEntries}),
		NewActionEntry("Necromancer Creatures", true, OpenMenu, {"Necromancer NPCs", GetNecromancerNPCMenuEntries}),
		NewActionEntry("Lucien Creatures", true, OpenMenu, {"Lucien Guard NPCs", GetLucienGuardNPCMenuEntries}),
		NewActionEntry("Shard Creatures", true, OpenMenu, {"Shard NPCs", GetShardNPCMenuEntries}),
		NewActionEntry("Troll Creatures", true, OpenMenu, {"Troll NPCs", GetTrollNPCMenuEntries}),
		NewActionEntry("Guard Creatures", true, OpenMenu, {"Guard NPCs", GetGuardNPCMenuEntries})
	}
end
function GetOpinionMenuEntries()
	return {
		NewActionEntry("Reset Target's Opinion", true, Functions.ChangeTargetOpinion, {"all", 0}),
		NewActionEntry("Make Target Love You", true, Functions.ChangeTargetOpinion, {"love", -1}),
		NewActionEntry("Make Target Hate You", true, Functions.ChangeTargetOpinion, {"love", 1}),
		NewActionEntry("Make Target Think You're Funny", true, Functions.ChangeTargetOpinion, {"fear", -1}),
		NewActionEntry("Make Target Fear You", true, Functions.ChangeTargetOpinion, {"fear", 1}),
		NewActionEntry("Make Target Attracted to You", true, Functions.ChangeTargetOpinion, {"attractiveness", 1}),
		NewActionEntry("Make Target Repulsed by You", true, Functions.ChangeTargetOpinion, {"attractiveness", -1}),
		NewActionEntry("Make Target Friendly", true, Faction.AddTemporaryEntityRelationship, {QuestManager.HeroEntity, Debug.GetHeroTarget(), EFactionStatus.FACTION_STATUS_ALLY}),
		NewActionEntry("Make Target Neutral", true, Faction.AddTemporaryEntityRelationship, {QuestManager.HeroEntity, Debug.GetHeroTarget(), EFactionStatus.FACTION_STATUS_NEUTRAL}),
		NewActionEntry("Make Target Enemy", true, Faction.AddTemporaryEntityRelationship, {QuestManager.HeroEntity, Debug.GetHeroTarget(), EFactionStatus.FACTION_STATUS_ENEMY}),
		NewActionEntry("Marry Target", true, PlayerFamily.Marry, {QuestManager.HeroEntity, Debug.GetHeroTarget() or QuestManager.HeroEntity})
	}
end
function GetMenuConfigEntries()
	return {
		NewActionEntry("Slow Menu" .. FormatBool(SlowMenu) .. " - Partially fix highlight bug", true, Functions.ToggleSlowMenu, nil)
	}
end
function GetStatsMenuEntries()
	return {
		NewActionEntry("Set Morality", true, Functions.ModifyMorality, nil),
		NewActionEntry("Set Purity", true, Functions.ModifyPurity, nil),
		NewActionEntry("Set Renown", true, Functions.ModifyRenown, nil)
	}
end

--[[																		DEBUG DRAW FUNCTIONS																								]]--
function GetDebugDrawMenuEntries()
	return {
		NewActionEntry("Nav Debug Draw Menu", true, OpenMenu, {"Nav Debug Draw Menu", GetNavMeshDebugMenuEntries}),
		NewActionEntry("Toggle Combat Debug Draw" .. FormatBool(CombatRegister.DrawDebug), true, Debug.SetDrawCombatDebug, {not CombatRegister.DrawDebug}),

		NewActionEntry("Toggle Breadcrumb Debug" .. FormatBool(AccessTrackedBool("BreadcrumbDebug")), true, 
						Functions.ToggleFunctionWithTrackedBool, {Debug.SetDrawBreadcrumbDebug, "BreadcrumbDebug"}),

		NewActionEntry("Toggle Hero Locomotion Debug" .. FormatBool(AccessTrackedBool("HeroLocomotionDebug")), true,
						Functions.ToggleFunctionWithTrackedBool, {Debug.SetDrawHeroLocomotionDebug, "HeroLocomotionDebug"})
	}
end
function GetNavMeshDebugMenuEntries()
	return {
		NewActionEntry("Toggle NavMesh Debug" .. FormatBool(AccessTrackedBool("NavMesh")), true,
					 Functions.ToggleFunctionWithTrackedBool, {Debug.SetDrawNavMesh, "NavMesh"}),

		NewActionEntry("Toggle NavGraph Debug" .. FormatBool(AccessTrackedBool("NavGraph")), true,
					 Functions.ToggleFunctionWithTrackedBool, {Debug.SetDrawNavGraph, "NavGraph"}),

		NewActionEntry("Toggle NavLines Debug" .. FormatBool(AccessTrackedBool("NavLines")), true,
					 Functions.ToggleFunctionWithTrackedBool, {Debug.SetDrawNavLines, "NavLines"}),

		NewActionEntry("Toggle NavPaths Debug" .. FormatBool(AccessTrackedBool("NavPaths")), true,
					 Functions.ToggleFunctionWithTrackedBool, {Debug.SetDrawNavPaths, "NavPaths"}),

		NewActionEntry("Toggle AI Locomotion Debug" .. FormatBool(AccessTrackedBool("LocoDebug")), true,
					 Functions.ToggleFunctionWithTrackedBool, {Debug.SetDrawLocoDebug, "LocoDebug"})
	}
end

--[[																		MISC FUNCTIONS																								]]--
function GetMiscMenuEntries()
	return {
		NewActionEntry("Become Adult/Child Menu", true, OpenMenu, {"Become Adult/Child", GetPlayerEntityMenuEntries}),
		NewActionEntry("Become Side Character Menu", true, OpenMenu, {"Become A Side Character", GetCharacterRecordMenuEntries}),
		NewActionEntry("Swap Gender", true, Functions.ChangeHeroGender, nil),
		NewActionEntry("Enable Safety Button in Wheel", true, Player.SetSafetyModeSuggestable, {QuestManager.HeroEntity, true}),
		NewActionEntry("Enable Quest/Map Menu", true, Player.SetMapScreenAsEnabled, {QuestManager.HeroEntity, true}),
		NewActionEntry("Enable Abilities Menu", true, Player.SetExperienceSpendingAsEnabled, {QuestManager.HeroEntity, true}),
		NewActionEntry("Enable Experience Orbs", true, ExperienceOrb.SetAsEnabled, {true})
	}
end


--[[																		BUILDING FUNCTIONS																								]]--
function GetBuildingsMenuEntries()
	return {
		NewActionEntry("Open/Close Nearest Door", true, Functions.CloseOrOpenDoor, nil),
		NewActionEntry("Buy All Buildings in Level", true, Functions.BuyAllBuildingsInLevel, nil),
		NewActionEntry("Buy Building From Targeted Sign", BuildingSaleSign.IsAvailable(Debug.GetHeroTarget()), Functions.BuyTargetedBuilding, nil)
	}
end
--[[																		QUEST SKIPS (may need Gameflow passing)																			]]--
function GetChildhoodQuestMenuEntries()
	return {
		NewActionEntry("Childhood Start", true, Gameflow.SetGameflowPosition, {Gameflow, ScriptEnum.DebugQC010}),
		NewActionEntry("Barnums Picture Box", true, Gameflow.SetGameflowPosition, {Gameflow, ScriptEnum.DebugQC020}),
		NewActionEntry("Warehouse Beetles", true, Gameflow.SetGameflowPosition, {Gameflow, ScriptEnum.DebugQC030}),
		NewActionEntry("Bullies and Dog", true, Gameflow.SetGameflowPosition, {Gameflow, ScriptEnum.DebugQC040}),
		NewActionEntry("The Warrants", true, Gameflow.SetGameflowPosition, {Gameflow, ScriptEnum.DebugQC050}),
		NewActionEntry("Retrieving Pete's Bottle", true, Gameflow.SetGameflowPosition, {Gameflow, ScriptEnum.DebugQC055})
	}
end
function GetPreSpireQuestMenuEntries()
	return {
		NewActionEntry("New Beginning", true, Gameflow.SetGameflowPosition, {Gameflow, ScriptEnum.DebugQC060}),
		NewActionEntry("Roadblock", true, Gameflow.SetGameflowPosition, {Gameflow, ScriptEnum.DebugQC065}),
		NewActionEntry("Thag", true, Gameflow.SetGameflowPosition, {Gameflow, ScriptEnum.DebugQC070}),
		NewActionEntry("Journey To Ravenscar", true, Gameflow.SetGameflowPosition, {Gameflow, ScriptEnum.DebugQC075}),
		NewActionEntry("Monk's Quest Pt 1", true, Gameflow.SetGameflowPosition, {Gameflow, ScriptEnum.DebugQC080}),
		NewActionEntry("Monk's Quest Pt 2", true, Gameflow.SetGameflowPosition, {Gameflow, ScriptEnum.DebugQC085}),
		NewActionEntry("Garth", true, Gameflow.SetGameflowPosition, {Gameflow, ScriptEnum.DebugQC090}),
		NewActionEntry("Fairfax", true, Gameflow.SetGameflowPosition, {Gameflow, ScriptEnum.DebugQC100}),
		NewActionEntry("Road To Westcliff", true, Gameflow.SetGameflowPosition, {Gameflow, ScriptEnum.DebugQC110}),
		NewActionEntry("The Crucible", true, Gameflow.SetGameflowPosition, {Gameflow, ScriptEnum.DebugQC120})
	}
end
function GetPostSpireQuestMenuEntries()
	return {
		NewActionEntry("Being A Soldier", true, Gameflow.SetGameflowPosition, {Gameflow, ScriptEnum.DebugQC130}),
		NewActionEntry("Breakout", true, Gameflow.SetGameflowPosition, {Gameflow, ScriptEnum.DebugQC140}),
		NewActionEntry("Bloodstone Or Bust", true, Gameflow.SetGameflowPosition, {Gameflow, ScriptEnum.DebugQC150}),
		NewActionEntry("Brightwood Cullis Gate", true, Gameflow.SetGameflowPosition, {Gameflow, ScriptEnum.DebugQC160}),
		NewActionEntry("Stranded (Wraithmarsh)", true, Gameflow.SetGameflowPosition, {Gameflow, ScriptEnum.DebugQC170}),
		NewActionEntry("The Pirate King", true, Gameflow.SetGameflowPosition, {Gameflow, ScriptEnum.DebugQC180}),
		NewActionEntry("Bloodstone Assault", true, Gameflow.SetGameflowPosition, {Gameflow, ScriptEnum.DebugQC200}),
		NewActionEntry("Opening The Portal", true, Gameflow.SetGameflowPosition, {Gameflow, ScriptEnum.DebugQC220}),
		NewActionEntry("The Music Box", true, Gameflow.SetGameflowPosition, {Gameflow, ScriptEnum.DebugQC230}),
		NewActionEntry("Endgame", true, Gameflow.SetGameflowPosition, {Gameflow, ScriptEnum.DebugQC240})
	}
end

--[[																					INVENTORY																					]]--
function GetInventoryMenuEntries()
	return {
		NewActionEntry("Weapons", true, OpenMenu, {"Weapon Menu", GetWeaponMenuEntries}),
		NewActionEntry("Items", true, OpenMenu, {"Item Menu", GetItemMenuEntries}),
		NewActionEntry("DLC Items", true, OpenMenu, {"DLC Items Menu", GetDLCItemMenuEntries}),
		NewActionEntry("Guild Cave Chest Items", true, OpenMenu, {"Guild Cave Chest Items", GetGuildChestItemMenuEntries}),
		NewActionEntry("Cosmetics", true, OpenMenu, {"Cosmetics Menu", GetCosmeticMenuEntries})
	}
end
function GetWeaponMenuEntries()
	return {
		NewActionEntry("AddAllInventoryItems", true, Debug.AddAllInventoryItems, {QuestManager.HeroEntity}),
		NewActionEntry("GiveAllMeleeWeapons", true, Debug.GiveAllMeleeWeapons, {}),
		NewActionEntry("GiveAllRangedWeapons", true, Debug.GiveAllRangedWeapons, {}),
		NewActionEntry("GiveAllWeapons", true, Debug.GiveAllWeapons, {}),
		NewActionEntry("GiveRustyWeapons", true, Debug.GiveRustyWeapons, {}),
		NewActionEntry("GiveIronWeapons", true, Debug.GiveIronWeapons, {}),
		NewActionEntry("GiveSteelWeapons", true, Debug.GiveSteelWeapons, {}),
		NewActionEntry("GiveMasterworkWeapons", true, Debug.GiveMasterworkWeapons, {}),
		NewActionEntry("GiveLegendaryWeapons", true, Debug.GiveLegendaryWeapons, {}),
		NewActionEntry("AddAllLightWeapons", true, Debug.AddAllLightWeapons, {QuestManager.HeroEntity}),
		NewActionEntry("AddAllHeavyWeapons", true, Debug.AddAllHeavyWeapons, {QuestManager.HeroEntity}),
		NewActionEntry("AddAllFirearms", true, Debug.AddAllFirearms, {QuestManager.HeroEntity}),
		NewActionEntry("AddAllCrossbows", true, Debug.AddAllCrossbows, {QuestManager.HeroEntity}),
		NewActionEntry("AddAllLegendaryWeapons", true, Debug.AddAllLegendaryWeapons, {QuestManager.HeroEntity}),
		NewActionEntry("AddAllAugmentations", true, Debug.AddAllAugmentations, {QuestManager.HeroEntity}),
		NewActionEntry("AddRandomAugmentation", true, Debug.AddRandomAugmentation, {QuestManager.HeroEntity}),
		NewActionEntry("AddAllAugmentableWeapons", true, Debug.AddAllAugmentableWeapons, {QuestManager.HeroEntity})
	}
end
function GetItemMenuEntries()
	return {
		NewActionEntry("AddAllGeneralBooks", true, Debug.AddAllGeneralBooks, {QuestManager.HeroEntity}),
		NewActionEntry("AddAllExpressionBooks", true, Debug.AddAllExpressionBooks, {QuestManager.HeroEntity}),
		NewActionEntry("AddAllDogBooks", true, Debug.AddAllDogBooks, {QuestManager.HeroEntity}),
		NewActionEntry("AddAllDogItems", true, Debug.AddAllDogItems, {QuestManager.HeroEntity}),
		NewActionEntry("AddAllPotions", true, Debug.AddAllPotions, {QuestManager.HeroEntity}),
		NewActionEntry("AddAllCards", true, Debug.AddAllCards, {QuestManager.HeroEntity}),
		NewActionEntry("AddAllTools", true, Debug.AddAllTools, {QuestManager.HeroEntity}),
		NewActionEntry("AddAllTrophies", true, Debug.AddAllTrophies, {QuestManager.HeroEntity}),
		NewActionEntry("AddAllFoodAndDrink", true, Debug.AddAllFoodAndDrink, {QuestManager.HeroEntity}),
		NewActionEntry("AddAllCarbonatedPrizes", true, Debug.AddAllCarbonatedPrizes, {QuestManager.HeroEntity}),
		NewActionEntry("AddAllFurniture", true, Debug.AddAllFurniture, {QuestManager.HeroEntity}),
		NewActionEntry("AddAllGifts", true, Debug.AddAllGifts, {QuestManager.HeroEntity}),
		NewActionEntry("AddAllLuciensDiaryPages", true, Debug.AddAllLuciensDiaryPages, {QuestManager.HeroEntity}),
		NewActionEntry("AddAllScriptItems", true, Debug.AddAllScriptItems, {QuestManager.HeroEntity})
	}
end
function GetDLCItemMenuEntries()
	return {
		NewActionEntry("AddAllDLC1Items", true, Debug.AddAllDLC1Items, {QuestManager.HeroEntity}),
		NewActionEntry("AddAllDLC1Augmentations", true, Debug.AddAllDLC1Augmentations, {QuestManager.HeroEntity}),
		NewActionEntry("AddAllDLC1Weapons", true, Debug.AddAllDLC1Weapons, {QuestManager.HeroEntity}),
		NewActionEntry("AddAllDLC1Potions", true, Debug.AddAllDLC1Potions, {QuestManager.HeroEntity}),
		NewActionEntry("AddAllDLC1Misc", true, Debug.AddAllDLC1Misc, {QuestManager.HeroEntity}),
		NewActionEntry("AddAllDLC1Clothing", true, Debug.AddAllDLC1Clothing, {QuestManager.HeroEntity}),
		NewActionEntry("AddAllDLC1AugmentableWeapons", true, Debug.AddAllDLC1AugmentableWeapons, {QuestManager.HeroEntity}),
		NewActionEntry("AddAllDLC2Items", true, Debug.AddAllDLC2Items, {QuestManager.HeroEntity})
	}
end
function GetGuildChestItemMenuEntries()
	return {
		NewActionEntry("Master Chief Items", true, Functions.GiveMasterchiefItems, nil),
		NewActionEntry("Chicken Costume Items", true, Functions.GiveChickenItems, nil),
		NewActionEntry("Other Chest Items", true, Functions.GiveOtherFlashItems, nil)

	}
end
function GetCosmeticMenuEntries()
	return {
		NewActionEntry("AddAllClothing", true, Debug.AddAllClothing, {QuestManager.HeroEntity}),
		NewActionEntry("AddAllClothingAccessories", true, Debug.AddAllClothingAccessories, {QuestManager.HeroEntity}),
		NewActionEntry("AddAllDyes", true, Debug.AddAllDyes, {QuestManager.HeroEntity}),
		NewActionEntry("AddAllDogCollars", true, Debug.AddAllDogCollars, {QuestManager.HeroEntity}),
		NewActionEntry("AddAllHairstyles", true, Debug.AddAllHairstyles, {QuestManager.HeroEntity}),
		NewActionEntry("AddAllMakeUp", true, Debug.AddAllMakeUp, {QuestManager.HeroEntity}),
		NewActionEntry("AddAllTattoos", true, Debug.AddAllTattoos, {QuestManager.HeroEntity}),
		NewActionEntry("AddAllClothingSuits", true, Debug.AddAllClothingSuits, {QuestManager.HeroEntity})
	}
end

--[[																					LEVELS																					]]--
function GetOverworldLevelMenuEntries()
	return {
		NewActionEntry("Bloodstone", true, Debug.LoadLevel, {'Albion', 'Bloodstone', ''}),
		NewActionEntry("Bower Lake", true, Debug.LoadLevel, {'Albion', 'BowerLake', ''}),
		NewActionEntry("Bowerstone Cemetery", true, Debug.LoadLevel, {'Albion', 'BWSCemetary', 'PlayerStart'}),
		NewActionEntry("Bowerstone Market", true, Debug.LoadLevel, {'Albion', 'BWSMarket', ''}),
		NewActionEntry("Bowerstone Slums", true, Debug.LoadLevel, {'Albion', 'BWSSlums', ''}),
		NewActionEntry("Brightwood", true, Debug.LoadLevel, {'Albion', 'Brightwood', ''}),
		NewActionEntry("Crucible (WC)", true, Debug.LoadLevel, {'Albion', 'Crucible', ''}),
		NewActionEntry("Dreamworld", true, Debug.LoadLevel, {'Albion', 'Dreamworld', ''}),
		NewActionEntry("Fairfax Castle Gardens (BWS)", true, Debug.LoadLevel, {'Albion', 'FairfaxCastleGardens', ''}),
		NewActionEntry("Oakfield (formerly Ravenscar)", true, Debug.LoadLevel, {'Albion', 'Ravenscar', ''}),
		NewActionEntry("Rookridge (formerly Dunecrest)", true, Debug.LoadLevel, {'Albion', 'DunecrestNew', 'PlayerStart'}),
		NewActionEntry("Tattered Spire", true, Debug.LoadLevel, {'Albion', 'TatteredSpire', ''}),
		NewActionEntry("Westcliff", true, Debug.LoadLevel, {'Albion', 'Westcliff', ''}),
		NewActionEntry("Wraithmarsh", true, Debug.LoadLevel, {'Albion', 'Wraithmarsh', ''})
	}
end
function GetDLCLevelMenuEntries()
	return {
		NewActionEntry("DLC2 Past", true, Debug.LoadLevel, {'Albion', 'DLC2\\DLC2_Past', ''}),
		NewActionEntry("DLC2 Present", true, Debug.LoadLevel, {'Albion', 'DLC2\\DLC2_Present', ''}),
		NewActionEntry("DLC2 Future", true, Debug.LoadLevel, {'Albion', 'DLC2\\DLC2_Future', ''}),
		NewActionEntry("DLC2 Colosseum", true, Debug.LoadLevel, {'Albion', 'DLC2\\DLC2_Colosseum', ''}),
		NewActionEntry("DLC Winter Shrine", true, Debug.LoadLevel, {'Albion', 'WinterShrine', ''}),
		NewActionEntry("DLC Summer Shrine", true, Debug.LoadLevel, {'Albion', 'SummerShrine', ''}),
		NewActionEntry("DLC Autumn Shrine", true, Debug.LoadLevel, {'Albion', 'Tombs\\Wraithmarsh\\AutumnShrine', ''}),
		NewActionEntry("DLC Island", true, Debug.LoadLevel, {'Albion', 'MysteryIsland', ''}),
		NewActionEntry("DLC Chamber of Seasons", true, Debug.LoadLevel, {'Albion', 'ChamberOfSeasons', ''})
	}
end
function GetCaveLevelMenuEntries()
	return {
		NewActionEntry("Bloodstone Assault Cave (BLS)", true, Debug.LoadLevel, {'Albion', 'Caves\\Bloodstone\\Bloodstone_Assault', ''}),
		NewActionEntry("Bloodstone Beach (BLS)", true, Debug.LoadLevel, {'Albion', 'Reaver Beach (Bloodtsone)', ''}),
		NewActionEntry("Fairfax Tomb (FCG)", true, Debug.LoadLevel, {'Albion', 'Tombs\\FairfaxCastleGardens\\FairfaxTomb', ''}),
		NewActionEntry("Farm Cellar (BW)", true, Debug.LoadLevel, {'Albion', 'Caves\\Brightwood\\BWFarmCellar', ''}),
		NewActionEntry("Gargoyles' Cave (BSM)", true, Debug.LoadLevel, {'Albion', 'Caves\\GargoylesCave', ''}),
		NewActionEntry("Gravekeepers Cave (BSC)", true, Debug.LoadLevel, {'Albion', 'Caves\\BWSCemetary\\GravekeepersCave', ''}),
		NewActionEntry("Green Mile (WC-BW)", true, Debug.LoadLevel, {'Albion', 'Caves\\Westcliff\\WestcliffExterior', ''}),
		NewActionEntry("Guild Cave (BL)", true, Debug.LoadLevel, {'Albion', 'Caves\\BowerLake\\ThagsCave', ''}),
		NewActionEntry("Hall of the Dead (BSC)", true, Debug.LoadLevel, {'Albion', 'Tombs\\BWSCemetery\\HallOfTheDead', ''}),
		NewActionEntry("Hobbe Cave (RR)", true, Debug.LoadLevel, {'Albion', 'Caves\\Dunecrest\\HobbeCave', ''}),
		NewActionEntry("Hobbes Cavern (OF)", true, Debug.LoadLevel, {'Albion', 'Caves\\Ravenscar\\HobbesCavern', ''}),
		NewActionEntry("Inn Cave (RR)", true, Debug.LoadLevel, {'Albion', 'Caves\\Dunecrest\\InnCave', ''}),
		NewActionEntry("Lady Grey's Tomb (FCG)", true, Debug.LoadLevel, {'Albion', 'Tombs\\BWSCemetery\\LadyGreysTomb', ''}),
		NewActionEntry("Nightmare Hollow (BSM)", true, Debug.LoadLevel, {'Albion', 'Tombs\\BWSMarket\\Nightmare Hollow', ''}),
		NewActionEntry("Palace Cave (WC)", true, Debug.LoadLevel, {'Albion', 'Caves\\Westcliff\\PalaceCave', ''}),
		NewActionEntry("Rescue My Baby Tomb (BL)", true, Debug.LoadLevel, {'Albion', 'Tombs\\BowerLake\\RescueMyBabyTomb', ''}),
		NewActionEntry("Ritual Cave (OF)", true, Debug.LoadLevel, {'Albion', 'Caves\\Ravenscar\\RVSRitualCave', ''}),
		NewActionEntry("River Cave (BW)", true, Debug.LoadLevel, {'Albion', 'Caves\\Deepwood\\RiverCave', ''}),
		NewActionEntry("Shadow Court (WM)", true, Debug.LoadLevel, {'Albion', 'Tombs\\Wraithmarsh\\HOTCrypt', ''}),
		NewActionEntry("Sink Hole (BLS)", true, Debug.LoadLevel, {'Albion', 'Caves\\Bloodstone\\SinkHole', ''}),
		NewActionEntry("Smuggler's Cave (WC)", true, Debug.LoadLevel, {'Albion', 'Caves\\Westcliff\\SmugglersCave', ''}),
		NewActionEntry("Temple of Evil (RR)", true, Debug.LoadLevel, {'Albion', 'TempleOfEvil', ''}),
		NewActionEntry("Treasure Island (BLS)", true, Debug.LoadLevel, {'Albion', 'Caves\\Bloodstone\\TreasureIsland', ''}),
		NewActionEntry("Twin Blade's Tomb (WM-BLS)", true, Debug.LoadLevel, {'Albion', 'Tombs\\Wraithmarsh\\WraithmarshToBloodstoneTomb', ''}),
		NewActionEntry("Waterfall Cave (RR)", true, Debug.LoadLevel, {'Albion', 'Caves\\Dunecrest\\WaterfallCave', ''}),
		NewActionEntry("Well Cave (BW)", true, Debug.LoadLevel, {'Albion', 'Caves\\Brightwood\\WellCave', ''}),
		NewActionEntry("Well Cave (WM)", true, Debug.LoadLevel, {'Albion', 'Caves\\Wraithmarsh\\WellCave', ''})
	}
end
function GetDemonDoorLevelMenuEntries()
	return {
		NewActionEntry("Bloodstone DD", true, Debug.LoadLevel, {'Albion', 'DemonDoors\\BloodstoneDD', ''}),
		NewActionEntry("Bower Lake DD", true, Debug.LoadLevel, {'Albion', 'DemonDoors\\BowerLakeDD', ''}),
		NewActionEntry("Bowerstone Cemetery DD", true, Debug.LoadLevel, {'Albion', 'DemonDoors\\BrightwoodDD', ''}),
		NewActionEntry("Brightwood DD", true, Debug.LoadLevel, {'Albion', 'DemonDoors\\RavenscarDD', ''}),
		NewActionEntry("Fairfax Castle Gardens DD", true, Debug.LoadLevel, {'Albion', 'DemonDoors\\MarcusMemorial', ''}),
		NewActionEntry("Oakfield DD", true, Debug.LoadLevel, {'Albion', 'DemonDoors\\Homestead', ''}),
		NewActionEntry("Rookridge DD", true, Debug.LoadLevel, {'Albion', 'DemonDoors\\DunecrestDD', ''}),
		NewActionEntry("Westcliff DD", true, Debug.LoadLevel, {'Albion', 'DemonDoors\\WestcliffDD', ''}),
		NewActionEntry("Wraithmarsh DD", true, Debug.LoadLevel, {'Albion', 'DemonDoors\\DeepwoodDD', ''})
	}
end

--[[																					CREATURES																					]]--
function GetFriendlyNPCMenuEntries()
	return {
		NewActionEntry("Theresa", true, Debug.CreateEntityByHero, {"QC010_Theresa", "TestTheresa"}),
		NewActionEntry("Reaver", true, Debug.CreateEntityByHero, {"ReaverTemplate", "TestReaver"}),
		NewActionEntry("Hammer", true, Debug.CreateEntityByHero, {"HammerOldTemplate", "TestHammer"}),
		NewActionEntry("Garth", true, Debug.CreateEntityByHero, {"GarthTemplate", "TestGarth"}),
		NewActionEntry("Generic Villager", true, Debug.CreateEntityByHero, {"CreatureVillager", "TestVillager"}),
		NewActionEntry("Games Master", true, Debug.CreateEntityByHero, {"CreatureVillagerTravellingGamesMaster", "TestVillager"}),
	}
end
function GetColourNPCMenuEntries()
	return {
		NewActionEntry("Blue Shadow Bandit", true, Debug.CreateEntityByHero, {'CreatureShadowBanditBlue', 'TestShadowBlue', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Red Shadow Bandit", true, Debug.CreateEntityByHero, {'CreatureShadowBanditRed', 'TestShadowRed', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Yellow Shadow Bandit", true, Debug.CreateEntityByHero, {'CreatureShadowBanditYellow', 'TestShadowYellow', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Easy Blue Shadow Bandit", true, Debug.CreateEntityByHero, {'CreatureShadowBanditBlueEasy', 'TestShadowBlue', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Easy Red Shadow Bandit", true, Debug.CreateEntityByHero, {'CreatureShadowBanditRedEasy', 'TestShadowRed', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Easy Yellow Shadow Bandit", true, Debug.CreateEntityByHero, {'CreatureShadowBanditYellowEasy', 'TestShadowYellow', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Medium Blue Shadow Bandit", true, Debug.CreateEntityByHero, {'CreatureShadowBanditBlueMedium', 'TestShadowBlue', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Medium Red Shadow Bandit", true, Debug.CreateEntityByHero, {'CreatureShadowBanditRedMedium', 'TestShadowRed', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Medium Yellow Shadow Bandit", true, Debug.CreateEntityByHero, {'CreatureShadowBanditYellowMedium', 'TestShadowYellow', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Base coloured Shadow Bandit", true, Debug.CreateEntityByHero, {'CreatureShadowBanditColourBase', 'TestColourBase', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Create Ghost Pirate", true, Debug.CreateEntityByHero, {'CreatureGhostPirate', 'TestGhostPirate', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Create Capain Dread QO170", true, Debug.CreateEntityByHero, {'CreatureCaptainDreadQO170', 'TestCaptainDread', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Shadow Balverine", true, Debug.CreateEntityByHero, {'CreatureShadowBalverine', 'TestShadowBalverine', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Shadow Bandit", true, Debug.CreateEntityByHero, {'CreatureShadowBandit', 'TestShadowBandit', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Shadow Beetle", true, Debug.CreateEntityByHero, {'CreatureShadowBeetleHugger', 'TestShadowBeetle', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Shadow Highwayman", true, Debug.CreateEntityByHero, {'CreatureShadowHighwayman', 'TestShadowHighwayman', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Shadow Hobbe", true, Debug.CreateEntityByHero, {'CreatureShadowHobbe', 'TestShadowHobbe', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Easy Shadow Bandit", true, Debug.CreateEntityByHero, {'CreatureShadowBanditEasy', 'TestShadowBanditEasy', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Easy Shadow Summoner", true, Debug.CreateEntityByHero, {'CreatureShadowSummonerEasy', 'TestShadowSummonerEasy', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Normal Shadow Summoner", true, Debug.CreateEntityByHero, {'CreatureShadowSummonerNormal', 'TestShadowSummonerNormal', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Hard Shadow Summoner", true, Debug.CreateEntityByHero, {'CreatureShadowSummonerHard', 'TestShadowSummonerHard', {Dist = 5.0, FaceHero = true}})
	}
end
function GetNecromancerNPCMenuEntries()
	return {
		NewActionEntry("Necromancer", true, Debug.CreateEntityByHero, {'CreatureNecromancer', 'TestNigelNecromancer', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Easy Necromancer", true, Debug.CreateEntityByHero, {'CreatureNecromancerEasy', 'TestNigelNecromancer', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Medium Necromancer", true, Debug.CreateEntityByHero, {'CreatureNecromancerMedium', 'TestNigelNecromancer', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("type 1 necromancer hollowman", true, Debug.CreateEntityByHero, {'CreatureHollowManNecroVar1', 'TestNecroHollow1', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("type 2 necromancer hollowman", true, Debug.CreateEntityByHero, {'CreatureHollowManNecroVar2', 'TestNecroHollow2', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("type 3 necromancer hollowman", true, Debug.CreateEntityByHero, {'CreatureHollowManNecroVar3', 'TestNecroHollow3', {Dist = 5.0, FaceHero = true}})
	}
end
function GetBansheeNPCMenuEntries()
	return {
		NewActionEntry("Banshee", true, Debug.CreateEntityByHero, {'CreatureBanshee', 'TestBanshee', {Dist = 20.0, FaceHero = true}}),
		NewActionEntry("Banshee Queen", true, Debug.CreateEntityByHero, {'CreatureBansheeQueen', 'TestBansheeQueen', {Dist = 20.0, FaceHero = true}}),
		NewActionEntry("Banshee Shadow Child", true, Debug.CreateEntityByHero, {'CreatureBansheeChild', 'TestBansheeChild', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Create Cornelius", true, Debug.CreateEntityByHero, {'CorneliusGrimShadowHighwaymanTemplate', 'TestCornelius', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Hollow Man Easy", true, Debug.CreateEntityByHero, {'CreatureHollowManEasy', 'TestHollowManEasy', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Hollow Man", true, Debug.CreateEntityByHero, {'CreatureHollowMan', 'TestHollowMan', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Hollow Man Elite", true, Debug.CreateEntityByHero, {'CreatureHollowManElite', 'TestHollowManElite', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Hollow Man Soldier", true, Debug.CreateEntityByHero, {'CreatureHollowManSoldier', 'TestHollowManSoldier', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Hollow Man Elite Soldier", true, Debug.CreateEntityByHero, {'CreatureHollowManEliteSoldier', 'TestHollowManEliteSoldier', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Bring forth the Headless Hollow Man", true, Debug.CreateEntityByHero, {'CreatureHeadlessHollowMan', 'TestHeadlessHollowMan', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Create Hollowman Leader QO815", true, Debug.CreateEntityByHero, {'CreatureQO815HollowmanLeader', 'TestHollowmanLeaderQO815', {Dist = 5.0, FaceHero = true}})
	}
end
function GetBalverineNPCMenuEntries()
	return {
		NewActionEntry("Basic Balverine", true, Debug.CreateEntityByHero, {'CreatureBalverine', 'TestBalverine', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Blooded Balverine", true, Debug.CreateEntityByHero, {'CreatureBalverineBlooded', 'TestBalverineBlooded', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Sire Balverine", true, Debug.CreateEntityByHero, {'CreatureBalverineSire', 'TestBalverineSire', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("poisonous Balverine", true, Debug.CreateEntityByHero, {'CreatureBalverinePoisoner', 'TestPoisonBalverine', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Easy poisonous Balverine", true, Debug.CreateEntityByHero, {'CreatureBalverinePoisonerEasy', 'TestPoisonBalverine', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Medium poisonous Balverine", true, Debug.CreateEntityByHero, {'CreatureBalverinePoisonerMedium', 'TestPoisonBalverine', {Dist = 5.0, FaceHero = true}})
	}
end
function GetBeetleNPCMenuEntries()
	return {
		NewActionEntry("Very Easy Beetle", true, Debug.CreateEntityByHero, {'CreatureBeetleBasicWeak', 'TestBeetleBasicWeak', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Very Easy Spitter Beetle", true, Debug.CreateEntityByHero, {'CreatureBeetleSpitterWeak', 'TestBeetleSpitterWeak', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Basic Beetle", true, Debug.CreateEntityByHero, {'CreatureBeetleBasic', 'TestBeetleBasic', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Basic Spitter Beetle", true, Debug.CreateEntityByHero, {'CreatureBeetleSpitterBasic', 'TestBeetleSpitterBasic', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Armoured Hugger Beetle", true, Debug.CreateEntityByHero, {'CreatureBeetleHuggerArmoured', 'TestBeetleHuggerArmoured', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Armoured Spitter Beetle", true, Debug.CreateEntityByHero, {'CreatureBeetleSpitterArmoured', 'TestBeetleSpitterArmoured', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Nocturnal Hugger Beetle", true, Debug.CreateEntityByHero, {'CreatureBeetleHuggerNocturnal', 'TestBeetleHuggerNocturnal', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Nocturnal Spitter Beetle", true, Debug.CreateEntityByHero, {'CreatureBeetleSpitterNocturnal', 'TestBeetleSpitterNocturnal', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Super Beetle", true, Debug.CreateEntityByHero, {'CreatureBeetleArmouredSuper', 'TestBeetleArmouredSuper', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Ice Beetle", true, Debug.CreateEntityByHero, {'CreatureBeetleIceSuper', 'TestBeetleIceSuper', {Dist = 5.0, FaceHero = true}})
	}
end
function GetBanditNPCMenuEntries()
	return {
		NewActionEntry("No Ranged Bandit", true, Debug.CreateEntityByHero, {'CreatureVillagerBanditNoRanged', 'TestBanditNoRanged', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("No Ranged & No block Bandit", true, Debug.CreateEntityByHero, {'CreatureVillagerBanditNoRangedNoParry', 'TestBanditNoRangedNoParry', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Easy Bandit Grunt", true, Debug.CreateEntityByHero, {'CreatureVillagerBanditEasy', 'TestBanditGruntEasy', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Bandit Turret", true, Debug.CreateEntityByHero, {'CreatureVillagerBanditTurret', 'TestBanditGruntTurret', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Basic Bandit Grunt", true, Debug.CreateEntityByHero, {'CreatureVillagerBandit', 'TestBanditGruntBasic', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Elite Bandit Grunt", true, Debug.CreateEntityByHero, {'CreatureVillagerBanditElite', 'TestBanditGruntElite', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Elite Turret Bandit Grunt", true, Debug.CreateEntityByHero, {'CreatureVillagerBanditTurretElite', 'TestBanditGruntTurretElite', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Basic Bandit Lieutenant", true, Debug.CreateEntityByHero, {'CreatureVillagerBanditLieutenant', 'TestBanditLieutenantBasic', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Elite Bandit Lieutenant", true, Debug.CreateEntityByHero, {'CreatureVillagerBanditLieutenantElite', 'TestBanditLieutenantElite', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Crucible Bandit", true, Debug.CreateEntityByHero, {'CreatureVillagerBanditCrucible', 'TestBanditCrucible', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Crucible Bandit Turret", true, Debug.CreateEntityByHero, {'CreatureVillagerBanditTurretCrucible', 'TestBanditCrucibleTurret', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Crucible Bandit Lieutenant", true, Debug.CreateEntityByHero, {'CreatureVillagerBanditLieutenantCrucible', 'TestBanditCrucibleLieutenant', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Create Bandit Leader Fairfax QO800", true, Debug.CreateEntityByHero, {'CreatureBanditLeaderFairfaxQO800', 'TestBanditFairfaxQO800', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Highwayman", true, Debug.CreateEntityByHero, {'CreatureHighwayman', 'TestHighwayman', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Elite Highwayman", true, Debug.CreateEntityByHero, {'CreatureHighwaymanElite', 'TestHighwaymanElite', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Create Highwayman Darius", true, Debug.CreateEntityByHero, {'CreatureHighwaymanDariusQO250', 'TestHighwaymanDarius', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Create idling Thag", true, Debug.CreateEntityByHero, {'CreatureVillagerScriptedBanditLeaderThag', 'TestThag', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Create idling Ripper", true, Debug.CreateEntityByHero, {'CreatureVillagerScriptedBanditLeaderRipper', 'TestRipper', {Dist = 5.0, FaceHero = true}})
	}
end
function GetGuardNPCMenuEntries()
	return {
		NewActionEntry("Basic Guard Grunt", true, Debug.CreateEntityByHero, {'CreatureVillagerGuard', 'TestGuardGruntBasic', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Elite Guard Grunt", true, Debug.CreateEntityByHero, {'CreatureVillagerGuardElite', 'TestGuardGruntElite', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Basic Guard Lieutenant", true, Debug.CreateEntityByHero, {'CreatureVillagerGuardLieutenant', 'TestGuardLieutenantBasic', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Elite Guard Lieutenant", true, Debug.CreateEntityByHero, {'CreatureVillagerGuardLieutenantElite', 'TestGuardLieutenantElite', {Dist = 5.0, FaceHero = true}})
	}
end
function GetHobbesNPCMenuEntries()
	return {
		NewActionEntry("Basic Hobbe Grunt", true, Debug.CreateEntityByHero, {'CreatureHobbe', 'TestHobbe', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Hobbe Ambusher", true, Debug.CreateEntityByHero, {'CreatureHobbeAmbusher', 'TestHobbeAmbusher', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Hobbe Elite Ambusher", true, Debug.CreateEntityByHero, {'CreatureHobbeAmbusherElite', 'TestHobbeAmbusherElite', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Hobbe Leader Ambusher", true, Debug.CreateEntityByHero, {'CreatureHobbeAmbusherLeader', 'TestHobbeAmbusherLeadder', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Hobbe Sniper", true, Debug.CreateEntityByHero, {'CreatureHobbeSniper', 'TestHobbeSniper', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Elite Hobbe Grunt", true, Debug.CreateEntityByHero, {'CreatureHobbeElite', 'TestHobbeElite', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Hobbe Leader", true, Debug.CreateEntityByHero, {'CreatureHobbeLeader', 'TestHobbeLeader', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Create Hobbe Leader QO270", true, Debug.CreateEntityByHero, {'CreatureHobbeLeaderQO270', 'TestQO270HobbeLeader', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Hobbe Leader no stilts", true, Debug.CreateEntityByHero, {'CreatureHobbeLeaderNoStilts', 'TestHobbeLeaderNoStilts', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Elite Hobbe Leader", true, Debug.CreateEntityByHero, {'CreatureHobbeEliteLeader', 'TestHobbeEliteLeader', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Elite HobbeLeader no stilts", true, Debug.CreateEntityByHero, {'CreatureHobbeEliteLeaderNoStilts', 'TestHobbeEliteLeaderNoStilts', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Hobbe Spellcaster", true, Debug.CreateEntityByHero, {'CreatureHobbeCaster', 'TestHobbeCaster', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Hobbe Spellcaster Healer", true, Debug.CreateEntityByHero, {'CreatureHobbeCasterHealer', 'TestHobbeHealer', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Create Hobbe Wizard QO190", true, Debug.CreateEntityByHero, {'CreatureQO190HobbeWizard', 'TestQO190HobbeWizard', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Hobbe Elite Spellcaster", true, Debug.CreateEntityByHero, {'CreatureHobbeEliteCaster', 'TestHobbeEliteCaster', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Hobbe Which Goes Boom", true, Debug.CreateEntityByHero, {'CreatureHobbeMentalist', 'TestHobbeMentalist', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Hobbe Skeleton", true, Debug.CreateEntityByHero, {'CreatureHobbeSkeleton', 'TestHobbeSkeleton', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Hobbe Elite Skeleton", true, Debug.CreateEntityByHero, {'CreatureHobbeEliteSkeleton', 'TestHobbeEliteSkeleton', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Crucible Hobbe", true, Debug.CreateEntityByHero, {'CreatureHobbeCrucible', 'TestHobbeCrucible', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Albino Hobbe", true, Debug.CreateEntityByHero, {'CreatureHobbeAlbino', 'TestHobbeAlbino', {Dist = 5.0, FaceHero = true}})
	}
end
function GetLucienGuardNPCMenuEntries()
	return {
		NewActionEntry("Basic Luciens Guard Grunt", true, Debug.CreateEntityByHero, {'CreatureLuciensGuard', 'TestLuciensGuardGruntBasic', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Basic Luciens Guard Lieutenant", true, Debug.CreateEntityByHero, {'CreatureLuciensGuardLieutenant', 'TestLuciensGuardLieutenantBasic', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Basic Luciens Guard Grunt Elite", true, Debug.CreateEntityByHero, {'CreatureLuciensGuardElite', 'TestLuciensGuardGruntBasic', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Basic Luciens Guard Lieutenant Elite", true, Debug.CreateEntityByHero, {'CreatureLuciensGuardLieutenantElite', 'TestLuciensGuardLieutenantBasic', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Luciens Soldier Grunt", true, Debug.CreateEntityByHero, {'CreatureLuciensSoldier', 'TestLuciensSoldier', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Luciens Soldier Elite", true, Debug.CreateEntityByHero, {'CreatureLuciensSoldierElite', 'TestLuciensSoldierElite', {Dist = 5.0, FaceHero = true}}),
		NewActionEntry("Create Commandant", true, Debug.CreateEntityByHero, {'CommandantTemplate', 'TestCommandant', {Dist = 5.0, FaceHero = true}})
	}
end
function GetShardNPCMenuEntries()
	return {
		NewActionEntry("Shard", true, Debug.CreateEntityByHero, {'CreatureShard', 'TestShard', {Dist = 15.0, FaceHero = true}}),
		NewActionEntry("Rusty Shard", true, Debug.CreateEntityByHero, {'CreatureShardRusty', 'TestShard', {Dist = 15.0, FaceHero = true}}),
		NewActionEntry("Large Shard", true, Debug.CreateEntityByHero, {'CreatureShardLarge', 'TestMegaShard', {Dist = 25.0, FaceHero = true}})
	}
end
function GetTrollNPCMenuEntries()
	return {
		NewActionEntry("Rock Troll", true, Debug.CreateEntityByHero, {'CreatureRockTroll', 'TestRockTroll', {Dist = 15.0, FaceHero = true}}),
		NewActionEntry("Swamp Troll", true, Debug.CreateEntityByHero, {'CreatureSwampTroll', 'TestSwampTroll', {Dist = 15.0, FaceHero = true}}),
		NewActionEntry("Tree Troll", true, Debug.CreateEntityByHero, {'CreatureTreeTroll', 'TestTreeTroll', {Dist = 15.0, FaceHero = true}})
	}
end

--[[																					CREATURES																					]]--
function GetPlayerEntityMenuEntries()
	return {
		NewActionEntry("Adult Female", true, Player.ChangePlayerEntityType, {QuestManager.HeroEntity, "CreatureHeroFemale"}),
		NewActionEntry("Adult Male", true, Player.ChangePlayerEntityType, {QuestManager.HeroEntity, "CreatureHero"}),
		NewActionEntry("Child Male", true, Player.ChangePlayerEntityType, {QuestManager.HeroEntity, "CreatureHeroChild"}),
		NewActionEntry("Child Female", true, Player.ChangePlayerEntityType, {QuestManager.HeroEntity, "CreatureHeroFemaleChild"}),
		NewActionEntry("Enable Magic While Child", true, PlayerAbility.SetAbilityRecord, {QuestManager.HeroEntity, "PlayerAbilitiesOneButtonCombat"}),
		NewActionEntry("Add Abilities Menu To DPad Once", true, Player.AddHUDSuggestionOfType, {QuestManager.HeroEntity, "HUDSuggestionLevelUp", "U", 500})

	}
end
function GetCharacterRecordMenuEntries()
	return {
		NewActionEntry("Become Balthazar", true, GraphicAppearanceMorph.SetCharacterRecord, {QuestManager.HeroEntity, "Balthazar"}),
		NewActionEntry("Become Barnum", true, GraphicAppearanceMorph.SetCharacterRecord, {QuestManager.HeroEntity, "Barnum"}),
		NewActionEntry("Become Charles", true, GraphicAppearanceMorph.SetCharacterRecord, {QuestManager.HeroEntity, "Charles"}),
		NewActionEntry("Become Maddog", true, GraphicAppearanceMorph.SetCharacterRecord, {QuestManager.HeroEntity, "Maddog"}),
		NewActionEntry("Become Max", true, GraphicAppearanceMorph.SetCharacterRecord, {QuestManager.HeroEntity, "Max"}),
		NewActionEntry("Become Monty", true, GraphicAppearanceMorph.SetCharacterRecord, {QuestManager.HeroEntity, "Monty"}),
		NewActionEntry("Become Murgo", true, GraphicAppearanceMorph.SetCharacterRecord, {QuestManager.HeroEntity, "Murgo"}),
		NewActionEntry("Become Murry", true, GraphicAppearanceMorph.SetCharacterRecord, {QuestManager.HeroEntity, "Murry"}),
		NewActionEntry("Become Sam", true, GraphicAppearanceMorph.SetCharacterRecord, {QuestManager.HeroEntity, "Sam"})
	}
end
