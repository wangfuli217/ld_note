__metatable
如果想保护一个元表不被程序修改，可以使用 __metatable 键

    wiki 上简短的一两句话还没有示例，有点让人摸不着头脑，我一开始以为是说一个表设置了 __metatable 之后，
就不能被设置为其他表的元表了，测试后发现不对，看了这篇Lua中的metatable详解的内容后才明白。

local mt = {__metatable = "error"}
local t = setmetatable({}, mt)
print(getmetatable(t)) --error
setmetatable(t,{}) --stdin:1: cannot change a protected metatable

原来是一个已经被设置为元表的表，设置这个键后就不允许通过 getmetatable() 获取，从而不允许被修改，反例：

local mt = {test=1}
local t = setmetatable({}, mt)
local mt2 = getmetatable(t)
print(mt.test,mt2.test) --1 1

-- 修改元表中的数据
mt2.test = 2
print(mt.test,mt2.test) --2 2