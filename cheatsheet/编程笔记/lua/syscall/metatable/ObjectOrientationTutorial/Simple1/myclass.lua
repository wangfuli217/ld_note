local MyClass = {} -- the table representing the class, which will double as the metatable for the instances
MyClass.__index = MyClass -- failed table lookups on the instances should fallback to the class table, to get methods

-- syntax equivalent to "MyClass.new = function..."
-- 1. MyClass提供方法 
-- 2. MyClass.__index = MyClass 元表的__index指向MyClass，使得可以实现继承
function MyClass.new(init)
  local self = setmetatable({}, MyClass) -- 3. self作为table提供数据
  self.value = init
  return self
end

function MyClass.set_value(self, newval) -- 4. self == MyClass
  print("self\t"..tostring(self)) 
  self.value = newval
end

function MyClass.get_value(self)
  return self.value
end

print("MyClass\t".. tostring(MyClass))

local i = MyClass.new(5)
print("i\t".. tostring(i))             -- self == i

-- tbl:name(arg) is a shortcut for tbl.name(tbl, arg), except tbl is evaluated only once
print(i:get_value()) --> 5
i:set_value(6)
print(i:get_value()) --> 6

local j = MyClass.new(5)
print("j\t".. tostring(j))             -- self == j
j:set_value(6)