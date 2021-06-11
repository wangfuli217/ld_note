# Makefile Copyright 2008 Groetker, Holtmann, Keding, Wloka

include ../../Makefile.include

myprog:
	gcc -Wall -g -fPIC -c util1.c
	gcc -shared -o libutil1.so util1.o
	gcc -Wall -g -fPIC -c util2.c
	gcc -shared -o libutil2.so util2.o
	gcc -Wall -o myprog -g main.c libutil1.so -ldl

clean:
	rm -rf $(CLEAN_TARGETS) myprog *.so
