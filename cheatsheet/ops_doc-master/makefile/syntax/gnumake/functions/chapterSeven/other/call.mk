# $(call VARIABLE,PARAM,PARAM,...)
# VARIABLE is a name , not a reference .  eg. NAME nor $NAME 
# ********

#  1) = not :=
#  usually = , not :=  
# do a test with :=
reverse = $(2) $(1)
reverse2 := $(2) $(1)
foo = $(call reverse,red,blue)
foo2 = $(call reverse2,red,blue)

all :
	echo "foo = $(foo)"
	echo "foo2 = $(foo2)"


# 2)  a example
# firstword wildcard addsuffix subst 
# pathsearch,  =   not :=
pathsearch = $(firstword $(wildcard $(addsuffix /$(1),$(subst //,/,$(subst :, ,$(PATH))))))
LS := $(call pathsearch,ls)

testpathsearch :
	@echo $(PATH)
	@echo $(subst :, ,$(PATH))
	@echo $(subst //,/,$(subst :, ,$(PATH)))
	@echo $(addsuffix /ls,$(subst //,/,$(subst :, ,$(PATH))))
	@echo $(wildcard $(addsuffix /ls,$(subst //,/,$(subst :, ,$(PATH)))))
	@echo $(firstword $(wildcard $(addsuffix /ls,$(subst //,/,$(subst :, ,$(PATH))))))
	@echo $(LS)


# 3) function origin 
#
override CFLAG := -O2

inputs = \
	undefined_variable	\
	PATH	\
	MAKE	\
	pathsearch	\
	DEBUG	\
	CFLAG	\
	@	\
	<	\
	?

map = $(foreach var,$(2),$(call $(1),$(var)))
result = $(call map,origin,$(inputs))

#$ make -f call.mk testorigin 
#$ undefined environment default file undefined override automatic automatic automatic
#$ make -f call.mk testorigin DEBUG=1
#$ undefined environment default file command line override automatic automatic automatic

testorigin :
	@echo $(result)


