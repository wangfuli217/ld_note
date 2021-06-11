/* capitalize.c */
/* Copyright (c) 2008 Thorsten Groetker, Ulrich Holtmann, Holger Keding, 
Markus Wloka. All rights reserved. Your use or disclosure of this source code 
is subject to the terms and conditions of the end user license agreement (EULA)
that is part of this software package. */

#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>
#ifdef _MSC_VER
#define strncasecmp strnicmp
#endif
	
void change_word ( char* str, int len ) {
    int i;
    for (i=0; i<len; i++)
        str[i]=toupper(str[i]);
}
	
int capitalize_str( char* str, const char* name ) {
    int n;
    int hits=0;
    int len=strlen(str);
    int len_name=strlen(name);
    int lastpos = len-len_name;
    for (n=0; n<=lastpos; n++) {
        if (strncasecmp(str+n,name,len_name)==0) {
             change_word( str+n, len_name );
             n += len_name;
             hits++;
         }
     }
     return hits;
}

int main( int argc, char* argv[] ) {
    int hits_total=0;
    int na; 
    char *mycopy;
    if (argc<3) return 1;
    mycopy = strdup(argv[1]);
    for(na=2; na<argc; na++)
        hits_total += capitalize_str( mycopy, argv[na] );
    printf("Total %d hits:\n", hits_total);
    printf("original: %s\n", argv[1]);
    printf("modified: %s\n", mycopy);
    free(mycopy);
    return 0;
}
