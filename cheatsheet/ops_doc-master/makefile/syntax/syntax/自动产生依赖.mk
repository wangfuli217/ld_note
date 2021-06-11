# 自动产生依赖
# gcc 通过"-M" 选项来实现此功能，使用"-M"选项 gcc 将自动找寻源文件中包含的头文件，并生成 文件的依赖关系。eg:gcc -M main.c

# 当不需要在依赖关系中考虑标准库头文件时，对于 gcc 需要使用"-MM"参数。
%.d: %.c
	$(CC) -M $(CPPFLAGS) $< > $@.$$$$; \
	sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
	rm -f $@.$$$$

# 第一行;使用 c 编译器自自动生成依赖文件($<)的头文件的依赖关系，并输出 成为一个临时文件，"$$$$"表示当前进程号。


sources = foo.c bar.c 
include $(sources:.c = .d)
sinclude $(sources:.c=.d)
- include $(sources:.c = .d)
# 变量引用置换 "$(sources : .c=.d)"的功能是根据变量"source"指定的.c文件自动产生对应的.d文

# 使用"wildcard" 函数获取工作目录下的.c 文件列表
$(wildcard *.c)
# # 变量引用置换功能，根据变量"source"指定的.c文件自动产生对应的.d文
$(sources : .c=.d)
# "filter"函数过滤不符合"%.o" 模式的文件名而返回所有符合此模式的文件列(.o)表
$(filter %.o $(sources))
$(patsubst %.c,%.o,$(wildcard *.c))
# 首先使用"wildcard" 函数获取工作目录下的.c 文件列表;之后将列表中所有文件名的后缀.c 替换为.o