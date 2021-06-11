-- return
-- string.find (s,p) 从string 变量s的开头向后匹配 string
-- p，若匹配不成功，返回nil，若匹配成功，返回第一次匹配成功
-- 的起止下标。

local start, finish = string.find("hello", "he") --start值为起始下标，finish
-- 值为结束下标
print(start, finish) -- 输出 1   2

local start = string.find("hello", "he") -- start值为起始下标
print(start) --输出 1


local _, finish = string.find("hello", "he") --采用虚变量（即下划线），接收起
--始下标值，然后丢弃，finish接收
--结束下标值
print(finish) --输出 2

-- for
local t = {1,3,5 }

for i, v in ipairs(t) do
    print(i, v)
end

for _, v in ipairs(t) do
    print(v)
end

