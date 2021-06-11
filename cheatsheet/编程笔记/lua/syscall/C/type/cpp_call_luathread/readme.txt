[root@localhost testLua]# g++ -g lua_resume_demo.cpp -ldl -llua
[root@localhost testLua]# ./a.out 
L Element Num:1 8
L1 Element Num:2
Func1 begin
Func2 begin.
LUA_YIELD = 1
iRet:1
Element Num:4
Value 1:5
Value 2:30
Value 3:40
Value 4:50
Func2 ended.

Func1 ended.
iRet:0
Element Num:2
Value 1:100
Value 1:game over

  

上面的例子是C语言调用Lua代码，Lua可以自己挂起自己。lua_resume可以启动一个协同程序，它的用法就像lua_call一样。将待调用的函数压入栈中，并压入其参数，最后在调用lua_resume时传入参数的数量narg。这个行为与lua_pcall类似，但有3点不同。

lua_resume没有参数用于指出期望的结果数量，它总是返回被调用函数的所有结果；
它没有用于指定错误处理函数的参数，发生错误时不会展开栈，这就可以在发生错误后检查栈中的情况；
如果正在运行的函数交出（yield）了控制权，lua_resume就会返回一个特殊的代码LUA_YIELD，并将线程置于一个可以被再次恢复执行的状态。
当lua_resume返回LUA_YIELD时，线程的栈中只能看到交出控制权时所传递的那些值。调用lua_gettop则会返回这些值的数量。为了恢复一个挂起线程的执行，可以再次调用lua_resume。在这种调用中，Lua假设栈中所有的值都是由yield调用返回的，当然了，你也可以任意修改栈中的值。