subsystem:
	cd subdir && $(MAKE)

# 其等价于规则:
subsystem:
	$(MAKE) -C subdir


# 需要将一个在上层定义的变量传递给子make，应该在上层Makefile中使用指示符 "export"对此变量进行声明。格式如下:
export MY_VALUE
# 当不希望将一个变量传递给子 make 时，可以使用指示符"unexport"来声明这个变量。 格式如下:
unexport MY_VALUE

#export更方便的用法是在定义变量的同时对它进行声明。看下边的几个例子:
export VARIABLE = value
# 等价于
VARIABLE = value
export VARIABLE

export VARIABLE := value
# 等效于:
VARIABLE := value
export VARIABLE

export VARIABLE += value
# 等效于:
VARIABLE += value
export VARIABLE

# 一个不带任何参数的指示符"export"指示符:
# 含义是将此 Makefile 中定义的所有变量传递给子 make 过程。
export
