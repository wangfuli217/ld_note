> mymodule = require "mymodule"
> mymodule.foo()
Hello World!

-- reload mymodule

> package.loaded.mymodule = nil 
> mymodule = require "mymodule" 
>
> mymodule.foo() 
Hello Module!

--  _G.m
> m = require "mymodule"
> print(_G.m)
table: 0x1381390
> for k,v in pairs(_G.m) do
>> print(k,v)
>> end
foo     function: 0x13815d0

-- package.loaded
> for k,v in pairs(package.loaded) do
>> print(k,v)
>> end
string  table: 0x21942e0
debug   table: 0x2199600
package table: 0x2194b50
_G      table: 0x21926b0
io      table: 0x2196720
os      table: 0x2197100
table   table: 0x21947a0
math    table: 0x2198530
coroutine       table: 0x2194600
mymodule        table: 0x21b8390
