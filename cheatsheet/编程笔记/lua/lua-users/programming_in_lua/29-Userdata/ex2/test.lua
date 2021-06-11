--
-- Created by IntelliJ IDEA.
-- User: xinlei.fan
-- Date: 17/2/13
-- Time: 涓婂崍11:25
-- To change this template use File | Settings | File Templates.
--

local array = require("array")
local a1 = array.new(32)
array.set(a1,2,true)

local a2 = array.new(64)
array.set(a2,38,true)
array.set(a2,3,false)

local a = array.union(a1,a2)
print(array.size(a))
print(tostring(array.get(a,2)))
print(tostring(array.get(a,38)))

local ai = array.inter(a1,a2)
print(array.get(ai,2))
print(array.get(ai,3))
