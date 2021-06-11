-- Create a table at the top and add your functions to it:

local mymodule = {}

local function private()
    print("in private function")
end

function mymodule.foo()
    print("Hello World!")
end

function mymodule.bar()
    private()
    mymodule.foo() -- need to prefix function call with module
end

return mymodule