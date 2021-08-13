#include <stdio.h>
#include <string.h>
#include <lua.hpp>
#include <lauxlib.h>
#include <lualib.h>

void load(lua_State* L, const char* fname, int* w, int* h) {
    if (luaL_loadfile(L,fname) || lua_pcall(L,0,0,0)) {
        printf("Error Msg is %s.\n",lua_tostring(L,-1));
        return;
    }
    lua_getglobal(L,"width");
    lua_getglobal(L,"height");
    if (!lua_isnumber(L,-2)) {
        printf("'width' should be a number\n" );
        return;
    }
    if (!lua_isnumber(L,-1)) {
        printf("'height' should be a number\n" );
        return;
    }
    *w = lua_tointeger(L,-2);
    *h = lua_tointeger(L,-1);
}


int main()
{
    lua_State* L = luaL_newstate();
    int w,h;
    load(L,"test.lua",&w,&h);
    printf("width = %d, height = %d\n",w,h);
    lua_close(L);
    return 0;
}