//
// Created by 范鑫磊 on 17/2/10.
//
// Write a transliterate function. This function receives a string and replaces each character in that string by another character,
// according to a table given as a second argument. If the table maps ‘a’ to ‘b’, the function should replace any occurrence of ‘a’ by ‘b’.
// If the table maps ‘a’ to false, the function should remove occurrences of ‘a’ from the resulting string.

#include "helper.h"
#include "lauxlib.h"
#include "lualib.h"
#include <string.h>
int l_trans(lua_State *L){
    size_t len;
    const char *o = luaL_checklstring(L,1,&len);
    luaL_checktype(L,2,LUA_TTABLE);
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

int main(){
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);

    lua_pushcfunction(L,l_trans);
    lua_setglobal(L,"trans");

    if(luaL_loadfile(L,"./test.lua") || lua_pcall(L,0,0,0)){
        error(L,"error load file %s",lua_tostring(L,-1));
    }

    lua_close(L);
    return 0;
}