-- 定义一个全局函数
function print_func1(var)
    print("var1 = "..var)
end

-- 定义一个局部函数
local function print_func2(var)
    print("var2 = "..var)
end

-- 自定义函数体
local i = 100
i = i + 1
return i
