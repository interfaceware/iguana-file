-- Basic Streams: Strings, Files, Pipes and Sockets
--
-- Copyright (c) 2011-2016 iNTERFACEWARE Inc.

-- How much data to buffer between reads.
local buffer_size = 64*1024

-- Throw errors reported by io.open().
local function open(path, mode)
   local file, err = io.open(path, mode)
   if not file then
      error(err, 3)
   end
   return file
end

-- Throw errors reported by io.popen().
local function popen(cmd, mode)
   local file, err = io.popen(cmd, mode)
   if not file then
      error(err, 3)
   end
   return file
end

-- Stream from some open file (see fromFile, fromPipe).
local function fromFile(file)
   return function()
      local out
      if file then
         out = file:read(buffer_size)
         if not out then
            file:close()
            file = nil
         end
      end
      return out
   end
end

-- Stream to some open file (see toFile, toPipe).
local function toFile(file, from, ...)
   local chunk
   repeat
      chunk = from(...)
      if chunk then
         file:write(chunk)
      end
   until not chunk
   file:close()
end

--
-- Public API
--

local stream = {}

-- stream.fromString(s)
--
-- Create a stream from a string.
--   's' - the string
--
-- e.g. stream.toFile('out.txt', stream.fromString(Data))
--
function stream.fromString(s)
   return function()
      local out
      if #s > 0 then
         out = s:sub(1,buffer_size)
         s = s:sub(buffer_size+1)
      end
      return out
   end
end

local Help = {
   Title="stream.fromString",
   Usage="stream.fromString(s)",
   ParameterTable=false,
   Parameters={
      {s={Desc="String to create the stream from <u>string</u>."}},
   },
   Returns={
      {Desc="A stream of string data <u>stream</u>."}
   },
   Examples={[[-- stream from a string to a file
stream.toFile('out.txt', stream.fromString(Data))]]},
   Desc="Create a stream from a string.",
   SeeAlso={
      {
         Title="Streaming File Operations",
         Link="http://help.interfaceware.com/v6/streaming-file-operations"
      },
      {
         Title="Source code for the stream.lua module on github",
         Link="https://github.com/interfaceware/iguana-file/blob/master/shared/stream.lua"
      }
   },
}

help.set{input_function=stream.fromString, help_data=Help}


