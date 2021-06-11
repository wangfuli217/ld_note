A = 360 --定义全局变量
local foo = require("foo") --使用模块foo，如何定义和使用模块请查看模块章节

local b = foo.add(A, A)
print("b = ", b)

foo.update_A()
print("A = ", A)