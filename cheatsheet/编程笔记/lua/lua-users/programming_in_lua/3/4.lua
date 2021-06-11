function polynomial_value(polynomial,x)

	local c = #polynomial
	t = 1 + polynomial[c]*x
	for i=c-1,2,-1 do
		t = t * x + polynomial[i]
	end
	t=t + polynomial[1]
	return t
end
print(polynomial_value({1,2,3},2))