-- stream.toString(from, ...)
--
-- Write a stream to a string.
--   'from(...)' - the stream to read from
--
-- e.g. local s = stream.toString(stream.fromFile('in.txt'))
--
function stream.toString(from, ...)
   local out, chunk = {}, nil
   repeat
      chunk = from(...)
      if chunk then
         out[#out+1] = chunk
      end
   until not chunk
   return table.concat(out)
end

local Help = {
   Title="stream.toString",
   Usage="stream.toString(from, ...)",
   ParameterTable=false,
   Parameters={
      {from={Desc="A function that returns a stream <u>function</u>."}},
      {["..."]={Desc='Parameters for the function "from" <u>any type</u>.'}},
   },
   Returns={
      {Desc="A string created from the stream <u>string</u>."}
   },
   Examples={[[-- create a string from stream
local s = stream.toString(stream.fromFile('in.txt'))]]},
   Desc="Write a stream to a string, from another stream.",
   SeeAlso={
      {
         Title="Streaming File Operations",
         Link="http://help.interfaceware.com/v6/streaming-file-operations"
      },
      {
         Title="Source code for the stream.lua module on github",
         Link="https://github.com/interfaceware/iguana-file/blob/master/shared/stream.lua"
      }
   },
}

help.set{input_function=stream.toString, help_data=Help}

-- stream.fromFile(path [,mode])
--
-- Create a stream from a file.
--   'path' - the path of the file
--   'mode' - the mode to use (defaults to 'rb')
--
-- e.g. local s = stream.toString(stream.fromFile('in.txt'))
--
function stream.fromFile(path, mode)
   local file = open(path, mode or 'rb')
   return fromFile(file)
end

local Help = {
   Title="stream.fromFile",
   Usage="stream.fromFile(path, mode)",
   ParameterTable=false,
   Parameters={
      {path={Desc="Path name for the file to stream from <u>string</u>."}},
      {mode={Desc="Mode to open the file (default = 'rb') <u>string</u>.", Opt = true}},
   },
   Returns={
      {Desc="Stream created from the file <u>stream</u>."}
   },
   Examples={[[-- create a stream from a file
local s = stream.toString(stream.fromFile('in.txt'))]]},
   Desc="Create a stream from a file.",
   SeeAlso={
      {
         Title="Streaming File Operations",
         Link="http://help.interfaceware.com/v6/streaming-file-operations"
      },
      {
         Title="Source code for the stream.lua module on github",
         Link="https://github.com/interfaceware/iguana-file/blob/master/shared/stream.lua"
      }
   },
}

help.set{input_function=stream.fromFile, help_data=Help}


-- stream.toFile(path, from, ...)
-- stream.toFile(path, mode, from, ...)
--
-- Write a stream to a file.
--   'path'      - the path of the file
--   'mode'      - the mode to use (defaults to 'wb')
--   'from(...)' - the stream to read from
--
-- e.g. stream.toFile('out.txt', stream.fromString(Data))
--
function stream.toFile(path, mode, from, ...)
   if type(mode) == 'function' then
      return stream.toFile(path, 'wb', mode, from, ...)
   end
   local file = open(path, mode)
   return toFile(file, from, ...)
end

local Help = {
   Title="stream.toFile",
   Usage="stream.toFile(path, mode, from, ...)",
   ParameterTable=false,
   Parameters={
      {path={Desc="The path of the file <u>string</u>."}},
      {mode={Desc="The mode to use for the file (default = 'wb') <u>string</u>.",Opt = true}},
      {from={Desc="A function that returns a stream <u>function</u>."}},
      {["..."]={Desc='Parameters for the function "from" <u>any type</u>.'}},
   },
   Returns={},
   Examples={[[-- Write a stream to a file
stream.toFile('out.txt', stream.fromString(Data))]]},
   Desc="Write a stream to a file, from another stream.",
   SeeAlso={
      {
         Title="Streaming File Operations",
         Link="http://help.interfaceware.com/v6/streaming-file-operations"
      },
      {
         Title="Source code for the stream.lua module on github",
         Link="https://github.com/interfaceware/iguana-file/blob/master/shared/stream.lua"
      }
   },
}

help.set{input_function=stream.toFile, help_data=Help}


-- stream.fromPipe(cmd)
--
-- Create a stream from an external process.
--   'cmd' - the command to run and read from
--
-- e.g. local s = stream.toString(stream.fromPipe('ls -1'))
--
function stream.fromPipe(cmd)
   local file = popen(cmd, 'r')
   return fromFile(file)
end

local Help = {
   Title="stream.fromPipe",
   Usage="stream.fromPipe(cmd)",
   ParameterTable=false,
   Parameters={
      {cmd={Desc="The command to run and read data from <u>string</u>."}},
   },
   Returns={
      {Desc="Stream created from the pipe <u>stream</u>."}
   },
   Examples={[[-- create a string from a pipe
local s = stream.toString(stream.fromPipe('ls -1'))]]},
   Desc="Create a stream from an external process (pipe).",
   SeeAlso={
      {
         Title="Streaming File Operations",
         Link="http://help.interfaceware.com/v6/streaming-file-operations"
      },
      {
         Title="Source code for the stream.lua module on github",
         Link="https://github.com/interfaceware/iguana-file/blob/master/shared/stream.lua"
      }
   },
}

help.set{input_function=stream.fromPipe, help_data=Help}


-- stream.toPipe(cmd, from, ...)
--
-- Write a stream to an external process.
--   'cmd'       - the command to run and write to
--   'from(...)' - the stream to read from
--
-- e.g. stream.toPipe('openssl des -out out.tmp -k '..Key,
--                    stream.fromString(Data))
--
function stream.toPipe(cmd, from, ...)
   local file = popen(cmd, 'w')
   return toFile(file, from, ...)
end

local Help = {
   Title="stream.toPipe",
   Usage="stream.toPipe(cmd, from, ...)",
   ParameterTable=false,
   Parameters={
      {cmd={Desc="The command to run and write data to <u>string</u>."}},
      {from={Desc="A function that returns a stream <u>function</u>."}},
      {["..."]={Desc='Parameters for the function "from" <u>any type</u>.'}},
   },
   Returns={},
   Examples={[[-- stream to a pipe from a string
stream.toPipe('openssl des -out out.tmp -k '..Key,
                    stream.fromString(Data))]]},
   Desc="Write a stream to an external process (pipe), from another stream.",
   SeeAlso={
      {
         Title="Streaming File Operations",
         Link="http://help.interfaceware.com/v6/streaming-file-operations"
      },
      {
         Title="Source code for the stream.lua module on github",
         Link="https://github.com/interfaceware/iguana-file/blob/master/shared/stream.lua"
      }
   },
}

help.set{input_function=stream.toPipe, help_data=Help}

-- stream.fromSocket(sock)
--
-- Create a stream from a TCP/IP connection.
--   'sock' - the connection to read from
--
-- e.g. local s = net.tcp.connect{...}
--      stream.toFile('big.hl7', stream.fromSocket(s))
--
function stream.fromSocket(sock)
   return function()
      return sock:recv()
   end
end

local Help = {
   Title="stream.fromSocket",
   Usage="stream.fromSocket(sock)",
   ParameterTable=false,
   Parameters={
      {sock={Desc="TCP/IP socket connection <u>socket</u>."}},
   },
   Returns={
      {Desc="Stream created from the socket <u>stream</u>."}
   },
   Examples={[[-- create a stream from a socket and send it to a file
local s = net.tcp.connect{...}
      stream.toFile('big.hl7', stream.fromSocket(s))]]},
   Desc="Create a stream from a TCP/IP connection (socket).",
   SeeAlso={
      {
         Title="Streaming File Operations",
         Link="http://help.interfaceware.com/v6/streaming-file-operations"
      },
      {
         Title="Source code for the stream.lua module on github",
         Link="https://github.com/interfaceware/iguana-file/blob/master/shared/stream.lua"
      }
   },
}

help.set{input_function=stream.fromSocket, help_data=Help}

-- stream.toSocket(sock, from, ...)
--
-- Write a stream to a TCP/IP connection.
--   'sock'      - the connection to write to
--   'from(...)' - the stream to read from
--
-- e.g. local s = net.tcp.connect{...}
--      stream.toSocket(s, stream.fromFile('big.hl7'))
--
function stream.toSocket(sock, from, ...)
   while true do
      local chunk = from(...)
      if not chunk then break end
      sock:send(chunk)
   end
end

local Help = {
   Title="stream.toSocket",
   Usage="stream.toSocket(sock, from, ...)",
   ParameterTable=false,
   Parameters={
      {sock={Desc="TCP/IP socket connection <u>socket</u>."}},
      {from={Desc="A function that returns a stream <u>function</u>."}},
      {["..."]={Desc='Parameters for the function "from" <u>any type</u>.'}},
   },
   Returns={},
   Examples={[[-- create an empty schema
local s = net.tcp.connect{...}
      stream.toSocket(s, stream.fromFile('big.hl7'))]]},
   Desc="Write a stream to a TCP/IP connection (socket), from another stream.",
   SeeAlso={
      {
         Title="Streaming File Operations",
         Link="http://help.interfaceware.com/v6/streaming-file-operations"
      },
      {
         Title="Source code for the stream.lua module on github",
         Link="https://github.com/interfaceware/iguana-file/blob/master/shared/stream.lua"
      }
   },
}

help.set{input_function=stream.toSocket, help_data=Help}

-- stream.filter(from, f)
--
-- Create a stream by attaching a filter to another stream.
--   'from' - the stream to read from
--   'f'    - the filter function
--
-- The filter (f) is called with each chunk (or nil) read
-- from the stream (from) and must return chunks (or nil)
-- to be sent downstream.
--
-- e.g. local Out = stream.toString(
--         stream.filter(stream.fromString(Data),
--             function(s)
--                return s and s:upper()
--             end))
--      assert(Out == Data:upper())
--
function stream.filter(from, f)
   return function(...)
      local out = from(...)
      return f(out, ...)
   end
end

local Help = {
   Title="stream.filter",
   Usage="stream.filter(from, f)",
   ParameterTable=false,
   Parameters={
      {from={Desc="A function that returns a stream <u>function</u>."}},
      {f={Desc="A function used to filter the stream <u>function</u>."}},
   },
   Returns={
      {Desc="Stream created from the filtered stream <u>stream</u>."}
   },
   Examples={[[-- filter a stream and output to string
local Out = stream.toString(
         stream.filter(stream.fromString(Data),
             function(s)
                return s and s:upper()
             end))
      assert(Out == Data:upper())]]},
   Desc="Create a stream by filtering another stream.",
   SeeAlso={
      {
         Title="Streaming File Operations",
         Link="http://help.interfaceware.com/v6/streaming-file-operations"
      },
      {
         Title="Source code for the stream.lua module on github",
         Link="https://github.com/interfaceware/iguana-file/blob/master/shared/stream.lua"
      }
   },
}

help.set{input_function=stream.filter, help_data=Help}

return stream