-- 变量系数
param =
{
    a = 2;
    b = 1;
}

-- 全局变量，满足c=2a+b，在c语言中实现
c = 100;

-- f(x) = ax + b
function lua_func(x)
    return (param.a * x * x + param.b * x + c)
end
