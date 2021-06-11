# $(patsubst PATTERN,REPLACEMENT,TEXT)
# 函数名称:模式替换函数—patsubst。
# 函数功能:搜索“TEXT”中以空格分开的单词,将否符合模式“TATTERN”替换为“REPLACEMENT”。
# 参数“PATTERN”中可以使用模式通配符“%”来代表一个单词中的若干字符
# 返回值:替换后的新字符串。
# 函数说明:参数“TEXT”单词之间的多个空格在处理时被合并为一个空格,并忽略前导和结尾空格。


.PHONY: all
objects = foo.o bar.o baz.o

all:
	@echo "call(addprefix src/,foo bar)"
	@echo $(patsubst %.c,%.o,x.c.c bar.c)
	
	@echo $(objects:.o=.c)
	@echo $(patsubst %.o,%.c,$(objects))
	
# # 变量的替换引用
# $(VAR:PATTERN=REPLACEMENT)
# # 就相当于:
# $(patsubst PATTERN,REPLACEMENT,$(VAR))
# # 另外一种更为简单的替换字符后缀的实现:
# $(VAR:SUFFIX=REPLACEMENT)
# # 它等于:
# $(patsubst %SUFFIX,%REPLACEMENT,$(VAR))
# # eg:
# objects = foo.o bar.o baz.o
# srcs = $(objects:.o=.c)
# srcs = $(patsubst %.o,%.c,$(objects))

# 对于源代码所包含的头文件的搜索路径需要使用gcc的“-I”参数指定目录来实现,“VPATH”罗列的目录是用冒号“:”分割的。
# 示例:
# VPATH = src:../includes
# override CFLAGS += $(patsubst %,-I%,$(subst :, ,$(VPATH)))
# $(subst :, ,$(VPATH)) 替换: 为空格
# $(patsubst %,-I%,$(VAR)) 将每个变量起始位置加统一前缀'-I'
