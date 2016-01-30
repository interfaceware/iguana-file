-- This module shows how we can securely store a password in a configuration file
-- outside of the Lua source code of a translator instance.
config = require 'encrypt.password'

-- The code uses AES encryption https://en.wikipedia.org/wiki/Advanced_Encryption_Standard

-- In production it makes sense to call the module outside of the main function to avoid
-- the overhead of loading a file everytime a message is processed.
local Password = config.load{config='appxyz.xml', key='KJHASkj233j3d'}

function main(Data)
   local WorkingDir = iguana.workingDir()
   trace('The config file is saved in the directory '..WorkingDir)
   local Password = config.load{config='appxyz.xml', key='KJHASkj233j3d'}
   
   -- This line is what can be used to save the password in the config file
   -- It executes inside the editor.  You have to be careful not to commit it to a
   -- a script with the real file name.
   --config.save{config='appxyz.xml', password='my password', key='KJHASkj233j3d'}
end