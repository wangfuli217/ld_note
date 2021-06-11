# Makefile的条件判断
# 关键字"ifeq",此关键字用来判断参数是否相等,格式如下:
ifeq (ARG1, ARG2)
ifeq 'ARG1' 'ARG2'
ifeq "ARG1" "ARG2"
ifeq "ARG1" 'ARG2'
ifeq 'ARG1' "ARG2"

ifeq ($(strip $(foo)),)
	@echo 'Hello,World.'
endif
# make的"strip"函数,来对它变量的值进行处理,去掉其中的空字符
# 因此当我们需要判断一个变量的值是否为空的情况时,
#需要使用"ifeq"(或者"ifneq")而不是"ifdef"

# 标记测试的条件语句
# 们可以使用条件判断语句、变量"MAKEFLAGS"和函数"findstring"实现对make命令行
# 选项的测试。看一个例子:
ifneq (,$(findstring t,$(MAKEFLAGS)))
	+touch archive.a
	+ranlib -t archive.a
else
	ranlib archive.a
endif
# 命令行前的"+"的意思是告诉 make,即使 make 使用了"-t"参数,"+"之后的命令都需要被执行
