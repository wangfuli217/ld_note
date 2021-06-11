--使用__metatable可以保护元表，禁止用户访问元表中的成员或者修改元表。
tA = {}
mt = {}
getmetatable(tA, mt)
mt.__metatable = "lock"
setmetatable(tA, mt)
print(getmetatable(tA)) -->lock
