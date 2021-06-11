-- This shows how to (mis-)use a custom handler function
local Strict = require('Strict')
Strict.strong=true
-- Set new handler function
Strict.handler=function (module,name,f)
	-- Normally, a handler would terminate the script in an appropriate manner
	print('Dunno what '..Strict.getModulename(module)..'.'..name..' means...')
end
-- Simple way to import declareGlobal even after having set Strict.strong
local declareGlobal=Strict.declareGlobal
-- Easier to define a function as local than to declareGlobal() it:-)
local function show(n)
	if n==nil then print('Oops!')
	else print(n) end
end
declareGlobal('x',7)
y=123   -- this triggers the first message
show(x)
show(y) -- triggers second message
Strict.handler=function (module,name,v)
	-- This handler is even more dodgy though it should (and seems to) work
	if v~=nil then -- if there's a value why not auto-declare name?
		print(name..' undeclared, will now be forced into existence...')
		declareGlobal(name,v,module) -- this doesn't declare 'name'!
	end
end
show(y) -- no joy
y=123   -- this will trigger the code in the handler above
show(y) -- ... and now all is well