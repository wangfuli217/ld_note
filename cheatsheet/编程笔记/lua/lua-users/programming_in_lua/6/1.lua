function integral(f,a,b)
    local s = a
    local t = 0
    while s<b do
        t=t+f(s)*0.01
        s=s+0.01
    end
    return t
end

function linear(x)
    return x
end
print(integral(linear,0,1))
