# $(notdir NAMES...)
# 函数名称:取文件名函数——notdir。
# 函数功能:从文件名序列“NAMES...”中取出非目录部分。目录部分是指最后一个斜线(“/”)(包括斜线)之前的部分。删除所有文件名中的目录部分,只保留非目录部分。
# 返回值:文件名序列“NAMES...”中每一个文件的非目录部分。
# 函数说明:如果“NAMES...”中存在不包含斜线的文件名,则不改变这个文件名。以反斜线结尾的文件名,是用空串代替,因此当“NAMES...”中存在多
# 个这样的文件名时,返回结果中分割各个文件名的空格数目将不确定! 这是此函数的一个缺陷。
# 示例:
# $(notdir src/foo.c hacks)
# 返回值为:“foo.c hacks”。

.PHONY: all

all:
	@echo $(notdir src/foo.c hacks)