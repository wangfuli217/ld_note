#include <stdio.h>
#include <string.h>
#include <lua.hpp>
#include <lauxlib.h>
#include <lualib.h>

const char* lua_function_code = "function add(x,y) return x + y end";

void call_function(lua_State* L) 
{
    //luaL_dostring 等同于luaL_loadstring() || lua_pcall()
    //注意：在能够调用Lua函数之前必须执行Lua脚本，否则在后面实际调用Lua函数时会报错，
    //错误信息为:"attempt to call a nil value."
    if (luaL_dostring(L,lua_function_code)) {
        printf("Failed to run lua code.\n");
        return;
    }
    double x = 1.0, y = 2.3;
    lua_getglobal(L,"add");
    lua_pushnumber(L,x);
    lua_pushnumber(L,y);
    //下面的第二个参数表示带调用的lua函数存在两个参数。
    //第三个参数表示即使带调用的函数存在多个返回值，那么也只有一个在执行后会被压入栈中。
    //lua_pcall调用后，虚拟栈中的函数参数和函数名均被弹出。
    if (lua_pcall(L,2,1,0)) {
        printf("error is %s.\n",lua_tostring(L,-1));
        return;
    }
    //此时结果已经被压入栈中。
    if (!lua_isnumber(L,-1)) {
        printf("function 'add' must return a number.\n");
        return;
    }
    double ret = lua_tonumber(L,-1);
    lua_pop(L,-1); //弹出返回值。
    printf("The result of call function is %f.\n",ret);
}

int main()
{
    lua_State* L = luaL_newstate();
    call_function(L);
    lua_close(L);
    return 0;
}