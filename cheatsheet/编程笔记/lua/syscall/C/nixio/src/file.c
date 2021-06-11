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
#include <errno.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/param.h>


static int nixio_open(lua_State *L) {
	const char *filename = luaL_checklstring(L, 1, NULL); // const char *luaL_checklstring (L, int i, size_t *n);
	int flags;

	if (lua_isnoneornil(L, 2)) { // default
		flags = O_RDONLY;
	} else if (lua_isnumber(L, 2)) { // number
		flags = lua_tointeger(L, 2);
	} else if (lua_isstring(L, 2)) { // string
		const char *str = lua_tostring(L, 2);
		if (!strcmp(str, "r")) {
			flags = O_RDONLY;
		} else if (!strcmp(str, "r+")) {
			flags = O_RDWR;
		} else if (!strcmp(str, "w")) {
			flags = O_WRONLY | O_CREAT | O_TRUNC;
		} else if (!strcmp(str, "w+")) {
			flags = O_RDWR | O_CREAT | O_TRUNC;
		} else if (!strcmp(str, "a")) {
			flags = O_WRONLY | O_CREAT | O_APPEND;
		} else if (!strcmp(str, "a+")) {
			flags = O_RDWR | O_CREAT | O_APPEND;
		} else {
			return luaL_argerror(L, 2, "supported values: r, r+, w, w+, a, a+");
		}
	} else { // other
		return luaL_argerror(L, 2, "open flags or string expected");
	}

	int fd;

	do {
		fd = open(filename, flags, nixio__check_mode(L, 3, 0666)); // int open(const char *pathname, int flags, mode_t mode)
	} while (fd == -1 && errno == EINTR);
	if (fd == -1) {
		return nixio__perror(L);
	}

	int *udata = lua_newuserdata(L, sizeof(int)); // 
	if (!udata) {
		return luaL_error(L, "out of memory");
	}

	*udata = fd;

	luaL_getmetatable(L, NIXIO_FILE_META);
	lua_setmetatable(L, -2);

	return 1;
}

// 从多个字符串到一个数字的转换
static int nixio_open_flags(lua_State *L) {
	int mode = 0;
	const int j = lua_gettop(L);
	for (int i=1; i<=j; i++) {
		const char *flag = luaL_checkstring(L, i); //luaL_checkstring获取但不弹出栈上内容
		if (!strcmp(flag, "append")) {
			mode |= O_APPEND;
		} else if (!strcmp(flag, "creat")) {
			mode |= O_CREAT;
		} else if (!strcmp(flag, "excl")) {
			mode |= O_EXCL;
		} else if (!strcmp(flag, "nonblock") || !strcmp(flag, "ndelay")) {
#ifndef __WINNT__
			mode |= O_NONBLOCK;
#endif
		} else if (!strcmp(flag, "sync")) {
#ifndef __WINNT__
			mode |= O_SYNC;
#endif
		} else if (!strcmp(flag, "trunc")) {
			mode |= O_TRUNC;
		} else if (!strcmp(flag, "rdonly")) {
			mode |= O_RDONLY;
		} else if (!strcmp(flag, "wronly")) {
			mode |= O_WRONLY;
		} else if (!strcmp(flag, "rdwr")) {
			mode |= O_RDWR;
		} else {
			return luaL_argerror(L, i, "supported values: append, creat, "
					"excl, nonblock, ndelay, sync, trunc");
		}
	}
	lua_pushinteger(L, mode);
	return 1;
}

// 参数可以是nixio.socket nixio.file FILE* 三种类型，共同类型是userdata
// 参数可以为1个，也可以为两个；
// 第一个参数可以为nixio.socket nixio.file FILE* 三种类型之一
// 第二个默认情况下为-1. 也可以为nixio.socket nixio.file FILE* 三种类型之一
static int nixio_dup(lua_State *L) {
	int oldfd = nixio__checkfd(L, 1);
	int newfd = (lua_gettop(L) > 1) ? nixio__checkfd(L, 2) : -1;
	int stat  = (newfd == -1) ? dup(oldfd) : dup2(oldfd, newfd);

	if (stat == -1) { // failure
		return nixio__perror(L);
	} else {
		if (newfd == -1) { // 创建一个新fd
			int *udata = lua_newuserdata(L, sizeof(int));
			if (!udata) { //int luaL_error (L, CC *fs, ...)
				return luaL_error(L, "out of memory");
			}

			*udata = stat;
			luaL_getmetatable(L, NIXIO_FILE_META);
			lua_setmetatable(L, -2);
		} else { // 替换一个老的fd, 相当于复制了一份
			lua_pushvalue(L, 2);
		}
		return 1;
	}
}

