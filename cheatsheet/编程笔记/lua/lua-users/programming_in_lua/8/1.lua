function loadwithprefix(prefix,cf)
	if type(cf) == "string" then
		local i = 0
		return load(function()
			i=i+1
			if i == 1 then return prefix end
			if i == 2 then return cf end
			return nil
		end)
	end

	if type(cf) == "function" then
		local i = 0
		return load(function()
			i=i+1
			if i==1 then return prefix end
			return cf()
		end)
	end
end

f=loadwithprefix("return ","{a=0}")
local r = f()
print(r.a)
f=loadwithprefix("return ",io.lines("/Users/fxl/Documents/workspace/programming_in_lua/8/test.lua","*L"))
r=f()
print(r.a)
