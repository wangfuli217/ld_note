//
// Created by 范鑫磊 on 17/2/13.
//
#include <stdio.h>
#include <dirent.h>
#include "helper.h"
#include "lauxlib.h"
#include "lualib.h"

static int l_iter(lua_State *L){
    DIR **d = (DIR **)luaL_checkudata(L,lua_upvalueindex(1),"Ex.dir");
    if(*d == NULL){
        return 0;
    }
    struct dirent *entry = readdir(*d);
    if(entry != NULL){
        lua_pushstring(L,entry->d_name);
        return 1;
    }
    closedir(*d);
    *d = NULL;
    return 0;
}

static int l_gc(lua_State *L){
    DIR **d = (DIR **)luaL_checkudata(L,1,"Ex.dir");
    if(*d == NULL){
        return 0;
    }
    closedir(*d);
    return 0;
}

static int l_open(lua_State *L){
    const char *path = luaL_checkstring(L,1);
    DIR **d = (DIR **)lua_newuserdata(L,sizeof(DIR *));
    luaL_setmetatable(L,"Ex.dir");
    *d = opendir(path);
    if (*d == NULL){
        luaL_error(L,"can not open %s",path);
    }
    lua_pushcclosure(L,l_iter,1);
    return 1;
}

static const luaL_Reg funcs[] = {
        {"open",l_open},
        { NULL, NULL}
};


static int luaopen_dir(lua_State *L){
    luaL_newmetatable(L,"Ex.dir");
    lua_pushcfunction(L,l_gc);
    lua_setfield(L,-2,"__gc");
    luaL_newlib(L,funcs);
    return 1;
}

int main(){
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);
    lua_getglobal(L,"package");
    lua_getfield(L,-1,"preload");
    lua_pushcfunction(L,luaopen_dir);
    lua_setfield(L,-2,"dir");
    if(luaL_loadfile(L,"./test.lua") || lua_pcall(L,0,0,0)){
        error(L,"error load file %s",lua_tostring(L,-1));
    }
    lua_close(L);
    return 0;
}