module(..., package.seeall)

function new(r, i)
    return { r = r, i = i }
end

local i = new(0, 1)

function add(c1, c2)
    return new(c1.r + c2.r, c1.i + c2.i)
end

function sub(c1, c2)
    return new(c1.r - c2.r, c1.i - c2.i)
end

function update()
    A = A + 1
end

--防止模块更改全局变量
getmetatable(mod1).__newindex = function(table, key, val)
    error('attempt to write to undeclared variable "' .. key .. '": ' .. debug.traceback())
end