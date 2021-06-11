
// 普通函数
 static int he(lua_State* L)
 {
 // 从栈中检查参数是否合法并读取参数,
 int a = luaL_checknumber(L,1);
 int b = luaL_checknumber(L,2);
 int re = a*b;
 // 将运算结果返回栈中供lua使用
 lua_pushnumber(L,re);
 return 1;
 }


 // 在C++中向lua传递table结构的数据
 // 这里的table是:{{"he"},{"li"}}
 int TTable(lua_State* L)
 {
   // 创建大table
   lua_newtable(L,1);

   // 大table的key
   lua_pushnumber(L,1); // 1为键
   //第一个小table
   lua_newtable(L);  
   // 第一个小table的key,value
   lua_pushnumber(L,1);
   lua_pushstring(L,"he");
   lua_settable(L,-3);
   //第一个小table的成员结束
   lua_settable(L,-3);
   //第二个小table,类似上面的过程
   lua_pushnumber(L,2); // 2为键
   lua_newtable(L,2);
   lua_pushnumber(L,1);
   lua_pushstring(L,"li");
   lua_settable(L,-3);
   lua_settable(L,-3)
   return 1;  //1个大table
 }
int main(int argc, char* argv[])
{
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);  // 加载Lua通用扩展库
    // 将he函数注册成lua的全局函数
    lua_register(L,"he",he);
    if(luaL_loadfile(L,"test.lua")/*||lua_pcall(L,0,0,0)*/)
        printf("error pcall!: %s\n",lua_tostring(L,-1));
    lua_close(L);
    return 0;
}

/*
//a.lua
a = 50
local b = 10

//h.lua
dofile("X:/.../a.lua")  
//或在同一个目录下时:doflie("a.lua")，require会更好
print(a,b)
*/
