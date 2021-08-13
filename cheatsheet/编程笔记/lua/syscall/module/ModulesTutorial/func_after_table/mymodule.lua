-- Make all functions local and put them in a table at the end:

-- private
local function private()
    print("in private function")
end

local function foo()
    print("Hello World!")
end

local function bar()
    private()
    foo() -- do not prefix function call with module
end

return { -- public interface
  foo = foo,
  bar = bar,
}
