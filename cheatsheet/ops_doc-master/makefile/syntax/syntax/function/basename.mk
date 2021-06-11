# $(basename NAMES...)
# 函数名称:取前缀函数—basename。
# 函数功能:从文件名序列“NAMES...”中取出各个文件名的前缀部分(点号之后的部分)。前缀部分指的是文件名中最后一个点号之前的部分。
# 返回值:空格分割的文件名序列“NAMES...”中各个文件的前缀序列。如果文件没有前缀,则返回空字串。
# 函数说明:如果“NAMES...”中包含没有后缀的文件名,此文件名不改变。如果一个文件名中存在多个点号,则返回值为此文件名的最后一个点号之前的文件名部分。
# 示例:
# $(basename src/foo.c src-1.0/bar.c /home/jack/.font.cache-1 hacks)
# 返回值为:“src/foo src-1.0/bar /home/jack/.font hacks”

.PHONY: all

all:
	@echo $(basename src/foo.c src-1.0/bar.c /home/jack/.font.cache-1 hacks)


