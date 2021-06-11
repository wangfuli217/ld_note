#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <dirent.h>
#include <errno.h>
#include <string.h>
#include <ctype.h>

#include "lua.h"
#include "lauxlib.h"

#include "util.h"


// Exercise 29.1
static int l_summation(lua_State *L) {
    double s;

    int i;
    for (i = 1; i <= lua_gettop(L); i++) {
        double d = luaL_checknumber(L, i);
        s = d + s;
    }

    lua_pushnumber(L, s);
    return 1;
}

// Exercise 29.2
static int l_pack(lua_State *L) {
    int n = lua_gettop(L);

    lua_newtable(L);
    int i;
    for (i = 1; i <= n; i++) {
        lua_pushvalue(L, i);
        lua_seti(L, -2, i);
    }

    lua_pushinteger(L, n);
    lua_setfield(L, -2, "n");

    return 1;
}

static int l_sin(lua_State *L) {
    double d = luaL_checknumber(L, 1);
    lua_pushnumber(L, sin(d));
    return 1;
}

static int l_dir(lua_State *L) {
    DIR *dir;
    struct dirent *entry;
    int i;
    const char *path = luaL_checkstring(L, 1);

    dir = opendir(path);
    if (dir == NULL) {
        lua_pushnil(L);
        lua_pushstring(L, strerror(errno));
        return 2;
    }
    lua_newtable(L);
    i = 1;
    while ((entry = readdir(dir)) != NULL) {
        lua_pushinteger(L, i++);
        lua_pushstring(L, entry->d_name);
        lua_settable(L, -3);
    }

    closedir(dir);
    return 1;
}

static int l_reverse(lua_State *L) {
    int n = lua_gettop(L);

    int i;
    for (i = 1; i <= n/2; i++) {
        int j = (n+1-i);
        // swap
        lua_pushvalue(L, i);
        lua_pushvalue(L, j);
        lua_replace(L, i);
        lua_replace(L, j);
    }

    return n;
}

static int l_foreach(lua_State *L) {
    luaL_checktype(L, 1, LUA_TTABLE);
    luaL_checktype(L, 2, LUA_TFUNCTION);

    lua_pushnil(L);
    while (lua_next(L, 1) != 0) {
        lua_pushvalue(L, 2);
        lua_pushvalue(L, 3);
        lua_pushvalue(L, 4);
        int error  = lua_pcall(L, 2, 0, 0);
        if (error) {
            lua_error(L);
        }
        lua_pop(L, 1);
    }

    return 0;
}


/*
  对数组中的所有元素调用一个指定的函数，然后用此函数返回的结果替换对应的数组元素
*/
static int l_map(lua_State *L) {
    int i, n;
/* 第一个参数必须是一张表 */
    luaL_checktype(L, 1, LUA_TTABLE);
/* 第二个参数必须是一个函数 */
    luaL_checktype(L, 2, LUA_TFUNCTION);

    n = luaL_len(L, 1); /* 获取表的大小 */
    for (i = 1; i <= n; i++) {
        lua_pushvalue(L, 2); // 压入f
        lua_geti(L, 1, i);   // 压入t[i]
        lua_call(L, 1, 1);   // 调用f(t[i])
        lua_seti(L, 1, i);   // t[i] = result
    }
    return 0; /* 没有返回值 */
}

/*
  函数根据指定的分隔符(单个字符)来分割字符串，并且返回一张包含子串的表。
  例如split("hi:ho:there", ":")应该返回{"hi", "ho", "there"}
*/
static int l_split(lua_State *L) {
    const char *s = luaL_checkstring(L, 1);   /* 目标字符串 */
    const char *sep = luaL_checkstring(L, 2); /* 分隔符 */

    lua_newtable(L); /* 结果表 */
    char *e;
    int i = 1;
    while ((e = strchr(s, *sep)) != NULL) {
        lua_pushlstring(L, s, e - s); /* 压入子串 */
        lua_rawseti(L, -2, i++);      /* 向表中插入 */
        s = e + 1;                    /* 跳过分隔符 */
    }
    /* 插入最后一个字串 */
    lua_pushstring(L, s);
    lua_rawseti(L, -2, i);
    return 1; /* 将结果表返回 */
}

static int l_upper(lua_State *L) {
    size_t l;
    size_t i;
    luaL_Buffer b; /* 声明一个Lua字符串 */
    const char *s = luaL_checklstring(L, 1, &l);
    char *p = luaL_buffinitsize(L, &b, l); /* 初始化一个指定长度的Lua字符串 */
    for (i = 0; i < l; i++) {
         p[i] = toupper(s[i]);
    }
    luaL_pushresultsize(&b, l); /* 结束对缓存 B 的使用，将最终的字符串留在栈顶。 */
    return 1;
}

static int l_concat(lua_State *L) {
    int i, n;
    luaL_checktype(L, 1, LUA_TTABLE);
    n = luaL_len(L, 1);
    luaL_Buffer b; /* 声明一个Lua字符串 */
    luaL_buffinit(L, &b); /* 初始化一个未指定长度的Lua字符串 */
    for (i = 1; i <= n; i++) {
        lua_geti(L, 1, i);
        luaL_addvalue(&b); /* 在Lua字符串中追加字符串 */
    }
    luaL_pushresult(&b);  /* 结束对缓存 B 的使用，将最终的字符串留在栈顶。 */
    return 1;
}

static int l_counter(lua_State *L) {
    int val = lua_tointeger(L, lua_upvalueindex(1));
    lua_pushinteger(L, ++val);
    lua_copy(L, -1, lua_upvalueindex(1));
    return 1;
}

static int newCounter(lua_State *L) {
    lua_pushinteger(L, 0);
    lua_pushcclosure(L, &l_counter, 1);
    return 1;
}


static const struct luaL_Reg mylib[] = {
    {"dir", l_dir},
    {"sin", l_sin},
    {"summation", l_summation},
    {"pack", l_pack},
    {"reverse", l_reverse},
    {"foreach", l_foreach},
    {"map", l_map},
    {"split", l_split},
    {"upper", l_upper},
    {"concat", l_concat},
    {"newCounter", newCounter},
    {NULL, NULL},
};


int luaopen_mylib (lua_State *L) {
    luaL_newlib(L, mylib);
    return 1;
}