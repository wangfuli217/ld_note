file = io.open("test.txt", "a+") --使用io.open()函数，以添加模式打开文件
io.output(file) --使用io.output()函数，设置默认输出文件
io.write("\nhello world\n") --使用io.write()函数，把内容写到文件
io.close(file)
