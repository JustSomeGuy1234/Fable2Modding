-- By github.com/JustSomeGuy1234
-- Just Some Guy#8131 on Discord.

-- This script essentially reads and runs a specific external lua file every x number of ticks. (Currently every couple of seconds)
-- When the external script gets run, it assigns an int to a global variable called myTestTable.newChecksum
-- This script then checks to see if newChecksum has changed since the last time it ran the external script. 
-- If it has, this script knows the external script has changed and so it calls a specific function within the external script.
-- This specific function contains code that we can control, as it's in an external plaintext file.
-- We also have manual control over newChecksum in the same external file.

-- So basically, whenever we want to run the external script we just change the curChecksum value in it and this script executes our code that we can change at runtime.

-- Oh and the script should work after loading a save too (which was a pain to figure out).
-- When the game loads a save, GSM (GeneralScriptManager) is basically passed all of the tables containing coroutine instances (and their variables) that it previously held when the game saved.
-- Unfortunately, these tables are not reassigned to the key that they were before and so the tables lose their original "names".
-- In this script though, I've basically checked to see if myTestTable is nil. If it is then the coroutine assigns the table that it's passed, to myTestTable in the global table. 
--  (the table it's passed should be the "unnamed", loaded, myTestTable table. It's automatically passed when GSM's Update function runs coroutine.resume on the script)

if myTestTable ~= nil then
  GUI.DisplayMessageBox("Not the first time the RuntimeScriptLoader script has run!\nThis is probably bad, as saving should manage the coroutine directly.")
end
myTestTable = {}
myTestTable.curChecksum = 0
myTestTable.newChecksum = 0
myTestTable.tickCounter = 0
myTestTable.lastResult = false
myTestTable.lastReason = "Last reason never set"
myTestTable.logString = "Log string never set"

myTestTable.Update = function(self)
  GUI.DisplayMessageBox("RuntimeScriptLoader starting...")
  while true do
    if not self then
      GUI.DisplayMessageBox("self is nil in MTT! :( Something has called this without passing the table.\n Expect everything to fail")
    end
    if not self.curChecksum or not self.newChecksum  or not self.logString then
      GUI.DisplayMessageBox("Something is nil in MTT!")
      GUI.DisplayMessageBox(tostring(self.curChecksum) .. "\n" .. tostring(self.newChecksum) .. "\n" .. tostring(self.lastReason) .. "\n" .. tostring(self.lastResult) .. "\n" .. tostring(self.logString))
    end

    -- This code loops every tick.
    -- The following function call draws the text that says true; nil.
    -- true will change to whether the external code succeeded in running, and nil will change to the error message.
    Debug.Draw3DText(Debug.GetHero():GetPosition() + CVector3(0, -2, 2), self.logString)
    -- Tick counter increases every tick.
    self.tickCounter = self.tickCounter + 1
    -- If a couple of seconds have passed, reset counter and run ext. script
    if self.tickCounter > 32 then
      self.tickCounter = 0
      -- If we're loading the game, the table containing the update coroutine and all vars will not actually be assigned to myTestTable 
      --    as the table name is seemingly lost when saving.
      -- In short, this script is within a different table so we just need to re-assign it.
      if(self ~= myTestTable) then
        GUI.DisplayMessageBox("myTestTable is not the table containing the code loader's coroutine!\nThis is most probably fine as it occurs after loading a save.")
        myTestTable = self
      end
      -- Keep in mind that while the entire script is run, not all the code is called
      -- as some of it is in a function that is not called until the checksum (which I have external control over) has changed.
      RunScript("RuntimeCode.lua")
      if self.curChecksum ~= self.newChecksum then
        -- At this point, we changed the checksum in the external script ourselves.
        self.curChecksum = self.newChecksum
        -- Time to call the function defined by the external script, which must be called CodeToRun inside the self table.
        self.lastResult, self.lastReason = pcall(self.CodeToRun) -- Note the pcall. If our external script causes an error it will kill this coroutine.
        self.logString = tostring(self.lastResult) .. "\n" .. tostring(self.lastReason)
      end
    end
    coroutine.yield()
  end
end


-- GeneralScriptManager.AddScript() creates a coroutine from the Update function within a given table, stores the coroutine within that table, and coroutine.resume()'s it every game tick.
GeneralScriptManager.AddScript(myTestTable)

-- For hijacking the Error function
--oldError = Debug.Error
--function Debug.Error(...) oldError(...) GUI.DisplayMessageBox(tostring(...)) end
