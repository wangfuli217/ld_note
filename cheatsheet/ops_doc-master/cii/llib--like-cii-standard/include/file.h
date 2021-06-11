#ifndef FILE_INCLUDED
#define FILE_INCLUDED

#include <stdio.h>

#include "utils.h"

BEGIN_DECLS

#define T File
typedef struct T* T;

enum file_format { UTF8, UTF16LE, UTF16BE, LOCALE, INFER };

T       File_open(const char* path, const char* mode, int format);
void    File_close(T file);

char*   File_read_line(T file);
char*   File_read_all(T file);

char*   File_read_all_text(const char* path, int format);
char**  File_read_all_lines(const char* path, int format);

void    File_write_line(T file, const char* line);
void    File_write_all_text(T file, const char* text);
void    File_write_all_lines(T file, const char** text);

#undef T

END_DECLS

#endif
