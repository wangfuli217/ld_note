#include <stdlib.h>
#include "lua.h"
#include <lualib.h>
#include <lauxlib.h>


int main(){
    lua_State *L = luaL_newstate();  
    luaL_openlibs(L);
    luaL_dofile(L,"Foo.lua");
    lua_getglobal(L,"foo");
    printf("stack size:%d,%s\n",lua_gettop(L),lua_typename(L, lua_type(L,-1)));
    // 存放函数到注册表中并返回引用
    int ref =  luaL_ref(L,LUA_REGISTRYINDEX);
    printf("stack size:%d\n",lua_gettop(L));

   // 从注册表中读取该函数并调用
    lua_rawgeti(L,LUA_REGISTRYINDEX,ref);
    printf("stack size:%d,%s\n",lua_gettop(L),lua_typename(L, lua_type(L,-1)));
   
    //printf("stack size:%d,%s\n",lua_gettop(L),lua_typename(L, lua_type(L,-1)));
    lua_pcall(L,0,0,0);
    printf("stack size:%d\n",lua_gettop(L));
    printf("------------------------华丽的分割线------------\n");

    lua_getglobal(L,"foo");
    printf("stack size:%d\n",lua_gettop(L));
    lua_setfield(L,LUA_REGISTRYINDEX,"sb");
    printf("stack size:%d\n",lua_gettop(L));
    lua_getfield(L,LUA_REGISTRYINDEX,"sb");
    lua_pcall(L,0,0,0);
    printf("------------------------又一次华丽的分割线------------\n");
    printf("stack size:%d,%s\n",lua_gettop(L),lua_typename(L, lua_type(L,-1)));
    luaL_unref(L,LUA_REGISTRYINDEX,ref);
    lua_rawgeti(L,LUA_REGISTRYINDEX,ref);
    printf("stack size:%d\n",lua_gettop(L));
    lua_getfield(L,LUA_REGISTRYINDEX,"sb");
    lua_pcall(L,0,0,0);
    lua_close(L);

   return 0;
}
