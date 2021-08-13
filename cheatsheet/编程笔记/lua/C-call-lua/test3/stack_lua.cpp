#include <stdio.h>
#include <string.h>
#include <lua.hpp>
#include <lauxlib.h>
#include <lualib.h>

static void stackDump(lua_State* L) 
{
    int top = lua_gettop(L);
    for (int i = 1; i <= top; ++i) {
        int t = lua_type(L,i);
        switch(t) {
        case LUA_TSTRING:
            printf("'%s'\t",lua_tostring(L,i));
            break;
        case LUA_TBOOLEAN:
            printf(lua_toboolean(L,i) ? "true\t" : "false\t");
            break;
        case LUA_TNUMBER:
            printf("%g\t",lua_tonumber(L,i));
            break;
        default:
            printf("%s\t",lua_typename(L,t));
            break;
        }
        printf("");
    }
    printf("\n");
}

int main()
{
    lua_State* L = luaL_newstate();
    lua_pushboolean(L,1);
    lua_pushnumber(L,10);
    lua_pushnil(L);
    lua_pushstring(L,"hello");
    stackDump(L); //true 10 nil 'hello'

    lua_pushvalue(L,-4);
    stackDump(L); //true 10 nil 'hello' true

    lua_replace(L,3);
    stackDump(L); //true 10 true 'hello'

    lua_settop(L,6);
    stackDump(L); //true 10 true 'hello' nil nil

    lua_remove(L,-3);
    stackDump(L); //true 10 true nil nil

    lua_settop(L,-5);
    stackDump(L); //true

    lua_close(L);
    return 0;
}