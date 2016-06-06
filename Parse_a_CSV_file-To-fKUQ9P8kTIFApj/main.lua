-- This example shows parsing of a CSV file.

-- http://help.interfaceware.com/v6/csv-parser

local parseCsv = require 'csv'

function main(Data)
   local Csv = parseCsv(Data)         -- comma separated (default)
   --local Csv = parseCsv(Data, '\t') -- tab separated (sample message 11)
   --local Csv = parseCsv(Data, '|')  -- bar separated (sample message 12)
   trace(Csv)
   trace('Count of rows = '..#Csv)
   
--[[ Examples of what you can do:
   
    1) Use in a To Translator and add code
       for saving patients to a database
   
    2) Use in a Filter Component and map to
       XML/JSON then queue for further processing
   ]]
end