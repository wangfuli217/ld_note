# suffix
sources := include/inc.h src/foo.c debug/ tools/calc.c main.c debug/ test/ debug.s
suffixs := $(suffix $(sources))

all :
	echo "suffixs = ___$(suffixs)___"
	echo "suffixs = ___$(sort $(suffixs))___"
