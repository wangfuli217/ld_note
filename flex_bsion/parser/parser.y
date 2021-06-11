%{
    #include "node.h"
    NBlock *programBlock; /* the top level root node of our final AST */

    extern int yylex();
    void yyerror(const char *s) { printf("ERROR: %s\n", s); }
%}

/* Represents the many different ways we can access our data */
%union {
    Node *node;
    NBlock *block;
    NExpression *expr;
    NStatement *stmt;
    NIdentifier *ident;
    NVariableDeclaration *var_decl;
    std::vector<NVariableDeclaration*> *varvec;
    std::vector<NExpression*> *exprvec;
    std::string *string;
    int token;
}

/* Define our terminal symbols (tokens). This should
   match our tokens.l lex file. We also define the node type
   they represent.
   终结符
 */
%token  TIDENTIFIER TINTEGER TDOUBLE
%token  TCEQ TCNE TCLT TCLE TCGT TCGE TEQUAL
%token  TLPAREN TRPAREN TLBRACE TRBRACE TCOMMA TDOT
%token  TPLUS TMINUS TMUL TDIV

/* Define the type of node our nonterminal symbols represent.
   The types refer to the %union declaration above. Ex: when
   we call an ident (defined by union type ident) we are really
   calling an (NIdentifier*). It makes the compiler happy.
   非终结符
 */
%type  <ident> ident
%type  <expr> numeric expr
%type  <varvec> func_decl_args
%type  <exprvec> call_args
%type  <block> program stmts block
%type  <stmt> stmt func_decl
%type  <var_decl> var_decl
%type  <token> comparison

/* Operator precedence for mathematical operators */
%left TPLUS TMINUS
%left TMUL TDIV

%start program

%%

program : stmts { programBlock = $1; }
        ;

stmts : stmt { $$ = new NBlock(); $$->statements.push_back($1); }
      | stmts stmt { $1->statements.push_back($2); }
      ;

stmt : var_decl { $$ = $1; }
	 | func_decl { $$ = $1; }
     | expr { $$ = new NExpressionStatement(*$1); }
     ;

block : TLBRACE stmts TRBRACE { $$ = $2; }		/* { stmts } */
      | TLBRACE TRBRACE { $$ = new NBlock(); }	/* {} */
      ;

var_decl : ident ident { $$ = new NVariableDeclaration(*$1, *$2); }					/* var declaration, eg. type1 arg1, type1 arg2 */
         | ident ident TEQUAL expr { $$ = new NVariableDeclaration(*$1, *$2, $4); }	/*eg. type1 arg1=func(arg2) */
         ;

func_decl : ident ident TLPAREN func_decl_args TRPAREN block				/* function func(arg1, arg2, ...) {}*/
            { $$ = new NFunctionDeclaration(*$1, *$2, *$4, *$6); delete $4; }
          ;

func_decl_args : /*blank*/  { $$ = new VariableList(); }					/* */
          | var_decl { $$ = new VariableList(); $$->push_back($1); }		/* type1 arg1, type2 arg2 */
          | func_decl_args TCOMMA var_decl { $1->push_back($3); }
          ;

ident : TIDENTIFIER { $$ = new NIdentifier(*$<ident>1); delete $<ident>1; }
      ;

numeric : TINTEGER { $$ = new NInteger(atol($<string>1->c_str())); delete $<string>1; }
        | TDOUBLE { $$ = new NDouble(atof($<string>1->c_str())); delete $<string>1; }
        ;

expr : ident TEQUAL expr { $$ = new NAssignment(*$1, *$3); }
     | ident TLPAREN call_args TRPAREN { $$ = new NMethodCall(*$1, *$3); delete $3; }
     | ident { $$ = $1; }
     | numeric
     | expr comparison expr { $$ = new NBinaryOperator(*$1, $2, *$3); }
     | TLPAREN expr TRPAREN { $$ = $2; }
     ;

call_args : /*blank*/  { $$ = new ExpressionList(); }
          | expr { $$ = new ExpressionList(); $$->push_back($1); }
          | call_args TCOMMA expr  { $1->push_back($3); }
          ;

comparison : TCEQ { $$ = $<token>1; }
		   | TCNE { $$ = $<token>1; }
		   | TCLT { $$ = $<token>1; }
           | TCLE { $$ = $<token>1; }
           | TCGT { $$ = $<token>1; }
           | TCGE { $$ = $<token>1; }
           | TPLUS { $$ = $<token>1; }
           | TMINUS { $$ = $<token>1; }
		   | TMUL { $$ = $<token>1; }
           | TDIV { $$ = $<token>1; }
           ;

%%
