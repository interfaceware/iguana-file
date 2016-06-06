-- Iguana makes it a breeze to script out an FTP feed with the translator.
-- Of course to make this work you will need to edit the credentials to fit
-- with a working FTP server. You might want to use net.ftp.init or net.ftps.init
-- for different flavours of the FTP protocol - feel free to reach out to support
-- if you have any questions.

-- http://help.interfaceware.com/v6/read-from-ftp-site 

-- Follow the steps outlined to get this working

-- Takes list of files as returned by the Iguana translator ftp api
-- Returns array of files that match the given extension 
local function FindFilesThatMatch(List, Extension)
   local Result = {}
   for i=1, #List do
      if List[i].filename:sub(-#Extension) == Extension then
         trace(List[i].filename.." matches criteria.")
         Result[#Result+1] = List[i].filename
      end
   end
   return Result
end

function main()
   -- 1) Edit the credentials to connect to your FTP server
   -- 2) Also you might want to change net.ftp.init to net.sftp.init or
   --    net.ftps.init if you need to use the various secure versions of FTP 
   local C = net.ftp.init{server='10.211.55.10',username='fred', password='smith'}

   -- 3) Remote path of "." should be the default path. You might
   --    want to try '/' for the root etc.
   local List = C:list{remote_path="."}

   -- 4) We get the complete list and find files that have the extension 'txt.'
   --    You could modify the extension or write your own filtering criteria.
   --    Click on FindFilesThatMatch in the right annotation box to see how it works.
   --    Also click on the table objects to see the inputs and outputs
   local ProcessList = FindFilesThatMatch(List, 'txt')
   if #ProcessList == 0 then
      -- Mostly a good idea to comment this out - otherwise the logging is too busy
      --iguana.logInfo("No files to collect. Going to sleep.")
      return
   end

   -- We concatenate a list of files we are interested in and log it
   iguana.logInfo("Filelist:\n"..table.concat(ProcessList, ","))
   for i=1, #ProcessList do
      iguana.logInfo("Fetching: "..ProcessList[i])
      local D = C:get{remote_path=ProcessList[i]}
      queue.push{data=D}
      if not iguana.isTest() then
         -- We only delete the files off the server when the channel is running
         -- in production.
         C:delete{remote_path=ProcessList[i]}
      end
      iguana.logInfo("Deleted "..ProcessList[i].." off server.")
   end
end
