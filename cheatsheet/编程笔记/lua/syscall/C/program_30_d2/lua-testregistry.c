#include <stdio.h>
#include <stdlib.h>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

static int lregistry_test(lua_State* L){
    lua_pushstring(L, "Hello");
    lua_setfield(L, LUA_REGISTRYINDEX, "key1");
    /*
    lua_getfield(L, LUA_REGISTRYINDEX, "key1");
    printf("%s\n", lua_tostring(L, -1));
    */
    return 1;
}

int luaopen_registrytest(lua_State* L){
    luaL_Reg l[] = {
        {"registry_func", lregistry_test},
        {NULL, NULL}
    };
    luaL_checkversion(L);
    luaL_newlib(L, l);
    return 1;
}