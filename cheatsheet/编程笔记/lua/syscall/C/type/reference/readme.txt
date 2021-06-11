[root@agent109 reference]# g++ -g reference.c -ldl -llua           
[root@agent109 reference]# ./a.out 
stack size:1,6
stack size:0
stack size:1,6
hello world
stack size:0
------------------------华丽的分割线------------
stack size:1
stack size:0
hello world
------------------------又一次华丽的分割线------------
stack size:0,0
stack size:1
hello world
[root@agent109 reference]# g++ -g reference.c -ldl -llua 
[root@agent109 reference]# ./a.out 
stack size:1,function
stack size:0
stack size:1,function
hello world
stack size:0
------------------------华丽的分割线------------
stack size:1
stack size:0
hello world
------------------------又一次华丽的分割线------------
stack size:0,nil
stack size:1
hello world


4.1：从程序的运行结果可以知道：luaL_ref返回一个int的值ref。ref这个值就是对应的value(foo函数)的key，
     通过API方法    lua_rawgeti(L,LUA_REGISTRYINDEX,ref);可以从注册表获取到对应的value（foo函数）。
     一旦ref在注册表的引用解除，就无法继续通过ref这个引用获取到value(即foo函数)。

4.2：如果想在c模块之间通过ref来引用到value(即foo函数)。也是可以的。但是c模块之间必须共享ref的值。
     这里就不写测试用例了。

4.3：注册表的key也可以C/C++静态变量地址作为key；C连接器可以确保这个key在整个注册表中的唯一性。

static int i =0;
lua_pushlightuserdata(L, (void*) &i) ;  /**取静态变量i的地址作为key压栈**/
lua_pushInteger(L, "value");   /**把值压栈**/
lua_settable(L, LUA_REGISTERINDEX); /** &i, value出栈；并且实现register[&i] = value**/

lua_pushlightuserdata(L, (void*) &i) ;  /**取静态变量i的地址作为key压栈**/
lua_gettable(L, LUA_REGISTERINDEX); /**获取value值，如果函数调用成功，那么value目前在栈顶**/
const char* str = lua_tostring(L,-1);