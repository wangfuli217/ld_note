# $(firstword <text>)
#     名称：首单词函数  firstword。
#     功能：取字符串<text>中的第一个单词。
#     返回：返回字符串<text>的第一个单词。
#     示例：$(firstword foo bar)返回值是"foo"。
# 备注：这个函数可以用word函数来实现：$(word 1,<text>)。

number = first second

.PHONY: all

all:
	@echo "call(firstword foo bar)"
	@echo $(firstword foo bar)
	@echo # 
	@echo "call(firstword $(number))"
	@echo $(firstword $(number))

