# Debug menu mod scripts
To load the menu:  
Pass loadfile the path to MyDebugMenu.lua to get the script in the format of a function. Create a new table then set the fenv of the function to this table. Set the new table's metatable to itself and make \_\_index point to \_G. Finally, call the function and add the table to GeneralScriptManager. Here's a snippet of code that does exactly that.

```
local menutab = {}  
local menufunc = loadfile("scripts/DebugMenuMod/MyDebugMenu.lua")  
setfenv(menufunc, menutab)  
setmetatable(menutab,menutab)  
menutab.__index = _G  
menutab._G = _G  
menufunc()  
GeneralScriptManager.AddScript(menutab)  
```
