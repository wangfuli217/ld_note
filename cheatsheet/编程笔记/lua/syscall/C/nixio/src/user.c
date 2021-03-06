/*
 * nixio - Linux I/O library for lua
 *
 *   Copyright (C) 2009 Steven Barth <steven@midlink.org>
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

#include "nixio.h"
#include <sys/types.h>
#include <errno.h>
#include <unistd.h>
#include <sys/param.h>

#ifndef __WINNT__

#include <grp.h>
#include <pwd.h>

#ifndef BSD
#include <shadow.h>
#include <crypt.h>
#endif

int nixio__check_group(lua_State *L, int idx) {
	if (lua_isnumber(L, idx)) { // integer
		return lua_tointeger(L, idx);
	} else if (lua_isstring(L, idx)) { //string 找不到名字返回-1
		struct group *g = getgrnam(lua_tostring(L, idx));
		return (!g) ? -1 : g->gr_gid;
	} else { // other
		return luaL_argerror(L, idx, "supported values: <groupname>, <gid>");
	}
}

int nixio__check_user(lua_State *L, int idx) {
	if (lua_isnumber(L, idx)) { // integer
		return lua_tointeger(L, idx);
	} else if (lua_isstring(L, idx)) { // string找不到名字返回-1
		struct passwd *p = getpwnam(lua_tostring(L, idx));
		return (!p) ? -1 : p->pw_uid;
	} else { // other
		return luaL_argerror(L, idx, "supported values: <username>, <uid>");
	}
}

// group
static int nixio__push_group(lua_State *L, struct group *gr) {
	lua_createtable(L, 0, 4); //  void lua_createtable (lua_State *L, int narr, int nrec);
	lua_pushstring(L, gr->gr_name);
	lua_setfield(L, -2, "name");
	lua_pushstring(L, gr->gr_passwd);
	lua_setfield(L, -2, "passwd");
	lua_pushinteger(L, gr->gr_gid);
	lua_setfield(L, -2, "gid");

	lua_newtable(L);  // void lua_newtable (lua_State *L);

	for (int i=0; gr->gr_mem[i]; i++) { // 组成员
		lua_pushstring(L, gr->gr_mem[i]);
		lua_rawseti(L, -2, i+1); // void lua_rawseti (lua_State *L, int index, lua_Integer i);
	}

	lua_setfield(L, -2, "mem");
	return 1;
}

// data = nixio.getgr() 
// data = nixio.getgr('root')
static int nixio_getgr(lua_State *L) {
	struct group *gr;
	errno = 0;
	if (lua_isnumber(L, 1)) { // integer
		gr = getgrgid(lua_tointeger(L, 1));
	} else if (lua_isstring(L, 1)) { //string
		gr = getgrnam(lua_tostring(L, 1));
	} else if (lua_isnoneornil(L, 1)) { // nil or TNONE
		lua_newtable(L);
		int i = 0;

		setgrent(); // init
		while ((gr = getgrent())) { // get
			nixio__push_group(L, gr);
			lua_rawseti(L, -2, ++i);
		}

		if (errno) {
			return nixio__perror(L);
		}

		endgrent(); // finiize
		return 1; // return table{table}
	} else {
		return luaL_argerror(L, 1, "supported values: <groupname>, <gid>");
	}

	if (!gr) {
		return nixio__perror(L);
	} else {
		return nixio__push_group(L, gr); // return table
	}
}


//
static int nixio__push_passwd(lua_State *L, struct passwd *pw) {
	lua_createtable(L, 0, 7);
	lua_pushstring(L, pw->pw_name);
	lua_setfield(L, -2, "name");
	lua_pushstring(L, pw->pw_passwd);
	lua_setfield(L, -2, "passwd");
	lua_pushinteger(L, pw->pw_gid);
	lua_setfield(L, -2, "gid");
	lua_pushinteger(L, pw->pw_uid);
	lua_setfield(L, -2, "uid");
	lua_pushstring(L, pw->pw_dir);
	lua_setfield(L, -2, "dir");
	lua_pushstring(L, pw->pw_gecos);
	lua_setfield(L, -2, "gecos");
	lua_pushstring(L, pw->pw_shell);
	lua_setfield(L, -2, "shell");
	return 1;
}

static int nixio_getpw(lua_State *L) {
	struct passwd *pw;
	errno = 0;
	if (lua_isnumber(L, 1)) { // number
		pw = getpwuid(lua_tointeger(L, 1));
	} else if (lua_isstring(L, 1)) { //string
		pw = getpwnam(lua_tostring(L, 1));
	} else if (lua_isnoneornil(L, 1)) { //nil 或者 TNONE
		lua_newtable(L);
		int i = 0;

		setpwent();
		while ((pw = getpwent())) {
			nixio__push_passwd(L, pw);
			lua_rawseti(L, -2, ++i);
		}

		if (errno) {
			return nixio__perror(L);
		}

		endpwent();
		return 1;
	} else { // other
		return luaL_argerror(L, 1, "supported values: <username>, <uid>");
	}

	if (!pw) {
		return nixio__perror(L);
	} else {
		return nixio__push_passwd(L, pw);
	}
}

#ifndef BSD
static int nixio__push_spwd(lua_State *L, struct spwd *sp) {
	lua_createtable(L, 0, 9);
	lua_pushstring(L, sp->sp_namp);
	lua_setfield(L, -2, "namp");
	lua_pushinteger(L, sp->sp_expire);
	lua_setfield(L, -2, "expire");
	lua_pushinteger(L, sp->sp_flag);
	lua_setfield(L, -2, "flag");
	lua_pushinteger(L, sp->sp_inact);
	lua_setfield(L, -2, "inact");
	lua_pushinteger(L, sp->sp_lstchg);
	lua_setfield(L, -2, "lstchg");
	lua_pushinteger(L, sp->sp_max);
	lua_setfield(L, -2, "max");
	lua_pushinteger(L, sp->sp_min);
	lua_setfield(L, -2, "min");
	lua_pushinteger(L, sp->sp_warn);
	lua_setfield(L, -2, "warn");
	lua_pushstring(L, sp->sp_pwdp);
	lua_setfield(L, -2, "pwdp");
	return 1;
}

static int nixio_getsp(lua_State *L) {
	struct spwd *sp;
	errno = 0;
	if (lua_isstring(L, 1)) { // string
		sp = getspnam(lua_tostring(L, 1));
	} else if (lua_isnoneornil(L, 1)) { // nil or TNONE
		lua_newtable(L);
		int i = 0;

		setspent();
		while ((sp = getspent())) {
			nixio__push_spwd(L, sp);
			lua_rawseti(L, -2, ++i);
		}

		if (errno) {
			return nixio__perror(L);
		}

		endspent();
		return 1;
	} else { // other
		return luaL_argerror(L, 1, "supported values: <username>");
	}

	if (!sp) {
		return nixio__perror(L);
	} else {
		return nixio__push_spwd(L, sp);
	}
}
#endif /* !BSD */

// pwdp = nixio.getsp(username).pwdp
// print(pwdp)
// print(nixio.crypt('123456', pwdp))
static int nixio_crypt(lua_State *L) {
	const char *key = luaL_checkstring(L, 1);
	const char *salt = luaL_checkstring(L, 2);
	const char *hash = crypt(key, salt);

	if (hash) {
		lua_pushstring(L, hash);
	} else {
		lua_pushnil(L);
	}

	return 1;
}


/* module table */
static const luaL_reg R[] = {
	{"crypt",		nixio_crypt},
	{"getgr",		nixio_getgr},
	{"getpw",		nixio_getpw},
#ifndef BSD
	{"getsp",		nixio_getsp},
#endif
	{NULL,			NULL}
};

#else /* __WINNT__ */

static const luaL_reg R[] = {
		{NULL,			NULL}
};

#endif

void nixio_open_user(lua_State *L) {
	luaL_register(L, NULL, R); // [nixio.socket], [nixio] 将R表中函数注册到nixio中
}
