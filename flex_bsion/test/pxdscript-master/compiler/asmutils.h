#ifndef __asmutils_h
#define __asmutils_h

#include <stdio.h>

extern const int START_SIZE;
extern unsigned int line;

char *strconcat(char *s1, char *s2);
char *getToken(FILE *f);
char *getStringToken(FILE *f);
void writeZString(char *str, FILE *f);

#endif

