
CC=gcc

CFLAGS=-std=c99 -O2

.PHONY: clean

all: merge_sort_test

clean:
	$(RM) merge_sort_test

merge_sort_test: test.c test.h file.c file.h ../merge_sort.c ../merge_sort.h merge_sort_stress.c
	$(CC) $(CFLAGS) -o merge_sort_test test.c file.c ../merge_sort.c merge_sort_stress.c 

