#  Created by Just Some Guy: https://github.com/JustSomeGuy1234
#  Requires Offzip (https://aluigi.altervista.org/mytoolz.htm# offzip)
#  Requires LuaC compatible with Lua version 5.1. LuaC can be compiled from the Lua source code or simply downloaded from various places on the internet. 
# 	Here's a random link I found: https://github.com/rjpcomputing/luaforwindows/blob/master/files/luac5.1.exe
import io
import os
import sys
import zlib
import subprocess

# Ok so this script is for recompiling, recompressing and reimporting a lua file into a bnk file, then modifying the TOC of the bnk, effectively letting you modify ingame lua scripts.
# Basically this script just opens the bnk, read some bytes, read more bytes based on those bytes, decompress those bytes, read the decompressed bytes, modify those decompressed bytes based on the size of the script, recompress those bytes based, modify the original file.
# Simple, right?

# TODO: maybe allow importation of other filetypes, not just lua. Could be fun to mess around with models and textures, even if you have no clue what you're doing.


# I think we need to replace quotes otherwise we will get quotes IN the string, so it will be as if "\"C:\\asdfasd.dat\""
if len(sys.argv) == 5:
    plaintextPath = sys.argv[1].replace("\"", "") 
    LuaCPlusPath = sys.argv[2].replace("\"", "")
    offzipPath = sys.argv[3].replace("\"", "")
    bnkPath = sys.argv[4].replace("\"", "")
else:
	print("\nI highly recommend creating a batch file to pass this python script your:\nLua script, bnk file to modify, LuaC path, and Offzip path\nso you can replace a script without having to specify these file paths each time.\n\n")
	plaintextPath = input("Please drag and drop the lua file onto me and press enter.\nYour filename MUST be identical to how it was in the bnk (extension doesn't matter).\n").replace("\"", "")
	LuaCPlusPath = input("\nPlease drag and drop LuaC on me and press enter.\n").replace("\"", "")
	offzipPath = input("\nPlease drag and drop offzip.exe onto me and press enter.\n").replace("\"", "")
	bnkPath = input("\nPlease drag and drop the bnk file onto me and press enter.\n").replace("\"", "")  


if(not os.path.isfile(plaintextPath)):
	print("Can't find your plaintext script file! Make sure the path is correct. (1st arg)")
	sys.exit()
if(not os.path.isfile(LuaCPlusPath)):
	print("Can't find LuaC! Make sure the path is correct. (2nd arg)")
	sys.exit()
if(not os.path.isfile(offzipPath)):
	print("Can't find offzip! Make sure the path is correct. (3rd arg)")
	sys.exit()
if(not os.path.isfile(bnkPath)):
	print("Can't find the bnk file to modify! Make sure the path is correct. (4th arg)")
	sys.exit()


filename = plaintextPath

filenameList = filename.split("\\")
filename = filenameList[len(filenameList)-1] # Get the filename from the path
if filename.rfind(".") != -1:
	filename = filename[0:filename.rfind(".")] + ".lua" # replace the extension with .lua
else:
	print("Your script doesn't have a file extension. I have not tested this.")
	filename = filename[0:len(filename)] + ".lua" # add .lua as the extension
compiledPath = plaintextPath + ".compiled"

# Compile the file with LuaCPlus
luaCplusArgs = [LuaCPlusPath, "-s", "-o", compiledPath, plaintextPath]
print("LUACPLUS ARGS:\n" + str(luaCplusArgs))
input()
subprocess.run(luaCplusArgs) # Why the fuck is this not working? Not enough quotes in args? fuck this shit man. fuck python. fuck its lack of debugging. fuck its local variable view that only shows up to 10 characters

# Compress the file with zlib to create the final lua file
compiledFile = io.open(compiledPath, 'br') # open the compiled lua file in binary read
compiledBytes = compiledFile.read()
compiledFile.close()
os.remove(compiledPath)



# We'll need this to put into the TOC later.
compiledFileLen = len(compiledBytes)
compiledFileLen = compiledFileLen.to_bytes(4, "big")



compressedCompiledBytes = zlib.compress(compiledBytes)
compressedCompiledFileLen = len(compressedCompiledBytes)
compressedCompiledFileLenAsBytes = int.to_bytes(compressedCompiledFileLen, 4, "big")

