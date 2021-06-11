#include <stdio.h>
#include <math.h>
#include <stdarg.h>
#include <stdlib.h>
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

/* 所有注册给Lua的C函数具有
 * "typedef int (*lua_CFunction) (lua_State *L);"的原型。
 */
static int l_sin(lua_State *L)
{   
    // 如果给定虚拟栈中索引处的元素可以转换为数字，则返回转换后的数字，否则报错。
    double d = luaL_checknumber(L, 1);
    lua_pushnumber(L, sin(d));  /* push result */

    /* 这里可以看出，C可以返回给Lua多个结果，
     * 通过多次调用lua_push*()，之后return返回结果的数量。
     */
    return 1;  /* number of results */
}

/* 需要一个"luaL_Reg"类型的结构体，其中每一个元素对应一个提供给Lua的函数。
 * 每一个元素中包含此函数在Lua中的名字，以及该函数在C库中的函数指针。
 * 最后一个元素为“哨兵元素”（两个"NULL"），用于告诉Lua没有其他的函数需要注册。
 */
static const struct luaL_Reg lib[] = {
    {"mysin", l_sin},
    {NULL, NULL}
};

/* 此函数为C库中的“特殊函数”。
 * 通过调用它注册所有C库中的函数，并将它们存储在适当的位置。
 * 此函数的命名规则应遵循：
 * 1、使用"luaopen_"作为前缀。
 * 2、前缀之后的名字将作为"require"的参数。
 */
extern int luaopen_mylib(lua_State* L)
{
    /* void luaL_newlib (lua_State *L, const luaL_Reg l[]);
     * 创建一个新的"table"，并将"l"中所列出的函数注册为"table"的域。
     */ 
    luaL_newlib(L, lib);

    return 1;
}
