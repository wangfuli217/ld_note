# $(VARIABLE_NAME)   Makefile 中定义的或者是make的环境变量
# ${VARIABLE_NAME}   出现在规则命令行中 shell 变量,引用使用 shell 的"${tmp}"格式。
# 对出现在命令行中的 make 变量我们同样使用"$(CMDVAR)"格式来引用。

# rule:
# 1) makefile variable, use $(VAR) $(V), not $VAR $V
# 2) variable in cmd line is a shell variable, use $$VAR , not $VAR or $$(VAR)
# 3) $$ --> $
# 

# echo $PATH     # echo $(P)ATH                                         -> ATH
# echo ${PATH}   # echo /bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin    -> /bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin
# echo $(PATH)   # echo /bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin    -> /bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin 
# echo $$PATH    # echo $PATH                                           -> /bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin 
# echo $${PATH}  # echo ${PATH}                                         -> /bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin 
# echo $$(PATH)  # echo $(PATH)                                         -> /bin/sh: PATH: command not found 即 $(cmd) 中PATH命令不能执行
# echo $$CFLAGS    # echo $CFLAGS                                       -> 
# echo $${CFLAGS}  # echo ${CFLAGS}                                     -> 
# echo $$(CFLAGS)  # echo $(CFLAGS)                                     -> /bin/sh: CFLAGS: command not found 即 $(cmd)中PATH命令不能执行
reference_env :
	echo $PATH
	echo $(PATH)
	echo ${PATH}
reference2_env :
	echo $$PATH
	echo $${PATH}
	echo $$(PATH)
reference2_make :
	echo $$CFLAGS
	echo $${CFLAGS}
	echo $$(CFLAGS)

# Hello
recurive_expansion :
	echo $(foo)

# 1) Recursive variable
#  variable expended util final use
foo = $(bar)
bar = $(hei)
hei = Hello

# fatal error for 1) 
# $Makefile:15: *** Recursive variable `foo' references itself (eventually).  Stop
# $hei = $(foo)

# 2) := 
#  Makefile中变量和函数的展开(除规则命令行中的变量和函数以外)，是在make读取makefile文件时进行的
reference_direct :
	echo $(x)
	echo $(y)

x := foo
y := $(x) bar
x := later

cur-dir := $(shell pwd)
whoami := $(shell whoami)
host-type := $(shell arch)

# 3) space
nullstring :=
space = $(nullstring) # space

reference_space :
	echo "__"$(space)"__"


# 4) ?= 
# 条件赋值的赋值操作符
FOO ?= foo

BAR := bar
BAR ?= foo

reference_condition :
	@echo FOO = $(FOO)
	@echo BAR = $(BAR)


# ?= just like below:
#ifeq ($(origin FOO),undefined)
#    FOO = foo
#endif
# fallible error :
# 1) [TAB] befor FOO = foo ;   space is ok
# 2) space after "," before undefined   ,  like :  ifeq ($(origin FOO), undefined)

# 5) +=
# add hei.o to the end of $(objects), and insert a space between the values
# := or = will effect the result of +=
test := test.o
# case A)
objects := $(test) foo.o bar.o
objects += hei.o

# case B)
objects2 = $(test) foo.o bar.o
objects2 += hei.o

test := zzz.o

reference_append :
	@echo "objects = "$(objects)
	@echo "objects2 = "$(objects2)


