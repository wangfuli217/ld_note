require "template"
 
compile [[
function test(t)
	for _,v in ipairs(|{"one","two","three"}|) do
		print(v,t[v])
	end
end
]]
 
compile [[
|ALPHA=2*math.pi|
function test2()
	return |ALPHA|
end
]]
 
print(test({one=1,two=2,three=3}))
print(test2)