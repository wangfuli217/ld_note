all: time.so

time.so: time.c
	gcc -o time.so -shared -fPIC time.c

clean: 
	rm -f *.o *.so