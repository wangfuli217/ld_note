file = io.open("test.txt", "r") --使用io.open()函数，以只读模式打开文件

--使用file:lines()函数逐行读取文件
for line in file:lines() do
    print(line)
end

file:close()
