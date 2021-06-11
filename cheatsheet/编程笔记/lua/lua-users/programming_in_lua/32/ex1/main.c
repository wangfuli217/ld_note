//
// Created by 范鑫磊 on 17/2/14.
//

#include <stdlib.h>
#include "helper.h"
#include "lauxlib.h"
#include "lualib.h"

typedef struct meminfo{
    int used;
    int limit ;
}meminfo;


void *my_alloc (void *ud, void *ptr, size_t osize,size_t nsize){
    meminfo *info = (meminfo *)ud;
    if(nsize == 0){
        if(ptr)
            info->used -= osize;
        free(ptr);
        return NULL;
    }else{
        if(info->used + nsize > info->limit){
            return NULL;
        }
        info->used -= osize;
        info->used += nsize;
        return realloc(ptr,nsize);
    }
}

static int l_setlimit(lua_State *L){
    int nlimit = lua_tointeger(L,-1);
    meminfo *info;
    lua_getallocf(L,(void **)&info);
    info->limit = nlimit;
    return 0;
}

static int l_getused(lua_State *L){
    meminfo *info;
    lua_getallocf(L,(void **)&info);
    lua_pushinteger(L,info->used);
    return 1;
}

static int l_getgc(lua_State *L){
    int bytes = (lua_gc(L,LUA_GCCOUNT,0) * 1024) + lua_gc(L,LUA_GCCOUNTB,0);
    lua_pushinteger(L,bytes);
    return 1;
}

const static luaL_Reg funcs[] = {
        {"setlimit",l_setlimit},
        {"getused",l_getused},
        {"getgc",l_getgc},
        {NULL,NULL}
};

static int luaopen_mem(lua_State *L){
    luaL_newlib(L,funcs);
    return 1;
}

int main(){
    meminfo info;
    info.used = 0;
    info.limit= 100000;

    lua_State *L = lua_newstate(my_alloc, (void *)&info);
    luaL_openlibs(L);
    lua_getglobal(L,"package");
    lua_getfield(L,-1,"preload");
    lua_pushcfunction(L,luaopen_mem);
    lua_setfield(L,-2,"mem");

    if(luaL_loadfile(L,"./test.lua") || lua_pcall(L,0,0,0)){
        error(L,"error load file %s",lua_tostring(L,-1));
    }
    lua_close(L);
    return 0;
}