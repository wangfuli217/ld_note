g++ test_lua.cpp -llua -lm  -ldl -o test_lua
./test_lua
g++ test_table.cpp -llua -lm  -ldl -o test_table
./test_table
g++ test_table2.cpp -llua -lm  -ldl -o test_table2
./test_table2
g++ lua_pcall.cpp -llua -lm  -ldl -o lua_pcall
./lua_pcall