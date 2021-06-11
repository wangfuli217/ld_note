#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
#include <event.h>


// gcc -I/usr/include/lua5.1 lua5.c -o lua5 -l lua5.1 && ./lua5

lua_State *L,*thread,*thread2;
  
int printtask(lua_State *L) {
    lua_pushthread(L);
    lua_gettable(L, LUA_REGISTRYINDEX);
    char *ptr = lua_touserdata(L, -1);
    printf("печатаем  %s\n",ptr);
}
              
  
int main(int argc, char *argv[])    
{   
    int i;
    L = lua_open();   
    int table,table2;
    luaopen_base(L);             /* opens the basic library */
    luaopen_table(L);            /* opens the table library */
    luaopen_string(L);           /* opens the string lib. */
    luaopen_math(L);             /* opens the math lib. */
    lua_pop(L,5);
    luaL_loadstring(L,"function main() local i=1+1 task() end");
    lua_pushcfunction(L, printtask);    
    lua_setglobal(L, "task"); 
    lua_pcall(L,0,0,0);
    char **ptr;
    char task[]="task 1";
    char task2[]="task 2";
    for(i=0;i<200;i++) {

	thread=lua_newthread(L);
        table = luaL_ref (L,LUA_REGISTRYINDEX);
	lua_pushthread(thread);
        lua_pushlightuserdata(thread, task);
        lua_settable(thread, LUA_REGISTRYINDEX);

	thread2=lua_newthread(L);
        table2 = luaL_ref (L,LUA_REGISTRYINDEX);
	lua_pushthread(thread2);
        lua_pushlightuserdata(thread2, task2);
        lua_settable(thread2, LUA_REGISTRYINDEX);

	lua_getglobal(thread2, "main");
	lua_getglobal(thread, "main");
	lua_resume(thread, 0);
	lua_resume(thread2, 0);
        luaL_unref(L, LUA_REGISTRYINDEX, table );
        luaL_unref(L, LUA_REGISTRYINDEX, table2 );
    }
    lua_close(L);


    return 0;   
}