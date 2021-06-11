
local mt
mt = {
  __add = function (lhs, rhs)
    return setmetatable({value = lhs.value + rhs.value}, mt)
  end,
  __eq = function (lhs, rhs)
    return lhs.value == rhs.value
  end,
  __lt = function (lhs, rhs)
    return lhs.value < rhs.value
  end,
  __le = function (lhs, rhs)
    return lhs.value <= rhs.value
  end,
}