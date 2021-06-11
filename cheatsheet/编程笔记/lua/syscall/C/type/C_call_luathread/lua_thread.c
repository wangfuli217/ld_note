#include <stdio.h>
#include <lua.hpp>
#include <lualib.h>
#include <lauxlib.h>


static int Stop(lua_State* L);


lua_State* CreateCoroutine(lua_State* gL, const char* corName);


int main()
{
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);
    luaL_dofile(L,"corTest.lua");
    lua_State* newL = CreateCoroutine(L,"CorTest");
    lua_register(newL,"Stop",Stop);
    int re = lua_resume(newL, 0);  // 这次传0个参数(因为CorTest没有参数)
    if(re != LUA_YIELD)
        printf("ERROR");
    //lua挂起后, 栈增加了coroutine.yield的参数：100, 和hello C++
    int rint = luaL_checknumber(newL, -2);
    const char* str = lua_tostring(newL, -1);
    printf("stack value: %d,  %s,now stack size:%d\n", rint, str,lua_gettop(newL));  // ? 100, hello C++
    // 这次恢复协程时传入参数, 参数压栈, lua中就是对应返回值local re
    lua_pushstring(newL, "from c++");
    printf("3333 stack szie: %d\n",lua_gettop(newL));
    // from c++这个字符串当做lua_resume的参数回传给coroutine的主函数
    re = lua_resume(newL, 1);
    const char* yield = lua_tostring(newL, -1);
    // 挂起后是在Stop()函数中传入了一个"call c yield!"
    printf("555 stack szie: %d=(%s)\n",lua_gettop(newL), yield);
    re = lua_resume(newL, 0); // 这里无法传值回去lua了,因为Stop的栈已经被释放 ,而是直接运行lua中Stop的后一句
    lua_close(L);
    return 0;
}

static int Stop(lua_State* lp)
{
    // 会传一个参数进来
    const char* str = lua_tostring(lp,-1);
    printf("C Stop Func: %s\n", str);
    //将这个值再次压入栈中
    lua_pushstring(lp,str);
    printf("Stop func stack szie: %d\n",lua_gettop(lp));
    //Yields a coroutine.
    //This function should only be called as the return expression of a C function, as follows:
    return lua_yield(lp,1);
}


lua_State* CreateCoroutine(lua_State* gL, const char* corName)
{
    lua_State* newL = lua_newthread(gL);
    lua_getglobal(newL, corName);  // 协程函数入栈
    return newL;
}