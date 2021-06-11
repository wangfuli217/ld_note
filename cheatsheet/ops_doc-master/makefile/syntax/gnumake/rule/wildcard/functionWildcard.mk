# if foo.o main.o is not exist,
# * will be really *.o, not foo.o main.o
# so please use function $(wildcard ......)

object1 = *.c
count1 = $(words $(object1))

object2 = $(wildcard *.c)
count2 = $(words $(object2))

objs = $(patsubst %c,%o,$(wildcard *.c))

ok : $(objs)
	cc   $(objs)   -o main

# count1 == 1, count2 == 2
test:
	echo count1 = $(count1)
	echo count2 = $(count2)

error : *.o
	cc   *.o   -o main


# use default regulars for .c ==> .o
#foo.o : foo.c
#	cc    -c -o foo.o foo.c
#main.o : main.c
#	cc    -c -o main.o main.c
	

clean :
	-rm *.o
	-rm main
