# 定义命令包
define run-hello
	yacc $(firstword $^)
	mv y.tab.c $@
endef

# $(firstword $^) 对引用它所在规则中的第一个依赖文件运行yacc程序

foo.c : foo.y
	$(run-hello)

# 空命令
target: ;