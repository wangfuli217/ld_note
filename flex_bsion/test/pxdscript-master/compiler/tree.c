/* wig tree.c
 *
 * History:
 * 18.10.2000 - created
 * 20.10.2000 - added all functions (empty except makeSERVICE())
 * 23.10.2000 - kasper : implemented rest of the functions, initialized all next pointers to NULL
 */

/* --** Includes: **--------------------------------------------------- */
#include "tree.h"
#include "memory.h"
#include "error.h"


/* --** Functions: **-------------------------------------------------- */
struct SCRIPTCOLLECTION *makeSCRIPTCOLLECTION(TOPLEVEL *toplevels)
{
  SCRIPTCOLLECTION *p = NEW(SCRIPTCOLLECTION);
  p->lineno = lineno;
  p->toplevels = toplevels;
  p->sym = NULL;
  return p;
}


struct TOPLEVEL *makeTOPLEVELfunction(FUNCTION *function)
{
  TOPLEVEL *p = NEW(TOPLEVEL);
  p->lineno = lineno;
  p->kind = functionK;
  p->val.functionT = function;
  p->next = NULL;
  return p;
}


struct TOPLEVEL *makeTOPLEVELprogram(PROGRAM *program)
{
  TOPLEVEL *p = NEW(TOPLEVEL);
  p->lineno = lineno;
  p->kind = programK;
  p->val.programT = program;
  p->next = NULL;
  return p;
}

struct FUNCTION *makeFUNCTION(char *name,struct TYPE *type,struct DECL *formals,struct STM *stms)
{
  FUNCTION *p = NEW(FUNCTION);
  p->lineno = lineno;
  p->name = name;
  p->type = type;
  p->formals = formals;
  p->stms = stms;
  p->sym = NULL;
  p->opcodes = NULL;
  p->labels = NULL;
  return p;
}

struct TRIGGER *makeTRIGGERonclick(char *name)
{
 TRIGGER *p = NEW(TRIGGER);	
 p->lineno = lineno;
 p->name = name;
 p->kind = trigger_on_clickK;
 return p;
}

struct TRIGGER *makeTRIGGERoncollide(char *name)
{
 TRIGGER *p = NEW(TRIGGER);	
 p->lineno = lineno;
 p->name = name;
 p->kind = trigger_on_collideK;
 return p;
}

struct TRIGGER *makeTRIGGERonpickup(char *name)
{
 TRIGGER *p = NEW(TRIGGER);	
 p->lineno = lineno;
 p->name = name;
 p->kind = trigger_on_pickupK;
 return p; 
}

struct TRIGGER *makeTRIGGERoninit()
{
 TRIGGER *p = NEW(TRIGGER);	
 p->lineno = lineno;
 p->name = NULL;
 p->kind = trigger_on_initK;
 return p;
}


struct PROGRAM *makePROGRAM(char *name, struct TRIGGER *trigger, struct STM *stms)
{
  PROGRAM *p = NEW(PROGRAM);
  p->lineno = lineno;
  p->name = name;
  p->trigger = trigger;
  p->stms = stms;
  p->sym = NULL;
  return p;
}

struct TYPE *makeTYPEbool()
{
  TYPE *p = NEW(TYPE);
  p->lineno = lineno;
  p->kind = boolK;
  return p;
}

struct TYPE *makeTYPEint()
{
  TYPE *p = NEW(TYPE);
  p->lineno = lineno;
  p->kind = intK;
  return p;
}


struct TYPE *makeTYPEstring()
{
  TYPE *p = NEW(TYPE);
  p->lineno = lineno;
  p->kind = stringK;
  return p;
}

struct TYPE *makeTYPEvoid()
{
  TYPE *p = NEW(TYPE);
  p->lineno = lineno;
  p->kind = voidK;
  return p;
}


struct DECL *makeDECLformal(struct TYPE *type, char *name)
{
  DECL *p = NEW(DECL);
  p->type = NULL;
  p->next = NULL;
  p->lineno = lineno;
  p->kind = formalK;
  p->type = type;
  p->val.formalD.name = name;
  return p;
}

