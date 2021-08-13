#include <stdio.h>
#include <string.h>
#include <lua.hpp>
#include <lauxlib.h>
#include <lualib.h>

int main(void)
{
    const char* buff = "print(\"hello\")";
    int error;
    lua_State* L = luaL_newstate();
    luaL_openlibs(L);

    error = luaL_loadbuffer(L,buff,strlen(buff),"line") || lua_pcall(L,0,0,0);
    int s = lua_gettop(L);
    if (error) {
        fprintf(stderr,"%s",lua_tostring(L,-1));
        lua_pop(L,1);
    }
    lua_close(L);
    return 0;
}