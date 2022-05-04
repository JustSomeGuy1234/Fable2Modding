--[[
	--- License & Credits ---
	By https://github.com/JustSomeGuy1234/
	Just Some Guy#8131

	If you use the Multipage System as a requirement of your own mod, you must leave a link to the above Github page so users can download it from there.
	Avoid direct links to the script file itself on Github as I may rename it in the future, leading to a 404. A link to the above Github page would be best.
	
	You may redistribute this script or the code within ONLY if it is to fix bugs or expand upon existing functionality. 
	You must accredit me on the page where the modified version of this script is redistributed.
	A link to my Github page must also be provided.
	
	In any and all cases, this license must be provided alongside the distribution of the script/code.
	If you must redistribute a compiled version this code (which removes all comments and therefor this license), copy this license into a seperate plaintext file which is downloaded alongside this script.
	--- License & Credits ---


	This is an example for my multi-page menu system for Fable II, which is meant to be adapted for use in mods.
	The game's ShowMenuBox function only allows for 5 options which is really not enough when you want to do something other than let the user select an amount of time to sleep for.
	This system allows you to very easily spread a theoretically infinite amount of menu options over an infinite amount of pages.
	Each "page" in the menu can be cycled through by pressing B.

	Multi-page menus have 2 things the player must know before using them.
	Firstly, the "Exit Menu" button is the first entry on the first page.
	Secondly, B will not close the menu. Instead it will go to the next page.
	There is no way to go back a page without cycling through however this is really not a problem if you categorize your menus properly and don't have a ridiculous number of entries on one menu.
	You can cycle through 3 pages per second so even if you have tons of entries its not a big deal to get back to the first page.

	To learn how you could use it look at the DoStuff(), ShowMainMenu(), and ShowSpellSelectMenu() functions (and Update() too, but that just runs the menu).
	ShowMenuBoxWithPages is the real function that you should learn how to use. It's the main thing this script is based around. Everything else is just an example on how you could use it.
	Basically to use the multipage menu, simply create a coroutine and have it pass ShowMenuBoxWithPages a title string and a table of entries (see example below).
	After the user chooses an option the func will return an int.
	The returned int will correspond to the entry in the table of entries at that index.
	For example say you pass the following table of entries to the function:
	entry_table = {  "Toggle God Mode", "Toggle Free Cam", "Reload Level", "Delete Dog", "Spawn Dog", "Set Infinite Ammo", "Decapitate Target"  }
	If the player chooses the Toggle God Mode entry, the function will return 1. If the player chooses Decapitate Target, the function will return 7.
	If the user chooses the Leave Menu button, the function will return 0 so make sure you handle that appropriately if you need to.

	For the above example I'd make a table called DebugFunctionTable and add a function to it for each entry. I'd have each functions index in DebugFunctionTable correspond to its index in the entry table.
	That way you can do something like DebugFunctionTable[returned_value]()

	ENTRY EXAMPLE:
	Entries are what I've named the menu options that get passed to the game's DisplayMenuBox function (which you shouldn't call directly).
	An entry can either be a simple string or a table containing a key named 'TextTag' and another called 'Enabled' (there may be more options).
	TextTag is what is shown in the menu, and Enabled is whether the user can select it.
	Entries must be added to a table which you pass as the second argument to the ShowMenuBoxWithPages()
	Lone entry example:
		{TextTag = "Spell Select", Enabled = true}
	Of course this must be added to a table, so we end up with
		entries = { {TextTag = "Spell Select", Enabled = true} }
	Without using variables, your final function call should be this:
		self:ShowMenuBoxWithPages("Menu Title", {  {TextTag = "Spell Select", Enabled = true}, "Just a string entry", {TextTag = "Unimplemented Menu", Enabled = false} })
	Note that there are only two arguments used here. The second argument is a table containing multiple entries.

	There are two more arguments you can pass to ShowMenuBoxWithPages that I have literally not tested yet.
	In theory:
		MultiSelect Mode:
			If you pass true as the third argument then MultiSelect mode is enabled.
			When MultiSelect is enabled, the user can choose multiple entries in the menu.
			As soon as they choose an entry, the entry is added to a table and the menu opens up again.
			After the user finally chooses the Exit Menu button, the menu is closed and any values chosen are returned in the table.
			The values are added to the table in the order they were chosen. So the first option chosen is stored in return_value[1], second option is stored in return_value[2], and so on.
			Because of this, you can iterate through the returned table with a numeric for-loop/ipairs and perform operations based on what the user chose.
		Page Number:
			The fourth arg is just the page number to start the menu at.
			If you make this higher than math.ceil(number_of_entries / 5) - 1 there's a decent chance it'll break the menu.
--]]



WispMenuCo = {
	MenuEnum = {SPELL_SELECT = 1, FOLLOW_BEHAVIOUR = 2}, 
	SpellEnum = { 
					{ID = "INFERNO", Name = "Inferno"}, {ID = "SHOCK", Name = "Shock"}, {ID = "VORTEX", Name = "Vortex"}, {ID = "TIME_CONTROL", Name = "Time Control"}, 
					{ID = "BLADES", Name = "Blades"}, {ID = "CHAOS", Name = "Chaos"}, {ID = "FORCE_PUSH", Name = "Force Push"}, {ID = "RAISE_DEAD", Name = "Raise Dead"}
				},
	CurrentSpell = 1
}
function WispMenuCo:GetSpellTag(spell_index)
	if spell_index == self.CurrentSpell then
		return "> " .. self.SpellEnum[spell_index].Name
	else
		return self.SpellEnum[spell_index].Name
	end
end


function WispMenuCo:Update() -- Manager coroutine, pretty much just for debugging. You could delete this function and rename DoStuff() to Update().
							 -- For the wisp, this will probably be the 'if looking at wisp, if hold lb, if pressed A' coroutine.
	self.worked = true
	self.whynot = "Hasn't failed yet?"
	self.do_stuff = coroutine.create(self.DoStuff)
	while self.worked do
		self.worked, self.whynot = coroutine.resume(self.do_stuff, self)
		coroutine.yield()
	end
	if not self.worked then
		local normal_co_error = "cannot resume normal coroutine"
		local dead_co_error = "cannot resume dead coroutine"
		if self.whynot == normal_co_error then
			self.whynot = "Menu coroutine has been frozen. This may happen if ShowMenuBox/WithPages is passed the wrong args."
		end

		if self.whynot ~= dead_co_error then
			GUI.DisplayMessageBox("Menu co failed! Reason:\n-------------\n" .. (self.whynot or "no reason given?"))
		elseif self.whynot == dead_co_error and not self.finished then
			GUI.DisplayMessageBox("Menu coroutine died before reaching the end. This shouldn't happen.")
		end
	end
end

function WispMenuCo:DoStuff()
	-- Main menu loop. We only exit from this if the player presses B at the main menu.
	local mainmenu_option
	while mainmenu_option ~= 0 do 
		mainmenu_option = self:ShowMainMenu()
		if mainmenu_option == self.MenuEnum.SPELL_SELECT then
			self:ShowSpellSelectMenu()
		end
	end
	self.finished = true
	GUI.DisplayMessageBox("Current spell is " .. (tostring(self.CurrentSpell) or "nil???"))
end

-- Define main menu
function WispMenuCo:ShowMainMenu()
	return self:ShowMenuBox("Main Wisp Menu", 
		{TextTag = "Spell Select",
		Enabled = true}, -- This can be false if the wisp has no spells
		{TextTag = "Wisp Following Behaviour",
		Enabled = false} -- Not implemented yet.
	)
end

-- Define the spell selection menu
function WispMenuCo:ShowSpellSelectMenu()
	local entries = {}
	for k,v in ipairs(self.SpellEnum) do
		local this_entry = {TextTag = self:GetSpellTag(k),
  							Enabled = true} -- todo: Get whether we have the spell or not.
		entries[k] = this_entry
	end
	local spell_option = self:ShowMenuBoxWithPages( "Spell Select Menu", entries, false)
	-- Here we process the spell selection.
	if spell_option ~= 0 then 
		self.CurrentSpell = spell_option
	end
end


-- Title of menu, every menu entry, (optional) whether the user can select multiple options which get returned in a table (100% untested), (optional) optional page number to start the menu at (100% untested)
function WispMenuCo:ShowMenuBoxWithPages(title, entries, multi_select, page_number)
	if type(entries) ~= "table" then
		GUI.DisplayMessageBox("Something tried to open a menu box with no/invalid entries!\nentries is of type: " .. type(entries))
		return 0
	end
	if not page_number then
		page_number = 0
	end
	-- Automatically add the exit menu entry. THIS SHIFTS EVERY ENTRY UP BY ONE. We must return entry-1 at the end. It's a little dirty.
	local tmp_entries = {}
	tmp_entries[1] = {TextTag = "Leave Menu", Enabled = true}
	for k,v in ipairs(entries) do
		tmp_entries[k+1] = v
	end
	entries = tmp_entries

	for k,v in pairs(entries) do
		local type_of_entry = type(v)
		if not type_of_entry == "string" and (not type_of_entry == "table" or not v.TextTag) then
			GUI.DisplayMessageBox("Something tried to open a menu box with an invalid entry!")
			return
		end
	end

	local entry_number
	local final_entry_number
	local total_pages = math.ceil(#entries / 5) - 1 -- Make first page be 0 so we don't add 1*5 to the results (otherwise final_entry_numer of first entry on first page would be 6)
	local multi_values = {}
	while final_entry_number ~= 1 do
		-- Page cycling. If entry_number is 0 it means the player pressed B which we will use for 'next page'.
		if entry_number == 0 then
			if page_number == total_pages then
				page_number = 0
			else
				page_number = page_number + 1
			end
		end

		-- Uncomment this for debugging
			--[[
			local testtable = {
				title .. " | Page " .. tostring(page_number+1) .. " of " .. tostring(total_pages + 1),
				entries[1 + (page_number * 5)],
				entries[2 + (page_number * 5)],
				entries[3 + (page_number * 5)],
				entries[4 + (page_number * 5)],
				entries[5 + (page_number * 5)]
			}
			for k,v in ipairs(testtable) do
				if not type(v) == "string" and not type(v.TextTag) == "string" then
					GUI.DisplayMessageBox("Invalid entry was passed to menu")
					return
				else
					GUI.DisplayMessageBox(v.TextTag or v)
				end
			end
			--]]

		-- LIFE IS PAIN. I HA-
		-- ShowMenuBox is honestly terrible to use. If you don't pass it exactly what it wants, it will freeze the coroutine that called it in a 'normal' status without an error message.
		-- I don't even know if the crashed coroutine is garbage-collected without nil'ing the reference in GeneralScriptManager. I guess we can maybe make the manager do that when it detects this scenario?

		-- Oh and for SOME reason if you pass it a nil arg instead of nothing it crashes(?!?)
		-- And so I create a table and add all entries to it, then "remove" invalid entries. There still needs to be consistency though, so I'll fill in any invalid entries with NONE.
		-- I then pass unpack(table_of_this_pages_entries) to ShowMenuBox so each entry is passed as a seperate arg.
		local page_entries = {
			entries[1 + (page_number * 5)],
			entries[2 + (page_number * 5)],
			entries[3 + (page_number * 5)],
			entries[4 + (page_number * 5)],
			entries[5 + (page_number * 5)]
		}
		-- Get any invalid entries before the last valid entry and set them as NONE. 
		-- We need to do this instead of nilling them as if there are valid entries afterwards we need their entry positions to stay the same.
		local lastentry
		for i=5,1,-1 do
			if page_entries[i] and not lastentry then
				lastentry = i
				break
			end
		end
		for i=1,5 do 
			if page_entries[i] == nil and i < lastentry then
				page_entries[i] = "NONE"
			end
		end

		entry_number = self:ShowMenuBox(
			title .. " | Page " .. tostring(page_number+1) .. " of " .. tostring(total_pages + 1),
			unpack(page_entries) -- Returns each entry as a seperate arg.
		)

		-- entry_number is only 0-5, so multiply it by current page. Option 3 on page 4 should be entry number 18.
		if entry_number ~= 0 then
			final_entry_number = entry_number + (page_number * 5) 
		else -- unless entry_number is 0 in which case the user pressed B and we don't want to store that.
			final_entry_number = 0
		end

		-- If user hasn't pressed B, and user hasn't chosen exit menu button, then add final entry number to table if multi_select or return it if not multi_select.
		if entry_number ~= 0 and final_entry_number ~= 1 then
			if multi_select then
				multi_values[#multi_values+1] = final_entry_number - 1 -- Remember, we nagate one because we added the menu entry.
			else
				return final_entry_number - 1
			end
		elseif final_entry_number == 1 and multi_select then -- User has pressed exit menu button (which should always be absolute first entry).
			return multi_values
		elseif final_entry_number == 1 and not multi_select then
			return 0
		end
	end
	-- In theory if we return a value, this will never be reached.
end

-- Every time the ShowMenuBoxWithPages opens a new page, this gets called and passes it 5 menu entries.
function WispMenuCo:ShowMenuBox(...)
	-- Make sure there's no more than 6 args (all that menu box can handle, first being title)
	local args = {select(1, ...)}
	local argCounter = 0
	for k,v in pairs(args) do
		argCounter = argCounter + 1
	end
	if argCounter > 6 then
		GUI.DisplayMessageBox("ShowMenuBox was given too many arguments!\nIf you want multiple pages, use ShowMenuBoxWithPages")
		return 0
	elseif argCounter < 2 then
		GUI.DisplayMessageBox("ShowMenuBox was not given at least a title and one entry!")
		return
	end

	
	self.LastMessageID_MenuBox = MessageEvents.GetMostRecentMessageID()
	GUI.DisplayMenuBox(...)
	while true do
		local menuposted, menumessage = MessageEvents.IsMessagePosted(EMessageEventType.MESSAGE_EVENT_MENUBOX, self.LastMessageID_MenuBox)
		if menuposted then
			self.LastMessageID_MenuBox = menumessage:GetID()
			local extradata = menumessage:GetExtraDataAsNumber()
			return extradata
		end
		coroutine.yield()
	end
end

-- Unused.
function WispMenuCo:GetSpellWithStringID(id)
	for i=1,#SpellEnum do
		if self.SpellEnum[i].ID == id then
			return self.SpellEnum[i]
		else
			return {ID = "NONE", Name = "NONE"}
		end
	end
end


GeneralScriptManager.AddScript(WispMenuCo)