# makefile for sample cpputest

CPPUTEST_HOME = /usr/local

CC      := gcc
CFLAGS    := -g -Wall
CFLAGS  += -std=c99
CFLAGS  += -D CPPUTEST            # 编译测试文件时, 忽略sample.c的main函数, sample.c的代码中用了宏CPPUTEST

# CPPUTest 是C++写的, 所以用 g++ 来编译 测试文件
CPP     := g++
CPPFLAGS  := -g -Wall
CPPFLAGS  += -I$(CPPUTEST_HOME)/include

LDFLAGS := -L$(CPPUTEST_HOME)/lib -lCppUTest


sample: sample.o

sample.o: sample.h sample.c
	$(CC) -c -o sample.o sample.c $(CFLAGS)

# 追加的测试程序编译
test: test.o sample.o
	$(CPP) -o $@ test.o sample.o $(LDFLAGS)

test.o: sample.h test.c
	$(CPP) -c -o test.o test.c $(CPPFLAGS)


.PHONY: clean
clean:
	@echo "clean..."
	rm -f test sample
	rm -f sample.o test.o