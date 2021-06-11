module(..., package.seeall) --使用module函数定义模块很不安全。如何定义和使用模块请查看模块章节

--两个number型变量相加
local function add(a, b)
    return a + b
end

--更新变量值
function update_A()
    A = 365
end

--防止foo模块更改全局变量
getmetatable(foo).__newindex = function(table, key, val)
    error('attempt to write to undeclared variable "' .. key .. '": ' .. debug.traceback())
end