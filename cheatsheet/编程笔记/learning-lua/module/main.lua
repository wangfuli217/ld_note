local complex = require "complex"

local com1 = complex.new(0, 1)
local com2 = complex.new(1, 2)

local ans = complex.add(com1, com2)
print(ans.r, ans.i) -->output  1     3
