-- This example shows running command line programs on
-- POSIX style operating systems like OS X, Linux and Unix

-- Note that rather than using invoking ls, os.fs.glob is a better choice for reading
-- files from a directory within Lua translator code. See:
-- http://help.interfaceware.com/api/#os_fs_glob

function main()
   local Command = [[ls -lh | grep iguana]]
   -- When executing a binary with 
   -- os.execute we won't see the output
   -- that the binary generates, but we
   -- can see the exit status of the command.
   local Success, Message = execute(Command)
   trace(Success, Message)
   
   -- If we want to see the output a 
   -- executable generates we can use
   -- io.popen instead.
   local Out = executeWithOutput(Command)
   trace(Out)
   
   -- To get standard error as well
   -- as standard out redirect the output
   -- with the bit 2>&1 which means redirect
   -- stream 2 (error) to stream 1 (standard)
   Out = executeWithOutput('ls -Z 2>&1')
end

function execute(Command)
   -- It's useful to build up a list of messages for known return codes
   -- so that problems are easier to debug. This doesn't need to be done.
   local exitCodes = {
      [0]     = "Ran successfully: \r\n"..Command,
      [1]     = "Ran with error(s): \r\n"..Command,
      [126]   = "Not executable or we don't have permission to execute it: \r\n"..Command,
      [127]   = "Command can not be found: \r\n"..Command,
      [256]   = "Command ran with error(s): \r\n"..Command,
      [32256] = "Command is not executable or we don't have permission to execute it: \r\n"..Command,
      [32512] = "Command can not be found: \r\n"..Command,
      [99999] = "etc."
   }
   local exitCode = os.execute(Command)
   
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

function executeWithOutput(Command)
   local P = io.popen(Command,'r') -- First we open the command
   local Output = P:read('*a') -- and then we read the output
   P:close()
   return Output
end