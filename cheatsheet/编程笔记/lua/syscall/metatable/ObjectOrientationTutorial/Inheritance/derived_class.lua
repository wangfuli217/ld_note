-- It's easy to extend the design of the class in the above example to use inheritance:

local BaseClass = {}
BaseClass.__index = BaseClass

setmetatable(BaseClass, {
  __call = function (cls, ...) -- ... -> _init(...) 可变输入参数 -> 即BaseClass:_init(init) 固定输入参数
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function BaseClass:_init(init) -- 从self:_init(...) 到 BaseClass:_init(init)，从可变输入参数到固定输入参数
  self.value = init
end

function BaseClass:set_value(newval)
  print("BaseClass:set_value:self\t"..tostring(self))
  self.value = newval
end

function BaseClass:get_value()
  return self.value
end

---

local DerivedClass = {}
DerivedClass.__index = DerivedClass

setmetatable(DerivedClass, {
  __index = BaseClass, -- this is what makes the inheritance work
  __call = function (cls, ...)
    local self = setmetatable({}, cls) -- self为新建实例；实例元表为DerivedClass；元表的__index指向基类
    self:_init(...)
    return self
  end,
})

function DerivedClass:_init(init1, init2) -- 从self:_init(...) 到 DerivedClass:_init(init)，从可变输入参数到固定输入参数
  BaseClass._init(self, init1) -- call the base class constructor
  self.value2 = init2
end

function DerivedClass:get_value() -- 覆盖基类对应函数
  print("DerivedClass:get_value:self\t"..tostring(self))
  return self.value + self.value2
end

local i = DerivedClass(1, 2)
print("i\t"..tostring(i)) -- self == i

print(i:get_value()) --> 3
i:set_value(3)
print(i:get_value()) --> 5