-- for variable = from_exp , to_exp [, step_exp] do block end

for i = 1,3 do print(i) end     -- count from 1 to 3
for i = 3,1 do print(i) end     -- count from 3 to 1 in steps of 1. zero iterations!
for i = 3,1,-1 do print(i) end  -- count down from 3 to 1
for i=1,0,-0.25 do print(i) end -- we're not limited to integers


-- for var {, var} in explist do block end
t = {3,7,10,17}
t["pi"] = 3.14159
t["banana"]="yellow"
-- pairs
for key,value in pairs(t) do print(key,value) end
-- ipairs
for index,value in ipairs(t) do print(index,value) end

-- next
print(next(t,nil))
print(next(t,4))

for key,value in next,t,nil do print(key,value) end

-- io.lines()
io.output(io.open("my.txt","w"))
io.write("This is\nsome sample text\nfor Lua.")
io.close()

for line in io.lines("my.txt") do print(line) end

-- file:lines()
file = assert(io.open("my.txt", "r"))
for line in file:lines() do print(line) end
file:close()

file = assert(io.open("list.txt", "r"))
local line = file:read()
if string.sub(line, 1, 1) ~= '#' then
  ProcessLine(line) -- File doesn't start with a comment, process the first line
end
-- We could also loop on the first lines, while they are comment
-- Process the remainder of the file
for line in file:lines() do
  ProcessLine(line)
end
file:close()



