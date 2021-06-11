#include <stdio.h>
#include "helper.h"
#include <limits.h>
#include "lauxlib.h"
#include "lualib.h"

// 一个无符号整型的bit数量
#define BITS_PER_WORD (CHAR_BIT * sizeof(unsigned int))
// 根据给定的索引来计算对应的bit位所存放的word
#define I_WORD(i) ((unsigned int )(i) / BITS_PER_WORD)
// 计算出一个掩码，用于访问这个word中的正确bit
#define I_BIT(i) (1 << ((unsigned int)(i) % BITS_PER_WORD))

// 布尔数组
typedef struct NumArray{
    int size;
// 由于C89标准不允许分配0长度的数组，所以声明了数组values需要有一个元素来作为占位符。
// 接下来会在分配数组时定义实际的大小
    unsigned  int values[1]; // 可变部分
} NumArray;

// 注意，这里无须对I_WORD加1，因为原来的结构中已经包含了一个元素的空间。
// sizeof(NumArray) + I_WORD(n-1)*sizeof(unsigned int) 拥有n个元素的数组大小

// 首先要面临的问题是如何在Lua中表示这个NumArray结构。Lua为此提供了一种基本类型userdata。
// userdata提供了一块原始的内存区域，可以用来存储任何东西。并且，在Lua中userdata没有任何预定义的操作。

static int newarray(lua_State *L){
    
// 宏luaL_checkint只是在调用luaL_checkinteger后进行了一个类型转换。
//只要在Lua中注册好newarray，就可以通过语句a=array.new(1000)来创建一个新数组。
    int size = luaL_checkinteger(L,1);
    luaL_argcheck(L, size>1, 1, "invalid size");
    size_t bytes = sizeof(NumArray) + I_WORD(size - 1) * sizeof(unsigned int);
//函数lua_newuserdata会根据指定的大小分配一块内存，并将对应的userdata压入栈中，最后返回这个内存块的地址
    NumArray *array = (NumArray *)lua_newuserdata(L,bytes); 
// 如果由于某些原因，需要通过其他机制来分配内存。那么可以创建只有一个指针大小的userdata，然后将指向真正内存块的指针存入其中。
    array->size = size;
    for(int i = 0;i<=I_WORD(size-1);i++){
        array->values[i] = 0; // 初始化数组
    }
    return 1; // 新的用户数据已经在栈中
}
// 可以通过这样的调用array.set(array, index, value)，在数组中存储元素。
// 后面的内容会介绍如何使用元表来实现更传统的语法array[index]=value。无论哪种写法，底层函数都是相同的。
static int setarray(lua_State *L){
    NumArray *array = (NumArray *)lua_touserdata(L,1); // 数组
    int index = luaL_checkinteger(L,2) - 1;            // 索引
    luaL_checktype(L,3,LUA_TBOOLEAN);                  // 新值
    luaL_argcheck(L,array!=NULL,1,"array expect");
    luaL_argcheck(L,index >= 0 && index < array->size,2,"invalid index");
    int value = lua_toboolean(L,3);
    if(value){
        array->values[I_WORD(index)] = array->values[I_WORD(index)] | I_BIT(index);    // 设置bit 
    }else{
        array->values[I_WORD(index)] = array->values[I_WORD(index)] & (~I_BIT(index)); // 重置bit
    }

    return 0;
}

static int getarray(lua_State *L){
    NumArray * array = (NumArray *)lua_touserdata(L,1);
    int index = luaL_checkinteger(L,2) -1 ;
    luaL_argcheck(L,array!=NULL,1,"array expect");
    luaL_argcheck(L,index >= 0 && index < array->size,2,"invalid index");
    lua_pushboolean(L,array->values[I_WORD(index)] & I_BIT(index));
    return 1;
}

static int getsize(lua_State *L){
    NumArray *array = (NumArray *)lua_touserdata(L,1);
    luaL_argcheck(L,array!=NULL,1,"array expect");
    lua_pushinteger(L,array->size);
    return 1;
}

const static luaL_Reg funcs[] = {
        {"new", newarray},
        {"get", getarray},
        {"set", setarray},
        {"size",getsize},
        {NULL,NULL}
};

static int lua_openarray(lua_State *L){
    luaL_newlib(L,funcs);
    return 1;
}

int main() {
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);
    lua_getglobal(L,"package");
    lua_getfield(L,-1,"preload");
    lua_pushcfunction(L,lua_openarray);
    lua_setfield(L,-2,"array");
    if(luaL_loadfile(L,"./test.lua") || lua_pcall(L,0,0,0)){
        error(L,"error load file %s",lua_tostring(L,-1));
    }
    lua_close(L);
    return 0;
}

/*
a = array.new(1000)
print(a)    			--> userdata: 0x8064d48
print(array.size(a))	--> 1000
for i = 1, 1000 do
    array.set(a, i, i%5 == 0)
end
print(array.get(a, 10))		--> true
*/