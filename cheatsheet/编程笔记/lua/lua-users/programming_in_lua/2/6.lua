a={}
a.a=a
print(a.a.a.a)
--[[
 a={
   a = a
 }
]]
a.a.a.a=3
print(a.a)
