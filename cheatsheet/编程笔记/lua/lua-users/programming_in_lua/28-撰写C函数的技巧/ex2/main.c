//
// Created by 范鑫磊 on 17/2/10.
//
#include "helper.h"
#include "lauxlib.h"
#include <string.h>
#include "lualib.h"

static int l_split (lua_State *L) {

    size_t len;
    const char *s = luaL_checklstring(L,1,&len);
    const char *sep = luaL_checkstring(L, 2);  /* separator */

    const char *e;
    int i = 1;
    lua_newtable(L);  /* result table */
    /* repeat for each separator */
    while ((e = memchr(s, *sep,len)) != NULL) {
        lua_pushlstring(L, s, e-s); /* push substring */
        lua_rawseti(L, -2, i++);/* insert it in table */
        len = len - (e - s);
        s=e+1; /*skipseparator*/
    }
    /* insert last substring */
    lua_pushstring(L, s);
    lua_rawseti(L, -2, i);
    return 1;  /* return the table */
}

int main(){
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);
    lua_pushcfunction(L,l_split);
    lua_setglobal(L,"split");
    if(luaL_loadfile(L,"./test.lua") || lua_pcall(L,0,0,0)){
        error("error when load %s",lua_tostring(L,-1));
    }
    lua_close(L);
    return 0;
}