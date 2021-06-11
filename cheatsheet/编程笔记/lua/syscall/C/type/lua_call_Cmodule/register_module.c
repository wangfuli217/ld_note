static int l_dir(lua_state *L)
{
}

static const struct luaL_Reg mylib[] = {
{"dir",l_dir},
{NULL,NULL}//结尾
};

int luaopen_mylib(lua_State *L)
{
     luaL_register(L,"mylib",mylib);
     return 1;
}