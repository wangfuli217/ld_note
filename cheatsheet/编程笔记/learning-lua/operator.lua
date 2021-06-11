-- 算术运算符

print(1 + 2) --> 3
print(5 / 10) --> 0.5, 与C不同
print(5.0 / 10) --> 0.5
--print(10 / 0)
print(2 ^ 10) --> 1024

local num = 1357
print(num % 2) --> 1
print((num % 2) == 1) --> true
print((num % 5) == 0) --> false

-- 关系运算符

print(1 < 2) --> true
print(1 == 2) --> false
print(1 ~= 2) --> true, 与C不同
local a, b = true, false
print(a == b) --> false

-- ==, 引用比较

local a = { x = 1, y = 0 }
local b = { x = 1, y = 0 }
if a == b then
    print("a == b")
else
    print("a ~= b")
end

-- output: a~=b

-- 逻辑运算符

-- a and b 如果a为nil，则返回a，否则返回b;
-- a or b 如果a为nil，则返回b，否则返回a;

local c = nil
local d = 0
local e = 100
print(c and d) --> nil
print(c and e) --> nil
print(d and e) --> 100
print(c or d) --> 0
print(c or e) --> 100
print(not c) --> true
print(not d) --> false

-- 字符串连接

print("Hello " .. "World") --> Hello World
print(0 .. 1) --> 01

str1 = string.format("%s-%s", "hello", "world")
print(str1) --> hello-world

str2 = string.format("%d-%s-%0.2f", 123, "world", 1.21)
print(str2) --> 123-world-1.21

-- 优先级

local a, b = 1, 2
local x, y = 3, 4
local i = 10
local res = 0
res = a + i < b / 2 + 1 --> res = (a + i) < ((b / 2) + 1)
print(res)
res = 5 + x ^ 2 * 8 --> res = 5 + ((x^2) * 8)
print(res)
res = a < y and y <= x --> res = (a < y) and (y <= x)
print(res)
