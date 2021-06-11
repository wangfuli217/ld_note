main : main.o
	cc   main.o   -o main

main.o : main.c
	cc    -c -o main.o main.c

include two.mk
include three.mk
include one.mk

# ignore error
-include four.mk

.PHONY : TEST
TEST : ONE TWO THREE
	@echo "test\n"

