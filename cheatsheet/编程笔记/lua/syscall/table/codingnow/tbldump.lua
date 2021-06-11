-- 调试 lua 程序的时候往往想以树的形式打印出一个 table ，下面这个 print_r 函数可以满足要求。

local print = print
local tconcat = table.concat
local tinsert = table.insert
local srep = string.rep
local type = type
local pairs = pairs
local tostring = tostring
local next = next
 
function print_r(root)
	local cache = {  [root] = "." }
	local function _dump(t,space,name)
		local temp = {}
		for k,v in pairs(t) do
			local key = tostring(k)
			if cache[v] then
				tinsert(temp,"+" .. key .. " {" .. cache[v].."}")
			elseif type(v) == "table" then
				local new_key = name .. "." .. key
				cache[v] = new_key
				tinsert(temp,"+" .. key .. _dump(v,space .. (next(t,k) and "|" or " " ).. srep(" ",#key),new_key))
			else
				tinsert(temp,"+" .. key .. " [" .. tostring(v).."]")
			end
		end
		return tconcat(temp,"\n"..space)
	end
	print(_dump(root, "",""))
end



a = {}
 
a.a = { 
	hello = { 
		alpha = 1 ,
		beta = 2,
	},
	world =  {
		foo = "ooxx",
		bar = "haha",
		root = a,
	},
}
a.b = { 
	test = a.a 
}
a.c = a.a.hello
 
print_r(a)



-- 输出：

+a+hello+alpha [1]
| |     +beta [2]
| +world+root {.}
|       +bar [haha]
|       +foo [ooxx]
+c {.a.hello}
+b+test {.a}