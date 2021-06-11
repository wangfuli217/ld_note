objects = program.o foo.o utils.o

program : $(objects)
	$(CC) -o program $(objects)

$(objects) : defs.h


# Makefile 中在对一些简单变量的引用,我们也可以不使用"()"和"{}"来标记变量名,
# 而直接使用"$x"的格式来实现,此种用法仅限于变量名为单字符的情况。


[递归展开式变量]
# 这一类型变量的定义是通过"="或者使用指示符"define"定义的
# 这种变量的引用,在引用的地方是严格的文本替换过程,此变量值的字符串原模原样的出现在引用它的地方。
foo = $(bar)
bar = $(ugh)
ugh = Huh?
all:;echo $(foo)
#执行"make"将会打印出"Huh?"。


##### 其优点是: 这种类型变量在定义时,可以引用其它的之前没有定义的变量。
CFLAGS = $(include_dirs) -O
include_dirs = -Ifoo -Ibar

##### 其缺点是: 使用此风格的变量定义,可能会由于出现变量的递归定义而导致 make 陷入到无限的变量展开过程中,最终使 make 执行失败
CFLAGS = $(CFLAGS) -O
# 它将会导致 make 对变量"CFLAGS"的无限展过程中去(这种定义就是变量的递归定义)。
# 因为一旦后续同样存在对"CLFAGS"定义的追加,展开过程将是套嵌的、不能终止的(在发生这种情况时,make 会提示错误信息并结束)。
# 一般书写 Makefile 时,这种追加变量值的方法很少使用

# 看另外一个例子:
x = $(y)
y = $(x) $(z)
# 这种情况下变量在进行展开时,同样会陷入死循环。
# 所以对于此风格的变量,当在一个变量的定义中需要引用其它的同类型风格的变量时需特别注意,防止变量展开过程的死循环。


[直接展开式变量]
# 这种风格的变量使用":="定义。在使用":="定义

ifeq (0,${MAKELEVEL})
cur-dir:= $(shell pwd)
whoami := $(shell whoami)
host-type := $(shell arch)
MAKE := ${MAKE} host-type=${host-type} whoami=${whoami}
endif


# 定义一个空格
nullstring :=
space := $(nullstring) # end of the line

# "?="操作符，条件赋值的赋值操作符
# 只有此变量在之前没有赋值的情况下才会对这个变量进行赋值
FOO ?= bar
# 其等价于:
ifeq ($(origin FOO), undefined)
FOO = bar
endif

# 变量的替换引用
# 对于一个已经定义的变量,可以使用"替换引用"将其值中的后缀字符(串)使用指定的字符(字符串)替换。
# 格式为"$(VAR:A=B)" (或者"${VAR:A=B}")
# 替换变量"VAR"中所有"A"字符结尾的字为"B"结尾的字
# 结尾"的含义是空格之前(变量值多个字之间使用空格分开)，对于变量其它部分的"A"字符不进行替换。
objs := a.o b.o c.o
srcs := $(foo:.o=.c)
# 变量的替换引用其实是函数"patsubst"的一个简化实现。
#"$(patsubst A,B $(VAR))"
foo := a.o b.o c.o
bar := $(foo:%.o=%.c)


# 变量的套嵌引用
x = y
y = z
a := $($(x))


# override 指示符
override VARIABLE = VALUE
override VARIABLE := VALUE
# 对于追加方式需要说明的是:变量在定义时使用了"override",则后续对它值进行追加时,
# 也需要使用带有"override"指示符的追加方式。否则对此变量值的追加不会生效。
# 使用"define"定义变量时同样也可以使用"override"进行声明
override define foo
bar
endef


# 使用"define"定义的变量和使用"="定义的变量一样,属于"递归展开"式的变量
# 目标指定变量TARGET ... : VARIABLE-ASSIGNMENT
prog : CFLAGS = -g
prog : prog.o foo.o bar.o
# 这个例子中,无论 Makefile 中的全局变量"CFLAGS"的定义是什么。
# 对于目标"prog"以及其所引发的所有(包含目标为"prog.o"、"foo.o"和"bar.o"的所有规则)规则,变量"CFLAGS"值都是"-g"。

# 使用目标指定变量可以实现对于不同的目标文件使用不同的编译参数。TARGET ... : VARIABLE=ASSIGNMENT看一个例子:
# sample Makefile
CUR_DIR = $(shell pwd)
INCS := $(CUR_DIR)/include
CFLAGS := -Wall –I$(INCS)
EXEF := foo bar
.PHONY : all clean
all : $(EXEF)
foo : foo.c
foo : CFLAGS+=-O2
bar : bar.c
bar : CFLAGS+=-g
...........
...........
$(EXEF) : debug.h
$(CC) $(CFLAGS) $(addsuffix .c,$@) –o $@
clean :
$(RM) *.o *.d $(EXES)

# $(addsuffix .c,$@)


# 模式指定变量
# 和目标指定变量语法的唯一区别就是:这里的目标是一个或者多个"模式"目标(包含模式字符"%")。
# 我们可以为所有的.o 文件指定变量"CFLAGS"的值:
%.o : CFLAGS += -O

