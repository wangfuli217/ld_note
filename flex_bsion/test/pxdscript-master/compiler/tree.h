/* pxdscript tree.h
 *
 * History:
 */

#ifndef __tree_h
#define __tree_h 

/* -*** Includes ***-------------------------------------------------------- */
#include <stdio.h>
#include "typedef.h"

/* --** Types: **------------------------------------------------------ */
typedef enum {noneMod, constMod} ModifierKind; 
typedef enum {mdlEntity, particleEntity, playerEntity, lightEntity, cameraEntity} EntityKind;
typedef enum {functionSym, programSym, declSym} SymbolKind;


typedef struct SYMBOL {
    char *name;
    SymbolKind kind;
    union {
      struct FUNCTION *functionS;
      struct PROGRAM *programS;
      struct DECL *declS;
    } val;
    struct SYMBOL *next;
} SYMBOL; 

typedef struct SCRIPTCOLLECTION {
  int lineno;
  struct TOPLEVEL *toplevels;
  struct SymbolTable *sym; /* symbol */
} SCRIPTCOLLECTION;

typedef struct TOPLEVEL {
  int lineno;
  enum {functionK, programK} kind; 
     
  union {
    struct FUNCTION *functionT;
    struct PROGRAM *programT;
  } val;
  struct TOPLEVEL *next;
} TOPLEVEL;

typedef struct FUNCTION {
  int lineno;
  char *name;
  struct TYPE *type;
  struct DECL *formals;
  struct STM *stms;
  struct SymbolTable *sym; 	/* symbol */
  int localslimit; 		/* resource */
  int labelcount; 		/* resource */
  char *signature; 		/* code */
  struct LABEL *labels; 	/* code */
  struct CODE *opcodes; 	/* code */
} FUNCTION;

typedef struct TRIGGER {
  int lineno;
  enum {trigger_neverK, trigger_on_initK, trigger_on_clickK, trigger_on_collideK, trigger_on_pickupK} kind;
  char *name; /* not always used */
} TRIGGER;

typedef struct PROGRAM {
  int lineno;
  struct TRIGGER *trigger;
  char *name;
  struct STM *stms;
  struct SymbolTable *sym; 	/* symbol */
  int localslimit; 		/* resource */
  int labelcount; 		/* resource */
  struct LABEL *labels; 	/* code */
  struct CODE *opcodes; 	/* code */
} PROGRAM;


typedef struct TYPE {
  int lineno;
  enum {boolK, intK, stringK, voidK} kind;
} TYPE;


typedef struct DECL {
  int lineno;
  enum {formalK, variableK, simplevarK} kind;
  struct TYPE *type; /* Parser! */
  
  union {
    struct {
      int offset; /* resource */	
      char *name;
    } formalD;
    struct {
      ModifierKind modifier;
      struct IDENTIFIER *identifiers;
      struct EXP *initialization;
      SYMBOL *symbol; /* symbol */
      int offset; /* resource */
    } variableD;
    struct {
      char *name;
      struct EXP *initialization;
      int offset;  /* resource */
    } simplevarD;
  } val;
  
  struct DECL *next;
} DECL;

typedef struct FORINIT {
  int lineno;
  enum {declforinitK, expforinitK} kind;

  union{
    struct DECL *declforinitF;
    struct EXP *expforinitF;
  } val;

  struct FORINIT *next;
} FORINIT;

