%{
/* $Id: micro.y,v 1.9 2008/07/11 18:56:43 dvermeir Exp $
*
* Parser specification for Micro
*/
#include <stdio.h> /* for (f)printf() */
#include <stdlib.h> /* for exit() */

#include "symbol.h"

int  lineno = 1; /* number of current source line */
extern int yylex(); /* lexical analyzer generated from lex.l */
extern char *yytext; /* last token, defined in lex.l  */

void
yyerror(char *s) {
  fprintf(stderr, "Syntax error on line #%d: %s\n", lineno, s);
  fprintf(stderr, "Last token was \"%s\"\n", yytext);
  exit(1);
}

#define PROLOGUE "\
.section .text\n\
.globl _start\n\
\n\
_start:\n\
	call main \n\
	jmp exit\n\
.include \"../x86asm/print_int.s\"\n\
.globl main\n\
.type main, @function\n\
main:\n\
	pushl %ebp /* save base(frame) pointer on stack */\n\
	movl %esp, %ebp /* base pointer is stack pointer */\n\
"

#define EPILOGUE "\
	movl %ebp, %esp\n\
	popl %ebp /* restore old frame pointer */\n\
	ret\n\
.type exit, @function\n\
exit:\n\
	movl $0, %ebx\n\
	movl $1, %eax\n\
	int $0x80\n\
"

%}

%union {
 int idx;
 int value;
 }

%token NAME
%token NUMBER
%token LPAREN
%token RPAREN
%token LBRACE
%token RBRACE
%token ASSIGN
%token SEMICOLON
%token PLUS
%token MINUS
%token DECLARE
%token WRITE
%token READ

%type <idx> NAME var
%type <value> NUMBER

%%
program         : LBRACE 
		  { puts(".section .data\n"); } declaration_list 
		  { puts(PROLOGUE); } statement_list 
                  RBRACE { puts(EPILOGUE); }
                ;
declaration_list  : declaration SEMICOLON declaration_list
                | /* empty */
                ;

statement_list  : statement SEMICOLON statement_list
                | /* empty */
                ;

statement       : assignment
                | read_statement
                | write_statement
                ;

declaration     : DECLARE NAME 
                  { 
                     if (symbol_declared($2)) {
                       fprintf(stderr, 
                               "Variable \"%s\" already declared (line %d)\n",
                               symbol_name($2), lineno);
                       exit(1);
                     }
                     else {
		       printf(".lcomm %s, 4\n", symbol_name($2));
                       symbol_declare($2); 
                     }
                  }
                ;

assignment      : var ASSIGN expression
                  {
	            /* we assume that the expresion value is (%esp) */
                    printf("\tpopl %s\n", symbol_name($1)); 
                  }
                ;

read_statement  : READ var { /* not implemented */}
                ;

write_statement : WRITE expression { puts("\tcall print_int\n"); }
                ;

expression      : term
                | term PLUS term { puts("\tpopl %eax\n\taddl %eax, (%esp)\n"); }
                | term MINUS term { puts("\tpopl %eax\n\tsubl %eax, (%esp)\n"); }
                ;

term            : NUMBER { printf("\tpushl $%d\n", $1); }
                | var { printf("\tpushl %s\n", symbol_name($1)); }
                | LPAREN expression RPAREN
                ;

var             : NAME
                  {
                    if (!symbol_declared($1)) {
                      fprintf(stderr, 
                              "Variable \"%s\" not declared (line %d)\n", 
                              symbol_name($1), lineno);
                      exit(1);
                    }
                    $$ = $1;
                  }
                ;
%%

int
main(int argc,char *argv[]) {
  return yyparse();
} 
