-- This module shows how we can securely store a password in a configuration file.
-- This is much more secure than storing a password (as plain text) in the Lua 
-- source code of a Translator instance.

-- The code uses AES encryption https://en.wikipedia.org/wiki/Advanced_Encryption_Standard

-- http://help.interfaceware.com/v6/encrypt-password-in-file

local config = require 'encrypt.password'

-- In production it makes sense to call the module outside of the main function to avoid
-- the overhead of loading a file everytime a message is processed.
local Password = config.load{config='appxyz.xml', key='KJHASkj233j3d'}

function main(Data)
	-- Test code that only needs to run in the editor
   if iguana.isTest() then
      local WorkingDir = iguana.workingDir()
      trace('The config file is saved in the directory '..WorkingDir)
      local Password = config.load{config='appxyz.xml', key='KJHASkj233j3d'}
      trace(Password)
   end
   
   -- Use this code to save the encrypted password to the configuration file.
   -- 1) Execute this code *once* inside the editor to encrypt the password
   --    Run it again (*once* inside the editor) whenever the password changes
   -- 2) Comment out the line of code then replace the real password with a fake one
   --    If don't comment the line first then the fake password will be encrypted
   -- 3) Check the config.load{} is returning the correct password
   -- NOTE: Never save a commit that includes a real password
   --config.save{config='appxyz.xml', password='enter-password', key='KJHASkj233j3d'}
end