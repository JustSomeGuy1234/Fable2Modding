menu = require "MultipageMenu"
self = getfenv(1)
local modulename = "MyDebugMenu" -- Should be unused now
ScriptName = "DebugMenu"
IterationID = GetRandomNumber(100000)
SlowMenu = false
MenuOpen = false

-- [[ Debug Functions ]]
DumbBandits = {}
TimeStopIDs = {}
Functions = {}
-- Tracked bools are bools that we gotta track because the game doesn't give us funcs that return em. 
-- Call AccessTrackedBool and it will return the bool and optionally turn it from false/true to true/false.
-- ToggleFunctionWithTrackedBool inverts the given tracked bool and passes it to a given function.
TrackedBools = {
	BreadcrumbDebug = false,
	HeroLocomotionDebug = false,
	NavMesh = false,
	NavGraph = false,
	NavLines = false,
	NavPaths = false,
	LocoDebug = true
}
function AccessTrackedBool(key, invert)
	if key and (type(TrackedBools[key]) == "boolean") then
		local val = TrackedBools[key]
		if invert then 
			TrackedBools[key] = not val
		end
		return TrackedBools[key]
	else 
		GUI.DisplayMessageBox("Debug Menu tried to access nil tracked bool")
		return false
	end
end
function Functions.ToggleFunctionWithTrackedBool(func, theBoolKey)
	func(AccessTrackedBool(theBoolKey, true))
end

-- Menu Config funcs
function Functions.ToggleSlowMenu()
	SlowMenu = not SlowMenu
end
-- Npc spawn funcs
function Functions.DumbBandit()
	DumbBandit = Debug.CreateEntityByHero("CreatureVillagerBanditLieutenant", "TestDumbBandit")
	Combat.SetCanFight(DumbBandit, false)
	Combat.SetCanFlee(DumbBandit, false)
	Health.SetAsInvulnerable(DumbBandit, true)
	table.insert(DumbBandits, DumbBandit)
end
function Functions.DestroyDumbBandits()
	for k,v in pairs(DumbBandits) do
		if v:IsAlive() then
			v:Destroy()
			DumbBandits[k] = nil
		end
	end
end
function Functions.DestroyAllOfTarget()
	local herotarget = Debug.GetHeroTarget()
	if not herotarget or not herotarget:IsAlive() then
		return
	end
	local herotargetname = herotarget:GetName()
	if not herotargetname:find("Test") == 0 then 
		return
	end
	local search = SearchTools.FilterWithScriptFilter(SearchTools.StartNewSearch("all"), function(ent) return ent:GetName() == herotargetname end)
	local results = SearchTools.GetSearchResults(search)
	for k,v in pairs(results) do
		v:Destroy()
	end
end
-- Cheat funcs
function Functions.ModifyGold()
	local curgold = Money.Get(QuestManager.HeroEntity)
	local returnedAmount, user_accepted = GUI.AskForAmount(self, 
		{
			Type = EAdjusterTypes.ADJUSTER_TYPE_MONEY, MinVal = 0, MaxVal = 1000000000, Increment = 500, DefaultVal = curgold, ShowSign = false 
		}, "Set your gold.", 1)
	if user_accepted then
		local diff = returnedAmount - curgold
		Money.Modify(QuestManager.HeroEntity, diff)
	end
end
function Functions.GiveMasterchiefItems()
	Functions.AddAndShowItems({
		"ObjectInventory_L_Longsword_Spartan",
		"ObjectClothingHatSpartanM",
		"ObjectClothingCoatSpartanM",
		"ObjectClothingTrousersSpartanM",
		"ObjectClothingBootsSpartanM",
		"ObjectClothingGlovesSpartanM"
	})
	Stats.AddUnlockedTitle(QuestManager.HeroEntity, "ObjectInventoryHeroTitleMasterChief")
	Stats.SetTitleAsFreeToBuy(QuestManager.HeroEntity, "ObjectInventoryHeroTitleMasterChief")end
function Functions.GiveChickenItems()
	Functions.AddAndShowItems({
		"ObjectClothingHatMascotM",
		"ObjectClothingCoatMascotM",
		"ObjectClothingBootsMascotM"
	})
