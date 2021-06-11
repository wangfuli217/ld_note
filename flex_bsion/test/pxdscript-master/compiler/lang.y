/* bison file for pxdscript
 *
 * history:
 */

%{
  /* -*** Includes ***------------------------------------------------------------- */
#include <stdio.h>
#include <string.h>
#include <malloc.h>
#include "error.h"
#include "tree.h" 

/* Prototype for the lexer (no .h file is generated): */
int yylex();

/* Outmost container */
extern SCRIPTCOLLECTION *thescriptcollection; 

%}

/* Token definitions */
%start scriptcollection

%union {
  struct SCRIPTCOLLECTION *scriptcollection;    /* A collection of functions and programs.. */
  struct TOPLEVEL *toplevel;
  struct FUNCTION *function;  /* A standard C-style function */
  struct PROGRAM *program;    /* Equals an u1 script program */
  struct TRIGGER *trigger;
  struct TYPE *type;
  struct IDENTIFIER *identifiers;
  struct EXP *exp;
  struct DECL *decl;
  struct FORINIT *forinit;
  struct STM *stm;
  struct LVALUE *lvalue;
  int modifier; /* ModifierKind modifier; */

  int entitykind; /* EntityKind entitykind; */
  char *identifier;
  int intconst;
  int boolconst;
  char *stringconst;
};

%token 
tAND tBOOL tCONST tELSE tEQUALS tGEQUALS tIF tINT tLEQUALS tNEQUALS tOR tRETURN 
tPROGRAM tSTRING tVOID tWHILE tERROR tFOR tTRIGGERONINIT tTRIGGERONCLICK tTRIGGERONCOLLIDE 
tTRIGGERONPICKUP tSETINT tSLEEP tENTITYMDL tENTITYPARTICLE tENTITYPLAYER tENTITYLIGHT 
tENTITYCAMERA 

%token <identifier> tIDENTIFIER
%token <intconst> tINTCONST
%token <boolconst> tBOOLCONST
%token <stringconst> tSTRINGCONST

%type <scriptcollection> scriptcollection
%type <toplevel> toplevels netoplevels toplevel
%type <function> function
%type <program> program
%type <trigger> trigger
%type <type> type
%type <identifiers> identifiers
%type <exp> initialization exp unaryexp unarypostfixexp exps neexps
%type <decl> decl simpledecl formals neformals formal
%type <forinit> forinits neforinits forinit
%type <stm> nestms stm compoundstm
%type <lvalue> lvalue
%type <modifier> modifier
%type <entitykind> entitytype


/* Resolve dangling else conflict: */
%left ')'
%left tELSE

/* Resolve binary operator conflicts: */
%left '='
%left tOR tAND
%left tEQUALS tNEQUALS tLEQUALS tGEQUALS '<' '>'
%left '+' '-'
%left '*' '/'
%left '%'

%% /* productions */

scriptcollection : toplevels 
          { thescriptcollection = makeSCRIPTCOLLECTION($1); } 
;

toplevels : /* empty */ 
            {$$ = NULL;}
          | netoplevels
            {$$ = $1;}
;

netoplevels : toplevel
              {$$ = $1;}  
            | toplevel netoplevels
              {$$ = $1; $$->next = $2;} 
;

toplevel : function 
           {$$ = makeTOPLEVELfunction($1);}
         | program
           {$$ = makeTOPLEVELprogram($1);}
;


decl : type identifiers initialization ';'
       {$$ = makeDECLvariable(noneMod,$1,$2,$3);}
     | modifier type identifiers initialization ';'
       {$$ = makeDECLvariable($1,$2,$3,$4);}
;

simpledecl : type tIDENTIFIER initialization
             {$$ = makeDECLsimplevar($1,$2,$3);}
;

modifier : tCONST
           {$$ = constMod;}
;

identifiers : tIDENTIFIER 
              {$$ = makeIDENTIFIER($1);}
            | tIDENTIFIER ',' identifiers 
              {$$ = makeIDENTIFIER($1); $$->next = $3;}
;

initialization : /* empty */ 
                 {$$ = NULL;}
               | '=' exp
                 {$$ = $2;}
;

type : tINT 
       {$$ = makeTYPEint();}
     | tBOOL 
       {$$ = makeTYPEbool();}
     | tSTRING 
       {$$ = makeTYPEstring();}
;

function : type tIDENTIFIER '(' formals ')' compoundstm
           {$$ = makeFUNCTION($2,$1,$4,$6);}
         | tVOID tIDENTIFIER '(' formals ')' compoundstm
           {$$ = makeFUNCTION($2, makeTYPEvoid(), $4, $6);} 

;

formals : /* empty */ 
            {$$ = NULL;}
        | neformals
            {$$ = $1;}
;

neformals : formal 
            {$$ = $1;}
          | formal ',' neformals 
            {$$ = $1; $$->next = $3;}
;

formal : type tIDENTIFIER
         {$$ = makeDECLformal($1,$2);}
;


