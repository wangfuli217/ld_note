-- https://blog.csdn.net/zh379835552/article/details/38703955
-- http://cloudwu.github.io/lua53doc/manual.html#9
-- http://valleu87.blog.163.com/blog/#m=0&t=1&c=fks_084070084084088064085085081095085095087068084085082064086
-- https://github.com/kakitgogogo/Bauble
-- http://book.luaer.cn/

--[[
    Lua 是一种嵌入式语言，这就意味着Lua并不是一个独立运行的应用，而是一个库，它可以
链接到其他应用程序，将Lua的功能融入这些应用。
    C拥有控制权，而Lua语言被用作库。这种交换形式中的C代码被称为应用代码。
    Lua是一种可扩展的语言，使用了Lua语言的程序可以在Lua环境中注册新的函数，从而
增加一些无法直接用Lua语言编写的功能。
    Lua语言拥有控制权，而C语言被用作库，此时C代码被称为库代码。
    
    C API是由函数、常量和类型组成的集合，有了它，C语言代码就能与Lua语言交互。
C API包括
1. 读写Lua全局变量的函数
2. 调用Lua函数的函数
3. 运行Lua代码段的函数以及
4. 注册C函数的函数等等。通过调用C API，C代码几乎可以做Lua代码能够做的所有事情。

    C API遵循C语言的操作模式，与Lua的操作模式有很大区别。在使用C语言编程时，我们必须
注意
1. 类型检查、
2. 错误恢复、
3. 内存分配错误和
4. 其他一些复杂的概念

    Lua 和 C之间通信的主要组件是无处不在的虚拟栈几乎所有API调用都是在操作这个栈中的值，
Lua 与 C之间所有的数据交换都是通过这个栈完成的。

    C 库中所有的 Lua API 函数都不去检查参数是否相容及有效。 然而，你可以在编译 Lua 
时加上打开一个宏开关 LUA_USE_APICHECK 来改变这个行为。
--]]

--[[ 栈 -> 协议
    无论何时Lua调用C，被调用的函数都得到一个新的栈，这个栈独立于C函数本身的栈，也独立于之前的Lua栈。 
它里面包含了Lua传递给C函数的所有参数， 而C函数则把要返回的结果放入这个栈以返回给调用者。
    

    方便起见，所有针对栈的API查询操作都不严格遵循栈的操作规则。而是可以用一个索引来指向栈上的任何元素：
正的索引指的是栈上的绝对位置(从1开始)；负的索引则指从栈顶开始的偏移量。
    展开来说，如果堆栈有n个元素， 那么索引 1 表示第一个元素(也就是最先被压栈的元素)而索引 n 则指最后一个元素；
索引 -1 也是指最后一个元素(即栈顶的元素)，索引 -n 是指第一个元素。
    索引值为正时表示相对于栈底的偏移索引，索引值为负时表示相对于栈顶的偏移索引。索引值以1或 -1 起始值，
因此栈顶索引值永远为-1, 栈底索引值永远为1 。 "栈"相当于数据在Lua和C之间的中转地，每种数据都有相应的存取接口。

注意：当Lua调用C时，栈至少包含LUA_MINSTACK(20)个位置，程序员也可以使用lua_checkstack函数来增加栈的大小。
      使用伪索引(Pseudo-Indices)来表示一些不在栈中的数据，比如thread环境、C函数环境、registry、C闭包的upvalues。
        thread环境(全局变量也在这里)，使用伪索引 LUA_GLOBALSINDEX；
        运行中的C函数环境，使用伪索引 LUA_ENVIRONINDEX
        Registry，使用伪索引 LUA_REGISTRYINDEX
        C闭包的upvalues，可以使用lua_upvalueindex(n)来访问第n个upvalue
        
关于Registry：
    在C里面如果函数要保存持久状态，只能依靠全局或static变量，但这样C API库就无法为多个LuaState状态同时提供服务
(就类似于带有static变量的C函数是不可重入的)。为此Lua提供了一个名为Registry的预定义table，允许C API往Registry里面存储数据。

关于References：
    Reference其实就是在一个指定的表t中保存一次lua的数据对象，Refenence本身其实就是表t的索引子，简称RefIndex，
当RefIndex作为Refenence时，t[RefIndex]其实就是用户要求引用的lua数据对象。当RefIndex被luaL_unref()回收时，
t每一个被回收的RefIndex构成一个单向链表: t[Refindex] = Refindex0, t[Refindex0] = Refindex1, t[Refindex1] = 
Refindex2 ... t[0] = Refindex。

注意，t[0]始终是指向了空闲链表的头部。每次调用luaL_ref()且回收链表为空时，都会产生一个新的Reference，
      每次调用luaL_unref()都会销毁一个指定的Reference存入空闲链表中。
--]]

