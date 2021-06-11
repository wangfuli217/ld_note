# between foo and bar is a space
source := foo bar

# between foo and bar is a [tab] 
source2 := foo	bar

# between foo and bar is two space
source3 := foo  bar

# findstring will compare space and tab strictly
result := $(findstring foo,$(source))
result2 := $(findstring $(source2),$(source))
result3 := $(findstring $(source3),$(source))

all :
	echo "result = $(result)"
	echo "result2 = $(result2)"
	echo "result3 = $(result3)"
