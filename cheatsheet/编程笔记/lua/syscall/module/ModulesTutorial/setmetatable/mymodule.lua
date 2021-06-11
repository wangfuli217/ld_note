-- if you don't want to have to save all the globals you need into locals:

local M = {}
do
	local globaltbl = _G
	local newenv = setmetatable({}, {
		__index = function (t, k)
			local v = M[k]
			if v == nil then return globaltbl[k] end
			return v
		end,
		__newindex = M,
	})
	if setfenv then
		setfenv(1, newenv) -- for 5.1
	else
		_ENV = newenv -- for 5.2
	end
end

local function private()
    print("in private function")
end

function foo()
    print("Hello World!")
end

function bar()
    private()
    foo()
end

return M