static int nixio_pipe(lua_State *L) {
	int pipefd[2], *udata;
	if (pipe(pipefd)) {
		return nixio__perror(L);
	}

	luaL_getmetatable(L, NIXIO_FILE_META); // [M]
	udata = lua_newuserdata(L, sizeof(int));  // [M] [U0]
	if (!udata) {
		return luaL_error(L, "out of memory");
	}

	*udata = pipefd[0];
	lua_pushvalue(L, -2); // [M] [U0] [M]
	lua_setmetatable(L, -2);  // [M] [U0] 


	udata = lua_newuserdata(L, sizeof(int)); // [M] [U0] [U1]
	if (!udata) {
		return luaL_error(L, "out of memory");
	}

	*udata = pipefd[1];
	lua_pushvalue(L, -3); // [M] [U0] [U1] [M]
	lua_setmetatable(L, -2); // [M] [U0] [U1] 

	return 2; //  [U0] [U1]  因为返回值是2，所以[M]会被丢弃掉
}

// write(lstring)
// write(lstring [, offset, wlen])
static int nixio_file_write(lua_State *L) {
	int fd = nixio__checkfd(L, 1);
	size_t len;
	ssize_t sent;
	const char *data = luaL_checklstring(L, 2, &len); // lstring len

	if (lua_gettop(L) > 2) { // offset wlen
		int offset = luaL_optint(L, 3, 0); // offset 位置为nil TNONE的时候，默认值为0
		if (offset) {
			if (offset < len) {
				data += offset;
				len -= offset;
			} else {
				len = 0;
			}
		}

		unsigned int wlen = luaL_optint(L, 4, len); // offset 位置为nil TNONE的时候，默认值为len
		if (wlen < len) {
			len = wlen;
		}
	}

	do {
		sent = write(fd, data, len);
	} while(sent == -1 && errno == EINTR);
	if (sent >= 0) { // 写入数据量
		lua_pushinteger(L, sent);
		return 1;
	} else { // 出错
		return nixio__perror(L);
	}
}

// read (length)
static int nixio_file_read(lua_State *L) {
	int fd = nixio__checkfd(L, 1);
	char buffer[NIXIO_BUFFERSIZE];
	uint req = luaL_checkinteger(L, 2);
	int readc;

	/* We limit the readsize to NIXIO_BUFFERSIZE */
	req = (req > NIXIO_BUFFERSIZE) ? NIXIO_BUFFERSIZE : req;

	do {
		readc = read(fd, buffer, req);
	} while (readc == -1 && errno == EINTR);

	if (readc < 0) {
		return nixio__perror(L); // 出错
	} else {
		lua_pushlstring(L, buffer, readc); // 读取数据量
		return 1;
	}
}

// seek (offset, [whence])  
// where: set cur end
static int nixio_file_seek(lua_State *L) {
	int fd = nixio__checkfd(L, 1);
	off_t len = (off_t)nixio__checknumber(L, 2);
	int whence;
	const char *whstr = luaL_optlstring(L, 3, "set", NULL);
	if (!strcmp(whstr, "set")) {
		whence = SEEK_SET;
	} else if (!strcmp(whstr, "cur")) {
		whence = SEEK_CUR;
	} else if (!strcmp(whstr, "end")) {
		whence = SEEK_END;
	} else {
		return luaL_argerror(L, 3, "supported values: set, cur, end");
	}
	len = lseek(fd, len, whence);
	if (len == -1) {
		return nixio__perror(L);
	} else {
		nixio__pushnumber(L, len);
		return 1;
	}
}
// tell ()
static int nixio_file_tell(lua_State *L) {
	int fd = nixio__checkfd(L, 1);
	off_t pos = lseek(fd, 0, SEEK_CUR);
	if (pos < 0) {
		return nixio__perror(L);
	} else {
		nixio__pushnumber(L, pos);
		return 1;
	}
}

// stat(['ino'])
static int nixio_file_stat(lua_State *L) {
	nixio_stat_t buf;
	if (fstat(nixio__checkfd(L, 1), &buf)) {
		return nixio__perror(L);
	} else {
		nixio__push_stat(L, &buf);
		if (lua_isstring(L, 2)) {
			lua_getfield(L, -1, lua_tostring(L, 2));
		}
		return 1;
	}
}

// sync (data_only) true: data_only; false: data and attr sync
static int nixio_file_sync(lua_State *L) {
	int fd = nixio__checkfd(L, 1);
	int stat;
#if (!defined BSD && !defined __WINNT__)
	int dataonly = lua_toboolean(L, 2);   
	do {
		stat = (dataonly) ? fdatasync(fd) : fsync(fd);
	} while (stat == -1 && errno == EINTR);
	return nixio__pstatus(L, !stat);
#else
	do {
		stat = fsync(fd);
	} while (stat == -1 && errno == EINTR);
	return nixio__pstatus(L, !stat);
#endif
}

