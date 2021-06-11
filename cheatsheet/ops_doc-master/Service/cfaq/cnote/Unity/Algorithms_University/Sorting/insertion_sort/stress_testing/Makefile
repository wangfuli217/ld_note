
CC=gcc

CFLAGS=-std=c99 -O2

.PHONY: clean

all: insertion_sort_test

clean:
	$(RM) insertion_sort_test

insertion_sort_test: test.c test.h file.c file.h ../insertion_sort.c ../insertion_sort.h insertion_sort_stress.c
	$(CC) $(CFLAGS) -o insertion_sort_test test.c file.c ../insertion_sort.c insertion_sort_stress.c 

