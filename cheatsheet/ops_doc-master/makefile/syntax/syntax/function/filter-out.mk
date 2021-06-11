# $(filter-out PATTERN...,TEXT)
# 函数名称:反过滤函数—filter-out。
# 函数功能:和“filter”函数实现的功能相反。过滤掉字串“TEXT”中所有符合模式“PATTERN”的单词,保留所有不符合此模式的单词。可以有多个模式。
# 存在多个模式时,模式表达式之间使用空格分割。。
# 返回值:空格分割的“TEXT”字串中所有不符合模式“PATTERN”的字串。
# 函数说明:“filter-out”函数也可以用来去除一个变量中的某些字符串,(实现和“filter”函数相反)。
# 示例:

.PHONY: all
objects=main1.o foo.o main2.o bar.o
mains=main1.o main2.o
all:
	@echo $(filter-out $(mains),$(objects))

