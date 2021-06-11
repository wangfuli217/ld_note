function polynomial_value(polynomial,x)
    local c = #polynomial
    local t = 0
    for i=1,c-1 do
        t =  ( t + polynomial[i] ) * x
    end
    t=t+polynomial[c]
	return t
end

function newpoly(polynomial)
    return function(x)
        return polynomial_value(polynomial,x)
    end
end
local f = newpoly({3,0,1})
print(f(10))
