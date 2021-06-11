--比较集合大小 <
mt = {}
function mt.__lt(tA, tB)
    return #tA < #tB
end

tA, tB = { 3 }, { 1, 2 }

setmetatable(tA, mt)
setmetatable(tB, mt)

print(tA < tB)