typedef struct STM {
  int lineno;
  enum {skipK, expK, declstmK, returnK, ifK, ifelseK, whileK, forK, sequenceK, scopeK, setintK, sleepK} kind;
  
  union{
     
    struct EXP *expS;
    
    struct DECL *declstmS;
    
    struct {
      struct EXP *exp;
    } returnS;
   
    struct {
      struct EXP *condition;
      struct STM *body;
      int stoplabel; /* resource */
    } ifS;
   
    struct {
      struct EXP *condition;
      struct STM *thenpart;
      struct STM *elsepart;
      int elselabel,stoplabel; /* resource */
    } ifelseS;
   
    struct {
      struct EXP *condition;
      struct STM *body;
      int startlabel,stoplabel; /* resource */
    } whileS;
   
    struct {
      struct FORINIT *inits;
      struct EXP *condition;
      struct EXP *updates;
      struct STM *body;
      int startlabel,stoplabel; /* resource */
    } forS;

    struct {
      struct STM *first;
      struct STM *second;
    } sequenceS;
  
    struct {
      struct SymbolTable *sym; /* symbol */
      struct STM *stm;
    } scopeS;

    struct {
      struct EXP *modelname; 	
      struct EXP *nr;
      struct EXP *val;
      EntityKind kind;
    } setintS; 
  
    struct {
      struct EXP *time;
    } sleepS;

  } val;
} STM;

typedef struct IDENTIFIER {
  int lineno;
  char *name;
  struct IDENTIFIER *next;
} IDENTIFIER;




typedef struct EXP {
  int lineno;
  TYPE *type; /* type */
 
  enum {intconstK, boolconstK, stringconstK, uminusK, notK, lvalueK, assignmentK, 
	equalsK, nequalsK, lessK, greaterK, lequalsK, gequalsK, plusK, minusK, multK, divK, moduloK, 
	andK, orK,  callK, castK} kind;
  union {
    int intconstE;
    int boolconstE;
    char *stringconstE;
    
  
    struct EXP *uminusE;
      
    struct {
      struct EXP *exp;
      int truelabel,stoplabel; /* resource */
    } notE;
      
    struct LVALUE *lvalueE;
    
    struct {
      struct LVALUE *left;
      struct EXP *right;
      } assignmentE;
    
    struct {
      struct EXP *left;
      struct EXP *right;
      int truelabel,stoplabel; /* resource */
    } equalsE;
    
    struct {
      struct EXP *left;
      struct EXP *right;
      int truelabel,stoplabel; /* resource */
    } nequalsE;
    
    struct {
      struct EXP *left;
      struct EXP *right;
      int truelabel,stoplabel; /* resource */
    } lessE;
    
    struct {
      struct EXP *left;
      struct EXP *right;
      int truelabel,stoplabel; /* resource */
    } greaterE;
    
    struct {
      struct EXP *left;
      struct EXP *right;
      int truelabel,stoplabel; /* resource */
    } lequalsE;
    
    struct {
      struct EXP *left;
      struct EXP *right;
      int truelabel,stoplabel; /* resource */
    } gequalsE;
    
    struct {
      struct EXP *left;
      struct EXP *right;
    } plusE;
    
    struct {
      struct EXP *left;
      struct EXP *right;
    } minusE;
    
    struct {
      struct EXP *left;
      struct EXP *right;
    } multE;
    
    struct {
      struct EXP *left;
      struct EXP *right;
    } divE;
    
    struct {
      struct EXP *left;
      struct EXP *right;
    } moduloE;
    
    struct {
      struct EXP *left;
      struct EXP *right;
      int falselabel; /* resource */
    } andE;
    
    struct {
      struct EXP *left;
      struct EXP *right;
      int truelabel; /* resource */
    } orE;
       
    struct {
      char* name;
      struct EXP* arguments;
      struct SYMBOL* symbol; /* symbol */
    } callE;
       
    struct {
      struct TYPE *type;
      struct EXP *exp;
    } castE;
  
  } val;
  struct EXP *next;
} EXP;



typedef struct LVALUE {
  int lineno;
  struct SYMBOL *symbol; /* symbol */
  ModifierKind modifier; /* symbol */
  struct TYPE *type;
  enum {idK} kind;
  union {
    char *idL;
  } val;
} LVALUE;





typedef struct LABEL {
   char *name;
   int sources;
   struct CODE *position;
} LABEL;


/* new opcodes : aaddCK , changed invokevirtual to call, removed 3 'null' opcodes*/

