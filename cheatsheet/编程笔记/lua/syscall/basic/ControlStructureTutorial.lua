--
-- if
--
n = 5
if n > 5 then print("greater than 5") else print("less than 5") end
n = 7
if n > 5 then print("greater than 5") else print("less than 5") end

n = 12
if n > 15 then
    print("the number is > 15")
elseif n > 10 then
    print("the number is > 10")
elseif n > 5 then
    print("the number is > 5")
else
    print("the number is <= 5")
end

if 5 then print("true") else print("false") end -- true
if 0 then print("true") else print("false") end -- true
if true then print("true") else print("false") end -- true
if {} then print("true") else print("false") end -- true
if "string" then print("true") else print("false") end -- true
if nil then print("true") else print("false") end  -- false
if false then print("true") else print("false") end -- false

-- 
-- while
--
i = 1
while i <= 10 do
    print(i)
    i = i + 1
end

--
-- repeat until
--
i = 5
repeat
    print(i)
    i = i - 1
until i == 0

-- for variable = start, stop, step do
--   block
--   end
for i = 1, 5 do
    print(i)
end

for i = 1, 100, 8 do
    print(i)
end

for i = 3, -3, -1 do
    print(i)
end

for i = 0, 1, 0.25 do
    print(i)
end

for i = 1, 3 do
    for j = 1, i do
        print(j)
    end
end







