# $(word N,TEXT)
# 函数名称:取单词函数。
# 函数功能:取字串“TEXT”中第“N”个单词(“N”的值从 1 开始)。
# 返回值:返回字串“TEXT”中第“N”个单词。
# 函数说明:如果“N”值大于字串“TEXT”中单词的数目,返回空字符串。如果“N”为 0,出错!
# 示例:
# $(word 2, foo bar baz)
# 返回值为“bar”。


.PHONY: all
objects=foo bar baz

all:
	@echo $(word 2, foo bar baz)
	@echo $(word 2, $(objects))