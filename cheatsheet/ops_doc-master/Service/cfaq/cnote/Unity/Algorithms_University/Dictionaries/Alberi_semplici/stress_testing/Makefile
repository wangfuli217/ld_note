
CC=gcc

CFLAGS=-std=c99 -O2

.PHONY: clean

all: alberi_semplici_test

clean:
	$(RM) alberi_semplici_test

alberi_semplici_test: test.c test.h file.c file.h ../alberi_semplici.c ../alberi_semplici.h tree_stress.c
	$(CC) $(CFLAGS) -o alberi_semplici_test test.c file.c ../alberi_semplici.c tree_stress.c -lm