end
function Functions.GiveOtherFlashItems()
	Functions.AddAndShowItems({
		"ObjectInventoryBookExpressionFakeout",
		"ObjectInventoryGiftToyDollHero",
		"ObjectInventoryDyeClothingRarePink",
		"ObjectTattooFaceLionhead",
		"ObjectTattooTorsoLionhead",
		"ObjectInventoryGoldBag_Online"
	})
end
function Functions.AddAndShowItems(items)
	for k,v in pairs(items) do
		if GDB.RecordExists(v) then
			ScriptFunction.WaitForTimeInSeconds(.1)
			GUI.DisplayReceivedItem(Inventory.AddItemOfType(QuestManager.HeroEntity, v))
		end
	end
end
	-- Stats
function Functions.ModifyExperience()
	local currentxp = Experience.Get(QuestManager.HeroEntity, EExperienceType.EXPERIENCE_GENERAL)
	local returnedAmount, user_accepted = GUI.AskForAmount(self, 
		{   
			Type = EAdjusterTypes.ADJUSTER_TYPE_MONEY, MinVal = 0, MaxVal = 999999999, Increment = 500, DefaultVal = currentxp, ShowSign = false 
		}, "Set your general experience.", 1)
	local diff =  returnedAmount - currentxp
	ScriptFunction.WaitForTimeInSeconds(.7)
	if user_accepted then
		Experience.Modify(QuestManager.HeroEntity, EExperienceType.EXPERIENCE_GENERAL, diff, false)
	end
end
function Functions.ModifyMorality()
	local returnedAmount, user_accepted = GUI.AskForAmount(self, 
	{   
		Type = EAdjusterTypes.ADJUSTER_TYPE_MONEY, MinVal = 0, MaxVal = 2000, Increment = 50, DefaultVal = Stats.GetMorality(QuestManager.HeroEntity) + 1000, ShowSign = false 
	}, "Set your morality.\n0 Is evil. 1000 Is neutral. 2000 Is good.", 1)
	if user_accepted then
		Debug.SetHeroMorality(returnedAmount - 1000)
		GraphicAppearanceMorph.UpdateTextureMorphs(QuestManager.HeroEntity)
	end
end
function Functions.ModifyPurity()
	local returnedAmount, user_accepted = GUI.AskForAmount(self, 
	{   
		Type = EAdjusterTypes.ADJUSTER_TYPE_MONEY, MinVal = 0, MaxVal = 2000, Increment = 50, DefaultVal = Stats.GetPurity(QuestManager.HeroEntity) + 1000, ShowSign = false 
	}, "Set your purity.\n0 Is corrupt. 1000 Is neutral. 2000 Is pure.", 1)
	if user_accepted then
		Debug.SetHeroPurity(returnedAmount - 1000)
		GraphicAppearanceMorph.UpdateTextureMorphs(QuestManager.HeroEntity)
	end
end
function Functions.ModifyRenown()
	local returnedAmount, user_accepted = GUI.AskForAmount(self, 
	{   
		Type = EAdjusterTypes.ADJUSTER_TYPE_MONEY, MinVal = 0, MaxVal = 2000, Increment = 50, DefaultVal = Stats.GetRenown(QuestManager.HeroEntity), ShowSign = false 
	}, "Set your renown.", 1)
	if user_accepted then
		Stats.ModifyRenown(QuestManager.HeroEntity, returnedAmount - Stats.GetRenown(QuestManager.HeroEntity))
	end
end
 -- Loose cheats
function Functions.OverrideAmmo()
	local gotgun, gun = Functions.GetHeroGun()
	if gotgun and Firearm.IsAvailable(gun) then
		local returnedAmount, user_accepted = GUI.AskForAmount(self, {
			Type = EAdjusterTypes.ADJUSTER_TYPE_MONEY,
			MinVal = 1,
			MaxVal = 100,
			Increment = 1,
			DefaultVal = 1,
			ShowSign = false
		}, "Number of bullets before reload.\nReloading only gives normal amount.\nTip: Sheathing refills ammo after a moment.", 1)
		if user_accepted then 
			Firearm.OverrideCapacity(gun, returnedAmount)
		end
	end
