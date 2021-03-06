---- Chap 27 --
--static int l_sin (lua_State *L) {
--  double d = lua_tonumber(L, 1); /* get argument */
--  lua_pushnumber(L, sin(d)); /* push result */
--  return 1; /* number of results */
--}
--
--#include <errno.h>
--#include <string.h>
--#include "lua.h"
--#include "lauxlib.h"
--static int l_dir (lua_State *L) {
--  DIR *dir;
--  struct dirent *entry;
--  int i;
--  const char *path = luaL_checkstring(L, 1);
--  /* open directory */
--  dir = opendir(path);
--  if (dir == NULL) { /* error opening the directory? */
--    lua_pushnil(L); /* return nil... */
--    lua_pushstring(L, strerror(errno)); /* and error message */
--    return 2; /* number of results */
--  }
--  /* create result table */
--  lua_newtable(L);
--  i = 1;
--  while ((entry = readdir(dir)) != NULL) {
--    lua_pushnumber(L, i++); /* push key */
--    lua_pushstring(L, entry->d_name); /* push value */
--    lua_settable(L, -3);
--  }
--  closedir(dir);
--  return 1; /* table is already on top */
--}
--
--static int finishpcall (lua_State *L, int status) {
--  lua_pushboolean(L, status); /* first result (status) */
--  lua_insert(L, 1); /* put first result in first slot */
--  return lua_gettop(L);
--}
--static int pcallcont (lua_State *L) {
--  int status = lua_getctx(L, NULL);
--  return finishpcall(L, (status == LUA_YIELD));
--}
--static int luaB_pcall (lua_State *L) {
--  int status;
--  luaL_checkany(L, 1);
--  status = lua_pcallk(L, lua_gettop(L) - 2, LUA_MULTRET, 0,
--  0, pcallcont);
--  return finishpcall(L, (status == LUA_OK));
--}