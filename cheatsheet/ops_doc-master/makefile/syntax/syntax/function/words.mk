# $(words TEXT)
# 函数名称:统计单词数目函数—words。
# 函数功能:字算字串“TEXT”中单词的数目。
# 返回值:“TEXT”字串中的单词数。
# 示例:
# $(words foo bar)
# 返 回 值 是 “ 2 ”.

.PHONY: all
objects=foo bar baz

all:
	@echo $(words  foo bar baz)
	@echo $(words $(objects))
	
	@echo $(words,  foo bar baz)
	@echo $(words, $(objects))