# Debug menu mod scripts  
My Debug Menu Mod with lots of debuggy things.  

<b>ALL SAVES ARE GoTY/PLATINUM UNLESS SPECIFIED</b>

## Savefile installation method
Savefile installation is easy, just download and extract the zip to ``%userprofile%\Documents\Xenia\content\4D5307F1\00000001\``.  

## Updating the mod menu
0. Go to ``/Fable 2/data/scripts/`` and create a new folder called ``DebugMenuMod``
1. Download the new scripts and copy them both to ``Fable 2/data/scripts/DebugMenuMod/``.
2. Open dir.manifest in ``/Fable 2/data/`` as a text file and add ``scripts\DebugMenuMod\MyDebugMenu.lua`` and ``scripts\DebugMenuMod\DebugMenuEntries.lua`` on new lines.
3. Load into your save, go to the last page and click ``(DEBUG) Reload Menu``

## Script installation method (advanced)
Requires MultipageMenu to be installed and ``require``able. Creating a new folder in ``/scripts/`` called ``Quests`` and putting it in there should work.  
Reminder that you must add all new files to the ``dir.manifest`` file in ``/data/``.
  
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