struct DECL *makeDECLvariable(ModifierKind modifier, struct TYPE *type, struct IDENTIFIER *identifiers, struct EXP *initialization)
{
  DECL *p = NEW(DECL);
  p->type = NULL;
  p->next = NULL;
  p->lineno = lineno;
  p->kind = variableK;
  p->val.variableD.modifier = modifier;
  p->type = type;
  p->val.variableD.identifiers = identifiers;
  p->val.variableD.initialization = initialization;
  return p;
}

struct DECL *makeDECLsimplevar(struct TYPE *type, char *name, struct EXP *initialization)
{
  DECL *p = NEW(DECL);
  p->type = NULL;
  p->next = NULL;
  p->lineno = lineno;
  p->kind = simplevarK;
  p->type = type;
  p->val.simplevarD.name = name;
  p->val.simplevarD.initialization = initialization;
  return p;
}

struct FORINIT *makeFORINITdecl(DECL *decl)
{
  FORINIT *p = NEW(FORINIT);
  p->lineno = lineno;
  p->kind = declforinitK;
  p->val.declforinitF = decl;
  p->next = NULL;

  return p;
}

struct FORINIT *makeFORINITexp(EXP *exp)
{
  FORINIT *p = NEW(FORINIT);
  p->lineno = lineno;
  p->kind = expforinitK;
  p->val.expforinitF = exp;
  p->next = NULL;

  return p;
}

struct STM *makeSTMskip()
{
  STM *p = NEW(STM);
  p->lineno = lineno;
  p->kind = skipK;
  return p;
}

struct STM *makeSTMdecl(struct DECL *decl)
{
  STM *p = NEW(STM);
  p->lineno = lineno;
  p->kind = declstmK;
  p->val.declstmS = decl;
  return p; 
}

struct STM *makeSTMexp(struct EXP *exp)
{
  STM *p = NEW(STM);
  p->lineno = lineno;
  p->kind = expK;
  p->val.expS = exp;
  return p;
}

struct STM *makeSTMreturn(struct EXP *exp)
{
  STM *p = NEW(STM);
  p->lineno = lineno;
  p->kind = returnK;
  p->val.returnS.exp = exp;
  return p;
}
struct STM *makeSTMif(struct EXP *condition,struct STM *body)
{
  STM *p = NEW(STM);
  p->lineno = lineno;
  p->kind = ifK;
  p->val.ifS.condition = condition;
  p->val.ifS.body = body;
  return p;
}
struct STM *makeSTMifelse(struct EXP *condition,struct STM *thenpart,struct STM *elsepart)
{
  STM *p = NEW(STM);
  p->lineno = lineno;
  p->kind = ifelseK;
  p->val.ifelseS.condition = condition;
  p->val.ifelseS.thenpart = thenpart;
  p->val.ifelseS.elsepart = elsepart; 
  return p;
}
struct STM *makeSTMwhile(struct EXP *condition,struct STM *body)
{
  STM *p = NEW(STM);
  p->lineno = lineno;
  p->kind = whileK;
  p->val.whileS.condition = condition;
  p->val.whileS.body = body;
  return p;
}

struct STM *makeSTMfor(struct FORINIT *inits, struct EXP *condition, struct EXP *updates, struct STM *body)
{
  STM *p = NEW(STM);
  p->lineno = lineno;
  p->kind = forK;
  p->val.forS.inits = inits;
  p->val.forS.condition = condition;
  p->val.forS.updates = updates;
  p->val.forS.body = body;

  return p;
}

struct STM *makeSTMsequence(struct STM *first,struct STM *second)
{
  STM *p = NEW(STM);
  p->lineno = lineno;
  p->kind = sequenceK;
  p->val.sequenceS.first = first;
  p->val.sequenceS.second = second;
  return p;
}

struct STM *makeSTMscope(struct STM *stm)
{
  STM *p = NEW(STM);
  p->lineno = lineno;
  p->kind = scopeK;
  p->val.scopeS.sym = NULL;
  p->val.scopeS.stm = stm;
  return p;
}

struct STM *makeSTMsetint(EntityKind kind, struct EXP *modelname, struct EXP *nr, struct EXP *val)
{	
  STM *p = NEW(STM);
  p->lineno = lineno;
  p->kind = setintK;
  p->val.setintS.kind = kind;
  p->val.setintS.modelname = modelname;
  p->val.setintS.nr = nr;
  p->val.setintS.val = val;
  return p;	
}


