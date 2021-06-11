// time.c
// 
// A lua module written in C to privode the time in subseconds resolution

#include <stdio.h>
#include <time.h>

#include "lua.h"
#include "lauxlib.h"

static double now()
{
    struct timespec time;
    clock_gettime(CLOCK_MONOTONIC, &time);
    return (double)time.tv_sec + (double)time.tv_nsec / 1e9f;
}

int get_time(lua_State *L)
{
    double t = now();
    lua_pushnumber(L, t);
    return 1;
}

int luaopen_time(lua_State *L)
{
    // Initialize the moudule
    luaL_Reg fns[] = {
        {"get_time", get_time},
        {NULL, NULL}
    };

    luaL_newlib(L, fns);
    return 1;
}