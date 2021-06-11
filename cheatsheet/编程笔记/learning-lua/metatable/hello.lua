print(getmetatable("lua"))
print(getmetatable(10))

-- 缺省情况下，table在创建时没有元表
t = {}
print(getmetatable(t))  --输出为nil

-- 使用setmetatable函数来设置或修改任何table的元表
t1 = {}
setmetatable(t,t1)
assert(getmetatable(t) == t1)
