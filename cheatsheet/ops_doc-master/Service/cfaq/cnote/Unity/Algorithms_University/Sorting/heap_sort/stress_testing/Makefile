
CC=gcc

CFLAGS=-std=c99 -O2

.PHONY: clean

all: heap_sort_test

clean:
	$(RM) heap_sort_test

heap_sort_test: test.c test.h file.c file.h ../heap_sort.c ../heap_sort.h heap_sort_stress.c
	$(CC) $(CFLAGS) -o heap_sort_test test.c file.c ../heap_sort.c heap_sort_stress.c 

