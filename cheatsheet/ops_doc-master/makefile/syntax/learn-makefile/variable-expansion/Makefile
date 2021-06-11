# like macro substitute in C
# 像是 C 语言中的宏
C = c

prog.o: prog.$(C)
	$(C)$(C) -$(C) prog.$(C)

# substitute when is used
# Recursive expansion
# 这种类型变量在定义时,可以引用其它的之前没有定义的变量。可能在后续部分定义，或者是通过 make 的命令行选项传递的变量
foo = $(bar)
bar = $(ugh)
ugh = Huh?

substitute:
	echo $(foo)

CFLAGS = $(include_dirs) -O
include_dirs = -Ifoo -Ibar
expansion:
	echo $(CFLAGS)

# 防止递归定义: (递归定义而导致 make 陷入到无限的变量展开过程中，最终使 make 执行失败)         递归定义
# recursive defination error
## 递归定义错误 形式1
# CFLAGS = $(CFLAGS) –O
## 递归定义错误 形式2
# x = $(y)
# y = $(x) $(z)
recurive:
	echo $(CFLAGS)

# Simple expansion ·
D := foo
E := $(D) bar
D := ugh
# foo bar
simle-extend-variables:
	@echo $(E)

# Define a variable that content is a space
nullstring :=
space := $(nullstring) # end of the line
a-space:
	@echo nullstring: @$(nullstrnig)@
	@echo space: @$(space)@

# conditional variable assignment
c1 = foo
c1 ?= bar
conditional1:
	@echo $(c1)

c2 ?= bar
conditional2:
	@echo $(c2)

# Substitution reference
# 	${var:a=b}		take the value of the variable var, replace every
# 	a at the end of word with b in that value, and substitue the
# 	resulting string
o1 := a.o b.o c.o
s1 := $(o1:o=c)
substitution1:
	@echo $(o1)
	@echo $(s1)

# Static substitution
s2 := $(o1:%.o=%.c)
substitution2:
	@echo $(o1)
	@echo $(s2)

# Substitution example
x = $(y)
y = z
z = Furzoom
a := $($(x))
e1:
	@echo $(a) # Furzoom

v1 = variable1
variable2 := Furzoom
v2 = $(subst 1,2,$(v1))
v3 = v2
v4 := $($($(v3)))
e2:
	@echo $(v4) # Furzoom

first_second = Furzoom
prefix = first
suffix = second
result := $($(prefix)_$(suffix))
e3:
	@echo $(result) # Furzoom

# Append to variable
obj = a.o b.o
obj += c.o
obj:
	@echo $(obj)

clean:
	$(RM) prog.o

