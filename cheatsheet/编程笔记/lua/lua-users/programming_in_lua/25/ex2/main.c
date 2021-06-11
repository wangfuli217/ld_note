//
// Created by 范鑫磊 on 17/2/7.
//


#include "lua.h"
#include "lauxlib.h"
#include "helper.h"

int main(void){

    lua_State *L = luaL_newstate();
    lua_pushnumber(L,3.5);
    lua_pushstring(L,"hello");
    lua_pushnil(L);
    lua_pushvalue(L,2);

    lua_remove(L,1);

    lua_insert(L,-2);
    dumpStack(L);

    lua_close(L);
    return 0;
}