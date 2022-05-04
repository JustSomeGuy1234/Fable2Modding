-- By https://github.com/JustSomeGuy1234
-- Just Some Guy#8131 on Discord

-- This script creates a function that gets all keys or values within a table and displays them on screen.
-- Intended to be run within Fable 2, though you can replace GUI.DisplayMessageBox() with print()

-- TO USE: myTestTable must be created beforehand. If you're using my RuntimeScriptLoader script then it should already exist. 
-- If you're not or you renamed the table must define it or rename all mentions of myTestTable in this script to a pre-existing table.
-- Just pass myTestTable.DisplayAllKeys a table and a bool. 
-- If you pass it false or nothing then it prints keys (which i recommend). Pass it true then it prints values.

-- Code begins:

-- myTestTable = {} -- UNCOMMENT THIS ONLY IF myTestTable DOESN'T EXIST. If it does you'll be breaking the functionality of RuntimeScriptLoader.lua
myTestTable.DisplayAllKeys = function(someTable, val) -- table to print, bool for whether to print key or values. Intended to print keys.
	local howManyKeys = 0
	myTestTable.tmpstr = ""
	for k,v in pairs(someTable) do
		local resultStr = ""
		if val then
			resultStr = tostring(v)
		else
			resultStr = tostring(k)
		end
		myTestTable.tmpstr = myTestTable.tmpstr .. "\n" .. resultStr
		howManyKeys = howManyKeys+1
	end
	if howManyKeys < 1 then
		GUI.DisplayMessageBox("Table had no keys!")
		return
	end
	
	-- Add all keys to a string, seperated by new lines
	myTestTable.strTable = {}

	for s in myTestTable.tmpstr:gmatch("[^\r\n]+") do
    	table.insert(myTestTable.strTable, s)
	end
	
	-- Print 12 lines of a table's keys at a time
	myTestTable.strBundle = ""
	myI = 0
	for i = 1, #myTestTable.strTable do
		myI = i
		if i % 12 == 0 then
			GUI.DisplayMessageBox(myTestTable.strBundle .. "\nPage " .. tostring(i/12) .. " of " .. tostring(#myTestTable.strTable/12))
			myTestTable.strBundle = ""
		end
		myTestTable.strBundle = myTestTable.strBundle .. tostring(myTestTable.strTable[i]) .. "\n"
	end
	if myI % 12 ~= 0 then
		GUI.DisplayMessageBox(myTestTable.strBundle)
		myTestTable.strBundle = ""
		myI = 0
	end
end
