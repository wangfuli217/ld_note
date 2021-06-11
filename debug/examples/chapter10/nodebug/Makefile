# Makefile Copyright 2008 Groetker, Holtmann, Keding, Wloka

include ../../Makefile.include

nodebug:
	gcc -Wall -O -c nodebug.c
	gcc -Wall -g -c main.c 
	gcc -o nodebug main.o nodebug.o

clean:
	rm -rf $(CLEAN_TARGETS) nodebug
