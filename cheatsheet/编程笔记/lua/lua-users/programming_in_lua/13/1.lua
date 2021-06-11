local Set = {}

function Set.new(l)
	local metatable = {
		__sub = function(a,b)
			local t = {}
			for k,v in pairs(a) do
				if b[k] == nil then
					t[k]=v
				end
			end
			return t
		end
	}
	setmetatable(l,metatable)
	return l
end
local a = Set.new({a="a",b="b",c=1})
local b = Set.new({c=1})
local c = a-b
for k,v in pairs(c) do
	print(k.."="..v)
end
