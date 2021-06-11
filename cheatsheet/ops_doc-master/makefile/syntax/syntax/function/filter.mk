# $(filter ,)
# 
# 名称：过滤函数 -- filter。
# 功能：以模式过滤字符串中的单词，保留符合模式的单词。可以有多个模式。
# 返回：返回符合模式的字串。
# 示例：
# 


sources := foo.c bar.c baz.s ugh.h
all: 
	@echo $(filter %.c %.s,$(sources))

# $(filter %.c %.s,$(sources))返回的值是"foo.c bar.c baz.s"。
# foo: $(sources)
# 	cc $(filter %.c %.s,$(sources)) -o foo

