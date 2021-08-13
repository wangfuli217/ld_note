#include <stdio.h>
#include <lua.h> //Lua main library (lua_*)
#include <lauxlib.h> //Lua auxiliary library (luaL_*)

int main(void)
{
    //create a Lua state
    lua_State *L = luaL_newstate();

    //load and execute a string
    if (luaL_dostring(L, "function foo (x,y) return x+y end")) {
        lua_close(L);
        return -1;
    }

    //push value of global "foo" (the function defined above)
    //to the stack, followed by integers 5 and 3
    lua_getglobal(L, "foo");
    lua_pushinteger(L, 5);
    lua_pushinteger(L, 3);
    lua_call(L, 2, 1); //call a function with two arguments and one return value
    printf("Result: %d\n", lua_tointeger(L, -1)); //print integer value of item at stack top
    lua_close(L); //close Lua state
    return 0;
}

// $ cc -o example example.c -llua -lm
// $ ./example 
// Result: 8