struct STM *makeSTMsleep(struct EXP *time) 
{
  STM *p = NEW(STM);
  p->lineno = lineno;
  p->kind = sleepK;
  p->val.sleepS.time = time;
  return p;	
}


struct IDENTIFIER *makeIDENTIFIER(char *name)
{
  IDENTIFIER *p = NEW(IDENTIFIER);
  p->lineno = lineno;
  p->name = name;
  p->next = NULL;
  return p;
}

struct EXP *makeEXPintconst(int value)
{
  EXP *p = NEW(EXP);
  p->type = NULL;
  p->lineno = lineno;
  p->kind = intconstK;
  p->val.intconstE = value;
  p->next = NULL;
  return p;
}


struct EXP *makeEXPboolconst(int value)
{
  EXP *p = NEW(EXP);
  p->type = NULL;
  p->lineno = lineno;
  p->kind = boolconstK;
  p->val.boolconstE = value;
  p->next = NULL;
  return p;
}

struct EXP *makeEXPstringconst(char *value)
{
  EXP *p = NEW(EXP);
  p->type = NULL;
  p->lineno = lineno;
  p->kind = stringconstK;
  p->val.stringconstE = value;
  p->next = NULL;
  return p;
}


struct EXP *makeEXPuminus(struct EXP *exp)
{
  EXP *p = NEW(EXP);
  p->type = NULL;
  p->lineno = lineno;
  p->kind = uminusK;
  p->val.uminusE = exp;
  p->next = NULL;
  return p;
}


struct EXP *makeEXPnot(struct EXP *exp)
{
  EXP *p = NEW(EXP);
  p->type = NULL;
  p->lineno = lineno;
  p->kind = notK;
  p->val.notE.exp = exp;
  p->next = NULL;
  return p;
}



struct EXP *makeEXPlvalue(struct LVALUE *lvalue)
{
  EXP *p = NEW(EXP);
  p->type = NULL;
  p->lineno = lineno;
  p->kind = lvalueK;
  p->val.lvalueE = lvalue;
  p->next = NULL;
  return p;
}

struct EXP *makeEXPassignment(struct LVALUE *lvalue, struct EXP *right)
{
  EXP *p = NEW(EXP);
  p->type = NULL;
  p->lineno = lineno;
  p->kind = assignmentK;
  p->val.assignmentE.left = lvalue;
  p->val.assignmentE.right = right;
  p->next = NULL;
  return p;
}

struct EXP *makeEXPequals(struct EXP *left, struct EXP *right)
{
  EXP *p = NEW(EXP);
  p->type = NULL;
  p->lineno = lineno;
  p->kind = equalsK;
  p->val.equalsE.left = left;
  p->val.equalsE.right = right;
  p->next = NULL;
  return p;
}

struct EXP *makeEXPnequals(struct EXP *left,struct  EXP *right)
{
  EXP *p = NEW(EXP);
  p->type = NULL;
  p->lineno = lineno;
  p->kind = nequalsK;
  p->val.nequalsE.left = left;
  p->val.nequalsE.right = right;
  p->next = NULL;
  return p;
}

struct EXP *makeEXPless(struct EXP *left,struct  EXP *right)
{
  EXP *p = NEW(EXP);
  p->type = NULL;
  p->lineno = lineno;
  p->kind = lessK;
  p->val.lessE.left = left;
  p->val.lessE.right = right;
  p->next = NULL;
  return p;
}

struct EXP *makeEXPgreater(struct EXP *left, struct EXP *right)
{
  EXP *p = NEW(EXP);
  p->type = NULL;
  p->lineno = lineno;
  p->kind = greaterK;
  p->val.greaterE.left = left;
  p->val.greaterE.right = right;
  p->next = NULL;
  return p;
}

struct EXP *makeEXPlequals(struct EXP *left, struct EXP *right)
{
  EXP *p = NEW(EXP);
  p->type = NULL;
  p->lineno = lineno;
  p->kind = lequalsK;
  p->val.lequalsE.left = left;
  p->val.lequalsE.right = right;
  p->next = NULL;
  return p;
}

