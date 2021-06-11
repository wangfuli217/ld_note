A = 2
require "mod1"

local com1 = mod1.new(0, 1)
local com2 = mod1.new(1, 2)

--mod1.update()
print(A)

local ans = mod1.add(com1, com2)
print(ans.r, ans.i)