trigger : tTRIGGERONCLICK '(' tSTRINGCONST ')'
          { $$ = makeTRIGGERonclick($3); }
        | tTRIGGERONCOLLIDE '(' tSTRINGCONST ')'
          { $$ = makeTRIGGERoncollide($3); }
        | tTRIGGERONPICKUP '(' tSTRINGCONST ')'
          { $$ = makeTRIGGERonpickup($3); }
        | tTRIGGERONINIT 
          { $$ = makeTRIGGERoninit(); }  
;


program : tPROGRAM tIDENTIFIER trigger compoundstm
          {$$ = makePROGRAM($2,$3,$4);}
;


compoundstm : '{' '}'
              {$$ = NULL;}
            | '{' nestms '}'
              {$$ = $2;}      
;

nestms : stm
         {$$ = $1;}
       | nestms stm
         {$$ = makeSTMsequence($1,$2);}
;

entitytype : tENTITYMDL
             {$$ = mdlEntity;}
           | tENTITYPARTICLE
             {$$ = particleEntity;}
           | tENTITYPLAYER
             {$$ = playerEntity;}
           | tENTITYLIGHT
             {$$ = lightEntity;} 
           | tENTITYCAMERA
             {$$ = cameraEntity;}
;

stm : ';'
      {$$ = makeSTMskip();}
    | tRETURN ';'
      {$$ = makeSTMreturn(NULL);}
    | tRETURN exp ';'
      {$$ = makeSTMreturn($2);}
    | tIF '(' exp ')' stm
      {$$ = makeSTMif($3,makeSTMscope($5));}
    | tIF '(' exp ')' stm tELSE stm
      {$$ = makeSTMifelse($3,makeSTMscope($5),makeSTMscope($7));}
    | tWHILE '(' exp ')' stm
      {$$ = makeSTMwhile($3,$5);}
    | tFOR '(' forinits ';' exp ';' exps ')' stm
      {$$ = makeSTMfor($3,$5,$7,makeSTMscope($9));}
    | compoundstm
      {$$ = makeSTMscope($1);}
    | decl
      {$$ = makeSTMdecl($1);}
    | exp ';'
      {$$ = makeSTMexp($1);}
    | tSLEEP '(' exp ')'
      {$$ = makeSTMsleep($3);}  
    | tSLEEP '(' ')'
      {$$ = makeSTMsleep(NULL);}                                   /* sleep until re-triggered */  
    | tSETINT '(' entitytype ',' exp ',' exp ',' exp ')'           /* Interface between script and game ! */
      {$$ = makeSTMsetint($3, $5, $7, $9);}  
;

forinits : /* empty */
           {$$ = NULL;}
         | neforinits
           {$$ = $1;}
;

neforinits : forinit
             {$$ = $1;}
           | forinit ',' neforinits
             {$$ = $1; $$->next = $3;}
;

forinit : simpledecl
          {$$ = makeFORINITdecl($1);}
        | exp
          {$$ = makeFORINITexp($1);}
;



exp : lvalue '=' exp
      {$$ = makeEXPassignment($1,$3);}
    | exp tEQUALS exp
      {$$ = makeEXPequals($1,$3);}
    | exp tNEQUALS exp
      {$$ = makeEXPnequals($1,$3);}
    | exp '<' exp
      {$$ = makeEXPless($1,$3);}
    | exp '>' exp
      {$$ = makeEXPgreater($1,$3);}
    | exp tLEQUALS exp
      {$$ = makeEXPlequals($1,$3);}
    | exp tGEQUALS exp
      {$$ = makeEXPgequals($1,$3);}
    | exp '+' exp
      {$$ = makeEXPplus($1,$3);}
    | exp '-' exp
      {$$ = makeEXPminus($1,$3);}
    | exp '*' exp
      {$$ = makeEXPmult($1,$3);}
    | exp '/' exp
      {$$ = makeEXPdiv($1,$3);}
    | exp '%' exp
      {$$ = makeEXPmodulo($1,$3);}
    | exp tAND exp
      {$$ = makeEXPand($1,$3);}
    | exp tOR exp
      {$$ = makeEXPor($1,$3);}
    | unaryexp
      {$$ = $1;}
;

unaryexp : '-' unaryexp
           {$$ = makeEXPuminus($2);}
         | '!' unaryexp
           {$$ = makeEXPnot($2);}
         | '(' type ')' unaryexp
           {$$ = makeEXPcast($2,$4);}
         | unarypostfixexp
           {$$ = $1;}
;

unarypostfixexp : tINTCONST
                  {$$ = makeEXPintconst($1);}
                | tBOOLCONST
                  {$$ = makeEXPboolconst($1);}
                | tSTRINGCONST
                  {$$ = makeEXPstringconst($1);}
                | lvalue
                  {$$ = makeEXPlvalue($1);}
                | '(' exp ')'
                  {$$ = $2;}
		| tIDENTIFIER '(' exps ')'           /* Invokation */
                  {$$ = makeEXPcall($1,$3);}
;

exps : /* empty */ 
       {$$ = NULL;}
     | neexps
       {$$ = $1;}
;

neexps : exp 
         {$$ = $1;}
       | exp ',' neexps 
         {$$ = $1; $$->next = $3;}
;

lvalue : tIDENTIFIER
         {$$ = makeLVALUEid($1);}
;




