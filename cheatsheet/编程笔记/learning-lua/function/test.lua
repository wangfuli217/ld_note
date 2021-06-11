
local sample = require "sample"

local function doAction(method, ...)
    local args = {...} or {}
    method(unpack(args, 1, table.maxn(args)))
end

print(type(sample))
for k, v in pairs(sample) do
    print(k, v)
end

doAction(sample.hello, sample, ' 123') -- 相当于sample:hello('123')
doAction(sample.world, ' 321') -- 相当于sample.world('321')