struct EXP *makeEXPgequals(struct EXP *left, struct EXP *right)
{
  EXP *p = NEW(EXP);
  p->type = NULL;
  p->lineno = lineno;
  p->kind = gequalsK;
  p->val.gequalsE.left = left;
  p->val.gequalsE.right = right;
  p->next = NULL;
  return p;
}

struct EXP *makeEXPplus(struct EXP *left, struct EXP *right)
{
  EXP *p = NEW(EXP);
  p->type = NULL;
  p->lineno = lineno;
  p->kind = plusK;
  p->val.plusE.left = left;
  p->val.plusE.right = right;
  p->next = NULL;
  return p;
}

struct EXP *makeEXPminus(struct EXP *left,struct  EXP *right)
{
  EXP *p = NEW(EXP);
  p->type = NULL;
  p->lineno = lineno;
  p->kind = minusK;
  p->val.minusE.left = left;
  p->val.minusE.right = right;
  p->next = NULL;
  return p;
}

struct EXP *makeEXPmult(struct EXP *left, struct EXP *right)
{
  EXP *p = NEW(EXP);
  p->type = NULL;
  p->lineno = lineno;
  p->kind = multK;
  p->val.multE.left = left;
  p->val.multE.right = right;
  p->next = NULL;\
  return p;
}

struct EXP *makeEXPdiv(struct EXP *left,struct  EXP *right)
{
  EXP *p = NEW(EXP);
  p->type = NULL;
  p->lineno = lineno;
  p->kind = divK;
  p->val.divE.left = left;
  p->val.divE.right = right;
  p->next = NULL;
  return p;
}

struct EXP *makeEXPmodulo(struct EXP *left,struct  EXP *right)
{
  EXP *p = NEW(EXP);
  p->type = NULL;
  p->lineno = lineno;
  p->kind = moduloK;
  p->val.moduloE.left = left;
  p->val.moduloE.right = right;
  p->next = NULL;
  return p;
}

struct EXP *makeEXPand(struct EXP *left,struct  EXP *right)
{
  EXP *p = NEW(EXP);
  p->type = NULL;
  p->lineno = lineno;
  p->kind = andK;
  p->val.andE.left = left;
  p->val.andE.right = right;
  p->next = NULL;
  return p;
}

struct EXP *makeEXPor(struct EXP *left,struct  EXP *right)
{
  EXP *p = NEW(EXP);
  p->type = NULL;
  p->lineno = lineno;
  p->kind = orK;
  p->val.orE.left = left;
  p->val.orE.right = right;
  p->next = NULL;
  return p;
}


struct EXP *makeEXPcall(char *name,struct  EXP *arguments)
{
  EXP *p = NEW(EXP);
  p->type = NULL;
  p->lineno = lineno;
  p->kind = callK;
  p->val.callE.name = name;
  p->val.callE.arguments = arguments;
  p->next = NULL;
  return p;
}


struct EXP *makeEXPcast(struct TYPE *type,struct  EXP *exp)
{
  EXP *p = NEW(EXP);
  p->type = NULL;
  p->lineno = lineno;
  p->kind = castK;
  p->val.castE.type = type;
  p->val.castE.exp = exp;
  p->next = NULL;
  return p;
}


struct LVALUE *makeLVALUEid(char *id)
{
  LVALUE *p = NEW(LVALUE);
  p->lineno = lineno;
  p->kind = idK;
  p->val.idL = id;
  return p;
}




/* ********* CODE ******************* */

CODE *makeCODEnop(CODE *next)
{ CODE *c;
  c = NEW(CODE);
  c->kind = nopCK;
  c->visited = 0;
  c->next = next;
  return c;
}

 
CODE *makeCODEimul(CODE *next)
{ CODE *c;
  c = NEW(CODE);
  c->kind = imulCK;
  c->visited = 0;
  c->next = next;
  return c;
}
 
CODE *makeCODEineg(CODE *next)
{ CODE *c;
  c = NEW(CODE);
  c->kind = inegCK;
  c->visited = 0;
  c->next = next;
  return c;
}
 
CODE *makeCODEirem(CODE *next)
{ CODE *c;
  c = NEW(CODE);
  c->kind = iremCK;
  c->visited = 0;
  c->next = next;
  return c;
}
 
