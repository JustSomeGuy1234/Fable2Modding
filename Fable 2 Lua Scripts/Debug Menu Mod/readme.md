# Debug menu mod scripts  
My Debug Menu Mod with lots of debuggy things.  

<b>ALL SAVES ARE GoTY/PLATINUM (all DLC) UNLESS SPECIFIED</b>

## Savefile installation method
Savefile installation is easy, just download and extract the zip to ``Xenia\content\4D5307F1\00000001\``.  

## Updating the Debug Menu
0. Create a new folder in ``Fable 2\data\scripts\`` and call it ``Quests``.
1. Download [MultipageMenu.lua](..\MultipageMenu.lua) found in the Fable 2 Lua Scripts page and place it in there.
2. Back in ``\scripts\``, create another new folder called ``DebugMenuMod``
3. Download the new Debug Menu Mod scripts and copy them both into it
4. Open dir.manifest in ``\Fable 2\data\`` as a text file and add the following lines (which is how the folders should now look):  
``scripts\DebugMenuMod\MyDebugMenu.lua``  
``scripts\DebugMenuMod\DebugMenuEntries.lua``  
``scripts\Quests\MultipageMenu.lua``  
5. Load into your save, go to the last page and click ``(DEBUG) Reload Menu``

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