# Now we've created our final lua file, we need to put it in the file and modify the TOC


# Uh we gotta figure out which lua file in the bnk to replace
# We could search the TOC for the exact filename as plaintextPath (excluding folders) but we would have to trust that the lua file name is identical. 
# Meh, i'll just have to remember to not rename them... which i don't do anyway.

bnkFile = io.open(bnkPath, "br") # Open the bank in binary read mode. We need to read stuff to figure out WHERE to write first.
bnkMemory = bytearray(bnkFile.read())
bnkFile.close()
baseOffset = int.from_bytes(bnkMemory[0:4], "big") # should be 0x8000... probably.

tocZSize = int.from_bytes(bnkMemory[9:13], "big")
print("tocZSize is " + str(tocZSize))
tocSize = int.from_bytes(bnkMemory[13:17], "big") # We don't need this for decompression, nor will we need to modify it because we won't be making the TOC bigger/smaller (we're literally just replacing some longs)


# Finished reading the header of the bnk and we have TOC metadata. Now we need the TOC.
tocRead = bnkMemory[0x11:0x11+tocZSize]

delTOC = ''
tocPath = bnkPath + ".toc"
if os.path.isfile(tocPath):
	print("Old TOC already exists, probably because this script failed to remove it last time.\nThis can be removed safely.\nContinue? y/n")
	delTOC = input()
	while delTOC != 'y' and delTOC != 'n':
		print("Old TOC already exists, probably because this script failed to remove it last time.\nThis can be removed safely.\nContinue?")
		delTOC = input()
	if delTOC == 'n':
		sys.exit()

if delTOC == 'y':
	os.remove(tocPath)
tocOut = io.open(tocPath, "xb")
tocOut.write(tocRead)
tocOut.close()

# So because the zip data is fucked, we have can't decompress it with zlib.decompress(). Quickbms also suffers this issue. Instead i'll just go the easy route and use offzip.
offzipArgs = [offzipPath, bnkPath + ".toc", bnkPath + ".tocDecomp"]
subprocess.run(offzipArgs)
os.remove(bnkPath + ".toc")

tocDecompressedFile = io.open(bnkPath + ".tocDecomp", "br")
tocDecompressed = tocDecompressedFile.read()
tocDecompressedFile.close()
os.remove(bnkPath + ".tocDecomp")


filenameAsBytes = bytearray(filename, "ascii")

# ISSUE: If we have two files that both contain the same words in the filename, it will replace the first one. 
# e.g if we have TheCat.py and Cat.py, and we want to modify Cat.py, it will replace TheCat.py because TheCat.py contains Cat.py
# SOLUTION: Keep the last \ in the filename so it searches for \Cat.py. This way it won't see \Cat.py in \TheCat.py (because of the characters inbetween \ and Cat.py)
# str.split() removes all \ in strings though, so we just added one back. (see creation of var)



filenameOffset = tocDecompressed.find(filenameAsBytes) # offset of the filename in hex. find() returns the zero based index eg. if you had a list of 16 items, it would say it occurs at 14 (-1 cos 0 based, -1 cos index of)
if  filenameOffset != -1:
	# We found the file in there. Good!
	print("Found the file! Found at " + str(filenameOffset) + "\n")
if filenameOffset == -1:
	# OOF!
	print("Didn't find your file! Ensure its filename is IDENTICAL to how it is in the bnk. (extension and dir doesn't matter)\nCheck the first few bytes of the compiled lua file for references\n\nSorry :(\n")
	exit()

# We don't need to know how long the filename is because we will find the end of it anyway.
# NOTE: The name of the compiled lua file is stored in the compiled lua file itself as well as the bnk.
# I don't think we have to change this however, as i imagine it only serves as debugging info if the script fails and plays no part in being found.
luaFileOffsetTOC = filenameOffset+len(filenameAsBytes)+1 # (add 1 because there's a null byte at the end of the filename)
unCompressedLuaSizeTOCOffset = luaFileOffsetTOC+4
compressedLuaSizeTOCOffset = unCompressedLuaSizeTOCOffset+4

luaFileOffsetInBnk = int.from_bytes(tocDecompressed[luaFileOffsetTOC:luaFileOffsetTOC+4], "big")
luaFileOldSizeInBnk = int.from_bytes(tocDecompressed[compressedLuaSizeTOCOffset:compressedLuaSizeTOCOffset+4], "big")

