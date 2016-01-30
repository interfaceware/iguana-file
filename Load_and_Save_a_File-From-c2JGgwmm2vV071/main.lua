-- This is some code to show how the file APIs in Iguana can be used.  It shows
-- just the bare APIs.  In practice I find personally I make a lot of helper functions.

SomeRandomData=[[
This is some random data to save to a file
with a few lines.
]]

function main()
   -- Iguana's 'working directory' can be 
   -- found using this function
   iguana.workingDir()
   
   -- Let's save a file
   local F = io.open("exampletext.txt", "w")
   F:write(SomeRandomData)
   F:close()
   
   -- Now open it for reading
   local F = io.open("exampletext.txt", "r")
   local Content = F:read("*a")
   -- Closing files is a good idea especially
   -- with windows.
   F:close()
   trace(Content)
   
   -- Rename a file 
   os.rename("exampletext.txt", "old.txt")
   -- Remove a file
   os.remove("old.txt")
   
   -- If a file does not exist then io.open
   -- returns nil
   local F, Reason = io.open("exampletext.txt", "r")
   if not F then 
      trace('File not present')
      trace(Reason)
   end
   -- Enjoy!
end