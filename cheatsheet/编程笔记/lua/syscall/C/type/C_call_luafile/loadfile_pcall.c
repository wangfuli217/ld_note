#include <stdio.h>
#include <string.h>

extern "C"
{
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
}
int main(int argc, char* argv[])
{
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);  // 加载Lua通用扩展库

    if(luaL_loadfile(L,"test.lua"||lua_pcall(L,0,0,0))  //或luaL_dofile(L,"test.lua")
        printf("error pcall!: %s\n",lua_tostring(L,-1));
    // 前面搭建了运行环境,lua代码写在了test.lua文件中
    // ......
    //
    lua_close(L);
    return 0;
}      