--[[ 入栈
    可以使用栈来保存临时变量。栈的使用解决了C和LUA之间两个不协调的问题：
    1. 动态类型和静态类型体系之间不匹配
    2. 自动内存管理和手动内存管理之间不匹配
    Lua严格地按照LIFO后进先出的规则来操作栈。在调用Lua时，只有栈顶部的部分会发生变化
而C语言代码则有更大的自由度。更具体地说，C语言可以监视栈中的任何一个元素，甚至可以在栈
的任意位置插入或删除元素。

Lua要么生成一个内部副本，要么复用已有的字符串，函数返回，即使立即释放或修改缓存区也不会出问题
void lua_pushnil(lua_State *L);                              [-0 +1 -]  // 常量值nil
void lua_pushboolean(lua_State *L,int bool);                 [-0 +1 -]  // 布尔值
void lua_pushnumber(lua_State *L,lua_Number n);              [-0 +1 -]  // double, unsigned long, unsigned int
void lua_pushinteger(lua_State *L,lua_Integer n);            [-0 +1 -]  // integer,
const char * lua_pushlstring(lua_State *L,const char *s,size_t len); [-0 +1 m]  // 任意的字符串(指向char型变量的指针加上一个长度)
const char * lua_pushstring(lua_State *L,const char *s);             [-0 +1 m]  // 以0终止符结尾的字符串
const char *lua_pushfstring (lua_State *L, const char *fmt, ...);    [-0 +1 m]  // 可变参数
const char *lua_pushvfstring (lua_State *L,const char *fmt,va_list argp); [-0 +1 m]  // 可变参数
const char *lua_pushliteral (lua_State *L, const char *s);                [-0 +1 m]  // 字面常量：const char*类型或者define字符串

void lua_pushcclosure (lua_State *L, lua_CFunction fn, int n);    // 把一个新的 C 闭包压栈。
// 当创建了一个 C 函数后， 你可以给它关联一些值， 这就是在创建一个 C 闭包，接下来无论函数何时被调用，这些值都可以被这个函数访问到。 
// 为了将一些值关联到一个 C 函数上， 首先这些值需要先被压入堆栈(如果有多个值，第一个先压)接下来调用 lua_pushcclosure 来创建出闭包并把这个 C 函数压到栈上。
// 参数 n 告之函数有多少个值需要关联到函数上。lua_pushcclosure 也会把这些值从栈上弹出。
// n 的最大值是 255 。
// 当 n 为零时， 这个函数将创建出一个 轻量 C 函数， 它就是一个指向 C 函数的指针。 这种情况下，不可能抛出内存错误。

void lua_pushcfunction (lua_State *L, lua_CFunction f);           // 将一个 C 函数压栈。
// 这个函数接收一个 C 函数指针， 并将一个类型为 function 的 Lua 值压栈。 当这个栈顶的值被调用时，将触发对应的 C 函数。
// 注册到 Lua 中的任何函数都必须遵循正确的协议来接收参数和返回值
// lua_pushcfunction 是作为一个宏定义出现的： #define lua_pushcfunction(L,f)  lua_pushcclosure(L,f,0)


void lua_pushlightuserdata (lua_State *L, void *p);               // 把一个轻量用户数据压栈。
// 用户数据是保留在 Lua 中的 C 值。 轻量用户数据 表示一个指针 void*。 它是一个像数字一样的值： 你不需要专门创建它，它也没有独立的元表，而且也不会被收集
// (因为从来不需要创建).只要表示的 C 地址相同，两个轻量用户数据就相等。

--> 也有向栈中压入C函数和用户数据的函数。

当push元素至stack的时候，必须确保stack有足够的空间来存储这些。一个安全的方法是使用之前先确认空间：
     int lua_checkstack(lua_State *L,int sz);    ensure stack capacity [-0 +0 m]  // 参数是要push的元素的数量。
     void luaL_checkstack(lua_State *L,int sz， const char *msg)
    Lua语言不会保留指向外部字符串(或指向除静态的C语言函数外的任何外部对象)的指针，
对于不得不保留的字符串，Lua要么生成一个内部副本，要么服用已有的字符串。因此，一旦
上述函数返回，即使立刻释放或修改缓冲区也不会出现问题。
--]]

