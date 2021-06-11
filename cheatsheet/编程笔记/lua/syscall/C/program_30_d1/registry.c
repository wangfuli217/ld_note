#include <stdio.h>
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>

int main()
{
	lua_State *L = luaL_newstate();
	static const char Key = 'k';

	lua_pushlightuserdata(L, (void *)&Key);
	lua_pushinteger(L, 1222);
	lua_settable(L, LUA_REGISTRYINDEX);

	lua_pushlightuserdata(L, (void *)&Key);
	lua_gettable(L, LUA_REGISTRYINDEX);
	long long int num = lua_tointeger(L, -1);
	printf("num: %lld, index: %d\n", num, LUA_REGISTRYINDEX);
	
	lua_pushstring(L, "abcdefg");
	int r = luaL_ref(L, LUA_REGISTRYINDEX);
	lua_pushnumber(L, r);
	lua_gettable(L, LUA_REGISTRYINDEX);
	printf("%d:%s\n", r, lua_tostring(L, -1));
	
	
	return 0;
}