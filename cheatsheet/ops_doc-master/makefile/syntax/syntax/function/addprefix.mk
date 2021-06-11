# 函数名称：加前缀函数 addprefix。
# 函数功能：为"NAMES..."中的每一个文件名添加前缀"PREFIX"。参数"NAMES"是空格分割的文件名序列，将"PREFIX"添加到此序列的每一个文件名之前。
# 返回值：以单空格分割的添加了前缀"PREFIX"的文件名序列。
# 函数说明：
# 示例：
# $(addprefix src/,foo bar)
# 返回值为"src/foo src/bar"。


.PHONY: all

all:
	@echo "call(addprefix src/,foo bar)"
	@echo $(addprefix src/,foo bar)