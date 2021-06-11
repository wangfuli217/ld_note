//.....
lua_getgloabl(L,"he");
lua_pushnumber(L,5);
lua_pushnumber(L,6);
// run the lua program
// lua_pcall(L,nargs,nresults,0)
if(lua_pcall(L,2,1,0) != 0)
    printf("error pcall!: %s\n",lua_tostring(L,-1)); 
// if error then push errorinfo in the stack else push reuslts
if(!lua_isnumber(L,-1))
    printf("error return!\n");
int re = (int)lua_tonumber(L,-1);

/*
function he(x,y)
    return x*y
end
*/