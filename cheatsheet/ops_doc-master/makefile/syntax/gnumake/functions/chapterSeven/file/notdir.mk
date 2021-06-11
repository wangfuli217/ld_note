# file or space
sources := include/inc.h src/foo.c debug/ tools/calc.c main.c debug/ test/
files := $(notdir $(sources))

# debug/  ==> space
all :
	echo "files = ___$(files)___"
