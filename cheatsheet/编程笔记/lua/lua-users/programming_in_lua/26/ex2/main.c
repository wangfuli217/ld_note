//
// Created by 范鑫磊 on 17/2/8.
//
#include "helper.h"
#include "lauxlib.h"
#include <stdlib.h>
#include <string.h>

void call_va(lua_State *L,const char *func,const char *sig, ...){
    va_list  vl;
    int narg,nres;

    va_start(vl,sig);
    lua_getglobal(L,func);

    for(narg = 0; *sig; narg++){
        switch(*sig++){
            case 'd':
                lua_pushnumber(L,va_arg(vl,double));
                break;
            case 'i':
                lua_pushinteger(L,va_arg(vl,int));
                break;
            case 'b':
                lua_pushboolean(L,va_arg(vl,int));
                break;
            case 's':
                lua_pushstring(L,va_arg(vl,char *));
                break;
            case '>':
                goto endargs;
            default:
                error(L,"invalid options (%c)",*(sig-1));
        }
    }
    endargs:
    nres = strlen(sig);
    if(lua_pcall(L,narg,nres,0) != LUA_OK){
        error(L,"error calling %s",func);
    }

    nres = -nres;
    while(*sig){
        switch(*sig++){
            case 'd':{
                int isnum;
                double n = lua_tonumberx(L,nres,&isnum);
                if(!isnum){
                    error(L,"wrong type");
                }
                *va_arg(vl,double *) = n;
                break;
            }
            case 'b':{
                int isbool;
                isbool = lua_isboolean(L,nres);
                if(!isbool){
                    error(L,"wrong type");
                }
                *va_arg(vl,int *) = lua_toboolean(L,nres);
                break;
            }
            case 'i':{
                int isnum;
                double n = lua_tonumberx(L,nres,&isnum);
                if(!isnum){
                    error(L,"wrong type");
                }
                *va_arg(vl,int *) = n;
                break;
            }
            case 's': {
                const char * s = lua_tostring(L,nres);
                if(s == NULL){
                    error(L,"wrong type");
                }
                *va_arg(vl,const char **) = s;
                break;
            }
            default:{
                error(L,"invalid option %c",*(sig-1));
            }
        }
        nres ++;
    }

    va_end(vl);
}

int main(){

    lua_State *L = luaL_newstate();
    if (luaL_loadfile(L,"./test.lua") || lua_pcall(L,0,0,0)){
        error(L,"error when load test.lua");
    }
    int age;
    char * name;
    call_va(L,"sayhello","sib>si","jack",2016,1,&name,&age);
    printf("name=%s age=%i",name,age);
    return EXIT_SUCCESS;
}