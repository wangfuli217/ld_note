# foreach 函数
# foreach"函数的语法：$(foreach VAR,LIST,TEXT)
# 函数功能:这个函数的工作过程是这样的:如果需要(存在变量或者函数的引用),首先展开变量"VAR"和"LIST"的引用;而表达式"TEXT"中的变量引用不展开。
# 执行时把"LIST"中使用空格分割的单词依次取出赋值给变量"VAR",然后执行"TEXT"表达式。重复直到"LIST"的最后一个单词(为空时结束)。
# "TEXT"中的变量或者函数引用在执行时才被展开,因此如果在"TEXT"中存在对"VAR"的引用,那么"VAR"的值在每一次展开式将会到的不同的值。
# 返回值:空格分割的多次表达式"TEXT"的计算的结果。
# 我们来看一个例子,定义变量"files",它的值为四个目录(变量"dirs"代表的 a、b、c、d 四个目录)下的文件列表:
# dirs := a b c d
# files := $(foreach dir,$(dirs),$(wildcard $(dir)/*))
# 所以此函数所实现的功能就和一下语句等价:
files := $(wildcard a/* b/* c/* d/*)

#当函数的"TEXT"表达式过于复杂时,我们可以通过定义一个中间变量,此变量代表表达式的一部分。并在函数的"TEXT"中引用这个变量 上边的例子也可以这样来实现:
# dirs := a b c d
# find_files = $(wildcard $(dir)/*)
# dirs := a b c d
# files := $(foreach dir,$(dirs),$(find_files))

dirs := a b c d
files := $(foreach dir,$(dirs),$(wildcard $(dir)/*))


all:
	@echo $(dirs)
	@echo $(files)