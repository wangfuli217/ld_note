#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
//lua头文件
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>


#define err_exit(num,fmt,args)  \
    do{printf("[%s:%d]"fmt"\n",__FILE__,__LINE__,#args);exit(num);} while(0)
#define err_return(num,fmt,args)  \
    do{printf("[%s:%d]"fmt"\n",__FILE__,__LINE__,#args);return(num);} while(0)

//lua中调用的c函数定义,实现加法
int csum(lua_State* l)
{
    int a = lua_tointeger(l,1) ;
    int b = lua_tointeger(l,2) ;
    lua_pushinteger(l,a+b) ;
    return 1 ;
}

int main(int argc,char** argv)
{
    lua_State *l = luaL_newstate() ;        //创建lua运行环境
    if ( l == NULL )
        err_return(-1, "lua_pcall:%s", "luaL_newstat() failed"); 
    int ret = 0 ;
    ret = luaL_loadfile(l,"func.lua") ;      //加载lua脚本文件
    if ( ret != 0 ) 
        err_return(-1, "lua_pcall:%s", "luaL_loadfile failed") ;
    ret = lua_pcall(l,0,0,0) ;
    if ( ret != 0 ) 
        err_return(-1, "lua_pcall:%s", "lua_pcall failed") ;

    lua_getglobal(l,"width");              //获取lua中定义的变量
    lua_getglobal(l,"height");
    printf("height:%ld width:%ld\n",lua_tointeger(l,-1),lua_tointeger(l,-2)) ;
    lua_pop(l,1) ;                        //恢复lua的栈

    int a = 11 ;
    int b = 12 ;
    lua_getglobal(l,"sum");               //调用lua中的函数sum
    lua_pushinteger(l,a) ;
    lua_pushinteger(l,b) ;
    ret = lua_pcall(l,2,1,0) ;
    if ( ret != 0 ) err_return(-1,"lua_pcall failed:%s",lua_tostring(l,-1)) ;
    printf("sum:%d + %d = %ld\n",a,b,lua_tointeger(l,-1)) ;
    lua_pop(l,1) ;

    const char str1[] = "hello" ;
    const char str2[] = "world" ;
    lua_getglobal(l,"mystrcat");          //调用lua中的函数mystrcat
    lua_pushstring(l,str1) ;
    lua_pushstring(l,str2) ;
    ret = lua_pcall(l,2,1,0) ;
    if ( ret != 0 ) err_return(-1,"lua_pcall failed:%s",lua_tostring(l,-1)) ;
    printf("mystrcat:%s%s = %s\n",str1,str2,lua_tostring(l,-1)) ;
    lua_pop(l,1) ;

    lua_pushcfunction(l,csum) ;         //注册在lua中使用的c函数
    lua_setglobal(l,"csum") ;           //绑定到lua中的名字csum

    lua_getglobal(l,"mysum");           //调用lua中的mysum函数，该函数调用本程序中定义的csum函数实现加法
    lua_pushinteger(l,a) ;
    lua_pushinteger(l,b) ;
    ret = lua_pcall(l,2,1,0) ;
    if ( ret != 0 ) err_return(-1,"lua_pcall failed:%s",lua_tostring(l,-1)) ;
    printf("mysum:%d + %d = %ld\n",a,b,lua_tointeger(l,-1)) ;
    lua_pop(l,1) ;

    lua_close(l) ;                     //释放lua运行环境
    return 0 ;
}

//cc test_lua.c -llua -lm -o test_lua