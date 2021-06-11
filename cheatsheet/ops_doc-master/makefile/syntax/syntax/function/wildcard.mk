# 使用函数"wildcard" ，
# 它的用法是：$(wildcard PATTERN...) 。在 Makefile 中，它被展开为已经存在的、使用空格
# 分开的、匹配此模式的所有文件列表。如果不存在任何符合此模式的文件，函数会忽略
# 模式字符并返回空。
# 需要注意的是：这种情况下规则中通配符的展开和上一小节匹配通配符的区别。 
#     一般可以使用"$(wildcard *.c)"来获取工作目录下的所有的.c文件列表。复
# 杂一些用法；可以使用"$(patsubst %.c,%.o,$(wildcard *.c))" ，首先使用"wildcard"
# 函数获取工作目录下的.c文件列表；之后将列表中所有文件名的后缀.c替换为.o。
# 这样就可以得到在当前目录可生成的.o 文件列表。因此在一个目录下可以使用如下内
# 容的 Makefile 来将工作目录下的所有的.c 文件进行编译并最后连接成为一个可执行文件： 
 
#sample Makefile 
objects := $(patsubst %.c,%.o,$(wildcard *.c)) 
 
foo : $(objects) 
	cc -o foo $(objects)
	
clean: 
	rm *.o temp 