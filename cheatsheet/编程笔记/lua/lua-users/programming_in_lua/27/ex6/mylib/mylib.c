//
// Created by 范鑫磊 on 17/2/9.
//
#include "lua.h"
#include <stdio.h>
#include "lauxlib.h"
static int test1(lua_State *L){
    printf("test1");
    return 0;
}

static int test2(lua_State *L){
    printf("test2");
    return 0;
}


static const struct luaL_Reg mylib[] = {
        {"test1",test1},
        {"test2",test2},
        {NULL,NULL}
};

int luaopen_libmylib(lua_State *L){
    luaL_newlib(L,mylib);
    return 1;
}