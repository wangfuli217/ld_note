# /usr/bin/env lua

function foo (a)
    print("foo 函数输出", a)
    return coroutine.yield(2 * a)
end

co = coroutine.create(function (a , b)
    print("第一次协同程序执行输出", a, b)
    local r = foo(a + 1)

    print("第二次协同程序执行输出", r)
    local r, s = coroutine.yield(a + b, a - b)

    print("第三次协同程序执行输出", r, s)
    return b, "结束协同程序"
end)

print("main", coroutine.resume(co, 1, 10))
print("---分割线----")
print("main", coroutine.resume(co, "r"))
print("---分割线---")
print("main", coroutine.resume(co, "x", "y"))
print("---分割线---")
print("main", coroutine.resume(co, "x", "y"))
print("---分割线---")