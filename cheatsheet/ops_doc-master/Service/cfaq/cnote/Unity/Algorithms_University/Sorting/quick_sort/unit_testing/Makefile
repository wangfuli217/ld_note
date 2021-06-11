
UNITY_PATH=../../../C/Unity-master
UNITY_INCLUDE_PATH=$(UNITY_PATH)/src
UNITY_SRC=$(UNITY_PATH)/src/unity.c
UNITY_GENERATOR=ruby $(UNITY_PATH)/auto/generate_test_runner.rb
CC=gcc

CFLAGS=-I$(UNITY_INCLUDE_PATH) -std=c99

.PHONY: clean

all: quick_sort_test

clean:
	$(RM) quick_sort_test
	$(RM) quick_sort_test_Runner.c

quick_sort_test: quick_sort_test_Runner.c ../quick_sort.c ../quick_sort.h quick_sort_test.c
	$(CC) $(CFLAGS) -o quick_sort_test quick_sort_test_Runner.c	../quick_sort.c quick_sort_test.c $(UNITY_SRC)

quick_sort_test_Runner.c:
	$(UNITY_GENERATOR) quick_sort_test.c
