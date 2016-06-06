-- Simple module to convert RTF file into text.

-- http://help.interfaceware.com/v6/rtf-conversion-example

local rtfToText = require 'rtf'

function main()
   -- Read the sample.rtf file which is part of this translator into Content string var
   local FileName = iguana.project.root()..'/'..iguana.project.guid()..'/sample.rtf'
   local F = io.open(FileName,'r')
   local Content = F:read('*a')
   F:close()
   
   -- Now convert the content into plain text.
   local Text = rtfToText(Content)
   trace(Text)
   -- Of course formatting is lost...
end