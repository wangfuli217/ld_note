#include <stdio.h>
#include "helper.h"
#include <limits.h>
#include "lauxlib.h"
#include "lualib.h"

#define BITS_PER_WORD (CHAR_BIT * sizeof(unsigned int))
#define I_WORD(i) ((unsigned int )(i) / BITS_PER_WORD)
#define I_BIT(i) (1 << ((unsigned int)(i) % BITS_PER_WORD))

typedef struct NumArray{
    int size;
    unsigned  int values[1];
} NumArray;


static int newarray(lua_State *L){
    int size = luaL_checkinteger(L,1);
    luaL_argcheck(L,size>1,1,"invalid size");
    size_t  bytes   = sizeof( NumArray) + I_WORD(size - 1) * sizeof(unsigned int );
    NumArray *array = (NumArray *)lua_newuserdata(L,bytes);
    array->size     = size;
    for(int i = 0;i <= I_WORD(size - 1);i++){
        array->values[i] = 0;
    }
    return 1;
}

static int setarray(lua_State *L){
    NumArray *array = (NumArray *)lua_touserdata(L,1);
    int index = luaL_checkinteger(L,2) - 1;
    luaL_checktype(L,3,LUA_TBOOLEAN);
    luaL_argcheck(L,array!=NULL,1,"array expect");
    luaL_argcheck(L,index >= 0 && index < array->size,2,"invalid index");
    int value = lua_toboolean(L,3);
    if(value){
        array->values[I_WORD(index)] = array->values[I_WORD(index)] | I_BIT(index);
    }else{
        array->values[I_WORD(index)] = array->values[I_WORD(index)] & (~I_BIT(index));
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

static int unionarray(lua_State *L){
    NumArray *a1 = (NumArray *)lua_touserdata(L,1);
    NumArray *a2 = (NumArray *)lua_touserdata(L,2);
    if(a1== NULL || a2 == NULL){
        error(L,"parameter should be array");
    }
    int maxsize = a1->size > a2->size ? a1->size : a2->size;

    int size = sizeof(NumArray) + I_WORD(maxsize - 1) * sizeof(unsigned int );

    NumArray * array = (NumArray *)lua_newuserdata(L,size);
    array->size = maxsize;
    int max = I_WORD(maxsize -1);
    int len1= I_WORD(a1->size-1);
    int len2= I_WORD(a2->size-1);
    for(int i = 0; i<= max; i++){
        unsigned  int v1 = i <= len1  ? a1->values[i] : 0;
        unsigned  int v2 = i <= len2  ? a2->values[i] : 0;
        array->values[i] = v1 | v2;
    }
    return 1;
}

static int intersectionarray(lua_State *L){
    NumArray *a1 = (NumArray *)lua_touserdata(L,1);
    NumArray *a2 = (NumArray *)lua_touserdata(L,2);
    if(a1== NULL || a2 == NULL){
        error(L,"parameter should be array");
    }
    int minsize = a1->size < a2->size ? a1->size : a2->size;

    int size = sizeof(NumArray) + I_WORD(minsize-1) * sizeof(unsigned int );

    NumArray * array = (NumArray *)lua_newuserdata(L,size);
    array->size = minsize;
    int min = I_WORD(minsize);

    for(int i = 0; i<=min; i++){
        array->values[i] =  a1->values[i] &  a2->values[i];
    }
    return 1;
}

const static luaL_Reg funcs[] = {
        {"new", newarray},
        {"get", getarray},
        {"set", setarray},
        {"size",getsize},
        {"union",unionarray},
        {"inter",intersectionarray},
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
