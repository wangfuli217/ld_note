%{
/* $Id: lex.l,v 1.1 2008/07/09 13:06:42 dvermeir Exp $
* 
* Lexical analyzer for the toy language ``Micro''
*/
#include <string.h> /* for strcmp, strdup & friends */
#include <stdlib.h> /* for atoi() */

#include "micro.tab.h" /* token type definitions from .y file */
#include "symbol.h" /* symbol table management */

extern int lineno;  /* defined in micro.y */

void
lex_init() {
  /* Initialize data structures etc. for scanner */
  symbol_insert("declare",DECLARE); /*Insert keywords in symbol table */
  symbol_insert("read",READ); /*Insert keywords in symbol table */
  symbol_insert("write",WRITE);
}

/*
* The macro below will be called automatically when the generated scanner
* initializes itself.
*/
#define YY_USER_INIT lex_init();

%}

alpha   [A-Za-z]
digit   [0-9]
alphanum  [A-Za-z0-9]

%%
[ \t]   break;  /* ignore white space */
"\n"    ++lineno; 

{alpha}{alphanum}*      {
                        yylval.idx = symbol_find(yytext);

                        if (yylval.idx<0) { /* new symbol: insert it */
                          yylval.idx =symbol_insert(yytext, NAME);
                          return NAME;
                        }
                        else
                          return symbol_type(yylval.idx);
                        }

{digit}+                {
                        yylval.value = atoi(yytext);
                        return NUMBER; 
                        }

"("                     return LPAREN;
")"                     return RPAREN;
"{"                     return LBRACE;
"}"                     return RBRACE;
"="                     return ASSIGN;
";"                     return SEMICOLON;
"+"                     return PLUS;
"-"                     return MINUS;

.                       { 
                        fprintf(stderr,
                                "Illegal character \'%s\' on line #%d\n",
                                yytext, lineno);
                        exit(1);
                        }

%%

int
yywrap() {
  return 1; /* tell scanner no further files need to be processed */
}

