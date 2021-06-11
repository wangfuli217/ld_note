-- You can even change the chunk's environment to store any global variables you create into the module:

local print = print -- the new env will prevent you from seeing global variables

local M = {}
if setfenv then
	setfenv(1, M) -- for 5.1 table M replace _G as environment
else
	_ENV = M -- for 5.2 table M replace _ENV as environment
end

local function private() -- local function variable
    print("in private function")
end

function foo() -- global function variable, so M.foo() like _G.foo()
    print("Hello World!")
end

function bar() -- global function variable, so M.bar() like _G.bar()
    private()
    foo()
end

-- then M have bar() and foo()

return M
