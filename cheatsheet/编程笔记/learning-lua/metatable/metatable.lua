Object = setmetatable({}, { __metatable = "You cannot access here" })

print(getmetatable(Object)) --> You cannot access here
setmetatable(Object, {}) --> 引发编译器报错
