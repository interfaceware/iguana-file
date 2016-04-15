-- Iguana makes it a breeze to script out an FTP feed with the translator.
-- Of course to make this work you will need to edit the credentials to fit
-- with a working FTP server.  You might want to use net.ftp.init or net.ftps.init
-- for different flavours of the FTP protocol - feel free to reach out to support
-- if you have any questions.

function main()
   local C = net.sftp.init{server='10.211.55.10',username='fred', password='smith'}
   local List = C:list{remote_path='/'}
   -- Take the complete list and find files that have the extension 'txt'
   local ProcessList = FindFilesThatMatch(List, 'txt')
   if #ProcessList == 0 then
      --iguana.logInfo("No files to collect.  Going to sleep.")
      return
   end
   -- We concatenate a list of files we are interested in
   iguana.logInfo("Filelist:\n"..table.concat(ProcessList, ","))
   for i=1, #ProcessList do
      iguana.logInfo("Fetching: "..ProcessList[i])
      local D = C:get{remote_path=ProcessList[i]}
      queue.push{data=D}
      if not iguana.isTest() then
         C:delete{remote_path=ProcessList[i]}
      end
      iguana.logInfo("Deleted "..ProcessList[i].." off server.")
   end
end

-- Takes list of files as returned by the Iguana translator ftp api
-- Returns array of files that match the given extension 
function FindFilesThatMatch(List, Extension)
   local Result = {}
   for i=1, #List do
      if List[i].filename:sub(-#Extension) == Extension then
         Result[#Result+1] = List[i].filename
      end
   end
   return Result
end
