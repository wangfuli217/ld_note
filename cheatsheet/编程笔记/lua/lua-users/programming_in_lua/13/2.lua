local Set = {}

function Set.new(l)
	local metatable = {
		__len = function(t)
			local i=0
			for _,_ in pairs(t) do
				i=i+1
			end
			return i
		end
	}
	setmetatable(l,metatable)
	return l
end
local a = Set.new({a="a",b="b",c=1})
print(#a)
