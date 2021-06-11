#ifndef FILE_H
#define FILE_H

#include "except.h"
#include "utils.h"

BEGIN_DECLS

extern const Except_T Dir_entry_error;

#define T dir_entry
typedef struct T *T;

T       Dir_open(const char *path);
void    Dir_close(T dir);
char*   Dir_next_entry(T dir);

#undef T

END_DECLS

#endif
