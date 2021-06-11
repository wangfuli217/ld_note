当向表中新分配一个不存在的键时，会触发 __newindex 元方法，如果该键已存在，则不会触发

local t = {}

local m = setmetatable({}, {__newindex = function (table, key, value)
  t[key] = value
end})

-- 注：上面使用函数等同于直接指定 __newindex 为表 t
-- local m = setmetatable({}, {__newindex = t})

m[123] = 456
print(m[123]) --> nil
print(t[123]) --> 456