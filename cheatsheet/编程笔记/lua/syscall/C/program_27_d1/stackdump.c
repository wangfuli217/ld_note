#include <stdio.h>

#include "lua.h"
#include "lauxlib.h"

static void stackdump(lua_State *L) {
    int top = lua_gettop(L);
    for (int i = 1; i <= top; i++) {
        int t = lua_type(L, i);
        switch(t) {
            case LUA_TSTRING:
            {
                printf("'%s'", lua_tostring(L, i));
                break;
            }
            case LUA_TBOOLEAN:
            {
                printf(lua_toboolean(L, i) ? "true" : "false");
                break;
            }
            case LUA_TNUMBER:
            {
                printf("%g", lua_tonumber(L, i));
                break;
            }
            default:
            {
                printf("%s", lua_typename(L, t));
                break;
            }
        }

        printf("  ");
    }
    printf("\n");
}

int main() {
    lua_State *L = luaL_newstate();

    lua_pushboolean(L, 1);
    lua_pushnumber(L, 10);
    lua_pushnil(L);
    lua_pushstring(L, "hello");

    stackdump(L);
    lua_pushvalue(L, -4); // 将指定索引上的元素的副本 压入栈
    stackdump(L);

    lua_replace(L, 3); // 把栈顶元素放置到给定位置而不移动其它元素(因此覆盖了那个位置处的值)，然后将栈顶元素弹出。
    stackdump(L);

    // 将栈顶设置为一个指定的值，即修改栈中的元素数量
    //如果之前的栈顶比新设置的更高，那么高出来的这些元素就会被丢弃；反之，该函数会向栈中压入nil来补足大小
    //特别的，函数lua_settop(L,0) 用于清空栈
    lua_settop(L, 6);
    stackdump(L);

    // 用于删除指定索引的元素，并将该位置上的所有元素下移以填空补缺
    lua_remove(L, -3);
    stackdump(L);

    lua_settop(L, -5);
    stackdump(L);

    /*
    lua_remove(L, -20);
    stackdump(L);
    */
    lua_settop(L, 0);
    stackdump(L);

// -------------------------------------------------------------------------- //
    lua_pushnumber(L, 3.5);
    stackdump(L);
    lua_pushstring(L, "hello");
    stackdump(L);
    lua_pushnil(L);
    stackdump(L);
    lua_pushvalue(L, -2);
    stackdump(L);
    lua_remove(L, 1);
    stackdump(L);
    lua_insert(L, -2);
    stackdump(L);

    lua_close(L);
    return 0;
}