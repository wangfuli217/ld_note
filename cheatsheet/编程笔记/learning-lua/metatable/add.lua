set1 = { 10, 20, 30 } --集合
set2 = { 20, 40, 50 } --集合

--将用于重载__add的函数，注意第一个参数是self
union = function(self, another)
    local set = {}
    local result = {}
    --利用数组来确保集合的互异性
    for i, j in pairs(self) do
        set[j] = true
    end
    for i, j in pairs(another) do
        set[j] = true
    end
    --加入结果集合
    for i, j in pairs(set) do
        table.insert(result, i)
    end
    return result
end

setmetatable(set1, { __add = union }) --重载set1表的__add元方法

set3 = set1 + set2
for _, j in pairs(set3) do
    io.write(j .. " ") -->输出结果30 50 20 40 10
end
io.write("\n")
