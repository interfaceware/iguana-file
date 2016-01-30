
-- This example shows the calls to iterate through a directory.
-- The timestamp information is in unix epoch time - number of seconds since 1971
-- The os.ts.date function is helpful for converting this to human readable formats.
-- See http://help.interfaceware.com/api/#os_fs_glob for more information on os.fs.glob

function main()
   -- We will iterate through the default directory
   local Dir = iguana.workingDir()
   -- We'll make a list the files/dirs we find
   local List = {}
   for Name, FileInfo in os.fs.glob(Dir..'*') do
      trace(Name)
      List[Name] = FileInfo
      -- FileInfo has interesting stats on each file
      trace("Size  = "..FileInfo.size)
      -- Formating the time for readability
      os.ts.date("%c", FileInfo.ctime)
      -- Putting a ! in gives us UTC time
      os.ts.date("!%c", FileInfo.ctime)
      if (FileInfo.isdir) then
         trace("It is a dir")
      end
   end
   trace(List)
end
