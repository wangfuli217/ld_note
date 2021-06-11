#ifndef H_CSTRING
#define H_CSTRING

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <regex.h>
#include "entry.h"

char* concat_string(char* s1, char* s2);
char* regexp_substitute_string(char* string, char* regexp, char* subwith);
char* regexp_substitute_string_frombeginning(char* string, char* regexp, char* subwith);
char* regexp_global_substitute_string(char* string, char* regexp, char* subwith);
char* regexp_get_substring(char* string, char* regexp);

#endif