/* changed behaviour : disallowed cast of string to bool */

/* removed code i2c, iinc, swap */

typedef struct CODE {
   enum {nopCK, imulCK,inegCK,iremCK,isubCK,idivCK,iaddCK, aaddCK,
         labelCK,gotoCK,ifeqCK,ifneCK,if_acmpeqCK,if_acmpneCK,   
         if_icmpeqCK,if_icmpgtCK,if_icmpltCK, if_icmpleCK,if_icmpgeCK,if_icmpneCK, 
         ireturnCK,areturnCK,returnCK,
         aloadCK,astoreCK,iloadCK,istoreCK, ldc_intCK, ldc_stringCK,
         dupCK,popCK, callCK, 
         setint_mdlCK, setint_particleCK, setint_plyCK, setint_lightCK, setint_camCK, 
         sleepCK, sleep_trigCK,
         cast_inttostringCK, cast_stringtointCK, cast_booltostringCK    } kind;
   int visited; /* emit */
   union {
     char *checkcastC;
     int labelC;
     int gotoC;
     int ifeqC;
     int ifneC;
     int if_acmpeqC;
     int if_acmpneC;
     int if_icmpeqC;
     int if_icmpgtC;
     int if_icmpltC;
     int if_icmpleC;
     int if_icmpgeC;
     int if_icmpneC;
     int aloadC;
     int astoreC;
     int iloadC;
     int istoreC;
     int ldc_intC;
     char* ldc_stringC;
     
     struct {
      char* callC;
      char* callSignatureC;
     } callVals;
          
    } val;
   struct CODE *next;
} CODE;




/* --** Prototypes: **------------------------------------------------- */
struct SCRIPTCOLLECTION *makeSCRIPTCOLLECTION(TOPLEVEL *toplevels);

struct TOPLEVEL *makeTOPLEVELfunction(FUNCTION *function);
struct TOPLEVEL *makeTOPLEVELprogram(PROGRAM *program);

struct FUNCTION *makeFUNCTION(char *name,struct TYPE *type,struct DECL *formals,struct STM *stms);

struct TRIGGER *makeTRIGGERonclick(char *name);
struct TRIGGER *makeTRIGGERoncollide(char *name);
struct TRIGGER *makeTRIGGERonpickup(char *name);
struct TRIGGER *makeTRIGGERoninit();

struct PROGRAM *makePROGRAM(char *name, struct TRIGGER *trigger, struct STM *stms);

struct TYPE *makeTYPEbool();
struct TYPE *makeTYPEint();
struct TYPE *makeTYPEstring();
struct TYPE *makeTYPEvoid();

struct DECL *makeDECLformal(struct TYPE *type, char *name);
struct DECL *makeDECLvariable(ModifierKind modifier, struct TYPE *type, struct IDENTIFIER *identifiers, struct EXP *initialization);
struct DECL *makeDECLsimplevar(struct TYPE *type, char *name, struct EXP *initialization);

struct FORINIT *makeFORINITdecl(DECL *decl);
struct FORINIT *makeFORINITexp(EXP *exp);

struct STM *makeSTMskip();
struct STM *makeSTMdecl(struct DECL *decl);
struct STM *makeSTMexp(struct EXP *exp);
struct STM *makeSTMreturn(struct EXP *exp);
struct STM *makeSTMif(struct EXP *condition, struct STM *body);
struct STM *makeSTMifelse(struct EXP *condition, struct STM *thenpart, struct STM *elsepart);
struct STM *makeSTMwhile(struct EXP *condition, struct STM *body);
struct STM *makeSTMfor(struct FORINIT *inits, struct EXP *condition, struct EXP *updates, struct STM *body);
struct STM *makeSTMsequence(struct STM *first, struct STM *second);
struct STM *makeSTMscope(struct STM *stm);
struct STM *makeSTMsetint(EntityKind kind, struct EXP *modelname, struct EXP *nr, struct EXP *val);
struct STM *makeSTMsleep(struct EXP *time);

