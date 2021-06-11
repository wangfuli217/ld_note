module("mymodule", package.seeall) -- optionally omitting package.seeall if desired
-- 增加了一个名字为mymodule的表
-- private
local x = 1 local 
function baz() print 'test' end

function foo() print("foo", x) end

function bar() 
    foo() 
    baz() 
    print "bar" 
end

