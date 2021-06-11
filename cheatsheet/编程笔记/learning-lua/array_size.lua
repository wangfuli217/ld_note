local arr1 = { 1, 2, 3, [5] = 5 }
print(#arr1) -- output: 3
--print(len(arr1))

local arr2 = { 1, 2, 3, nil, nil }
print(#arr2) -- output: 3
--print(len(arr2))

local arr3 = { 1, nil, 2 }
arr3[5] = 5
print(#arr3) -- output: 1
--print(len(arr3))

local arr4 = { 1, [3] = 2 }
arr4[4] = 4
print(#arr4) -- output: 4
--print(len(arr4))
