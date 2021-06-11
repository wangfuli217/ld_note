#include <stdio.h>
#include <string.h>
#include <lua.hpp>
#include <lauxlib.h>
#include <lualib.h>

void load(lua_State* L) {

    if (luaL_loadstring(L,"background = { r = 0.30, g = 0.10, b = 0 }") 
        || lua_pcall(L,0,0,0)) {
        printf("Error Msg is %s.\n",lua_tostring(L,-1));
        return;
    }
    
    lua_getglobal(L,"background");
    if (!lua_istable(L,-1)) {
        printf("'background' is not a table.\n" );
        return;
    }
    
    lua_getfield(L,-1,"r");
    if (!lua_isnumber(L,-1)) {
        printf("Invalid component in background color.\n");
        return;
    }
    int r = (int)(lua_tonumber(L,-1) * 255);
    printf("r = %d\n",r);
    lua_pop(L,1);

    lua_getfield(L,-1,"g");
    if (!lua_isnumber(L,-1)) {
        printf("Invalid component in background color.\n");
        return;
    }
    int g = (int)(lua_tonumber(L,-1) * 255);
    printf("g = %d\n",g);
    lua_pop(L,1);
    
    
    lua_pushnumber(L,0.4);
    lua_setfield(L,-2,"b");

    lua_getfield(L,-1,"b");
    if (!lua_isnumber(L,-1)) {
        printf("Invalid component in background color.\n");
        return;
    }
    int b = (int)(lua_tonumber(L,-1) * 255);
    printf("b = %d\n",b);
    printf("r = %d, g = %d, b = %d\n",r,g,b);
    lua_pop(L,1);
    lua_pop(L,1);
    return;
}

int main()
{
    lua_State* L = luaL_newstate();
    load(L);
    lua_close(L);
    return 0;
}