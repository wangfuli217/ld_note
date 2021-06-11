#include <stdio.h>
#include <string.h>
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
#include <dlfcn.h>
#include <math.h>
 
static int mytest(lua_State *L) {
  //获取上值
  int upv = (int)lua_tonumber(L, lua_upvalueindex(1));
  printf("%d\n", upv);
  upv += 5;
  lua_pushinteger(L, upv);
  lua_replace(L, lua_upvalueindex(1));
 
  //获取一般参数
  printf("%d\n", (int)lua_tonumber(L,1));
 
  return 0;
}
 
int main(void) {
  lua_State *L = luaL_newstate();
  luaL_openlibs(L);
 
  //设置Cclosure函数的上值
  lua_pushinteger(L,10);
  lua_pushinteger(L,11);
  lua_pushcclosure(L,mytest,2);
  lua_setglobal(L,"upvalue_test");
  luaL_dofile(L, "./luatest.lua");
 
  //获取fclosure上值的名称(临时值, 不带env)
  lua_getglobal(L, "l_counter");
  const char *name = lua_getupvalue(L, -1, 1);
  printf("%s\n", name);
 
  //设置fclosure上值
  lua_getglobal(L, "l_counter");
  lua_pushinteger(L,1000);
  name = lua_setupvalue(L, -2, 1);
  printf("%s\n", name);
 
  lua_getglobal(L,"ltest");
  lua_pcall(L,0,0,0);
  lua_getglobal(L,"ltest");
  lua_pcall(L,0,0,0);
 
  //获取fclosure的上值（带env）
  lua_getglobal(L, "g_counter");
  lua_getupvalue(L, -1, 1);
   
  //通过settable重新设置env中对应的值
  lua_pushstring(L, "gloval_upvalue");
  lua_pushinteger(L,10000);
  lua_settable(L,-3);
   
  lua_pushstring(L, "gloval_upvalue1");
  lua_pushinteger(L,20000);
  lua_settable(L,-3);
   
  lua_getglobal(L,"gtest");
  lua_pcall(L,0,0,0);
  lua_close(L);
  return 0;
}