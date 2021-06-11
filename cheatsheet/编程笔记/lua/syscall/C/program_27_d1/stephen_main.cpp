#include <stdio.h>
#include <string.h>
#include <lua.hpp> // 上面的代码是基于我的C++工程，而非C工程，因此包含的头文件是lua.hpp，如果是C工程，可以直接包含lua.h。
#include <lauxlib.h>
#include <lualib.h>

int main(void)
{
    const char* buff = "print(\"hello\")";
    int error;
    // Lua库中没有定义任何全局变量，而是将所有的状态都保存在动态结构lua_State中，后面所有的C API都需要该指针作为第一个参数。
    lua_State* L = luaL_newstate();
    // luaL_openlibs函数是用于打开Lua中的所有标准库，如io库、string库等。
    luaL_openlibs(L);
    
    // luaL_loadbuffer编译了buff中的Lua代码，如果没有错误，则返回0，同时将编译后的程序块压入虚拟栈中。
    // lua_pcall函数会将程序块从栈中弹出，并在保护模式下运行该程序块。执行成功返回0，否则将错误信息压入栈中。
    error = luaL_loadbuffer(L,buff,strlen(buff),"line") || lua_pcall(L,0,0,0);
    int s = lua_gettop(L);
    if (error) {
        // lua_tostring函数中的-1，表示栈顶的索引值，栈底的索引值为1，以此类推。该函数将返回栈顶的错误信息，但是不会将其从栈中弹出。
        fprintf(stderr,"%s",lua_tostring(L,-1));
        // lua_pop是一个宏，用于从虚拟栈中弹出指定数量的元素，这里的1表示仅弹出栈顶的元素。
        lua_pop(L,1);
    }
    // lua_close用于释放状态指针所引用的资源。
    lua_close(L);
    return 0;
}