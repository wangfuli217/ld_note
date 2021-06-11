all: parser

clean:
	rm parser.cpp parser.hpp parser tokens.cpp

parser.cpp: parser.y
	bison -d -o $@ $^

parser.hpp: parser.cpp

tokens.cpp: tokens.l
	flex -o $@ $^

parser: parser.cpp tokens.cpp node.cpp main.cpp
	#g++ -o $@ `llvm-config --libs core jit native --cxxflags --ldflags` *.cpp
	g++ -o $@ -std=c++11 -Wno-deprecated-register -L/usr/local/lib -I /usr/local//Cellar/llvm/5.0.1/include/ $^

