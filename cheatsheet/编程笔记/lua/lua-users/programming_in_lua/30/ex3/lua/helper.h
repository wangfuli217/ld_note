//
// Created by 范鑫磊 on 17/2/8.
//

#ifndef UNTITLED_HELPER_H
#define UNTITLED_HELPER_H

#include "lua.h"

void dumpStack(lua_State *);

void error(lua_State *, const char *, ...);


#endif //UNTITLED_HELPER_H
