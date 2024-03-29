# Most of this stuff is now redundant or out of date!
With the release of [Archon's Toolbox](https://github.com/JustSomeGuy1234/Archons-Toolbox), the Lua modding process is now fully automated.
There are still a couple of things in here that are convenient to have like the tables list and the cheat engine string scan but everything else is obsolete.
## Fable2Modding
This repository contains scripts and information on modding Fable 2 for the Xbox 360.  
Most information, tools, and scripts are for modding the Lua engine which gives you tons of control over the game.  
There's also a couple of things for other stuff.

## Fable 2 Lua Scripts (folder)
Contains useful Lua scripts and code that you can run ingame to do various things.  
Now contains RuntimeScriptLoader.

## Modding Guide.txt
An out of date (contains wrong info), relatively indepth guide to setting up a workflow for modding with Fable 2's Lua instances.   
Watch this instead:  
https://www.youtube.com/watch?v=Gvi9v9_c6KY

I might make a quickstart guide at some point, because getting set up if you know what you're doing only takes a few minutes. The majority of the main guide explains the situations you'll be in when you start, and how to solve any issues that arise but if you're impatient or feel that you're in over your head you probably won't make it a third of the way through the full one. It's quite a lot simpler than the guide makes out, probably because i'm bad at writing.

## CompileCompressReplace.py
Compiles and compresses your modified Lua script, then replaces the old version within the chosen bnk file.

This script (and its requirements) is all you need to begin writing your own code and have it run in-game. Kind of. Read the guide.

Pass it your non-compiled non-compressed lua script, the bnk the original script is in, LuaC.exe and Offzip.exe.

REQUIRES: Offzip.exe (https://aluigi.altervista.org/mytoolz.htm#offzip) 

REQUIRES: LuaC.exe (Try and find it online, or compile the Lua source code).

REQUIRES: Python 3.6 or something, I can't remember what I wrote the script in as I've been sitting on it for a couple of years.

## DecompileAllLua.py 
Decompiles all Lua files within a folder that has been extracted from one of Fable II's three script bnk files.  
ONLY WORKS IF THE FILE STRUCTURE AND FOLDER NAMES ARE UNTOUCHED FROM EXTRACTION. ( e.g. \gamescripts\scripts\...)
If the file structure or folder names are not as they were when extracted, the script will not work as it does some messy stuff to sort the files.

REQUIRES: unluac.jar (https://sourceforge.net/projects/unluac/) to be in the same folder, and also Java to be accessable from the command line.



## Functions and Tables I found.txt
A huge, messy list of all the interesting functions and tables I found that are accessable from the global environment.

## Cheat Engine Expanded String Scan.lua
A script for Cheat Engine's Lua Engine.  
It scans for all occurances of the given string in memory and tries to read the rest of each occurance, then writes all results to a file.  
Basically if you search for ObjectInventory, everything starting with ObjectInventory in memory will be written to a file.

## Fable2 Speech bnk.bms
A modified version of AlphaTwentyThree's wav scanner script for QuickBMS that extracts wav files, made to extract voice lines from speech.bnk.

REQUIRES: xmaencode.exe

REQUIRES: QuickBMS

### VERY IMPORTANT:
To use, create a new folder and name it anything, this folder will contain all extracted voice lines as well as the following.

Copy the following two files into this new folder:

\Fable 2\data\language\en-uk\filehash.csv (or your languages filehash.csv, may be different on other versions of the game)

\Fable 2\data\language\en-uk\speech\speech.bnk

Once they're in, run the QuickBMS script and select the speech.bnk file. When it asks you to choose the output folder, you must select the speech.bnk file again.

  If you do not choose the output folder correctly you will get a file not found error.
  
Your new folder will begin to rapidly fill with all of the voice lines within the speech bnk. You may now delete the copies of filehash.csv and speech.bnk.

### ALSO VERY IMPORTANT:
You will NOT be able to play the wav files immediately.

This is because they're encoded in Microsoft's proprietary xma format.

To decode them you will need an application called xmaencode.exe (NOT xWMAencode.exe. That is different). There may be alternatives out there but I know xmaencode works.

I cannot provide this file legally as it's from the 360's XDK software. I also cannot provide the XDK software.

Once you do manage to get xmaencode.exe from a completely legal source you can run the following in cmd to decode it into a normal playable wav.

xmaencode.exe path/to/output/folder /X path/to/input/file.wav

Since there's literally 45,600 voice lines you're going to want to make a batch to convert them all. Here's mine.

forfiles /S /M *.wav /C "cmd /c cd %~dp0 & echo @file & xmaencode.exe @PATH /X @PATH.wav"

This takes each wav file in every subfolder of the batch and passes it to xmaencode. It then saves the decoded version as your somefile.wav.wav

  You'll need to put this batch file in the same folder as xmaencode.exe (preferable outside of the folder with 45 thousand soon-to-be-90-thousand sound files...)

This is intentional as I have no experience with cmd and I can't figure out how to manipulate the path, so your folder will contain a copy of every sound with an extra .wav ext

Once it's done you can enter *.wav.wav into the search bar at the top right of file explorer and it will show every converted, ready-to-use wav file.

  (I can't remember how I removed all of the .wav.wav extensions afterwards automatically, but it doesn't matter functionally)
