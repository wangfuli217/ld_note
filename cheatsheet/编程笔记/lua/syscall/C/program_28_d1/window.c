#include <stdio.h>
#include <string.h>
#include  "lua.h"
#include "lauxlib.h"
#include "lualib.h"

#include "util.h"

int getglobint(lua_State *L, const char *var) {
    int isnum, result;
    // int lua_getglobal (lua_State *L, const char *name);
    // 把全局变量 name 里的值压栈，返回该值的类型。
    lua_getglobal(L, var);
    
    // lua_Integer lua_tointeger (lua_State *L, int index);
    // 将给定索引处的 Lua 值转换为带符号的整数类型 lua_Integer。 
    // 这个 Lua 值必须是一个整数，或是一个可以被转换为整数的数字或字符串； 否则，lua_tointegerx 返回 0 。
    result = (int) lua_tointeger(L, -1);
/*
    result = (int) lua_tointegerx(L, -1, &isnum);
    if (!isnum)
        error(L, "'%s' should be a number\n", var);
*/
    
    lua_pop(L, 1);
    return result;
}

void load(lua_State *L, const char *fname, int *w, int *h) {
    // int luaL_loadfile (lua_State *L, const char *filename);
    // 把一个文件加载为 Lua 代码块。 这个函数使用 lua_load 加载文件中的数据。 代码块的名字被命名为 filename。
    // 如果 filename 为 NULL， 它从标准输入加载。 
    // 如果文件的第一行以 # 打头，则忽略这一行。
    
    // int lua_pcall (lua_State *L, int nargs, int nresults, int msgh);
    // 以保护模式调用一个函数。
    // nargs 是你压入栈的参数个数。当函数调用完毕后，所有的参数以及函数本身都会出栈。 
    // 而函数的返回值这时则被压栈。返回值的个数将被调整为 nresults 个， 除非 nresults 被设置成 LUA_MULTRET。
    if (luaL_loadfile(L, fname) || lua_pcall(L, 0, 0, 0))
        error(L, "cannot run config. file: %s", lua_tostring(L, -1)); // -1 表示栈顶
    *w = getglobint(L, "width");
    *h = getglobint(L, "height");
}

#define MAX_COLOR 255

struct ColorTable {
    char *name;
    unsigned char red, green, blue;
} colortable[] = {
    {"WHITE", MAX_COLOR, MAX_COLOR, MAX_COLOR},
    {"RED", MAX_COLOR, 0, 0},
    {"GREEN", 0, MAX_COLOR, 0},
    {"BLUE", 0, 0, MAX_COLOR},
    {NULL, 0, 0, 0}
};

int getcolorfield(lua_State *L, const char *key) {
    int result, isnum;
    // const char *lua_pushstring (lua_State *L, const char *s);
    // 将指针 s 指向的零结尾的字符串压栈。Lua 对这个字符串做一个内部副本(或是复用一个副本)，
    // 因此 s 处的内存在函数返回后，可以释放掉或是立刻重用于其它用途。
    // 返回内部副本的指针。
    // 如果 s 为 NULL，将 nil 压栈并返回 NULL。
    lua_pushstring(L, key); //
    
    // int lua_gettable (lua_State *L, int index);
    // 把 t[k] 的值压栈， 这里的 t 是指索引指向的值， 而 k 则是栈顶放的值。
    // 这个函数会弹出堆栈上的键，把结果放在栈上相同位置。 和在 Lua 中一样， 这个函数可能触发对应 "index" 事件的元方法 
    // 返回压入值的类型。
    lua_gettable(L, -2);    
    
    // lua_Number lua_tonumber (lua_State *L, int index);
    // 把给定索引处的 Lua 值转换为 lua_Number 这样一个 C 类型.
    // 这个 Lua 值必须是一个数字或是一个可转换为数字的字符串 
    // 否则， lua_tonumberx 返回 0 
    result = (int)(lua_tonumber(L, -1) * MAX_COLOR);
/*
    result = (int)(lua_tonumberx(L, -1, &isnum) * MAX_COLOR);
    if (!isnum)
        error(L, "invalid componet '%s' in color", key);
*/
    lua_pop(L, 1);
    return result;
}

int setcolorfield(lua_State *L, const char *index, int value) {
    // const char *lua_pushstring (lua_State *L, const char *s);
    // 将指针 s 指向的零结尾的字符串压栈。Lua 对这个字符串做一个内部副本(或是复用一个副本)，
    // 因此 s 处的内存在函数返回后，可以释放掉或是立刻重用于其它用途。
    // 返回内部副本的指针。
    // 如果 s 为 NULL，将 nil 压栈并返回 NULL。
    lua_pushstring(L, index);
    
    // void lua_pushnumber (lua_State *L, lua_Number n);
    // 把一个值为 n 的浮点数压栈。
    lua_pushnumber(L, (double)value / MAX_COLOR);
    
    // void lua_settable (lua_State *L, int index);
    // 做一个等价于 t[k] = v 的操作， 这里 t 是给出的索引处的值， v 是栈顶的那个值， k 是栈顶之下的值。
    lua_settable(L, -3);
}

void setcolor(lua_State *L, struct ColorTable *ct) {
    // void lua_newtable (lua_State *L);
    // 创建一张空表，并将其压栈。 它等价于 lua_createtable(L, 0, 0) 。
    lua_newtable(L);
    setcolorfield(L, "red", ct->red);
    setcolorfield(L, "green", ct->green);
    setcolorfield(L, "blue", ct->blue);
    
    // void lua_setglobal (lua_State *L, const char *name);
    // 从堆栈上弹出一个值，并将其设为全局变量 name 的新值。
    lua_setglobal(L, ct->name);
}

int main(int argc, char *argv[]) {
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);
    int w, h;

    load(L, argv[1], &w, &h);

    printf("width: %d\n", w);
    printf("height: %d\n", h);

    int red, green, blue;
    lua_getglobal(L, "background");
    if (lua_isstring(L, -1)) {
        const char *name = lua_tostring(L, -1);
        int i = 0;
        for (i = 0; colortable[i].name != NULL; i++) {
            if (strcmp(name, colortable[i].name) == 0) {
                break;
            }
        }
        red = colortable[i].red;
        green = colortable[i].green;
        blue = colortable[i].blue;
    } else if (lua_istable(L, -1)) {
        red = getcolorfield(L, "red");
        green = getcolorfield(L, "green");
        blue = getcolorfield(L, "blue");
    } else {
        error(L, "invalid value for 'background'");
    }

    printf("red: %d, green: %d, blue: %d\n", red, green, blue);

    lua_close(L);
    return 0;
}
