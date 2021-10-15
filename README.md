# Fable2Modding
Scripts and information on modding Fable 2 for the Xbox 360, mostly the game's Lua implementation.

# Modding Guide.txt
A relatively indepth guide to setting up a workflow for modding with Fable 2's Lua instances.

# Functions and Tables I found.txt
A huge, messy list of all the interesting functions and tables I found that are accessable from the global environment.

# CompileCompressReplace.py
Compiles and compresses your modified Lua script, then replaces the old version within the chosen bnk file.

This script (and its requirements) is all you need to begin writing your own code and have it run in-game. Kind of. Read the guide.

Pass it your non-compiled non-compressed lua script, the bnk the original script is in, LuaC.exe and Offzip.exe.

REQUIRES: Offzip.exe (https://aluigi.altervista.org/mytoolz.htm#offzip) 

REQUIRES: LuaC.exe (Try and find it online, or compile the Lua source code).

REQUIRES: Python 3.6 or something, I can't remember what I wrote the script in as I've been sitting on it for a couple of years.

# Fable2 bnk.bms
A bad QuickBMS script I wrote that extracts files from most bnk archives, except the big ones.
The input (bnk) file to extract from MUST be in the same directory as the output folder. Sorry 'bout that.
