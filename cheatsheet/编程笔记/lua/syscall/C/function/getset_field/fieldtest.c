#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

void print_stacknum(const char * desc, const int count){
    printf("%s stack num = %d\n", desc, count);
}

void test_api_getfield(){
    lua_State *L = lua_open();

    luaL_dofile(L,"fieldtest.lua");     // 加载执行lua文件
    lua_getglobal(L,"param");           // 查找param变量压入栈底
    print_stacknum("stage1", lua_gettop(L));

    lua_getfield(L, -1, "a");           // 将Param.a入栈
    int nParam_a = lua_tointeger(L,-1); // 将Param.a取出赋值给变量nParam_a
    lua_getfield(L, -2, "b");           // 将Param.b入栈
    int nParam_b = lua_tointeger(L,-1); // 将Param.b取出赋值给变量nParam_b
    print_stacknum("stage2",lua_gettop(L));

    lua_pop(L, 3);                       // 清除掉栈中多余的3个变量param、param.a、param.b
    print_stacknum("stage3",lua_gettop(L));

    int nParam_c = 2 * nParam_a + nParam_b;
    lua_pushinteger(L, nParam_c);       // 将c=2a+b计算完成，压入栈顶
    lua_setfield(L, LUA_GLOBALSINDEX, "c");// 使用栈顶的值设置脚本全局变量c
    print_stacknum("stage4",lua_gettop(L));

    lua_getglobal(L,"lua_func");        // 查找lua_func函数压入栈底
    lua_pushinteger(L, 3);              // 压入函数变量x=3    
    lua_pcall(L,1,1,0);             // 执行脚本函数lua_func
    print_stacknum("stage5",lua_gettop(L));

    int result = lua_tointeger(L,-1);   // 从栈中取回返回值 
    lua_pop(L,1);                       // 弹出返回结果
    print_stacknum("stage6",lua_gettop(L));

    printf("\nresult = %d", result);  
    lua_close(L);                       //关闭lua环境  
}
int main() {
    test_api_getfield();
    system("pause");
}