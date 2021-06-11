%{
#include <stdio.h>
#include <string.h>

#define YYSTYPE char *

int yydebug = 1;
%}

%union{
    text char[256];  
}
%token WORD FILENAME QUOTE OBRACE EBRACE SEMICOLON ZONETOK FILETOK

%%
commands:
	|	 
	commands command SEMICOLON
	;


command:
	zone_set 
	;

zone_set:
	ZONETOK quotedname zonecontent
	{
		printf("Complete zone for '%s' found\n", $3);
	}
	;

zonecontent:
	OBRACE zonestatements EBRACE 

quotedname:
	QUOTE FILENAME QUOTE
	{
		$$=$2;
	}
	;

zonestatements:
	|
	zonestatements zonestatement SEMICOLON
	;

zonestatement:
	statements
	|
	FILETOK quotedname 
	{
		printf("A zonefile name '%s' was encountered\n", $2);
	}
	;

block: 
	OBRACE zonestatements EBRACE SEMICOLON
	;

statements:
	| statements statement
	;

statement: WORD | block | quotedname
%%

void yyerror(const char *str)
{
	fprintf(stderr,"error: %s\n",str);
}

int yywrap()
{
	return 1;
}

void main(void)
{
	yyparse();
}
