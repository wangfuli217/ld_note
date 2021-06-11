require('Strict')
-- 'Import' a couple of functions into globals, for convenience
declareGlobal,isDeclared=Strict.declareGlobal,Strict.isDeclared
-- ... then switch from default (weak) to strong checking
-- 'Strong' means that *all* global variables have to be declared
--  via a call to declareGlobal()
Strict.strong=true
-- Show is a global and as such has to be declared
declareGlobal('show')
function show(b)
	if b then return 'on' else return 'off' end
end
--[[ NB: the code above and this are equivalent:
declareGlobal('show',function (b)
	if b then return 'on' else return 'off' end
end)
--]]
-- Switch off strict (ie neither weak nor strong)
Strict.strict=false
print('Strict mode is now '..show(Strict.strict))
-- Use a few globals
x=97
y=98
z=99
print('-> '..x)
print('-> '..y)
print('-> '..z)
-- Define a global function
function square(n)
	print('-> '..n*n)
end
-- Switch back on
Strict.strict=true
print('Strict mode is now '..show(Strict.strict))
declareGlobal('Bond',007)
print('-> '..Bond)
x=997
y=998
z=999
square(x)
square(y)
square(z)
square(Bond)
-- check is a local, no declaration needed
local function check(n)
	if isDeclared(n) then print(n..' is declared')
	else print(n..' is not declared') end
end
check('Q')
declareGlobal('Q','clever')
check('Q')
declareGlobal('M')
print(M)   -- M may be nil
check('M') -- ... but it's still declared
notDeclared=0