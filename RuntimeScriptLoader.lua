-- By github.com/JustSomeGuy1234
-- Just Some Guy#8131 on Discord.

-- This script essentially reads and runs a specific external lua file every tick.
-- When the external script gets run, it assigns an int to a global variable called myTestTable.curChecksum
-- This script then checks to see if curChecksum has changed. 
-- If it has, this script knows the external script has changed and so it calls a specific function within the external script.
-- This specific function contains code that we can control, as it's in an external file.
-- We also have manual control over curChecksum in the external script.

-- So basically, whenever we want to run the external script we just change the curChecksum value in it and this script executes our code that we can change at runtime.

if myTestTable ~= nil then
  GUI.DisplayMessageBox("Not the first time RuntimeScriptLoader.lua has run!")
end
myTestTable = {}
myTestTable.curChecksum = 0
myTestTable.newChecksum = 0
myTestTable.Update = function()
  myTestTable.tickCounter = 0
  GUI.DisplayMessageBox("RuntimeScriptLoader starting...")
  myTestTable.lastResult = false
  myTestTable.lastReason = ""
  myTestTable.logString = ""
  while true do
    while true do
      -- This code loops every tick.
      -- The following function call draws the text that says true; nil.
      -- true will change to whether the external code succeeded in running, and nil will change to the error message.
      Debug.Draw3DText(Debug.GetHero():GetPosition() + CVector3(0, -2, 2), myTestTable.logString)
      -- Tick counter increases every tick.
      myTestTable.tickCounter = myTestTable.tickCounter + 1
      -- If a couple of seconds have passed, reset counter and run ext. script
      if myTestTable.tickCounter > 32 then
        myTestTable.tickCounter = 0
        
        -- Keep in mind that while the entire script is run, not all the code is called
        -- as some of it is in a function that is not called until the checksum (which I have external control over) has changed.
        RunScript("myscripts/test.lua") 
        
        if myTestTable.curChecksum ~= myTestTable.newChecksum then
          -- At this point, we changed the checksum in the external script ourselves.
          myTestTable.curChecksum = myTestTable.newChecksum
          -- Time to call the function defined by the external script, which must be called CodeToRun inside the myTestTable table.
          myTestTable.lastResult, myTestTable.lastReason = pcall(myTestTable.CodeToRun) -- Note the pcall. If our external script causes an error it will kill this coroutine.
          myTestTable.logString = tostring(myTestTable.lastResult) .. "\n" .. tostring(myTestTable.lastReason)
        end
      end
      coroutine.yield()
    end
  end
end
-- GeneralScriptManager.AddScript() creates a coroutine from the Update function within a given table, and coroutine.resume()'s it every game tick.
GeneralScriptManager.AddScript(myTestTable) 
