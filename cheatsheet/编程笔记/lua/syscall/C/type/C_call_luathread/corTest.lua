function CorTest()
    print("coroutine begin")
    ---100,hello c++两个参数返回栈
    local re = coroutine.yield(100, "hello c++")  
    ---re是lua_resume的参数
    print("coroutine continue: " .. re) 
    Stop("call c yield!")  
    print("coroutine continue after yield")
    print("coroutine end")
end