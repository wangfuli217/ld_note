//
// Created by 范鑫磊 on 17/2/9.
//
#include "helper.h"
#include "lauxlib.h"
#include "lualib.h"
static int l_filter(lua_State *L){
    luaL_checktype(L,1,LUA_TTABLE);
    luaL_checktype(L,2,LUA_TFUNCTION);
    lua_len(L,1);
    int len = lua_tointeger(L,-1);
    lua_pop(L,1);
    lua_pushvalue(L,-1); // table func func
    for(int i=1;i<=len;i++){
        lua_rawgeti(L,1,i); // table func func val
        lua_call(L,1,1);
        lua_rawseti(L,1,i);
        lua_pushvalue(L,-1);
    }

    return 1;
}

int main(){
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);
    lua_pushcfunction(L,l_filter);
    lua_setglobal(L,"filter");
    if(luaL_loadfile(L,"./test.lua") || lua_pcall(L,0,0,0)){
        error(L,"error load file %s",lua_tostring(L,-1));
    }
    lua_close(L);
    return 0;
}