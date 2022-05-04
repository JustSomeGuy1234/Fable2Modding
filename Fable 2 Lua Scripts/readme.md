# RuntimeScriptLoader.lua
A Lua script that runs external scripts on command during runtime.

To use, put it in the scripts folder, then get this script loaded by adding a RunScript call to an internal bnk script.

Make another script in the scripts folder and pass it's filename to the RunScript call in RuntimeScriptLoader

In the new script, add the following lines:

>myTestTable.newChecksum = 0  
>function myTestTable.CodeToRun()  
>--  Code here  
>end  

You can write whatever you want to run at runtime within the CodeToRun function. Do not write anything outside of the CodeToRun function, except the checksum line.  
Whenever you want CodeToRun to be called, simply change the newChecksum value to something else.

# MultipageMenu.lua and MultipageMenu Example.lua
My multipage custom menu system. It allows for the creation of things like mod configuration menus, or debug menus, etc.  
Run the example script to see what it can do.  
Information on how to implement it into your mod is in the non-example script.  

# TableLogger.lua
(May not work due to upcoming RuntimeScriptLoader refactor)
A function that displays all keys or values in a table 12 at a time.
Pass true if you want to print the keys.
To be used with RuntimeScriptLoader.
