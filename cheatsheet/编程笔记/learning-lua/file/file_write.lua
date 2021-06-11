file = io.open("test.txt", "a") --使用io.open()函数，以添加模式打开文件
file:write("\nhello file_write\n") --使用file:open()函数，在文件的最后添加一行内容
file:close()