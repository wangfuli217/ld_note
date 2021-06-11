//
// Created by 范鑫磊 on 17/2/9.
//

#include "helper.h"
#include "lauxlib.h"
#include "lualib.h"

int main(){
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);

    if(luaL_loadfile(L,"./test.lua") || lua_pcall(L,0,0,0)) {
        error(L,"error load file %s",lua_tostring(L,-1));
    }
    lua_close(L);
    return 0;
}