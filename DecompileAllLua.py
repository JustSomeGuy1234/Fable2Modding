import sys
import os
import subprocess
import io
import glob

missingFiles = "Files DecompileAllLua missed (but should have copied):\n"

passedFolder = sys.argv[1]

allLuas = glob.glob(passedFolder + "/**/*.lua", recursive=True)

for thisFile in allLuas:
	print("In: " + thisFile)
	
	# Determine the bnk the scripts are from.
	bnkName = ""
	gs = "gamescripts\\scripts\\"
	gsr = "gamescripts_r\\scripts\\"
	guis = "guiscripts\\scripts\\"
	guisa = "guiscripts\\art\\"

	hasFoundBankName = False
	if thisFile.find(gs) > -1:
		bnkName = gs
		hasFoundBankName = True
	if thisFile.find(gsr) > -1:
		bnkName = gsr
		hasFoundBankName = True
	if thisFile.find(guis) > -1:
		bnkName = guis
		hasFoundBankName = True
	if thisFile.find(guisa) > -1:
		bnkName = guisa
		hasFoundBankName = True

	# Get the file name, file folder, output folder
	thisFileName = thisFile[thisFile.rfind("\\"):len(thisFile)]
	thisFileFolder = thisFile[0:thisFile.rfind("\\")]
	if not hasFoundBankName or thisFileFolder.find(bnkName) == -1 or bnkName == "":
		print("Couldn't find: " + bnkName + "\nin file path!")
		print("hasFoundBankName is " + str(hasFoundBankName))
		print("filefolder is: " + thisFileFolder)
		input()
		break
	outFolder = thisFileFolder.replace(bnkName, bnkName + "\\decompiled\\")
	outFolder = outFolder.replace("\\\\","\\")
	outFile = outFolder+thisFileName
	print("Out: " + outFile)

	# Make output folder if it doesn't exist
	if not os.path.exists(outFolder):
		try:
			os.makedirs(outFolder)
		except OSError as err:
			print("Msg: Failed to create output folder.")
			print(err)
			input()

	# Make sure I didn't do something stupid and try and overwrite the original file
	if outFile == thisFile:
		print("Output path is the same as input path! Wut")
		input()
		break


	

	# Finale
	unluacArgs = "Java -jar ./unluac.jar " + '"' + thisFile + '"' + " > " + '"' + outFile + '"'
	copyArgs = ['copy', thisFile, outFile]
	print("CMD ARGS: " + unluacArgs)
	result = os.system(unluacArgs)
	if result != 0:
		print("unluac error. Probably because the script is already plaintext. Copying file.")
		try:
			os.remove(outFile)
			missingFiles += thisFile + "\n"
			copyResult = subprocess.call(copyArgs, shell=True)
			if copyResult != 0:
				print("And failed to copy it!")
				missingFiles += "Failed copy & decompile: " + thisFile + "\n"
		except OSError as err:
			print("Failed to remove failed script: " + thisFile)
			copyResult = subprocess.call(copyArgs, shell=True)
			if copyResult != 0:
				print("And failed to copy it!")
				missingFiles += "Failed copy & decompile: " + thisFile + "\n"


if missingFiles == "Files DecompileAllLua missed (but should have copied):\n":
	missingFiles = "\nDecompileAllLua missed no files c:"
print(missingFiles)
input("\nFinished")