CODE *makeCODEisub(CODE *next)
{ CODE *c;
  c = NEW(CODE);
  c->kind = isubCK;
  c->visited = 0;
  c->next = next;
  return c;
}

CODE *makeCODEidiv(CODE *next)
{ CODE *c;
  c = NEW(CODE);
  c->kind = idivCK;
  c->visited = 0;
  c->next = next;
  return c;
}
 
CODE *makeCODEiadd(CODE *next)
{ CODE *c;
  c = NEW(CODE);
  c->kind = iaddCK;
  c->visited = 0;
  c->next = next;
  return c;
}


CODE *makeCODEaadd(CODE *next)
{ CODE *c;
  c = NEW(CODE);
  c->kind = aaddCK;
  c->visited = 0;
  c->next = next;
  return c;
}


CODE *makeCODElabel(int label, CODE *next)
{ CODE *c;
  c = NEW(CODE);
  c->kind = labelCK;
  c->visited = 0;
  c->val.labelC = label;
  c->next = next;
  return c;
}
 
CODE *makeCODEgoto(int label, CODE *next)
{ CODE *c;
  c = NEW(CODE);
  c->kind = gotoCK;
  c->visited = 0;
  c->val.gotoC = label;
  c->next = next;
  return c;
}
 
CODE *makeCODEifeq(int label, CODE *next)
{ CODE *c;
  c = NEW(CODE);
  c->kind = ifeqCK;
  c->visited = 0;
  c->val.ifeqC = label;
  c->next = next;
  return c;
}
 
CODE *makeCODEifne(int label, CODE *next)
{ CODE *c;
  c = NEW(CODE);
  c->kind = ifneCK;
  c->visited = 0;
  c->val.ifneC = label;
  c->next = next;
  return c;
}
 
CODE *makeCODEif_acmpeq(int label, CODE *next)
{ CODE *c;
  c = NEW(CODE);
  c->kind = if_acmpeqCK;
  c->visited = 0;
  c->val.if_acmpeqC = label;
  c->next = next;
  return c;
}
 
CODE *makeCODEif_acmpne(int label, CODE *next)
{ CODE *c;
  c = NEW(CODE);
  c->kind = if_acmpneCK;
  c->visited = 0;
  c->val.if_acmpneC = label;
  c->next = next;
  return c;
}

 
CODE *makeCODEif_icmpeq(int label, CODE *next)
{ CODE *c;
  c = NEW(CODE);
  c->kind = if_icmpeqCK;
  c->visited = 0;
  c->val.if_icmpeqC = label;
  c->next = next;
  return c;
}
 
CODE *makeCODEif_icmpgt(int label, CODE *next)
{ CODE *c;
  c = NEW(CODE);
  c->kind = if_icmpgtCK;
  c->visited = 0;
  c->val.if_icmpgtC = label;
  c->next = next;
  return c;
}
 
CODE *makeCODEif_icmplt(int label, CODE *next)
{ CODE *c;
  c = NEW(CODE);
  c->kind = if_icmpltCK;
  c->visited = 0;
  c->val.if_icmpltC = label;
  c->next = next;
  return c;
}
 
CODE *makeCODEif_icmple(int label, CODE *next)
{ CODE *c;
  c = NEW(CODE);
  c->kind = if_icmpleCK;
  c->visited = 0;
  c->val.if_icmpleC = label;
  c->next = next;
  return c;
}
 
CODE *makeCODEif_icmpge(int label, CODE *next)
{ CODE *c;
  c = NEW(CODE);
  c->kind = if_icmpgeCK;
  c->visited = 0;
  c->val.if_icmpgeC = label;
  c->next = next;
  return c;
}
 
CODE *makeCODEif_icmpne(int label, CODE *next)
{ CODE *c;
  c = NEW(CODE);
  c->kind = if_icmpneCK;
  c->visited = 0;
  c->val.if_icmpneC = label;
  c->next = next;
  return c;
}
 
CODE *makeCODEireturn(CODE *next)
{ CODE *c;
  c = NEW(CODE);
  c->kind = ireturnCK;
  c->visited = 0;
  c->next = next;
  return c;
}
 
