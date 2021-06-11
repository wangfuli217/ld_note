#include <stdio.h> 
#include <unistd.h>      
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
      
int main(int argc, const char *argv[])  
{  
    lua_State *L;  
    if(NULL == (L = luaL_newstate()))  
    {  
        perror("luaL_newstate failed");  
        return -1;  
    }
    
    luaL_openlibs(L);
    
    if(luaL_loadfile(L, "./printmsg.lua"))  
    {  
        perror("loadfile failed");  
        return -1;  
    }
    
    lua_pcall(L, 0, 0, 0);//Lua handles a chunk as the body of an anonymous function with a variable number of arguments. Call it.  
    lua_getglobal(L,"x");
    int x = (int) lua_tonumber(L,-1);
    printf("x:%d\n\r",x);
    
    lua_getglobal(L, "printmsg");  
    lua_pcall(L, 0, 0, 0);
    
    
    lua_close(L);  
      
    return 0;  
}


