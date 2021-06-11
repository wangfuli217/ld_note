#include <stdio.h>
#include "helper.h"
#include "lauxlib.h"
#include "lualib.h"

int foreach(lua_State *L){
    luaL_checktype(L,-2,LUA_TTABLE);
    luaL_checktype(L,-1,LUA_TFUNCTION);
    lua_pushnil(L); // table func  nil

    while(lua_next(L,-3) != 0){ //table func key value
        lua_pushvalue(L,-3);
        lua_pushvalue(L,-3);
        lua_pushvalue(L,-3);
        lua_pcall(L,2,0,0);
        lua_pop(L,1);
    }
    return 0;
}

int main() {
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);
    lua_pushcfunction(L,foreach);
    lua_setglobal(L,"foreach");
    if(luaL_loadfile(L,"./test.lua") || lua_pcall(L,0,0,0)){
        error(L,"error load file %s",lua_tostring(L,-1));
    }
    lua_close(L);
    return 0;
}