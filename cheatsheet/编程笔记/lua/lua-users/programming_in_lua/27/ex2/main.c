#include <stdio.h>
#include "helper.h"
#include "lauxlib.h"
#include "lualib.h"

int pack(lua_State *L){
    int nargs = lua_gettop(L);
    lua_newtable(L);
    for(int i = 1;i<=nargs;i++){
        lua_pushinteger(L,i);
        lua_pushvalue(L,i);
        lua_settable(L,-3);
    }
    return 1;
}

int main() {

    lua_State *L = luaL_newstate();
    luaL_openlibs(L);
    lua_pushcfunction(L,pack);
    lua_setglobal(L,"pack");
    if(luaL_loadfile(L,"./test.lua") || lua_pcall(L,0,0,0)){
        error("error load file %s",lua_tostring(L,-1));
    }
    lua_close(L);
    return 0;
}