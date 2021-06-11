local array = require "array"

a = array.new(1000)
for i = 1, 1000 do
    a:set(i, i % 2 == 0)
end
print(a:get(10))
print(a:get(11))
print(a:size())
print("a", a)