--[[ 出栈
API使用indices，首先push进去的元素index为1，之后为2，如果使用的是负数，则-1代表最后push的元素，-2为倒数第二个。
使用函数lua_isstring,lua_istable,lua_isnumber等来检测元素的类型。各个函数的形式都类似于：
    int lua_is*(lua_State *L,int index)
    
    int lua_type (lua_State *L, int idx) 
    // 1. lua_isfunction lua_istable lua_islightuserdata lua_isnil lua_isboolean lua_isthread lua_isnone 是对lua_type返回值的判断
    // 2. lua_iscfunction  在lua_isfunction的基础上进行进一步判断
    // 3. lua_isuserdata   是LUA_TUSERDATA或者LUA_TLIGHTUSERDATA类型都可以
    // 4. lua_isnoneornil  是LUA_TNIL或者LUA_TNONE类型都可以
    // 5. lua_isstring     是LUA_TSTRING或者LUA_TNUMBER类型都可以
    // 6. lua_isnumber     是LUA_TNUMBER类型或者是LUA_TSTRING类型且该字符串可以转换为数字
    
    int lua_isboolean (lua_State *L, int index);       is stack[i] a bool?   [-0 +0 -]  
    int lua_iscfunction (lua_State *L, int index);     is stack[i] a cfn?    [-0 +0 -]
    int lua_isfunction (lua_State *L, int index);      is stack[i] a fn?     [-0 +0 -]
    int lua_islightuserdata (lua_State *L, int index); is stack[i] a lightudata?  [-0 +0 -] 
    int lua_isnil (lua_State *L, int index);           is stack[i] a nil?    [-0 +0 -]  
    int lua_isnone (lua_State *L, int index);          nothing at stack[i]?  [-0 +0 -]
    int lua_isnoneornil (lua_State *L, int index);     is stack[i] a nil? or nothing at stack[i]?  [-0 +0 -]
    int lua_isnumber (lua_State *L, int index);        is stack[i] a number? [-0 +0 -]
    int lua_isstring (lua_State *L, int index);        is stack[i] a string? [-0 +0 -] 
    int lua_istable (lua_State *L, int index);         is stack[i] a table?  [-0 +0 -]
    int lua_isthread (lua_State *L, int index);        is stack[i] a thread?  [-0 +0 -] 
    int lua_isuserdata (lua_State *L, int index);      is stack[i] a udata?  [-0 +0 -] 

这些都是栈中指定元素类型检查的接口；

并且事实上lua_isnumber并不是检测元素是否是number类型，而是检测能否转换为这个类型；lua_isstring也是类似的检测：
所有的number都可以转换为string

    另外函数lua_type，返回元素的类型。这些类型定义在lua.h头文件中：
LUA_TNIL,LUA_TBOOLEAN,LUA_TNUMBER,LUA_TSTRING,LUA_TTABLE,LUA_TTHERAD,LUA_TUSERDATA,LUA_TFUNCTION.

从stack中得到元素值，有以下的函数：
    int             lua_toboolean(lua_State *L,int index); bool(stack[i]) [-0 +0 -]   // nil和false转化为0，所有其他的Lua值转化为1
    const char*     lua_tostring(lua_State *L,int index, size_t* len); mem is owned by Lua   [-0 +0 -] // 对于不正确类型返回NULL 
    const char*     lua_tolstring(lua_State *L,int index,size_t* len); mem is owned by Lua   [-0 +0 -] // 返回一个指向该字符串内部副本的指针
    //并将字符串的长度存入到参数len指定的位置; 我们无法修改这个内部副本(const表明了一点)
    //Lua语言保证，只要对应的字符串还在栈中，那么这个指针就是有效的。
    // 当Lua调用的一个C函数返回时，Lua就会清空栈。因此，作为规则，永远不要把指向Lua字符串的指针存放到获取该指针的函数之外。
    lua_State*      lua_tothread(lua_State *L, int index)// 对于不正确类型返回NULL
    
    lua_Number      lua_tonumber(lua_State *L,int index);    lua_Number(stack[i])  [-0 +0 -] 
    lua_Number      lua_tonumberx (lua_State *L, int index, int *isnum);  //*isnum 会被设为操作是否成功
    lua_Integer     lua_tointeger(lua_State *L,int index);   lua_Integer(stack[i]) [-0 +0 -] 
    lua_Integer     lua_tointegerx (lua_State *L, int index, int *isnum); //*isnum 会被设为操作是否成功
    void *lua_touserdata (lua_State *L, int index);          returns void *        [-0 +0 -] 
函数lua_tostring 返回的字符串总是会默认在尾部带一个0，而实际上该字符串的长度是函数第三个参数所代表的值。
--]]