end
function Functions.IsCarryingGun()
	local carrying_gun, gun = Functions.GetHeroGun()
	return carrying_gun
end
function Functions.SetDamageMultiplier()
	local returnedAmount, user_accepted = GUI.AskForAmount(self, 
		{   
			Type = EAdjusterTypes.ADJUSTER_TYPE_MONEY, MinVal = 0, MaxVal = 1000, Increment = 1, DefaultVal = 1, ShowSign = false 
		}, "Set damage multiplier.\n(Magic not effected)", 1)
	if user_accepted then
		Combat.SetDamageMultiplier(QuestManager.HeroEntity, returnedAmount)
	end
end
function Functions.SetActionSpeed()
	local returnedAmount, user_accepted = GUI.AskForAmount(self, 
		{   
			Type = EAdjusterTypes.ADJUSTER_TYPE_MONEY, MinVal = 1, MaxVal = 20, Increment = 1, DefaultVal = 1, ShowSign = false 
		}, "Set action speed multiplier.\nEffects more than just combat.", 1)
	if user_accepted then
		Combat.SetActionSpeedMultiplier(QuestManager.HeroEntity, returnedAmount)
	end
end
function Functions.GetHeroGun()
	local gunhand = Carrying.GetEntityInSlot(QuestManager.HeroEntity, DummyObjects.HAND_RIGHT)
	local gunback = Carrying.GetEntityInSlot(QuestManager.HeroEntity, DummyObjects.SHEATHE_RANGED_BACK)
	local gunhip = Carrying.GetEntityInSlot(QuestManager.HeroEntity, DummyObjects.SHEATHE_HIP)
	local gunfront = Carrying.GetEntityInSlot(QuestManager.HeroEntity, DummyObjects.SHEATHE_FRONT)
	local is_carrying = false
	local gun
	if Firearm.IsAvailable(gunhand) then
		is_carrying = true
		gun = gunhand
	elseif Firearm.IsAvailable(gunback) then
		is_carrying = true
		gun = gunback
	elseif Firearm.IsAvailable(gunhip) then
		is_carrying = true
		gun = gunhip
	elseif Firearm.IsAvailable(gunfront) then
		is_carrying = true
		gun = gunfront
	end
	return is_carrying, gun
end
function Functions.CloseOrOpenDoor()
	local heropos = QuestManager.HeroEntity:GetPosition()
	local search = SearchTools.FilterWithEC(SearchTools.StartNewSearch("objects"), Door.GetECType())
	SearchTools.FilterWithinDistanceOfPos(search, heropos, 8)
	local nearestDoor = SearchTools.GetNearestEntity(search, heropos)
	if nearestDoor then
		Door.SetOpen(nearestDoor, not Door.IsOpen(nearestDoor), true)
	end
end
function Functions.BuyAllBuildingsInLevel()
	local search = SearchTools.StartNewSearch("object")
	SearchTools.FilterWithEC(search, BuildingSaleSign.GetECType())
	local signs = SearchTools.GetSearchResults(search)
	local hero = QuestManager.HeroEntity
	for k,sign in pairs(signs) do
		if sign ~= nil and sign:IsAlive() and BuildingSaleSign.IsAvailable(sign) then
			local building = BuildingSaleSign.GetBuilding(sign)
			if building ~= nil and building:IsAlive() then
				PlayerProperties.PurchasePropertyQuietly(hero, building)
				MessageEvents.PostMessage({
				  type = "HousePurchased",
				  to = building,
				  from = hero
				})
			end
		end
	end
end
function Functions.BuyTargetedBuilding()
	local sign = Debug.GetHeroTarget()
	if sign and BuildingSaleSign.IsAvailable(sign) and BuildingSaleSign.GetBuilding(sign) then
		local building = BuildingSaleSign.GetBuilding(sign)
		PlayerProperties.PurchaseProperty(QuestManager.HeroEntity, building)
		MessageEvents.PostMessage({
		  type = "HousePurchased",
		  to = building,
		  from = QuestManager.HeroEntity
		})
	end
