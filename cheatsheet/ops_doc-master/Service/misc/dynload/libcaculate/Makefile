.PHONE : all

all : libcaculate.so test

libcaculate.so : caculate.o
	gcc -Wall -fPIC -shared $^ -o $@
test: test.o
	gcc -Wall -L./ -rdynamic $^ -o $@ -ldl
test.o : test.c
	gcc -c $<
caculate.o : caculate.c
	gcc -c $<

clean:
	rm -f *.so *.o test
