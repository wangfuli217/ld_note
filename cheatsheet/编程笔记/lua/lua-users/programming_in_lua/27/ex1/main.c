//
// Created by 范鑫磊 on 17/2/8.
//

#include <stdlib.h>
#include "helper.h"
#include "lauxlib.h"
#include "lualib.h"
int summation(lua_State *L){
    int nargs = lua_gettop(L);
    double res = 0;
    for(int i=1;i<=nargs;i++){
        luaL_checknumber(L,i);
        double t = lua_tonumberx(L,i,0);

        res += t;
    }
    lua_pushnumber(L,res);
    return 1;
}

int pack(lua_State *L){

}

int main(){
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);
    lua_pushcfunction(L,summation);
    lua_setglobal(L,"summation");
    if(luaL_loadfile(L,"./test.lua") || lua_pcall(L,0,0,0)){
        error(L,"error load file %s",lua_tostring(L,-1));
    }

    lua_close(L);
    return EXIT_SUCCESS;
}