CODE *makeCODEareturn(CODE *next)
{ CODE *c;
  c = NEW(CODE);
  c->kind = areturnCK;
  c->visited = 0;
  c->next = next;
  return c;
}
 
CODE *makeCODEreturn(CODE *next)
{ CODE *c;
  c = NEW(CODE);
  c->kind = returnCK;
  c->visited = 0;
  c->next = next;
  return c;
}
 
CODE *makeCODEaload(int arg, CODE *next)
{ CODE *c;
  c = NEW(CODE);
  c->kind = aloadCK;
  c->visited = 0;
  c->val.aloadC = arg;
  c->next = next;
  return c;
}

CODE *makeCODEastore(int arg, CODE *next)
{ CODE *c;
  c = NEW(CODE);
  c->kind = astoreCK;
  c->visited = 0;
  c->val.astoreC = arg;
  c->next = next;
  return c;
}
 
CODE *makeCODEiload(int arg, CODE *next)
{ CODE *c;
  c = NEW(CODE);
  c->kind = iloadCK;
  c->visited = 0;
  c->val.iloadC = arg;
  c->next = next;
  return c;
}
 
CODE *makeCODEistore(int arg, CODE *next)
{ CODE *c;
  c = NEW(CODE);
  c->kind = istoreCK;
  c->visited = 0;
  c->val.istoreC = arg;
  c->next = next;
  return c;
}
 
 
CODE *makeCODEdup(CODE *next)
{ CODE *c;
  c = NEW(CODE);
  c->kind = dupCK;
  c->visited = 0;
  c->next = next;
  return c;
}
 
CODE *makeCODEpop(CODE *next)
{ CODE *c;
  c = NEW(CODE);
  c->kind = popCK;
  c->visited = 0;
  c->next = next;
  return c;
}

 
CODE *makeCODEldc_int(int arg, CODE *next)
{ CODE *c;
  c = NEW(CODE); 
  c->kind = ldc_intCK; 
  c->visited = 0;
  c->val.ldc_intC = arg; 
  c->next = next;
  return c;
}
 
 
CODE *makeCODEldc_string(char *arg, CODE *next)
{ CODE *c;
  c = NEW(CODE);
  c->kind = ldc_stringCK;
  c->visited = 0;
  c->val.ldc_stringC = arg;
  c->next = next;
  return c;
}
 
 
CODE *makeCODEcall(char *arg, char* signature, CODE *next)
{ CODE *c;
  c = NEW(CODE);
  c->kind = callCK;
  c->visited = 0;
  c->val.callVals.callC = arg;
  c->val.callVals.callSignatureC = signature;
  c->next = next;
  return c;
}



CODE *makeCODEsetint(EntityKind kind, CODE *next)
{ CODE *c;
  c = NEW(CODE);
  
  switch(kind) {
    case mdlEntity:
      c->kind = setint_mdlCK;
      break;
    case particleEntity:
      c->kind = setint_particleCK;
      break;
    case playerEntity:
      c->kind = setint_plyCK;
      break;     
    case lightEntity:
      c->kind = setint_lightCK;
      break;     
    case cameraEntity:
      c->kind = setint_camCK;
      break;     
  }
    
  c->visited = 0;
  c->next = next;
  return c;
}



CODE *makeCODEsleep(CODE *next) 
{ CODE *c;
  c = NEW(CODE);
  c->kind = sleepCK;
  c->visited = 0;
  c->next = next;
  return c;
}

CODE *makeCODEsleepUntilTriggered(CODE *next) 
{ CODE *c;
  c = NEW(CODE);
  c->kind = sleep_trigCK;
  c->visited = 0;
  c->next = next;
  return c;
}



CODE *makeCODEcast(TYPE *source, TYPE *dest, CODE *next) {
	
 CODE *c;
 c = NEW(CODE);
 
 if (source->kind == intK && dest->kind == stringK)
   c->kind = cast_inttostringCK; 
 
 if (source->kind == stringK && dest->kind == intK)
   c->kind = cast_stringtointCK; 
   
 if (source->kind == boolK && dest->kind == stringK)
   c->kind = cast_booltostringCK;   
  
  c->visited = 0;
  c->next = next;
  return c;	
}

