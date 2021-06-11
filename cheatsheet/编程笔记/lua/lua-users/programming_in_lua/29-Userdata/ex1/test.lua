--
-- Created by IntelliJ IDEA.
-- User: fxl
-- Date: 17/2/12
-- Time: 上午12:21
-- To change this template use File | Settings | File Templates.
--

local array = require"array"
local a = array.new(64)
array.set(a,2,true)
print(tostring(array.get(a,1)))
print(tostring(array.get(a,2)))
