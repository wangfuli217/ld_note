-- http://lua-users.org/wiki/ControlStructureTutorial

--[[
for variable = start, stop, step do 
  block 
end
]]
for i = 1, 5 do print(i) end

for i = 1, 100, 8 do print(i) end

for i = 3, -3, -1 do print(i) end

for i = 0, 1, 0.25 do print(i) end

for i = 1, 3 do for j = 1, i do print(j) end end

--[[
for var1, var2, var3 in iterator do 
  block 
end
]]
tbl = {"a", "b", "c"}
for key, value in ipairs(tbl) do
  print(key, value)
end