> require "mymodule" 
> mymodule.foo() 
Hello World!

> print(mymodule)
table: 0xf4e2d0

> for k,v in pairs(mymodule) do
>> print(k,v)
>> end
foo     function: 0xf4e460
_M      table: 0xf4e2d0
_NAME   mymodule
_PACKAGE

> for k,v in pairs(mymodule._M) do 
>> print(k,v)
>> end
foo     function: 0xf4e460
_M      table: 0xf4e2d0
_NAME   mymodule
_PACKAGE

-- mymodule == mymodule._M == 0xf4e2d0
-- _G == getmetatable(mymodule).__index

> for k,v in pairs(getmetatable(mymodule).__index) do
>> print(k,v)
>> end
string  table: 0xf2a2e0
xpcall  function: 0xf299c0
package table: 0xf2ab50
tostring        function: 0xf298a0
print   function: 0xf29a40
os      table: 0xf2d100
unpack  function: 0xf29960
require function: 0xf2b360
getfenv function: 0xf29430
setmetatable    function: 0xf297e0
next    function: 0xf29600
assert  function: 0xf29310
tonumber        function: 0xf29840
io      table: 0xf2c720
rawequal        function: 0xf29aa0
collectgarbage  function: 0xf29370
getmetatable    function: 0xf296c0
module  function: 0xf2b300
rawset  function: 0xf29b60
mymodule        table: 0xf4e2d0
math    table: 0xf2e530
debug   table: 0xf2f600
pcall   function: 0xf29660
table   table: 0xf2a7a0
newproxy        function: 0xf2a560
type    function: 0xf29900
coroutine       table: 0xf2a600
_G      table: 0xf286b0
select  function: 0xf28700
gcinfo  function: 0xf293d0
pairs   function: 0xf290b0
rawget  function: 0xf29b00
loadstring      function: 0xf295a0
ipairs  function: 0xf29010
_VERSION        Lua 5.1
dofile  function: 0xf29480
setfenv function: 0xf29780
load    function: 0xf29540
error   function: 0xf294e0
loadfile        function: 0xf29720

-- The way it works is it creates a new table for the module, stores it in the
-- global named by the first argument to module, and sets it as the environment
-- for the chunk, so if you create a global variable, it gets stored in the
-- module table.

-- package.seeall gives the module a metatable with an __index that points to the
-- global table, so the module can now use global variables. The problem with
-- this is that the user of the module can now see global variables through the
-- module
