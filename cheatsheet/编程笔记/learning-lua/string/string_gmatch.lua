s = "hello world from Lua"
--匹配最长连续且只含字母的字符串
for w in string.gmatch(s, "%a+") do
    print(w)
end

t = {}
s = "from=world, to=Lua"
--匹配两个最长连续且只含字母的字符串，它们之间用等号连接
for k, v in string.gmatch(s, "(%a+)=(%a+)") do
    t[k] = v
end

for k, v in pairs(t) do
    print(k, v)
end
