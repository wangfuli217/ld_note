local t  = {}
local _t = {}
local mt = {
	__index = function(t,k)
		print("*access to the k = "..k)
		return _t[k]
	end,
	__newindex = function(t,k,v)
		print("*update to the k = "..k)
		_t[k]=v
	end,
	__pairs = function()
		return function(_,k)
			return next(_t,k)
		end
	end,
	__ipairs= function()
		return function(_,i)
			return next(_t,i)
		end
	end
}
setmetatable(t,mt)
t.a="a"
t.b="b"
for k,v in pairs(t) do
	print("v="..v)
end
t[1]=1
t[2]=2
for _,v in ipairs(t) do
	print("v="..v)
end
