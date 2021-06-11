A combination of the two examples above:

local mymodule = {} -- public interface

-- private
local function private()
    print("in private function")
end

local function foo()
    print("Hello World!")
end
mymodule.foo = foo

local function bar()
    private()
    foo()
end
mymodule.bar = bar

return mymodule
