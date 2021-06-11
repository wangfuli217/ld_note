使用 setmetatable() 方法设定一个表作为元表

local x = {value = 5}

local mt = {
  __add = function (lhs, rhs)
    return { value = lhs.value + rhs.value }
  end
}

setmetatable(x, mt)
local y = x + x
print(y.value) --10
local z = y + y --error

设置 mt 为 x 的元表，元表中拥有 __add 元方法，所以 x 才可以使用 + 操作符，y 没有元方法，不能使用 + 操作符

如果其中一个操作数是数字，同样也可以触发元表中的方法，并且，左边的操作数就是函数中的第一个参数，右边的操作数就是第二个参数，所以具有元表的表也不一定是元方法的第一个参数：

local x = {value = 5}

local mt = {
    __add = function(l,r)
        return {value = l + r.value}
    end
}

setmetatable(x,mt)
local y = 5 + x
print(y.value) --10