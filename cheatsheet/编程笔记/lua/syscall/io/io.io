--[[ 简单模型 完整模型
Lua的标准I/O库提供了三个预定义的C stream句柄:io.stdin,io.stdout,io.stderr.
可以使用如下方式给error stream发送错误信息:
  io.stderr:write(message)

简单模型所有操作都有表io.提供。
完整模型所有操作都有file描述符提供。file描述符通过io.open函数获得。
1. 简单模型： io.input(filename)  io.output(filename) io.lines(filename)
  与io.stdin,io.stdout,io.stderr是相互独立的，io.input,io.output和io.lines是io表提供的方法

local temp = io.input()          --得到当前的输入文件
io.input("new")                  --设置新的输入文件
... ...                          -- read process
io.input():close()               --关闭当前的输入文件
io.input(temp)                   --还原之前的输入文件
  
2. 完整模型   io.open 模式字符串可以是 "r"(读模式)，"w"(写模式，对数据进行覆盖)，或者是 "a"(附加模式)
                字符 "b" 可附加在后面表示以二进制形式打开文件
              如果发生错误，则返回nil，以及一个错误信息和错误代码。错误代码的定义由系统决定。

   完整模型 是为了在I/O操作时能提供更多的控制方法
   完整模型 核心概念是——文件句柄；代表着当前打开的文件及当前读取的位置

    Lua处理二进制文件类似于处理普通的文本文件，lua中的字符串可以存入任何字节，而标准库中
几乎所有的函数都可以处理二进制字节。也可以使用二进制数据进行模式匹配，当然此时需要使用字符类:%z.
    可以使用'*a"，读取整个二进制文件，也可以使用n读取n个字节。
    
file:op(): 函数调用出错情况下，都返回nil和错误描述字符串。
注意:  io.input和io.output 在出错的情况下，函数抛出错误而不是返回错误码。 
     而io.open 在出错的情况下，返回nil 和 错误描述符字符串
--]]

--[=[
                                               |-- file:setvbuf (mode [, size])
                                               |-- file:seek ([whence [, offset]])
   |-- write   function                        |-- file:write (···)
   |-- read    function                        |-- file:read (···)
   |-- close   io.close ([file])               |-- file:close ()
   |-- flush   function                        |-- file:flush ()
   |-- open    function  -- file对象-------|---|
   |-- lines   function  -- 简单IO        /|\  |-- file:lines (···)
   |-- output  function  -- 简单IO         |
io-|-- input   function  -- 简单IO         |
   |-- stderr  file      -- 标准错误输出-| |
   |-- stdin   file      -- 标准输入-----|-|
   |-- stdout  file      -- 标准输出-----|
   |-- type    function
   |-- popen   function
   |-- tmpfile function
   
io.write, io.close, io.flush依赖于io.output先调用 -> io.output():write(···)
io.read,  io.close依赖于io.input先调用            -> io.input():read(...)
io.stderr:write         从标准错误输出，默认打开
io.stdout:write  print  从标准输出输出，默认打开
io.stdin:read           从标准输入输入，默认打开
--]=]



--[[ 移动读写点
  文件模型会保存当前读写的字符位置.随着read或者write的调用,这个读写点会自动移动.
如果要重新读取某一段内容或者覆盖某一段已经存在的内容,就需要移动读写点.
  移动读写点使用函数seek(同样需要从文件模型调用,并且把文件模型本身作为第一个参数传入).

  
--]]
-- lua prog.lua file.dos file.unix
--[[  prog.lua
local inp = assert(io.open(arg[1],"rb"))
local out = assert(io.open(arg[2],"wb"))
local data = inp:read("*a")
data = string.gsub(data,"\r\n","\n")
out:write(data)
assert(out:close())
--]]

--[[  从二进制文件中读取到的数据打印出来：
local f = assert(io.open(arg[1],"rb"))
local data = f:read("*a")
local validchars = "[%w%p%s]"
local pattern = string.rep(validchars, 6) .. "+%z"
for w in string.gmatch(data,pattern) do
     print(w)
end 
--]]

--[[ hexdump
local f = assert(io.open(arg[1], "rb"))
local block = 10
while true do
  local bytes = f:read(block)
  if not bytes then break end
  for b in string.gmatch(bytes, ".") do
    io.write(string.format("%02X ", string.byte(b)))
  end
  io.write(string.rep("   ", block - string.len(bytes) + 1))
  io.write(string.gsub(bytes, "%c", "."), "\n")
end
--]]

--[[ wc 命令
local BUFSIZE = 2^13     -- 8K
local f = io.input(arg[1])   -- open input file
local cc, lc, wc = 0, 0, 0   -- char, line, and word counts
while true do
  local lines, rest = f:read(BUFSIZE, "*line")
  if not lines then break end
  if rest then lines = lines .. rest .. '\n' end
  cc = cc + string.len(lines)
  -- count words in the chunk
  local _,t = string.gsub(lines, "%S+", "")
  wc = wc + t
  -- count newlines in the chunk
  _,t = string.gsub(lines, "\n", "\n")
  lc = lc + t
end
print(lc, wc, cc)
--]] 


-- Find the length of a file
--   filename: file name
-- returns
--   len: length of file
--   asserts on error
function length_of_file(filename)
  local fh = assert(io.open(filename, "rb"))
  local len = assert(fh:seek("end"))
  fh:close()
  return len
end

-- Return true if file exists and is readable.
function file_exists(path)
  local file = io.open(path, "rb")
  if file then file:close() end
  return file ~= nil
end

-- Guarded seek.
-- Same as file:seek except throws string
-- on error.
-- Requires Lua 5.1.
function seek(fh, ...)
  assert(fh:seek(...))
end

-- Read an entire file.
function readall(filename)
  local fh = assert(io.open(filename, "rb"))
  local contents = assert(fh:read("a")) -- "a" in Lua 5.3; "*a" in Lua 5.1 and 5.2
  fh:close()
  return contents
end

-- Write a string to a file.
function write(filename, contents)
  local fh = assert(io.open(filename, "wb"))
  fh:write(contents)
  fh:flush()
  fh:close()
end

-- Read, process file contents, write.
function modify(filename, modify_func)
  local contents = readall(filename)
  contents = modify_func(contents)
  write(filename, contents)
end