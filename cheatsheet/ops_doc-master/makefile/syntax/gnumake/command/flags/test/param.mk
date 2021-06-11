#  --------- redefine is ok 
# fooValue = foo
# barValue = bar

all:
	echo "subdir : $(value)"
	echo "subdir fooValue: $(fooValue)"
	echo "subdir barValue: $(barValue)"
	echo "subdir: MAKELEVEL=" $(MAKELEVEL)
	echo "subdir: MAKEFLAGS=" $(MAKEFLAGS)
	echo "subdir: MAKEOVERRIDES=" $(MAKEOVERRIDES)
