# origin函数
# $(origin VARIABLE)
# 函数功能：函数"origin"查询参数"VARIABLE" (一个变量名)的出处。
# 函数说明： "VARIABLE"是一个变量名而不是一个变量的引用。因此通常它不包含"$"(当然，计算的变量名例外)。
# 返回值：返回"VARIABLE"的定义方式。用字符串表示。
#     undefined     变量"VARIABLE"没有被定义。
#     default       变量"VARIABLE"是一个默认定义(内嵌变量)。 -> 10.3 隐含变量
#                   如"CC"、"MAKE"、"RM"等变量。如果在 Makefile 中重新定义这些变量，函数返回值将相应发生变化
#     environment   变量"VARIABLE"是一个系统环境变量，并且make没有使用命令行选项"-e" -> 10.7 make的命令行选项
#                   (Makefile 中不存在同名的变量定义，此变量没有被替代)。
#     environment override 变量"VARIABLE"是一个系统环境变量，并且make使用了命令行选项"-e"。Makefile中存在一个同名的变量定义，-> 9.7 make的命令行选项
#                          使用"make -e"时环境变量值替代了文件中的变量定义。
#     file          变量"VARIABLE"在某一个makefile文件中定义。
#     command line  变量"VARIABLE"在命令行中定义。
#     override      变量"VARIABLE"在 makefile 文件中定义并使用"override"指示符声明。
#     automatic     变量"VARIABLE"是自动化变量。


CMD_LS = $(shell ls -a)

MPATH="/data/"
MSUBPATH=$(MPATH)

.PHONY: all

all:
	@echo "undefined variable"
	@echo $(origin undefined)
	
	@echo "default variable"
	@echo $(origin CC)
	
	@echo "shell variable"
	@echo $(origin CMD_LS)
	
	@echo "makefile variable"
	@echo $(origin HOME)
	@echo $(origin MSUBPATH)
	
	@echo "MAKEFLAGS variable"
	@echo $(origin MAKEFLAGS)

# 函数"origin"返回的变量信息对我们书写 Makefile 是相当有用的，可以使我们在
# 使用一个变量之前对它值的合法性进行判断。假设在 Makefile 其包了另外一个名为
# bar.mk 的 makefile 文件。我们需要在 bar.mk 中定义变量"bletch"(无论它是否是一
# 个环境变量)，保证"make –f bar.mk"能够正确执行。另外一种情况，当Makefile 包
# 含bar.mk，在Makefile包含bar.mk之前有同样的变量定义，但是我们不希望覆盖bar.mk
# 中的"bletch"的定义。一种方式是：我们在bar.mk中使用指示符"override"声明这
# 个变量。但是它所存在的问题时，此变量不能被任何方式定义的同名变量覆盖，包括命
# 令行定义。另外一种比较灵活的实现就是在bar.mk 中使用"origin"函数，如下： 
#  
# ifdef bletch 
# ifeq "$(origin bletch)" "environment" 
# bletch = barf, gag, etc. 
# endif 
# endif 
#  
# 这里，如果存在环境变量"bletch"，则对它进行重定义。 
#  
# ifneq "$(findstring environment,$(origin bletch))" "" 
# bletch = barf, gag, etc. 
# endif 
#  
# 这个例子实现了：即使环境变量中已经存在变量"bletch"，无论是否使用"make -e"
# 来执行 Makefile，变量"bletch"的值都是"barf,gag,etc"(在 Makefile 中所定义的) 。
# 环境变量不能替代文件中的定义。 
# 如果"$(origin bletch)"返回"environment"或"environment override"，都将对
# 变量"bletch"重新定义。