# Check if the new LUA file is bigger than the old one. If it is, it could overwrite the next entry in the bnk.
tooBigChoice = ""
newLuaDifference = luaFileOldSizeInBnk - compressedCompiledFileLen
if newLuaDifference > 0:
	print("New lua file is smaller than the old one. Good.\n")
else:
	if newLuaDifference < 0:
		tooBigChoice = input("The new LUA file is bigger than the old one by (int)" + str(newLuaDifference) + "! \nThis will probably be bad and break the game. Continue? y/n\n")
		while tooBigChoice != "n" and tooBigChoice != "y":
			tooBigChoice = input("y/n\n")
			if tooBigChoice == "y":
				print("if you say so\n")
			else:
				if tooBigChoice == "n":
					sys.exit()
# ??? Why must I do this twice??!? Something must be messed up in the while loop, but I'm too lazy to fix it seeing as I haven't touched this script/python since I made it 2 years ago.
if tooBigChoice == "n":
	sys.exit()

ItsAboutToGoCritical = tocDecompressed[compressedLuaSizeTOCOffset+7] == 2 # This byte is either 01 or 02. If 01, it's fine. If 02 however, there's 2 longs that add up to the uncompressed size. Dunno what they do, gonna leave it.
if ItsAboutToGoCritical:
	print("Came across a script with that unknown byte set to 2.\nI'll keep going though.\n")

# Time to modify the TOC. The "bytes" object is not mutable, so we must convert it to bytearray. No clue why.
tocDecompressedByteArray = bytearray(tocDecompressed)
tocDecompressedByteArray[unCompressedLuaSizeTOCOffset:unCompressedLuaSizeTOCOffset+4] = compiledFileLen # uncompressed file len
tocDecompressedByteArray[compressedLuaSizeTOCOffset:compressedLuaSizeTOCOffset+4] = compressedCompiledFileLenAsBytes # compressed file len
print(str(tocDecompressedByteArray[compressedLuaSizeTOCOffset:compressedLuaSizeTOCOffset+4]))
print("compressedCompiledFileLenAsBytes len is (hex)" + str(compressedCompiledFileLenAsBytes))
tocDecompressedByteArray[compressedLuaSizeTOCOffset+8:compressedLuaSizeTOCOffset+12] = compiledFileLen # uncompressed file len unless ItsAboutToGoCritical is 2 in which case it's different

# TOC modified. Time to replace it in the bnk.
os.remove(bnkPath)


tocRecompressed = zlib.compress(tocDecompressedByteArray)
tocRecompressedSize = len(tocRecompressed)
tocRecompressedSizeAsBytes = tocRecompressedSize.to_bytes(4, "big")
bnkMemory[0x9:0xD] = tocRecompressedSizeAsBytes
bnkMemory[0xd:0x11] = len(tocDecompressedByteArray).to_bytes(4, "big")
bnkMemory[0x11:0x11 + tocRecompressedSize] = tocRecompressed

# clean remnants of TOC from BNK
bytesToRemove = tocZSize - tocRecompressedSize 
if bytesToRemove > 0:
	print("old TOC was bigger than this one by (int)" + str(bytesToRemove) + ". Let's remove the leftover bytes.")
	bnkMemory[0x11 + tocRecompressedSize : 0x11 + tocRecompressedSize + bytesToRemove] = bytes(bytesToRemove)




# Finished replacing the TOC! Time to replace the lua file in the bnk.
bnkMemory[baseOffset + luaFileOffsetInBnk : baseOffset + luaFileOffsetInBnk + len(compressedCompiledBytes)] = compressedCompiledBytes




# Remove any leftover bytes from the old lua file in the bnk
if newLuaDifference > 0:
	nullArray = bytes(newLuaDifference)
	bnkMemory[baseOffset + luaFileOffsetInBnk + len(compressedCompiledBytes) : baseOffset + luaFileOffsetInBnk + len(compressedCompiledBytes) + len(nullArray)] = nullArray

# Done! Now just write our changes to the bnk.
bnkFile = io.open(bnkPath, "bx")
bnkFile.write(bnkMemory)
bnkFile.close()

print("CCR Finished!")
input()
