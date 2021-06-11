# $(addsuffix SUFFIX,NAMES...)
# 函数名称:加后缀函数—addsuffix。
# 函数功能:为“NAMES...”中的每一个文件名添加后缀“SUFFIX”。参数“NAMES...”为空格分割的文件名序列,将“SUFFIX”追加到此序列的每一个文件名的末尾。
# 返回值:以单空格分割的添加了后缀“SUFFIX”的文件名序列。
# 函数说明:
# 示例:
# $(addsuffix .c,foo bar)
# 返回值为“foo.c bar.c”

all:
	@echo $(addsuffix .c,foo bar)

