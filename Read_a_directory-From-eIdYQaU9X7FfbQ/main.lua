-- This example shows the calls to iterate through a directory.
-- The timestamp information is in unix epoch time - number of seconds since 1971
-- The os.ts.date function is helpful for converting this to human readable formats.

-- http://help.interfaceware.com/v6/read-a-directory

-- for more information on os.fs.glob, see:
-- http://help.interfaceware.com/api/#os_fs_glob

function main()
   -- Get the working directory
   local Dir = iguana.workingDir()

   -- Iterate through the default directory
   -- to make a list of the files/dirs we find
   local List = {}
   for Name, FileInfo in os.fs.glob(Dir..'*') do
      trace(Name)

      -- Add a list entry for each file
      List[Name] = FileInfo      

      -- Trace a few interesting stats FileInfo has on each file
      trace("Size  = "..FileInfo.size)

      -- Formating the time for readability
      os.ts.date("%c", FileInfo.ctime)

      -- Adding a ! gives us UTC time
      os.ts.date("!%c", FileInfo.ctime)
      if (FileInfo.isdir) then
         trace("It is a dir")
      end
   end

   -- View the list we created
   trace(List)
end