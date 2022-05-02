--[[
Written by https://github.com/JustSomeGuy1234/
Just Some Guy#8131

This script scans memory for every instance of given string (string_to_scan) and tries to get the rest of the string,
then write all found strings to a file. Keep in mind it does not scan backwards. For example, if you scan for BobNPC
it will find all 'BobNPC...'s but it won't get what was behind it, like '*NotActually*BobNPC'.

To use this, open Cheat Engine, open the Memory View menu, Press Ctrl + L,
paste this in, change the string_to_scan string and outputfolder string, then press execute.
--]]

local string_to_scan = "ObjectInventory" -- Change this to the string you want scanning, e.g. ObjectInventory or Creature
local outputfolder = "D:/" -- Change this to the directory that the scan will be written to. (e.g "C:/Users/You/Documents/Fable 2 text dump/")
local finaloutfilepath = outputfolder .. string_to_scan .. ".txt" -- If you just want to specify the entire filepath yourself, replace this with a single string.
local myFile = io.open(finaloutfilepath, "w")
-- If all is left unchanged, the file will end up in D:/ObjectInventory.txt

-- Turn each character in the string into their bytes and put them in the string.
local bytes_as_string = "" -- Don't change this
local string_to_scan_bytes = {string.byte(string_to_scan, 1, -1)}
for k,v in ipairs(string_to_scan_bytes) do
     bytes_as_string = bytes_as_string .. string.format("%x", v) .. " "
end

-- AOBScan returns userdata but it can be indexed. key is 1 through length, val is the memory address as a string.
-- The AOBScan object it returns also has a ton of functions and information about the scan. See the AOBScan documentation for more.
myresults = AOBScan(bytes_as_string)
processedResults = {}
for i=1,myresults.Count-1 do -- Genuinely unsure why we need to remove one, it's like Count is one too many.
    local thisByte
    local thisString = ""
    local thisByteOffset = tonumber("0x" .. myresults[i])
    print("Found " .. string_to_scan .. " at " .. myresults[i])
    if type(thisByteOffset) ~= "number" then
       print("Offset isn't a number somehow.")
       print("thisByteOffset = " .. (thisByteOffset or "nil"))
       print("myresults[i] is " .. (tostring(myresults[i]) or "nil") .. " of type: " .. type(myresults[i]))
       return
    end
    thisByte = readBytes(thisByteOffset, 1, false)
    local isFile
    -- Get every byte starting from where string_to_scan is found until we hit a terminator char, then store what we found if it's not a filepath.
    while thisByte ~= 0x00 and thisByte ~= 0x0D and thisByte ~= 0x0A and thisByte ~= 0x20 and thisByte ~= 0x22 do -- Terminator chars
          thisByte = string.char(thisByte)
          if thisByte == "\\" or thisByte == "." then
             isFile = true -- This if statment filters entries with \ or . as they're probably file paths. If you want them, remove this line.
          end
          thisByteOffset = thisByteOffset + 1
          thisString = thisString .. tostring(thisByte)
          thisByte = readBytes(thisByteOffset, 1, false)
    end
    -- Prevent duplicates. Unfortunately this results in us not being able to use ipairs.
    local alreadyFound
    for k,v in pairs(processedResults) do
        if v == thisString then
           alreadyFound = true
        end
    end
    if not alreadyFound and not isFile then
       processedResults[i] = thisString
    end
end
-- Every string we found should be in the processedResults table.
for k,v in pairs(processedResults) do
    myFile:write(v .. "\n")
end
myFile:flush()
myFile:close()
