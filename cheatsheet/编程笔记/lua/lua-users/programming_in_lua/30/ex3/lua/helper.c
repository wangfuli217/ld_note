//
// Created by 范鑫磊 on 17/2/8.
//

#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include "helper.h"
#include "lualib.h"
#include "lauxlib.h"


void error(lua_State *L, const char *fmt, ...){
    va_list  argp;
    va_start(argp,fmt);
    vfprintf(stderr,fmt,argp);
    va_end(argp);
    lua_close(L);
    exit(EXIT_FAILURE);
}


 void dumpStack(lua_State *L){
    int i;
    int top = lua_gettop(L);
    for(i = 1; i <= top; i++){
        int t = lua_type(L,i);
        switch(t){
            case LUA_TSTRING:{
                printf("%s",lua_tostring(L,i));
                break;
            }
            case LUA_TBOOLEAN:{
                printf("%s",lua_toboolean(L,i)==1 ? "true" : "false");
                break;
            }
            case LUA_TNUMBER:{
                printf("%g",lua_tonumber(L,i));
                break;
            }
            default:
                printf("%s",luaL_typename(L,i));
        }
        printf("    ");
    }
    printf("\n");
}