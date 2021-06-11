CC=gcc
CXX=g++

FLAGS= -g -Werror -Wall -Wextra
CFLAGS=-std=c99 $(FLAGS)
CXXFLAGS=-std=c++11 $(FLAGS)


EXAMPLES=ex1 ex2 ex3 ex4 ex5 ex6 ex7 ex8 ex9 ex10 ex11 ex12 ex13 ex14 ex21 ex22 ex23

%: %.c
	$(CC) $(CFLAGS) $< -o $@ -lm

%: %.cpp
	$(CXX) $(CXXFLAGS) $< -o $@ -lm

all: $(EXAMPLES)

clean:
	rm -rf $(EXAMPLES)
