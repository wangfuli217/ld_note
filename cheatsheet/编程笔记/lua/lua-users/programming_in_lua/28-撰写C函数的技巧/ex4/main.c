//
// Created by 范鑫磊 on 17/2/10.
//


#include "helper.h"
#include "lauxlib.h"
#include "lualib.h"
static const char *Key = "lib.tbl";

int l_trans(lua_State *L){
    size_t len;
    const char *o = luaL_checklstring(L,1,&len);
    lua_rawgetp(L,LUA_REGISTRYINDEX,(const void *)&Key);
    luaL_Buffer b;
    char *p = luaL_buffinitsize(L,&b,len);
    int rlen = 0;
    for(int i = 0;i<len;i++){
        lua_pushlstring(L,o+i,1);
        const char * k = lua_tostring(L,-1);
        lua_getfield(L,2,k);
        int t = lua_type(L,-1);
        if( t == LUA_TSTRING ){
            const char *c = lua_tostring(L,-1);
            p[rlen]= (unsigned char)c[0];
            rlen++;
        }else if ( t == LUA_TBOOLEAN){
            int b = lua_toboolean(L,-1);
            if(b){
                p[rlen]= (unsigned char) o[i];
                rlen++;
            }
        }
    }

    luaL_pushresultsize(&b,rlen);

    return 1;
}

int l_settrans(lua_State *L){
    luaL_checktype(L,1,LUA_TTABLE);
    lua_rawsetp(L,LUA_REGISTRYINDEX,(const void *)&Key);
    return 0;
}

int l_gettrans(lua_State *L){
    lua_rawgetp(L,LUA_REGISTRYINDEX,(const void *)&Key);
    return 1;
}

int main(){
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);

    lua_newtable(L);
    lua_pushcfunction(L,l_settrans);
    lua_setfield(L,-2,"settrans");
    lua_pushcfunction(L,l_gettrans);
    lua_setfield(L,-2,"gettrans");

    lua_pushcfunction(L,l_trans);
    lua_setfield(L,-2,"trans");

    lua_setglobal(L,"lib");

    if(luaL_loadfile(L,"./test.lua") || lua_pcall(L,0,0,0)){
        error(L,"error load file %s",lua_tostring(L,-1));
    }

    lua_close(L);
    return 0;
}