--计算最小的x,使从1到x的所有数相加和大于100

sum = 0
i = 1
while true do
    sum = sum + i
    if sum > 100 then
        break
    end
    i = i + 1
end

print("The result is " .. i)