end
function Functions.ChangeTargetOpinion(axis, amount)
	local target = Debug.GetHeroTarget()
	if OpinionReaction.IsAvailable(target) then
		local opinions = OpinionReaction.GetCurrentPlayerOpinions(Debug.GetHeroTarget())
		if axis == "all" then
			for k,v in pairs(opinions) do
				opinions[k] = 0
			end
		else
			opinions[axis] = amount
		end
		OpinionReaction.SetAxisValue(target, EOpinionAxes.EOA_LOVE, opinions.love * -1)
		OpinionReaction.SetAxisValue(target, EOpinionAxes.EOA_FEAR, opinions.fear)
		OpinionReaction.SetAxisValue(target, EOpinionAxes.EOA_ATTRACTIVENESS, opinions.attractiveness)
		OpinionReaction.SetAxisValue(target, EOpinionAxes.EOA_MORALITY, opinions.love)
		OpinionReaction.SetAxisValue(target, EOpinionAxes.EOA_RESPECT, opinions.love)
	end
end

-- Misc functions
function Functions.ChangeHeroGender()
	if Gender.Get(QuestManager.HeroEntity) == EGender.EG_MALE then
	  Player.ChangePlayerEntityType(QuestManager.HeroEntity, "CreatureHeroFemale")
    else
      Player.ChangePlayerEntityType(QuestManager.HeroEntity, "CreatureHero")
    end
    if Gender.HasHadSexChange(QuestManager.HeroEntity) then
      Gender.SetHasHadSexChange(QuestManager.HeroEntity, false)
    else
      Gender.SetHasHadSexChange(QuestManager.HeroEntity, true)
    end
end
function Functions.UnlockChest()
	local hero_target = Debug.GetHeroTarget()
	if hero_target and Chest.IsAvailable(hero_target) then
		Chest.Unlock(hero_target)
		Chest.SetToDisplayLockedMessage(hero_target, false)
	end
end

-- Camera funcs
function Functions.HideGUI()
	ToHideGUI = true
end
function Functions.SetFOV()
	local returnedAmount, user_accepted = GUI.AskForAmount(self, {
		Type = EAdjusterTypes.ADJUSTER_TYPE_MONEY,
		MinVal = 5,
		MaxVal = 179,
		Increment = 1,
		DefaultVal = 75,
		ShowSign = false
	}, "FOV Slider", 1)
	if user_accepted then
		ScriptFunction.WaitForTimeInSeconds(1.5)
		Debug.SetFOV(returnedAmount)
		ScriptFunction.WaitForTimeInSeconds(1)
	end
end
-- Time funcs
function Functions.SetTimeOfDay()
	local returnedAmount, user_accepted = GUI.AskForAmount(self, {
		Type = EAdjusterTypes.ADJUSTER_TYPE_MONEY,
		MinVal = 0,
		MaxVal = 24,
		Increment = 1,
		DefaultVal = 12,
		ShowSign = false
	}, "Time Of Day", 1)
	if user_accepted then
		Timing.SetTimeOfDay(returnedAmount)
	end
end
function Functions.ToggleTime()
	if #TimeStopIDs > 0 then
		for k,v in ipairs(TimeStopIDs) do
			Timing.SetTimeAsStopped(false, v)
			TimeStopIDs[k] = nil
		end
	else
		table.insert(TimeStopIDs, Timing.SetTimeAsStopped(true))
	end
end
function Functions.DaySpeed()
	local returnedAmount, user_accepted = GUI.AskForAmount(self, {
		Type = EAdjusterTypes.ADJUSTER_TYPE_MONEY, MinVal = 0, MaxVal = 10000, Increment = 10, DefaultVal = 1440, ShowSign = false
	}, "Number of real seconds per day.\nLower is faster.\n0 Stops time.", 1)
	if user_accepted then
		Timing.SetDaySpeed(returnedAmount)
	end
