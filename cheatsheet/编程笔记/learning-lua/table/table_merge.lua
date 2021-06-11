function table_merge(t1, t2)
    local t3 = {unpack(t1)}
    for i = 1, #t2 do
        t3[#t3 + 1] = t2[i]
    end
    return t3
end

t1 = {'a', 'b', 'c'}

t2 = {'d', 'e', 'f' }

t3 = table_merge(t1, t2)

print(table.concat(t1))
print(table.concat(t2))
print(table.concat(t3))
