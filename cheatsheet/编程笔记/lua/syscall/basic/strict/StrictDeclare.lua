-- This quicky shows a perhaps more convenient approach to declare
-- globals than using a number of calls to Strict.declareGlobal()
require('Strict')
Strict.strong=true
local function declareGlobal(t,m)
	for k,v in pairs(t) do Strict.declareGlobal(k,v,m) end
end
declareGlobal {
	x=97, y=98, z=99, show=function (...) print(...) end, s='test'
}
show(show,x,y,z,s)