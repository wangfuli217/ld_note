function polynomial_value(polynomial,x)
    local c = #polynomial
    local t = 0
    for i=1,c-1 do
        t =  ( t + polynomial[i] ) * x
    end
    t=t+polynomial[c]
	return t
end
print(polynomial_value({1,2,3},2))