--[[ 操作栈
int  lua_gettop (lua_State *L)             get stack size        [-0 +0 -]// 栈中元素的个数，也即栈顶元素的索引
void lua_settop(lua_State *L,int index);   set stack size        [-? +? -]// 将栈顶设置为一个指定的值，即修改栈中的元素数量
//如果之前的栈顶比新设置的更高，那么高出来的这些元素就会被丢弃；反之，该函数会向栈中压入nil来补足大小
//特别的，函数lua_settop(L,0) 用于清空栈
// 函数lua_settop时也可以使用负数索引；基于此功能提供了如下宏：
#define lua_pop(L,n) lua_settop(L, -(n)-1)

void lua_pushvalue(lua_State *L,int index); cp i -> top        [-0 +1 m]    // 将指定索引上的元素的副本 压入栈
void lua_remove(lua_State *L,int index);    rm i               [-1 +0 -]    // 用于删除指定索引的元素，并将该位置上的所有元素下移以填空补缺
void lua_insert(lua_State *L,int index);    mv top -> i        [-1 +1 -]    // 将栈顶元素移动到指定位置，并上移指定位置上的所有元素以开辟出一个元素空间
void lua_replace(lua_State *L,int index);   rm i, mv top -> i  [-1 +0 -]    // 把栈顶元素放置到给定位置而不移动其它元素(因此覆盖了那个位置处的值)，然后将栈顶元素弹出。
void lua_copy(lua_State *L,int fromidx,int toidx);  // 把一个元素复制到他当前的位置

void lua_concat (lua_State *L, int n); // 将栈顶开始的n个元素连接起来，并将它们出栈，然后将结果入栈；
void lua_getfield (lua_State *L, int index, const char *k); // 将t[k]压入堆栈，t由参数index指定在栈中的位置；
void lua_setfield (lua_State *L, int index, const char *k); // 相当于t[k]=v，t由参数index指定在栈中的位置，v是栈顶元素，改函数会将栈顶的value出栈；
void lua_getglobal(lua_State *L, char *name);          // lua_getfield(L, LUA_GLOBALSINDEX, s)，注意：栈中LUA_GLOBALSINDEX索引位置处是当前Lua状态机的全局变量环境。
void lua_setglobal (lua_State *L, const char *name);   // 等价于 lua_setfield(L, LUA_GLOBALSINDEX, s)；
int lua_next (lua_State *L, int index); // lua_next 弹出一个key，然后将t[key]入栈，t是参数index处的table；
// 在利用lua_next遍历栈中的table时，对key使用lua_tolstring尤其需要注意，除非知道key都是string类型。
//  pop k/push k,v if any [-1 +0|2 e]  
size_t lua_objlen (lua_State *L, int index); // 返回index处元素的长度，对string，返回字符串长度；对table，返回"#"运算符的结果；对userdata，返回内存大小；其它类型返回0；
void luaL_checkstack (lua_State *L, int sz, const char *msg); // 增加栈大小（新增sz个元素的空间），如果grow失败，引发一个错误，msg参数传递错误消息。

--]]

