local mylib = require "mylib"

print(mylib.sin(3))

local res = mylib.dir('.')
for _, v in ipairs(res) do
    print(v)
end


-- Exercise 29.1
local summation = mylib.summation
print(summation()) --> 0
print(summation(2.3, 5.4)) --> 7.7
print(summation(2.3, 5.4, -34)) --> -26.3
--print(summation(2.3, 5.4, {}))

-- Exercise 29.2
local t = mylib.pack(3, 4, nil, 5)
--local t = table.pack(3, 4, nil, 5)
for k, v in pairs(t) do
    print(k, v)
end

-- Exercise 29.3
local reverse = mylib.reverse
print(reverse(1, "hello", 20))
print(reverse(1, 2, 3, 4))

-- Exercise 29.4
local foreach = mylib.foreach
print("foreach")
foreach({x = 10, y = 20}, print)


print("map:")
local a = {1, 2, 3, 4}
mylib.map(a, function (x) return x*x end)
for i, v in ipairs(a) do
    print(i, v)
end
print()

print("split")
local t = mylib.split("hi:ho:there", ":")
for i, v in ipairs(t) do
    print(i, v)
end
print()

print("upper");
print(mylib.upper("hello"))
print()

print("concat")
print(mylib.concat({"hello ", "world"}))
print()


print("new counter")
local newCounter = mylib.newCounter
local c1 = newCounter()
c1(); c1()
local c2 = newCounter()
print("c1", c1())
print("c2", c2())