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

# MultipageMenu.lua
My multipage custom menu system. It allows for the easy creation of things like mod configuration menus, or debug menus, etc.  
Once loaded, the menu can be used by simply having a coroutine pass MultipageMenu.ShowMenuBoxWithPages() the title and a table of strings.  
Information on how to implement it into your mod is in the non-example script.  

# TableLogger.lua
(May not work due to upcoming RuntimeScriptLoader refactor)
A function that displays all keys or values in a table 12 at a time.
Pass true if you want to print the keys.
To be used with RuntimeScriptLoader.
