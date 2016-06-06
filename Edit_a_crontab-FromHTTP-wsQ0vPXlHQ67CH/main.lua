-- This example shows how to programmatically read a crontab 
-- NOTE: It is also possible (gulp!) write to a crontab 
--       Be cautious with writing to crontabs :-)

-- This code has only been tested under Linux

-- http://help.interfaceware.com/v6/cron-edit-crontab

local cron = require 'cron.edit'

local Template=[[
<html>
<body>
<p>
This is the crontab for this user:
</p>
<pre>
#CRONTAB#
</pre>
</body>
</html>
]]

function main(Data)
   local Content = cron.read()
   
   net.http.respond{body=Template:gsub("#CRONTAB#", Content)}
end