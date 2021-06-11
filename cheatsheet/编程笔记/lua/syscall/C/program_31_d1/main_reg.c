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


static int newarray(lua_State *L) {
    int i, n;
    size_t nbytes;
    NumArray *a;
// 宏luaL_checkint只是在调用luaL_checkinteger后进行了一个类型转换。
//只要在Lua中注册好newarray，就可以通过语句a=array.new(1000)来创建一个新数组。
    n = luaL_checkint(L, 1);
    luaL_argcheck(L, n >= 1, 1, "invalid size")
    nbytes = sizeof(NumArray) + I_WORD(n - 1)*sizeof(unsigned int);
//函数lua_newuserdata会根据指定的大小分配一块内存，并将对应的userdata压入栈中，最后返回这个内存块的地址
    a = (NumArray *)lua_newuserdata(L, nbytes);
// 如果由于某些原因，需要通过其他机制来分配内存。那么可以创建只有一个指针大小的userdata，然后将指向真正内存块的指针存入其中。

    a->size = n;
    for(i = 0; i <= I_WORD(n-1); i++)
        a->values[i] = 0;        /* 初始化数组 */
    return 1;        /* 新的userdata已在栈上 */
}
// 由于Lua中任何值都可以转换为布尔，所以这里对第3个参数使用luaL_checkany，
// 它只确保了在这个参数位置上有一个值。如果用错误的参数调用了setarray，就会得到这样的错误消息：
// array.set(0, 11, 0) --> stdin:1: bad argument #1 to 'set' ('array' expected)
// array.set(a, 0)     --> stdin:1: bad argument #3 to 'set' (value expected)
// array.set(array, index, value)
static int setarray(lua_State *L){
    NumArray *a = (NumArray *)lua_touserdata(L, 1);
    int index = luaL_checkint(L, 2) - 1;
    luaL_checkany(L, 3);
    
    luaL_argcheck(L, a != NULL, 1, "'array' expected");
    
    luaL_argcheck(L, 0 <= index && index < a->size, 2, "index out of range");
    
    if(lua_toboolean(L, 3))
        a->values[I_WORD(index)] |= I_BIT(index);    /* 设置bit */
    else
        a->values[I_WORD(index)] &= ~I_BIT(index);    /* 重置bit */
    return 0;
}

static int getarray(lua_State *L) {
    NumArray *a = (NumArray *)lua_touserdata(L, 1);
    int index = luaL_checkint(L, 2) - 1;
    
    luaL_argcheck(L, a != NULL, 1, "'array' expected");
    
    lua_pushboolean(L, a->values[I_WORD(index)] & I_BIT(index));
    return 1;
}

static int getsize(lua_State *L) {
    NumArray *a = (NumArray *)lua_touserdata(L, 1);
    luaL_argcheck(L, a != NULL, 1, "'array' expected");
    lua_pushinteger(L, a->size);
    return 1;
}

// newarray 会把userdata数据类型压入栈中
// setarray 会修改userdata数据类型关联内存
// getarray 会从userdata数据类型关联内存的值压入栈中
// getsize  会从userdata数据类型关联内存计算值压入栈中
static const struct luaL_Reg arraylib [] = {
    {"new", newarray},
    {"set", setarray},
    {"get", getarray},
    {"size", getsize},
    {NULL, NULL}
};

int luaopen_array(lua_State *L) {
    luaL_register(L, "array", arraylib);
    return 1;
}

/*
require "array"

a = array.new(100)
print(array.size(a))

for i = 1, 100 do
    array.set(a, i, i)
end

print(array.get(a, 10))
*/
