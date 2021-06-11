#include <stdio.h>
#include <stdlib.h>
#define LUA_USE_APICHECK
#include <string.h>

#include "lua.h"     //声明了Lua提供的基础函数，其中包括创建新Lua环境的函数、调用Lua函数的函数，
// 读写环境中全局变量的函数、以及注册供Lua语言调用的新函数的函数，lua.h中声明的所有内容都有一个前缀lua_
#include "lauxlib.h" //声明了辅助库所提供的函数，其中所有的声明均以luaL_开头。
// 辅助库使用lua.h提供的基础API来提供更高层次的抽象，特别是对标准库用到的相关机制进行抽象
// 基础API追求经济性和正交性，而辅助库则追求对常见任务的实用性。
// 注意：辅助库不能访问Lua的内部元素，而只能通过lua.h中声明的官方基础API完成所有工作。
//       辅助库能实现什么，你的程序就能实现什么
#include "lualib.h" //声明了用于打开这些库的函数。函数LuaL_openlibs用于打开所有的标准库

void lerror(lua_State *L, char *msg) {
  fprintf(stderr, "\nFATAL ERROR:\n  %s: %s\n\n", msg, lua_tostring(L, -1));
  lua_close(L);
  exit(1);
}

int main(int argc, char** argv)
{
	char buff[256];
	int error;
// Lua标准库没有定义任何C语言全局变量，他将其所有的状态都保存在动态的结构体lua_State中，
// Lua中的所有函数都接收一个指向该结构的指针作为参数，这种设计使得Lua是可重入的，
// 并且可以直接用于编写多线程代码。

// 创建一个新的 Lua 状态机。 它以一个基于标准 C 的 realloc 函数实现的内存分配器调用 lua_newstate 。
// 并把可打印一些出错信息到标准错误输出的 panic 函数设置好，用于处理致命错误。
// 返回新的状态机。 如果内存分配失败，则返回 NULL 。
	lua_State* L = luaL_newstate(); /* 打开lua*/
// 打开指定状态机中的所有 Lua 标准库。
	luaL_openlibs(L);               /* 打开标准库 */

	while (fgets(buff, sizeof(buff), stdin) != NULL)
	{ // luaL_loadstring来编译用户输入的每一行内容。如果没有错误，则返回零，并向栈中压入编译后得到的函数。
      // 然后，程序调用函数lua_pcall从栈中弹出编译后的函数，并以保护模式运行。
		error = luaL_loadstring(L, buff) || lua_pcall(L, 0, 0, 0);
		if (error){ // 当发生错误时，这两个函数都会向栈中压入一条错误信息。可以通过lua_tostring获取错误信息，
          // 并在打印出错误信息后使用函数Lua_pop将其从栈中删除。
			fprintf(stderr, "%s\n", lua_tostring(L, -1));
          // lua_pop 是一个宏，用于从虚拟栈中弹出指定数量的元素，这里的1表示仅弹出栈顶的元素。
			lua_pop(L, 1); 
		}
	}
	lua_close(L);
	return 0;
}

/*
#ifdef __cplusplus
extern "C" {
#endif
...
#ifdef __cpluspluc
}
#endif    

*/
