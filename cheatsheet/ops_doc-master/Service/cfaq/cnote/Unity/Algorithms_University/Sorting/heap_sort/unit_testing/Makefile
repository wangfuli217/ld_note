
UNITY_PATH=../../../C/Unity-master
UNITY_INCLUDE_PATH=$(UNITY_PATH)/src
UNITY_SRC=$(UNITY_PATH)/src/unity.c
UNITY_GENERATOR=ruby $(UNITY_PATH)/auto/generate_test_runner.rb
CC=gcc

CFLAGS=-I$(UNITY_INCLUDE_PATH) -std=c99

.PHONY: clean

all: heap_sort_test

clean:
	$(RM) heap_sort_test
	$(RM) heap_sort_test_Runner.c

heap_sort_test: heap_sort_test_Runner.c ../heap_sort.c ../heap_sort.h heap_sort_test.c
	$(CC) $(CFLAGS) -o heap_sort_test heap_sort_test_Runner.c	../heap_sort.c heap_sort_test.c $(UNITY_SRC)

heap_sort_test_Runner.c:
	$(UNITY_GENERATOR) heap_sort_test.c
