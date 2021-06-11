module("hello.mytest", package.seeall)
local function test() print(123) end
function test1() test() end 
function test2() test1(); test1() end
