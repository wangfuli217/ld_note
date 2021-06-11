#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>

#ifdef _WIN32
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#else
#include <dirent.h>
#endif

#include "portable.h"

#include "dir.h"
#include "str.h"
#include "mem.h"
#include "utf8.h"
#include "assert.h"
#include "safeint.h"

#ifdef _WIN32
#define DIR_PATH_EXTRA 2
#define DIR_PATH_MAX 256
#define DIR_FILENAME_MAX 256
#else
#define DIR_PATH_EXTRA 0
#define DIR_PATH_MAX 4096
#define DIR_FILENAME_MAX 256
#endif

#define T dir_entry

struct T
{
#ifdef _WIN32
    HANDLE _d;
    char* first_name;
#else
    DIR* _d;
#endif
};

const Except_T Dir_entry_error = { "Error getting a directory entry"};

T Dir_open(const char *path)
{
    T dir;

    assert (path != NULL || strlen(path) != 0);
    assert (strlen(path) + DIR_PATH_EXTRA < DIR_PATH_MAX);

    NEW(dir);

#ifdef _WIN32
    {
        WIN32_FIND_DATA f;
        char * u8_path = Str_acat(path, "\\*");
        uint16_t* u16_path = u8_to_u16(u8_path);
        dir->_d = FindFirstFileW((LPCWSTR)u16_path, &f);
        dir->first_name = u16_to_u8((uint16_t*)f.cFileName);
        FREE(u8_path);
        FREE(u16_path);
    }
    if (dir->_d == INVALID_HANDLE_VALUE)
#else
    dir->_d = opendir(path);
    if (dir->_d == NULL)
#endif
    {
        Dir_close(dir);
        RAISE_DATA_PTR(Dir_entry_error, path);
    }

    return dir;
}

void Dir_close(T dir)
{
    assert (dir != NULL);

#ifdef _WIN32

    if(dir->first_name[0] == '\0')
        FREE(dir->first_name);

    if (dir->_d != INVALID_HANDLE_VALUE)
        FindClose(dir->_d);
#else
    if (dir->_d)
        closedir(dir->_d);
#endif
    FREE(dir);
}

char* Dir_next_entry(T dir)
{
    assert(dir != NULL);

    if(dir->first_name[0] != '\0') {
        char* tmp = Str_adup(dir->first_name);
        REALLOC(dir->first_name, 1);
        dir->first_name[0] = '\0';
        return tmp;
    }

#ifdef _WIN32
    {
        WIN32_FIND_DATA f;
        int r = FindNextFile(dir->_d, &f);
        if (r) {
            return u16_to_u8((uint16_t*)f.cFileName);            
        } else if(GetLastError() == ERROR_NO_MORE_FILES)
            return NULL;
    }
#else
    {
        errno = 0;
        dir->_e = readdir(dir->_d);
        if (dir->_e != NULL) {
            return Str_adup(dir->e->d_name);
        } else if(errno == 0)
            return NULL;
    }
#endif
        Dir_close(dir);
        RAISE_INT(Dir_entry_error);
}