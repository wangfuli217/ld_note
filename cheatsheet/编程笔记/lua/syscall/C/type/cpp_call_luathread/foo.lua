function Func2(value)

print("Func2 begin.")

   coroutine.yield(5, value + 10,value+20,value+30)

    print("Func2 ended.")
end


function Func1(param1)
    print("Func1 begin")
    Func2(param1 + 10) 
    print("Func1 ended.")
    return 100,"game over"
end