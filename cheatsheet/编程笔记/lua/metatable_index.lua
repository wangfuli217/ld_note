0. __index

使用 __index 键可以接备用表(fallback table)或者函数，如果接函数，则第一个参数是查找失败的表，第二个参数是查找的键。备用表同样可以触发它的 __index 键，所以可以创建一个很长的备用表链

local func_example = setmetatable({}, {__index = function (t, k)
  return "key doesn't exist"
end})

local fallback_tbl = setmetatable({
  foo = "bar",
  [123] = 456,
}, {__index=func_example})

local fallback_example = setmetatable({}, {__index=fallback_tbl})

print(func_example[1]) --> key doesn't exist
print(fallback_example.foo) --> bar
print(fallback_example[123]) --> 456
print(fallback_example[456]) --> key doesn't exist