tA = { 1, 3 }
tB = { 5, 7 }

--tSum = tA + tB
mt = {}

mt.__add = function(t1, t2)
    for _, item in ipairs(t2) do
        table.insert(t1, item)
    end
    return t1
end

setmetatable(tA, mt)
-- 或者 setmetatable(tB, mt)

tSum = tA + tB

for k, v in pairs(tSum) do
    print(v)
end
