#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

static int lcounter(lua_State* L) {
    //获取第一个upvalue的值。
    int val = lua_tointeger(L,lua_upvalueindex(1));
    //将得到的结果压入栈中。
    lua_pushinteger(L,++val);
    //赋值一份栈顶的数据，以便于后面的替换操作。
    lua_pushvalue(L,-1);
    //该函数将栈顶的数据替换到upvalue(1)中的值。同时将栈顶数据弹出。
    lua_replace(L,lua_upvalueindex(1));
    //lua_pushinteger(L,++value)中压入的数据仍然保留在栈中并返回给Lua。
    return 1;
}

static int lnewCounter(lua_State* L) {
    //压入一个upvalue的初始值0，该函数必须先于lua_pushcclosure之前调用。
    lua_pushinteger(L,0);
    //压入闭包函数，参数1表示该闭包函数的upvalue数量。该函数返回值，闭包函数始终位于栈顶。
    lua_pushcclosure(L,lcounter,1);
    return 1;

}

int luaopen_testupvalue(lua_State* L) {
    luaL_Reg l[] = {
        {"counter", lcounter},
        {"newCounter", lnewCounter},
        {NULL, NULL}
    };

    luaL_checkversion(L);
    luaL_newlib(L, l);
    return 1;
}