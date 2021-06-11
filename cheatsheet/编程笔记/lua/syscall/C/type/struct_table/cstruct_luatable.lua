=====main.cpp=======
#include "stdio.h"

extern "C"
{
#include "lua/lua.h"
#include "lua/lualib.h"
#include "lua/lauxlib.h"
};

typedef struct 
{
int  wChairID;
int  iHeroID;
int  iChosenHeros[16];
}
Player;

/* LUA接口声明*/
lua_State* L;

void Operate(Player &obj)
{
    int i;

    lua_getglobal(L, "PlayOperate");

    lua_newtable(L);
    lua_pushstring(L, "wChairID");
    lua_pushnumber(L, obj.wChairID);
    lua_settable(L, -3);
    lua_pushstring(L, "iHeroID");
    lua_pushnumber(L, obj.iHeroID);
    lua_settable(L, -3);

    lua_pushstring(L, "iChosenHeros");
    lua_newtable(L);
    for (i=0;i<16;++i)
    {
        lua_pushnumber(L, i);
        lua_pushnumber(L, obj.iChosenHeros[i]);
        lua_settable(L, -3);
    }
    lua_settable(L, -3);

    lua_call(L, 1, 1);

    lua_pushstring(L, "wChairID");
    int n=lua_gettop(L);
    lua_gettable(L, -2);
    obj.wChairID = (int)lua_tonumber(L, -1);
    lua_pop(L, 1);
    lua_pushstring(L, "iHeroID");
    lua_gettable(L, -2);
    obj.iHeroID = (int)lua_tonumber(L, -1);
    lua_pop(L, 1);
    lua_pushstring(L, "iChosenHeros");
    lua_gettable(L, -2);
    for (i=0;i<16;++i)
    {
        lua_pushnumber(L, i);
        lua_gettable(L, -2);
        obj.iChosenHeros[i]=(int)lua_tonumber(L, -1);
        lua_pop(L, 1);
    }

}

int main(int argc, char *argv[])
{
    int i;
    Player obj;

    obj.wChairID = 1;
    obj.iHeroID  = 2;

    for(i=0; i<16; ++i)
        obj.iChosenHeros[i]=3;

    //print initial value
    printf( "The origin is blow:\n");
    printf( "obj.wChairID = %d\n", obj.wChairID);
    printf( "obj.iHeroID = %d\n", obj.iHeroID);
    for(i=0; i<16; ++i)
        printf( "obj.iChosenHeros[%d] = %d\n", i, obj.iChosenHeros[i]);


    /* initialize Lua */
    L = lua_open();
    if (NULL == L)
    {
        return -1;
    }
    /* load Lua base libraries */
    luaL_openlibs(L);

    /* load the script */
    luaL_dofile(L, "e:\\aaa.lua");  //这里指定aaa.lua文件的位置

    /* call function */
    Operate(obj);

    /* print the result */
    printf( "The result is blow:\n");
    printf( "obj.wChairID = %d\n", obj.wChairID);
    printf( "obj.iHeroID = %d\n", obj.iHeroID);
    for(i=0; i<16; ++i)
        printf( "obj.iChosenHeros[%d] = %d\n", i, obj.iChosenHeros[i]);

    /* cleanup Lua */
    lua_close(L);

    return 0;

}

=============aaa.lua==========
function PlayOperate(x)
    x.wChairID = x.wChairID+1
    x.iHeroID = x.iHeroID+1
    x.iChosenHeros[0]= 9
    x.iChosenHeros[1]= 10
    
    return x
end