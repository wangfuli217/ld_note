//
// Created by 范鑫磊 on 17/2/8.
//
#include "helper.h"
#include "lua.h"
#include "lauxlib.h"
#include "stdlib.h"

void load(lua_State *L,const char *filename,int *w,int *h){
    if ( luaL_loadfile(L,filename) || lua_pcall(L,0,0,0) )
        error(L,"cannot run config lua %s",lua_tostring(L,-1));
}

int main(){

    lua_State *L = luaL_newstate();
    int w,h;
    load(L,"./config.lua",&w,&h);
    lua_getglobal(L,"f");
    lua_pushnumber(L,2);
    if(LUA_OK == lua_pcall(L,1,1,0)){
        int r = lua_tonumber(L,-1);
        printf("result = %i",r);
    }
    lua_close(L);
    return EXIT_SUCCESS;
}

