# Makefile
#
# This file is written for use on Mac OS X.
#

all: apidemo.so

apidemo.so: apidemo.c
	gcc  -O2 --std=gnu99  -fPIC -c -o apidemo.o apidemo.c
	gcc  -shared -o apidemo.so apidemo.o

clean:
	rm apidemo.so
	rm apidemo.o
