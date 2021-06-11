%{
	//This file belongs to yacc
	
    #include <stdlib.h>
    #include <math.h>
    #include <unistd.h>
    #include "customstring.h"
    #include "customio.h"
    #include "entry.h"
    extern int yylineno;
    extern int yylex();
    extern int DEBUG;
    
    void yyerror(char *s) {
		printstr_err(s); printstr_err(" on line "); 
		printint_err(yylineno); printstr_err("\n");
		//fprintf(stderr, "%s on line %d\n", s, yylineno);
		exit(SYNTAX_ERROR);
    }
    void printop(char *s) {
		if (DEBUG) fprintf(stderr, "Got %s\n", s);
	}
	void printrun(char* s) {
		if (DEBUG) fprintf(stderr, "Running %s\n", s);
	}
	
	void die(char* s, int exitcode) {
		fprintf(stderr, "%s\n", s);
		exit(exitcode);
	}
	
	void warning(char* s) {
		fprintf(stderr, "warning: %s\n", s);
	}
		
	char* type_by_enum[] = { "none", "singleop", "blockop", "exprop", "assignop", "value", "strvalue", "id", "binaryop", "unaryop", "ifop", "whileop", "funop", "regex", "arrvalue" };

	//SOME ACTUALLY USEFUL STUFF
	
	
	entry* head;
	entry* awkbegin;
	entry* awkend;
	
	
	void rec_print(entry* a, int depth) {
		if (a == NULL) return;
		if (DEBUG == 0) return;

		for (int i = 0; i < depth; i++) printstr(" ");
		char* strbuf = (char*)calloc(50, sizeof(char));
		sprintf(strbuf, "%p %d %s %c ", a, a->type, type_by_enum[a->type], a->op);
		printstr(strbuf);
		free(strbuf);
		if (a->text != NULL) printstr(a->text);
		printstr("\n");
		for (int i = 0; i < a->argc; i++) {
			rec_print((entry*)((a->argv)[i]), depth + 1);
		}
	
	}

	entry* new_entry_0(){
		entry* tmp = (entry*)malloc(sizeof(entry));
		tmp->type = none;
		tmp->argc = 0;
		tmp->argv = (struct entry**)malloc(sizeof(entry*) * 5);
		tmp->text = "\0";
		tmp->op = '\0';
		tmp->op2 = '\0';
		return tmp;
	}
	entry* new_entry_1(entry* a) {
		entry* tmp = new_entry_0();
		tmp->argc = 1;
		(tmp->argv)[0] = a;
		return tmp;
	}
	entry* new_entry_2(entry* a, entry* b) {
		entry* tmp = new_entry_1(a);
		tmp->argc = 2;
		(tmp->argv)[1] = b;
		return tmp;
	}
	
	//OPERATORS
	entry* new_block_op_2(entry* a, entry* b) {
		entry* tmp = new_entry_2(a, b);
		tmp->type = blockop;
		return tmp;
	};
	
	//EXPRESSIONS
	entry* new_expr_op(entry* a) {
		entry* tmp = new_entry_1(a);
		tmp->type = exprop;
		return tmp;
	}
	entry* new_expr_value(entry* a) {
		entry* tmp = new_entry_1(a);
		tmp->type = value;
		return tmp;
	}
	entry* new_assign_op(entry* a, entry* b) {
		entry* tmp = new_entry_2(a, b);
		tmp->type = assignop;
		return tmp;
	}
	entry* new_binary_op(char op, entry* a, entry* b) {
		entry* tmp = new_entry_2(a, b);
		tmp->type = binaryop;
		tmp->op = op;
		return tmp;
	}
	entry* new_binary_op2(char op, char op2, entry* a, entry* b) {
		entry* tmp = new_entry_2(a, b);
		tmp->type = binaryop;
		tmp->op = op;
		tmp->op2 = op2;
		return tmp;
	}
	entry* new_unary_op(char op, entry* a) {
		entry* tmp = new_entry_1(a);
		tmp->type = unaryop;
		tmp-> op = op;
		return tmp;
	}
	entry* new_id_value(entry* a) {
		entry* tmp = new_entry_1(a);
		tmp->type = value;
		return tmp;
	}
	entry* new_if_op(entry* a, entry* b, entry* c) {
		entry* tmp = new_entry_2(a, b);
		tmp->type = ifop;
		tmp->argc = 3;
		(tmp->argv)[2] = c;
		return tmp;
	}
	entry* new_while_op(entry* a, entry* b) {
		entry* tmp = new_entry_2(a, b);
		tmp->type = whileop;
		return tmp;
	}
	entry* new_fun_op(entry* a, entry* b) {
		entry* tmp = new_entry_2(a, b);
		tmp->type = funop;
		return tmp;
	}
	entry* new_sub_fun_op(entry* a, entry* b, entry* c, entry* d) {
		entry* tmp = new_entry_2(a, b);
		tmp->type = funop;
		tmp->argc = 4;
		(tmp->argv)[2] = c;
		(tmp->argv)[3] = d;
		return tmp;
	}
	entry* new_regex() {
		entry* tmp = new_entry_0();
		tmp->type = regex;
		return tmp;
	}
	entry* new_arrval_op(entry* a, entry* b) {
		entry* tmp = new_entry_2(a, b);
		tmp->type = arrvalue;
		return tmp;
	}
%}

