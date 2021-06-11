# 1) 
# only replace the words end with o,  not all the o
# please focus on o.o ooo 
foo := a.o b.o c.o o.o ooo
bar := $(foo:.o=.c)
hei := $(foo:o=c)

variable_dot :
	@echo "bar="$(bar)
	@echo "hei="$(hei)
#bar=a.c b.c c.c o.c ooo
#hei=a.c b.c c.c o.c ooc

# 2) 
# same as .o=.c , aa.s.c
x := a.s b.s c.s aa.s.c
y := $(x:%.s=%.c)
variable_fmt :
	@echo "y="$(y)

a = variable1
variable2 := hello
b = $(subst 1,2,$(a))
c = b
d := $($($(c)))
# d := $($(subst 1,2,variable1))

reference_recursive :
	@echo "b="$(b)
	@echo "c="$(c)
	@echo "d="$(d)
	@echo "x="$(subst 1,2,variable1)

# 3) 
# function
# sorted don't work as a sorted list, it's empty
func := sort

unsort := a d b g q c
sorted := $($(func) $(unsort))

function_sort :
	echo "sorted="$(sorted)
	echo "sort2="$(sort a b d g q c)





