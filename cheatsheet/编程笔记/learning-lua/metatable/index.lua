mytable = setmetatable({ key1 = "value1" }, --原始表
    {
        --重载函数
        __index = function(self, key)
            if key == "key2" then
                return "metatablevalue"
            else
                return self[key]
            end
        end
    })

print(mytable.key1, mytable.key2) -->value1 metatablevalue

t = setmetatable({ [1] = "hello" }, { __index = { [2] = "world" } })
print(t[1], t[2]) -->hello world
