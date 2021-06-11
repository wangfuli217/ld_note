#include "common.h"
#include <assert.h>
#include <limits.h>

int main(int argc, char *argv[]){
    const char* file = argv[1];
    printf("file %s", file);

    lua_State *L = luaL_newstate();
    assert(L);

    luaL_openlibs(L);


    load_file(L, file);

    lua_close(L);
    return 0;
}