--[[ 使用C API进行错误处理 -> Lua语言使用异常来提示错误，而没有在API的每个操作中使用错误码。
    Lua中所有的结构都是动态的：它们会按需扩展，并且在可能时最后重新收缩，这意味着在
Lua中内存分配失败可能无处不在，几乎所有的操作最终都可能会面临内存分配失败。以外，
许多操作可能会抛出异常。例如，访问一个全局变量可能会触发__index元方法，而该元方法
又可能会抛出异常。最后，分配内存的操作会触发垃圾收集器，而垃圾收集器又可能会抛出异常的
析构器。简而言之：Lua API中的绝大数函数都可能抛出异常。
    Lua语言使用异常来提示错误，而没有在API的每个操作中使用错误码。
    与C++和Java不同，C语言没有提供异常处理机制。为了解决这个问题，
    Lua使用了C语言中的setjmp机制，setjmp营造了一个类似异常处理的机制。因此，大多数API函数
都可以抛出异常(即调用longjmp)而不是直接返回。

    在编写库代码时(被Lua语言调用的C函数)，由于Lua会捕获所有异常，因此，对我们来说
使用longjmp并不用进行额外的操作，不过，在编写应用程序代码(调用Lua的C代码时)，则必须
提供一种捕获异常的方法。

1. 处理应用代码中的错误
    要正确地处理应用代码中的错误，就必须通过Lua语言调用我们自己的代码，这样Lua语言
才能设置合适的上下文来捕获异常，即在setjmp的上下文中运行代码。类似于通过函数pcall
在保护模式中运行Lua代码，我们也可以用函数lua_pcall运行C代码。 更具体地说，可以把C
代码封装到一个函数F中，然后使用lua_pcall调用这个函数F。
static int foo(lua_State *L){
    code to run in protected mode(要以保护模式运行的代码)
    return 0;
}

int secure_foo(lua_State *L){
    lua_pushcfunction(L, foo); // 将foo作为lua函数压栈
    return (lua_pcall(L,0,0,0) == 0)
}


2. 处理库代码中的错误
    在为Lua编写库函数时，通常无需处理错误。库函数抛出的错误要么被Lua中的pcall捕获，
要么被应用代码中的lua_pcall捕获。因此，zaiC语言库中的函数检测到错误时，只需要简单地调用
lua_error即可(或调用luaL_error更好，它会格式化错误信息，然后调用lua_error)。函数
lua_error会收拾Lua系统中的残局，然后跳转回保护模式调用处，并传递错误信息。

--]]
-- https://www.cnblogs.com/chenny7/p/4077364.html
-- https://www.cnblogs.com/chenny7/p/3993456.html
--[[ API
1. 类型声明
typedef double lua_Number;
typedef ptrdiff_t lua_Integer;

2. 初始化lua状态机
lua_State* lua_open();                           // lua_open() 等价于 luaL_newstate()
lua_State* lua_newstate (lua_Alloc f, void *ud); // lua_newstate(l_alloc, NULL) 等价于 luaL_newstate()
lua_newstate 创建一个新的、独立的Lua状态机，如果因为内存不足导致创建失败，返回NULL。
  参数f 指定内存分配函数，
  参数ud是传给f 函数的指针。
lua_open 没有指定内存分配函数的功能，不建议再使用。
注意：lua_State表示的一个Lua程序的执行状态，它代表一个新的线程(注意是指Lua中的thread类型，不是指操作系统中的线程)，
      每个thread拥有独立的数据栈以及函数调用链，还有独立的调试钩子和错误处理方法。

3. 销毁lua状态机
void lua_close(lua_State *L);
销毁Lua状态机的所有对象，回收分配的内存。

4. 加载lua库
void luaL_openlibs(lua_State *L);                   
void luaopen_base(lua_State *L);
void luaopen_package(lua_State *L);
void luaopen_string(lua_State *L);
void luaopen_io(lua_State *L);
void luaopen_table(lua_State *L);
void luaopen_math(lua_State *L);
luaL_openlibs 在给定的Lua状态机中打开所有的标准Lua库；

5. 编译/加载 lua代码
int luaL_dofile(lua_State *L, char *lua_script);
int luaL_dostring (lua_State *L, const char *str);
int lua_load (lua_State *L, lua_Reader reader, void *data,const char *chunkname);
int luaL_loadbuffer (lua_State *L, const char *buff, size_t sz, const char *name);
int luaL_loadfile (lua_State *L, const char *filename);
int luaL_loadstring (lua_State *L, const char *s);
luaL_dofile 加载并执行给定lua文件，成功返回0，错误返回1；
luaL_dostring 加载并执行给定string，成功返回0，错误返回1；
lua_load 加载一段chunk(但并不执行它)，并将编译后的代码作为一个函数压入堆栈，如果发生错误，则将错误消息压入堆栈；
luaL_loadbuffer 从一个buffer中加载chunk；
luaL_loadfile从文件加载chunk；
luaL_loadstring从字符串加载chunk；

6. 函数参数检查
void luaL_checkany (lua_State *L, int narg);                                    // 
void luaL_checktype (lua_State *L, int narg, int t);                            // 
const char *luaL_checklstring (lua_State *L, int narg, size_t *l);              // luaL_checkstring = luaL_checklstring(L, (n), NULL)
const char *luaL_optlstring (lua_State *L, int narg, const char *d, size_t *l); // luaL_optstring = luaL_optlstring(L, (n), (d), NULL)
lua_Number luaL_checknumber (lua_State *L, int narg);                           // 
luaL_optnumber (lua_State *L, int narg, lua_Number def);                        // 
lua_Integer luaL_checkinteger (lua_State *L, int narg);                         // luaL_checkint  luaL_checklong
lua_Integer luaL_optinteger (lua_State *L, int narg, lua_Integer def)           // luaL_optint    luaL_optlong

int luaL_optint(L, int n, int d)     int(stack[n]) or d    [-0 +0 v]    
--- luaL_optinteger(L, int n, l_I d) l_I(stack[n]) or d    [-0 +0 v]    
--- luaL_optlong(L, int n, long d)   long(stack[n]) or d   [-0 +0 v]    
l_N luaL_optnumber(L, int n, l_N d)  l_N(stack[n]) or d    [-0 +0 v]    
str luaL_optstring(L, int n, str d)  str(stack[n]) or d    [-0 +0 v]  

int luaL_checkoption (lua_State *L, int narg, const char *def, const char *const lst[]);
void *luaL_checkudata (lua_State *L, int narg, const char *tname);

// 以下函数都直接依赖于于lua_type函数，在返回值的基础上进行了扩展；不影响栈状态。
luaL_checkany     检查函数等narg位置是否有LUA类型参数                           不符合要求抛出异常
luaL_checktype    检查函数第narg位置是否有指定类型类型参数                      不符合要求抛出异常
luaL_typename     通过lua_type和lua_typename返回类型的字符串描述                不符合返回 "no value"
lua_isfunction  lua_istable     lua_islightuserdata lua_isnil lua_isboolean lua_isthread
lua_isnone      lua_isnoneornil


luaL_checklstring 检查函数第narg位置是否有字符串，len为返回字符串长度           不符合要求抛出异常
                  lua_tolstring
luaL_optlstring   检查函数第narg位置是否有字符串，len为返回字符串长度；有则返回，没有则返回默认值d
                  如果指定位置为none或nil则返回默认值；否则调用luaL_checklstring
                  lua_isnoneornil + luaL_checklstring
luaL_checknumber  检查函数第narg位置是否实数值，                                不符合要求抛出异常
                  lua_tonumber
luaL_optnumber    检查函数第narg位置是否实数值，有则返回，没有则返回默认值d；
                  如果指定位置为none或nil则返回默认值；否则调用luaL_checknumber
                  lua_isnoneornil + luaL_checknumber
luaL_checkinteger 检查函数第narg位置是否整数值，                                不符合要求抛出异常
                  lua_tointeger
luaL_optinteger   检查函数第narg位置是否实数值，有则返回，没有则返回默认值d；
                  如果指定位置为none或nil则返回默认值；否则调用luaL_checkinteger
                  lua_isnoneornil + luaL_checkinteger
                  
luaL_checkudata  检查函数的第 arg 个参数的userdata元表是否和tname指定的元表相等。
                 成功返回p; 失败返回NULL。

luaL_checkoption 检查函数第narg个参数是否位字符串类型，并且在lst[](字符串数组)中搜索这个字符串，
                 最后返回匹配的数组下标，如未能匹配，引发一个错误。
                 
                 如果参数def非空，当narg参数不存在或为nil时，就是要def作为搜索串。
                 这个函数的作用是将字符串映射为C的enum类型。
                 
void luaL_argcheck (lua_State *L, int cond, int arg, const char *extramsg);  // 相当于断言
检查 cond 是否为真。 如果不为真，以标准信息形式抛出一个错误

const char *lua_typename (lua_State *L, int tp);
返回 tp 表示的类型名， 这个 tp 必须是 lua_type 可能返回的值中之一。


7. table操作 
// 获取操作
void  (lua_gettable) (lua_State *L, int idx);  // 弹key压value                  pop k; push stk[i][k] [-1 +1 e] 
把 t[k] 的值压栈，这里的 t 是指索引(idx)指向的值，而 k 则是栈顶放的值。
这个函数会弹出堆栈上的键，把结果放在栈上相同位置。 和在 Lua 中一样， 这个函数可能触发对应 "index" 事件的元方法
返回压入值的类型。
void  (lua_getfield) (lua_State *L, int idx, const char *k); // 指定key压value  push stk[i][k]        [-0 +1 e]
把 t[k] 的值压栈， 这里的 t 是索引(idx)指向的值。 在 Lua 中，这个函数可能触发对应 "index" 事件对应的元方法。
函数将返回压入值的类型。
void  (lua_rawget) (lua_State *L, int idx);    // 弹key压value                  gettable,no metacalls [-1 +1 -] 
类似于 lua_gettable ， 但是作一次直接访问(不触发元方法)
void  (lua_rawgeti) (lua_State *L, int idx, int n);          // 指定pos压value  push stk[i][n];no mt  [-0 +1 -]
把 t[n] 的值压栈， 这里的 t 是指给定索引(idx)处的表。 这是一次直接访问；就是说，它不会触发元方法。
返回入栈值的类型。

void  lua_createtable(lua_State *L, int narr, int nrec);    // 压栈 m,n=arr,rec capacity  [-0 +1 m] 
创建一张新的空表压栈。 
参数 narr 建议了这张表作为序列使用时会有多少个元素；
参数 nrec 建议了这张表可能拥有多少序列之外的元素。
Lua 会使用这些建议来预分配这张新表。 如果你知道这张表用途的更多信息，预分配可以提高性能。
否则，你可以使用函数 lua_newtable 

void lua_newtable (lua_State *L);                           // 压栈  pushes {}             [-0 +1 m]
创建一张空表，并将其压栈。 它等价于 lua_createtable(L, 0, 0) 。

void *(lua_newuserdata) (lua_State *L, size_t sz);          // 压栈
这个函数分配一块指定大小的内存块， 把内存块地址作为一个完全用户数据压栈，并返回这个地址。宿主程序可以随意使用这块内存。

int   (lua_getmetatable) (lua_State *L, int objindex);      // 返回1 压栈；返回0 不压栈
如果该索引(objindex)处的值有元表，则将其元表压栈，返回 1 。 否则不会将任何东西入栈，返回 0 。

void  (lua_getfenv) (lua_State *L, int idx);                // 压栈
把索引处值的环境表压入堆栈。


// 设置操作
void  (lua_settable) (lua_State *L, int idx);               // key和value都出栈      pops k,v; stk[i][k]=v [-2 +0 e] 
作一个等价于 t[k] = v 的操作， 这里 t 是一个给定有效索引 idx 处的值， v 指栈顶的值， 而 k 是栈顶之下的那个值。
这个函数会把键和值都从堆栈中弹出。 和在 Lua 中一样，这个函数可能触发 "newindex" 事件的元方法

void  (lua_setfield) (lua_State *L, int idx, const char *k);  // 指定key, value出栈  pops v; stk[i][k]=v   [-1 +0 e]
做一个等价于 t[k] = v 的操作， 这里 t 是给出的有效索引 idx 处的值， 而 v 是栈顶的那个值。
这个函数将把这个值弹出堆栈。 跟在 Lua 中一样，这个函数可能触发一个 "newindex" 事件的元方法 

void  (lua_rawset) (lua_State *L, int idx);                // key和value都出栈       settable,no metacalls [-2 +0 e] 
类似于 lua_settable， 但是是作一个直接赋值(不触发元方法)。
void  (lua_rawseti) (lua_State *L, int idx, int n);        // 指定key, value出栈     stk[i][n]=pop'd;no mt [-1 +0 e] 
等价于 t[n] = v， 这里的 t 是指给定索引 index 处的一个值， 而 v 是栈顶的值。
函数将把这个值弹出栈。 赋值操作是直接的；就是说，不会触发元方法。

int   (lua_setmetatable) (lua_State *L, int objindex);     // 元表出栈
把一个 table 弹出堆栈，并将其设为给定索引(objindex)处的值的 metatable 。

int   (lua_setfenv) (lua_State *L, int idx);               // 表出栈
从堆栈上弹出一个 table 并把它设为指定索引处值的新环境。 
如果指定索引处的值即不是函数又不是线程或是 userdata ， lua_setfenv 会返回 0 ， 否则返回 1


8. metatable操作
int luaL_newmetatable (lua_State *L, const char *tname);
在Registry中创建一个key为tname的metatable，并返回1；
如果Registry 已经有tname这个key，则返回0；这两种情况都会将metatable压入堆栈；

void luaL_getmetatable (lua_State *L, const char *tname);     
将Registry中key为tname的metatable压入堆栈；

int lua_getmetatable (lua_State *L, int index);  // push mt(stk[i])if any [-1 +0|1 -]  
将index处的元表压入堆栈；

int lua_setmetatable (lua_State *L, int index);  // pop mt; mt(stk[i])=mt [-1 +0 -] 
弹出栈顶，并将它作为由index指定元素的元表；

int luaL_getmetafield (lua_State *L, int obj, const char *e);
将索引obj处的元素的元表的e字段压入堆栈；


int lua_next(L, int i)               pop k/push k,v if any [-1 +0|2 e]  
szt lua_objlen(L, int i)  Lua 5.1    #stk[i], assuming seq [-0 +0 -]    
szt lua_rawlen(L, int i)  Lua 5.2+   #stk[i], assuming seq [-0 +0 -]    
                                                                        
    lua_setglobal(L, str name)       pops v; _G[name]=v    [-1 +0 e]    
    lua_getglobal(L, str name)       pushes _G[name]       [-0 +1 e]    
                                                                        
int luaL_getmetafield(L, int i, str) +mt(stk[i])[s] if any [-1 +0|1 e] 


9. 函数调用
int lua_pcall (lua_State *L, int nargs, int nresults, int errfunc); // 以保护模式调用函数，如果发生错误，捕捉它，并将错误消息压入栈，然后返回错误码。
int lua_cpcall (lua_State *L, lua_CFunction func, void *ud);        // 以保护模式调用C函数func，参数ud指针指向一个用户自定义数据。
void lua_call (lua_State *L, int nargs, int nresults); // 调用函数，参数nargs指定函数参数个数，参数nresults指定返回值个数。
// 首先，被调函数必须在栈中；
// 其次，函数参数必须是按从左往右的顺序入栈的；
// 函数调用时，所有函数参数都会弹出堆栈。函数返回时，其返回值入栈（第一个返回最最先入栈）。

下面的例子中，这行 Lua 代码等价于在宿主程序中用 C 代码做一些工作：
     a = f("how", t.x, 14)
这里是 C 里的代码：
     lua_getglobal(L, "f");                  /* function to be called */
     lua_pushliteral(L, "how");                       /* 1st argument */
     lua_getglobal(L, "t");                    /* table to be indexed */
     lua_getfield(L, -1, "x");        /* push result of t.x (2nd arg) */
     lua_remove(L, -2);                  /* remove 't' from the stack */
     lua_pushinteger(L, 14);                          /* 3rd argument */
     lua_call(L, 3, 1);     /* call 'f' with 3 arguments and 1 result */
     lua_setglobal(L, "a");                         /* set global 'a' */

10 .错误处理
int luaL_error (lua_State *L, const char *fmt, ...);
引发一个错误。

11. thread 操作
lua_State *lua_newthread (lua_State *L);
int lua_resume (lua_State *L, int narg);
int lua_yield (lua_State *L, int nresults);
lua_newthread 创建一个新的thread，然后压入堆栈，并返回一个lua_State*指针表示创建的新thread。
新创建的thread与当前thread共享一个全局环境。没有销毁thread的显式调用，它由垃圾收集器负责回收。
--]]

