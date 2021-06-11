
CC=gcc

CFLAGS=-std=c99 -O2

.PHONY: clean

all: quick_sort_test

clean:
	$(RM) quick_sort_test

quick_sort_test: test.c test.h file.c file.h ../quick_sort.c ../quick_sort.h quick_sort_stress.c
	$(CC) $(CFLAGS) -o quick_sort_test test.c file.c ../quick_sort.c quick_sort_stress.c 

