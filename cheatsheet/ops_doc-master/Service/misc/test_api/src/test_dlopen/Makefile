CC=gcc
all:
	$(CC) -ggdb3 -fPIC -shared -o hello.so hello.c
	$(CC) -o hello_dlopen hello_dlopen.c -ldl -ggdb3
clean:
	rm *.o *.so hello_dlopen
