
-- This example shows the calls to iterate through a directory.
-- The one complication is that the wild card matching expression
-- has to be *.* for windows and * for OS X, Unix and Linux.

function main()
   -- We will iterate through the default directory
   local Dir = iguana.workingDir()
   -- We'll make a list the files/dirs we find
   local List = {}
   -- Glob matching pattern 
   -- is *.* for Windows, * for everything else.
   local Glob = GlobForOs()
   
   for Name, FileInfo in os.fs.glob(Dir..Glob) do
      trace(Name)
      List[Name] = FileInfo
      -- FileInfo has interesting stats on each file
      trace("Size  = "..FileInfo.size)
      if (FileInfo.isdir) then
         ShowDir(Name, FileInfo)
      else
         ShowFile(Name, FileInfo)
      end
   end
   trace(List)
end


function ShowDir(Name, Info)
   -- This is the create time
   trace(Info.ctime)
   -- It's unix epoch time
   -- number of seconds since
   -- 1971.
   -- We can convert it into a
   -- string using os.ts.date
   os.ts.date("%c", Info.ctime)
   -- Putting a ! in gives us
   -- UTC time
   os.ts.date("!%c", Info.ctime)
   -- Info.size can be interesting
   trace(Info.size) 
end


function ShowFile(Name, FileInfo)
      
end

function GlobForOs()
   return '*'
end