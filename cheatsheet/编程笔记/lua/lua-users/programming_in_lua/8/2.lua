
function mutiload(...)
	local t= {...}
	local i=1
	return load(function()
		c=t[i]
		while c ~= nil do
			if type(c)=="string" then
				i=i+1
				return c
			end
			if type(c)=="function" then
				local r = c()
				if r ~= nil then return r end
				i=i+1

			end
			c=t[i]
		end
		return nil
	end)
end
f = mutiload("local i=1;",io.lines("/Users/fxl/Documents/workspace/programming_in_lua/8/test.lua","*L")," ;print(i)")
f()
