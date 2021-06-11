
UNITY_PATH=../../../C/Unity-master
UNITY_INCLUDE_PATH=$(UNITY_PATH)/src
UNITY_SRC=$(UNITY_PATH)/src/unity.c
UNITY_GENERATOR=ruby $(UNITY_PATH)/auto/generate_test_runner.rb
CC=gcc

CFLAGS=-I$(UNITY_INCLUDE_PATH) -std=c99

.PHONY: clean

all: merge_sort_test

clean:
	$(RM) merge_sort_test
	$(RM) merge_sort_test_Runner.c

merge_sort_test: merge_sort_test_Runner.c ../merge_sort.c ../merge_sort.h merge_sort_test.c
	$(CC) $(CFLAGS) -o merge_sort_test merge_sort_test_Runner.c	../merge_sort.c merge_sort_test.c $(UNITY_SRC)

merge_sort_test_Runner.c:
	$(UNITY_GENERATOR) merge_sort_test.c
