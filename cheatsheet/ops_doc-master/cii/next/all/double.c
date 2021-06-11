//<double.c>
//  <includes>
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<errno.h>
#include<ctype.h>
#include"cii.h"



//  <data>
static int linenum;




//  <prototypes>
static void doubleword(char *name, FILE *fp);
static int getword(FILE *fp, char *buf, size_t size);





//  <functions>
int 
main(int argc, char *argv[])
{
    int i;

    for(i = 1; i < argc; i++){
        FILE *fp = fopen(argv[i], "r");

        if(NULL == fp){
            fprintf(stderr, "%s: can't open '%s' (%s)\n", 
                    argv[0], argv[i], strerror(errno));
            return EXIT_FAILURE;
        }else{
            
            doubleword(argv[i], fp);
            return EXIT_SUCCESS;
        }
    }

    if(1 == argc){
        doubleword(NULL, stdin);
    }
    
    return EXIT_SUCCESS;
}

static
void
doubleword(char *name, FILE *fp)
{
    char prev[128], word[128], lastcheck[128];
    size_t len;

    linenum = 1;
    prev[0] = '\0';
    lastcheck[0] = '\0';
    len = sizeof(word);

    while(getword(fp, word, len)){
        
        if(isalpha(word[0]) &&
            0 == strcmp(prev, word) && 
            0 != strcmp(lastcheck, word)){

            //<word is a duplicate>
            if(name)
                printf("%s:", name);
            printf("%d: %s\n", linenum, word);

            strncpy(lastcheck, word, len);
        }

        strncpy(prev, word, len);
    }
}

static 
int 
getword(FILE *fp, char *buf, size_t size)
{
    int c, i;
    
    c = getc(fp);

    //<scan forword to to nonspace character or EOF>
    for(; EOF !=c && isspace(c); c = getc(fp)){
        if('\n' == c)
            linenum ++;
    }

    //<copy the word into buf buf buf [0..size-1]>
    i = 0;
    for(;EOF != c && !isspace(c); c = getc(fp)){
        if(i < size - 1)
            buf[i++] = tolower(c);
    }
    if(i < size)
        buf[i] = '\0';



    if(EOF != c)
        ungetc(c, fp);

    return buf[0] != '\0';
}
