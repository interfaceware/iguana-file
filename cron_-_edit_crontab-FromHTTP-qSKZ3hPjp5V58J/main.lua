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