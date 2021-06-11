--Chap 26--
void load (lua_State *L, const char *fname, int *w, int *h) {
  if (luaL_loadfile(L, fname) || lua_pcall(L, 0, 0, 0))
  error(L, "cannot run config. file: %s", lua_tostring(L, -1));
  lua_getglobal(L, "width");
  lua_getglobal(L, "height");
  if (!lua_isnumber(L, -2))
  error(L, "'width' should be a number\n");
  if (!lua_isnumber(L, -1))
  error(L, "'height' should be a number\n");
  *w = lua_tointeger(L, -2);
  *h = lua_tointeger(L, -1);
}

#define MAX_COLOR 255
/* assume that table is on the stack top */
int getcolorfield (lua_State *L, const char *key) {
  int result;
  lua_pushstring(L, key); /* push key */
  lua_gettable(L, -2); /* get background[key] */
  if (!lua_isnumber(L, -1))
  error(L, "invalid component in background color");
  result = (int)(lua_tonumber(L, -1) * MAX_COLOR);
  lua_pop(L, 1); /* remove number */
  return result;
}

/* call a function 'f' defined in Lua */
double f (lua_State *L, double x, double y) {
  int isnum;
  double z;
  /* push functions and arguments */
  lua_getglobal(L, "f"); /* function to be called */
  lua_pushnumber(L, x); /* push 1st argument */
  lua_pushnumber(L, y); /* push 2nd argument */
  /* do the call (2 arguments, 1 result) */
  if (lua_pcall(L, 2, 1, 0) != LUA_OK)
  error(L, "error running function 'f': %s",
  lua_tostring(L, -1));
  /* retrieve result */
  z = lua_tonumberx(L, -1, &isnum);
  if (!isnum)
  error(L, "function 'f' must return a number");
  lua_pop(L, 1); /* pop returned value */
  return z;
}

#include <stdarg.h>
void call_va (lua_State *L, const char *func,
const char *sig, ...) {
  va_list vl;
  int narg, nres; /* number of arguments and results */
  va_start(vl, sig);
  lua_getglobal(L, func); /* push function */
  <push arguments (Listing 26.6)>
  nres = strlen(sig); /* number of expected results */
  if (lua_pcall(L, narg, nres, 0) != 0) /* do the call */
  error(L, "error calling '%s': %s", func,
  lua_tostring(L, -1));
  <retrieve results (Listing 26.7)>
  va_end(vl);
}