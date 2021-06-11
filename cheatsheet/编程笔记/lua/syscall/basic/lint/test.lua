local y = 5
local function test(x)
  print("123",x,y,z)
end

local factorial
function factorial(n)
  return n == 1 and 1 or n * factorial(n-1)
end

g = function(w) return w*2 end

for k=1,2 do print(k) end

for k,v in pairs{1,2} do print(v) end

test(2)
print(g(2))