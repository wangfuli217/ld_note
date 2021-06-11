a = os.clock()
local sin = math.sin
for i = 1,10000000 do
  local x = sin(i)
end
b = os.clock()
print(b-a) --0.75951