end
function Functions.TimeControl()
	local returnedAmount, user_accepted = GUI.AskForAmount(self, {
		Type = EAdjusterTypes.ADJUSTER_TYPE_PERCENTAGE,
		MinVal = 10,
		MaxVal = 300,
		Increment = 10,
		DefaultVal = 100,
		ShowSign = false
		}, "This controls the speed of the world around you.\nUse at your own risk.\nLower is slower.", 1)
	if user_accepted then
		returnedAmount = returnedAmount * 0.01
		Debug.SetHeroSlowTime(returnedAmount)
	end
end

--[[																																																MISC/RENDER 																																				]]
function Functions.FadeDog()
	function SACCamera:FadeAllEntitiesBasedOnPositionIfNeeded(close_range, to_ignore, fade_heroes)
		GraphicAppearance.SetCameraAlpha(GetDog(), 0)
	end
end
function Functions.SetStaticRendDist()
	local returnedAmount, user_accepted = GUI.AskForAmount(self, {
		Type = EAdjusterTypes.ADJUSTER_TYPE_MONEY, MinVal = 1, MaxVal = 10, Increment = 1, DefaultVal = 1, ShowSign = false
		}, "Static Entity render distance multiplier.\nThings like ruins, fences, etc.", 1)
	if user_accepted then
		Debug.SetStaticEntityDrawDistanceMultiplier(returnedAmount)
	end
end
function Functions.SetAnimatedRendDist()
	local returnedAmount, user_accepted = GUI.AskForAmount(self, {
		Type = EAdjusterTypes.ADJUSTER_TYPE_MONEY, MinVal = 1, MaxVal = 10, Increment = 1, DefaultVal = 1, ShowSign = false
		}, "Animated Entity render distance multiplier.\nThings like hanging lights and ???", 1)
	if user_accepted then
		Debug.SetAnimatedEntityDrawDistanceMultiplier(returnedAmount)
	end
end
function Functions.SetVillagerRendDist()
	local returnedAmount, user_accepted = GUI.AskForAmount(self, {
		Type = EAdjusterTypes.ADJUSTER_TYPE_MONEY, MinVal = 1, MaxVal = 10, Increment = 1, DefaultVal = 1, ShowSign = false
		}, "Villager Entity render distance multiplier.", 1)
	if user_accepted then
		Debug.SetVillagerDrawDistanceMultiplier(returnedAmount)
	end
end
function Functions.SetCreatureRendDist()
	local returnedAmount, user_accepted = GUI.AskForAmount(self, {
		Type = EAdjusterTypes.ADJUSTER_TYPE_MONEY, MinVal = 1, MaxVal = 10, Increment = 1, DefaultVal = 1, ShowSign = false
		}, "Creature Entity render distance multiplier.\nThis is anything that's alive and isn't a villager.", 1)
	if user_accepted then
		Debug.SetCreatureDrawDistanceMultiplier(returnedAmount)
	end
end


-- [[ Entry Logic ]]
function FormatBool(thebool)
	if type(thebool) == "boolean" then
		return " (" .. tostring(thebool)  .. ")"
	else
		return ""
	end
end

function NewActionEntry(text, enabled, func, args)
	local entry = {}
	if type(text) == "string" then
		entry.TextTag = text

		if type(enabled) == "boolean" then
			entry.Enabled = enabled
		else
			entry.Enabled = true
		end

		if not func then
			entry.TextTag = text .. " (err: nil function)"
		else
			entry.Function = func
		end
		entry.Args = args

		return entry
	else
		return "Malformed entry"
	end
end

function HandleEntry(entry)
	if type(entry.Function) == "function" then
		if type(entry.Args) == "table" then
			entry.Function(unpack(entry.Args))
		else
			entry.Function(entry.Args)
		end
	end
end

-- [[ Define Menu Entries ]]
local DefineEntriesScript = loadfile("scripts/DebugMenuMod/DebugMenuEntries.lua")
setfenv(DefineEntriesScript, getfenv(1))
DefineEntriesScript()



