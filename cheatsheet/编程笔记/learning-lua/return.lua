function add(x, y)
    return x + y
--    print("add: I will return the result " .. (x + y)) --因为前面有个return，若不注释该语句，则会报错
end

function is_positive(x)
    if x > 0 then
        return x .. " is positive"
    else
        return x .. " is non-positive"
    end
    print("function end!") --由于return只出现在前面显式的语句块，所以此语句不注释也不会报错，但是不会被执行，此处不会产生输出
end

sum = add(10, 20)
print("The sum is " .. sum) -->output:The sum is 30
answer = is_positive(-10)
print(answer) -->output:-10 is non-positive