--[[
对于可被Lua调用的C函数而言，其接口必须遵循Lua要求的形式，即
typedef int (*lua_CFunction)(lua_State* L);
接收一个参数Lua_State*，即Lua的状态，返回值表示压入栈中的结果个数。

 
把要调用的C 函数注册到lua状态机中：
void lua_register (lua_State *L, const char *name, lua_CFunction f);
lua_register 是一个宏：#define lua_register(L,n,f) (lua_pushcfunction(L, f), lua_setglobal(L, n))
其中，参数name是lua中的函数名，f 是C中的函数。
从宏定义可以看出，这个函数的作用是把C函数压入堆栈，并在全局环境中设置Lua函数名；
--]]

--[[ 内存分配
typedef void * (*lua_Alloc) (void *ud,      // lua_newstate所提供的用户数据
                             void *ptr,     // 正要被(重)分配或者释放的块的地址
                             size_t osize,  // 原始块的大小
                             size_t nsize); // 请求的块大小
Lua 状态机中使用的内存分配器函数的类型。 内存分配函数必须提供一个功能类似于 realloc 但又不完全相同的函数。
    它的参数有 ud ，一个由 lua_newstate 传给它的指针；                   
    ptr ，一个指向已分配出来/将被重新分配/要释放的内存块指针；
    osize ，内存块原来的尺寸或是关于什么将被分配出来的代码；
    nsize ，新内存块的尺寸。
    
如果 ptr 不是 NULL， osize 是 ptr 指向的内存块的尺寸， 即这个内存块当初被分配或重分配的尺寸。
如果 ptr 是 NULL，   osize 是 Lua 即将分配对象类型的编码。 当(且仅当)Lua 创建一个对应类型的新对象时，
osize 是 LUA_TSTRING，LUA_TTABLE，LUA_TFUNCTION， LUA_TUSERDATA，或 LUA_TTHREAD 中的一个。 
若 osize 是其它类型，Lua 将为其它东西分配内存。

Lua 假定分配器函数会遵循以下行为：
当 nsize 是零时，   分配器必须和 free 行为类似并返回 NULL。
当 nsize 不是零时， 分配器必须和 realloc 行为类似。 如果分配器无法完成请求，返回 NULL。 Lua 假定在 osize >= nsize 成立的条件下， 分配器绝不会失败。
如果ptr是NULL并且nsize为零，则两条规则都适用：最终结果是分配什么都不做，返回NULL.


lua_Alloc lua_getallocf (lua_State *L, void **ud);
返回给定状态机的内存分配器函数。 如果 ud 不是 NULL ， Lua 把设置内存分配函数时设置的那个指针置入 *ud 。

void lua_setallocf (lua_State *L, lua_Alloc f, void *ud);
把指定状态机的分配器函数换成带上用户数据 ud 的 f 。
--]]





















