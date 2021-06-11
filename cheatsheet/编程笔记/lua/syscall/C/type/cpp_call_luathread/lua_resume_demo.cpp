#include <iostream>
#include <lua.hpp>
#include <lualib.h>
#include <lauxlib.h>

using namespace std;

int main()
{
    //创建主线程
    lua_State *L = luaL_newstate();
    //打开lua辅助库
    luaL_openlibs(L);


    lua_State *L1 = lua_newthread(L);
    if (!L1)
    {
        return 0;
    }
    //L的栈顶是L1,thread类型的值
    cout << "L Element Num:" << lua_gettop(L)<<" " << lua_type(L,1) << endl;
    //在L1加载lua文件
    luaL_dofile(L1,"foo.lua");

lua_getglobal(L1, "Func1");

    lua_pushinteger(L1, 10);
    cout << "L1 Element Num:" << lua_gettop(L1) << endl;
    // 运行这个协同程序
    // // 这里返回LUA_YIELD
    int iRet = lua_resume(L1, 1);
    cout << "LUA_YIELD = " << LUA_YIELD << endl;
    cout << "iRet:" << iRet << endl;
    // // 打印L1栈中元素的总数
    cout << "Element Num:" << lua_gettop(L1) << endl;
    // 打印yield返回的四个值
    cout << "Value 1:" << lua_tointeger(L1, 1) << endl;
    cout << "Value 2:" << lua_tointeger(L1, 2) << endl;
    cout << "Value 3:" << lua_tointeger(L1, 3) << endl;
    cout << "Value 4:" << lua_tointeger(L1, 4) << endl;

    /// 再次启动协同程序
    /// 这里返回0
    iRet = lua_resume(L1, 0);
    cout << "iRet:" << iRet << endl;
    cout << "Element Num:" << lua_gettop(L1) << endl;
    cout << "Value 1:" << lua_tointeger(L1, -2) << endl;
    cout << "Value 1:" << lua_tostring(L1, -1) << endl;
    //关闭主线程
    lua_close(L);
    return 0;

}