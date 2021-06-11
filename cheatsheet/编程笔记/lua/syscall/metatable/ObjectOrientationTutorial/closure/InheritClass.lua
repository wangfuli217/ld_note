-- Inheritance is also possible this way:

local function BaseClass(init)
  local self = {}

  local private_field = init

  function self.foo()
    return private_field
  end

  function self.bar()
    private_field = private_field + 1
  end

  -- return the instance
  return self
end

local function DerivedClass(init, init2)
  local self = BaseClass(init)

  self.public_field = init2

  -- this is independent from the base class's private field that has the same name
  local private_field = init2

  -- save the base version of foo for use in the derived version
  local base_foo = self.foo
  function self.foo()
    return private_field + self.public_field + base_foo()
  end

  -- return the instance
  return self
end

local i = DerivedClass(1, 2)
print(i.foo()) --> 5
i.bar()
print(i.foo()) --> 6