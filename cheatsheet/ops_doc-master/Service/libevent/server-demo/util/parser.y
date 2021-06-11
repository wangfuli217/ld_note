%{
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include "settings.h"

extern int yylineno;
extern char *yytext;
extern int yylex();
int logyes = 0;
void yyerror(const char *str)
{
    fprintf(stderr,"error: %s %d: %s\n",str, yylineno, yytext);
}

int yywrap()
{
    return 1;
}

extern struct settings settings;

%}

%token	SHARP EQUAL TEST PORT THREADNUM DAEMONIZE MAXCONNS

%union
{
    int number;
    char *string;
}

%token <number> STATE
%token <number> NUMBER
%token <string> WORD

%%

commands:
    | commands command
    ;


command:
    testassign | portassign | threadnumassign | daemonizeassign | maxconnsassign

testassign:
    TEST EQUAL WORD
    {
        printf("test is %s\n", $3);
        settings.test = strdup($3);
    }
    ;

portassign:
    PORT EQUAL NUMBER
    {
        printf("port is %d\n", $3);
        settings.port = $3;
    }
    ;

threadnumassign:
    THREADNUM EQUAL NUMBER
    {
        printf("num_threads is %d\n", $3);
        settings.num_threads = $3;
    }
    ;

daemonizeassign:
    DAEMONIZE EQUAL NUMBER
    {
        printf("daemonize is %d\n", $3);
        settings.daemonize = $3;
    }
    ;
maxconnsassign:
    MAXCONNS EQUAL NUMBER
    {
        printf("maxconns is %d\n", $3);
        settings.maxconns = $3;
    }
    ;
