# $(wordlist S,E,TEXT)
# 函数名称:取子串函数。
# 函数功能:从字串“TEXT”中取出从“S”开始到“E”的子单词串。“S”和“E”表示单词在字串中位置的数字。
# 返回值:字串“TEXT”中从第“S”到“E”(包括“E”)的单词字串。
# 函数说明:“S”和“E”都是从 1 开始的数字。
# 当“S”比“TEXT”中的字数大时,返回空。如果“E”大于“TEXT”字数,返回从“S”开始,到“TEXT”结束的单词串。如果“S”大于“E”,返回空。
# 示例:
# $(wordlist 2, 3, foo bar baz)
# 返回值为:“bar baz”。

.PHONY: all
objects=foo bar baz

all:
	@echo $(wordlist 2, 3, foo bar baz)
	@echo $(wordlist 2, 3, $(objects))