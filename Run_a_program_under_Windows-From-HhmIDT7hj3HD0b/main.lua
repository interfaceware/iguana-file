-- This example shows invoking a command line program on windows.  One of
-- the complications with windows is if you have multiple volumes
-- Iguana could be running on the C: drive and if you wanted to
-- run a program on the D: drive then you have do something like
-- "D:\ && cd D:\\Some Directory\\XYX\\ && MyCommand"
-- It can be very perplexing the first time you run into this.

function main()
   local Command = [[C: && cd C:\\Windows && dir]]

   -- When executing a binary with os.execute we won't see the output that
   -- the binary generates, but we can see the exit status of the command.
   local Success, Message = Execute(Command)
   trace(Success, Message)
   
   -- If we want to see the output a executable generates we can use
   -- io.popen instead.
   local Out = ExecuteWithOutput(Command)
   trace(Out)
end

function Execute(cmd)
   -- It's useful to build up a list of messages for known return codes
   -- so that problems are easier to debug. This doesn't need to be done.
   local exitCodes = {
      [0]  = "Ran successfully: \r\n" .. cmd,
      [1]  = "Ran with error(s): \r\n" .. cmd,
      [12] = "Command is too long: \r\n" .. cmd,
      [99] = "etc."
   }
   local exitCode = os.execute(cmd)
   if exitCode ~= 0 then
      -- If the exit status isn't 0 this should indicate the execution
      -- wasn't a complete success. We'll return the pre-defined error
      -- message for this exit status or a generic one.
      return false, exitCodes[exitCode]
        or "Failed with exit code "..exitCode..":\r\n"..cmd
   else
      return true, exitCodes[exitCode]
   end
end

function ExecuteWithOutput(Command)
   local P = io.popen(Command,'r') -- First we open the command
   local Output =  P:read('*a')-- and then we read the output
   P:close()
   return Output
end