// lock (command, length)
static int nixio_file_lock(lua_State *L) {
	int fd = nixio__checkfd(L, 1);
	const char *flag = luaL_checkstring(L, 2);   //
	off_t len = (off_t)nixio__optnumber(L, 3, 0);//
	int stat;

	int cmd = 0;
	if (!strcmp(flag, "lock")) {
		cmd = F_LOCK;
	} else if (!strcmp(flag, "tlock")) {
		cmd = F_TLOCK;
	} else if (!strcmp(flag, "ulock")) {
		cmd = F_ULOCK;
	} else if (!strcmp(flag, "test")) {
		cmd = F_TEST;
	} else {
		return luaL_argerror(L, 2,
				"supported values: lock, tlock, ulock, test");
	}

	do {
		stat = lockf(fd, cmd, len);
	} while (stat == -1 && errno == EINTR);

	return nixio__pstatus(L, !stat);
}


static int nixio_file_close(lua_State *L) {
	int *fdp = luaL_checkudata(L, 1, NIXIO_FILE_META);
	luaL_argcheck(L, *fdp != -1, 1, "invalid file object");
	int res;
	do {
		res = close(*fdp);
	} while (res == -1 && errno == EINTR);
	*fdp = -1;  // 防止再次回收
	return nixio__pstatus(L, !res);
}


static int nixio_file__gc(lua_State *L) {
	int *fdp = luaL_checkudata(L, 1, NIXIO_FILE_META);
	int res;
	if (*fdp > 2) {
		do {
			res = close(*fdp);
		} while (res == -1 && errno == EINTR);
		*fdp = -1;
	}
	return 0;
}

/**
 * string representation
 */
static int nixio_file__tostring(lua_State *L) {
	lua_pushfstring(L, "nixio file %d", nixio__tofd(L, 1));
	return 1;
}

/* method table */
static const luaL_reg M[] = {
	{"write",		nixio_file_write},
	{"read",		nixio_file_read},
	{"tell",		nixio_file_tell},
	{"seek",		nixio_file_seek},
	{"stat",		nixio_file_stat},
	{"sync",		nixio_file_sync},
	{"lock",		nixio_file_lock},
	{"close",		nixio_file_close},
	{"__gc",		nixio_file__gc},
	{"__tostring",	nixio_file__tostring},
	{NULL,			NULL}
};

/* module table */
static const luaL_reg R[] = {
	{"dup",			nixio_dup},
	{"open",		nixio_open},
	{"open_flags",	nixio_open_flags},
	{"pipe",		nixio_pipe},
	{NULL,			NULL}
};

void nixio_open_file(lua_State *L) {
	luaL_register(L, NULL, R);             // [nixio.socket], [nixio] 将R表中函数注册到nixio中

	luaL_newmetatable(L, NIXIO_FILE_META); // C 语言中操作元表的标识符 [nixio.socket], [nixio], [nixio.file]
	luaL_register(L, NULL, M);             // [nixio.socket], [nixio], [nixio.file] 将M表中函数注册到nixio.file中
	lua_pushvalue(L, -1);                  // [nixio.socket], [nixio], [nixio.file], [nixio.file], 
	lua_setfield(L, -2, "__index");        // [nixio.socket], [nixio], [nixio.file]  [nixio.file]表的__index指向自身
// fd, code, msg = nixio.open("debug.lua", "r")
// print(getmetatable(fd), getmetatable(fd).__index) 元表的__index指向元表自身；即nixio.file的__index又指向nixio.file

	int *uin  = lua_newuserdata(L, sizeof(int)); // [nixio.socket], [nixio], [nixio.file], [uin]
	int *uout = lua_newuserdata(L, sizeof(int)); // [nixio.socket], [nixio], [nixio.file], [uin], [uout]
	int *uerr = lua_newuserdata(L, sizeof(int)); // [nixio.socket], [nixio], [nixio.file], [uin], [uout], [uerr]

	if (!uin || !uout || !uerr) {
		luaL_error(L, "out of memory");
	}

	*uin  = STDIN_FILENO;
	*uout = STDOUT_FILENO;
	*uerr = STDERR_FILENO;
// nixio nixio.file uin uout uerr
	for (int i = -4; i < -1; i++) { 
		lua_pushvalue(L, -4);
        // [nixio.socket], [nixio], [nixio.file], [uin], [uout], [uerr], [nixio.file]
		lua_setmetatable(L, i); // 设置uin uout uerr的元表为nixio.file(meta_file)
        // [nixio.socket], [nixio], [nixio.file], [uin], [uout], [uerr]
	}

	lua_setfield(L, -5, "stderr"); // [nixio.socket], [nixio], [nixio.file], [uin], [uout] 设置表nixio.stderr 指向 uerr
	lua_setfield(L, -4, "stdout"); // [nixio.socket], [nixio], [nixio.file], [uin] 设置表nixio.stdout 指向 uout
	lua_setfield(L, -3, "stdin");  // [nixio.socket], [nixio], [nixio.file] 设置表nixio.stdin 指向 uin
	lua_setfield(L, -2, "meta_file"); // [nixio.socket], [nixio] 设置表nixio.meta_file 指向 nixio.file 表
}
