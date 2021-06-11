# .LIBPATTERNS 's default value is :  lib%.so  lib%.a
# -lprint <==> libprint.so or  libprint.a
VPATH = ./

# if libprint.so exist, can use -lprint as prerequisite
# but if libprint.so is not existed. 
#main : main.c -lprint
main : main.c libprint.so
#	@cc -o main main.c -L . -lprint
#	@cc -o main main.c -L . -lprint
	@cc $^ -o $@

main.o : main.c
	@cc    -c -o main.o main.c

print.o : print.c
	@cc    -c -o print.o print.c

libprint.so : print.o
	@ar cr libprint.so print.o

clean :
	$(RM) libprint.so *.o main