%expect 1

%token AWKBEGIN AWKEND
%token REGMATCH
%token COMMENT
%token IF ELSE WHILE EXIT
%token EQ LE GE NE BOOLAND BOOLOR
%token REGEX
%token STRING NUM ID SQBROP SQBRCL


/*
%type<str> ID NUM STRING
%type<entry> OPS OP1 OP2 OP
%type<entry> EXPR EXPR1 EXPR2 TERM VAL ARG
%type<args> ARGS*/


%%

PROGRAM: OPS							{ rec_print($1, 0); head = $1; awkbegin = NULL; awkend = NULL;}
|		AWKBEGIN '{' OPS '}' '{' OPS '}' { rec_print($6, 0); head = $6; awkbegin = $3; awkend = NULL;}
|		'{' OPS '}' AWKEND  '{' OPS '}' { rec_print($2, 0); head = $2; awkbegin = NULL; awkend = $6;}
|		AWKBEGIN '{' OPS '}' '{' OPS '}' AWKEND  '{' OPS '}' { rec_print($6, 0); head = $6; awkbegin = $3; awkend = $10;}
;

OPS:	OP							  // inherit
|	   OPS OP						  { $$ = new_block_op_2($1, $2);}
;

OP1:	'{' OPS '}'					 { $$ = $2; printop("op in braces");}
|	   EXPR ';'						{ $$ = new_expr_op($1); printop("expression");}
|	   IF '(' EXPR ')' OP1 ELSE OP1	{ $$ = new_if_op($3, $5, $7); printop("if/else 1");}
|	   WHILE '(' EXPR ')' OP1		  { $$ = new_while_op($3, $5); printop("while 1");}
|	   EXIT ';'						{ /*$$ = new exitop();*/ printop("exit");}
;

OP2:	IF '(' EXPR ')' OP			  { $$ = new_if_op($3, $5, NULL); printop("if");}
|	   IF '(' EXPR ')' OP1 ELSE OP2	{ $$ = new_if_op($3, $5, $7); printop("if/else 2");}
|	   WHILE '(' EXPR ')' OP2		  { $$ = new_while_op($3, $5); printop("while 2");}
;

OP:	 OP1 | OP2 ;					 // inherit

EXPR:   EXPR1						   // inherit
|	   ID '=' EXPR					 { $$ = new_assign_op($1, $3); printop("assign value");}
|	   ID REGEX			{ $$ = new_binary_op('~', $1, $2); printop("regex match");}
;

EXPR1:  EXPR2						   // inherit
|	   EXPR1 EQ EXPR2				  { $$ = new_binary_op2('=', '=', $1, $3); printop("binary ==");}
|	   EXPR1 LE EXPR2				  { $$ = new_binary_op2('<', '=', $1, $3); printop("binary <=");}
|	   EXPR1 GE EXPR2				  { $$ = new_binary_op2('>', '=', $1, $3); printop("binary >=");}
|	   EXPR1 NE EXPR2				  { $$ = new_binary_op2('!', '=', $1, $3); printop("binary !=");}
|	   EXPR1 BOOLAND EXPR2				  { $$ = new_binary_op2('&', '&', $1, $3); printop("binary &&");}
|	   EXPR1 BOOLOR EXPR2				  { $$ = new_binary_op2('|', '|', $1, $3); printop("binary ||");}
|	   EXPR1 '>' EXPR2				 { $$ = new_binary_op('>', $1, $3); printop("binary >");}
|	   EXPR1 '<' EXPR2				 { $$ = new_binary_op('<', $1, $3); printop("binary <");}
;

EXPR2:  TERM							// inherit
|	   EXPR2 '+' TERM				  { $$ = new_binary_op('+', $1, $3); printop("binary +");}
|	   EXPR2 '-' TERM				  { $$ = new_binary_op('-', $1, $3);  printop("binary -");}
;

TERM:   VAL							 // inherit
|	   TERM '*' VAL					{ $$ = new_binary_op('*', $1, $3);  printop("binary *");}
|	   TERM '/' VAL					{ $$ = new_binary_op('/', $1, $3);  printop("binary /");}
;

VAL:	NUM							 { $$ = new_expr_value($1); printop("plain value");}
|	   '-' VAL						 { $$ = new_unary_op('-', $2); printop("unary -");}
|	   '!' VAL						 { $$ = new_unary_op('!', $2); printop("binary !");}
|	   '(' EXPR ')'					{ $$ = $2; }
|	   ID							  { $$ = new_id_value($1); printop("value by id");}
|	   ID SQBROP EXPR SQBRCL				 { $$=new_arrval_op($1, $3); printop("arrvaluecall");}
|	   ID '(' EXPR ')'				 { $$=new_fun_op($1, $3); printop("funcall");}
|		ID '(' ID REGEX ',' VAL ')'	{ $$ = new_sub_fun_op($1, $3, $4, $6); printop("regexp funcall"); } 
|		ID '(' ID REGEX ')'	{ $$ = new_sub_fun_op($1, $3, $4, NULL); printop("regexp funcall"); } 
|		STRING						{ $$ = new_expr_value($1); printop("string"); }
;

%%
