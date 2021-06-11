

bison -d -o parser.cpp parser.y
flex -o tokens.cpp tokens.l
g++ -std=c++11 -Wno-deprecated-register -L/usr/local/lib -I /usr/local//Cellar/llvm/5.0.1/include/ -o parser parser.cpp tokens.cpp codegen.cpp main.cpp

