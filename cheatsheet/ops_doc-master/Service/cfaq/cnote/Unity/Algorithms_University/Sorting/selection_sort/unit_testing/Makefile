
UNITY_PATH=../../../C/Unity-master
UNITY_INCLUDE_PATH=$(UNITY_PATH)/src
UNITY_SRC=$(UNITY_PATH)/src/unity.c
UNITY_GENERATOR=ruby $(UNITY_PATH)/auto/generate_test_runner.rb
CC=gcc

CFLAGS=-I$(UNITY_INCLUDE_PATH) -std=c99

.PHONY: clean

all: selection_sort_test

clean:
	$(RM) selection_sort_test
	$(RM) selection_sort_test_Runner.c

selection_sort_test: selection_sort_test_Runner.c ../selection_sort.c ../selection_sort.h selection_sort_test.c
	$(CC) $(CFLAGS) -o selection_sort_test selection_sort_test_Runner.c	../selection_sort.c selection_sort_test.c $(UNITY_SRC)

selection_sort_test_Runner.c:
	$(UNITY_GENERATOR) selection_sort_test.c
