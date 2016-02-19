-- This example shows running command line programs on
-- POSIX style operating systems like OS X, Linux and Unix

function main()
   local cmd = [[ls -lh | grep iguana]]
   -- When executing a binary with 
   -- os.execute we won't see the output
   -- that the binary generates, but we
   -- can see the exit status of the command.
   local success, message = execute(cmd)
   trace(success, message)
   
   -- If we want to see the output a 
   -- executable generates we can use
   -- io.popen instead.
   local out = executeWithOutput(cmd)
   trace(out)
end

function execute(cmd)
   -- It's useful to build up a list of messages for known return codes
   -- so that problems are easier to debug. This doesn't need to be done.
   local exitCodes = {
      [0]     = "Ran successfully: \r\n"..cmd,
      [1]     = "Ran with error(s): \r\n"..cmd,
      [126]   = "Not executable or we don't have permission to execute it: \r\n"..cmd,
      [127]   = "Command can not be found: \r\n"..cmd,
      [256]   = "Command ran with error(s): \r\n"..cmd,
      [32256] = "Command is not executable or we don't have permission to execute it: \r\n"..cmd,
      [32512] = "Command can not be found: \r\n"..cmd,
      [99999] = "etc."
   }
   local exitCode = os.execute(cmd)
   
   if exitCode ~= 0 then
      -- If the exit status isn't 0 this should indicate the execution
      -- wasn't a complete success. We'll return the pre-defined error
      -- message for this exit status or a generic one.
      return false, exitCodes[exitCode] or
      "Command ran unsuccessfully and returned exit code "..exitCode..":\r\n"..cmd
   else
      return true, exitCodes[exitCode]
   end
end

function executeWithOutput(cmd)
   local P = io.popen(cmd,'r') -- First we open the command
   local Output = P:read('*a') -- and then we read the output
   P:close()
   return Output
end