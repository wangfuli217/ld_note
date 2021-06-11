#ifndef ATOM_INCLUDE
#define ATOM_INCLUDE

int atom_length(const char *str);
const char * atom_new(const char *str, int len);
const char * atom_string(const char *str);
const char * atom_int(long n);

#endif /*ATOM_INCLUDE*/
