# if foo.o main.o is not exist,
# * will be really *.o, not foo.o main.o
# so please use function $(wildcard ......)
error : *.o
	cc   *.o   -o main

ok : foo.o main.o
	cc   *.o   -o main
	
foo.o : foo.c
	cc    -c -o foo.o foo.c

main.o : main.c
	cc    -c -o main.o main.c
	
