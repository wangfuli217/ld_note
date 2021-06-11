-- There are some improvements that can be made:

local MyClass = {}
MyClass.__index = MyClass 

setmetatable(MyClass, {
  __call = function (cls, ...) -- cls == MyClass
    return cls.new(...) -- MyClass.new(...)
  end,
})

function MyClass.new(init)
  local self = setmetatable({}, MyClass) -- self is table, metatable is MyClass, MyClass.__index is MyClass
  self.value = init
  print("self\t"..tostring(self))
  return self
end

-- the : syntax here causes a "self" arg to be implicitly added before any other args
function MyClass:set_value(newval)
  self.value = newval
end

function MyClass:get_value()
  return self.value
end

print("MyClass\t"..tostring(MyClass))

local instance = MyClass(5)
print("instance\t"..tostring(instance)) -- self == instance


print(instance:get_value())
instance:set_value(6)
print(instance:get_value())

local demo = MyClass(7)
print("demo\t"..tostring(demo)) -- self == demo

