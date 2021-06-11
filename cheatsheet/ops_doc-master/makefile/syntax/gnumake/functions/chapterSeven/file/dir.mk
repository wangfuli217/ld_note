sources := include/inc.h src/foo.c tools/calc.c main.c
paths := $(dir $(sources))

all :
	echo "paths = $(paths)"
