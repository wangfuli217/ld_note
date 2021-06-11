x = 10
local i = 1 --程序块中的局部变量i

while i <= x do
    local x = i * 2 --while循环体中的局部变量x
    print(x) --打印2, 4, 6, 8, ...(实际输出格式不是这样的，这里只是表示输出结果)
    i = i + 1
end

if i > 20 then
    local x --then中的局部变量x
    x = 20
    print(x + 2) --如果i > 20 将会打印22，此处的x是局部变量
else
    print(x) --打印10， 这里x是全局变量
end

print(x) --打印10