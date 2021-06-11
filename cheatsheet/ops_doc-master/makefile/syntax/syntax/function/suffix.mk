# $(suffix NAMES...)
# 函数名称:取后缀函数—suffix。
# 函数功能:从文件名序列“NAMES...”中取出各个文件名的后缀。后缀是文件名中最后一个以点“.”开始的(包含点号)部分,如果文件名中不包含一个点号,则为空。
# 返回值:以空格分割的文件名序列“NAMES...”中每一个文件的后缀序列。
# 函数说明:“NAMES...”是多个文件名时,返回值是多个以空格分割的单词序列。如果文件名没有后缀部分,则返回空。
# 示例:
# $(suffix src/foo.c src-1.0/bar.c hacks)
# 返回值为“.c .c”。

.PHONY: all

all:
	@echo $(suffix src/foo.c src-1.0/bar.c hacks)