-- [[ Menu Function ]]
function OpenMenu(title, entriesfunction)
	local result
	local lastpage = 0
	while result ~= 0 and not CloseAll do
		local entries = entriesfunction()
		result, lastpage = menu.ShowMenuBoxWithPages(title, entries, false, lastpage, SlowMenu)
		if result == 0 then break end
		local selectedentry = entries[result]
		HandleEntry(selectedentry)

		-- If user clicked right stick, process final choice then end. This only occurs on the current menu, but CloseAll is set to true so all menus close.
		local is_posted, message = MessageEvents.IsMessagePosted(EMessageEventType.MESSAGE_EVENT_GENERIC_RIGHT_STICK_PRESSED, LastStickID)
		if is_posted and message:GetTimeStamp() - FrameMenuOpened > 0 then 
			LastStickID = message:GetID()
			CloseAll = true
		end
		coroutine.yield()
	end
end

function Update()
	custom_update = coroutine.create(CustomUpdate)
	hide_gui_update = coroutine.create(HideGUIUpdate)
	while not ShouldDie do
		coroutine.yield()

		MenuScriptWorked, MenuWhyNot = coroutine.resume(custom_update)
		if not MenuScriptWorked then
			GUI.DisplayMessageBox("Guy's Debug Menu has ended! Reason:\n " .. tostring(MenuWhyNot))
			ShouldDie = true
		end

		HideScriptWorked, HideWhyNot = coroutine.resume(hide_gui_update)
		if not HideScriptWorked then
			GUI.DisplayMessageBox("Guy's Debug Menu - Error in GUI Hider:\n " .. tostring(HideWhyNot))
			ShouldDie = true
		end
		if ShouldDie and not Restarting then
			coroutine.yield()
			if GUI.AskYesNoQuestion("Debug Menu Script encountered an error. Restart?", self) then				
				coroutine.yield()
				custom_update = coroutine.create(CustomUpdate)
				hide_gui_update = coroutine.create(HideGUIUpdate)
				ShouldDie = false
			end
		end
	end

	coroutine.yield()
end

function CustomUpdate()
	while true do
		coroutine.yield()
		if Player.IsInFirstPerson(QuestManager.HeroEntity) or Debug.GetUseFreeCamera() then
			local pressed_a, message = MessageEvents.IsMessagePosted(EMessageEventType.MESSAGE_EVENT_GENERIC_A_BUTTON_PRESSED, LastMessageID_PressedAButton)
			if pressed_a and (Timing.GetWorldFrame() == message:GetTimeStamp()) then
				LastMessageID_PressedAButton = message:GetID()
				Debug.SetDrawGUI(true) 	-- Unfortunately I couldn't find a way to get whether the GUI is enabled or disabled when opening the menu, so we cannot restore how it was when the menu closes.
				ToHideGUI = false
				MenuOpen = true
				FrameMenuOpened = Timing.GetWorldFrame()
				OpenMenu("Guy's Debug Menu (" .. tostring(IterationID) .. ")", GetMainMenuEntries)
				MenuOpen = false
				CloseAll = false
			end
		end
	end
end

function HideGUIUpdate()
	while not ShouldDie do
		if ToHideGUI then
			ToHideGUI = false
			while MenuOpen do
				coroutine.yield()
			end
			ScriptFunction.WaitForTimeInSeconds(.7)
			if not MenuOpen then
				Debug.SetDrawGUI()
			end
		end
		coroutine.yield()
	end
end

function Terminate()
	ShouldDie = true
end

function ReloadMenu()
	local menufunc = loadfile("scripts/DebugMenuMod/MyDebugMenu.lua")
	if type(menufunc) ~= "function" then 
		GUI.DisplayMessageBox("Couldn't run Debug Menu script!")
		return
	elseif type(loadfile("scripts/DebugMenuMod/DebugMenuEntries.lua")) ~= "function" then
		GUI.DisplayMessageBox("Couldn't run entry definitions script!")
		return
	end
	Restarting = true
	Terminate()
	local menutab = {}
	setfenv(menufunc, menutab)
	setmetatable(menutab,menutab)
	menutab.__index = _G
	menutab._G = _G
	menufunc()
	GeneralScriptManager.AddScript(menutab)
end