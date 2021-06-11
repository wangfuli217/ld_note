#include <stdio.h>
#include "helper.h"
#include "lauxlib.h"
#include "lualib.h"

int reverse(lua_State *L){
    int nargs = lua_gettop(L);
    for(int i=nargs;i>=1;i--){
        lua_pushvalue(L,i);
    }
    return nargs;
}

int main() {
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);
    lua_pushcfunction(L,reverse);
    lua_setglobal(L,"reverse");
    if(luaL_loadfile(L,"./test.lua") || lua_pcall(L,0,0,0) ){
        error("error load file %s",lua_tostring(L,-1));
    }
    lua_close(L);
    return 0;
}