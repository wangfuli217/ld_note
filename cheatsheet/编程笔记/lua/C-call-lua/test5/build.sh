g++ lua_test.cpp -llua -lm  -ldl -o lua_test
./lua_test
g++ -shared -fPIC test_so.cpp -o test_so.so