struct IDENTIFIER *makeIDENTIFIER(char *name);

struct EXP *makeEXPintconst(int value);
struct EXP *makeEXPboolconst(int value);
struct EXP *makeEXPstringconst(char *value);
struct EXP *makeEXPuminus(struct EXP *exp);
struct EXP *makeEXPnot(struct EXP *exp);
struct EXP *makeEXPlvalue(struct LVALUE *lvalue);
struct EXP *makeEXPassignment(struct LVALUE *lvalue, struct EXP *right);
struct EXP *makeEXPequals(struct EXP *left, struct EXP *right);
struct EXP *makeEXPnequals(struct EXP *left, struct  EXP *right);
struct EXP *makeEXPless(struct EXP *left, struct  EXP *right);
struct EXP *makeEXPgreater(struct EXP *left, struct EXP *right);
struct EXP *makeEXPlequals(struct EXP *left, struct EXP *right);
struct EXP *makeEXPgequals(struct EXP *left, struct EXP *right);
struct EXP *makeEXPplus(struct EXP *left, struct EXP *right);
struct EXP *makeEXPminus(struct EXP *left, struct  EXP *right);
struct EXP *makeEXPmult(struct EXP *left, struct EXP *right);
struct EXP *makeEXPdiv(struct EXP *left, struct  EXP *right);
struct EXP *makeEXPmodulo(struct EXP *left, struct  EXP *right);
struct EXP *makeEXPand(struct EXP *left, struct  EXP *right);
struct EXP *makeEXPor(struct EXP *left, struct  EXP *right);
struct EXP *makeEXPcall(char *name, struct  EXP *arguments);
struct EXP *makeEXPcast(struct TYPE *type,struct  EXP *exp);

struct LVALUE *makeLVALUEid(char *id);


/* Codes */

CODE *makeCODEnop(CODE *next);
CODE *makeCODEimul(CODE *next);
CODE *makeCODEineg(CODE *next);
CODE *makeCODEirem(CODE *next);
CODE *makeCODEisub(CODE *next);
CODE *makeCODEidiv(CODE *next);
CODE *makeCODEiadd(CODE *next);
CODE *makeCODEaadd(CODE *next);
CODE *makeCODElabel(int label, CODE *next);
CODE *makeCODEgoto(int label, CODE *next);
CODE *makeCODEifeq(int label, CODE *next);
CODE *makeCODEifne(int label, CODE *next);
CODE *makeCODEif_acmpeq(int label, CODE *next);
CODE *makeCODEif_acmpne(int label, CODE *next);
CODE *makeCODEif_icmpeq(int label, CODE *next);
CODE *makeCODEif_icmpgt(int label, CODE *next);
CODE *makeCODEif_icmplt(int label, CODE *next);
CODE *makeCODEif_icmple(int label, CODE *next);
CODE *makeCODEif_icmpge(int label, CODE *next);
CODE *makeCODEif_icmpne(int label, CODE *next);
CODE *makeCODEireturn(CODE *next);
CODE *makeCODEareturn(CODE *next);
CODE *makeCODEreturn(CODE *next);
CODE *makeCODEaload(int arg, CODE *next);
CODE *makeCODEastore(int arg, CODE *next);
CODE *makeCODEiload(int arg, CODE *next);
CODE *makeCODEistore(int arg, CODE *next);
CODE *makeCODEdup(CODE *next);
CODE *makeCODEpop(CODE *next);
CODE *makeCODEldc_int(int arg, CODE *next);
CODE *makeCODEldc_string(char *arg, CODE *next);
CODE *makeCODEcall(char *arg, char* signature, CODE *next);

CODE *makeCODEsetint(EntityKind kind, CODE *next);
CODE *makeCODEsleep(CODE *next);
CODE *makeCODEsleepUntilTriggered(CODE *next);

CODE *makeCODEcast(TYPE *source, TYPE *dest, CODE *next);

#endif
