//
// Created by 范鑫磊 on 17/2/13.
//

#include "helper.h"
#include "lauxlib.h"
#include "lualib.h"
#include "expat.h"

typedef struct lxp_userdata{
    XML_Parser  parser;
    lua_State   *L;
} lxp_userdata;

static void f_StartElement(void *ud, const char *name, const char **atts);
static void f_EndElement(void *ud, const char *name);
static void f_CharData(void *ud, const char *s,int len);

static int l_new(lua_State *L){
    size_t size = sizeof(struct lxp_userdata);
    lxp_userdata *lu = (lxp_userdata *)lua_newuserdata(L,size);
    luaL_setmetatable(L,"Ex.lxp");

    XML_Parser p;
    p=lu->parser = XML_ParserCreate(NULL);
    if(!p)
        luaL_error(L,"xml parser create failed ...");

    luaL_checktype(L,1,LUA_TTABLE);
    lua_pushvalue(L,1);
    lua_setuservalue(L,-2);
    XML_SetUserData(p,lu);
    XML_SetElementHandler(p,f_StartElement,f_EndElement);
    XML_SetCharacterDataHandler(p,f_CharData);
    return 1;
}

static int l_parse(lua_State *L){
    lxp_userdata *lu = luaL_checkudata(L,1,"Ex.lxp");
    luaL_argcheck(L,lu->parser != NULL ,1,"parse is closed");
    size_t len;
    const char *content = luaL_checklstring(L,2,&len);
    lua_getuservalue(L,1);
    lu->L = L;
    int status = XML_Parse(lu->parser,content,len,1);
    lua_pushboolean(L,status);
    return 1;
}

static int l_close(lua_State *L){
    lxp_userdata *lu = (lxp_userdata *)luaL_checkudata(L,1,"Ex.lxp");
    if(lu->parser)
        XML_ParserFree(lu->parser);
    lu->parser = NULL;
    return 0;
}


const static luaL_Reg funcs[] = {
        {"new",l_new},
        {NULL,NULL}

};

const static luaL_Reg mefuncs[] = {
        {"parse",l_parse},
        {"close",l_close},
        {NULL,NULL}
};

static int luaopen_lxp(lua_State *L){

    luaL_newmetatable(L,"Ex.lxp");

    lua_pushvalue(L,-1);

    lua_setfield(L,-2,"__index");

    luaL_setfuncs(L,mefuncs,0);

    luaL_newlib(L,funcs);
    return 1;
}

static void f_EndElement(void *ud,const char *name){
    lxp_userdata *lu = (lxp_userdata *)ud;

    lua_State *L = lu->L;
    lua_getfield(L,3,"EndElement");
    if(lua_isnil(L,-1)){
        lua_pop(L,1);
        return;
    }
    lua_pushvalue(L,1);
    lua_pushstring(L,name);
    lua_call(L,2,0);
}

static void f_StartElement(void *ud, const char *name, const char **atts){
    lxp_userdata *lu = (lxp_userdata *)ud;
    lua_State *L = lu->L;
    lua_getfield(L,3,"StartElement");
    if(lua_isnil(L,-1)){
        lua_pop(L,1);
        return;
    }
    lua_pushvalue(L,1);
    lua_pushstring(L,name);
    lua_newtable(L);
    lua_newtable(L);
    int i = 1;
    for(;*atts;atts+=2){
        lua_pushstring(L,*(atts + 1));
        lua_setfield(L,-3,*atts);

        lua_pushstring(L,*atts);
        lua_rawseti(L,-2,i++);

    }

    lua_call(L,4,0);
}

static void f_CharData(void *ud, const char *s,int len){
    lxp_userdata *lu = (lxp_userdata *)ud;
    lua_State *L = lu->L;
    lua_getfield(L,3,"ChatacterData");
    if(lua_isnil(L,-1)){
        lua_pop(L,1);
        return;
    }
    lua_pushvalue(L,1);
    lua_pushlstring(L,s,len);
    lua_call(L,2,0);
}

int main(){
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);
    lua_getglobal(L,"package");
    lua_getfield(L,-1,"preload");
    lua_pushcfunction(L,luaopen_lxp);
    lua_setfield(L,-2,"lxp");
    if( luaL_loadfile(L, "./test.lua") || lua_pcall(L,0,0,0)){
        error(L,"error load file %s",lua_tostring(L,-1));
    }
    lua_close(L);
    return 0;
}